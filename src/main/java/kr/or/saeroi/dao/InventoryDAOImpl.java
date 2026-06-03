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
	// 검색어는 띄어쓰기를 무시해서 검색한다.
	// 예) 'EV6배터리'로 검색해도 'EV6 배터리'가 검색된다.
	// 공통 JSP / Controller / Service는 건드리지 않고 DAO SQL에서만 처리한다.
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
			// 재고조회는 INVENTORY DB에 있는 데이터를 기준으로 조회한다.
			// 기존에는 RM / FG만 조회했지만,
			// DB에 있는 SM 재고도 재고조회에 보여야 하므로
			// 품목유형 제한 조건은 넣지 않는다.
			// 단, 우리 프로젝트 기준으로 SM은 화면에서 '완제품'으로 표시한다.
			// =============================================================

			// =============================================================
			// 날짜 검색
			// 등록/입출고 반영 후 첫 화면에서 안 보이는 문제 방지
			// CREATED_DATE만 보면 기존 재고가 수정된 경우 조회에서 빠질 수 있으므로
			// UPDATED_DATE가 있으면 UPDATED_DATE를 기준으로 검색한다.
			// =============================================================
			if (startDate != null
				&& !"".equals(startDate)) {

				sql += " AND NVL(INV.UPDATED_DATE, INV.CREATED_DATE) >= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') ";
			}

			if (endDate != null
				&& !"".equals(endDate)) {

				sql += " AND NVL(INV.UPDATED_DATE, INV.CREATED_DATE) <= ";
				sql += " TO_DATE(?, 'YYYY-MM-DD') + 0.99999 ";
			}

			// =============================================================
			// 검색 기능
			// =============================================================
			if (keyword != null
				&& !"".equals(keyword.trim())) {

				// =========================================================
				// 품목코드 검색
				// =========================================================
				if ("itemCode".equals(searchType)) {

					// =====================================================
					// 품목코드 검색
					// 대문자 / 소문자 구분 없이 검색하고,
					// REPLACE로 DB값과 검색어의 띄어쓰기를 모두 제거해서 비교한다.
					// 예) RM 001 = RM001
					// =====================================================
					sql += " AND REPLACE(UPPER(I.ITEM_CODE), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";
				}

				// =========================================================
				// 품목명 검색
				// =========================================================
				else if ("itemName".equals(searchType)) {

					// =====================================================
					// 품목명 검색
					// 영문 품목명도 대문자 / 소문자 구분 없이 검색하고,
					// 띄어쓰기 차이도 무시한다.
					// =====================================================
					sql += " AND REPLACE(UPPER(I.ITEM_NAME), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";
				}

				// =========================================================
				// 전체 검색
				// =========================================================
				else {

					sql += " AND ( ";

					// =====================================================
					// 전체 검색
					// 문자 컬럼은 모두 UPPER + REPLACE 처리해서
					// 대소문자와 띄어쓰기 차이를 무시하고 검색한다.
					// =====================================================
					sql += "     REPLACE(UPPER(I.ITEM_CODE), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";
					sql += "     OR REPLACE(UPPER(I.ITEM_NAME), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";
					sql += "     OR REPLACE(UPPER(INV.STOCK_LOCATION), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";
					sql += "     OR REPLACE(UPPER(INV.REMARK), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";
					sql += "     OR REPLACE(UPPER(I.ITEM_UNIT), ' ', '') LIKE REPLACE(UPPER(?), ' ', '') ";

					// =====================================================
					// 품목유형 한글 검색
					// 우리 프로젝트 기준: RM=원자재, FG=완제품, SM=완제품
					// =====================================================
					sql += "     OR UPPER(CASE ";
					sql += "         WHEN I.ITEM_TYPE = 'RM' THEN '원자재' ";
					sql += "         WHEN I.ITEM_TYPE = 'FG' THEN '완제품' ";
					sql += "         WHEN I.ITEM_TYPE = 'SM' THEN '완제품' ";
					sql += "         ELSE I.ITEM_TYPE ";
					sql += "     END) LIKE UPPER(?) ";

					// =====================================================
					// 숫자 검색
					// =====================================================
					boolean isNumber = false;

					try {

						Integer.parseInt(keyword.trim());

						isNumber = true;

					} catch (Exception e) {

						isNumber = false;
					}

					if (isNumber) {

						sql += " OR INV.INVENTORY_STOCK = ? ";
					}

					sql += " ) ";
				}
			}

			// =============================================================
			// 생성일 최신순 정렬
			// 팀 피드백 반영: 재고조회관리 목록은 UPDATED_DATE가 아니라
			// CREATED_DATE 기준으로 최신 등록건이 위에 오도록 한다.
			// =============================================================
			sql += " ORDER BY INV.CREATED_DATE DESC, INV.INVENTORY_ID DESC ";

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

				// =========================================================
				// 생성일 / 수정일 추가
				// =========================================================
				dto.setCreatedDate(
					rs.getDate("CREATED_DATE"));

				dto.setUpdatedDate(
					rs.getDate("UPDATED_DATE"));

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
			sql += "         AS STOCK_LOCATION, ";
			sql += "     NVL(SUM(INV.INVENTORY_STOCK), 0) ";
			sql += "         AS INVENTORY_STOCK ";

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

				// =====================================================
				// 등록 모달에서 품목 선택 시
				// 현재 DB 재고를 같이 보여주기 위한 값
				// =====================================================
				dto.setInventoryStock(
					rs.getInt("INVENTORY_STOCK"));

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
	// -------------------------------------------------------------------------
	// 화면에서 등록 버튼을 누르면 항상 신규 재고 행을 INSERT한다.
	//
	// 수정 이유:
	// 기존 코드는 같은 품목 + 같은 창고위치가 이미 있으면 INSERT가 아니라
	// UPDATE로 처리했다. 그래서 등록은 되었지만 새 INVENTORY_ID가 생기지 않아
	// 목록 첫 번째 줄에 새 등록건처럼 보이지 않는 문제가 있었다.
	//
	// 현재 요구사항:
	// 재고조회 등록 모달에서 등록한 데이터는 신규 재고번호를 생성하고,
	// CREATED_DATE / UPDATED_DATE를 SYSDATE로 저장하여 목록 첫 번째 줄에 보이게 한다.
	// 공통 파일은 수정하지 않고 DAO 등록 로직만 수정한다.
	// =========================================================================
	@Override
	public int insertInventory(InventoryDTO dto) {

		int result = 0;

		try {

			Connection conn =
				getConnection();

			// =====================================================
			// NULL 방어코딩
			// 화면에서 비어있는 값이 넘어와도 DB에는 빈 문자열로 저장한다.
			// =====================================================
			if (dto.getStockLocation() == null) {

				dto.setStockLocation("");
			}

			if (dto.getRemark() == null) {

				dto.setRemark("");
			}

			String sql = "";

			sql += " INSERT INTO INVENTORY ";
			sql += " ( ";
			sql += "     INVENTORY_ID, ";
			sql += "     ITEM_ID, ";
			sql += "     INVENTORY_STOCK, ";
			sql += "     STOCK_LOCATION, ";
			sql += "     REMARK, ";
			sql += "     CREATED_DATE, ";
			sql += "     UPDATED_DATE ";
			sql += " ) ";
			sql += " VALUES ";
			sql += " ( ";
			// =====================================================
			// 신규 재고번호 생성
			// 기존 시퀀스 값이 꼬여도 PK 중복이 나지 않도록
			// 현재 INVENTORY_ID 최대값 + 1을 사용한다.
			// =====================================================
			sql += "     ?, ";
			sql += "     ?, ";
			sql += "     ?, ";
			sql += "     ?, ";
			sql += "     ?, ";
			sql += "     SYSDATE, ";
			sql += "     SYSDATE ";
			sql += " ) ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			int idx = 1;

			// =====================================================
			// 방금 등록한 재고를 목록 첫 줄에 고정하려면
			// Controller까지 신규 INVENTORY_ID를 돌려줘야 한다.
			// 그래서 selectNextInventoryId(conn)를 변수에 담아
			// INSERT에도 쓰고, 성공 후 반환값으로도 사용한다.
			// =====================================================
			int newInventoryId =
				selectNextInventoryId(conn);

			pstmt.setInt(
				idx++,
				newInventoryId);

			pstmt.setInt(
				idx++,
				dto.getItemId());

			pstmt.setInt(
				idx++,
				dto.getInventoryStock());

			pstmt.setString(
				idx++,
				dto.getStockLocation());

			pstmt.setString(
				idx++,
				dto.getRemark());

			result =
				pstmt.executeUpdate();

			// =====================================================
			// INSERT 성공 시 영향받은 행 수 1이 아니라
			// 신규 재고번호를 반환한다.
			// 그래야 Controller에서 방금 등록한 재고를
			// 목록 첫 번째 줄에 정확히 올릴 수 있다.
			// =====================================================
			if (result > 0) {

				result = newInventoryId;
			}

			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	// =========================================================================
	// 같은 품목 + 같은 창고위치 재고번호 조회
	// 재고 등록 시 중복 행을 만들지 않고 기존 재고를 갱신하기 위한 보조 메서드
	// =========================================================================
	private Integer selectInventoryIdByItemAndLocation(
			Connection conn,
			int itemId,
			String stockLocation) throws Exception {

		Integer inventoryId =
			null;

		String sql = "";

		sql += " SELECT ";
		sql += "     INVENTORY_ID ";
		sql += " FROM INVENTORY ";
		sql += " WHERE ITEM_ID = ? ";
		sql += " AND NVL(STOCK_LOCATION, ' ') = NVL(?, ' ') ";
		sql += " ORDER BY INVENTORY_ID DESC ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		pstmt.setInt(1, itemId);
		pstmt.setString(2, stockLocation);

		ResultSet rs =
			pstmt.executeQuery();

		if (rs.next()) {

			inventoryId =
				Integer.valueOf(
					rs.getInt("INVENTORY_ID"));
		}

		rs.close();
		pstmt.close();

		return inventoryId;
	}

	// =========================================================================
	// 재고번호 자동 생성
	// INVENTORY_ID는 PK이므로 기존 최대값보다 1 큰 값을 사용한다.
	// =========================================================================
	private int selectNextInventoryId(
			Connection conn) throws Exception {

		String sql = "";

		sql += " SELECT ";
		sql += "     NVL(MAX(INVENTORY_ID), 0) + 1 AS NEXT_INVENTORY_ID ";
		sql += " FROM INVENTORY ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		ResultSet rs =
			pstmt.executeQuery();

		int nextInventoryId = 1;

		if (rs.next()) {

			nextInventoryId =
				rs.getInt("NEXT_INVENTORY_ID");
		}

		rs.close();
		pstmt.close();

		return nextInventoryId;
	}

	// =========================================================================
	// 재고 상세 조회
	// 생성일 / 수정일 나오도록 수정 완료
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

				// =====================================================
				// 재고 기본 정보
				// =====================================================
				dto.setInventoryId(
					rs.getInt("INVENTORY_ID"));

				dto.setItemId(
					rs.getInt("ITEM_ID"));

				dto.setInventoryStock(
					rs.getInt("INVENTORY_STOCK"));

				dto.setStockLocation(
					rs.getString("STOCK_LOCATION"));

				dto.setRemark(
					rs.getString("REMARK"));

				// =====================================================
				// 생성일 / 수정일 추가
				// =====================================================
				dto.setCreatedDate(
					rs.getDate("CREATED_DATE"));

				dto.setUpdatedDate(
					rs.getDate("UPDATED_DATE"));

				// =====================================================
				// 품목 정보
				// =====================================================
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
	// 재고 상세페이지 하단 입출고 내역 조회
	// -------------------------------------------------------------------------
	// 팀장님 피드백 반영 최종 방향
	// 기존에는 INVENTORY_ID → ITEM_ID 기준으로 같은 품목의 전체 입출고 이력을
	// 가져와서 60건 이상이 한꺼번에 보이는 문제가 있었다.
	//
	// 변경 기준:
	// 1. 재고번호로 해당 품목의 최신 자재 LOT번호 1개를 찾는다.
	// 2. 그 LOT번호와 같은 MATERIAL_INOUT 이력만 가져온다.
	// 3. 입고/출고를 시간순으로 계산해서 누적잔량을 만든다.
	// 4. 화면에는 최신순으로 보여주되, 각 행에는 그 시점의 잔량을 표시한다.
	// 5. 입출고 등록/수정 후에는 MATERIAL_INOUT을 다시 조회해서
	//    총입고량 / 총출고량 / 현재잔량을 매번 새로 계산한다.
	//
	// 예:
	// 입고 1000 → 누적잔량 1000
	// 출고 100  → 누적잔량 900
	// 출고 200  → 누적잔량 700
	// =========================================================================
	@Override
	public List<InventoryDTO> selectInventoryInoutHistoryList(
			int inventoryId) {

		List<InventoryDTO> list =
			new ArrayList<InventoryDTO>();

		int totalInQty = 0;
		int totalOutQty = 0;
		int remainQty = 0;

		try {

			Connection conn =
				getConnection();

			// =============================================================
			// 재고 상세 기본정보의 현재재고 수량
			// 화면 하단 입출고 흐름에서 이 수량과 일치하는 행을
			// 첫 번째로 올리기 위해 먼저 조회한다.
			// 예) 기본정보 현재재고가 6,325M이면
			//     +6,325M / 누적잔량 6,325M 행을 맨 위에 보여준다.
			// =============================================================
			int currentInventoryStock =
				selectInventoryStockByInventoryId(
					conn,
					inventoryId);

			String sql = "";

			sql += " SELECT ";
			sql += "     MI.INOUT_ID, ";
			sql += "     MI.DOC_NO, ";
			sql += "     MI.INOUT_TYPE, ";
			sql += "     MI.MATERIAL_LOT, ";
			sql += "     MI.INOUT_QTY, ";
			sql += "     MI.INOUT_DATE, ";
			sql += "     MI.STATUS, ";
			sql += "     MI.REMARK, ";
			sql += "     MI.CREATED_DATE, ";
			sql += "     MI.UPDATED_DATE, ";
			sql += "     I.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT ";
			sql += " FROM MATERIAL_INOUT MI ";
			sql += " JOIN ITEM I ";
			sql += "     ON MI.ITEM_ID = I.ITEM_ID ";

			// =============================================================
			// LOT 기준 조회
			// 최신 LOT 하나를 먼저 찾고, 그 LOT의 입고/출고 흐름만 조회한다.
			// 품목코드 기준 전체 조회가 아니므로 같은 품목의 다른 LOT 이력은 섞이지 않는다.
			// =============================================================
			sql += " WHERE MI.MATERIAL_LOT = ( ";
			sql += "     SELECT MATERIAL_LOT ";
			sql += "     FROM ( ";
			sql += "         SELECT M2.MATERIAL_LOT ";
			sql += "         FROM MATERIAL_INOUT M2 ";
			sql += "         WHERE M2.ITEM_ID = ( ";
			sql += "             SELECT ITEM_ID ";
			sql += "             FROM INVENTORY ";
			sql += "             WHERE INVENTORY_ID = ? ";
			sql += "         ) ";
			sql += "         AND M2.MATERIAL_LOT IS NOT NULL ";
			sql += "         ORDER BY M2.INOUT_DATE DESC, M2.INOUT_ID DESC ";
			sql += "     ) ";
			sql += "     WHERE ROWNUM = 1 ";
			sql += " ) ";

			// =============================================================
			// 누적잔량 계산을 위해 SQL에서는 시간순으로 가져온다.
			// 화면에서는 최신순으로 보여주기 위해 Java에서 list.add(0, dto)를 사용한다.
			// =============================================================
			sql += " ORDER BY MI.INOUT_DATE ASC, MI.INOUT_ID ASC ";

			PreparedStatement pstmt =
				conn.prepareStatement(sql);

			pstmt.setInt(1, inventoryId);

			ResultSet rs =
				pstmt.executeQuery();

			while (rs.next()) {

				InventoryDTO dto =
					new InventoryDTO();

				String inoutType =
					rs.getString("INOUT_TYPE");

				int qty =
					rs.getInt("INOUT_QTY");

				dto.setInoutId(rs.getInt("INOUT_ID"));
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setInoutType(inoutType);
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(qty);

				// =====================================================
				// 입고/출고 분리 + 누적잔량 계산
				// MI는 입고로 더하고, 그 외 MO/MO-PROD는 출고 또는 사용으로 뺀다.
				// =====================================================
				if ("MI".equals(inoutType)) {

					dto.setInQty(qty);
					dto.setOutQty(0);

					totalInQty += qty;
					remainQty += qty;

				} else {

					dto.setInQty(0);
					dto.setOutQty(qty);

					totalOutQty += qty;
					remainQty -= qty;
				}

				dto.setRemainQty(remainQty);

				dto.setInoutDate(rs.getDate("INOUT_DATE"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setHistoryRemark(rs.getString("REMARK"));
				dto.setHistoryCreatedDate(rs.getDate("CREATED_DATE"));
				dto.setHistoryUpdatedDate(rs.getDate("UPDATED_DATE"));

				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));

				// =====================================================
				// 화면은 최신순이 보기 편하므로 맨 앞에 추가한다.
				// 단, remainQty는 이미 시간순 기준으로 계산된 값이므로 정확하다.
				// =====================================================
				list.add(0, dto);
			}

			// =============================================================
			// 기본정보 현재재고와 일치하는 행 우선 표시
			// -----------------------------------------------------------------
			// 기존에는 최신 입출고 행이 맨 위에 보여서,
			// 입고 +6,325M / 누적잔량 6,325M 같은 기준 행이
			// 맨 아래로 내려가는 문제가 있었다.
			//
			// 팀 피드백 반영:
			// 어떤 품목 상세페이지에 들어갔을 때 기본정보의 현재재고 수량과
			// 일치하는 입출고 흐름 행을 첫 번째로 보여준다.
			//
			// 우선순위:
			// 1. 누적잔량이 현재재고와 같은 행
			// 2. 입고수량이 현재재고와 같은 행
			// =============================================================
			if (currentInventoryStock > 0) {

				for (int i = 0; i < list.size(); i++) {

					InventoryDTO dto =
						list.get(i);

					if (dto.getRemainQty() == currentInventoryStock
							|| dto.getInQty() == currentInventoryStock) {

						list.remove(i);
						list.add(0, dto);
						break;
					}
				}
			}

			// =============================================================
			// LOT 요약값 세팅
			// JSP에서 첫 번째 행을 기준으로 총입고/총출고/현재잔량을 보여줄 수 있게
			// 모든 DTO에 같은 요약값을 넣는다.
			// =============================================================
			for (int i = 0; i < list.size(); i++) {

				InventoryDTO dto =
					list.get(i);

				dto.setTotalInQty(totalInQty);
				dto.setTotalOutQty(totalOutQty);
				dto.setCurrentRemainQty(remainQty);
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
	// 재고 상세 현재재고 조회
	// -------------------------------------------------------------------------
	// selectInventoryInoutHistoryList() 안에서 같은 Connection을 사용한다.
	// 기본정보의 현재재고 수량과 입출고 흐름 행을 비교하기 위한 보조 메서드이다.
	// 공통 파일 / Controller / JSP는 건드리지 않고 DAO 안에서만 처리한다.
	// =========================================================================
	private int selectInventoryStockByInventoryId(
			Connection conn,
			int inventoryId) throws Exception {

		int inventoryStock = 0;

		String sql = "";

		sql += " SELECT ";
		sql += "     NVL(INVENTORY_STOCK, 0) AS INVENTORY_STOCK ";
		sql += " FROM INVENTORY ";
		sql += " WHERE INVENTORY_ID = ? ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		pstmt.setInt(
			1,
			inventoryId);

		ResultSet rs =
			pstmt.executeQuery();

		if (rs.next()) {

			inventoryStock =
				rs.getInt("INVENTORY_STOCK");
		}

		rs.close();
		pstmt.close();

		return inventoryStock;
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