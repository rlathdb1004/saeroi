package kr.or.saeroi.Chart;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/report")
public class ChartController {
	@Autowired
	ChartService chartService;
	
	@RequestMapping("/productionreport")
	public String Chart() {
		
		return "report/productionreport.tiles";
	}
	
	@RequestMapping("/chart_bar")
	@ResponseBody
	public Map<String, Object> chartday(
			@RequestParam(value="searchType", defaultValue="month")String searchType) {
		Map<String, Object> chartData = new HashMap<>();
		
		List<Map<String, Object>> list = chartService.chartday(searchType);
		chartData.put("chartList", list);
		return chartData;
	}
	
}
