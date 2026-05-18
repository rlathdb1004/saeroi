package kr.or.saeroi.controller;

import java.sql.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.InoutDTO;
import kr.or.saeroi.service.InoutService;
import kr.or.saeroi.service.InoutServiceImpl;

@Controller
public class InventoryController {

	private InoutService service = new InoutServiceImpl();

	@RequestMapping("/inventory/materialIn")
	public String materialIn(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "searchType", defaultValue = "all") String searchType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			Model model) {

		int size = 10;

		int totalCount = service.getInoutCount(
				searchType, keyword, startDate, endDate);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		List<InoutDTO> list = service.getInoutList(
				startRow, endRow, searchType, keyword, startDate, endDate);

		List<InoutDTO> itemList = service.getItemList();

		model.addAttribute("list", list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		// Tiles 주소
		return "ioRegInq";
	}

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

	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			Model model) {

		InoutDTO inout = service.getInoutDetail(inoutId);

		model.addAttribute("inout", inout);

		// Tiles 주소
		return "ioRegDetail";
	}
}