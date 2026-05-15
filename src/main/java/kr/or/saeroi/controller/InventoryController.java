package kr.or.saeroi.controller;

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
			Model model) {

		int size = 10;

		int totalCount = service.getInoutCount();

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		List<InoutDTO> list = service.getInoutList(startRow, endRow);

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		model.addAttribute("contentPage", "/WEB-INF/views/inoutManage.jsp");
		model.addAttribute("headerTitle", "자재/재고 관리");
		model.addAttribute("headerSubTitle", "자재입출고 관리");

		return "layout";
	}
}