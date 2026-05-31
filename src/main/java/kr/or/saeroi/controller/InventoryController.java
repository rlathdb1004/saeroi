package kr.or.saeroi.controller;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

		inventoryService.addInventory(dto);

		return "redirect:/inventory/stockList";
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
			Model model) {

		InventoryDTO inventory =
			inventoryService.getInventoryDetail(
				inventoryId);

		model.addAttribute(
			"inventory",
			inventory);

		// =============================================================
		// 재고 상세페이지 하단 입출고 내역서
		// 재고번호를 따라갔을 때 해당 품목의 입고 / 사용 / 출고 이력을
		// 리스트로 확인할 수 있도록 MATERIAL_INOUT 이력을 같이 전달한다.
		// =============================================================
		model.addAttribute(
			"inoutHistory",
			inventoryService.getInventoryInoutHistoryList(
				inventoryId));

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