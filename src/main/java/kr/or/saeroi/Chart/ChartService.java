package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;



public interface ChartService {

	public List<Map<String, Object>> chartday(String searchType,String searchItem);
	public List<Map<String, Object>> itemList();

	// 대시보드 생산실적 추이 차트로 인해 하위 내용 추가 
	public List<Map<String, Object>> dashboardProductionTrend();
	public Map<String, Object> dashboardProductionSummary();
	
	// 대시보드 불량 추이 차트로 인해 하위 내용 추가 
	public List<Map<String, Object>> dashboardDefectTrend();
	public Map<String, Object> dashboardDefectSummary();
	
	// 대시보드 생산원가 차트로 인해 하위 내용 추가
	public List<Map<String, Object>> dashboardCostTrend();
	public Map<String, Object> dashboardCostSummary();
	
	// 대시보드 설비 가동 차트로 인해 하위 내용 추가
	public Map<String, Object> dashboardFacilityStatus();
}
