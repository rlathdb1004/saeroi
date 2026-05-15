package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.InspectionDTO;
public interface QualityDAO {
	//검사 목록 가져오기
	List<InspectionDTO> selectInspection();
	
}
