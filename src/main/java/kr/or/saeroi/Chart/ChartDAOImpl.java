package kr.or.saeroi.Chart;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChartDAOImpl implements ChartDAO{
	
	@Autowired
	SqlSession sqlSession;
	
	public List<Map<String, Object>> chartday(String searchType){
		
		List<Map<String, Object>> list = sqlSession.selectList("mapper.chart.sleect_day_data",searchType);
	
		return list;
	};
}
