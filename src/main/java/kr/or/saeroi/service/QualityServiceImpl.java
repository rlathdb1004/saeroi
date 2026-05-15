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
	public List<InspectionDTO> _dto_select_Inspection(){
		
		System.out.println("result_list 실행 됨");
		List<InspectionDTO> result_list = qualityDAO._dao_select_Inspection();
		return result_list;
	}

}
