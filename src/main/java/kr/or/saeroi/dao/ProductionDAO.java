package kr.or.saeroi.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ProductionDTO;

// 생산관리 DAO이다.
// DAO는 Controller나 Service에서 직접 SQL을 작성하지 않도록 MyBatis Mapper를 호출하는 역할만 한다.
@Repository
public class ProductionDAO {

	// MyBatis 실행 객체이다.
	@Autowired
	private SqlSessionTemplate sqlSession;

	// ProductionMapper.xml의 namespace와 반드시 동일해야 한다.
	private static final String NAMESPACE =
			"kr.or.saeroi.mapper.ProductionMapper.";

	// 생산계획 목록 총 건수를 조회한다.
	public int selectProductionPlanCount(ProductionDTO productionDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionPlanCount",
				productionDTO);
	}

	// 생산계획 목록을 조회한다.
	public List<ProductionDTO> selectProductionPlanList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectProductionPlanList",
				productionDTO);
	}

	// 검색 select box에 사용할 품목 구분 목록을 조회한다.
	public List<String> selectItemTypeList() {

		return sqlSession.selectList(
				NAMESPACE + "selectItemTypeList");
	}
	
	// 생산계획 상세 정보를 조회한다.
	public ProductionDTO selectProductionPlanDetail(Integer prodPlanId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionPlanDetail",
				prodPlanId);
	}

	// 생산계획 정보를 수정한다.
	public int updateProductionPlan(ProductionDTO productionDTO) {

		return sqlSession.update(
				NAMESPACE + "updateProductionPlan",
				productionDTO);
	}
}