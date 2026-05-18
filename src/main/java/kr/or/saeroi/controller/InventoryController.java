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

// 자재/재고 Controller
@Controller
public class InventoryController {

	private InoutService service = new InoutServiceImpl();

	// 자재입고관리 클릭 시 입출고관리 화면
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
				searchType,
				keyword,
				startDate,
				endDate);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		List<InoutDTO> list = service.getInoutList(
				startRow,
				endRow,
				searchType,
				keyword,
				startDate,
				endDate);

		List<InoutDTO> itemList = service.getItemList();

		model.addAttribute("list", list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		model.addAttribute("contentPage", "/WEB-INF/views/inoutManage.jsp");
		model.addAttribute("headerTitle", "자재/재고 관리");
		model.addAttribute("headerSubTitle", "자재입출고 관리");

		return "layout";
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

	// 상세보기 페이지
	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			Model model) {

		InoutDTO inout = service.getInoutDetail(inoutId);

		model.addAttribute("inout", inout);

		model.addAttribute("contentPage", "/WEB-INF/views/inoutDetail.jsp");
		model.addAttribute("headerTitle", "자재/재고 관리");
		model.addAttribute("headerSubTitle", "입출고 상세보기");

		return "layout";
	}
}