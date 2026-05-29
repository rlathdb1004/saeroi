package kr.or.saeroi.controller;

import java.lang.reflect.Method;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

		List<InoutDTO> list =
			service.getInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);

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
		// 로그인한 사용자 사원번호
		// 등록모달에서 자동 표시하고 insert에서도 이 값을 사용한다.
		// =============================================================
		model.addAttribute(
			"loginEmpId",
			getLoginEmpId(session));

		return "inventory/inoutManage.tiles";
	}

	// =========================================================================
	// 입출고 등록
	// 사원번호는 로그인 사용자 기준으로 자동 저장한다.
	// 작업지시번호 / 문서번호 / 문서순번은 등록모달에서 제거한다.
	// 문서번호 / 문서순번은 DAO에서 자동 생성한다.
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
		// 로그인한 사용자 사원번호 자동 저장
		// =============================================================
		dto.setEmpId(
			getLoginEmpId(session));

		dto.setItemId(itemId);
		dto.setInoutType(inoutType);

		// =============================================================
		// LOT번호 처리
		// 입고: 화면에서 자동 생성된 값이 넘어오고, 비어 있으면 서버에서 한 번 더 생성
		// 출고: 화면 select 박스에서 선택한 기존 LOT가 넘어온다.
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

		// =============================================================
		// 창고위치
		// MATERIAL_INOUT에는 창고위치 컬럼이 없으므로
		// DAO에서 INVENTORY 현재재고 갱신 기준으로 사용한다.
		// =============================================================
		dto.setStockLocation(stockLocation);

		// =============================================================
		// 작업지시번호는 등록모달에서 제거
		// 신규 수기 입출고 등록은 ORDER_ID를 NULL로 저장한다.
		// =============================================================
		dto.setOrderId(0);

		service.addInout(dto);

		return "redirect:/inventory/materialIn";
	}

	// =========================================================================
	// 선택 삭제
	// 체크박스로 선택한 입출고 데이터 삭제
	// =========================================================================
	@RequestMapping("/inventory/materialIn/delete")
	public String deleteInout(
			@RequestParam(
				value = "inoutIds",
				required = false)
			String[] inoutIds) {

		if (inoutIds != null) {

			service.removeInout(
				inoutIds);
		}

		return "redirect:/inventory/materialIn";
	}

	// =========================================================================
	// 상세보기 페이지
	// 상세페이지는 DAO에서 전체 DB 컬럼을 조회해서 inoutDetail.jsp로 전달
	// =========================================================================
	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			@RequestParam(
				value = "mode",
				defaultValue = "view")
			String mode,
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
	// 상세페이지 수정모드용 기존 흐름 유지
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
	// AJAX에서 문자열 JSON으로 받아 등록모달에 출력한다.
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

		// =============================================================
		// null 방어코딩
		// 품목 연결 정보가 비어 있어도 AJAX가 깨지지 않게 빈 DTO로 처리한다.
		// =============================================================
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
	// 창고위치별 현재재고도 같이 내려준다.
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

		String result = "";

		result += "[";

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
	// 품목별 잔량이 남은 LOT만 내려준다.
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

		String result = "";

		result += "[";

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
	// 기존 재고조회 기능은 건드리지 않음
	// =========================================================================

	// =========================================================================
	// 재고조회 목록
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
			Model model) {

		List<InventoryDTO> list =
			inventoryService.getInventoryList(
				searchType,
				keyword,
				startDate,
				endDate);

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
			"/inventory/stockList");

		model.addAttribute(
			"searchType",
			searchType);

		model.addAttribute(
			"keyword",
			keyword);

		model.addAttribute(
			"startDate",
			startDate);

		model.addAttribute(
			"endDate",
			endDate);

		return "inventory/inventoryManage.tiles";
	}

	// =========================================================================
	// 재고 등록
	// =========================================================================
	@RequestMapping("/inventory/stockList/insert")
	public String insertInventory(
			@RequestParam("itemId") int itemId,
			@RequestParam("inventoryStock") int inventoryStock,
			@RequestParam("stockLocation") String stockLocation,
			@RequestParam(
				value = "remark",
				defaultValue = "")
			String remark) {

		InventoryDTO dto =
			new InventoryDTO();

		dto.setItemId(itemId);
		dto.setInventoryStock(inventoryStock);

		if (stockLocation == null) {
			stockLocation = "";
		}

		dto.setStockLocation(stockLocation);
		dto.setRemark(remark);

		inventoryService.addInventory(dto);

		return "redirect:/inventory/stockList";
	}

	// =========================================================================
	// 재고 선택 삭제
	// =========================================================================
	@RequestMapping("/inventory/stockList/delete")
	public String deleteInventory(
			@RequestParam(
				value = "inventoryIds",
				required = false)
			String[] inventoryIds) {

		if (inventoryIds != null) {

			inventoryService.removeInventory(
				inventoryIds);
		}

		return "redirect:/inventory/stockList";
	}

	// =========================================================================
	// 재고 상세
	// =========================================================================
	@RequestMapping("/inventory/stockList/detail")
	public String inventoryDetail(
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam(
				value = "mode",
				defaultValue = "view")
			String mode,
			Model model) {

		InventoryDTO inventory =
			inventoryService.getInventoryDetail(
				inventoryId);

		model.addAttribute(
			"inventory",
			inventory);

		model.addAttribute(
			"mode",
			mode);

		return "inventory/inventoryDetail.tiles";
	}

	// =========================================================================
	// 재고 수정
	// =========================================================================
	@RequestMapping("/inventory/stockList/update")
	public String updateInventory(
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam("inventoryStock") int inventoryStock,
			@RequestParam("stockLocation") String stockLocation,
			@RequestParam(
				value = "remark",
				defaultValue = "")
			String remark) {

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

	// =========================================================================
	// 품목 선택 시 창고위치 자동 조회
	// 재고조회 등록 모달에서 사용
	// 기존 재고조회 기능이므로 유지한다.
	// =========================================================================
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
	// 로그인 사용자 사원번호 추출
	// 프로젝트 LoginDTO 필드명이 달라도 컴파일 에러가 나지 않도록 reflection 사용
	// getEmpId가 있으면 우선 사용하고, 없으면 getEmpno에서 숫자만 추출한다.
	// =========================================================================
	private int getLoginEmpId(
			HttpSession session) {

		if (session == null) {

			return 0;
		}

		Object loginUser =
			session.getAttribute("loginUser");

		if (loginUser == null) {

			loginUser =
				session.getAttribute("member");
		}

		if (loginUser == null) {

			return 0;
		}

		Integer empId =
			callIntGetter(
				loginUser,
				"getEmpId");

		if (empId != null
				&& empId.intValue() > 0) {

			return empId.intValue();
		}

		empId =
			callIntGetter(
				loginUser,
				"getEmp_id");

		if (empId != null
				&& empId.intValue() > 0) {

			return empId.intValue();
		}

		String empno =
			callStringGetter(
				loginUser,
				"getEmpno");

		if (empno != null) {

			String onlyNumber =
				empno.replaceAll("[^0-9]", "");

			if (!onlyNumber.equals("")) {

				try {

					return Integer.parseInt(
							onlyNumber);

				} catch (Exception e) {

					return 0;
				}
			}
		}

		return 0;
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
	// 화면에서 생성된 값이 비어있을 때 서버에서 한 번 더 생성한다.
	// =========================================================================
	private String createMaterialLot(
			String inoutDate) {

		String dateText =
			inoutDate.replaceAll("-", "");

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
	// 간단한 JSON 문자열 이스케이프
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
