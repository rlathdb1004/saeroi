package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.InspectionDTO;

public interface QualityDAO {
    // 검사 목록 가져오기
    List<InspectionDTO> _dao_select_Inspection(String startDate, String endDate, String searchType, String keyword);

    // 구분 옵션
    List<InspectionDTO> _dao_option_Inspection(String startDate, String endDate, String searchType, int optionPage, int optionSize);
}
