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
// =========================================================
@Repository
public class WorkerDAOImpl implements WorkerDAO {

	private Connection getConnection()
			throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url =
			"jdbc:oracle:thin:@//125.181.132.133:51521/xe";

		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(url, id, pw);
	}

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

			// =================================================
			// 디버그: DAO로 넘어온 값 확인
			// =================================================
			System.out.println("========== WorkerDAOImpl 조회 ==========");
			System.out.println("DAO empno = " + empno);
			System.out.println("DAO ename = " + ename);

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

			// =================================================
			// 디버그: DAO 조회 결과 수 확인
			// =================================================
			System.out.println("DAO 조회 결과 수 = " + list.size());

			rs.close();
			ps.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}
}