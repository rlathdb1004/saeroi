package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.InspectionDTO;

//DAO 인터페이스 기능들을 mybatis와 연결
@Repository
public class QualityDAOImpl implements QualityDAO{

	@Autowired
	SqlSession sqlSession;
	
	@Override
	public List<InspectionDTO> _dao_select_Inspection(String startDate, String endDate, String searchType, String keyword) {
		//mybatis에 시작일 종료일 보내기(DB 조회를 위해서)
		 Map<String, String> param = new HashMap<String, String>();
		 param.put("startDate", startDate);
		 param.put("endDate", endDate);
		 param.put("searchType", searchType);
		param.put("keyword", keyword);
		 
		//mybatis 도구 sqlSession, 여러줄 실행
		List<InspectionDTO> inspection_List = sqlSession.selectList("mapper.quality._select_Inspection", param);
		System.out.println("inspection_List 실행"+inspection_List);
		
		return inspection_List;
	}
	//구분 옵션
	public List<String> _dao_option_Inspection(String startDate,String endDate, String searchType, int optionPage, int optionSize){
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("searchType", searchType);
		param.put("optionPage", optionPage);
		param.put("optionSize", optionSize);
		
		List<String> inspection_List_option = sqlSession.selectList("mapper.quality._select_Inspection_option",param);
		
		return inspection_List_option;
		
	}
	
}
