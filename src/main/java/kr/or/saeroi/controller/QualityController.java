package kr.or.saeroi.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.QualityService;

@Controller
@RequestMapping("/quality")
public class QualityController {

//	컨트롤러에 서비스 파일 주입 받기
	@Autowired
	QualityService qualityService;

	// 품질관리 등록, 수정, 삭제 권한 확인
	private boolean canManageQuality(LoginDTO loginUser) {
		return loginUser != null && ("ADMIN".equals(loginUser.getRole()) || "MANAGER".equals(loginUser.getRole()));
	}

	@RequestMapping("/inspection")
	public String inspection(Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate, @RequestParam(required = false) String searchType,
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
		// DB에서 전체목록을 가져온 다음 컨트롤러에서 보여줄 것만 잘라서 JSP로 보냄
		int totalCount = list.size();
		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;
		// 마지막 페이지에서 범위 넘어가는 것 방지
		if (endIndex > totalCount) {
			endIndex = totalCount;
		}
		List<InspectionDTO> page_list = list.subList(startIndex, endIndex);
		PageDTO pageInfo = new PageDTO(page, size, totalCount);// 페이징 jsp 버튼 만들 수 있는 정보 담는 곳
		model.addAttribute("list", page_list);

		// jsp에서 검색 조건 남아있게 하기
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/quality/inspection");

		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);

		// 페이징 바뀔 때도 검색 조건 유지(페이징 jsp에 보내는 값)
		String searchParam = "";

		if (startDate != null && !startDate.equals("")) {
			searchParam += "&startDate=" + startDate;
		}
		if (endDate != null && !endDate.equals("")) {
			searchParam += "&endDate=" + endDate;
		}
		if (searchType != null && !searchType.equals("")) {
			searchParam += "&searchType=" + searchType;
		}
		if (keyword != null && !keyword.equals("")) {
			searchParam += "&keyword=" + keyword;
		}

		model.addAttribute("searchParam", searchParam);

		// JSP 지정
//		model.addAttribute("contentPage", "/WEB-INF/views/inspection.jsp");

		return "quality/inspection.tiles";
	}

//	구분 10개씩 기능 메서드
	@ResponseBody
	@RequestMapping("/inspection/option")
	public List<InspectionDTO> inspection_option(Model model, @RequestParam(defaultValue = "1") int optionPage,
			@RequestParam(defaultValue = "10") int optionSize,
			// 없어도 괜찮은 값이므로(필수X)
			@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate,
			@RequestParam(required = false) String searchType) {

		List<InspectionDTO> option_list = qualityService._ser_option_Inspection(startDate, endDate, searchType,
				optionPage, optionSize);

		return option_list;
	}

	// 등록 메서드(등록 post 방식 추가)
	// redirect: DB에 저장하고 다시 목록 페이지로 이동시키기 위해서
	@RequestMapping(value = "/inspection/add", method = RequestMethod.POST)
	public String inspection_add(Model model, HttpSession session, @RequestParam(required = false) String insp_date,
			@RequestParam(required = false) String prod_id, @RequestParam(required = false) String emp_id,
			@RequestParam(required = false) String insp_type, @RequestParam(required = false) String result,
			@RequestParam(required = false) String inspection_qty, @RequestParam(required = false) String good_qty,
			@RequestParam(required = false) String remark) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/inspection";
		}

		int insert_result = qualityService._ser_insert_Inspection(insp_date, prod_id, emp_id, insp_type, result,
				inspection_qty, good_qty, remark);

		System.out.println("insert_result 결과: " + insert_result);

		return "redirect:/quality/inspection";
	}

	// 삭제 메서드
	// 삭제 시 검사 번호만
	@RequestMapping(value = "/inspection/delete", method = RequestMethod.POST)
	// 검사번호를 여러 개(선택 시) 받을 수 있으므로 String[] 로 받음
	public String inspection_delete(Model model, HttpSession session,
			@RequestParam(value = "insp_id", required = false) String[] insp_id) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/inspection";
		}

		if (insp_id != null) {
			// 어떤 행을 지울지만 필요함
//			sqlSession.CRUD 자체가 반환 타입이 int
			int delete_result = qualityService._ser_delete_Inspection(insp_id);

			System.out.println("delete_result 결과: " + delete_result);
		}

		return "redirect:/quality/inspection";
	}

	// 검사 상세 목록
	@RequestMapping("/inspection_detail")
	public String inspection(Model model, @RequestParam(required = false) String insp_id,
			@RequestParam(required = false) String insp_date, @RequestParam(required = false) String prod_id,
			@RequestParam(required = false) String emp_id, @RequestParam(required = false) String insp_type,
			@RequestParam(required = false) String result, @RequestParam(required = false) String inspection_qty,
			@RequestParam(required = false) String good_qty, @RequestParam(required = false) String remark) {
		// 1건씩만 read이므로 List 아님
		InspectionDTO inspection = qualityService._ser_select_Inspection_detail(insp_id, insp_date, prod_id, emp_id,
				insp_type, result, inspection_qty, good_qty, remark);
		System.out.println("검사 상세 목록 list 실행 됨");

		// jsp에 값 보내기
		model.addAttribute("inspection", inspection);
		model.addAttribute("insp_id", insp_id);
		model.addAttribute("insp_date", insp_date);
		model.addAttribute("prod_id", prod_id);
		model.addAttribute("emp_id", emp_id);
		model.addAttribute("insp_type", insp_type);
		model.addAttribute("inspection_qty", inspection_qty);
		model.addAttribute("good_qty", good_qty);
		model.addAttribute("remark", remark);

		return "quality/inspection_detail.tiles";
	}

	// (검사 상세에서)
	// 업데이트 메서드
	// 검사 수정
	@RequestMapping(value = "/inspection/update", method = RequestMethod.POST)
	public String inspection_update(Model model, HttpSession session, @RequestParam(required = false) String insp_id,
			@RequestParam(required = false) String insp_date, @RequestParam(required = false) String insp_type,
			@RequestParam(required = false) String result, @RequestParam(required = false) String inspection_qty,
			@RequestParam(required = false) String good_qty, @RequestParam(required = false) String remark) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/inspection_detail?insp_id=" + insp_id;
		}

		int update_result = qualityService._ser_update_Inspection(insp_id, insp_date, insp_type, result, inspection_qty,
				good_qty, remark);

		System.out.println("update_result: " + update_result);

		return "redirect:/quality/inspection_detail?insp_id=" + insp_id;
	}

	// 불량 목록
	@RequestMapping("/defect")
	public String defect(Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate, @RequestParam(required = false) String searchType,
			@RequestParam(required = false) String keyword) {

		List<DefectDTO> list = qualityService._ser_select_Defect(startDate, endDate, searchType, keyword);

		System.out.println("불량 목록 list 실행 됨");
		System.out.println("startDate: " + startDate);
		System.out.println("endDate: " + endDate);
		System.out.println("searchType: " + searchType);
		System.out.println("keyword: " + keyword);

		int totalCount = list.size();

		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;

		if (startIndex > totalCount) {
			startIndex = totalCount;
		}

		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		List<DefectDTO> page_list = list.subList(startIndex, endIndex);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		model.addAttribute("list", page_list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/quality/defect");

		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);

		String searchParam = "";

		if (startDate != null && !startDate.equals("")) {
			searchParam += "&startDate=" + startDate;
		}
		if (endDate != null && !endDate.equals("")) {
			searchParam += "&endDate=" + endDate;
		}
		if (searchType != null && !searchType.equals("")) {
			searchParam += "&searchType=" + searchType;
		}
		if (keyword != null && !keyword.equals("")) {
			searchParam += "&keyword=" + keyword;
		}

		model.addAttribute("searchParam", searchParam);

		return "quality/defect.tiles";
	}

	// 불량 관리 모달 옵션
	@ResponseBody
	@RequestMapping("/defect/option")
	public List<DefectDTO> defect_option() {

		List<DefectDTO> defect_option_list = qualityService._ser_select_Defect_option();

		return defect_option_list;
	}

//	//불량관리 등록 메서드
	@RequestMapping(value = "/defect/add", method = RequestMethod.POST)
	public String defect_add(Model model, HttpSession session, @RequestParam(required = false) String defect_date,
			@RequestParam(required = false) String insp_id, @RequestParam(required = false) String defect_id,
			@RequestParam(required = false) String defect_qty, @RequestParam(required = false) String remark) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect";
		}

		int defect_add_result = qualityService._ser_add_defect(defect_date, insp_id, defect_id, defect_qty, remark);

		System.out.println("defect_add_result 결과: " + defect_add_result);

		return "redirect:/quality/defect";
	}

	// 불량관리 삭제 메서드
	@RequestMapping(value = "/defect/delete", method = RequestMethod.POST)
	public String defect_delete(Model model, HttpSession session,
			@RequestParam(value = "defect_list_id", required = false) String[] defect_list_id) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect";
		}

		if (defect_list_id != null && defect_list_id.length > 0) {
			int defect_delete_result = qualityService._ser_delete_defect(defect_list_id);
			System.out.println("defect_delete_result: " + defect_delete_result);
		}

		return "redirect:/quality/defect";

	}

	// 불량 관리 상세
	@RequestMapping("/defect_detail")
	public String defect_detail(Model model, @RequestParam(required = false) String defect_list_id) {

		DefectDTO defect = qualityService._ser_select_Defect_detail(defect_list_id);

		List<DefectDTO> defectActionList = qualityService._ser_select_Defect_action(defect_list_id);

		System.out.println("defect_detail defect_list_id: " + defect_list_id);
		System.out.println("defect_detail action 건수: " + defectActionList.size());

		model.addAttribute("defect", defect);
		model.addAttribute("defectActionList", defectActionList);

		return "quality/defect_detail.tiles";
	}

	// 불량관리 업데이트 메서드
	@RequestMapping(value = "/defect/update", method = RequestMethod.POST)
	public String defect_update(Model model, HttpSession session, @RequestParam(required = false) String defect_list_id,
			@RequestParam(required = false) String defect_date, @RequestParam(required = false) String defect_id,
			@RequestParam(required = false) String defect_qty, @RequestParam(required = false) String remark) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
		}

		int defect_update_result = qualityService._ser_update_Defect(defect_list_id, defect_date, defect_id, defect_qty,
				remark);

		System.out.println("defect_update_result: " + defect_update_result);

		return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
	}

	// 불량 조치 내역 등록
	@RequestMapping(value = "/defect/action/add", method = RequestMethod.POST)
	public String defect_action_add(Model model, HttpSession session,
			@RequestParam(required = false) String defect_list_id, @RequestParam(required = false) String action_date,
			@RequestParam(required = false) String emp_id, @RequestParam(required = false) String action_content) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
		}

		int insert_result = qualityService._ser_insert_Defect_action(defect_list_id, action_date, emp_id,
				action_content);

		System.out.println("defect_action_insert_result: " + insert_result);

		return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
	}

}
