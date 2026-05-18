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
	public List<InspectionDTO> _ser_select_Inspection(String startDate, String endDate, String searchType, String keyword) {
		
		System.out.println("result_list 실행 됨");
		List<InspectionDTO> result_list = qualityDAO._dao_select_Inspection(startDate, endDate, searchType, keyword);
		return result_list;
	}
	@Override
	//	구분 옵션 메서드
	public List<String> _ser_option_Inspection(String startDate,String endDate, String searchType, int optionPage, int optionSize){
		
		List<String> result_list_opiton = qualityDAO._dao_option_Inspection(startDate, endDate, searchType, optionPage, optionSize);
		System.out.println("result_list_opiton 실행 됨");
		return result_list_opiton;
		
	}

}
