package kr.or.saeroi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.InspectionDTO;
import kr.or.saeroi.service.QualityService;

@Controller
@RequestMapping("/quality")
public class QualityController {

//	컨트롤러에 서비스 파일 주입 받기
	@Autowired
	QualityService qualityService;

	@RequestMapping("/inspection")
	public String inspection(Model model, @RequestParam(defaultValue = "1") int page,
	        @RequestParam(defaultValue = "10") int size,
	        @RequestParam(required = false) String startDate,
	        @RequestParam(required = false) String endDate,
	        @RequestParam(required = false) String searchType,
	        @RequestParam(required = false) String keyword) {
//		검사 목록 
		List<InspectionDTO> list = qualityService._ser_select_Inspection(startDate, endDate, searchType, keyword);
		System.out.println("검사 목록 list 실행 됨");

		// 날짜 잘 들어왔나 값 확인(콘솔)
		System.out.println("startDate: " + startDate);
		System.out.println("endDate: " + endDate);
		System.out.println("searchType: " + searchType);
		System.out.println("keyword: " + keyword);

		// 페이징 기능
		int totalCount = list.size();
		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;
		//마지막 페이지에서 범위 넘어가는 것 방지
		if (endIndex > totalCount) {
			endIndex = totalCount;
		}
		List<InspectionDTO> page_list = list.subList(startIndex, endIndex);
		PageDTO pageInfo = new PageDTO(page, size, totalCount);//페이징 jsp 버튼 만들 수 있는 정보 담는 곳
		model.addAttribute("list", page_list);

		// jsp에서 검색 조건 남아있게 하기
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/quality/inspection");

		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);

		// JSP 지정
//		model.addAttribute("contentPage", "/WEB-INF/views/inspection.jsp");

		return "inspection.tiles";
	}

//	구분 10개씩 기능 메서드
	@ResponseBody
	@RequestMapping("/inspection/option")
	public List<InspectionDTO> inspection_option(Model model, @RequestParam(defaultValue = "1") int optionPage,
			@RequestParam(defaultValue = "10") int optionSize,
			// 없어도 괜찮은 값이므로(필수X)
			@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate,
			@RequestParam(required = false) String searchType) {
		
		List<InspectionDTO> option_list = qualityService._ser_option_Inspection(startDate, endDate, searchType, optionPage, optionSize);
		
		return option_list;
	}

	@RequestMapping("/defect")
	public String defect(Model model) {

		model.addAttribute("contentPage", "/WEB-INF/views/quality/defect.jsp");

		return "defect.tiles";
	}
	
	//등록 메서드(등록 post 방식 추가)
	@RequestMapping(value = "/inspection/add", method = RequestMethod.POST)
	public String inspection_add() {
		
		
		return null;
	}
}
