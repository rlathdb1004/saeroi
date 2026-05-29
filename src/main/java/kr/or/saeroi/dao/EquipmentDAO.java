package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ClientDTO;
import kr.or.saeroi.dto.EquipmentDTO;
import kr.or.saeroi.dto.LineDTO;

@Repository
public class EquipmentDAO {
	@Autowired
	private DataSource dataSource;

	public List<EquipmentDTO> eqp_list() {

		List<EquipmentDTO> list = new ArrayList<>();

		String sql = "SELECT " 
			    	+ "E.EQUIP_ID, E.LINE_ID, E.EQUIP_CODE, " 
			    	+ "E.EQUIP_NAME, E.EQUIP_STATUS, E.USE_YN, " 
			    	+ "E.EQUIP_LOC, C.CLIENT_NAME, E.REMARK " 
			    	+ "FROM EQUIPMENT E " 
			    	+ "LEFT JOIN CLIENT C ON E.CLIENT_ID = C.CLIENT_ID " 
			    	+ "ORDER BY E.EQUIP_ID DESC";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				EquipmentDTO equipment = new EquipmentDTO();
				
				equipment.setEquip_id(rs.getInt("EQUIP_ID"));
				equipment.setLine_id(rs.getInt("LINE_ID"));
				equipment.setEquip_code(rs.getString("EQUIP_CODE"));
				equipment.setEquip_name(rs.getString("EQUIP_NAME"));
				equipment.setEquip_status(rs.getString("EQUIP_STATUS"));
				equipment.setUse_yn(rs.getString("USE_YN"));
				equipment.setEquip_loc(rs.getString("EQUIP_LOC"));
				equipment.setClient_name(rs.getString("CLIENT_NAME"));
				equipment.setRemark(rs.getString("REMARK"));
				
				list.add(equipment);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}

	public List<EquipmentDTO> search_eqp_list(
	        String searchType,
	        String keyword) {

	    List<EquipmentDTO> list = new ArrayList<>();

	    StringBuilder sql = new StringBuilder();

	    sql.append(
	        "SELECT " +
	        "    e.EQUIP_ID, " +
	        "    e.EQUIP_CODE, " +
	        "    e.EQUIP_NAME, " +
	        "    e.USE_YN, " +
	        "    e.EQUIP_STATUS, " +
	        "    e.EQUIP_LOC, " +
	        "    e.REMARK, " +
	        "    c.CLIENT_NAME, " +
	        "    e.EQUIP_PRICE, " +
	        "    e.BUY_DATE " +
	        "FROM EQUIPMENT e " +
	        "LEFT JOIN CLIENT c " +
	        "ON e.CLIENT_ID = c.CLIENT_ID " +
	        "WHERE 1=1 "
	    );

	    boolean hasKeyword =
	            keyword != null &&
	            !keyword.trim().isEmpty();

	    if (hasKeyword) {

	        switch (searchType) {

	            case "equip_code":
	                sql.append(
	                    " AND UPPER(e.EQUIP_CODE) LIKE UPPER(?) ");
	                break;
	            case "equip_name":
	                sql.append(
	                    " AND UPPER(e.EQUIP_NAME) LIKE UPPER(?) ");
	                break;
	            case "equip_status":
	                sql.append(
	                    " AND UPPER(e.EQUIP_STATUS) LIKE UPPER(?) ");
	                break;
	            case "use_yn":
	                sql.append(
	                    " AND UPPER(e.USE_YN) LIKE UPPER(?) ");
	                break;
	            case "equip_loc":
	                sql.append(
	                    " AND UPPER(e.EQUIP_LOC) LIKE UPPER(?) ");
	                break;
	            case "client_name":
	                sql.append(
	                    " AND UPPER(c.CLIENT_NAME) LIKE UPPER(?) ");
	                break;
	            case "all":
	            default:
	                sql.append(
	                    " AND ( " +
	                    " UPPER(e.EQUIP_CODE) LIKE UPPER(?) " +
	                    " OR UPPER(e.EQUIP_NAME) LIKE UPPER(?) " +
	                    " OR UPPER(e.USE_YN) LIKE UPPER(?) " +
	                    " OR UPPER(e.EQUIP_STATUS) LIKE UPPER(?) " +
	                    " OR UPPER(e.EQUIP_LOC) LIKE UPPER(?) " +
	                    " OR UPPER(c.CLIENT_NAME) LIKE UPPER(?) " +
	                    " ) "
	                );
	                break;
	        }
	    }

	    sql.append(" ORDER BY e.EQUIP_ID DESC ");

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps =
	                conn.prepareStatement(sql.toString())
	    ) {

	        if (hasKeyword) {

	            String param =
	                    "%" + keyword.trim() + "%";

	            if ("all".equals(searchType)
	                    || searchType == null
	                    || searchType.isEmpty()) {

	                ps.setString(1, param);
	                ps.setString(2, param);
	                ps.setString(3, param);
	                ps.setString(4, param);
	                ps.setString(5, param);
	                ps.setString(6, param);

	            } else {

	                ps.setString(1, param);
	            }
	        }

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {

	            EquipmentDTO dto = new EquipmentDTO();

	            dto.setEquip_id(rs.getInt("EQUIP_ID"));
	            dto.setEquip_code(rs.getString("EQUIP_CODE"));
	            dto.setEquip_name(rs.getString("EQUIP_NAME"));
	            dto.setUse_yn(rs.getString("USE_YN"));
	            dto.setEquip_status(rs.getString("EQUIP_STATUS"));
	            dto.setEquip_loc(rs.getString("EQUIP_LOC"));
	            dto.setRemark(rs.getString("REMARK"));
	            dto.setClient_name(rs.getString("CLIENT_NAME"));

	            list.add(dto);
	        }

	    } catch (Exception e) {
	        throw new RuntimeException(
	                "설비 검색 실패", e);
	    }
	    return list;
	}

	public int insert_equipment(EquipmentDTO dto) {

		int result = 0;

		String sql = "INSERT INTO EQUIPMENT ( " 
				+ "    EQUIP_ID, EQUIP_CODE, EQUIP_NAME, EQUIP_STATUS, "
				+ "    LINE_ID, EQUIP_LOC, CLIENT_ID, EQUIP_PRICE, "
				+ "    BUY_DATE, REMARK, CREATED_DATE " 
				+ ") VALUES ( "
				+ "    EQUIPMENT_SEQ.NEXTVAL, " 
				+ "    ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP " 
				+ ")";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, dto.getEquip_code());
			ps.setString(2, dto.getEquip_name());
			ps.setString(3, dto.getEquip_status());
			ps.setInt(4, dto.getLine_id());
			ps.setString(5, dto.getEquip_loc());
			if (dto.getClient_id() > 0) {
				ps.setInt(6, dto.getClient_id());
			} else {
				ps.setNull(6, java.sql.Types.INTEGER);
			}
			if (dto.getEquip_price() != null) {
				ps.setInt(7, dto.getEquip_price());
			} else {
				ps.setNull(7, java.sql.Types.INTEGER);
			}
			if (dto.getBuy_date() != null) {
				ps.setDate(8, dto.getBuy_date());
			} else {
				ps.setNull(8, java.sql.Types.DATE);
			}
			ps.setString(9, dto.getRemark());
			result = ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("설비 등록 실패");
		}

		return result;
	}

	public List<ClientDTO> get_client_list() {

		List<ClientDTO> list = new ArrayList<>();

		String sql = "SELECT CLIENT_ID, CLIENT_NAME " 
				+ "FROM CLIENT " 
				+ "ORDER BY CLIENT_NAME";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				ClientDTO dto = new ClientDTO();

				dto.setClient_id(rs.getInt("CLIENT_ID"));
				dto.setClient_name(rs.getString("CLIENT_NAME"));

				list.add(dto);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}
	
	public List<LineDTO> get_line_list() {

		List<LineDTO> list = new ArrayList<>();

		String sql = "SELECT LINE_ID, LINE_NAME " 
				+ "FROM LINE " 
				+ "ORDER BY LINE_ID";

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				LineDTO dto = new LineDTO();

				dto.setLine_id(rs.getInt("LINE_ID"));
				dto.setLine_name(rs.getString("LINE_NAME"));

				list.add(dto);
			}

		} catch (Exception e) {

			e.printStackTrace();
		}

		return list;
	}


	public int delete_equipment(List<Integer> eqpIds) {

		int result = 0;

		StringBuilder sql = new StringBuilder();
		sql.append("DELETE FROM EQUIPMENT WHERE EQUIP_ID IN (");

		for (int i = 0; i < eqpIds.size(); i++) {

			sql.append("?");

			if (i < eqpIds.size() - 1) {
				sql.append(",");
			}
		}

		sql.append(")");

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			for (int i = 0; i < eqpIds.size(); i++) {
				ps.setInt(i + 1, eqpIds.get(i));
			}

			result = ps.executeUpdate();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return result;
	}

	public EquipmentDTO get_equipment_detail(String equip_id) {

	    EquipmentDTO dto = null;

	    String sql =
	        "SELECT " +
	        "E.EQUIP_ID, E.EQUIP_CODE, E.EQUIP_NAME, E.EQUIP_STATUS, E.REMARK, " +
	        "E.EQUIP_PRICE, E.BUY_DATE, E.EQUIP_LOC, E.USE_YN, " +
	        "E.CREATED_DATE, E.UPDATED_DATE, " +
	        "E.LINE_ID, L.LINE_NAME, " +
	        "E.CLIENT_ID, C.CLIENT_NAME " +
	        "FROM EQUIPMENT E " +
	        "LEFT JOIN LINE L ON E.LINE_ID = L.LINE_ID " +
	        "LEFT JOIN CLIENT C ON E.CLIENT_ID = C.CLIENT_ID " +
	        "WHERE E.EQUIP_ID = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, equip_id);

	        try (ResultSet rs = ps.executeQuery()) {

	            if (rs.next()) {
	                dto = new EquipmentDTO();

	                dto.setEquip_id(rs.getInt("EQUIP_ID"));
	                dto.setEquip_code(rs.getString("EQUIP_CODE"));
	                dto.setEquip_name(rs.getString("EQUIP_NAME"));
	                dto.setEquip_status(rs.getString("EQUIP_STATUS"));
	                dto.setRemark(rs.getString("REMARK"));
	                dto.setUse_yn(rs.getString("USE_YN"));
	                int price = rs.getInt("EQUIP_PRICE");
	                dto.setEquip_price(rs.wasNull() ? null : price);
	                dto.setBuy_date(rs.getDate("BUY_DATE"));
	                dto.setEquip_loc(rs.getString("EQUIP_LOC"));
	                dto.setCreated_date(rs.getTimestamp("CREATED_DATE"));
	                dto.setUpdated_date(rs.getTimestamp("UPDATED_DATE"));
	                dto.setLine_id(rs.getInt("LINE_ID"));
	                dto.setLine_name(rs.getString("LINE_NAME"));
	                dto.setClient_id(rs.getInt("CLIENT_ID"));
	                dto.setClient_name(rs.getString("CLIENT_NAME"));
	            }
	        }

	    } catch (Exception e) {
	        throw new RuntimeException("설비 상세 조회 실패", e);
	    }

	    return dto;
	}
	
	
	public int update_equipment(EquipmentDTO dto) {
		
	    int result = 0;

	    String sql =
	        "UPDATE EQUIPMENT " +
	        "SET EQUIP_STATUS = ?, " +	        
	        "    USE_YN = ?, " +
	        "    UPDATED_DATE = SYSTIMESTAMP, " +
	        "    REMARK = ? " +
	        "WHERE EQUIP_ID = ?";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {
	    	
	        ps.setString(1, dto.getEquip_status());
	        ps.setString(2, dto.getUse_yn());	       
	        ps.setString(3, dto.getRemark());
	        ps.setInt(4, dto.getEquip_id());

	        result = ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException("설비 수정 실패", e);
	    }

	    return result;
	}
}
