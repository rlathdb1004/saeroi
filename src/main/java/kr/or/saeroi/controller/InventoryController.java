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

		List<InoutDTO> page_list =
				list.subList(startIndex, endIndex);

		PageDTO pageInfo =
				new PageDTO(page, size, totalCount);

		List<InoutDTO> itemList =
				service.getItemList();

		model.addAttribute("list", page_list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		model.addAttribute("searchType", searchType);
		model.addAttribute("inoutType", inoutType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		// inventory 폴더로 옮겼기 때문에 폴더명 추가
		return "inventory/inoutManage.tiles";
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

		InoutDTO inout =
				service.getInoutDetail(inoutId);

		model.addAttribute("inout", inout);
		model.addAttribute("mode", mode);

		// inventory 폴더로 옮겼기 때문에 폴더명 추가
		return "inventory/inoutDetail.tiles";
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
		"/inventory/inventoryStatus",
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

		List<InventoryDTO> list =
				inventoryService.getInventoryList(
						searchType,
						keyword,
						startDate,
						endDate);

		int totalCount = list.size();
		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;

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

		model.addAttribute("pageUrl", "/inventory/inventoryStatus");

		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		// inventory 폴더로 옮겼기 때문에 폴더명 추가
		return "inventory/inventoryManage.tiles";
	}

	// 재고 등록
	@RequestMapping("/inventory/stockList/insert")
	public String insertInventory(
			@RequestParam("itemId") int itemId,
			@RequestParam("inventoryStock") int inventoryStock,
			@RequestParam("stockLocation") String stockLocation,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InventoryDTO dto = new InventoryDTO();

		dto.setItemId(itemId);
		dto.setInventoryStock(inventoryStock);
		dto.setStockLocation(stockLocation);
		dto.setRemark(remark);

		inventoryService.addInventory(dto);

		return "redirect:/inventory/inventoryStatus";
	}

	// 재고 선택 삭제
	@RequestMapping("/inventory/stockList/delete")
	public String deleteInventory(
			@RequestParam(value = "inventoryIds", required = false) String[] inventoryIds) {

		if (inventoryIds != null) {
			inventoryService.removeInventory(inventoryIds);
		}

		return "redirect:/inventory/inventoryStatus";
	}

	// 재고 상세
	@RequestMapping("/inventory/stockList/detail")
	public String inventoryDetail(
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam(value = "mode", defaultValue = "view") String mode,
			Model model) {

		InventoryDTO inventory =
				inventoryService.getInventoryDetail(inventoryId);

		model.addAttribute("inventory", inventory);
		model.addAttribute("mode", mode);

		// inventory 폴더로 옮겼기 때문에 폴더명 추가
		return "inventory/inventoryDetail.tiles";
	}

	// 재고 수정
	@RequestMapping("/inventory/stockList/update")
	public String updateInventory(
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam("inventoryStock") int inventoryStock,
			@RequestParam("stockLocation") String stockLocation,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InventoryDTO dto = new InventoryDTO();

		dto.setInventoryId(inventoryId);
		dto.setInventoryStock(inventoryStock);
		dto.setStockLocation(stockLocation);
		dto.setRemark(remark);

		inventoryService.modifyInventory(dto);

		return "redirect:/inventory/stockList/detail?inventoryId=" + inventoryId;
	}
}