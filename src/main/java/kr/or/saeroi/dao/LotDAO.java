package kr.or.saeroi.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.LotDTO;

// LOT 이력추적 DAO이다.
@Repository
public class LotDAO {

	// MyBatis 실행 객체이다.
	@Autowired
	private SqlSessionTemplate sqlSession;

	// LotMapper.xml의 namespace와 반드시 동일해야 한다.
	private static final String NAMESPACE =
			"kr.or.saeroi.mapper.LotMapper.";

	// LOT 이력 목록 총 건수를 조회한다.
	public int selectLotHistoryCount(LotDTO lotDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectLotHistoryCount",
				lotDTO);
	}

	// LOT 이력 목록을 조회한다.
	public List<LotDTO> selectLotHistoryList(LotDTO lotDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectLotHistoryList",
				lotDTO);
	}

	// LOT 이력 상세 정보를 조회한다.
	public LotDTO selectLotHistoryDetail(Integer orderId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectLotHistoryDetail",
				orderId);
	}
}