package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;

public interface QualityDAO {
	// 검사 목록 가져오기
	List<InspectionDTO> _dao_select_Inspection(String startDate, String endDate, String searchType, String keyword);

	// 구분 옵션
	List<InspectionDTO> _dao_option_Inspection(String startDate, String endDate, String searchType, int optionPage,
			int optionSize);

	// 등록에 필요한 구성
	int _dao_insert_Inspection(String insp_date, String prod_id, String emp_id, String insp_type, String result,
			String inspection_qty, String good_qty, String remark);

	// 삭제에 필요한 구성
	// 검사 번호만 필요
	int _dao_delete_Inspection(String[] insp_id);

	// 감사 상세 목록
	InspectionDTO _dao_Insepection_detail(String insp_id, String insp_date, String prod_id, String emp_id,
			String insp_type, String result, String inspection_qty, String good_qty, String remark);

	// 검사 수정
	int _dao_update_Inspection(String insp_id, String insp_date, String insp_type, String result, String inspection_qty,
			String good_qty, String remark);

	// 불량 목록
	List<DefectDTO> _dao_select_Defect(String startDate, String endDate, String searchType, String keyword);

	// 불량 등록
	int _dao_insert_defect(String defect_date, String insp_id, String defect_id, String defect_qty, String remark);

	// 불량 모달 옵션
	List<DefectDTO> _dao_select_Defect_option();

	// 불량 삭제
	int _dao_delete_defect(String[] defect_list_id);

	// 불량 상세 목록
	DefectDTO _dao_select_Defect_detail(String defect_list_id);

	//불량 업데이트
	int _dao_update_Defect(String defect_list_id, String defect_date, String defect_id, String defect_qty,
			String remark);
}
