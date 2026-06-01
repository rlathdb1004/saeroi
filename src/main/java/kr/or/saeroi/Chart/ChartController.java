package kr.or.saeroi.Chart;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;



@Controller
@RequestMapping("/report")
public class ChartController {
	@Autowired
	ChartService chartService;

	
	@RequestMapping({"", "/", "/productionreport"})
	public String productionreport(Model model) {
		
		List<Map<String,Object>> item = chartService.itemList();
		model.addAttribute("item", item);
		return "report/productionreport.tiles";
	}

	@RequestMapping("/chart")
	public String Chart(
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size,
			@RequestParam(value="searchType", required=false) String searchType,
			@RequestParam(value="searchItem", required=false) String searchItem,
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			Model model) {
		
		System.out.println("스타트"+startDate);
		System.out.println("엔드"+endDate);
		List<Map<String,Object>> item = chartService.itemList();
		model.addAttribute("item", item);
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchItem", searchItem);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "report/chart.tiles";
	}
	
	
	
	
	@RequestMapping("/chart_bar")
	@ResponseBody
	public Map<String, Object> chartday(
			@RequestParam(value="searchType", defaultValue="month")String searchType,
			@RequestParam(value="searchItem", defaultValue="all")String searchItem
			) {
		Map<String, Object> chartData = new HashMap<>();
		System.out.println("컨트롤"+searchItem);
		List<Map<String, Object>> list = chartService.chartday(searchType,searchItem);
		chartData.put("chartList", list);
		System.out.println("list"+list);
		return chartData;
	}
	
	

}
