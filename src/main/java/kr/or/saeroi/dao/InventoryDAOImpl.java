package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.InventoryDTO;

// 재고 DAO 구현 클래스
@Repository
public class InventoryDAOImpl implements InventoryDAO {

	// =========================================================================
	// DB 연결
	// =========================================================================
	private Connection getConnection() throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url =
			"jdbc:oracle:thin:@//125.181.132.133:51521/xe";

		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(url, id, pw);
	}

	// =========================================================================
	// 재고 목록 조회
	// =========================================================================
	@Override
	public List<InventoryDTO> selectInventoryList(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		List<InventoryDTO> list =
			new ArrayList<InventoryDTO>();

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     INV.*, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";
			sql += " FROM INVENTORY INV ";
			sql += " JOIN ITEM I ";
			sql += "     ON INV.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE 1=1 ";

			// =============================================================
			// 날짜 검색
			// =============================================================

			if (startDate != null
				&& !"".equals(startDate)) {

				sql += " AND INV.CREATED_DATE >= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') ";
			}

			if (endDate != null
				&& !"".equals(endDate)) {

				sql += " AND INV.CREATED_DATE <= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') + 0.99999 ";
			}

			// =============================================================
			// 검색 기능
			// =============================================================

			if (keyword != null
				&& !"".equals(keyword.trim())) {

				if ("itemCode".equals(searchType)) {

					sql += " AND I.ITEM_CODE LIKE ? ";
				}

				else if ("itemName".equals(searchType)) {

					sql += " AND I.ITEM_NAME LIKE ? ";
				}

				else {

					sql += " AND ( ";

					// =====================================================
					// 기본 검색
					// =====================================================

					sql += "     I.ITEM_CODE LIKE ? ";
					sql += "     OR I.ITEM_NAME LIKE ? ";
					sql += "     OR INV.STOCK_LOCATION LIKE ? ";
					sql += "     OR INV.REMARK LIKE ? ";
					sql += "     OR I.ITEM_UNIT LIKE ? ";

					// =====================================================
					// 숫자 검색
					// 재고수량 정확검색
					// =====================================================

					boolean isNumber = false;

					try {

						Integer.parseInt(keyword);

						isNumber = true;

					} catch (Exception e) {

						isNumber = false;
					}

					if (isNumber) {

						sql += " OR INV.INVENTORY_STOCK = ? ";
					}

					// =====================================================
					// 완제품 검색
					// =====================================================

					sql += " OR ( ";
					sql += "     I.ITEM_TYPE = 'FG' ";
					sql += "     AND ? LIKE '%완제품%' ";
					sql += " ) ";

					// =====================================================
					// 원자재 검색
					// RM만 원자재 처리
					// =====================================================

					sql += " OR ( ";
					sql += "     I.ITEM_TYPE = 'RM' ";
					sql += "     AND ? LIKE '%원자재%' ";
					sql += " ) ";

					// =====================================================
					// 부자재 검색
					// =====================================================

					sql += " OR ( ";
					sql += "     I.ITEM_TYPE = 'SM' ";
					sql += "     AND ? LIKE '%부자재%' ";
					sql += " ) ";

					sql += " ) ";
				}
			}

			// =============================================================
			// 최신순 정렬
			// =============================================================

			sql += " ORDER BY INV.INVENTORY_ID DESC ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			int idx = 1;

			// =============================================================
			// 날짜 바인딩
			// =============================================================

			if (startDate != null
				&& !"".equals(startDate)) {

				pstmt.setString(idx++, startDate);
			}

			if (endDate != null
				&& !"".equals(endDate)) {

				pstmt.setString(idx++, endDate);
			}

			// =============================================================
			// 검색어 바인딩
			// =============================================================

			if (keyword != null
				&& !"".equals(keyword.trim())) {

				String likeKey =
					"%" + keyword.trim() + "%";

				// =========================================================
				// 단일 검색
				// =========================================================

				if ("itemCode".equals(searchType)
					|| "itemName".equals(searchType)) {

					pstmt.setString(idx++, likeKey);
				}

				// =========================================================
				// 전체 검색
				// =========================================================

				else {

					pstmt.setString(idx++, likeKey);
					pstmt.setString(idx++, likeKey);
					pstmt.setString(idx++, likeKey);
					pstmt.setString(idx++, likeKey);
					pstmt.setString(idx++, likeKey);

					// =====================================================
					// 숫자 검색 바인딩
					// =====================================================

					try {

						pstmt.setInt(
							idx++,
							Integer.parseInt(keyword.trim()));

					} catch (Exception e) {

						// 숫자 아닐 경우 무시
					}

					// =====================================================
					// 품목유형 검색
					// =====================================================

					pstmt.setString(idx++, keyword);
					pstmt.setString(idx++, keyword);
					pstmt.setString(idx++, keyword);
				}
			}

			ResultSet rs =
				pstmt.executeQuery();

			while (rs.next()) {

				InventoryDTO dto =
					new InventoryDTO();

				dto.setInventoryId(
					rs.getInt("INVENTORY_ID"));

				dto.setItemId(
					rs.getInt("ITEM_ID"));

				dto.setItemCode(
					rs.getString("ITEM_CODE"));

				dto.setItemName(
					rs.getString("ITEM_NAME"));

				dto.setItemType(
					rs.getString("ITEM_TYPE"));

				dto.setItemUnit(
					rs.getString("ITEM_UNIT"));

				dto.setInventoryStock(
					rs.getInt("INVENTORY_STOCK"));

				dto.setStockLocation(
					rs.getString("STOCK_LOCATION"));

				dto.setRemark(
					rs.getString("REMARK"));

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

	// =========================================================================
	// 등록 모달 품목 리스트 조회
	// =========================================================================
	@Override
	public List<InventoryDTO> selectItemList() {

		List<InventoryDTO> list =
			new ArrayList<InventoryDTO>();

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     I.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT, ";

			sql += "     NVL(MAX(INV.STOCK_LOCATION), '') ";
			sql += "         AS STOCK_LOCATION ";

			sql += " FROM ITEM I ";

			sql += " LEFT JOIN INVENTORY INV ";
			sql += "     ON I.ITEM_ID = INV.ITEM_ID ";

			sql += " GROUP BY ";
			sql += "     I.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";

			sql += " ORDER BY I.ITEM_CODE ASC ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			ResultSet rs =
				pstmt.executeQuery();

			while (rs.next()) {

				InventoryDTO dto =
					new InventoryDTO();

				dto.setItemId(
					rs.getInt("ITEM_ID"));

				dto.setItemCode(
					rs.getString("ITEM_CODE"));

				dto.setItemName(
					rs.getString("ITEM_NAME"));

				dto.setItemType(
					rs.getString("ITEM_TYPE"));

				dto.setItemUnit(
					rs.getString("ITEM_UNIT"));

				dto.setStockLocation(
					rs.getString("STOCK_LOCATION"));

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

	// =========================================================================
	// 품목 선택 시 창고위치 조회
	// =========================================================================
	@Override
	public String getStockLocationByItemId(int itemId) {

		String stockLocation = "";

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT NVL(MAX(STOCK_LOCATION), '') ";
			sql += " FROM INVENTORY ";
			sql += " WHERE ITEM_ID = ? ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			pstmt.setInt(1, itemId);

			ResultSet rs =
				pstmt.executeQuery();

			if (rs.next()) {

				stockLocation =
					rs.getString(1);
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return stockLocation;
	}

	// =========================================================================
	// 재고 등록
	// =========================================================================
	@Override
	public int insertInventory(InventoryDTO dto) {

		int result = 0;

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " INSERT INTO INVENTORY ";
			sql += " ( ";
			sql += "     INVENTORY_ID, ";
			sql += "     ITEM_ID, ";
			sql += "     INVENTORY_STOCK, ";
			sql += "     STOCK_LOCATION, ";
			sql += "     REMARK, ";
			sql += "     CREATED_DATE ";
			sql += " ) ";
			sql += " VALUES ";
			sql += " ( ";
			sql += "     SEQ_INVENTORY_ID.NEXTVAL, ";
			sql += "     ?, ?, ?, ?, SYSDATE ";
			sql += " ) ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			pstmt.setInt(1, dto.getItemId());
			pstmt.setInt(2, dto.getInventoryStock());
			pstmt.setString(3, dto.getStockLocation());
			pstmt.setString(4, dto.getRemark());

			result =
				pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	// =========================================================================
	// 재고 상세 조회
	// =========================================================================
	@Override
	public InventoryDTO selectInventoryDetail(
			int inventoryId) {

		InventoryDTO dto = null;

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     INV.*, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";
			sql += " FROM INVENTORY INV ";
			sql += " JOIN ITEM I ";
			sql += "     ON INV.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE INV.INVENTORY_ID = ? ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			pstmt.setInt(1, inventoryId);

			ResultSet rs =
				pstmt.executeQuery();

			if (rs.next()) {

				dto = new InventoryDTO();

				dto.setInventoryId(
					rs.getInt("INVENTORY_ID"));

				dto.setItemId(
					rs.getInt("ITEM_ID"));

				dto.setItemCode(
					rs.getString("ITEM_CODE"));

				dto.setItemName(
					rs.getString("ITEM_NAME"));

				dto.setItemType(
					rs.getString("ITEM_TYPE"));

				dto.setItemUnit(
					rs.getString("ITEM_UNIT"));

				dto.setInventoryStock(
					rs.getInt("INVENTORY_STOCK"));

				dto.setStockLocation(
					rs.getString("STOCK_LOCATION"));

				dto.setRemark(
					rs.getString("REMARK"));
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return dto;
	}

	// =========================================================================
	// 재고 삭제
	// =========================================================================
	@Override
	public int deleteInventory(String[] inventoryIds) {

		int result = 0;

		try {

			Connection conn =
				getConnection();

			String sql =
				" DELETE FROM INVENTORY WHERE INVENTORY_ID = ? ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			for (int i = 0; i < inventoryIds.length; i++) {

				pstmt.setInt(
					1,
					Integer.parseInt(inventoryIds[i]));

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

	// =========================================================================
	// 재고 수정
	// =========================================================================
	@Override
	public int updateInventory(InventoryDTO dto) {

		int result = 0;

		try {

			Connection conn =
				getConnection();

			String sql = "";

			sql += " UPDATE INVENTORY ";
			sql += " SET ";
			sql += "     INVENTORY_STOCK = ?, ";
			sql += "     STOCK_LOCATION = ?, ";
			sql += "     REMARK = ?, ";
			sql += "     UPDATED_DATE = SYSDATE ";
			sql += " WHERE INVENTORY_ID = ? ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			pstmt.setInt(1, dto.getInventoryStock());

			pstmt.setString(2, dto.getStockLocation());

			pstmt.setString(3, dto.getRemark());

			pstmt.setInt(4, dto.getInventoryId());

			result =
				pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}
}