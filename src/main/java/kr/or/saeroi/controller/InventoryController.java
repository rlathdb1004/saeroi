package kr.or.saeroi.controller;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dao.InoutDAO;
import kr.or.saeroi.dao.InoutDAOImpl;
import kr.or.saeroi.dto.InoutDTO;
import kr.or.saeroi.dto.InventoryDTO;
import kr.or.saeroi.service.InoutService;
import kr.or.saeroi.service.InoutServiceImpl;
import kr.or.saeroi.service.InventoryService;
import kr.or.saeroi.service.InventoryServiceImpl;

// =========================================================================
// 자재 / 재고 Controller
// 자재입출고관리와 재고조회가 같이 들어있는 통합 컨트롤러
// =========================================================================
@Controller
public class InventoryController {

	// =========================================================================
	// 입출고 Service
	// 기존 목록 / 등록 / 수정 / 삭제 흐름은 그대로 사용한다.
	// =========================================================================
	private InoutService service =
		new InoutServiceImpl();

	// =========================================================================
	// 입출고 DAO
	// 등록모달 자동조회 AJAX 전용
	// Service 파일을 건드리지 않기 위해 추가 조회만 DAO를 직접 사용한다.
	// =========================================================================
	private InoutDAO inoutDAO =
		new InoutDAOImpl();

	// =========================================================================
	// 재고조회 Service
	// =========================================================================
	private InventoryService inventoryService =
		new InventoryServiceImpl();

	// =========================================================================
	// 자재입고관리 클릭 시 입출고관리 화면
	// 목록 화면은 기존처럼 필요한 컬럼만 보여주고
	// 상세페이지에서 전체 DB 컬럼을 보여준다.
	// =========================================================================
	@RequestMapping("/inventory/materialIn")
	public String materialIn(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			@RequestParam(value = "searchType", defaultValue = "all") String searchType,
			@RequestParam(value = "inoutType", defaultValue = "") String inoutType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			HttpSession session,
			Model model) {

		// =============================================================
		// 시작일 기본값 처리 변경
		// 등록 후 redirect:/inventory/materialIn 으로 돌아오면 startDate가 비어 있다.
		// 이때 오늘 날짜를 강제로 넣으면, 사용자가 과거 입출고일자로 등록한 데이터가
		// 목록에서 바로 안 보일 수 있다.
		// 그래서 최초 진입 / 등록 후 진입은 전체 조회가 되도록 startDate를 강제 세팅하지 않는다.
		// =============================================================
		// =============================================================
		// 종료일 방어코딩
		// 종료일이 시작일보다 이전이면 검색 조건이 꼬이므로 시작일로 맞춘다.
		// =============================================================
		if (endDate != null
				&& !endDate.trim().equals("")
				&& endDate.compareTo(startDate) < 0) {

			endDate = startDate;
		}

		List<InoutDTO> list =
			service.getInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);

		// =============================================================
		// 자재입출고 목록 최신 등록순 정렬
		// 등록 직후 화면 첫 번째 줄에 방금 등록한 데이터가 보여야 하므로
		// 입출고일자가 아니라 INOUT_ID DESC 기준으로 정렬한다.
		// 사용자가 입출고일자를 과거 날짜로 넣어도 신규 등록건이 위에 나온다.
		// =============================================================
		Collections.sort(
			list,
			new Comparator<InoutDTO>() {

				@Override
				public int compare(
						InoutDTO a,
						InoutDTO b) {

					return b.getInoutId() - a.getInoutId();
				}
			});

		int totalCount =
			list.size();

		int startIndex =
			(page - 1) * size;

		int endIndex =
			startIndex + size;

		// =============================================================
		// 페이지 범위 방어코딩
		// 검색 후 데이터가 없을 때 subList 오류 방지
		// =============================================================
		if (startIndex > totalCount) {
			startIndex = totalCount;
		}

		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		List<InoutDTO> page_list =
			list.subList(startIndex, endIndex);

		PageDTO pageInfo =
			new PageDTO(page, size, totalCount);

		// =============================================================
		// 등록 모달 품목 select 출력용
		// 품목 선택 시 거래처명 / 담당자 / 현재재고 자동 표시용 data도 포함
		// =============================================================
		List<InoutDTO> itemList =
			inoutDAO.selectItemList();

		model.addAttribute(
			"list",
			page_list);

		model.addAttribute(
			"itemList",
			itemList);

		model.addAttribute(
			"pageInfo",
			pageInfo);

		model.addAttribute(
			"pageUrl",
			"/inventory/materialIn");

		model.addAttribute(
			"searchType",
			searchType);

		model.addAttribute(
			"inoutType",
			inoutType);

		model.addAttribute(
			"keyword",
			keyword);

		model.addAttribute(
			"startDate",
			startDate);

		model.addAttribute(
			"endDate",
			endDate);

		// =============================================================
		// DB 저장용 EMP_ID
		// MATERIAL_INOUT.EMP_ID에는 숫자 PK가 들어가야 하므로 4 같은 값 사용
		// =============================================================
		model.addAttribute(
			"loginEmpId",
			getLoginEmpId(session));

		// =============================================================
		// 화면 표시용 EMPNO
		// 등록모달 사원번호 칸에는 E2026004 같은 사번을 보여준다.
		// =============================================================
		model.addAttribute(
			"loginEmpNo",
			getLoginEmpNo(session));

		// =============================================================
		// 화면 표시용 로그인 사용자 이름
		// 자재입출고 등록 모달의 담당자 칸은 품목 거래처 담당자가 아니라
		// 현재 로그인한 작업자/관리자 이름이 보이도록 한다.
		// DB 저장은 기존처럼 getLoginEmpId(session)로 EMP_ID를 저장한다.
		// =============================================================
		model.addAttribute(
			"loginEmpName",
			getLoginEmpName(session));

		return "inventory/inoutManage.tiles";
	}

	// =========================================================================
	// 입출고 등록
	// 사원번호는 로그인 사용자 기준으로 자동 저장한다.
	// 화면에는 EMPNO가 보여도 DB에는 EMP_ID가 저장된다.
	// =========================================================================
	@RequestMapping("/inventory/materialIn/insert")
	public String insertInout(
			@RequestParam("itemId") int itemId,
			@RequestParam("inoutType") String inoutType,
			@RequestParam(value = "materialLot", defaultValue = "") String materialLot,
			@RequestParam("inoutQty") int inoutQty,
			@RequestParam("inoutDate") String inoutDate,
			@RequestParam(value = "stockLocation", defaultValue = "") String stockLocation,
			@RequestParam(value = "remark", defaultValue = "") String remark,
			@RequestParam(value = "status", defaultValue = "완료") String status,
			@RequestParam(value = "useYn", defaultValue = "Y") String useYn,
			HttpSession session) {

		InoutDTO dto =
			new InoutDTO();

		// =============================================================
		// DB 저장용 사원 ID
		// 로그인 세션의 EMPNO로 EMP 테이블의 실제 EMP_ID를 조회해서 저장
		// FK_MIO_EMP 오류 방지
		// =============================================================
		dto.setEmpId(
			getLoginEmpId(session));

		dto.setItemId(itemId);
		dto.setInoutType(inoutType);

		// =============================================================
		// LOT번호 처리
		// 입고: 비어 있으면 서버에서 자동 생성
		// 출고: 화면 select에서 선택한 LOT 사용
		// =============================================================
		if ((materialLot == null
				|| materialLot.trim().equals(""))
				&& "MI".equals(inoutType)) {

			materialLot =
				createMaterialLot(
					inoutDate);
		}

		dto.setMaterialLot(materialLot);
		dto.setInoutQty(inoutQty);
		dto.setInoutDate(Date.valueOf(inoutDate));
		dto.setRemark(remark);
		dto.setStatus(status);
		dto.setUseYn(useYn);
		dto.setStockLocation(stockLocation);

		// =============================================================
		// 수기 자재 입출고는 작업지시번호 없이 저장
		// DAO에서 ORDER_ID는 NULL 처리
		// =============================================================
		dto.setOrderId(0);

		service.addInout(dto);

		return "redirect:/inventory/materialIn";
	}

	// =========================================================================
	// 선택 삭제
	// =========================================================================
	@RequestMapping("/inventory/materialIn/delete")
	public String deleteInout(
			@RequestParam(value = "inoutIds", required = false) String[] inoutIds) {

		if (inoutIds != null) {

			service.removeInout(inoutIds);
		}

		return "redirect:/inventory/materialIn";
	}

	// =========================================================================
	// 상세보기 페이지
	// =========================================================================
	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			@RequestParam(value = "mode", defaultValue = "view") String mode,
			Model model) {

		InoutDTO inout =
			inoutDAO.selectInoutDetail(
				inoutId);

		model.addAttribute(
			"inout",
			inout);

		model.addAttribute(
			"mode",
			mode);

		return "inventory/inoutDetail.tiles";
	}

	// =========================================================================
	// 입출고 수정
	// =========================================================================
	@RequestMapping("/inventory/materialIn/update")
	public String updateInout(
			@RequestParam("inoutId") int inoutId,
			@RequestParam("empId") int empId,
			@RequestParam("itemId") int itemId,
			@RequestParam("inoutType") String inoutType,
			@RequestParam("materialLot") String materialLot,
			@RequestParam("inoutQty") int inoutQty,
			@RequestParam("inoutDate") String inoutDate,
			@RequestParam(value = "remark", defaultValue = "") String remark,
			@RequestParam(value = "status", defaultValue = "완료") String status,
			@RequestParam(value = "orderId", defaultValue = "0") int orderId,
			@RequestParam(value = "docNo", defaultValue = "") String docNo,
			@RequestParam(value = "docSeq", defaultValue = "0") int docSeq,
			@RequestParam(value = "useYn", defaultValue = "Y") String useYn) {

		InoutDTO dto =
			new InoutDTO();

		dto.setInoutId(inoutId);
		dto.setEmpId(empId);
		dto.setItemId(itemId);
		dto.setInoutType(inoutType);
		dto.setMaterialLot(materialLot);
		dto.setInoutQty(inoutQty);
		dto.setInoutDate(Date.valueOf(inoutDate));
		dto.setRemark(remark);
		dto.setStatus(status);
		dto.setOrderId(orderId);
		dto.setDocNo(docNo);
		dto.setDocSeq(docSeq);
		dto.setUseYn(useYn);

		service.modifyInout(dto);

		return "redirect:/inventory/materialIn/detail?inoutId="
				+ inoutId;
	}

	// =========================================================================
	// 품목 선택 시 거래처명 / 담당자 / 현재재고 자동조회
	// =========================================================================
	@ResponseBody
	@RequestMapping(
		value = "/inventory/materialIn/itemInfo",
		produces = "application/json; charset=UTF-8")
	public String getMaterialInItemInfo(
			@RequestParam("itemId") int itemId,
			@RequestParam(value = "inoutType", defaultValue = "") String inoutType) {

		InoutDTO dto =
			inoutDAO.selectItemInfo(
				itemId,
				inoutType);

		if (dto == null) {

			dto =
				new InoutDTO();
		}

		String result = "";

		result += "{";
		result += "\"clientName\":\"" + json(dto.getClientName()) + "\",";
		result += "\"clientManager\":\"" + json(dto.getClientManager()) + "\",";
		result += "\"inventoryStock\":" + dto.getInventoryStock();
		result += "}";

		return result;
	}

	// =========================================================================
	// 품목 선택 시 창고위치 select 박스 자동조회
	// =========================================================================
	@ResponseBody
	@RequestMapping(
		value = "/inventory/materialIn/stockLocations",
		produces = "application/json; charset=UTF-8")
	public String getMaterialInStockLocations(
			@RequestParam("itemId") int itemId) {

		List<InoutDTO> list =
			inoutDAO.selectStockLocationList(
				itemId);

		String result = "[";

		for (int i = 0; i < list.size(); i++) {

			InoutDTO dto =
				list.get(i);

			if (i > 0) {

				result += ",";
			}

			result += "{";
			result += "\"stockLocation\":\"" + json(dto.getStockLocation()) + "\",";
			result += "\"inventoryStock\":" + dto.getInventoryStock();
			result += "}";
		}

		result += "]";

		return result;
	}

	// =========================================================================
	// 출고 선택 시 LOT번호 목록 자동조회
	// =========================================================================
	@ResponseBody
	@RequestMapping(
		value = "/inventory/materialIn/lotList",
		produces = "application/json; charset=UTF-8")
	public String getMaterialInLotList(
			@RequestParam("itemId") int itemId) {

		List<InoutDTO> list =
			inoutDAO.selectMaterialLotList(
				itemId);

		String result = "[";

		for (int i = 0; i < list.size(); i++) {

			InoutDTO dto =
				list.get(i);

			if (i > 0) {

				result += ",";
			}

			result += "{";
			result += "\"materialLot\":\"" + json(dto.getMaterialLot()) + "\",";
			result += "\"remainQty\":" + dto.getInoutQty();
			result += "}";
		}

		result += "]";

		return result;
	}

	// =========================================================================
	// 여기부터 재고조회 코드
	// =========================================================================
	@RequestMapping({
		"/inventory/inventoryStatus",
		"/inventory/stockList",
		"/inventory/inventoryList",
		"/inventory/stock",
		"/inventory/inventory"
	})
	public String inventoryList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			@RequestParam(value = "searchType", defaultValue = "") String searchType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			@RequestParam(value = "topInventoryId", defaultValue = "0") int topInventoryId,
			Model model) {

		// =============================================================
		// 시작일 기본값 처리 변경
		// 재고 등록 / 입출고 등록 후 기존 INVENTORY 행이 UPDATED_DATE만 갱신되는 경우가 있다.
		// 여기서 오늘 날짜를 CREATED_DATE 검색 조건으로 강제하면,
		// 기존 재고 행이 목록에서 안 보이는 문제가 생긴다.
		// 그래서 최초 진입 / 등록 후 진입은 전체 조회가 되도록 startDate를 강제 세팅하지 않는다.
		// =============================================================
		// =============================================================
		// 종료일 방어코딩
		// 종료일은 시작일보다 이전으로 검색되지 않게 한다.
		// =============================================================
		if (endDate != null
				&& !endDate.trim().equals("")
				&& endDate.compareTo(startDate) < 0) {

			endDate = startDate;
		}

		List<InventoryDTO> list =
			inventoryService.getInventoryList(
				searchType,
				keyword,
				startDate,
				endDate);

		// =============================================================
		// 재고조회 목록 생성일 최신순 정렬
		// 팀 피드백 반영: 재고조회관리 화면은 수정일이 아니라
		// 생성일 기준 최신 등록건이 위로 보이게 한다.
		// DAO에서도 CREATED_DATE DESC로 정렬하지만,
		// 공통 파일을 건드리지 않고 Controller에서 한 번 더 보정한다.
		// =============================================================
		Collections.sort(
			list,
			new Comparator<InventoryDTO>() {

				@Override
				public int compare(
						InventoryDTO a,
						InventoryDTO b) {

					if (a.getCreatedDate() != null
							&& b.getCreatedDate() != null
							&& !a.getCreatedDate().equals(b.getCreatedDate())) {

						return b.getCreatedDate().compareTo(a.getCreatedDate());
					}

					return b.getInventoryId() - a.getInventoryId();
				}
			});

		// =============================================================
		// 재고 등록 직후 첫 줄 고정 처리
		// 등록 메소드에서 방금 등록된 INVENTORY_ID를 topInventoryId로 넘긴다.
		// 날짜/시간 정렬이 꼬이거나 검색조건이 남아 있어도
		// 방금 등록한 재고가 1페이지 첫 번째 줄에 보이도록 한다.
		// 공통 페이징 파일은 건드리지 않고 현재 Controller에서만 처리한다.
		// =============================================================
		if (topInventoryId > 0) {

			InventoryDTO topInventory = null;

			for (int i = 0; i < list.size(); i++) {

				InventoryDTO inventory =
					list.get(i);

				if (inventory.getInventoryId() == topInventoryId) {

					topInventory = inventory;
					list.remove(i);
					break;
				}
			}

			// =========================================================
			// 혹시 날짜 검색조건 때문에 목록에 빠져 있으면
			// 상세조회로 다시 가져와서 맨 위에 추가한다.
			// =========================================================
			if (topInventory == null) {

				topInventory =
					inventoryService.getInventoryDetail(
						topInventoryId);
			}

			if (topInventory != null) {

				list.add(0, topInventory);
			}
		}

		int totalCount =
			list.size();

		int startIndex =
			(page - 1) * size;

		int endIndex =
			startIndex + size;

		if (startIndex > totalCount) {
			startIndex = totalCount;
		}

		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		List<InventoryDTO> page_list =
			list.subList(startIndex, endIndex);

		PageDTO pageInfo =
			new PageDTO(page, size, totalCount);

		List<InventoryDTO> itemList =
			inventoryService.getItemList();

		model.addAttribute("list", page_list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/stockList");
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		return "inventory/inventoryManage.tiles";
	}

	@RequestMapping("/inventory/stockList/insert")
	public String insertInventory(
			@RequestParam("itemId") int itemId,
			@RequestParam("inventoryStock") int inventoryStock,
			@RequestParam("stockLocation") String stockLocation,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InventoryDTO dto =
			new InventoryDTO();

		dto.setItemId(itemId);
		dto.setInventoryStock(inventoryStock);

		if (stockLocation == null) {
			stockLocation = "";
		}

		dto.setStockLocation(stockLocation);
		dto.setRemark(remark);

		// =============================================================
		// 재고 등록 후 방금 등록된 재고번호를 받아온다.
		// 이 번호를 목록 URL에 넘겨서 inventoryList()에서
		// 해당 재고를 강제로 1페이지 첫 줄에 올린다.
		// =============================================================
		int topInventoryId =
			inventoryService.addInventory(dto);

		return "redirect:/inventory/stockList?topInventoryId="
				+ topInventoryId;
	}

	@RequestMapping("/inventory/stockList/delete")
	public String deleteInventory(
			@RequestParam(value = "inventoryIds", required = false) String[] inventoryIds) {

		if (inventoryIds != null) {

			inventoryService.removeInventory(inventoryIds);
		}

		return "redirect:/inventory/stockList";
	}

	@RequestMapping("/inventory/stockList/detail")
	public String inventoryDetail(
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam(value = "mode", defaultValue = "view") String mode,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		return inventoryDetailView(
			inventoryId,
			mode,
			page,
			size,
			model);
	}

	// =========================================================================
	// 재고 상세 하단 내역서 페이징 전용 URL
	// 공통 paging.jsp는 pageUrl 뒤에 ?page=... 형식으로 붙는 구조이다.
	// 그래서 쿼리스트링이 들어간 /detail?inventoryId=14를 pageUrl로 쓰지 않고
	// /detail/14 형태의 별도 매핑을 만들어 공통 페이징을 그대로 사용한다.
	// =========================================================================
	@RequestMapping("/inventory/stockList/detail/{inventoryId}")
	public String inventoryDetailPaging(
			@PathVariable("inventoryId") int inventoryId,
			@RequestParam(value = "mode", defaultValue = "view") String mode,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		return inventoryDetailView(
			inventoryId,
			mode,
			page,
			size,
			model);
	}

	// =========================================================================
	// 재고 상세 공통 처리
	// 기본정보 + 재고 입출고 내역서 조회를 한 곳에서 처리한다.
	// 내역서는 기본 5개씩 보이고, 공통 몇개씩 보기 select와 공통 paging.jsp를 그대로 사용한다.
	// =========================================================================
	private String inventoryDetailView(
			int inventoryId,
			String mode,
			int page,
			int size,
			Model model) {

		if (page < 1) {
			page = 1;
		}

		if (size <= 0) {
			size = 5;
		}

		InventoryDTO inventory =
			inventoryService.getInventoryDetail(
				inventoryId);

		model.addAttribute(
			"inventory",
			inventory);

		List<InventoryDTO> historyList =
			inventoryService.getInventoryInoutHistoryList(
				inventoryId);

		// =============================================================
		// 재고 상세 입출고 내역서는 LOT 기준 흐름만 보여준다.
		// 품목코드/ITEM_ID 기준 전체 이력을 가져오면 60건 이상이 한꺼번에 보여
		// 관리가 복잡해지므로, DAO에서 최신 LOT 기준으로 입고/출고 흐름과
		// 누적잔량을 계산해서 가져온다.
		// 공통 paging.jsp는 inventoryDetail.jsp에서 사용하지 않는다.
		// =============================================================
		int totalCount =
			historyList.size();

		List<InventoryDTO> pageHistoryList =
			historyList;

		PageDTO pageInfo =
			new PageDTO(
				1,
				totalCount == 0 ? 1 : totalCount,
				totalCount);

		model.addAttribute(
			"inoutHistory",
			pageHistoryList);

		model.addAttribute(
			"pageInfo",
			pageInfo);

		// =============================================================
		// 공통 페이징 전용 URL
		// 쿼리스트링이 없는 URL을 넘겨야 2페이지, 3페이지 이동이 정상 동작한다.
		// =============================================================
		model.addAttribute(
			"pageUrl",
			"/inventory/stockList/detail/" + inventoryId);

		model.addAttribute(
			"mode",
			mode);

		return "inventory/inventoryDetail.tiles";
	}

	@RequestMapping("/inventory/stockList/update")
	public String updateInventory(
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam("inventoryStock") int inventoryStock,
			@RequestParam("stockLocation") String stockLocation,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InventoryDTO dto =
			new InventoryDTO();

		dto.setInventoryId(inventoryId);
		dto.setInventoryStock(inventoryStock);
		dto.setStockLocation(stockLocation);
		dto.setRemark(remark);

		inventoryService.modifyInventory(dto);

		return "redirect:/inventory/stockList/detail?inventoryId="
				+ inventoryId;
	}

	@ResponseBody
	@RequestMapping("/inventory/getStockLocation")
	public String getStockLocation(
			@RequestParam("itemId") int itemId) {

		String stockLocation =
			inventoryService.getStockLocationByItemId(
				itemId);

		if (stockLocation == null) {

			stockLocation = "";
		}

		return stockLocation;
	}

	// =========================================================================
	// 로그인 사용자 EMP_ID 조회
	// DB 저장용
	// EMPNO를 그대로 저장하면 FK 오류가 나므로 EMP 테이블에서 EMP_ID를 조회한다.
	// =========================================================================
	private int getLoginEmpId(
			HttpSession session) {

		if (session == null) {

			return 1;
		}

		Object loginUser =
			session.getAttribute("loginUser");

		if (loginUser == null) {

			loginUser =
				session.getAttribute("member");
		}

		if (loginUser == null) {

			return 1;
		}

		Integer empId =
			callIntGetter(
				loginUser,
				"getEmpId");

		if (empId != null
				&& empId.intValue() > 0) {

			return empId.intValue();
		}

		String empno =
			callStringGetter(
				loginUser,
				"getEmpno");

		if (empno == null
				|| empno.trim().equals("")) {

			return 1;
		}

		Integer foundEmpId =
			selectEmpIdByEmpno(
				empno.trim());

		if (foundEmpId != null
				&& foundEmpId.intValue() > 0) {

			return foundEmpId.intValue();
		}

		return 1;
	}

	// =========================================================================
	// 로그인 사용자 EMPNO 조회
	// 화면 표시용
	// 등록모달에는 E2026004 같은 사번을 보여준다.
	// =========================================================================
	private String getLoginEmpNo(
			HttpSession session) {

		if (session == null) {

			return "";
		}

		Object loginUser =
			session.getAttribute("loginUser");

		if (loginUser == null) {

			loginUser =
				session.getAttribute("member");
		}

		if (loginUser == null) {

			return "";
		}

		String empno =
			callStringGetter(
				loginUser,
				"getEmpno");

		if (empno == null) {

			return "";
		}

		return empno;
	}

	// =========================================================================
	// 로그인 사용자 이름 조회
	// 화면 표시용
	// 자재입출고 등록 모달 담당자 칸에 현재 로그인한 사람 이름을 보여준다.
	// 로그인 DTO는 팀원 파일이므로 수정하지 않고 getter만 사용한다.
	// =========================================================================
	private String getLoginEmpName(
			HttpSession session) {

		if (session == null) {

			return "";
		}

		Object loginUser =
			session.getAttribute("loginUser");

		if (loginUser == null) {

			loginUser =
				session.getAttribute("member");
		}

		if (loginUser == null) {

			return "";
		}

		String ename =
			callStringGetter(
				loginUser,
				"getEname");

		if (ename == null) {

			return "";
		}

		return ename;
	}

	// =========================================================================
	// EMPNO로 EMP_ID 조회
	// =========================================================================
	private Integer selectEmpIdByEmpno(
			String empno) {

		Integer empId =
			null;

		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");

			String url =
				"jdbc:oracle:thin:@//125.181.132.133:51521/xe";

			String id =
				"tofhdl";

			String pw =
				"rlatofhdl";

			Connection conn =
				DriverManager.getConnection(url, id, pw);

			String sql = "";

			sql += " SELECT ";
			sql += "     EMP_ID ";
			sql += " FROM EMP ";
			sql += " WHERE EMPNO = ? ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			pstmt.setString(
				1,
				empno);

			ResultSet rs =
				pstmt.executeQuery();

			if (rs.next()) {

				empId =
					Integer.valueOf(
						rs.getInt("EMP_ID"));
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return empId;
	}

	private Integer callIntGetter(
			Object target,
			String methodName) {

		try {

			Method method =
				target.getClass().getMethod(
					methodName);

			Object value =
				method.invoke(
					target);

			if (value == null) {

				return null;
			}

			if (value instanceof Number) {

				return Integer.valueOf(
					((Number) value).intValue());
			}

			return Integer.valueOf(
				String.valueOf(value));

		} catch (Exception e) {

			return null;
		}
	}

	private String callStringGetter(
			Object target,
			String methodName) {

		try {

			Method method =
				target.getClass().getMethod(
					methodName);

			Object value =
				method.invoke(
					target);

			if (value == null) {

				return null;
			}

			return String.valueOf(
				value);

		} catch (Exception e) {

			return null;
		}
	}

	// =========================================================================
	// 입고 LOT번호 자동 생성
	// =========================================================================
	private String createMaterialLot(
			String inoutDate) {

		String dateText = "";

		if (inoutDate != null
				&& !inoutDate.trim().equals("")) {

			dateText =
				inoutDate.replaceAll("-", "");
		}

		if (dateText == null
				|| dateText.equals("")) {

			dateText =
				new SimpleDateFormat("yyyyMMdd")
					.format(new java.util.Date());
		}

		int randomNo =
			(int) (System.currentTimeMillis() % 10000);

		return "RMLOT-"
				+ dateText
				+ "-"
				+ String.format("%04d", randomNo);
	}

	// =========================================================================
	// JSON 문자열 이스케이프
	// =========================================================================
	private String json(
			String value) {

		if (value == null) {

			return "";
		}

		return value
				.replace("\\", "\\\\")
				.replace("\"", "\\\"")
				.replace("\r", "")
				.replace("\n", "");
	}
}