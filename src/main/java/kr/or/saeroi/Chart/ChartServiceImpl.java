package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChartServiceImpl implements ChartService{
	
	@Autowired
	ChartDAO chartDAO;
	
	public List<Map<String, Object>> chartday(String searchType,String searchItem) {
		List<Map<String, Object>> list = chartDAO.chartday(searchType,searchItem);
		return list;
	}
	
	public List<Map<String, Object>> itemList(){
		List<Map<String, Object>> list = chartDAO.itemList();
		return list;
	}
	
	// 대시보드 KPI 핵심 6대 지표를 조회한다.
	@Override
	public Map<String, Object> dashboardKpiSummary() {
		Map<String, Object> map = chartDAO.dashboardKpiSummary();
		return map;
	}
	
	// 대시보드 생산실적 추이 최근 7일 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardProductionTrend() {
		List<Map<String, Object>> list = chartDAO.dashboardProductionTrend();
		return list;
	}

	// 대시보드 생산실적 추이 이번주 요약 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardProductionSummary() {
		Map<String, Object> map = chartDAO.dashboardProductionSummary();
		return map;
	}
	
	// 대시보드 불량 추이 최근 7일 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardDefectTrend() {
		List<Map<String, Object>> list = chartDAO.dashboardDefectTrend();
		return list;
	}

	// 대시보드 불량 추이 이번주 요약 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardDefectSummary() {
		Map<String, Object> map = chartDAO.dashboardDefectSummary();
		return map;
	}
	
	// 대시보드 생산원가 추이 최근 7일 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardCostTrend() {
		List<Map<String, Object>> list = chartDAO.dashboardCostTrend();
		return list;
	}

	// 대시보드 생산원가 추이 이번주 요약 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardCostSummary() {
		Map<String, Object> map = chartDAO.dashboardCostSummary();
		return map;
	}
	
	// 대시보드 설비 가동 현황 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardFacilityStatus() {
		Map<String, Object> map = chartDAO.dashboardFacilityStatus();
		return map;
	}
	
	// 대시보드 LOT 현황 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardLotStatus() {
		Map<String, Object> map = chartDAO.dashboardLotStatus();
		return map;
	}
	
	// 대시보드 현장 이슈 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardIssueStatus() {
		Map<String, Object> map = chartDAO.dashboardIssueStatus();
		return map;
	}
	
	// 생산달성률 상세 모달 주차별 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardAchievementWeek(Map<String, Object> param) {
		List<Map<String, Object>> list = chartDAO.dashboardAchievementWeek(param);
		return list;
	}
	
	// KPI 상세 모달 주차별 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardKpiWeekDetail(Map<String, Object> param) {
		List<Map<String, Object>> list = chartDAO.dashboardKpiWeekDetail(param);
		return list;
	}
	
	// 대시보드 현장 이슈와 LOT 간략 목록을 조회한다.
	@Override
	public List<Map<String, Object>> dashboardDetailList(Map<String, Object> param) {
		List<Map<String, Object>> list = chartDAO.dashboardDetailList(param);
		return list;
	}
	
}
