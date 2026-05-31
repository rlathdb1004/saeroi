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
	
}
