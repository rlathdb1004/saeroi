package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;

public interface QualityService {
	// 검사 목록
	// 검색조건에 맞는 전체목록을 가져옴 -> 가져온 값들을 컨트롤러에서 페이지 자름
	// 그러므로 여기엔 페이징 관련 전달인자가 없음
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
	int _ser_update_Inspection(String insp_id, String insp_date, String insp_type, String result, String inspection_qty,
			String good_qty, String remark);

	// 불량 목록
	List<DefectDTO> _ser_select_Defect(String startDate, String endDate, String searchType, String keyword);

	// 불량 등록
	int _ser_add_defect(String defect_date, String insp_id, String defect_id, String defect_qty, String remark);

	// 불량 모달 옵션
	List<DefectDTO> _ser_select_Defect_option();

	// 불랑 삭제
	int _ser_delete_defect(String[] defect_list_id);

	// 불량 상세
	DefectDTO _ser_select_Defect_detail(String defect_list_id);

	//불량 업데이트
	int _ser_update_Defect(String defect_list_id, String defect_date, String defect_id, String defect_qty,
			String remark);
	
	// 불량 조치 내역 조회
	List<DefectDTO> _ser_select_Defect_action(String defect_list_id);

	// 불량 조치 내역 등록
	int _ser_insert_Defect_action(String defect_list_id, String action_date, String emp_id, String action_content);

	//불량관리 상세 모달 emp옵션
	List<DefectDTO> _ser_select_Defect_action_emp_option(String dept);
}
