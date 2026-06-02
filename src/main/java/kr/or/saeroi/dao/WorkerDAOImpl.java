package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ProductionDTO;

// =========================================================
// 작업자 전용 DAO 구현 클래스
// 팀원 ProductionMapper.xml 안 건드림
// 로그인한 작업자 데이터만 조회
// =========================================================
@Repository
public class WorkerDAOImpl implements WorkerDAO {

	// =====================================================
	// DB 연결
	// =====================================================
	private Connection getConnection()
			throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url =
			"jdbc:oracle:thin:@//125.181.132.133:51521/xe";

		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(url, id, pw);
	}

	// =====================================================
	// 로그인한 작업자 작업지시 조회
	// =====================================================
	@Override
	public List<ProductionDTO> selectMyWorkOrderList(
			String empno,
			String ename) {

		List<ProductionDTO> list =
			new ArrayList<ProductionDTO>();

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     WO.ORDER_ID, ";
			sql += "     WO.PROD_PLAN_ID, ";
			sql += "     WO.LINE_ID, ";
			sql += "     WO.EMP_ID, ";
			sql += "     WO.PRODUCT_LOT, ";
			sql += "     WO.ORDER_QTY, ";
			sql += "     TO_CHAR(WO.ORDER_DATE, 'YYYY-MM-DD') AS ORDER_DATE, ";
			sql += "     WO.REMARK, ";
			sql += "     WO.DOC_NO, ";
			sql += "     WO.DOC_SEQ, ";
			sql += "     I.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT, ";
			sql += "     L.LINE_CODE, ";
			sql += "     L.LINE_NAME, ";
			sql += "     E.EMPNO, ";
			sql += "     E.ENAME, ";
			sql += "     E.DEPT, ";
			sql += "     E.JOB, ";
			sql += "     NVL(P.PROD_STATUS, '대기') AS PROD_STATUS ";
			sql += " FROM WORK_ORDER WO ";
			sql += " JOIN PRODUCTION_PLAN PP ";
			sql += "   ON WO.PROD_PLAN_ID = PP.PROD_PLAN_ID ";
			sql += " JOIN ITEM I ";
			sql += "   ON PP.ITEM_ID = I.ITEM_ID ";
			sql += " LEFT JOIN LINE L ";
			sql += "   ON WO.LINE_ID = L.LINE_ID ";
			sql += " LEFT JOIN EMP E ";
			sql += "   ON WO.EMP_ID = E.EMP_ID ";
			sql += " LEFT JOIN ( ";
			sql += "     SELECT ";
			sql += "         P1.ORDER_ID, ";
			sql += "         P1.PROD_STATUS ";
			sql += "     FROM PRODUCTION P1 ";
			sql += "     JOIN ( ";
			sql += "         SELECT ";
			sql += "             ORDER_ID, ";
			sql += "             MAX(PROD_ID) AS PROD_ID ";
			sql += "         FROM PRODUCTION ";
			sql += "         GROUP BY ORDER_ID ";
			sql += "     ) PM ";
			sql += "       ON P1.ORDER_ID = PM.ORDER_ID ";
			sql += "      AND P1.PROD_ID = PM.PROD_ID ";
			sql += " ) P ";
			sql += "   ON WO.ORDER_ID = P.ORDER_ID ";
			sql += " WHERE ( ";
			sql += "     TRIM(E.EMPNO) = TRIM(?) ";
			sql += "     OR TRIM(E.ENAME) = TRIM(?) ";
			sql += " ) ";
			sql += " ORDER BY WO.ORDER_DATE DESC, WO.ORDER_ID DESC ";

			PreparedStatement ps =
				conn.prepareStatement(sql);

			ps.setString(1, empno);
			ps.setString(2, ename);

			ResultSet rs =
				ps.executeQuery();

			while (rs.next()) {

				ProductionDTO dto =
					new ProductionDTO();

				dto.setOrderId(rs.getInt("ORDER_ID"));
				dto.setProdPlanId(rs.getInt("PROD_PLAN_ID"));
				dto.setLineId(rs.getInt("LINE_ID"));
				dto.setEmpId(rs.getInt("EMP_ID"));
				dto.setProductLot(rs.getString("PRODUCT_LOT"));
				dto.setOrderQty(rs.getInt("ORDER_QTY"));
				dto.setOrderDate(rs.getString("ORDER_DATE"));
				dto.setRemark(rs.getString("REMARK"));
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setDocSeq(rs.getInt("DOC_SEQ"));

				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));

				dto.setLineCode(rs.getString("LINE_CODE"));
				dto.setLineName(rs.getString("LINE_NAME"));

				dto.setEmpno(rs.getString("EMPNO"));
				dto.setEname(rs.getString("ENAME"));
				dto.setDept(rs.getString("DEPT"));
				dto.setJob(rs.getString("JOB"));

				dto.setProdStatus(rs.getString("PROD_STATUS"));

				list.add(dto);
			}

			rs.close();
			ps.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}


	// =====================================================
	// 작업자 메인 실제 작업지시 QR 조회
	// -----------------------------------------------------
	// 팀원 ProductionController / ProductionService는 수정하지 않는다.
	// 여기서는 로그인한 작업자의 오늘 작업지시 중 최신 1건만 조회한다.
	//
	// 화면에서는 ORDER_ID를 이용해서 기존 팀원 QR 생성 URL인
	// /production/workorder/qr?orderId=ORDER_ID 를 img src로 사용한다.
	//
	// QR을 직접 누르거나 테스트 버튼을 누르면
	// 작업자가 바로 생산실적 등록 화면으로 이동할 수 있도록
	// WORK_ORDER.QR_URL이 있으면 QR_URL을 사용하고,
	// 없으면 Controller에서 기본 이동 URL을 만들어 사용한다.
	// =====================================================
	@Override
	public ProductionDTO selectTodayQrWorkOrder(
			String empno,
			String ename) {

		ProductionDTO dto =
			null;

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT * ";
			sql += " FROM ( ";
			sql += "     SELECT ";
			sql += "         WO.ORDER_ID, ";
			sql += "         WO.PROD_PLAN_ID, ";
			sql += "         WO.LINE_ID, ";
			sql += "         WO.EMP_ID, ";
			sql += "         WO.PRODUCT_LOT, ";
			sql += "         WO.ORDER_QTY, ";
			sql += "         TO_CHAR(WO.ORDER_DATE, 'YYYY-MM-DD') AS ORDER_DATE, ";
			sql += "         WO.REMARK, ";
			sql += "         WO.DOC_NO, ";
			sql += "         WO.DOC_SEQ, ";
			sql += "         WO.QR_URL, ";
			sql += "         WO.QR_IMAGE_PATH, ";
			sql += "         I.ITEM_ID, ";
			sql += "         I.ITEM_CODE, ";
			sql += "         I.ITEM_NAME, ";
			sql += "         I.ITEM_TYPE, ";
			sql += "         I.ITEM_UNIT, ";
			sql += "         L.LINE_CODE, ";
			sql += "         L.LINE_NAME, ";
			sql += "         E.EMPNO, ";
			sql += "         E.ENAME, ";
			sql += "         E.DEPT, ";
			sql += "         E.JOB ";
			sql += "     FROM WORK_ORDER WO ";
			sql += "     JOIN PRODUCTION_PLAN PP ";
			sql += "       ON WO.PROD_PLAN_ID = PP.PROD_PLAN_ID ";
			sql += "     JOIN ITEM I ";
			sql += "       ON PP.ITEM_ID = I.ITEM_ID ";
			sql += "     LEFT JOIN LINE L ";
			sql += "       ON WO.LINE_ID = L.LINE_ID ";
			sql += "     LEFT JOIN EMP E ";
			sql += "       ON WO.EMP_ID = E.EMP_ID ";
			sql += "     WHERE ( ";
			sql += "         TRIM(E.EMPNO) = TRIM(?) ";
			sql += "         OR TRIM(E.ENAME) = TRIM(?) ";
			sql += "     ) ";
			sql += "     AND TRUNC(WO.ORDER_DATE) = TRUNC(SYSDATE) ";
			sql += "     ORDER BY WO.ORDER_ID DESC ";
			sql += " ) ";
			sql += " WHERE ROWNUM = 1 ";

			PreparedStatement ps =
				conn.prepareStatement(sql);

			ps.setString(1, empno);
			ps.setString(2, ename);

			ResultSet rs =
				ps.executeQuery();

			if (rs.next()) {

				dto =
					new ProductionDTO();

				dto.setOrderId(rs.getInt("ORDER_ID"));
				dto.setProdPlanId(rs.getInt("PROD_PLAN_ID"));
				dto.setLineId(rs.getInt("LINE_ID"));
				dto.setEmpId(rs.getInt("EMP_ID"));
				dto.setProductLot(rs.getString("PRODUCT_LOT"));
				dto.setOrderQty(rs.getInt("ORDER_QTY"));
				dto.setOrderDate(rs.getString("ORDER_DATE"));
				dto.setRemark(rs.getString("REMARK"));
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setDocSeq(rs.getInt("DOC_SEQ"));
				dto.setQrUrl(rs.getString("QR_URL"));
				dto.setQrImagePath(rs.getString("QR_IMAGE_PATH"));

				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));

				dto.setLineCode(rs.getString("LINE_CODE"));
				dto.setLineName(rs.getString("LINE_NAME"));

				dto.setEmpno(rs.getString("EMPNO"));
				dto.setEname(rs.getString("ENAME"));
				dto.setDept(rs.getString("DEPT"));
				dto.setJob(rs.getString("JOB"));
			}

			rs.close();
			ps.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return dto;
	}

	// =====================================================
	// 로그인한 작업자 생산실적 조회
	// 생산실적은 PRODUCTION → WORK_ORDER → EMP 기준으로 연결
	// =====================================================
	@Override
	public List<ProductionDTO> selectMyProductionResultList(
			String empno,
			String ename) {

		List<ProductionDTO> list =
			new ArrayList<ProductionDTO>();

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     P.PROD_ID, ";
			sql += "     P.ORDER_ID, ";
			sql += "     TO_CHAR(P.PROD_DATE, 'YYYY-MM-DD') AS PROD_DATE, ";
			sql += "     P.PROD_QTY, ";
			sql += "     P.LOSS_QTY, ";
			sql += "     P.PROD_STATUS, ";
			sql += "     WO.EMP_ID, ";
			sql += "     WO.PRODUCT_LOT, ";
			sql += "     WO.ORDER_QTY, ";
			sql += "     I.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT, ";
			sql += "     E.EMPNO, ";
			sql += "     E.ENAME, ";
			sql += "     E.DEPT, ";
			sql += "     E.JOB ";
			sql += " FROM PRODUCTION P ";
			sql += " JOIN WORK_ORDER WO ";
			sql += "   ON P.ORDER_ID = WO.ORDER_ID ";
			sql += " JOIN PRODUCTION_PLAN PP ";
			sql += "   ON WO.PROD_PLAN_ID = PP.PROD_PLAN_ID ";
			sql += " JOIN ITEM I ";
			sql += "   ON PP.ITEM_ID = I.ITEM_ID ";
			sql += " LEFT JOIN EMP E ";
			sql += "   ON WO.EMP_ID = E.EMP_ID ";

			// =================================================
			// 핵심 WHERE 조건
			// 로그인한 작업자의 사원번호 또는 이름과 일치하는 생산실적만 조회
			// =================================================
			sql += " WHERE ( ";
			sql += "     TRIM(E.EMPNO) = TRIM(?) ";
			sql += "     OR TRIM(E.ENAME) = TRIM(?) ";
			sql += " ) ";

			sql += " ORDER BY P.PROD_DATE DESC, P.PROD_ID DESC ";

			PreparedStatement ps =
				conn.prepareStatement(sql);

			ps.setString(1, empno);
			ps.setString(2, ename);

			ResultSet rs =
				ps.executeQuery();

			while (rs.next()) {

				ProductionDTO dto =
					new ProductionDTO();

				dto.setProdId(rs.getInt("PROD_ID"));

				// =================================================
				// 작업자 생산실적 실적번호 표시 보정
				// -------------------------------------------------
				// 관리자 화면은 팀원 기존 조회 로직을 타기 때문에 실적번호가 보이지만,
				// 작업자 화면은 WorkerDAOImpl.selectMyProductionResultList()를 타므로
				// 여기서 화면 표시용 실적번호를 직접 세팅한다.
				//
				// 팀원 ProductionController / Service / JSP는 수정하지 않는다.
				// DTO의 기존 docNo / docSeq 필드만 사용해서 화면에서 실적번호가 비지 않게 한다.
				// =================================================
				dto.setDocNo(
					makeWorkerProdDocNo(
						rs.getString("PROD_DATE"),
						rs.getInt("PROD_ID")));

				dto.setDocSeq(rs.getInt("PROD_ID"));

				dto.setOrderId(rs.getInt("ORDER_ID"));
				dto.setProdDate(rs.getString("PROD_DATE"));
				dto.setProdQty(rs.getInt("PROD_QTY"));
				dto.setLossQty(rs.getInt("LOSS_QTY"));
				dto.setProdStatus(rs.getString("PROD_STATUS"));

				dto.setEmpId(rs.getInt("EMP_ID"));
				dto.setProductLot(rs.getString("PRODUCT_LOT"));
				dto.setOrderQty(rs.getInt("ORDER_QTY"));

				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));

				dto.setEmpno(rs.getString("EMPNO"));
				dto.setEname(rs.getString("ENAME"));
				dto.setDept(rs.getString("DEPT"));
				dto.setJob(rs.getString("JOB"));

				list.add(dto);
			}

			rs.close();
			ps.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}
	// =====================================================
	// 작업자 생산실적 화면용 실적번호 생성
	// -----------------------------------------------------
	// 팀원 생산실적 등록 / 조회 코드는 건드리지 않는다.
	// 작업자 전용 DAO에서 조회한 생산실적은 실적번호 표시 값이 비어있을 수 있어서
	// PROD_DATE + PROD_ID 기준으로 화면 표시용 번호를 만들어 DTO에 넣는다.
	//
	// 예)
	// PROD_DATE : 2026-06-01
	// PROD_ID   : 1
	// 화면 표시 : PR-20260601-0001
	// =====================================================
	private String makeWorkerProdDocNo(
			String prodDate,
			int prodId) {

		String dateText = "";

		if (prodDate != null) {

			dateText =
				prodDate.replace("-", "").trim();
		}

		if (dateText.equals("")) {

			dateText = "00000000";
		}

		return "PR-"
				+ dateText
				+ "-"
				+ String.format("%04d", prodId);
	}

}