package kr.or.saeroi.controller;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.QualityService;

@Controller
@RequestMapping("/quality")
public class QualityController {

	@Autowired
	QualityService qualityService;

	private static final String RESULT_PASS = "합격";
	private static final String RESULT_CONDITIONAL = "조건부";
	private static final String RESULT_WAIT = "대기";

	private boolean canManageQuality(LoginDTO loginUser) {
		return loginUser != null && ("ADMIN".equals(loginUser.getRole()) || "MANAGER".equals(loginUser.getRole()));
	}

	@RequestMapping("/inspection")
	public String inspection(Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate, @RequestParam(required = false) String searchType,
			@RequestParam(required = false) String keyword) {

		List<InspectionDTO> list;

		if (isInvalidDateRange(startDate, endDate)) {
			list = new ArrayList<InspectionDTO>();
			model.addAttribute("dateError", "시작일은 종료일보다 늦을 수 없습니다.");
		} else {
			list = qualityService._ser_select_Inspection(startDate, endDate, searchType, keyword);
		}

		int totalCount = list.size();
		int startIndex = Math.min((page - 1) * size, totalCount);
		int endIndex = Math.min(startIndex + size, totalCount);
		List<InspectionDTO> pageList = list.subList(startIndex, endIndex);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		model.addAttribute("list", pageList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/quality/inspection");
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("searchParam", buildSearchParam(startDate, endDate, searchType, keyword));

		return "quality/inspection.tiles";
	}

	@ResponseBody
	@RequestMapping("/inspection/option")
	public List<InspectionDTO> inspection_option(Model model, @RequestParam(defaultValue = "1") int optionPage,
			@RequestParam(defaultValue = "10") int optionSize, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate, @RequestParam(required = false) String searchType) {

		return qualityService._ser_option_Inspection(startDate, endDate, searchType, optionPage, optionSize);
	}

	@RequestMapping(value = "/inspection/add", method = RequestMethod.POST)
	public String inspection_add(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(required = false) String insp_date, @RequestParam(required = false) String prod_id,
			@RequestParam(required = false) String emp_id, @RequestParam(required = false) String insp_type,
			@RequestParam(required = false) String result, @RequestParam(required = false) String inspection_qty,
			@RequestParam(required = false) String good_qty, @RequestParam(required = false) String remark,
			@RequestParam(required = false) String has_defect,
			@RequestParam(required = false) String defect_date,
			@RequestParam(required = false) String defect_id,
			@RequestParam(required = false) String defect_qty,
			@RequestParam(value = "defect_photo_file", required = false) MultipartFile defect_photo_file,
			@RequestParam(required = false) String defect_remark,
			@RequestParam(required = false) String action_date,
			@RequestParam(required = false) String action_emp_id,
			@RequestParam(required = false) String action_content) throws IOException {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/inspection";
		}

		double inspectionQtyValue = toNumber(inspection_qty);
		double goodQtyValue = toNumber(good_qty);
		double defectQtyValue = toNumber(defect_qty);
		boolean isPassResult = RESULT_PASS.equals(result);
		boolean isConditionalResult = RESULT_CONDITIONAL.equals(result);
		boolean isWaitResult = RESULT_WAIT.equals(result);

		if (!isPassResult && !isConditionalResult && !isWaitResult) {
		    return "redirect:/quality/inspection";
		}

		if (isWaitResult) {
		    // 대기는 양품수량 강제 0, 불량 없음
		    good_qty = "0";
		    has_defect = null;
		} else {
		    if (inspectionQtyValue <= 0 || goodQtyValue < 0 || defectQtyValue < 0) {
		        return "redirect:/quality/inspection";
		    }

		    if (isPassResult && !isSameQuantity(goodQtyValue, inspectionQtyValue)) {
		        return "redirect:/quality/inspection";
		    }

		    if (isPassResult) {
		        has_defect = null;
		        defectQtyValue = 0;
		    }

		    if (isConditionalResult) {
		        if (!"Y".equals(has_defect) || defectQtyValue <= 0) {
		            return "redirect:/quality/inspection";
		        }
		        if (!isSameQuantity(goodQtyValue + defectQtyValue, inspectionQtyValue)) {
		            return "redirect:/quality/inspection";
		        }
		        if (!hasText(defect_date) || !hasText(defect_id) || !hasText(action_date) || !hasText(action_emp_id)
		                || !hasText(action_content)) {
		            return "redirect:/quality/inspection";
		        }
		    }
		}

		int inspId = qualityService._ser_insert_Inspection(insp_date, prod_id, emp_id, insp_type, result, inspection_qty,
				good_qty, remark);

		if ("Y".equals(has_defect) && hasText(defect_date) && hasText(defect_id) && hasText(defect_qty)) {
			String defectPhotoPath = saveDefectPhoto(defect_photo_file, request);
			qualityService._ser_add_defect_with_action(defect_date, String.valueOf(inspId), defect_id, defect_qty,
					defectPhotoPath, defect_remark, action_date, action_emp_id, action_content);
		}

		return "redirect:/quality/inspection";
	}

	@RequestMapping(value = "/inspection/delete", method = RequestMethod.POST)
	public String inspection_delete(Model model, HttpSession session,
			@RequestParam(value = "insp_id", required = false) String[] insp_id) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/inspection";
		}

		if (insp_id != null && insp_id.length > 0) {
			int deleteResult = qualityService._ser_delete_Inspection(insp_id);
			System.out.println("inspection delete_result: " + deleteResult);
		}

		return "redirect:/quality/inspection";
	}

	@RequestMapping("/inspection_detail")
	public String inspection(Model model, @RequestParam(required = false) String insp_id,
			@RequestParam(required = false) String insp_date, @RequestParam(required = false) String prod_id,
			@RequestParam(required = false) String emp_id, @RequestParam(required = false) String insp_type,
			@RequestParam(required = false) String result, @RequestParam(required = false) String inspection_qty,
			@RequestParam(required = false) String good_qty, @RequestParam(required = false) String remark) {

		InspectionDTO inspection = qualityService._ser_select_Inspection_detail(insp_id, insp_date, prod_id, emp_id,
				insp_type, result, inspection_qty, good_qty, remark);
		List<DefectDTO> inspectionDefectList = qualityService._ser_select_Defect_by_Inspection(insp_id);
		List<DefectDTO> inspectionActionList = qualityService._ser_select_Defect_action_by_Inspection(insp_id);

		model.addAttribute("inspection", inspection);
		model.addAttribute("inspectionDefectList", inspectionDefectList);
		model.addAttribute("inspectionActionList", inspectionActionList);
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

	@RequestMapping(value = "/inspection/update", method = RequestMethod.POST)
	public String inspection_update(Model model, HttpSession session, @RequestParam(required = false) String insp_id,
			@RequestParam(required = false) String insp_date, @RequestParam(required = false) String insp_type,
			@RequestParam(required = false) String result, @RequestParam(required = false) String inspection_qty,
			@RequestParam(required = false) String good_qty, @RequestParam(required = false) String remark) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/inspection_detail?insp_id=" + insp_id;
		}

		int updateResult = qualityService._ser_update_Inspection(insp_id, insp_date, insp_type, result, inspection_qty,
				good_qty, remark);
		System.out.println("inspection update_result: " + updateResult);

		return "redirect:/quality/inspection_detail?insp_id=" + insp_id;
	}

	@RequestMapping("/defect")
	public String defect(Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate, @RequestParam(required = false) String searchType,
			@RequestParam(required = false) String keyword) {

		List<DefectDTO> list;

		if (isInvalidDateRange(startDate, endDate)) {
			list = new ArrayList<DefectDTO>();
			model.addAttribute("dateError", "시작일은 종료일보다 늦을 수 없습니다.");
		} else {
			list = qualityService._ser_select_Defect(startDate, endDate, searchType, keyword);
		}

		int totalCount = list.size();
		int startIndex = Math.min((page - 1) * size, totalCount);
		int endIndex = Math.min(startIndex + size, totalCount);
		List<DefectDTO> pageList = list.subList(startIndex, endIndex);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		model.addAttribute("list", pageList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/quality/defect");
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("searchParam", buildSearchParam(startDate, endDate, searchType, keyword));

		return "quality/defect.tiles";
	}

	@ResponseBody
	@RequestMapping("/defect/option")
	public List<DefectDTO> defect_option() {
		return qualityService._ser_select_Defect_option();
	}

	@RequestMapping(value = "/defect/add", method = RequestMethod.POST)
	public String defect_add(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(required = false) String defect_date, @RequestParam(required = false) String insp_id,
			@RequestParam(required = false) String defect_id, @RequestParam(required = false) String defect_qty,
			@RequestParam(value = "defect_photo_file", required = false) MultipartFile defect_photo_file,
			@RequestParam(required = false) String remark) throws IOException {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect";
		}

		String defectPhotoPath = saveDefectPhoto(defect_photo_file, request);
		int defectAddResult = qualityService._ser_add_defect(defect_date, insp_id, defect_id, defect_qty,
				defectPhotoPath, remark);
		System.out.println("defect_add_result: " + defectAddResult);

		return "redirect:/quality/defect";
	}

	@RequestMapping(value = "/defect/delete", method = RequestMethod.POST)
	public String defect_delete(Model model, HttpSession session,
			@RequestParam(value = "defect_list_id", required = false) String[] defect_list_id) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect";
		}

		if (defect_list_id != null && defect_list_id.length > 0) {
			int deleteResult = qualityService._ser_delete_defect(defect_list_id);
			System.out.println("defect_delete_result: " + deleteResult);
		}

		return "redirect:/quality/defect";
	}

	@RequestMapping("/defect_detail")
	public String defect_detail(Model model, @RequestParam(required = false) String defect_list_id) {

		DefectDTO defect = qualityService._ser_select_Defect_detail(defect_list_id);
		List<DefectDTO> defectActionList = qualityService._ser_select_Defect_action(defect_list_id);

		model.addAttribute("defect", defect);
		model.addAttribute("defectActionList", defectActionList);

		return "quality/defect_detail.tiles";
	}

	@RequestMapping(value = "/defect/update", method = RequestMethod.POST)
	public String defect_update(Model model, HttpSession session, @RequestParam(required = false) String defect_list_id,
			@RequestParam(required = false) String defect_date, @RequestParam(required = false) String defect_id,
			@RequestParam(required = false) String defect_qty, @RequestParam(required = false) String remark) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
		}

		int defectUpdateResult = qualityService._ser_update_Defect(defect_list_id, defect_date, defect_id, defect_qty,
				remark);
		System.out.println("defect_update_result: " + defectUpdateResult);

		return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
	}

	@RequestMapping(value = "/defect/action/add", method = RequestMethod.POST)
	public String defect_action_add(Model model, HttpSession session,
			@RequestParam(required = false) String defect_list_id, @RequestParam(required = false) String action_date,
			@RequestParam(required = false) String emp_id, @RequestParam(required = false) String action_content) {

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (!canManageQuality(loginUser)) {
			return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
		}

		int insertResult = qualityService._ser_insert_Defect_action(defect_list_id, action_date, emp_id,
				action_content);
		System.out.println("defect_action_insert_result: " + insertResult);

		return "redirect:/quality/defect_detail?defect_list_id=" + defect_list_id;
	}

	@ResponseBody
	@RequestMapping(value = "/defect/action/empOption", method = RequestMethod.GET)
	public List<DefectDTO> defect_action_emp_option(@RequestParam(required = false) String dept) {
		return qualityService._ser_select_Defect_action_emp_option(dept);
	}

	private boolean isInvalidDateRange(String startDate, String endDate) {
		if (!hasText(startDate) || !hasText(endDate)) {
			return false;
		}

		try {
			return LocalDate.parse(startDate).isAfter(LocalDate.parse(endDate));
		} catch (DateTimeParseException e) {
			return true;
		}
	}

	private String buildSearchParam(String startDate, String endDate, String searchType, String keyword) {
		String searchParam = "";

		if (hasText(startDate)) {
			searchParam += "&startDate=" + startDate;
		}
		if (hasText(endDate)) {
			searchParam += "&endDate=" + endDate;
		}
		if (hasText(searchType)) {
			searchParam += "&searchType=" + searchType;
		}
		if (hasText(keyword)) {
			searchParam += "&keyword=" + keyword;
		}

		return searchParam;
	}

	private String saveDefectPhoto(MultipartFile defectPhotoFile, HttpServletRequest request) throws IOException {
		if (defectPhotoFile == null || defectPhotoFile.isEmpty()) {
			return null;
		}

		String originalFilename = defectPhotoFile.getOriginalFilename();
		String extension = "";

		if (originalFilename != null && originalFilename.lastIndexOf(".") >= 0) {
			extension = originalFilename.substring(originalFilename.lastIndexOf("."));
		}

		String uploadRelativePath = "/resources/upload/defect/";
		String uploadRealPath = request.getServletContext().getRealPath(uploadRelativePath);

		if (uploadRealPath == null) {
			throw new IOException("업로드 경로를 찾을 수 없습니다.");
		}

		File uploadDir = new File(uploadRealPath);

		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		String savedFilename = "defect_" + UUID.randomUUID().toString().replace("-", "") + extension;
		File savedFile = new File(uploadDir, savedFilename);
		defectPhotoFile.transferTo(savedFile);

		return uploadRelativePath + savedFilename;
	}

	private boolean hasText(String value) {
		return value != null && value.trim().length() > 0;
	}

	private double toNumber(String value) {
		if (!hasText(value)) {
			return 0;
		}

		try {
			return Double.parseDouble(value.trim());
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	private boolean isSameQuantity(double left, double right) {
		return Math.abs(left - right) < 0.000001;
	}
}
