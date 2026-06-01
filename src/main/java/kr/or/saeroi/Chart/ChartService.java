package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;



public interface ChartService {

	public List<Map<String, Object>> chartday(String searchType,String searchItem);
	public List<Map<String, Object>> itemList();
	
	// 대시보드 KPI 핵심 6대 지표를 조회한다.
	public Map<String, Object> dashboardKpiSummary();

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
	
	//대시보드 LOT 현황 데이터를 조회한다.
	public Map<String, Object> dashboardLotStatus();
	
	//대시보드 긴급이슈
	public Map<String, Object> dashboardIssueStatus();
	
	// 생산달성률 상세 모달 주차별 데이터를 조회한다.
	public List<Map<String, Object>> dashboardAchievementWeek(Map<String, Object> param);
	
	// KPI 상세 모달 주차별 데이터를 조회한다.
	public List<Map<String, Object>> dashboardKpiWeekDetail(Map<String, Object> param);
	
	// 대시보드 현장 이슈와 LOT 간략 목록을 조회한다.
	public List<Map<String, Object>> dashboardDetailList(Map<String, Object> param);
	
}
