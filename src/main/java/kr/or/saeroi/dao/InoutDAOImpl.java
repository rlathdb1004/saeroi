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

// 입출고 DAO 구현 클래스
@Repository
public class InoutDAOImpl implements InoutDAO {

	// DB 연결
	private Connection getConnection() throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url = "jdbc:oracle:thin:@//125.181.132.133:51521/xe";
		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(url, id, pw);
	}

	// 팀장님 Tool 코드용
	@Override
	public List<InoutDTO> selectInoutList(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		String inoutType = "";

		// 구분 검색일 때 입고/출고 값 바꾸기
		if ("구분".equals(searchType)) {

			if ("입고".equals(keyword)) {
				inoutType = "MI";
				keyword = "";

			} else if ("출고".equals(keyword)) {
				inoutType = "MO-PROD";
				keyword = "";
			}
		}

		return selectInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);
	}

	// 입출고 목록 조회
	@Override
	public List<InoutDTO> selectInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		List<InoutDTO> list = new ArrayList<InoutDTO>();

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

			// 입출고구분 검색
			if (inoutType != null && !inoutType.equals("")) {
				sql += " AND MI.INOUT_TYPE = ? ";
			}

			// 검색어가 있을 때
			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					sql += " AND I.ITEM_CODE LIKE ? ";

				} else if ("itemName".equals(searchType)) {
					sql += " AND I.ITEM_NAME LIKE ? ";

				} else {
					sql += " AND (I.ITEM_CODE LIKE ? ";
					sql += " OR I.ITEM_NAME LIKE ?) ";
				}
			}

			// 시작일 검색
			if (startDate != null && !startDate.equals("")) {
				sql += " AND MI.INOUT_DATE >= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			// 종료일 검색
			if (endDate != null && !endDate.equals("")) {
				sql += " AND MI.INOUT_DATE <= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			// 최신순 정렬
			sql += " ORDER BY MI.INOUT_ID DESC ";

			PreparedStatement pstmt = conn.prepareStatement(sql);

			int idx = 1;

			// 입출고구분 값 넣기
			if (inoutType != null && !inoutType.equals("")) {
				pstmt.setString(idx++, inoutType);
			}

			// 검색어 값 넣기
			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else if ("itemName".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else {
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
				}
			}

			// 시작일 값 넣기
			if (startDate != null && !startDate.equals("")) {
				pstmt.setString(idx++, startDate);
			}

			// 종료일 값 넣기
			if (endDate != null && !endDate.equals("")) {
				pstmt.setString(idx++, endDate);
			}

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto = new InoutDTO();

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

	// 전체 개수 조회
	@Override
	public int selectInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		int count = 0;

		try {
			Connection conn = getConnection();

			String sql = "";

			sql += " SELECT COUNT(*) ";
			sql += " FROM MATERIAL_INOUT MI ";
			sql += " JOIN ITEM I ";
			sql += " ON MI.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE 1 = 1 ";

			// 입출고구분 검색
			if (inoutType != null && !inoutType.equals("")) {
				sql += " AND MI.INOUT_TYPE = ? ";
			}

			// 검색어가 있을 때
			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					sql += " AND I.ITEM_CODE LIKE ? ";

				} else if ("itemName".equals(searchType)) {
					sql += " AND I.ITEM_NAME LIKE ? ";

				} else {
					sql += " AND (I.ITEM_CODE LIKE ? ";
					sql += " OR I.ITEM_NAME LIKE ?) ";
				}
			}

			// 시작일 검색
			if (startDate != null && !startDate.equals("")) {
				sql += " AND MI.INOUT_DATE >= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			// 종료일 검색
			if (endDate != null && !endDate.equals("")) {
				sql += " AND MI.INOUT_DATE <= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			PreparedStatement pstmt = conn.prepareStatement(sql);

			int idx = 1;

			// 입출고구분 값 넣기
			if (inoutType != null && !inoutType.equals("")) {
				pstmt.setString(idx++, inoutType);
			}

			// 검색어 값 넣기
			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else if ("itemName".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else {
					pstmt.setString(idx++, "%" + keyword + "%");
					pstmt.setString(idx++, "%" + keyword + "%");
				}
			}

			// 시작일 값 넣기
			if (startDate != null && !startDate.equals("")) {
				pstmt.setString(idx++, startDate);
			}

			// 종료일 값 넣기
			if (endDate != null && !endDate.equals("")) {
				pstmt.setString(idx++, endDate);
			}

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

	// 품목 목록 조회
	@Override
	public List<InoutDTO> selectItemList() {

		List<InoutDTO> list = new ArrayList<InoutDTO>();

		try {
			Connection conn = getConnection();

			String sql = "";

			sql += " SELECT ITEM_ID, ITEM_CODE, ITEM_NAME, ITEM_TYPE, ITEM_UNIT ";
			sql += " FROM ITEM ";
			sql += " ORDER BY ITEM_ID ASC ";

			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				InoutDTO dto = new InoutDTO();

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

	// 입출고 등록
	@Override
	public int insertInout(InoutDTO dto) {

		int result = 0;

		try {
			Connection conn = getConnection();

			int inoutId = 1;

			String idSql = " SELECT NVL(MAX(INOUT_ID), 0) + 1 FROM MATERIAL_INOUT ";

			PreparedStatement idPstmt = conn.prepareStatement(idSql);
			ResultSet idRs = idPstmt.executeQuery();

			if (idRs.next()) {
				inoutId = idRs.getInt(1);
			}

			idRs.close();
			idPstmt.close();

			String itemType = "";

			String itemSql = "";
			itemSql += " SELECT ITEM_TYPE ";
			itemSql += " FROM ITEM ";
			itemSql += " WHERE ITEM_ID = ? ";

			PreparedStatement itemPstmt = conn.prepareStatement(itemSql);
			itemPstmt.setInt(1, dto.getItemId());

			ResultSet itemRs = itemPstmt.executeQuery();

			if (itemRs.next()) {
				itemType = itemRs.getString("ITEM_TYPE");
			}

			itemRs.close();
			itemPstmt.close();

			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String dateText = sdf.format(dto.getInoutDate());

			String typeText = "MI";

			if ("MO-PROD".equals(dto.getInoutType())) {
				typeText = "MO";
			}

			String docPrefix = itemType + "-" + typeText + "-" + dateText;

			int docSeq = 1;

			String seqSql = "";
			seqSql += " SELECT NVL(MAX(DOC_SEQ), 0) + 1 ";
			seqSql += " FROM MATERIAL_INOUT ";
			seqSql += " WHERE DOC_NO LIKE ? ";

			PreparedStatement seqPstmt = conn.prepareStatement(seqSql);
			seqPstmt.setString(1, docPrefix + "%");

			ResultSet seqRs = seqPstmt.executeQuery();

			if (seqRs.next()) {
				docSeq = seqRs.getInt(1);
			}

			seqRs.close();
			seqPstmt.close();

			String docNo = docPrefix + "-" + String.format("%04d", docSeq);

			String lotNo = "LOT-" + dateText + "-" + String.format("%04d", docSeq);

			String sql = "";

			sql += " INSERT INTO MATERIAL_INOUT ( ";
			sql += "     INOUT_ID, EMP_ID, INOUT_TYPE, MATERIAL_LOT, ";
			sql += "     INOUT_QTY, INOUT_DATE, REMARK, ";
			sql += "     CREATED_DATE, UPDATED_DATE, USE_YN, STATUS, ";
			sql += "     ORDER_ID, ITEM_ID, DOC_NO, DOC_SEQ ";
			sql += " ) VALUES ( ";
			sql += "     ?, 4, ?, ?, ";
			sql += "     ?, ?, ?, ";
			sql += "     SYSDATE, SYSDATE, 'Y', '완료', ";
			sql += "     NULL, ?, ?, ? ";
			sql += " ) ";

			PreparedStatement pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, inoutId);
			pstmt.setString(2, dto.getInoutType());
			pstmt.setString(3, lotNo);
			pstmt.setInt(4, dto.getInoutQty());
			pstmt.setDate(5, new Date(dto.getInoutDate().getTime()));
			pstmt.setString(6, dto.getRemark());
			pstmt.setInt(7, dto.getItemId());
			pstmt.setString(8, docNo);
			pstmt.setInt(9, docSeq);

			result = pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	// 입출고 상세조회
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

			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, inoutId);

			ResultSet rs = pstmt.executeQuery();

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

	// 선택 삭제
	@Override
	public int deleteInout(String[] inoutIds) {

		int result = 0;

		try {
			Connection conn = getConnection();

			String sql = "";
			sql += " DELETE FROM MATERIAL_INOUT ";
			sql += " WHERE INOUT_ID = ? ";

			PreparedStatement pstmt = conn.prepareStatement(sql);

			for (int i = 0; i < inoutIds.length; i++) {

				// 선택한 입출고 ID 넣기
				pstmt.setInt(1, Integer.parseInt(inoutIds[i]));

				// 삭제 실행
				result += pstmt.executeUpdate();
			}

			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	// 입출고 수정
	@Override
	public int updateInout(InoutDTO dto) {

		int result = 0;

		try {
			Connection conn = getConnection();

			String sql = "";

			sql += " UPDATE MATERIAL_INOUT ";
			sql += " SET ";
			sql += "     INOUT_TYPE = ?, ";
			sql += "     INOUT_QTY = ?, ";
			sql += "     INOUT_DATE = ?, ";
			sql += "     REMARK = ?, ";
			sql += "     UPDATED_DATE = SYSDATE ";
			sql += " WHERE INOUT_ID = ? ";

			PreparedStatement pstmt = conn.prepareStatement(sql);

			// 입출고구분
			pstmt.setString(1, dto.getInoutType());

			// 수량
			pstmt.setInt(2, dto.getInoutQty());

			// 일자
			pstmt.setDate(3, new Date(dto.getInoutDate().getTime()));

			// 비고
			pstmt.setString(4, dto.getRemark());

			// 입출고 ID
			pstmt.setInt(5, dto.getInoutId());

			// 수정 실행
			result = pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
}