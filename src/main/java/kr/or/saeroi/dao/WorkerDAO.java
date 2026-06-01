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
	// empno + ename 둘 다 전달한다.
	// 팀원 작업지시 코드는 건드리지 않고 작업자 전용 DAO에서만 조회한다.
	// =====================================================
	List<ProductionDTO> selectMyWorkOrderList(
			String empno,
			String ename);


	// =====================================================
	// 작업자 메인 실제 작업지시 QR 조회
	// -----------------------------------------------------
	// 팀원 작업지시 Controller / Mapper는 건드리지 않고,
	// 작업자 전용 DAO에서 로그인한 작업자의 오늘 작업지시 1건을 조회한다.
	// workerMain.jsp에서 이 ORDER_ID로 팀원이 만든
	// /production/workorder/qr?orderId=... QR 이미지를 그대로 사용한다.
	// =====================================================
	ProductionDTO selectTodayQrWorkOrder(
			String empno,
			String ename);

	// =====================================================
	// 로그인 작업자 생산실적 조회
	// 작업자 생산실적 화면에서 본인 실적만 보여주기 위한 메서드다.
	// =====================================================
	List<ProductionDTO> selectMyProductionResultList(
			String empno,
			String ename);
}