package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;

public interface ChartDAO {
	public List<Map<String, Object>> chartday(String searchType, String searchItem);
	public List<Map<String, Object>> itemList();
	
	// 대시보드 차트로 인해 하위 내용 추가
	public List<Map<String, Object>> dashboardProductionTrend();
	public Map<String, Object> dashboardProductionSummary();
	
	// 대시보드 불량 추이 차트로 인해 하위 내용 추가 
	public List<Map<String, Object>> dashboardDefectTrend();
	public Map<String, Object> dashboardDefectSummary();
}
