package kr.or.saeroi.AiChatbot;

import java.sql.Connection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import dev.langchain4j.agent.tool.Tool;
import kr.or.saeroi.dao.LoginDAO;
import kr.or.saeroi.dao.QualityDAO;
import kr.or.saeroi.dto.InspectionDTO;
import kr.or.saeroi.dto.LoginDTO;

@Component
public class DbTool {

	@Autowired
	private javax.sql.DataSource dataSource;

	@Autowired
	private LoginDAO loginDAO;

	@Autowired
	private QualityDAO qualityDAO;
	
	@Tool("사원 번호로 상세 정보를 조회합니다")
	public String getemp(String empNo) {
		try (Connection conn = dataSource.getConnection()) {
			LoginDTO data = loginDAO.Find_empno(conn, empNo);
//			return (data !=null) ? "해당 조회내용은 없습니다" : data.toString();
			return (data == null) ? "해당 조회내용은 없습니다" : data.toString();
		} catch (Exception e) {
			return "DB 조회 중 오류: " + e.getMessage();
		}
	}
	
	@Tool("품질 검사 내역 목록을 조회합니다. " +
		      "조회 시작일(startDate)과 종료일(endDate)은 반드시 필수(Required)로 입력되어야 합니다. (형식: YYYY-MM-DD) " +
		      "만약 사용자가 검색 조건(searchType)이나 키워드(keyword)를 언급하지 않았다면, 무리해서 채우지 말고 반드시 빈 문자열(\"\")로 넘겨주어야 합니다.")
	public String getQualitySelect(String startDate, String endDate, String searchType, String keyword) {
		try {
			String type = (searchType != null && !searchType.isEmpty()) ? searchType : null; 
			String key = (keyword != null && !keyword.isEmpty()) ? keyword : null; 
			
			List<InspectionDTO> list = qualityDAO._dao_select_Inspection(startDate, endDate, type, key);
			return list.isEmpty() ? "해당 조건으로 조회된 품질 검사 결과가 없습니다." : list.toString();
		} catch (Exception e) {
			return "퀄리티 조회중 오류: " + e.getMessage();
		}
	}
}
