package kr.or.saeroi.controller;

import java.sql.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.InoutDTO;
import kr.or.saeroi.dto.InventoryDTO;
import kr.or.saeroi.service.InoutService;
import kr.or.saeroi.service.InoutServiceImpl;
import kr.or.saeroi.service.InventoryService;
import kr.or.saeroi.service.InventoryServiceImpl;

// 자재/재고 Controller
@Controller
public class InventoryController {

	private InoutService service = new InoutServiceImpl();

	// 재고조회 Service
	private InventoryService inventoryService = new InventoryServiceImpl();

	// 자재입고관리 클릭 시 입출고관리 화면
	@RequestMapping("/inventory/materialIn")
	public String materialIn(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size,
			@RequestParam(value = "searchType", defaultValue = "all") String searchType,
			@RequestParam(value = "inoutType", defaultValue = "") String inoutType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			Model model) {

		List<InoutDTO> list = service.getInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);

		int totalCount = list.size();
		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;

		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		List<InoutDTO> page_list = list.subList(startIndex, endIndex);
		PageDTO pageInfo = new PageDTO(page, size, totalCount);
		List<InoutDTO> itemList = service.getItemList();

		model.addAttribute("list", page_list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		model.addAttribute("searchType", searchType);
		model.addAttribute("inoutType", inoutType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		return "inoutManage.tiles";
	}

	// 입출고 등록
	@RequestMapping("/inventory/materialIn/insert")
	public String insertInout(
			@RequestParam("itemId") int itemId,
			@RequestParam("inoutType") String inoutType,
			@RequestParam("inoutQty") int inoutQty,
			@RequestParam("inoutDate") String inoutDate,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InoutDTO dto = new InoutDTO();

		dto.setItemId(itemId);
		dto.setInoutType(inoutType);
		dto.setInoutQty(inoutQty);
		dto.setInoutDate(Date.valueOf(inoutDate));
		dto.setRemark(remark);

		service.addInout(dto);

		return "redirect:/inventory/materialIn";
	}

	// 선택 삭제
	@RequestMapping("/inventory/materialIn/delete")
	public String deleteInout(
			@RequestParam(value = "inoutIds", required = false) String[] inoutIds) {

		if (inoutIds != null) {
			service.removeInout(inoutIds);
		}

		return "redirect:/inventory/materialIn";
	}

	// 상세보기 페이지
	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			@RequestParam(value = "mode", defaultValue = "view") String mode,
			Model model) {

		InoutDTO inout = service.getInoutDetail(inoutId);

		model.addAttribute("inout", inout);
		model.addAttribute("mode", mode);

		return "inoutDetail.tiles";
	}

	// 입출고 수정
	@RequestMapping("/inventory/materialIn/update")
	public String updateInout(
			@RequestParam("inoutId") int inoutId,
			@RequestParam("inoutType") String inoutType,
			@RequestParam("inoutQty") int inoutQty,
			@RequestParam("inoutDate") String inoutDate,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InoutDTO dto = new InoutDTO();

		dto.setInoutId(inoutId);
		dto.setInoutType(inoutType);
		dto.setInoutQty(inoutQty);
		dto.setInoutDate(Date.valueOf(inoutDate));
		dto.setRemark(remark);

		service.modifyInout(dto);

		return "redirect:/inventory/materialIn/detail?inoutId=" + inoutId;
	}

	// ==================================================
	// 여기부터 재고조회 코드
	// ==================================================

	// 재고조회 목록
	@RequestMapping({
		"/inventory/inventoryStatus", // 사이드바 재고조회 주소
		"/inventory/stockList",
		"/inventory/inventoryList",
		"/inventory/stock",
		"/inventory/inventory"
	})
	public String inventoryList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size,
			@RequestParam(value = "searchType", defaultValue = "") String searchType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			Model model) {

		// 재고 목록 조회
		List<InventoryDTO> list = inventoryService.getInventoryList(
				searchType,
				keyword,
				startDate,
				endDate);

		// 전체 데이터 개수
		int totalCount = list.size();

		// 시작 위치
		int startIndex = (page - 1) * size;

		// 끝 위치
		int endIndex = startIndex + size;

		// 마지막 페이지 예외 처리
		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		// 현재 페이지 데이터만 자르기
		List<InventoryDTO> page_list =
				list.subList(startIndex, endIndex);

		// 페이징 정보 저장
		PageDTO pageInfo =
				new PageDTO(page, size, totalCount);

		// 품목 목록 조회
		List<InventoryDTO> itemList =
				inventoryService.getItemList();

		// jsp로 데이터 보내기
		model.addAttribute("list", page_list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);

		// 공통 페이징 URL
		model.addAttribute(
				"pageUrl",
				"/inventory/inventoryStatus");

		// 검색 값 유지
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		// 재고조회 페이지 이동
		return "inventoryManage.tiles";
	}
}