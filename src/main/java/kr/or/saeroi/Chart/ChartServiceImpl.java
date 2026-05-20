package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChartServiceImpl implements ChartService{
	
	@Autowired
	ChartDAO chartDAO;
	
	public List<Map<String, Object>> chartday(String searchType) {
		List<Map<String, Object>> list = chartDAO.chartday(searchType);
		return list;
	}
	
}
