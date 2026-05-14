package kr.or.saeroi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ProductionController {

	@RequestMapping("/production/productionPlan")
	public String productionPlan(Model model) {

		model.addAttribute("contentPage", "/WEB-INF/views/productionPlan.jsp");
		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산계획 관리");

		return "layout";
	}
}