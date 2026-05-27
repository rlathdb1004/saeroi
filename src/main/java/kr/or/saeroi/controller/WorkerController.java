package kr.or.saeroi.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.ProductionService;

// =========================================================
// 작업자 컨트롤러
// =========================================================
@Controller
public class WorkerController {

	// =====================================================
	// 생산관리 Service
	// =====================================================
	@Autowired
	private ProductionService productionService;

	// =====================================================
	// 작업자 메인 페이지
	// =====================================================
	@RequestMapping("/worker/main")
	public String workerMain(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 세션 확인
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 페이지 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 작업자 정보 전달
		// =================================================
		model.addAttribute(
			"workerName",
			loginUser.getEname());

		model.addAttribute(
			"workerDept",
			loginUser.getDept());

		// =================================================
		// 작업자 메인 페이지 이동
		// =================================================
		return "worker/workerMain";
	}

	// =====================================================
	// 작업지시 조회
	// 로그인한 작업자 본인 데이터만 출력
	// =====================================================
	@RequestMapping("/worker/workorder")
	public String workerWorkOrder(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 세션 확인
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 전체 작업지시 조회
		// =================================================
		List<ProductionDTO> allList =
			productionService.selectWorkOrderList(
				new ProductionDTO());

		// =================================================
		// 로그인 작업자 데이터만 저장할 리스트
		// =================================================
		List<ProductionDTO> myWorkList =
			new ArrayList<>();

		// =================================================
		// 로그인 사용자 이름
		// =================================================
		String myName = "";

		if (loginUser.getEname() != null) {

			myName =
				loginUser.getEname().trim();
		}

		// =================================================
		// 로그인한 작업자 데이터만 필터링
		// =================================================
		if (allList != null) {

			for (ProductionDTO item : allList) {

				String itemEname = "";

				if (item.getEname() != null) {

					itemEname =
						item.getEname().trim();
				}

				// =========================================
				// 이름 비교
				// =========================================
				if (itemEname.equals(myName)) {

					myWorkList.add(item);
				}
			}
		}

		// =================================================
		// JSP 전달
		// =================================================
		model.addAttribute(
			"list",
			myWorkList);

		model.addAttribute(
			"workerName",
			loginUser.getEname());

		model.addAttribute(
			"workerDept",
			loginUser.getDept());

		// =================================================
		// 기존 작업지시 페이지 이동
		// =================================================
		return "production/workorder";
	}

	// =====================================================
	// 생산실적 페이지 이동
	// 기존 생산실적 Controller 로 redirect
	// =====================================================
	@RequestMapping("/worker/productionresult")
	public String workerProductionResult(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 세션 확인
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 기존 생산실적 Controller 로 이동
		// =================================================
		return "redirect:/production/productionresult";
	}

	// =====================================================
	// 공지사항 페이지 이동
	// 기존 공지사항 Controller 로 redirect
	// =====================================================
	@RequestMapping("/worker/notice")
	public String workerNotice(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 세션 확인
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 기존 공지사항 Controller 로 이동
		// =================================================
		return "redirect:/board/notice";
	}

	// =====================================================
	// 기존 notice/list 요청 처리
	// 팀원 JSP 호환용
	// =====================================================
	@RequestMapping("/notice/list")
	public String noticeListRedirect() {

		// =================================================
		// 실제 공지사항 Controller 로 이동
		// =================================================
		return "redirect:/board/notice";
	}

}