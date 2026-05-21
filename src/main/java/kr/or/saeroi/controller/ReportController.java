package kr.or.saeroi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/report")
public class ReportController {

    // 생산 리포트 페이지로 이동한다.
    @GetMapping("/productionreport")
    public String productionReport() {
        return "report/productionreport.tiles";
    }

    // 품질 리포트 페이지로 이동한다.
    @GetMapping("/qualityreport")
    public String qualityReport() {
        return "report/qualityreport.tiles";
    }
}
