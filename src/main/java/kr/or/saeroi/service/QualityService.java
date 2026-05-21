package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InspectionDTO;

public interface QualityService {
	// 전체 목록
	List<InspectionDTO> _ser_select_Inspection(String startDate, String endDate, String searchType, String keyword);

	// 구분 옵션에 따른 목록
	List<InspectionDTO> _ser_option_Inspection(String startDate, String endDate, String searchType, int optionPage,
			int optionSize);

	// 등록에 필요한 구성
	// insert 실행 결과는 int
	int _ser_insert_Inspection(String insp_date, String prod_id, String emp_id, String insp_type, String result,
			String inspection_qty, String good_qty, String remark);

	// 삭제에 필요한 구성
	// 검사 번호만 필요
	int _ser_delete_Inspection(String[] insp_id);

	// 검사 상세 목록
	InspectionDTO _ser_select_Inspection_detail(String insp_id, String insp_date, String prod_id, String emp_id,
			String insp_type, String result, String inspection_qty, String good_qty, String remark);

	// 검사 수정
	int _ser_update_Inspection(String insp_id, String insp_date, String insp_type, String result,
	        String inspection_qty, String good_qty, String remark);
}
