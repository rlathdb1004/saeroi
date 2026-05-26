package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

		System.out.println("result_list 실행 됨");
		List<InspectionDTO> result_list = qualityDAO._dao_select_Inspection(startDate, endDate, searchType, keyword);
		return result_list;
	}

	@Override
	// 구분 옵션 메서드
	public List<InspectionDTO> _ser_option_Inspection(String startDate, String endDate, String searchType,
			int optionPage, int optionSize) {

		List<InspectionDTO> result_list_opiton = qualityDAO._dao_option_Inspection(startDate, endDate, searchType,
				optionPage, optionSize);
		System.out.println("result_list_opiton 실행 됨");
		return result_list_opiton;

	}

	// 등록에 필요한 구성
	// insert 실행 결과는 int
	@Override
	public int _ser_insert_Inspection(String insp_date, String prod_id, String emp_id, String insp_type, String result,
			String inspection_qty, String good_qty, String remark) {

		int insert_list = qualityDAO._dao_insert_Inspection(insp_date, prod_id, emp_id, insp_type, result,
				inspection_qty, good_qty, remark);

		return insert_list;
	}

	// 삭제에 필요한 구성
	// 검사 번호만 필요
	@Override
	public int _ser_delete_Inspection(String[] insp_id) {

		int delete_list = qualityDAO._dao_delete_Inspection(insp_id);

		return delete_list;
	}

	// 검사 상세 목록
	@Override
	public InspectionDTO _ser_select_Inspection_detail(String insp_id, String insp_date, String prod_id, String emp_id,
			String insp_type, String result, String inspection_qty, String good_qty, String remark) {

		InspectionDTO detail_result = qualityDAO._dao_Insepection_detail(insp_id, insp_date, prod_id, emp_id, insp_type,
				result, inspection_qty, good_qty, remark);
		return detail_result;
	}

	// 검사 수정
	@Override
	public int _ser_update_Inspection(String insp_id, String insp_date, String insp_type, String result,
			String inspection_qty, String good_qty, String remark) {

		int update_result = qualityDAO._dao_update_Inspection(insp_id, insp_date, insp_type, result, inspection_qty,
				good_qty, remark);

		return update_result;
	}

	// 불량 목록
	@Override
	public List<DefectDTO> _ser_select_Defect(String startDate, String endDate, String searchType, String keyword) {

		System.out.println("defect_list 실행 됨");

		List<DefectDTO> defect_list = qualityDAO._dao_select_Defect(startDate, endDate, searchType, keyword);

		return defect_list;
	}

	// 불량 등록
	@Override
	public int _ser_add_defect(String defect_date, String insp_id, String defect_id, String defect_qty, String remark) {

		int defect_insert = qualityDAO._dao_insert_defect(defect_date, insp_id, defect_id, defect_qty, remark);

		return defect_insert;
	}

	// 불량 모달 옵션
	@Override
	public List<DefectDTO> _ser_select_Defect_option() {

		List<DefectDTO> defect_option_list = qualityDAO._dao_select_Defect_option();

		return defect_option_list;
	}

	@Override
	public int _ser_delete_defect(String[] defect_list_id) {

		int delete_result = qualityDAO._dao_delete_defect(defect_list_id);

		return delete_result;
	}
	//불량 상세 목록
	@Override
	public DefectDTO _ser_select_Defect_detail(String defect_list_id) {

		DefectDTO defect_detail = qualityDAO._dao_select_Defect_detail(defect_list_id);

		return defect_detail;
	}
	
	//불량 업데이트
	@Override
	public int _ser_update_Defect(String defect_list_id, String defect_date, String defect_id, String defect_qty,
			String remark) {

		int defect_update = qualityDAO._dao_update_Defect(defect_list_id, defect_date, defect_id, defect_qty, remark);

		return defect_update;
	}
	
	// 불량 조치 내역 조회
	@Override
	public List<DefectDTO> _ser_select_Defect_action(String defect_list_id) {

		List<DefectDTO> defect_action_list =
				qualityDAO._dao_select_Defect_action(defect_list_id);

		return defect_action_list;
	}

	// 불량 조치 내역 등록
	@Override
	public int _ser_insert_Defect_action(String defect_list_id, String action_date, String emp_id,
			String action_content) {

		int insert_result =
				qualityDAO._dao_insert_Defect_action(defect_list_id, action_date, emp_id, action_content);

		return insert_result;
	}
}
