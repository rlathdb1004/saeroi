package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.QualityDAO;
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
}
