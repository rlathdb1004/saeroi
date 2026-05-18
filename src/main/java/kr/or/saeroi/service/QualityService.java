package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InspectionDTO;

public interface QualityService {
	List<InspectionDTO> _ser_select_Inspection(String startDate, String endDate, String searchType, String keyword);
	List<InspectionDTO> _ser_option_Inspection(String startDate,String endDate, String searchType, int optionPage, int optionSize);
}
