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

	private Connection getConnection() throws Exception {

		Class.forName("oracle.jdbc.driver.OracleDriver");

		String url = "jdbc:oracle:thin:@//125.181.132.133:51521/xe";
		String id = "tofhdl";
		String pw = "rlatofhdl";

		return DriverManager.getConnection(url, id, pw);
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

		List<InoutDTO> list = new ArrayList<InoutDTO>();

		// 검색어에 입고/출고를 직접 입력했을 때 처리
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

			if (inoutType != null && !inoutType.equals("")) {
				sql += " AND MI.INOUT_TYPE = ? ";
			}

			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					sql += " AND I.ITEM_CODE LIKE ? ";

				} else if ("itemName".equals(searchType)) {
					sql += " AND I.ITEM_NAME LIKE ? ";

				} else {
					sql += " AND ( ";
					sql += " I.ITEM_CODE LIKE ? ";
					sql += " OR I.ITEM_NAME LIKE ? ";
					sql += " OR I.ITEM_UNIT LIKE ? ";
					sql += " OR MI.DOC_NO LIKE ? ";
					sql += " OR MI.MATERIAL_LOT LIKE ? ";
					sql += " OR MI.REMARK LIKE ? ";
					sql += " OR TO_CHAR(MI.INOUT_QTY) LIKE ? ";
					sql += " OR TO_CHAR(MI.INOUT_DATE, 'YYYY-MM-DD') LIKE ? ";
					sql += " OR CASE WHEN MI.INOUT_TYPE = 'MI' THEN '입고' ";
					sql += "         WHEN MI.INOUT_TYPE = 'MO-PROD' THEN '출고' ";
					sql += "         ELSE MI.INOUT_TYPE END LIKE ? ";
					sql += " OR CASE WHEN I.ITEM_TYPE = 'FG' THEN '완제품' ";
					sql += "         WHEN I.ITEM_TYPE = 'RM' THEN '원자재' ";
					sql += "         WHEN I.ITEM_TYPE = 'SM' THEN '부자재' ";
					sql += "         ELSE I.ITEM_TYPE END LIKE ? ";
					sql += " ) ";
				}
			}

			if (startDate != null && !startDate.equals("")) {
				sql += " AND MI.INOUT_DATE >= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			if (endDate != null && !endDate.equals("")) {
				sql += " AND MI.INOUT_DATE <= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			sql += " ORDER BY MI.INOUT_ID DESC ";

			PreparedStatement pstmt = conn.prepareStatement(sql);

			int idx = 1;

			if (inoutType != null && !inoutType.equals("")) {
				pstmt.setString(idx++, inoutType);
			}

			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else if ("itemName".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else {
					for (int i = 0; i < 10; i++) {
						pstmt.setString(idx++, "%" + keyword + "%");
					}
				}
			}

			if (startDate != null && !startDate.equals("")) {
				pstmt.setString(idx++, startDate);
			}

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

	@Override
	public int selectInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		int count = 0;

		// 검색어에 입고/출고를 직접 입력했을 때 처리
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

			sql += " SELECT COUNT(*) ";
			sql += " FROM MATERIAL_INOUT MI ";
			sql += " JOIN ITEM I ";
			sql += " ON MI.ITEM_ID = I.ITEM_ID ";
			sql += " WHERE 1 = 1 ";

			if (inoutType != null && !inoutType.equals("")) {
				sql += " AND MI.INOUT_TYPE = ? ";
			}

			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					sql += " AND I.ITEM_CODE LIKE ? ";

				} else if ("itemName".equals(searchType)) {
					sql += " AND I.ITEM_NAME LIKE ? ";

				} else {
					sql += " AND ( ";
					sql += " I.ITEM_CODE LIKE ? ";
					sql += " OR I.ITEM_NAME LIKE ? ";
					sql += " OR I.ITEM_UNIT LIKE ? ";
					sql += " OR MI.DOC_NO LIKE ? ";
					sql += " OR MI.MATERIAL_LOT LIKE ? ";
					sql += " OR MI.REMARK LIKE ? ";
					sql += " OR TO_CHAR(MI.INOUT_QTY) LIKE ? ";
					sql += " OR TO_CHAR(MI.INOUT_DATE, 'YYYY-MM-DD') LIKE ? ";
					sql += " OR CASE WHEN MI.INOUT_TYPE = 'MI' THEN '입고' ";
					sql += "         WHEN MI.INOUT_TYPE = 'MO-PROD' THEN '출고' ";
					sql += "         ELSE MI.INOUT_TYPE END LIKE ? ";
					sql += " OR CASE WHEN I.ITEM_TYPE = 'FG' THEN '완제품' ";
					sql += "         WHEN I.ITEM_TYPE = 'RM' THEN '원자재' ";
					sql += "         WHEN I.ITEM_TYPE = 'SM' THEN '부자재' ";
					sql += "         ELSE I.ITEM_TYPE END LIKE ? ";
					sql += " ) ";
				}
			}

			if (startDate != null && !startDate.equals("")) {
				sql += " AND MI.INOUT_DATE >= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			if (endDate != null && !endDate.equals("")) {
				sql += " AND MI.INOUT_DATE <= TO_DATE(?, 'YYYY-MM-DD') ";
			}

			PreparedStatement pstmt = conn.prepareStatement(sql);

			int idx = 1;

			if (inoutType != null && !inoutType.equals("")) {
				pstmt.setString(idx++, inoutType);
			}

			if (keyword != null && !keyword.equals("")) {

				if ("itemCode".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else if ("itemName".equals(searchType)) {
					pstmt.setString(idx++, "%" + keyword + "%");

				} else {
					for (int i = 0; i < 10; i++) {
						pstmt.setString(idx++, "%" + keyword + "%");
					}
				}
			}

			if (startDate != null && !startDate.equals("")) {
				pstmt.setString(idx++, startDate);
			}

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
				pstmt.setInt(1, Integer.parseInt(inoutIds[i]));
				result += pstmt.executeUpdate();
			}

			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

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

			pstmt.setString(1, dto.getInoutType());
			pstmt.setInt(2, dto.getInoutQty());
			pstmt.setDate(3, new Date(dto.getInoutDate().getTime()));
			pstmt.setString(4, dto.getRemark());
			pstmt.setInt(5, dto.getInoutId());

			result = pstmt.executeUpdate();

			pstmt.close();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
}