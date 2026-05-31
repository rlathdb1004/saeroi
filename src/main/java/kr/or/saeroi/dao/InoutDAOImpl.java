package kr.or.saeroi.dao;

import java.sql.Connection;
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
// MATERIAL_INOUT 테이블 실제 SQL 처리 파일
// 목록 조회는 안정성을 위해 MATERIAL_INOUT + ITEM만 사용
// 상세 조회는 ITEM + CLIENT + INVENTORY까지 JOIN해서 출력한다.
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

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     MI.INOUT_ID, ";
			sql += "     MI.EMP_ID, ";
			sql += "     MI.INOUT_TYPE, ";
			sql += "     MI.MATERIAL_LOT, ";
			sql += "     MI.INOUT_QTY, ";
			sql += "     MI.INOUT_DATE, ";
			sql += "     MI.REMARK, ";
			sql += "     MI.CREATED_DATE, ";
			sql += "     MI.UPDATED_DATE, ";
			sql += "     MI.USE_YN, ";
			sql += "     MI.STATUS, ";
			sql += "     MI.ORDER_ID, ";
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

					// =====================================================
					// 품목코드 검색
					// UPPER를 사용해서 대문자 / 소문자를 구분하지 않는다.
					// 예: RM, rm, Rm 모두 검색 가능
					// =====================================================
					sql += " AND UPPER(I.ITEM_CODE) LIKE UPPER(?) ";

				} else if ("itemName".equals(searchType)) {

					// =====================================================
					// 품목명 검색
					// 영어가 들어간 품목명도 대소문자 구분 없이 검색한다.
					// =====================================================
					sql += " AND UPPER(I.ITEM_NAME) LIKE UPPER(?) ";

				} else if (isNumber) {

					sql += " AND MI.INOUT_QTY = ? ";

				} else {

					// =====================================================
					// 통합검색
					// 품목코드 / 품목명 / 단위 / 문서번호 / LOT번호 등
					// 영어 검색어가 들어가는 컬럼은 UPPER를 적용해서
					// 대소문자를 구분하지 않게 한다.
					// =====================================================
					sql += " AND ( ";
					sql += "     UPPER(I.ITEM_CODE) LIKE UPPER(?) ";
					sql += "     OR UPPER(I.ITEM_NAME) LIKE UPPER(?) ";
					sql += "     OR UPPER(I.ITEM_UNIT) LIKE UPPER(?) ";
					sql += "     OR UPPER(MI.DOC_NO) LIKE UPPER(?) ";
					sql += "     OR UPPER(MI.MATERIAL_LOT) LIKE UPPER(?) ";
					sql += "     OR UPPER(MI.REMARK) LIKE UPPER(?) ";
					sql += "     OR UPPER(MI.STATUS) LIKE UPPER(?) ";
					sql += "     OR UPPER(MI.USE_YN) LIKE UPPER(?) ";
					sql += "     OR TO_CHAR(MI.INOUT_DATE, 'YYYY-MM-DD') LIKE ? ";
					// =====================================================
					// 입고/출고 한글 검색도 대소문자 구분 없이 처리한다.
					// =====================================================
					sql += "     OR UPPER(CASE ";
					sql += "            WHEN MI.INOUT_TYPE = 'MI' THEN '입고' ";
					sql += "            WHEN MI.INOUT_TYPE = 'MO-PROD' THEN '출고' ";
					sql += "            ELSE MI.INOUT_TYPE ";
					sql += "        END) LIKE UPPER(?) ";
					// =====================================================
					// 품목유형 검색도 대소문자 구분 없이 처리한다.
					// FG / fg / Rm 같은 검색어도 동일하게 처리된다.
					// =====================================================
					sql += "     OR UPPER(CASE ";
					sql += "            WHEN I.ITEM_TYPE = 'FG' THEN '완제품' ";
					sql += "            WHEN I.ITEM_TYPE = 'RM' THEN '원자재' ";
					sql += "            WHEN I.ITEM_TYPE = 'SM' THEN '부자재' ";
					sql += "            ELSE I.ITEM_TYPE ";
					sql += "        END) LIKE UPPER(?) ";
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

			// =============================================================
			// 최신 등록순 정렬
			// 등록 직후 입출고일자가 과거여도 방금 등록한 INOUT_ID가 맨 위에 오도록 한다.
			// =============================================================
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
				dto.setEmpId(rs.getInt("EMP_ID"));
				dto.setInoutType(rs.getString("INOUT_TYPE"));
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(rs.getInt("INOUT_QTY"));
				dto.setInoutDate(rs.getDate("INOUT_DATE"));
				dto.setRemark(rs.getString("REMARK"));
				dto.setCreatedDate(rs.getDate("CREATED_DATE"));
				dto.setUpdatedDate(rs.getDate("UPDATED_DATE"));
				dto.setUseYn(rs.getString("USE_YN"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setOrderId(rs.getInt("ORDER_ID"));
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

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     MI.INOUT_ID, ";
			sql += "     MI.EMP_ID, ";
			sql += "     MI.INOUT_TYPE, ";
			sql += "     MI.MATERIAL_LOT, ";
			sql += "     MI.INOUT_QTY, ";
			sql += "     MI.INOUT_DATE, ";
			sql += "     MI.REMARK, ";
			sql += "     MI.CREATED_DATE, ";
			sql += "     MI.UPDATED_DATE, ";
			sql += "     MI.USE_YN, ";
			sql += "     MI.STATUS, ";
			sql += "     MI.ORDER_ID, ";
			sql += "     MI.ITEM_ID, ";
			sql += "     MI.DOC_NO, ";
			sql += "     MI.DOC_SEQ, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT, ";
			sql += "     C.CLIENT_NAME, ";
			sql += "     C.CLIENT_MAN, ";
			sql += "     IV.STOCK_LOCATION, ";
			sql += "     IV.INVENTORY_STOCK ";
			sql += " FROM MATERIAL_INOUT MI ";
			sql += " JOIN ITEM I ";
			sql += " ON MI.ITEM_ID = I.ITEM_ID ";
			// =====================================================
			// 거래처 JOIN
			// 등록모달에서는 품목 선택 시 거래처명이 자동으로 보이지만,
			// 상세페이지는 저장된 ITEM_ID를 기준으로 다시 CLIENT를 JOIN해서 가져온다.
			//
			// 기존 조건은 출고(MO-PROD)일 때 ITEM.CLIENT_ID만 보게 되어 있어서
			// 해당 품목의 CLIENT_ID가 비어 있고 SUPPLIER_ID만 있으면
			// 거래처명 / 담당자가 상세페이지에 빈 값으로 나왔다.
			//
			// 그래서 상세페이지에서는 CLIENT_ID 또는 SUPPLIER_ID 둘 중
			// DB에 실제 연결된 값이 있으면 거래처 정보를 가져오도록 한다.
			// =====================================================
			// =====================================================
			// 거래처 JOIN
			// 입고(MI)는 공급처(SUPPLIER_ID)를 우선 사용한다.
			// 출고(MO-PROD)는 납품처(CLIENT_ID)를 우선 사용하되,
			// CLIENT_ID가 비어있는 품목은 SUPPLIER_ID로 보완해서 거래처명이 비지 않게 한다.
			// OR 조건을 쓰면 한 품목에 거래처가 2건 붙을 수 있어서 CASE + NVL로 1건만 JOIN한다.
			// =====================================================
			sql += " LEFT JOIN CLIENT C ";
			sql += " ON C.CLIENT_ID = ";
			sql += "     CASE ";
			sql += "         WHEN MI.INOUT_TYPE = 'MI' THEN I.SUPPLIER_ID ";
			sql += "         WHEN MI.INOUT_TYPE = 'MO-PROD' THEN NVL(I.CLIENT_ID, I.SUPPLIER_ID) ";
			sql += "         ELSE NVL(I.CLIENT_ID, I.SUPPLIER_ID) ";
			sql += "     END ";
			sql += " LEFT JOIN ( ";
			sql += "     SELECT ";
			sql += "         ITEM_ID, ";
			sql += "         MAX(STOCK_LOCATION) AS STOCK_LOCATION, ";
			sql += "         SUM(INVENTORY_STOCK) AS INVENTORY_STOCK ";
			sql += "     FROM INVENTORY ";
			sql += "     GROUP BY ITEM_ID ";
			sql += " ) IV ";
			sql += " ON MI.ITEM_ID = IV.ITEM_ID ";
			sql += " WHERE MI.INOUT_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			pstmt.setInt(1, inoutId);

			ResultSet rs =
					pstmt.executeQuery();

			if (rs.next()) {

				dto =
						new InoutDTO();

				dto.setInoutId(rs.getInt("INOUT_ID"));
				dto.setEmpId(rs.getInt("EMP_ID"));
				dto.setInoutType(rs.getString("INOUT_TYPE"));
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(rs.getInt("INOUT_QTY"));
				dto.setInoutDate(rs.getDate("INOUT_DATE"));
				dto.setRemark(rs.getString("REMARK"));
				dto.setCreatedDate(rs.getDate("CREATED_DATE"));
				dto.setUpdatedDate(rs.getDate("UPDATED_DATE"));
				dto.setUseYn(rs.getString("USE_YN"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setOrderId(rs.getInt("ORDER_ID"));
				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setDocNo(rs.getString("DOC_NO"));
				dto.setDocSeq(rs.getInt("DOC_SEQ"));

				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));

				dto.setClientName(rs.getString("CLIENT_NAME"));
				dto.setClientManager(rs.getString("CLIENT_MAN"));

				dto.setStockLocation(rs.getString("STOCK_LOCATION"));
				dto.setInventoryStock(rs.getInt("INVENTORY_STOCK"));
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
			sql += "     EMP_ID = ?, ";
			sql += "     ITEM_ID = ?, ";
			sql += "     INOUT_TYPE = ?, ";
			sql += "     MATERIAL_LOT = ?, ";
			sql += "     INOUT_QTY = ?, ";
			sql += "     INOUT_DATE = ?, ";
			sql += "     REMARK = ?, ";
			sql += "     UPDATED_DATE = SYSDATE, ";
			sql += "     USE_YN = ?, ";
			sql += "     STATUS = ?, ";
			sql += "     ORDER_ID = ?, ";
			sql += "     DOC_NO = ?, ";
			sql += "     DOC_SEQ = ? ";
			sql += " WHERE INOUT_ID = ? ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			pstmt.setInt(idx++, dto.getEmpId());
			pstmt.setInt(idx++, dto.getItemId());
			pstmt.setString(idx++, dto.getInoutType());
			pstmt.setString(idx++, dto.getMaterialLot());
			pstmt.setInt(idx++, dto.getInoutQty());
			pstmt.setDate(idx++, dto.getInoutDate());
			pstmt.setString(idx++, dto.getRemark());
			// =====================================================
			// 화면에서 사용여부 입력란은 제거했기 때문에 기본값 Y로 저장한다.
			// 상태도 비어있으면 완료로 저장해서 목록/상세가 비지 않게 한다.
			// =====================================================
			if (dto.getUseYn() == null
					|| dto.getUseYn().trim().equals("")) {

				dto.setUseYn("Y");
			}

			if (dto.getStatus() == null
					|| dto.getStatus().trim().equals("")) {

				dto.setStatus("완료");
			}

			// =====================================================
			// 화면에서 사용여부 입력란은 제거했기 때문에 기본값 Y로 저장한다.
			// 상태도 비어있으면 완료로 저장한다.
			// =====================================================
			if (dto.getUseYn() == null
					|| dto.getUseYn().trim().equals("")) {

				dto.setUseYn("Y");
			}

			if (dto.getStatus() == null
					|| dto.getStatus().trim().equals("")) {

				dto.setStatus("완료");
			}

			pstmt.setString(idx++, dto.getUseYn());
			pstmt.setString(idx++, dto.getStatus());

			if (dto.getOrderId() <= 0) {

				pstmt.setNull(
						idx++,
						java.sql.Types.INTEGER);

			} else {

				pstmt.setInt(
						idx++,
						dto.getOrderId());
			}

			pstmt.setString(idx++, dto.getDocNo());
			pstmt.setInt(idx++, dto.getDocSeq());
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
			sql += "     ITEM_CODE, ";
			sql += "     ITEM_NAME, ";
			sql += "     ITEM_TYPE, ";
			sql += "     ITEM_UNIT ";
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

	// =============================================================
	// 품목 선택 시 자동 표시할 품목 상세 정보 조회
	// 기존 호출 호환용 메서드
	// 입출고구분이 없으면 ITEM.CLIENT_ID가 있으면 납품처를 우선 사용하고,
	// CLIENT_ID가 없으면 SUPPLIER_ID 공급처를 사용한다.
	// =============================================================
	@Override
	public InoutDTO selectItemInfo(int itemId) {

		return selectItemInfo(
				itemId,
				"");
	}

	// =============================================================
	// 품목 선택 시 자동 표시할 품목 상세 정보 조회
	// 등록 모달에서 품목과 입출고구분을 선택하면 거래처명 / 담당자 / 현재재고를 자동 표시한다.
	// 입고(MI)는 공급처(SUPPLIER_ID), 출고(MO-PROD)는 납품처(CLIENT_ID)를 기준으로 조회한다.
	// =============================================================
	@Override
	public InoutDTO selectItemInfo(
			int itemId,
			String inoutType) {

		InoutDTO dto =
				null;

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
			sql += "     C.CLIENT_NAME, ";
			sql += "     C.CLIENT_MAN, ";
			sql += "     NVL(SUM(INV.INVENTORY_STOCK), 0) AS INVENTORY_STOCK ";
			sql += " FROM ITEM I ";
			sql += " LEFT JOIN CLIENT C ";
			sql += " ON ( ";
			sql += "     (? = 'MI' AND I.SUPPLIER_ID = C.CLIENT_ID) ";
			sql += "     OR ";
			sql += "     (? = 'MO-PROD' AND I.CLIENT_ID = C.CLIENT_ID) ";
			sql += "     OR ";
			sql += "     ((? IS NULL OR ? = '' OR ? NOT IN ('MI', 'MO-PROD')) ";
			sql += "      AND NVL(I.CLIENT_ID, I.SUPPLIER_ID) = C.CLIENT_ID) ";
			sql += " ) ";
			sql += " LEFT JOIN INVENTORY INV ";
			sql += " ON I.ITEM_ID = INV.ITEM_ID ";
			sql += " WHERE I.ITEM_ID = ? ";
			sql += " GROUP BY ";
			sql += "     I.ITEM_ID, ";
			sql += "     I.ITEM_CODE, ";
			sql += "     I.ITEM_NAME, ";
			sql += "     I.ITEM_TYPE, ";
			sql += "     I.ITEM_UNIT, ";
			sql += "     C.CLIENT_NAME, ";
			sql += "     C.CLIENT_MAN ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			pstmt.setString(idx++, inoutType);
			pstmt.setString(idx++, inoutType);
			pstmt.setString(idx++, inoutType);
			pstmt.setString(idx++, inoutType);
			pstmt.setString(idx++, inoutType);
			pstmt.setInt(idx++, itemId);

			ResultSet rs =
					pstmt.executeQuery();

			if (rs.next()) {

				dto =
						new InoutDTO();

				dto.setItemId(rs.getInt("ITEM_ID"));
				dto.setItemCode(rs.getString("ITEM_CODE"));
				dto.setItemName(rs.getString("ITEM_NAME"));
				dto.setItemType(rs.getString("ITEM_TYPE"));
				dto.setItemUnit(rs.getString("ITEM_UNIT"));
				dto.setClientName(rs.getString("CLIENT_NAME"));
				dto.setClientManager(rs.getString("CLIENT_MAN"));
				dto.setInventoryStock(rs.getInt("INVENTORY_STOCK"));
			}

			rs.close();
			pstmt.close();
			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		if (dto == null) {

			dto =
				new InoutDTO();

			dto.setItemId(itemId);
		}

		return dto;
	}

	// =============================================================
	// 품목별 창고위치 목록 조회
	// 등록 모달에서 창고위치 select 박스 출력용
	// 같은 품목이 여러 창고에 있으면 창고별 현재재고 합계도 같이 가져온다.
	// =============================================================
	@Override
	public List<InoutDTO> selectStockLocationList(int itemId) {

		List<InoutDTO> list =
				new ArrayList<InoutDTO>();

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     STOCK_LOCATION, ";
			sql += "     SUM(INVENTORY_STOCK) AS INVENTORY_STOCK ";
			sql += " FROM INVENTORY ";
			sql += " WHERE ITEM_ID = ? ";
			sql += " AND STOCK_LOCATION IS NOT NULL ";
			sql += " GROUP BY STOCK_LOCATION ";
			sql += " ORDER BY STOCK_LOCATION ASC ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			pstmt.setInt(1, itemId);

			ResultSet rs =
					pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto =
						new InoutDTO();

				dto.setItemId(itemId);
				dto.setStockLocation(rs.getString("STOCK_LOCATION"));
				dto.setInventoryStock(rs.getInt("INVENTORY_STOCK"));

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
	// 등록 모달에서 입력한 MATERIAL_INOUT 값을 저장한다.
	// 작업지시번호 / 문서번호 / 문서순번은 화면에서 입력받지 않는다.
	// DOC_NO / DOC_SEQ는 여기서 자동 생성한다.
	// 창고위치가 넘어오면 INVENTORY 현재재고도 입고/출고에 맞게 갱신한다.
	// =============================================================
	@Override
	public int insertInout(InoutDTO dto) {

		int result = 0;

		try {

			Connection conn =
					getConnection();

			// =====================================================
			// 문서순번 자동 생성
			// 같은 입출고구분 + 같은 일자 기준으로 다음 순번을 구한다.
			// =====================================================
			int docSeq =
				selectNextDocSeq(
					conn,
					dto);

			// =====================================================
			// 문서번호 자동 생성
			// 예: RM-MI-20260529-0001, RM-MO-20260529-0001
			// =====================================================
			String docNo =
				createDocNo(
					dto,
					docSeq);

			dto.setDocSeq(docSeq);
			dto.setDocNo(docNo);

			String sql = "";

			sql += " INSERT INTO MATERIAL_INOUT ( ";
			sql += "     INOUT_ID, ";
			sql += "     EMP_ID, ";
			sql += "     ITEM_ID, ";
			sql += "     INOUT_TYPE, ";
			sql += "     MATERIAL_LOT, ";
			sql += "     INOUT_QTY, ";
			sql += "     INOUT_DATE, ";
			sql += "     REMARK, ";
			sql += "     CREATED_DATE, ";
			sql += "     UPDATED_DATE, ";
			sql += "     USE_YN, ";
			sql += "     STATUS, ";
			sql += "     ORDER_ID, ";
			sql += "     DOC_NO, ";
			sql += "     DOC_SEQ ";
			sql += " ) VALUES ( ";
			// =====================================================
			// 기존 SEQ_MATERIAL_INOUT.NEXTVAL 값이
			// 이미 DB에 있는 INOUT_ID와 겹치면 ORA-00001이 발생한다.
			// 그래서 현재 MATERIAL_INOUT의 최대 INOUT_ID보다 큰 값을
			// 직접 구해서 PK 중복을 방지한다.
			// =====================================================
			sql += "     ?, ";
			sql += "     ?, ?, ?, ?, ?, ?, ?, ";
			sql += "     SYSDATE, ";
			sql += "     SYSDATE, ";
			sql += "     ?, ?, ?, ?, ? ";
			sql += " ) ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			int idx = 1;

			pstmt.setInt(
					idx++,
					selectNextInoutId(conn));

			// =====================================================
			// 사용여부 / 상태 기본값 방어코딩
			// 화면에서 사용여부는 제거했기 때문에 값이 없으면 Y로 저장한다.
			// 상태가 비어 있으면 완료로 저장한다.
			// =====================================================
			if (dto.getUseYn() == null
					|| dto.getUseYn().trim().equals("")) {

				dto.setUseYn("Y");
			}

			if (dto.getStatus() == null
					|| dto.getStatus().trim().equals("")) {

				dto.setStatus("완료");
			}

			pstmt.setInt(idx++, dto.getEmpId());
			pstmt.setInt(idx++, dto.getItemId());
			pstmt.setString(idx++, dto.getInoutType());
			pstmt.setString(idx++, dto.getMaterialLot());
			pstmt.setInt(idx++, dto.getInoutQty());
			pstmt.setDate(idx++, dto.getInoutDate());
			pstmt.setString(idx++, dto.getRemark());
			pstmt.setString(idx++, dto.getUseYn());
			pstmt.setString(idx++, dto.getStatus());

			// =====================================================
			// 신규 수기 등록은 작업지시번호가 없으므로 NULL 저장
			// 기존 데이터 수정 호환을 위해 값이 있으면 저장 가능하게 둔다.
			// =====================================================
			if (dto.getOrderId() <= 0) {

				pstmt.setNull(
						idx++,
						java.sql.Types.INTEGER);

			} else {

				pstmt.setInt(
						idx++,
						dto.getOrderId());
			}

			pstmt.setString(idx++, dto.getDocNo());
			pstmt.setInt(idx++, dto.getDocSeq());

			result =
					pstmt.executeUpdate();

			pstmt.close();

			// =====================================================
			// 현재재고 갱신
			// MATERIAL_INOUT 저장 성공 후 INVENTORY를 갱신한다.
			// 입고는 더하고, 출고는 뺀다.
			// =====================================================
			if (result > 0) {

				updateInventoryStock(
					conn,
					dto);
			}

			conn.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}



	// =============================================================
	// 입출고 ID 자동 생성
	// 기존 시퀀스 값이 DB 최대 INOUT_ID보다 작으면
	// PK_MAT_IO 중복 오류(ORA-00001)가 발생할 수 있다.
	// 그래서 등록 시점의 MAX(INOUT_ID) + 1 값을 사용한다.
	// =============================================================
	private int selectNextInoutId(
			Connection conn) throws Exception {

		String sql = "";

		sql += " SELECT ";
		sql += "     NVL(MAX(INOUT_ID), 0) + 1 AS NEXT_INOUT_ID ";
		sql += " FROM MATERIAL_INOUT ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		ResultSet rs =
			pstmt.executeQuery();

		int nextInoutId = 1;

		if (rs.next()) {

			nextInoutId =
				rs.getInt("NEXT_INOUT_ID");
		}

		rs.close();
		pstmt.close();

		return nextInoutId;
	}

	// =============================================================
	// 문서순번 자동 생성
	// 같은 일자 + 같은 입출고구분 기준 다음 DOC_SEQ를 구한다.
	// =============================================================
	private int selectNextDocSeq(
			Connection conn,
			InoutDTO dto) throws Exception {

		String sql = "";

		sql += " SELECT ";
		sql += "     NVL(MAX(DOC_SEQ), 0) + 1 AS NEXT_DOC_SEQ ";
		sql += " FROM MATERIAL_INOUT ";
		sql += " WHERE INOUT_TYPE = ? ";
		sql += " AND TRUNC(INOUT_DATE) = TRUNC(?) ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		pstmt.setString(
			1,
			dto.getInoutType());

		pstmt.setDate(
			2,
			dto.getInoutDate());

		ResultSet rs =
			pstmt.executeQuery();

		int docSeq = 1;

		if (rs.next()) {

			docSeq =
				rs.getInt("NEXT_DOC_SEQ");
		}

		rs.close();
		pstmt.close();

		return docSeq;
	}

	// =============================================================
	// 문서번호 자동 생성
	// 입고는 RM-MI, 출고는 RM-MO 형식으로 만든다.
	// =============================================================
	private String createDocNo(
			InoutDTO dto,
			int docSeq) throws Exception {

		String typeText =
			"IN";

		if ("MI".equals(dto.getInoutType())) {

			typeText =
				"MI";

		} else if ("MO-PROD".equals(dto.getInoutType())) {

			typeText =
				"MO";
		}

		String dateText =
			new SimpleDateFormat("yyyyMMdd")
				.format(dto.getInoutDate());

		return "RM-"
				+ typeText
				+ "-"
				+ dateText
				+ "-"
				+ String.format("%04d", docSeq);
	}

	// =============================================================
	// INVENTORY 현재재고 갱신
	// 창고위치가 선택된 경우 해당 품목 + 창고위치의 현재재고를 갱신한다.
	// 입고는 수량을 더하고, 출고는 수량을 뺀다.
	// =============================================================
	private void updateInventoryStock(
			Connection conn,
			InoutDTO dto) throws Exception {

		// =====================================================
		// 입출고 등록 후 재고조회 페이지에 바로 반영되도록
		// MATERIAL_INOUT 저장이 성공하면 INVENTORY 현재재고를 같이 갱신한다.
		//
		// 핵심 흐름:
		// 1. 입고(MI)     : 현재재고 + 입고수량
		// 2. 출고(MO-PROD): 현재재고 - 출고수량
		// 3. 기존 재고 행이 없고 입고라면 INVENTORY 행을 새로 생성
		//
		// 주의:
		// MATERIAL_INOUT 테이블에는 창고위치 컬럼이 없기 때문에
		// 화면에서 넘어온 dto.stockLocation을 INVENTORY 갱신 기준으로 사용한다.
		// 만약 화면에서 창고위치가 비어 오면 기존 INVENTORY의 대표 창고위치를 찾아서 사용한다.
		// =====================================================
		String stockLocation =
			dto.getStockLocation();

		if (stockLocation == null
				|| stockLocation.trim().equals("")) {

			stockLocation =
				selectDefaultStockLocation(
					conn,
					dto.getItemId());

			dto.setStockLocation(stockLocation);
		}

		// =====================================================
		// 창고위치가 끝까지 없으면 재고 갱신 기준이 없으므로
		// INVENTORY를 잘못 갱신하지 않고 종료한다.
		// 이 경우 MATERIAL_INOUT 이력은 저장되지만 재고조회 현재재고는 변하지 않는다.
		// =====================================================
		if (stockLocation == null
				|| stockLocation.trim().equals("")) {

			System.out.println(
				"재고 반영 실패 : 창고위치가 비어 있습니다. ITEM_ID="
				+ dto.getItemId());

			return;
		}

		stockLocation =
			stockLocation.trim();

		int changeQty =
			dto.getInoutQty();

		// =====================================================
		// 출고는 재고 차감
		// 작업지시 자동 투입도 MO-PROD 유형으로 들어오기 때문에
		// 같은 규칙으로 재고가 차감된다.
		// =====================================================
		if ("MO-PROD".equals(dto.getInoutType())) {

			changeQty =
				changeQty * -1;
		}

		String sql = "";

		sql += " UPDATE INVENTORY ";
		sql += " SET ";
		sql += "     INVENTORY_STOCK = INVENTORY_STOCK + ?, ";
		sql += "     UPDATED_DATE = SYSDATE ";
		sql += " WHERE ITEM_ID = ? ";
		sql += " AND STOCK_LOCATION = ? ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		pstmt.setInt(
			1,
			changeQty);

		pstmt.setInt(
			2,
			dto.getItemId());

		pstmt.setString(
			3,
			stockLocation);

		int updateCount =
			pstmt.executeUpdate();

		pstmt.close();

		// =====================================================
		// 입고인데 해당 품목 + 창고위치 재고 행이 아직 없으면
		// INVENTORY에 새 행을 만든다.
		//
		// 기존에는 SEQ_INVENTORY_ID.NEXTVAL을 사용했는데
		// 시퀀스 값과 실제 DB 최대 INVENTORY_ID가 어긋나면 PK 중복 오류가 날 수 있다.
		// 그래서 여기서는 MAX(INVENTORY_ID) + 1을 사용해서 안정적으로 생성한다.
		// =====================================================
		if (updateCount == 0
				&& "MI".equals(dto.getInoutType())) {

			String insertSql = "";

			insertSql += " INSERT INTO INVENTORY ( ";
			insertSql += "     INVENTORY_ID, ";
			insertSql += "     INVENTORY_STOCK, ";
			insertSql += "     REMARK, ";
			insertSql += "     STOCK_LOCATION, ";
			insertSql += "     CREATED_DATE, ";
			insertSql += "     UPDATED_DATE, ";
			insertSql += "     ITEM_ID ";
			insertSql += " ) VALUES ( ";
			insertSql += "     ?, ";
			insertSql += "     ?, ";
			insertSql += "     ?, ";
			insertSql += "     ?, ";
			insertSql += "     SYSDATE, ";
			insertSql += "     SYSDATE, ";
			insertSql += "     ? ";
			insertSql += " ) ";

			PreparedStatement insertPstmt =
				conn.prepareStatement(insertSql);

			insertPstmt.setInt(
				1,
				selectNextInventoryId(conn));

			insertPstmt.setInt(
				2,
				dto.getInoutQty());

			insertPstmt.setString(
				3,
				"자재 입고 자동반영");

			insertPstmt.setString(
				4,
				stockLocation);

			insertPstmt.setInt(
				5,
				dto.getItemId());

			insertPstmt.executeUpdate();

			insertPstmt.close();
		}
	}

	// =============================================================
	// 품목 기준 대표 창고위치 조회
	// 입출고 등록 시 창고위치가 비어 넘어온 경우 재고 반영이 누락되지 않도록
	// 기존 INVENTORY에 있는 가장 최근 창고위치를 가져온다.
	// =============================================================
	private String selectDefaultStockLocation(
			Connection conn,
			int itemId) throws Exception {

		String stockLocation = "";

		String sql = "";

		sql += " SELECT STOCK_LOCATION ";
		sql += " FROM ( ";
		sql += "     SELECT STOCK_LOCATION ";
		sql += "     FROM INVENTORY ";
		sql += "     WHERE ITEM_ID = ? ";
		sql += "     AND STOCK_LOCATION IS NOT NULL ";
		sql += "     ORDER BY UPDATED_DATE DESC, INVENTORY_ID DESC ";
		sql += " ) ";
		sql += " WHERE ROWNUM = 1 ";

		PreparedStatement pstmt =
			conn.prepareStatement(sql);

		pstmt.setInt(
			1,
			itemId);

		ResultSet rs =
			pstmt.executeQuery();

		if (rs.next()) {

			stockLocation =
				rs.getString("STOCK_LOCATION");
		}

		rs.close();
		pstmt.close();

		return stockLocation;
	}

	// =============================================================
	// INVENTORY_ID 자동 생성
	// INVENTORY 시퀀스가 실제 데이터보다 작을 때 PK 중복이 날 수 있으므로
	// MAX(INVENTORY_ID) + 1로 새 재고번호를 만든다.
	// =============================================================
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


@Override
	public List<InoutDTO> selectMaterialLotList(int itemId) {

		List<InoutDTO> list =
				new ArrayList<InoutDTO>();

		try {

			Connection conn =
					getConnection();

			String sql = "";

			sql += " SELECT ";
			sql += "     MATERIAL_LOT, ";
			sql += "     SUM( ";
			sql += "         CASE ";
			sql += "             WHEN INOUT_TYPE = 'MI' THEN INOUT_QTY ";
			sql += "             WHEN INOUT_TYPE = 'MO-PROD' THEN -INOUT_QTY ";
			sql += "             ELSE 0 ";
			sql += "         END ";
			sql += "     ) AS REMAIN_QTY ";
			sql += " FROM MATERIAL_INOUT ";
			sql += " WHERE ITEM_ID = ? ";
			sql += " AND MATERIAL_LOT IS NOT NULL ";
			sql += " GROUP BY MATERIAL_LOT ";
			sql += " HAVING SUM( ";
			sql += "         CASE ";
			sql += "             WHEN INOUT_TYPE = 'MI' THEN INOUT_QTY ";
			sql += "             WHEN INOUT_TYPE = 'MO-PROD' THEN -INOUT_QTY ";
			sql += "             ELSE 0 ";
			sql += "         END ";
			sql += "     ) > 0 ";
			sql += " ORDER BY MATERIAL_LOT ASC ";

			PreparedStatement pstmt =
					conn.prepareStatement(sql);

			pstmt.setInt(1, itemId);

			ResultSet rs =
					pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto =
						new InoutDTO();

				dto.setItemId(itemId);
				dto.setMaterialLot(rs.getString("MATERIAL_LOT"));
				dto.setInoutQty(rs.getInt("REMAIN_QTY"));

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