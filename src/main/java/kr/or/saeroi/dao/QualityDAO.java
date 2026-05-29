package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;

public interface QualityDAO {

	List<InspectionDTO> _dao_select_Inspection(String startDate, String endDate, String searchType, String keyword);

	List<InspectionDTO> _dao_option_Inspection(String startDate, String endDate, String searchType, int optionPage,
			int optionSize);

	int _dao_insert_Inspection(String insp_date, String prod_id, String emp_id, String insp_type, String result,
			String inspection_qty, String good_qty, String remark);

	int _dao_delete_Inspection(String[] insp_id);

	InspectionDTO _dao_Insepection_detail(String insp_id, String insp_date, String prod_id, String emp_id,
			String insp_type, String result, String inspection_qty, String good_qty, String remark);

	int _dao_update_Inspection(String insp_id, String insp_date, String insp_type, String result, String inspection_qty,
			String good_qty, String remark);

	List<DefectDTO> _dao_select_Defect(String startDate, String endDate, String searchType, String keyword);

	int _dao_insert_defect(String defect_date, String insp_id, String defect_id, String defect_qty, String defect_photo,
			String remark);

	List<DefectDTO> _dao_select_Defect_option();

	int _dao_delete_defect(String[] defect_list_id);

	DefectDTO _dao_select_Defect_detail(String defect_list_id);

	int _dao_update_Defect(String defect_list_id, String defect_date, String defect_id, String defect_qty,
			String remark);

	List<DefectDTO> _dao_select_Defect_action(String defect_list_id);

	int _dao_insert_Defect_action(String defect_list_id, String action_date, String emp_id, String action_content);

	List<DefectDTO> _dao_select_Defect_action_emp_option(String dept);
}
