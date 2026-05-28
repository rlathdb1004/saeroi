package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.ProductionDTO;

// =========================================================
// 작업자 전용 DAO
// 팀원 ProductionMapper.xml 안 건드리고
// 작업자 본인 작업지시만 조회
// =========================================================
public interface WorkerDAO {

	// =====================================================
	// 로그인 작업자 작업지시 조회
	// empno + ename 둘 다 전달
	// =====================================================
	List<ProductionDTO> selectMyWorkOrderList(
			String empno,
			String ename);
}