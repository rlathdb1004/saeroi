package kr.or.saeroi.controller;

import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dao.WorkerDAO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.ProductionService;

// =========================================================
// 작업자 컨트롤러
// 작업자 메인 / 작업지시 조회 / 생산실적 조회 처리
// =========================================================
@Controller
public class WorkerController {

	@Autowired
	private ProductionService productionService;

	@Autowired
	private WorkerDAO workerDAO;

	@RequestMapping("/worker/main")
	public String workerMain(
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		model.addAttribute("workerName", loginUser.getEname());
		model.addAttribute("workerDept", loginUser.getDept());

		// =============================================================
		// 오늘 작업 현황 조회
		// 팀원이 만든 작업지시 Controller / Mapper는 건드리지 않고,
		// 작업자 전용 DAO로 로그인한 작업자의 작업지시만 가져온 뒤
		// 오늘 날짜 기준으로 화면에 보여줄 건수와 진행률을 계산한다.
		// =============================================================
		String empno = "";

		if (loginUser.getEmpno() != null) {

			empno =
				loginUser.getEmpno().trim();
		}

		String ename = "";

		if (loginUser.getEname() != null) {

			ename =
				loginUser.getEname().trim();
		}

		List<ProductionDTO> myWorkOrderList =
			workerDAO.selectMyWorkOrderList(
				empno,
				ename);

		if (myWorkOrderList == null) {

			myWorkOrderList =
				new ArrayList<ProductionDTO>();
		}

		int todayWorkOrderCount = 0;
		int todayCompleteCount = 0;
		int todayProgressCount = 0;

		for (ProductionDTO workOrder : myWorkOrderList) {

			if (workOrder == null
					|| !isToday(workOrder.getOrderDate())) {

				continue;
			}

			todayWorkOrderCount++;

			if (isCompleteStatus(workOrder.getProdStatus())) {

				todayCompleteCount++;

			} else {

				todayProgressCount++;
			}
		}

		int todayProgressRate = 0;

		if (todayWorkOrderCount > 0) {

			todayProgressRate =
				(todayCompleteCount * 100) / todayWorkOrderCount;
		}

		String todayProgressText = "대기";

		if (todayWorkOrderCount > 0
				&& todayCompleteCount == todayWorkOrderCount) {

			todayProgressText = "완료";

		} else if (todayProgressCount > 0) {

			todayProgressText = "진행 중";
		}

		model.addAttribute(
			"workerTodayWorkOrderCount",
			todayWorkOrderCount);

		model.addAttribute(
			"workerTodayProgressRate",
			todayProgressRate);

		model.addAttribute(
			"workerTodayProgressText",
			todayProgressText);

		// =============================================================
		// 최근 알림은 현재 별도 알림 테이블을 건드리지 않는다.
		// 기존 화면의 알림 건수 표시는 유지하고, 클릭 시 공지사항으로 이동하게 한다.
		// =============================================================
		model.addAttribute(
			"workerRecentAlertCount",
			2);


		// =============================================================
		// 작업자 메인 실제 작업지시 QR 조회
		// -------------------------------------------------------------
		// 팀원 작업지시 파일은 수정하지 않는다.
		// 작업자 전용 DAO에서 로그인한 작업자의 오늘 작업지시 1건만 조회하고,
		// workerMain.jsp에서는 기존 팀원 QR 생성 URL을 그대로 사용한다.
		//
		// QR 이미지:
		// /production/workorder/qr?orderId=작업지시번호
		//
		// QR 클릭 / 테스트 버튼 이동:
		// WORK_ORDER.QR_URL이 있으면 그 값을 사용하고,
		// 없으면 생산실적 등록 화면으로 이동한다.
		// =============================================================
		ProductionDTO workerQrWorkOrder =
			workerDAO.selectTodayQrWorkOrder(
				empno,
				ename);

		int workerQrOrderId = 0;
		String workerQrMoveUrl =
			"/worker/workorder?todayOnly=Y";

		if (workerQrWorkOrder != null
				&& workerQrWorkOrder.getOrderId() != null) {

			workerQrOrderId =
				workerQrWorkOrder.getOrderId().intValue();

			if (workerQrWorkOrder.getQrUrl() != null
					&& !workerQrWorkOrder.getQrUrl().trim().equals("")) {

				workerQrMoveUrl =
					workerQrWorkOrder.getQrUrl().trim();

			} else {

				workerQrMoveUrl =
					"/production/productionresult?orderId="
					+ workerQrOrderId
					+ "&openModal=Y";
			}
		}

		model.addAttribute(
			"workerQrWorkOrder",
			workerQrWorkOrder);

		model.addAttribute(
			"workerQrOrderId",
			workerQrOrderId);

		model.addAttribute(
			"workerQrMoveUrl",
			workerQrMoveUrl);


		return "worker/workerMain";
	}

	@RequestMapping("/worker/workorder")
	public String workerWorkOrder(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			@RequestParam(value = "todayOnly", defaultValue = "") String todayOnly,
			@RequestParam(value = "status", defaultValue = "") String status,
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		// =============================================================
		// 작업자 작업지시 관리 화면 버튼 숨김 처리
		// -------------------------------------------------------------
		// 팀원 작업지시 JSP는 수정하지 않는다.
		// 작업자 전용 URL로 들어온 경우에만 세션 role을 WORKER로 바꿔서
		// 등록 / 선택삭제 / 검색결과 인쇄 버튼이 화면에 보이지 않게 한다.
		// =============================================================
		applyWorkerViewRole(
			session,
			loginUser);

		String empno = "";

		if (loginUser.getEmpno() != null) {

			empno =
				loginUser.getEmpno().trim();
		}

		String ename = "";

		if (loginUser.getEname() != null) {

			ename =
				loginUser.getEname().trim();
		}

		List<ProductionDTO> myAllList =
			workerDAO.selectMyWorkOrderList(
				empno,
				ename);

		if (myAllList == null) {

			myAllList =
				new ArrayList<ProductionDTO>();
		}

		// =============================================================
		// 작업자 메인에서 오늘 작업지시 / 진행상태를 눌렀을 때
		// 팀원 작업지시 코드는 건드리지 않고 이 Controller에서만
		// 로그인 작업자 + 오늘 날짜 + 진행중 조건으로 목록을 좁힌다.
		// =============================================================
		if ("Y".equals(todayOnly)
				|| "progress".equals(status)) {

			List<ProductionDTO> filteredList =
				new ArrayList<ProductionDTO>();

			for (ProductionDTO workOrder : myAllList) {

				if (workOrder == null
						|| !isToday(workOrder.getOrderDate())) {

					continue;
				}

				if ("progress".equals(status)
						&& isCompleteStatus(workOrder.getProdStatus())) {

					continue;
				}

				filteredList.add(workOrder);
			}

			myAllList =
				filteredList;
		}

		int totalCount =
			myAllList.size();

		PageDTO pageInfo =
			new PageDTO(page, size, totalCount);

		int startIndex =
			(page - 1) * size;

		int endIndex =
			page * size;

		if (startIndex < 0) {

			startIndex = 0;
		}

		if (endIndex > totalCount) {

			endIndex = totalCount;
		}

		List<ProductionDTO> list =
			new ArrayList<ProductionDTO>();

		if (startIndex <= endIndex
				&& startIndex < totalCount) {

			list =
				myAllList.subList(startIndex, endIndex);
		}

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		// =============================================================
		// 공통 paging.jsp는 pageUrl을 기준으로 페이지를 만든다.
		// 오늘 작업지시 / 진행상태에서 들어온 경우도 필터가 유지되도록
		// pageUrl에 현재 조건을 같이 넘긴다.
		// =============================================================
		String pageUrl = "/worker/workorder";

		if ("Y".equals(todayOnly)
				&& "progress".equals(status)) {

			pageUrl =
				"/worker/workorder?todayOnly=Y&status=progress";

		} else if ("Y".equals(todayOnly)) {

			pageUrl =
				"/worker/workorder?todayOnly=Y";
		}

		model.addAttribute("pageUrl", pageUrl);

		model.addAttribute("prodStatus", status);
		model.addAttribute("keyword", "");
		model.addAttribute("startDate", "");
		model.addAttribute("endDate", "");

		model.addAttribute("workOrderStatusList",
			productionService.selectWorkOrderStatusList());

		model.addAttribute("workOrderPlanList",
			productionService.selectWorkOrderPlanList());

		model.addAttribute("lineList",
			productionService.selectLineList());

		model.addAttribute("empList",
			productionService.selectWorkOrderEmpList());

		model.addAttribute("workerName", loginUser.getEname());
		model.addAttribute("workerDept", loginUser.getDept());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "작업지시 관리");

		// =============================================================
		// 작업자 전용 읽기모드 표시
		// -------------------------------------------------------------
		// 작업자 전용 JSP에서 등록 / 삭제 / 인쇄 기능을 사용하지 않기 위한 표시값이다.
		// 팀원 production/workorder.jsp는 수정하지 않는다.
		// =============================================================
		model.addAttribute("workerReadonlyMode", "Y");

		return "worker/workerWorkOrder.tiles";
	}

	// =====================================================
	// 생산실적 조회
	// 로그인한 작업자 본인 생산실적만 조회
	// 기존 팀원 productionresult.jsp + tiles 사용
	// CSS / 사이드바 / 헤더 유지
	// 작업지시 조회처럼 5개씩 페이징 처리
	// =====================================================
	@RequestMapping("/worker/productionresult")
	public String workerProductionResult(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		// =============================================================
		// 작업자 생산실적 등록 화면 버튼 숨김 처리
		// -------------------------------------------------------------
		// 팀원 생산실적 JSP는 수정하지 않는다.
		// 작업자 전용 URL로 들어온 경우에만 세션 role을 WORKER로 바꿔서
		// 등록 / 선택삭제 / 검색결과 인쇄 버튼이 화면에 보이지 않게 한다.
		// =============================================================
		applyWorkerViewRole(
			session,
			loginUser);

		String empno = "";

		if (loginUser.getEmpno() != null) {

			empno =
				loginUser.getEmpno().trim();
		}

		String ename = "";

		if (loginUser.getEname() != null) {

			ename =
				loginUser.getEname().trim();
		}

		// =================================================
		// 로그인한 작업자 기준 생산실적 전체 조회
		// =================================================
		List<ProductionDTO> myAllList =
			workerDAO.selectMyProductionResultList(
				empno,
				ename);

		if (myAllList == null) {

			myAllList =
				new ArrayList<ProductionDTO>();
		}

		// =================================================
		// 생산실적도 작업지시처럼 5개씩 보이도록 페이징 처리
		// =================================================
		int totalCount =
			myAllList.size();

		PageDTO pageInfo =
			new PageDTO(page, size, totalCount);

		int startIndex =
			(page - 1) * size;

		int endIndex =
			page * size;

		if (startIndex < 0) {

			startIndex = 0;
		}

		if (endIndex > totalCount) {

			endIndex = totalCount;
		}

		List<ProductionDTO> list =
			new ArrayList<ProductionDTO>();

		if (startIndex <= endIndex
				&& startIndex < totalCount) {

			list =
				myAllList.subList(startIndex, endIndex);
		}

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/worker/productionresult");

		model.addAttribute("workerName", loginUser.getEname());
		model.addAttribute("workerDept", loginUser.getDept());

		// =================================================
		// 공통 header.jsp 제목
		// =================================================
		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산실적 등록");

		// =============================================================
		// 작업자 전용 읽기모드 표시
		// -------------------------------------------------------------
		// 작업자 전용 JSP에서 등록 / 삭제 / 인쇄 기능을 사용하지 않기 위한 표시값이다.
		// 팀원 production/productionresult.jsp는 수정하지 않는다.
		// =============================================================
		model.addAttribute("workerReadonlyMode", "Y");

		// =================================================
		// 중요
		// worker/workerProductionResult 사용
		// 작업자 전용 tiles 화면으로 이동해서 버튼을 숨김
		// =================================================
		return "worker/workerProductionResult.tiles";
	}

	// =====================================================
	// 작업자 화면 표시용 권한 보정
	// -----------------------------------------------------
	// 팀원 production/workorder.jsp, production/productionresult.jsp는
	// sessionScope.loginUser.role 값을 기준으로 등록 / 삭제 / 인쇄 버튼을 보여준다.
	//
	// 관리자나 매니저가 일반 생산관리 메뉴로 들어갈 때는 기존 권한을 그대로 사용해야 하므로
	// 팀원 Controller와 JSP는 건드리지 않는다.
	//
	// 대신 작업자 전용 URL인
	// /worker/workorder
	// /worker/productionresult
	// 로 들어온 경우에만 현재 세션의 role을 WORKER로 바꿔서
	// 작업자 화면에서는 등록 / 선택삭제 / 인쇄 버튼이 보이지 않게 한다.
	// =====================================================
	private void applyWorkerViewRole(
			HttpSession session,
			LoginDTO loginUser) {

		if (session == null
				|| loginUser == null) {

			return;
		}

		// =================================================
		// 원래 권한은 참고용으로만 보관한다.
		// 추후 필요 시 로그아웃 전까지 확인할 수 있게 세션에 남겨둔다.
		// =================================================
		if (session.getAttribute("originWorkerRole") == null) {

			session.setAttribute(
				"originWorkerRole",
				loginUser.getRole());
		}

		// =================================================
		// Lombok @Data LoginDTO라서 setRole 사용 가능
		// 작업자 전용 화면에서는 버튼 권한을 WORKER 기준으로 보이게 한다.
		// =================================================
		loginUser.setRole("WORKER");

		session.setAttribute(
			"loginUser",
			loginUser);
	}

	// =====================================================
	// 오늘 날짜 여부 확인
	// WORK_ORDER.ORDER_DATE는 yyyy-MM-dd 문자열로 DTO에 들어오므로
	// 오늘 날짜 문자열과 비교한다.
	// =====================================================
	private boolean isToday(
			String dateText) {

		if (dateText == null
				|| dateText.trim().equals("")) {

			return false;
		}

		String today =
			new SimpleDateFormat("yyyy-MM-dd")
				.format(new java.util.Date());

		return today.equals(dateText.trim());
	}

	// =====================================================
	// 완료 상태 여부 확인
	// 상태명은 팀원 작업지시/생산실적 코드에서 넘어오는 값을 그대로 사용하되,
	// '완료'가 들어가면 완료 처리하고 나머지는 진행 대상으로 본다.
	// =====================================================
	private boolean isCompleteStatus(
			String status) {

		if (status == null) {

			return false;
		}

		return status.indexOf("완료") >= 0;
	}

	// =====================================================
	// 작업자 자재 입출고 목록
	// 작업자 권한으로 접근해도 관리자와 같은 자재 입출고 화면을 사용하게 리다이렉트한다.
	// 사이드바 / 공통 JSP는 건드리지 않고 Controller 경로만 맞춘다.
	// =====================================================
	@RequestMapping("/worker/materialIn")
	public String workerMaterialIn() {

		return "redirect:/inventory/materialIn";
	}

	// =====================================================
	// 작업자 자재 입출고 상세
	// 작업자로 상세페이지에 들어가도 기존 상세 JSP가 아니라
	// 수정된 inventory/inoutDetail.tiles 화면을 그대로 타도록 리다이렉트한다.
	// =====================================================
	@RequestMapping("/worker/materialIn/detail")
	public String workerMaterialInDetail(
			@RequestParam("inoutId") int inoutId,
			@RequestParam(
				value = "mode",
				defaultValue = "view")
			String mode) {

		return "redirect:/inventory/materialIn/detail?inoutId="
				+ inoutId
				+ "&mode="
				+ mode;
	}

	@RequestMapping("/worker/notice")
	public String workerNotice(
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		return "redirect:/board/notice";
	}

	@RequestMapping("/notice/list")
	public String noticeListRedirect() {

		return "redirect:/board/notice";
	}
}