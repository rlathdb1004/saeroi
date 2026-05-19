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

	// DB 연결
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

	// ==================================================
	// 재고 목록 조회
	// ==================================================
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
			sql += "     IV.INVENTORY_ID, ";
			sql += "     IV.INVENTORY_STOCK, ";
			sql += "     IV.REMARK, ";
			sql += "     IV.STOCK_LOCATION, ";
			sql += "     IV.CREATED_DATE, ";
			sql += "     IV.UPDATED_DATE, ";
			sql += "     IV.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";
			sql += " FROM INVENTORY IV ";
			sql += " JOIN ITEM I ";
			sql += " ON IV.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE 1 = 1 ";

			// 검색어가 있을 때
			if (keyword != null &&
					!keyword.equals("")) {

				// 품목코드 검색
				if ("itemCode".equals(searchType)) {

					sql += " AND I.ITEM_CODE LIKE ? ";

				// 품목명 검색
				} else if ("itemName".equals(searchType)) {

					sql += " AND I.ITEM_NAME LIKE ? ";

				// 전체 검색
				} else {

					sql += " AND ( ";
					sql += " I.ITEM_CODE LIKE ? ";
					sql += " OR I.ITEM_NAME LIKE ? ";
					sql += " ) ";
				}
			}

			// 시작일 검색
			if (startDate != null &&
					!startDate.equals("")) {

				sql += " AND IV.CREATED_DATE >= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') ";
			}

			// 종료일 검색
			if (endDate != null &&
					!endDate.equals("")) {

				sql += " AND IV.CREATED_DATE <= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') ";
			}

			// 최신순 정렬
			sql += " ORDER BY IV.INVENTORY_ID DESC ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			// 검색어 값 넣기
			if (keyword != null &&
					!keyword.equals("")) {

				if ("itemCode".equals(searchType)) {

					pstmt.setString(
							idx++,
							"%" + keyword + "%");

				} else if ("itemName".equals(searchType)) {

					pstmt.setString(
							idx++,
							"%" + keyword + "%");

				} else {

					pstmt.setString(
							idx++,
							"%" + keyword + "%");

					pstmt.setString(
							idx++,
							"%" + keyword + "%");
				}
			}

			// 시작일 값
			if (startDate != null &&
					!startDate.equals("")) {

				pstmt.setString(
						idx++,
						startDate);
			}

			// 종료일 값
			if (endDate != null &&
					!endDate.equals("")) {

				pstmt.setString(
						idx++,
						endDate);
			}

			ResultSet rs =
					pstmt.executeQuery();

			while (rs.next()) {

				InventoryDTO dto =
						new InventoryDTO();

				dto.setInventoryId(
						rs.getInt("INVENTORY_ID"));

				dto.setInventoryStock(
						rs.getInt("INVENTORY_STOCK"));

				dto.setRemark(
						rs.getString("REMARK"));

				dto.setStockLocation(
						rs.getString("STOCK_LOCATION"));

				dto.setCreatedDate(
						rs.getDate("CREATED_DATE"));

				dto.setUpdatedDate(
						rs.getDate("UPDATED_DATE"));

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

	// ==================================================
	// 품목 목록 조회
	// ==================================================
	@Override
	public List<InventoryDTO> selectItemList() {

		List<InventoryDTO> list =
				new ArrayList<InventoryDTO>();

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     ITEM_ID, ";
			sql += "     ITEM_CODE, ";
			sql += "     ITEM_NAME, ";
			sql += "     ITEM_TYPE, ";
			sql += "     ITEM_UNIT ";
			sql += " FROM ITEM ";
			sql += " ORDER BY ITEM_ID ASC ";

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

	// ==================================================
	// 재고 등록
	// ==================================================
	@Override
	public int insertInventory(
			InventoryDTO dto) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			int inventoryId = 1;

			String idSql =
					" SELECT NVL(MAX(INVENTORY_ID), 0) + 1 FROM INVENTORY ";

			PreparedStatement idPstmt =
					conn.prepareStatement(idSql);

			ResultSet idRs =
					idPstmt.executeQuery();

			if (idRs.next()) {

				inventoryId =
						idRs.getInt(1);
			}

			idRs.close();
			idPstmt.close();

			String sql = "";

			sql += " INSERT INTO INVENTORY ( ";
			sql += "     INVENTORY_ID, ";
			sql += "     INVENTORY_STOCK, ";
			sql += "     REMARK, ";
			sql += "     STOCK_LOCATION, ";
			sql += "     CREATED_DATE, ";
			sql += "     UPDATED_DATE, ";
			sql += "     ITEM_ID ";
			sql += " ) VALUES ( ";
			sql += "     ?, ?, ?, ?, ";
			sql += "     SYSDATE, SYSDATE, ? ";
			sql += " ) ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			pstmt.setInt(1, inventoryId);
			pstmt.setInt(2, dto.getInventoryStock());
			pstmt.setString(3, dto.getRemark());
			pstmt.setString(4, dto.getStockLocation());
			pstmt.setInt(5, dto.getItemId());

			result =
					pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	// ==================================================
	// 재고 상세조회
	// ==================================================
	@Override
	public InventoryDTO selectInventoryDetail(
			int inventoryId) {

		InventoryDTO dto = null;

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     IV.INVENTORY_ID, ";
			sql += "     IV.INVENTORY_STOCK, ";
			sql += "     IV.REMARK, ";
			sql += "     IV.STOCK_LOCATION, ";
			sql += "     IV.CREATED_DATE, ";
			sql += "     IV.UPDATED_DATE, ";
			sql += "     IV.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";
			sql += " FROM INVENTORY IV ";
			sql += " JOIN ITEM I ";
			sql += " ON IV.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE IV.INVENTORY_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			pstmt.setInt(1, inventoryId);

			ResultSet rs =
					pstmt.executeQuery();

			if (rs.next()) {

				dto =
						new InventoryDTO();

				dto.setInventoryId(
						rs.getInt("INVENTORY_ID"));

				dto.setInventoryStock(
						rs.getInt("INVENTORY_STOCK"));

				dto.setRemark(
						rs.getString("REMARK"));

				dto.setStockLocation(
						rs.getString("STOCK_LOCATION"));

				dto.setCreatedDate(
						rs.getDate("CREATED_DATE"));

				dto.setUpdatedDate(
						rs.getDate("UPDATED_DATE"));

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
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return dto;
	}

	// ==================================================
	// 재고 선택 삭제
	// ==================================================
	@Override
	public int deleteInventory(
			String[] inventoryIds) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " DELETE FROM INVENTORY ";
			sql += " WHERE INVENTORY_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			for (int i = 0;
					i < inventoryIds.length;
					i++) {

				pstmt.setInt(
						1,
						Integer.parseInt(
								inventoryIds[i]));

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

	// ==================================================
	// 재고 수정
	// ==================================================
	@Override
	public int updateInventory(
			InventoryDTO dto) {

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

			pstmt.setInt(
					1,
					dto.getInventoryStock());

			pstmt.setString(
					2,
					dto.getStockLocation());

			pstmt.setString(
					3,
					dto.getRemark());

			pstmt.setInt(
					4,
					dto.getInventoryId());

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