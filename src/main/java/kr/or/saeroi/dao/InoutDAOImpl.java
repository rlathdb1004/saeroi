package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// 입출고 DAO 구현 클래스
public class InoutDAOImpl implements InoutDAO {

	// DB 연결
	private Connection getConnection() throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url = "jdbc:oracle:thin:@//125.181.132.133:51521/xe";
		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(url, id, pw);
	}

	// 입출고 목록 10개씩 조회
	@Override
	public List<InoutDTO> selectInoutList(int startRow, int endRow) {

		List<InoutDTO> list = new ArrayList<InoutDTO>();

		try {
			Connection conn = getConnection();

			String sql = "";

			sql += " SELECT * ";
			sql += " FROM ( ";
			sql += "     SELECT ROWNUM rnum, A.* ";
			sql += "     FROM ( ";
			sql += "         SELECT ";
			sql += "             MI.INOUT_ID, ";
			sql += "             MI.INOUT_TYPE, ";
			sql += "             MI.MATERIAL_LOT, ";
			sql += "             MI.INOUT_QTY, ";
			sql += "             MI.INOUT_DATE, ";
			sql += "             MI.STATUS, ";
			sql += "             MI.ITEM_ID, ";
			sql += "             MI.DOC_NO, ";
			sql += "             MI.DOC_SEQ, ";
			sql += "             I.ITEM_CODE, ";
			sql += "             I.ITEM_NAME, ";
			sql += "             I.ITEM_TYPE, ";
			sql += "             I.ITEM_UNIT ";
			sql += "         FROM MATERIAL_INOUT MI ";
			sql += "         JOIN ITEM I ";
			sql += "         ON MI.ITEM_ID = I.ITEM_ID ";
			sql += "         ORDER BY MI.INOUT_ID ASC ";
			sql += "     ) A ";
			sql += "     WHERE ROWNUM <= ? ";
			sql += " ) ";
			sql += " WHERE rnum >= ? ";

			PreparedStatement pstmt = conn.prepareStatement(sql);

			// 페이징 끝 번호
			pstmt.setInt(1, endRow);

			// 페이징 시작 번호
			pstmt.setInt(2, startRow);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto = new InoutDTO();

				dto.setInoutId(rs.getInt("INOUT_ID"));
				dto.setInoutType(rs.getString("INOUT_TYPE"));
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(rs.getInt("INOUT_QTY"));
				dto.setInoutDate(rs.getDate("INOUT_DATE"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setItemId(rs.getInt("ITEM_ID"));

				// 새로 추가된 입출고번호 / 순번
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setDocSeq(rs.getInt("DOC_SEQ"));

				// ITEM 테이블에서 가져온 값
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));

				list.add(dto);
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// 전체 개수 조회
	@Override
	public int selectInoutCount() {

		int count = 0;

		try {
			Connection conn = getConnection();

			String sql = " SELECT COUNT(*) FROM MATERIAL_INOUT ";

			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}
}