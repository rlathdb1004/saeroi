package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.InoutDTO;

// =============================================================
// 입출고 DAO 구현 클래스
// =============================================================
@Repository
public class InoutDAOImpl implements InoutDAO {

	// =============================================================
	// DB 연결
	// =============================================================
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

	// =============================================================
	// 입출고 목록 조회 오버로딩
	// =============================================================
	@Override
	public List<InoutDTO> selectInoutList(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		String inoutType = "";

		// =========================================================
		// 검색어에 입고 / 출고 직접 입력 시 처리
		// =========================================================

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

	// =============================================================
	// 입출고 목록 조회
	// =============================================================
	@Override
	public List<InoutDTO> selectInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		List<InoutDTO> list =
				new ArrayList<InoutDTO>();

		// =========================================================
		// 검색어에 입고 / 출고 직접 입력 시 처리
		// =========================================================

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

			// =========================================================
			// 입출고 타입 검색
			// =========================================================

			if (inoutType != null
					&& !inoutType.equals("")) {

				sql += " AND MI.INOUT_TYPE = ? ";
			}

			// =========================================================
			// 검색 기능
			// =========================================================

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

				// =====================================================
				// 품목코드 검색
				// =====================================================

				if ("itemCode".equals(searchType)) {

					sql += " AND I.ITEM_CODE LIKE ? ";
				}

				// =====================================================
				// 품목명 검색
				// =====================================================

				else if ("itemName".equals(searchType)) {

					sql += " AND I.ITEM_NAME LIKE ? ";
				}

				// =====================================================
				// 숫자 검색 시 입출고량 정확검색
				// =====================================================

				else if (isNumber) {

					sql += " AND MI.INOUT_QTY = ? ";
				}

				// =====================================================
				// 전체 검색
				// =====================================================

				else {

					sql += " AND ( ";

					sql += "     I.ITEM_CODE LIKE ? ";
					sql += "     OR I.ITEM_NAME LIKE ? ";
					sql += "     OR I.ITEM_UNIT LIKE ? ";
					sql += "     OR MI.DOC_NO LIKE ? ";
					sql += "     OR MI.MATERIAL_LOT LIKE ? ";
					sql += "     OR MI.REMARK LIKE ? ";

					sql += "     OR TO_CHAR(MI.INOUT_DATE, 'YYYY-MM-DD') LIKE ? ";

					sql += "     OR CASE ";
					sql += "            WHEN MI.INOUT_TYPE = 'MI' ";
					sql += "            THEN '입고' ";

					sql += "            WHEN MI.INOUT_TYPE = 'MO-PROD' ";
					sql += "            THEN '출고' ";

					sql += "            ELSE MI.INOUT_TYPE ";
					sql += "        END LIKE ? ";

					sql += "     OR CASE ";
					sql += "            WHEN I.ITEM_TYPE = 'FG' ";
					sql += "            THEN '완제품' ";

					sql += "            WHEN I.ITEM_TYPE = 'RM' ";
					sql += "            THEN '원자재' ";

					sql += "            WHEN I.ITEM_TYPE = 'SM' ";
					sql += "            THEN '부자재' ";

					sql += "            ELSE I.ITEM_TYPE ";
					sql += "        END LIKE ? ";

					sql += " ) ";
				}
			}

			// =========================================================
			// 날짜 검색
			// =========================================================

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

			// =========================================================
			// 최신순 정렬
			// =========================================================

			sql += " ORDER BY MI.INOUT_ID DESC ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			// =========================================================
			// 입출고 타입 바인딩
			// =========================================================

			if (inoutType != null
					&& !inoutType.equals("")) {

				pstmt.setString(idx++, inoutType);
			}

			// =========================================================
			// 검색어 바인딩
			// =========================================================

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

				// 품목코드 검색
				if ("itemCode".equals(searchType)) {

					pstmt.setString(
							idx++,
							"%" + keyword + "%");
				}

				// 품목명 검색
				else if ("itemName".equals(searchType)) {

					pstmt.setString(
							idx++,
							"%" + keyword + "%");
				}

				// 숫자 검색
				else if (isNumber) {

					pstmt.setInt(
							idx++,
							Integer.parseInt(keyword));
				}

				// 전체 검색
				else {

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

			// =========================================================
			// 날짜 바인딩
			// =========================================================

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

			// =========================================================
			// 결과 DTO 저장
			// =========================================================

			while (rs.next()) {

				InoutDTO dto =
						new InoutDTO();

				dto.setInoutId(
						rs.getInt("INOUT_ID"));

				dto.setInoutType(
						rs.getString("INOUT_TYPE"));

				dto.setMaterialLot(
						rs.getString("MATERIAL_LOT"));

				dto.setInoutQty(
						rs.getInt("INOUT_QTY"));

				dto.setInoutDate(
						rs.getDate("INOUT_DATE"));

				dto.setRemark(
						rs.getString("REMARK"));

				dto.setStatus(
						rs.getString("STATUS"));

				dto.setItemId(
						rs.getInt("ITEM_ID"));

				dto.setDocNo(
						rs.getString("DOC_NO"));

				dto.setDocSeq(
						rs.getInt("DOC_SEQ"));

				dto.setItemCode(
						rs.getString("ITEM_CODE"));

				dto.setItemName(
						rs.getString("ITEM_NAME"));

				dto.setItemType(
						rs.getString("ITEM_TYPE"));

				dto.setItemUnit(
						rs.getString("ITEM_UNIT"));

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
	// 입출고 상세조회
	// =============================================================
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

			// =========================================================
			// 상세 데이터 저장
			// =========================================================

			if (rs.next()) {

				dto = new InoutDTO();

				dto.setInoutId(
						rs.getInt("INOUT_ID"));

				dto.setInoutType(
						rs.getString("INOUT_TYPE"));

				dto.setMaterialLot(
						rs.getString("MATERIAL_LOT"));

				dto.setInoutQty(
						rs.getInt("INOUT_QTY"));

				dto.setInoutDate(
						rs.getDate("INOUT_DATE"));

				dto.setRemark(
						rs.getString("REMARK"));

				dto.setStatus(
						rs.getString("STATUS"));

				dto.setItemId(
						rs.getInt("ITEM_ID"));

				dto.setDocNo(
						rs.getString("DOC_NO"));

				dto.setDocSeq(
						rs.getInt("DOC_SEQ"));

				dto.setItemCode(
						rs.getString("ITEM_CODE"));

				dto.setItemName(
						rs.getString("ITEM_NAME"));

				dto.setItemType(
						rs.getString("ITEM_TYPE"));

				dto.setItemUnit(
						rs.getString("ITEM_UNIT"));
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return dto;
	}

	// =============================================================
	// 입출고 수정
	// =============================================================
	@Override
	public int updateInout(InoutDTO dto) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			// =====================================================
			// 입출고 수정 SQL
			// =====================================================

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

			// =====================================================
			// 수정 데이터 바인딩
			// =====================================================

			pstmt.setString(
					idx++,
					dto.getInoutType());

			pstmt.setInt(
					idx++,
					dto.getInoutQty());

			pstmt.setDate(
					idx++,
					dto.getInoutDate());

			pstmt.setString(
					idx++,
					dto.getRemark());

			// =====================================================
			// 수정할 입출고번호
			// =====================================================

			pstmt.setInt(
					idx++,
					dto.getInoutId());

			// =====================================================
			// 수정 실행
			// =====================================================

			result =
					pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	// =============================================================
	// 이하 기존 코드 그대로 유지
	// =============================================================

	@Override
	public int selectInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		return 0;
	}

	@Override
	public List<InoutDTO> selectItemList() {

		return null;
	}

	@Override
	public int insertInout(InoutDTO dto) {

		return 0;
	}

	@Override
	public int deleteInout(String[] inoutIds) {

		return 0;
	}
}