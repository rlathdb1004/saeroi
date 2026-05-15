package kr.or.saeroi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.saeroi.common.PageDTO;

@Controller
public class InventoryController {

	@RequestMapping("/inventory/materialIn")
	public String materialInOut(Model model) {

		PageDTO pageInfo = new PageDTO(1, 10, 1);

		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		model.addAttribute("contentPage", "/WEB-INF/views/materialInOut.jsp");
		model.addAttribute("headerTitle", "자재/재고 관리");
		model.addAttribute("headerSubTitle", "자재입출고 관리");

		return "layout";
	}
}