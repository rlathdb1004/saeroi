package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.InoutDTO;

// =============================================================
// 입출고 DAO 구현 클래스
// =============================================================
@Repository
public class InoutDAOImpl implements InoutDAO {

	private Connection getConnection() throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url =
				"jdbc:oracle:thin:@//125.181.132.133:51521/xe";

		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(
				url,
				id,
				pw);
	}

	@Override
	public List<InoutDTO> selectInoutList(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		String inoutType = "";

		if ("입고".equals(keyword)) {

			inoutType = "MI";
			keyword = "";

		} else if ("출고".equals(keyword)) {

			inoutType = "MO-PROD";
			keyword = "";
		}

		return selectInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);
	}

	@Override
	public List<InoutDTO> selectInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		List<InoutDTO> list =
				new ArrayList<InoutDTO>();

		if ((inoutType == null || inoutType.equals(""))
				&& keyword != null) {

			if ("입고".equals(keyword.trim())) {

				inoutType = "MI";
				keyword = "";

			} else if ("출고".equals(keyword.trim())) {

				inoutType = "MO-PROD";
				keyword = "";
			}
		}

		try {

			Connection conn = getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     MI.INOUT_ID, ";
			sql += "     MI.INOUT_TYPE, ";
			sql += "     MI.MATERIAL_LOT, ";
			sql += "     MI.INOUT_QTY, ";
			sql += "     MI.INOUT_DATE, ";
			sql += "     MI.REMARK, ";
			sql += "     MI.STATUS, ";
			sql += "     MI.ITEM_ID, ";
			sql += "     MI.DOC_NO, ";
			sql += "     MI.DOC_SEQ, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";

			sql += " FROM MATERIAL_INOUT MI ";

			sql += " JOIN ITEM I ";
			sql += " ON MI.ITEM_ID = I.ITEM_ID ";

			sql += " WHERE 1 = 1 ";

			if (inoutType != null
					&& !inoutType.equals("")) {

				sql += " AND MI.INOUT_TYPE = ? ";
			}

			if (keyword != null
					&& !keyword.trim().equals("")) {

				keyword = keyword.trim();

				boolean isNumber = false;

				try {
					Integer.parseInt(keyword);
					isNumber = true;
				} catch (Exception e) {
					isNumber = false;
				}

				if ("itemCode".equals(searchType)) {

					sql += " AND I.ITEM_CODE LIKE ? ";

				} else if ("itemName".equals(searchType)) {

					sql += " AND I.ITEM_NAME LIKE ? ";

				} else if (isNumber) {

					sql += " AND MI.INOUT_QTY = ? ";

				} else {

					sql += " AND ( ";
					sql += "     I.ITEM_CODE LIKE ? ";
					sql += "     OR I.ITEM_NAME LIKE ? ";
					sql += "     OR I.ITEM_UNIT LIKE ? ";
					sql += "     OR MI.DOC_NO LIKE ? ";
					sql += "     OR MI.MATERIAL_LOT LIKE ? ";
					sql += "     OR MI.REMARK LIKE ? ";
					sql += "     OR TO_CHAR(MI.INOUT_DATE, 'YYYY-MM-DD') LIKE ? ";
					sql += "     OR CASE ";
					sql += "            WHEN MI.INOUT_TYPE = 'MI' THEN '입고' ";
					sql += "            WHEN MI.INOUT_TYPE = 'MO-PROD' THEN '출고' ";
					sql += "            ELSE MI.INOUT_TYPE ";
					sql += "        END LIKE ? ";
					sql += "     OR CASE ";
					sql += "            WHEN I.ITEM_TYPE = 'FG' THEN '완제품' ";
					sql += "            WHEN I.ITEM_TYPE = 'RM' THEN '원자재' ";
					sql += "            WHEN I.ITEM_TYPE = 'SM' THEN '부자재' ";
					sql += "            ELSE I.ITEM_TYPE ";
					sql += "        END LIKE ? ";
					sql += " ) ";
				}
			}

			if (startDate != null
					&& !startDate.equals("")) {

				sql += " AND MI.INOUT_DATE >= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') ";
			}

			if (endDate != null
					&& !endDate.equals("")) {

				sql += " AND MI.INOUT_DATE <= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') ";
			}

			sql += " ORDER BY MI.INOUT_ID DESC ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			if (inoutType != null
					&& !inoutType.equals("")) {

				pstmt.setString(idx++, inoutType);
			}

			if (keyword != null
					&& !keyword.trim().equals("")) {

				keyword = keyword.trim();

				boolean isNumber = false;

				try {
					Integer.parseInt(keyword);
					isNumber = true;
				} catch (Exception e) {
					isNumber = false;
				}

				if ("itemCode".equals(searchType)) {

					pstmt.setString(idx++, "%" + keyword + "%");

				} else if ("itemName".equals(searchType)) {

					pstmt.setString(idx++, "%" + keyword + "%");

				} else if (isNumber) {

					pstmt.setInt(idx++, Integer.parseInt(keyword));

				} else {

					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
				}
			}

			if (startDate != null
					&& !startDate.equals("")) {

				pstmt.setString(idx++, startDate);
			}

			if (endDate != null
					&& !endDate.equals("")) {

				pstmt.setString(idx++, endDate);
			}

			ResultSet rs =
					pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto =
						new InoutDTO();

				dto.setInoutId(rs.getInt("INOUT_ID"));
				dto.setInoutType(rs.getString("INOUT_TYPE"));
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(rs.getInt("INOUT_QTY"));
				dto.setInoutDate(rs.getDate("INOUT_DATE"));
				dto.setRemark(rs.getString("REMARK"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setDocSeq(rs.getInt("DOC_SEQ"));
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

	@Override
	public InoutDTO selectInoutDetail(int inoutId) {

		InoutDTO dto = null;

		try {

			Connection conn = getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     MI.INOUT_ID, ";
			sql += "     MI.INOUT_TYPE, ";
			sql += "     MI.MATERIAL_LOT, ";
			sql += "     MI.INOUT_QTY, ";
			sql += "     MI.INOUT_DATE, ";
			sql += "     MI.REMARK, ";
			sql += "     MI.STATUS, ";
			sql += "     MI.ITEM_ID, ";
			sql += "     MI.DOC_NO, ";
			sql += "     MI.DOC_SEQ, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";
			sql += " FROM MATERIAL_INOUT MI ";
			sql += " JOIN ITEM I ";
			sql += " ON MI.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE MI.INOUT_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			pstmt.setInt(1, inoutId);

			ResultSet rs =
					pstmt.executeQuery();

			if (rs.next()) {

				dto = new InoutDTO();

				dto.setInoutId(rs.getInt("INOUT_ID"));
				dto.setInoutType(rs.getString("INOUT_TYPE"));
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(rs.getInt("INOUT_QTY"));
				dto.setInoutDate(rs.getDate("INOUT_DATE"));
				dto.setRemark(rs.getString("REMARK"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setDocSeq(rs.getInt("DOC_SEQ"));
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return dto;
	}

	@Override
	public int updateInout(InoutDTO dto) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " UPDATE MATERIAL_INOUT ";
			sql += " SET ";
			sql += "     INOUT_TYPE = ?, ";
			sql += "     INOUT_QTY = ?, ";
			sql += "     INOUT_DATE = ?, ";
			sql += "     REMARK = ? ";
			sql += " WHERE INOUT_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			pstmt.setString(idx++, dto.getInoutType());
			pstmt.setInt(idx++, dto.getInoutQty());
			pstmt.setDate(idx++, dto.getInoutDate());
			pstmt.setString(idx++, dto.getRemark());
			pstmt.setInt(idx++, dto.getInoutId());

			result =
					pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	@Override
	public List<InoutDTO> selectItemList() {

		List<InoutDTO> list =
				new ArrayList<InoutDTO>();

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     ITEM_ID, ";
			sql += "     ITEM_NAME ";
			sql += " FROM ITEM ";
			sql += " ORDER BY ITEM_NAME ASC ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			ResultSet rs =
					pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto =
						new InoutDTO();

				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setItemName(rs.getString("ITEM_NAME"));

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

	// =============================================================
	// 입출고 등록
	// EMP_ID가 NOT NULL이라 반드시 INSERT에 넣어야 등록됨
	// 지금은 임시로 EMP_ID = 1 넣음
	// 만약 1번 사원이 없으면 DB에 실제 존재하는 EMP_ID로 바꿔야 함
	// =============================================================
	@Override
	public int insertInout(InoutDTO dto) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " INSERT INTO MATERIAL_INOUT ( ";
			sql += "     INOUT_ID, ";
			sql += "     EMP_ID, ";
			sql += "     ITEM_ID, ";
			sql += "     INOUT_TYPE, ";
			sql += "     INOUT_QTY, ";
			sql += "     INOUT_DATE, ";
			sql += "     REMARK ";
			sql += " ) VALUES ( ";
			sql += "     SEQ_MATERIAL_INOUT.NEXTVAL, ";
			sql += "     ?, ?, ?, ?, ?, ? ";
			sql += " ) ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			// =====================================================
			// 사원 ID
			// MATERIAL_INOUT.EMP_ID가 NOT NULL이라 필수
			// =====================================================
			pstmt.setInt(
					1,
					1);

			pstmt.setInt(
					2,
					dto.getItemId());

			pstmt.setString(
					3,
					dto.getInoutType());

			pstmt.setInt(
					4,
					dto.getInoutQty());

			pstmt.setDate(
					5,
					dto.getInoutDate());

			pstmt.setString(
					6,
					dto.getRemark());

			result =
					pstmt.executeUpdate();

			System.out.println("입출고 등록 성공 : " + result);

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			System.out.println("입출고 등록 실패");
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public int deleteInout(String[] inoutIds) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " DELETE FROM MATERIAL_INOUT ";
			sql += " WHERE INOUT_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			for (String id : inoutIds) {

				pstmt.setInt(
						1,
						Integer.parseInt(id));

				result +=
						pstmt.executeUpdate();
			}

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	@Override
	public int selectInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		return selectInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate).size();
	}
}