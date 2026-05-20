package kr.or.saeroi.dao;

import java.util.List;

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

}
