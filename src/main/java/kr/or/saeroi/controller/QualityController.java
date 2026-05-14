package kr.or.saeroi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/quality")
public class QualityController {

    @RequestMapping("/inspection")
    public String inspection(Model model) {

        // JSP 지정
        model.addAttribute("contentPage", "/WEB-INF/views/quality/inspection.jsp");

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
