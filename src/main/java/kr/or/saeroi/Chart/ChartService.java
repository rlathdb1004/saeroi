package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;

public interface ChartService {

	public List<Map<String, Object>> chartday(String searchType,String searchItem);
	public List<Map<String, Object>> itemList();
}
