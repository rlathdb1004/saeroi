package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InspectionDTO;

public interface QualityService {
	List<InspectionDTO> selectInspection();
}
