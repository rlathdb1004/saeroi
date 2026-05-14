package kr.or.saeroi.dao;

import java.util.List;

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
	public List<InspectionDTO> selectInspection(){
		List<InspectionDTO> inspection_List = null;
		//mybatis 도구 sqlSession, 여러줄 실행
		inspection_List = sqlSession.selectList("mapper.quality._select_Inspection");
		System.out.println("inspection_List 실행"+inspection_List);
		
		
		return inspection_List;
	}
	
	
}
