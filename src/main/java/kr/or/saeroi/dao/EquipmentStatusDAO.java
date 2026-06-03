package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.EquipmentMaintenanceDTO;
import kr.or.saeroi.dto.EquipmentStatusDTO;
import kr.or.saeroi.dto.EquipmentTroubleDTO;

@Repository
public class EquipmentStatusDAO {
	
	@Autowired
	private DataSource dataSource;
	
	public List<EquipmentStatusDTO> eqp_status_list() {

		List<EquipmentStatusDTO> list = new ArrayList<>();

		String sql =
		        "SELECT h.HISTORY_ID, " +
		        "       e.EQUIP_ID, " +
		        "       e.EQUIP_CODE, " +
		        "       e.EQUIP_NAME, " +
		        "       h.OPERATION_DATE, " +
		        "       h.RUNTIME_MIN, " +
		        "       h.DOWNTIME_MIN, " +
		        "       h.DOWN_REASON, " +
		        "       h.REMARK " +		        
		        "FROM EQUIPMENT_HISTORY h " +
		        "JOIN EQUIPMENT e ON h.EQUIP_ID = e.EQUIP_ID " +
		        "ORDER BY h.HISTORY_ID DESC";

		    try (
		        Connection conn = dataSource.getConnection();
		        PreparedStatement ps = conn.prepareStatement(sql);
		        ResultSet rs = ps.executeQuery()
		    ) {

		        while(rs.next()) {

		            EquipmentStatusDTO dto = new EquipmentStatusDTO();

		            dto.setHistory_id(rs.getInt("HISTORY_ID"));
		            dto.setEquip_id(rs.getInt("EQUIP_ID"));
		            dto.setEquip_code(rs.getString("EQUIP_CODE"));
		            dto.setEquip_name(rs.getString("EQUIP_NAME"));
		            dto.setOperation_date(rs.getDate("OPERATION_DATE"));
		            dto.setRuntime_min(rs.getInt("RUNTIME_MIN"));
		            dto.setDowntime_min(rs.getInt("DOWNTIME_MIN"));
		            dto.setDown_reason(rs.getString("DOWN_REASON"));
		            dto.setRemark(rs.getString("REMARK"));		            

		            list.add(dto);
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    return list;
	}
	
	public List<EquipmentStatusDTO> eqp_status_search(
	        String searchType,
	        String keyword) {

	    List<EquipmentStatusDTO> list = new ArrayList<>();

	    StringBuilder sql = new StringBuilder();

	    sql.append(
	        "SELECT h.HISTORY_ID, " +
	        "       e.EQUIP_ID, " +
	        "       e.EQUIP_CODE, " +
	        "       e.EQUIP_NAME, " +
	        "       h.OPERATION_DATE, " +
	        "       h.PLAN_TIME_MIN, " +
	        "       h.RUNTIME_MIN, " +
	        "       h.DOWNTIME_MIN, " +
	        "       h.DOWN_REASON, " +
	        "       h.REMARK, " +
	        "       h.DOC_NO " +	              
	        "FROM EQUIPMENT_HISTORY h " +
	        "JOIN EQUIPMENT e " +
	        "ON h.EQUIP_ID = e.EQUIP_ID " +
	        "WHERE 1=1 "
	    );

	    boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

	    if (hasKeyword) {
	    	
	        switch (searchType) {
	        
	            case "equip_code":
	                sql.append(" AND UPPER(e.EQUIP_CODE) " + "LIKE UPPER(?) ");
	                break;
	            case "equip_name":
	                sql.append(" AND UPPER(e.EQUIP_NAME) " + "LIKE UPPER(?) ");
	                break;
	            case "operation_date":
	                sql.append(" AND TO_CHAR(h.OPERATION_DATE,'YYYY-MM-DD') " +
	                    "LIKE ? ");
	                break;
	            case "down_reason":
	                sql.append(" AND UPPER(h.DOWN_REASON) " + "LIKE UPPER(?) ");
	                break;

	            case "all":
	            default:
	                sql.append(
	                    " AND ( " +
	                    " UPPER(e.EQUIP_CODE) LIKE UPPER(?) " +
	                    " OR UPPER(e.EQUIP_NAME) LIKE UPPER(?) " +
	                    " OR TO_CHAR(h.OPERATION_DATE,'YYYY-MM-DD') LIKE ? " +
	                    " OR TO_CHAR(h.PLAN_TIME_MIN) LIKE ? " +
	                    " OR TO_CHAR(h.RUNTIME_MIN) LIKE ? " +
	                    " OR TO_CHAR(h.DOWNTIME_MIN) LIKE ? " +
	                    " OR UPPER(h.DOWN_REASON) LIKE UPPER(?) " +
	                    " OR UPPER(h.REMARK) LIKE UPPER(?) " +
	                    " OR UPPER(h.DOC_NO) LIKE UPPER(?) " +	                    
	                    " ) "
	                );
	                break;
	        }
	    }

	    sql.append(" ORDER BY h.HISTORY_ID DESC ");

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql.toString())
	    ) {

	        if (hasKeyword) {

	            String param = "%" + keyword.trim() + "%";

	            if ("all".equals(searchType)
	                    || searchType == null
	                    || searchType.isEmpty()) {

	            	ps.setString(1, param);
	            	ps.setString(2, param);
	            	ps.setString(3, param);
	            	ps.setString(4, param);
	            	ps.setString(5, param);
	            	ps.setString(6, param);
	            	ps.setString(7, param);
	            	ps.setString(8, param);
	            	ps.setString(9, param);	            	

	            } else {
	                ps.setString(1, param);
	            }
	        }

	        try (ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	                EquipmentStatusDTO dto = new EquipmentStatusDTO();

	                dto.setHistory_id(rs.getInt("HISTORY_ID"));
	                dto.setEquip_id(rs.getInt("EQUIP_ID"));
	                dto.setEquip_code(rs.getString("EQUIP_CODE"));
	                dto.setEquip_name(rs.getString("EQUIP_NAME"));
	                dto.setOperation_date(rs.getDate("OPERATION_DATE"));
	                dto.setPlan_time_min(rs.getInt("PLAN_TIME_MIN"));
	                dto.setRuntime_min(rs.getInt("RUNTIME_MIN"));
	                dto.setDowntime_min(rs.getInt("DOWNTIME_MIN"));
	                dto.setDown_reason(rs.getString("DOWN_REASON"));
	                dto.setRemark(rs.getString("REMARK"));
	                dto.setDoc_no(rs.getString("DOC_NO"));	                

	                list.add(dto);
	            }
	        }

	    } catch (Exception e) {
	        throw new RuntimeException("설비 상태 검색 실패", e);
	    }
	    return list;
	}
	
	
	public int insert(EquipmentStatusDTO dto) {

	    int result = 0;

	    String sql =
	        "INSERT INTO equipment_history (" +
	        "HISTORY_ID, EQUIP_ID, "+
	        "OPERATION_DATE, TIME_START, TIME_END, " +
	        "PLAN_TIME_MIN, RUNTIME_MIN, DOWNTIME_MIN, " +
	        "DOWN_REASON, REMARK, DOC_NO) " +
	        "VALUES (" +
	        "EQUIPMENT_HISTORY_SEQ.NEXTVAL, ?, "+
	        "?, ?, ?, " +
	        "?, ?, ?, " +
	        "?, ?, ?)";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {
	    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	    	String dateStr = sdf.format(dto.getOperation_date());
	    	String docNo = "EH-" + dateStr + "-" + String.format("%04d", dto.getEquip_id());

	    	LocalDate operation_date = dto.getOperation_date().toLocalDate();
	    	LocalDateTime start_date_time = 
	    			LocalDateTime.of(operation_date, LocalTime.of(8, 0));
	    	LocalDateTime end_date_time = 
	    	        start_date_time.plusMinutes(dto.getPlan_time_min());
	    	Timestamp time_start = Timestamp.valueOf(start_date_time);
	    	Timestamp time_end = Timestamp.valueOf(end_date_time);
	    	    	
	    	
	    	ps.setInt(1, dto.getEquip_id());
	    	ps.setDate(2, dto.getOperation_date());
	    	ps.setTimestamp(3, time_start);
	        ps.setTimestamp(4, time_end);
	    	ps.setInt(5, dto.getPlan_time_min());
	    	ps.setInt(6, dto.getRuntime_min());
	    	ps.setInt(7, dto.getDowntime_min());
	    	ps.setString(8, dto.getDown_reason());
	    	ps.setString(9, dto.getRemark());
	    	ps.setString(10, docNo);

	        result = ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}	
	
	public EquipmentStatusDTO equipment_status_detail(int history_id) {

	    EquipmentStatusDTO dto = null;

	    String sql =
	        "SELECT " +
	        "EH.HISTORY_ID, EH.EQUIP_ID, E.EQUIP_CODE, E.EQUIP_NAME, " +
	        "EH.OPERATION_DATE, EH.PLAN_TIME_MIN, EH.RUNTIME_MIN, EH.DOWNTIME_MIN, " +
	        "EH.DOWN_REASON, EH.DOC_NO, EH.REMARK " +	        
	        "FROM EQUIPMENT_HISTORY EH " +
	        "LEFT JOIN EQUIPMENT E ON EH.EQUIP_ID = E.EQUIP_ID " +	        
	        "WHERE EH.HISTORY_ID = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, history_id);

	        try (ResultSet rs = ps.executeQuery()) {

	        	if (rs.next()) {

	        	    dto = new EquipmentStatusDTO();

	        	    dto.setHistory_id(rs.getInt("HISTORY_ID"));
	        	    dto.setEquip_id(rs.getInt("EQUIP_ID"));
	        	    dto.setEquip_code(rs.getString("EQUIP_CODE"));
	        	    dto.setEquip_name(rs.getString("EQUIP_NAME"));
	        	    dto.setOperation_date(rs.getDate("OPERATION_DATE"));
	        	    dto.setPlan_time_min(rs.getInt("PLAN_TIME_MIN"));
	        	    dto.setRuntime_min(rs.getInt("RUNTIME_MIN"));
	        	    dto.setDowntime_min(rs.getInt("DOWNTIME_MIN"));
	        	    dto.setDown_reason(rs.getString("DOWN_REASON"));
	        	    dto.setDoc_no(rs.getString("DOC_NO"));
	        	    dto.setRemark(rs.getString("REMARK"));
	        	}
	        }
	    } catch (Exception e) {
	        throw new RuntimeException("설비 상세 조회 실패", e);
	    }

	    return dto;
	}
	
	public int update(EquipmentStatusDTO dto) {

	    int result = 0;

	    String sql =
	        "UPDATE EQUIPMENT_HISTORY " +
	        "SET RUNTIME_MIN = ?, " +
	        "    DOWNTIME_MIN = ?, " +
	        "    DOWN_REASON = ?, " +
	        "    REMARK = ? " +	          
	        "WHERE HISTORY_ID = ?";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	        ps.setInt(1, dto.getRuntime_min());
	        ps.setInt(2, dto.getDowntime_min());
	        ps.setString(3, dto.getDown_reason());
	        ps.setString(4, dto.getRemark());
	        ps.setInt(5, dto.getHistory_id());

	        result = ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	
	
	
	public int delete(List<Integer> ids) {

	    int result = 0;

	    StringBuilder sql = new StringBuilder(
	            "DELETE FROM equipment_history WHERE HISTORY_ID IN ("
	        );

	    for(int i=0;i<ids.size();i++) {

	        sql.append("?");

	        if(i < ids.size()-1) {
	            sql.append(",");
	        }
	    }

	    sql.append(")");

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql.toString())
	    ) {

	        for(int i=0;i<ids.size();i++) {
	            ps.setInt(i + 1, ids.get(i));
	        }
	        result = ps.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	
	
	public List<EquipmentMaintenanceDTO> maintenance_history(
	        int equip_id,
	        Date operation_date) {

	    List<EquipmentMaintenanceDTO> list = new ArrayList<>();

	    String sql =
	            "SELECT " +
	            "    EM.EQUIP_MAIN_ID, " +
	            "    EM.EQUIP_ID, " +
	            "    EM.EMP_ID, " +
	            "    E.ENAME, " +
	            "    EM.EQUIP_MAIN_DATE, " +
	            "    EM.EQUIP_MAIN_TYPE, " +
	            "    EM.EQUIP_MAIN_CONTENT, " +
	            "    EM.EQUIP_MAIN_TIME, " +
	            "    EM.REMARK " +
	            "FROM EQUIPMENT_MAINTENANCE EM " +
	            "LEFT JOIN EMP E " +
	            "ON EM.EMP_ID = E.EMP_ID " +
	            "WHERE EM.EQUIP_ID = ? " +
	            "AND EM.EQUIP_MAIN_DATE >= ? " +
	            "AND EM.EQUIP_MAIN_DATE < ? + 1 ";

	        try (
	            Connection conn = dataSource.getConnection();
	            PreparedStatement ps = conn.prepareStatement(sql)
	        ) {
	            ps.setInt(1, equip_id);
	            ps.setDate(2, operation_date);	            
	            ps.setDate(3, operation_date);	            

	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {

	                EquipmentMaintenanceDTO dto = new EquipmentMaintenanceDTO();

	                dto.setEquip_main_id(rs.getInt("EQUIP_MAIN_ID"));
	                dto.setEquip_id(rs.getInt("EQUIP_ID"));
	                dto.setEmp_id(rs.getInt("EMP_ID"));
	                dto.setEname(rs.getString("ENAME"));
	                dto.setEquip_main_date(rs.getDate("EQUIP_MAIN_DATE"));
	                dto.setEquip_main_type(rs.getString("EQUIP_MAIN_TYPE"));
	                dto.setEquip_main_content(rs.getString("EQUIP_MAIN_CONTENT"));
	                dto.setEquip_main_time(rs.getInt("EQUIP_MAIN_TIME"));
	                dto.setRemark(rs.getString("REMARK"));
	                
	                list.add(dto);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return list;
	}
	
	public List<EquipmentTroubleDTO> trouble_history(
	        int equip_id,
	        Date operation_date) {

	    List<EquipmentTroubleDTO> list = new ArrayList<>();

	    String sql =
	        "SELECT " +
	        "    ET.TROUBLE_ID, " +
	        "    ET.EQUIP_ID, " +
	        "    ET.EMP_ID, " +
	        "    E.ENAME, " +
	        "    ET.TROUBLE_CONTENT, " +
	        "    ET.TROUBLE_DATE, " +
	        "    ET.TROUBLE_RESOLVE, " +
	        "    ET.RESOLVE_DATE, " +
	        "    ET.REMARK " +
	        "FROM EQUIPMENT_TROUBLE ET " +
	        "LEFT JOIN EMP E " +
	        "ON ET.EMP_ID = E.EMP_ID " +
	        "WHERE ET.EQUIP_ID = ? " +
	        "AND ET.TROUBLE_DATE < ?+1 " +
	        "AND ( ET.RESOLVE_DATE IS NULL "+ 
	        "    OR ET.RESOLVE_DATE >= ?) ";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	        ps.setInt(1, equip_id);
	        ps.setDate(2, operation_date);
	        ps.setDate(3, operation_date);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {

	            EquipmentTroubleDTO dto = new EquipmentTroubleDTO();

	            dto.setTrouble_id(rs.getInt("TROUBLE_ID"));
	            dto.setEquip_id(rs.getInt("EQUIP_ID"));
	            dto.setEmp_id(rs.getInt("EMP_ID"));
	            dto.setEname(rs.getString("ENAME"));
	            dto.setTrouble_content(rs.getString("TROUBLE_CONTENT"));
	            dto.setTrouble_date(rs.getTimestamp("TROUBLE_DATE"));
	            dto.setTrouble_resolve(rs.getString("TROUBLE_RESOLVE"));
	            dto.setResolve_date(rs.getTimestamp("RESOLVE_DATE"));
	            dto.setRemark(rs.getString("REMARK"));

	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public int maintenance_insert(EquipmentMaintenanceDTO dto) {
		int result = 0;

	    String sql =
	        "INSERT INTO EQUIPMENT_MAINTENANCE (" +
	        "EQUIP_MAIN_ID, EQUIP_ID, "+
	        "EMP_ID, EQUIP_MAIN_DATE, EQUIP_MAIN_TYPE, " +
	        "EQUIP_MAIN_CONTENT, EQUIP_MAIN_TIME, REMARK, " +
	        "CREATED_DATE, UPDATED_DATE) " +
	        "VALUES (" +
	        "EQUIPMENT_MAIN_SEQ.NEXTVAL, ?, "+
	        "?, ?, ?, " +
	        "?, ?, ?, " +
	        "SYSDATE, SYSDATE)";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {
	    	ps.setInt(1, dto.getEquip_id());
	    	ps.setInt(2, dto.getEmp_id());	    	
	    	ps.setDate(3, dto.getEquip_main_date());
	    	ps.setString(4, dto.getEquip_main_type());
	    	ps.setString(5, dto.getEquip_main_content());
	    	if (dto.getEquip_main_time() == null) {
	    	    ps.setInt(6, 0);
	    	} else {
	    	    ps.setInt(6, dto.getEquip_main_time());
	    	}
	    	ps.setString(7, dto.getRemark());

	    	result = ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}

	public int trouble_insert(EquipmentTroubleDTO dto) {
		int result = 0;

	    String sql =
	        "INSERT INTO EQUIPMENT_TROUBLE (" +
	        "TROUBLE_ID, EQUIP_ID, "+
	        "EMP_ID, TROUBLE_CONTENT, TROUBLE_DATE, " +
	        "TROUBLE_RESOLVE, RESOLVE_DATE, REMARK, " +
	        "CREATED_DATE, UPDATED_DATE) " +
	        "VALUES (" +
	        "EQUIPMENT_TROUBLE_SEQ.NEXTVAL, ?, "+
	        "?, ?, ?, ?, " +
	        "?, ?, " +
	        "SYSDATE, SYSDATE)";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	    	ps.setInt(1, dto.getEquip_id());
	    	ps.setInt(2, dto.getEmp_id());
	    	ps.setString(3, dto.getTrouble_content());
	    	ps.setTimestamp(4, dto.getTrouble_date());
	    	ps.setString(5, dto.getTrouble_resolve());
	    	ps.setTimestamp(6, dto.getResolve_date());
	    	ps.setString(7, dto.getRemark());

	    	result = ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	
	public EquipmentMaintenanceDTO maintenance_detail(int equip_main_id) {
		EquipmentMaintenanceDTO dto = null;

	    String sql =
	        "SELECT m.*, e.ENAME, eq.EQUIP_NAME " +
	        "FROM EQUIPMENT_MAINTENANCE m " +
	        "LEFT JOIN emp e ON m.emp_id = e.emp_id " +
	        "LEFT JOIN equipment eq ON m.equip_id = eq.equip_id " +
	        "WHERE m.EQUIP_MAIN_ID = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, equip_main_id);

	        try (ResultSet rs = ps.executeQuery()) {

	            if (rs.next()) {

	                dto = new EquipmentMaintenanceDTO();

	                dto.setEquip_main_id(rs.getInt("EQUIP_MAIN_ID"));
	                dto.setEquip_id(rs.getInt("EQUIP_ID"));
	                dto.setEmp_id(rs.getInt("EMP_ID"));
	                dto.setEquip_main_type(rs.getString("EQUIP_MAIN_TYPE"));
	                dto.setEquip_main_content(rs.getString("EQUIP_MAIN_CONTENT"));
	                dto.setEquip_main_time(rs.getInt("EQUIP_MAIN_TIME"));
	                dto.setEquip_main_date(rs.getDate("EQUIP_MAIN_DATE"));
	                dto.setRemark(rs.getString("REMARK"));
	                dto.setEname(rs.getString("ENAME"));
	                dto.setEquip_name(rs.getString("EQUIP_NAME"));
	            }
	        }

	    } catch (Exception e) {
	        throw new RuntimeException("설비 정비 이력 상세 조회 실패", e);
	    }

	    return dto;
	}
	
	public EquipmentTroubleDTO trouble_detail(int trouble_id) {
		EquipmentTroubleDTO dto = null;

	    String sql =
	        "SELECT t.*, e.ENAME, eq.EQUIP_NAME " +	        	        
	        "FROM EQUIPMENT_TROUBLE t " +	                
	        "LEFT JOIN emp e ON t.emp_id = e.emp_id "+	        
	        "LEFT JOIN equipment eq ON t.equip_id = eq.equip_id " +
	        "WHERE t.TROUBLE_ID = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, trouble_id);

	        try (ResultSet rs = ps.executeQuery()) {

	        	if (rs.next()) {

	        	    dto = new EquipmentTroubleDTO();

	        	    dto.setTrouble_id(rs.getInt("TROUBLE_ID"));
	        	    dto.setEquip_id(rs.getInt("EQUIP_ID"));	        	    
	        	    dto.setEmp_id(rs.getInt("EMP_ID"));
	        	    dto.setTrouble_content(rs.getString("TROUBLE_CONTENT"));	        	    
	        	    dto.setTrouble_date(rs.getTimestamp("TROUBLE_DATE"));
	        	    dto.setTrouble_resolve(rs.getString("TROUBLE_RESOLVE"));
	        	    dto.setResolve_date(rs.getTimestamp("RESOLVE_DATE"));	        	    
	        	    dto.setRemark(rs.getString("REMARK"));
	        	    dto.setEname(rs.getString("ename"));
	        	    dto.setEquip_name(rs.getString("equip_name"));
	        	}
	        }
	    } catch (Exception e) {
	        throw new RuntimeException("설비 고장 이력 상세 조회 실패", e);
	    }

	    return dto;
	}
	public int maintenance_update(EquipmentMaintenanceDTO dto) {
		int result = 0;

	    String sql =
	        "UPDATE EQUIPMENT_MAINTENANCE " +
	        "SET EMP_ID = ?, " +
	        "    EQUIP_MAIN_DATE = ?, " +
	        "    EQUIP_MAIN_TYPE = ?, " +
	        "    EQUIP_MAIN_CONTENT = ?, " +
	        "    EQUIP_MAIN_TIME = ?, " +
	        "    UPDATED_DATE = SYSDATE, " +
	        "    REMARK = ? " +	          
	        "WHERE EQUIP_MAIN_ID = ?";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	    	ps.setInt(1, dto.getEmp_id());
	    	ps.setDate(2, dto.getEquip_main_date());
	    	ps.setString(3, dto.getEquip_main_type());
	    	ps.setString(4, dto.getEquip_main_content());
	    	ps.setInt(5, dto.getEquip_main_time());
	    	ps.setString(6, dto.getRemark());
	    	ps.setInt(7, dto.getEquip_main_id());

	        result = ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	
	public int truoble_update(EquipmentTroubleDTO dto) {
		int result = 0;

	    String sql =
	        "UPDATE EQUIPMENT_TROUBLE " +
	        "SET EMP_ID = ?, " +
	        "    TROUBLE_CONTENT = ?, " +
	        "    TROUBLE_DATE = ?, " +
	        "    TROUBLE_RESOLVE = ?, " +
	        "    RESOLVE_DATE = ?, " +
	        "    UPDATED_DATE = SYSDATE, " +
	        "    REMARK = ? " +	          
	        "WHERE TROUBLE_ID = ?";

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	        ps.setInt(1, dto.getEmp_id());
	        ps.setString(2, dto.getTrouble_content());
	        ps.setTimestamp(3, dto.getTrouble_date());
	        ps.setString(4, dto.getTrouble_resolve());
	        ps.setTimestamp(5, dto.getResolve_date());
	        ps.setString(6, dto.getRemark());
	        ps.setInt(7, dto.getTrouble_id());

	        result = ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}

	public int trouble_delete(List<Integer> ids) {
		int result = 0;

	    StringBuilder sql = new StringBuilder(
	            "DELETE FROM equipment_trouble WHERE trouble_ID IN ("
	        );

	    for(int i=0;i<ids.size();i++) {

	        sql.append("?");

	        if(i < ids.size()-1) {
	            sql.append(",");
	        }
	    }

	    sql.append(")");

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql.toString())
	    ) {

	        for(int i=0;i<ids.size();i++) {
	            ps.setInt(i + 1, ids.get(i));
	        }
	        result = ps.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}

	public int maintenance_delete(List<Integer> ids) {
		int result = 0;

	    StringBuilder sql = new StringBuilder(
	            "DELETE FROM equipment_maintenance WHERE EQUIP_MAIN_ID IN ("
	        );

	    for(int i=0;i<ids.size();i++) {

	        sql.append("?");

	        if(i < ids.size()-1) {
	            sql.append(",");
	        }
	    }

	    sql.append(")");

	    try (
	        Connection conn = dataSource.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql.toString())
	    ) {

	        for(int i=0;i<ids.size();i++) {
	            ps.setInt(i + 1, ids.get(i));
	        }
	        result = ps.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}

	

	


	
}
