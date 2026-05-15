package kr.or.saeroi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.saeroi.dto.InspectionDTO;
import kr.or.saeroi.service.QualityService;

@Controller
@RequestMapping("/quality")
public class QualityController {

//	컨트롤러에 서비스 파일 주입 받기
	@Autowired
	QualityService qualityService;

	@RequestMapping("/inspection")
	public String inspection(Model model) {
//		검사 목록 
		List<InspectionDTO> list = qualityService._dto_select_Inspection();
		System.out.println("검사 목록 list 실행 됨");

		// JSP 지정
		model.addAttribute("contentPage", "/WEB-INF/views/inspection.jsp");
		model.addAttribute("list", list);
		// 공통 레이아웃 화면으로 이동
		return "layout";
	}

	@RequestMapping("/defect")
	public String defect(Model model) {

		// layout.jsp 안에 들어갈 실제 본문 JSP 지정
		model.addAttribute("contentPage", "/WEB-INF/views/quality/defect.jsp");

		// 공통 레이아웃 화면으로 이동
		return "layout";
	}
}
