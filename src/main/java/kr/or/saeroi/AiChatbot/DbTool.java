package kr.or.saeroi.AiChatbot;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import dev.langchain4j.agent.tool.Tool;
import kr.or.saeroi.Chart.ChartDAO;
import kr.or.saeroi.dao.InoutDAO;
import kr.or.saeroi.dao.LoginDAO;
import kr.or.saeroi.dao.QualityDAO;
import kr.or.saeroi.dto.InoutDTO;
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
	
	@Autowired
	private InoutDAO inoutDAO;
	
	@Autowired
	private ChartDAO chartDAO;
	
	
	@Tool("사원 번호로 상세 정보를 조회합니다")
	public String getemp(String empNo) {
		try (Connection conn = dataSource.getConnection()) {
			LoginDTO data = loginDAO.find_empno(empNo);
//			return (data !=null) ? "해당 조회내용은 없습니다" : data.toString();
			return (data == null) ? "해당 조회내용은 없습니다" : data.toString();
		} catch (Exception e) {
			return "DB 조회 중 오류: " + e.getMessage();
		}
	}
	
	@Tool("품질 검사 내역 목록을 조회합니다. 사용자가 특정 품목이나 검색어를 언급하면 keyword에 넣고, searchType은 '품목명' 등으로 지정합니다. " +
			"만약 날짜를 조회했다면 YYYY-MM-DD의 형식을 지켜줘"+
		      "만약 조회 시작일(startDate)과 종료일(endDate)을 언급하지 않았다면, 무리하게 채우지 말고 반드시 빈 문자열(\"\")로 넘겨주어야 합니다. " +
		      "출력 개수 제한(limit)이나 정렬 방식(orderBy)에 대한 요구사항이 있다면 해당 매개변수에 값을 채워줍니다.")
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
	
	@Tool("입출고 기록을 조회합니다. "+
			"만약 조회 시작일(startDate)과 종료일(endDate)을 언급하지 않았다면, 무리하게 채우지 말고 반드시 빈 문자열(\"\")로 넘겨주어야 합니다." +
			"만약 날짜를 조회했다면 YYYY-MM-DD의 형식을 지켜줘"+
			"사용자가 특정 품목이나 검색어를 언급하면 keyword에 넣고, searchType은 '품목명' 등으로 지정합니다."+
			"사용자가 '출고 기록' 혹은 '입고 기록'을 요청하면 keyword에 넣지 말고, 반드시 searchType에 '구분'을 넣고 keyword에는 '출고' 또는 '입고'를 넣으세요.")
	public String getInOut(
							String searchType,
							String keyword,
							String startDate,
							String endDate) {
		String type = (searchType != null && !searchType.isEmpty()) ? searchType : null; 
		String key = (keyword != null && !keyword.isEmpty()) ? keyword : null; 
		
		List<InoutDTO> list = inoutDAO.selectInoutList(type, key,startDate,endDate);
		return list.isEmpty() ? "해당 조건으로 조회된 입출고 기록이 없습니다." :list.toString();
	}
	
	@Tool("일일 주일 월별 년간 계획일자에 따른 생산계획수량 불량수량 작업량을 조회합니다 "+
			"일수까지 물어본다면 구분(sarchType)을 day로 넣어주고"+
			"년도만 물어보면 구분(sarchType)을 year로 넣어주는데" +
			"이용자가 합을 물어본다면  year_sum 평균을 물어본다면 uear_avg를 넣고 기본은 year_sum이야"+
			"이용자가 '어제', '오늘' 혹은 '특정 날짜'를 언급하면, 분석된 날짜를 반드시 today 매개변수에 YYYY-MM-DD 형식으로 넣어주어야 합니다." 
			
			)
	public String getChart(String searchType, String today, String searchItem) {
		
		String type = (searchType != null && !searchType.isEmpty()) ? searchType : null; 
		
		List<Map<String, Object>> list = chartDAO.chartday(searchType,searchItem);
		return list.isEmpty() ? "해당 날짜(" + today + ")로 조회된 리포트 기록이 없습니다." :list.toString();
	}
}
