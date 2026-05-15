package kr.or.saeroi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.saeroi.common.PageDTO;

@Controller
public class ProductionController {

	@RequestMapping("/production/productionPlan")
	public String productionPlan(Model model) {

		// 페이징에 필요한 값
		PageDTO pageInfo = new PageDTO(1, 10, 1);

		// 공통 페이징으로 보내는 값
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/production/productionPlan");

		// layout에 들어갈 본문 JSP
		model.addAttribute("contentPage", "/WEB-INF/views/productionPlan.jsp");

		// 헤더 제목
		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산계획관리");

		return "layout";
	}
}