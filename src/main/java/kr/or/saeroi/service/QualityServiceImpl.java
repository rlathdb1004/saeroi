package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import kr.or.saeroi.dao.QualityDAO;
import kr.or.saeroi.dto.InspectionDTO;

public class QualityServiceImpl implements QualityService {
	@Autowired
	QualityDAO qualityDAO;

	@Override
	public List<InspectionDTO> selectInspection(){
		
		System.out.println("result_list 실행 됨");
		List<InspectionDTO> result_list = qualityDAO.selectInspection();
		return result_list;
	}

}
