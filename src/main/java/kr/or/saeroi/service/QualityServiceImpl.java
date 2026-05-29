package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.saeroi.dao.QualityDAO;
import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;

@Service
public class QualityServiceImpl implements QualityService {

	@Autowired
	QualityDAO qualityDAO;

	@Override
	public List<InspectionDTO> _ser_select_Inspection(String startDate, String endDate, String searchType,
			String keyword) {
		System.out.println("inspection_list 실행 됨");
		return qualityDAO._dao_select_Inspection(startDate, endDate, searchType, keyword);
	}

	@Override
	public List<InspectionDTO> _ser_option_Inspection(String startDate, String endDate, String searchType,
			int optionPage, int optionSize) {
		return qualityDAO._dao_option_Inspection(startDate, endDate, searchType, optionPage, optionSize);
	}

	@Override
	public int _ser_insert_Inspection(String insp_date, String prod_id, String emp_id, String insp_type, String result,
			String inspection_qty, String good_qty, String remark) {
		return qualityDAO._dao_insert_Inspection(insp_date, prod_id, emp_id, insp_type, result, inspection_qty, good_qty,
				remark);
	}

	@Override
	public int _ser_delete_Inspection(String[] insp_id) {
		return qualityDAO._dao_delete_Inspection(insp_id);
	}

	@Override
	public InspectionDTO _ser_select_Inspection_detail(String insp_id, String insp_date, String prod_id, String emp_id,
			String insp_type, String result, String inspection_qty, String good_qty, String remark) {
		return qualityDAO._dao_Insepection_detail(insp_id, insp_date, prod_id, emp_id, insp_type, result,
				inspection_qty, good_qty, remark);
	}

	@Override
	public int _ser_update_Inspection(String insp_id, String insp_date, String insp_type, String result,
			String inspection_qty, String good_qty, String remark) {
		return qualityDAO._dao_update_Inspection(insp_id, insp_date, insp_type, result, inspection_qty, good_qty,
				remark);
	}

	@Override
	public List<DefectDTO> _ser_select_Defect(String startDate, String endDate, String searchType, String keyword) {
		System.out.println("defect_list 실행 됨");
		return qualityDAO._dao_select_Defect(startDate, endDate, searchType, keyword);
	}

	@Override
	public int _ser_add_defect(String defect_date, String insp_id, String defect_id, String defect_qty,
			String defect_photo, String remark) {
		return qualityDAO._dao_insert_defect(defect_date, insp_id, defect_id, defect_qty, defect_photo, remark);
	}

	@Transactional
	@Override
	public int _ser_add_defect_with_action(String defect_date, String insp_id, String defect_id, String defect_qty,
			String defect_photo, String defect_remark, String action_date, String action_emp_id,
			String action_content) {

		int defectListId = qualityDAO._dao_insert_defect(defect_date, insp_id, defect_id, defect_qty, defect_photo,
				defect_remark);

		if (hasText(action_date) && hasText(action_emp_id) && hasText(action_content)) {
			qualityDAO._dao_insert_Defect_action(String.valueOf(defectListId), action_date, action_emp_id,
					action_content);
		}

		return defectListId;
	}

	@Override
	public List<DefectDTO> _ser_select_Defect_option() {
		return qualityDAO._dao_select_Defect_option();
	}

	@Override
	public int _ser_delete_defect(String[] defect_list_id) {
		return qualityDAO._dao_delete_defect(defect_list_id);
	}

	@Override
	public DefectDTO _ser_select_Defect_detail(String defect_list_id) {
		return qualityDAO._dao_select_Defect_detail(defect_list_id);
	}

	@Override
	public int _ser_update_Defect(String defect_list_id, String defect_date, String defect_id, String defect_qty,
			String remark) {
		return qualityDAO._dao_update_Defect(defect_list_id, defect_date, defect_id, defect_qty, remark);
	}

	@Override
	public List<DefectDTO> _ser_select_Defect_action(String defect_list_id) {
		return qualityDAO._dao_select_Defect_action(defect_list_id);
	}

	@Override
	public int _ser_insert_Defect_action(String defect_list_id, String action_date, String emp_id,
			String action_content) {
		return qualityDAO._dao_insert_Defect_action(defect_list_id, action_date, emp_id, action_content);
	}

	@Override
	public List<DefectDTO> _ser_select_Defect_action_emp_option(String dept) {
		return qualityDAO._dao_select_Defect_action_emp_option(dept);
	}

	private boolean hasText(String value) {
		return value != null && value.trim().length() > 0;
	}
}
