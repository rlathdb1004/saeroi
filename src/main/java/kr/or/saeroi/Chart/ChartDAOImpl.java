package kr.or.saeroi.Chart;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChartDAOImpl implements ChartDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	public List<Map<String, Object>> chartday(String searchType,String searchItem){
		Map<String, Object> paramMap = new HashMap<>();
		System.out.println(searchItem);		
		paramMap.put("searchType", searchType);
	    paramMap.put("searchItem", searchItem);
	    
		List<Map<String, Object>> list = sqlSession.selectList("mapper.chart.sleect_day_data",paramMap);
	System.out.println("doalist"+list);
		return list;
	};
	
	public List<Map<String, Object>> itemList(){
		List<Map<String, Object>> list = sqlSession.selectList("mapper.chart.sleect_item");
		
		return list;
	}
	
	// 대시보드 KPI 핵심 6대 지표를 조회한다.
	@Override
	public Map<String, Object> dashboardKpiSummary() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_kpi_summary");

		return map;
	}
	
	// 대시보드 생산실적 추이 최근 7일 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardProductionTrend() {
		List<Map<String, Object>> list =
				sqlSession.selectList("mapper.chart.select_dashboard_production_trend");

		return list;
	}

	// 대시보드 생산실적 추이 이번주 요약 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardProductionSummary() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_production_summary");

		return map;
	}
	
	// 대시보드 불량 추이 최근 7일 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardDefectTrend() {
		List<Map<String, Object>> list =
				sqlSession.selectList("mapper.chart.select_dashboard_defect_trend");

		return list;
	}

	// 대시보드 불량 추이 이번주 요약 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardDefectSummary() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_defect_summary");

		return map;
	}
	
	// 대시보드 생산원가 추이 최근 7일 데이터를 조회한다.
	@Override
	public List<Map<String, Object>> dashboardCostTrend() {
		List<Map<String, Object>> list =
				sqlSession.selectList("mapper.chart.select_dashboard_cost_trend");

		return list;
	}

	// 대시보드 생산원가 추이 이번주 요약 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardCostSummary() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_cost_summary");

		return map;
	}
	
	// 대시보드 설비 가동 현황 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardFacilityStatus() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_facility_status");

		return map;
	}
	
	// 대시보드 LOT 현황 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardLotStatus() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_lot_status");

		return map;
	}
	
	// 대시보드 현장 이슈 데이터를 조회한다.
	@Override
	public Map<String, Object> dashboardIssueStatus() {
		Map<String, Object> map =
				sqlSession.selectOne("mapper.chart.select_dashboard_issue_status");

		return map;
	}
	
}
