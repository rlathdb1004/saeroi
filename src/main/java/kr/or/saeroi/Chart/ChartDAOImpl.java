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
}
