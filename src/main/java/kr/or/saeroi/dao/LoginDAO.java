package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.LoginDTO;

@Repository
public class LoginDAO {

	public LoginDTO FindEmpNo(Connection conn, String empNo){
		LoginDTO login = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = ""
                + "SELECT EMPNO, EMP_PW, ENAME, DEPT, JOB, HIRE_DATE,"
                + "       EMP_TEL, EMAIL, STATUS, ROLE,  "                
                + "       CREATED_DATE, UPDATED_DATE "
                + "FROM EMP "
                + "WHERE EMPNO = ? ";   
        
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, empNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                login = new LoginDTO();                
                login.setEmpno(rs.getString("EMPNO"));
                login.setEname(rs.getString("ENAME"));
                login.setEmp_pw(rs.getString("EMP_PW"));
                login.setDept(rs.getString("DEPT"));
                login.setJob(rs.getString("JOB"));
                login.setEmail(rs.getString("EMAIL"));
                login.setEmp_tel(rs.getString("EMP_TEL"));
                login.setStatus(rs.getString("STATUS"));
                login.setRole(rs.getString("ROLE"));                
                login.setHire_date(rs.getTimestamp("HIRE_DATE"));               
                login.setCreated_date(rs.getTimestamp("CREATED_DATE"));
                login.setUpdated_date(rs.getTimestamp("UPDATED_DATE"));
            }

        } catch (Exception e) {
            throw new RuntimeException("사번 조회 실패", e);
        } finally {
            try {
            	if(rs != null) rs.close();            	
			} catch (SQLException e) {				
				e.printStackTrace();
			}
            try {
            	if(ps != null) ps.close();
			} catch (SQLException e) {				
				e.printStackTrace();
			}
        }

        return login;
	}

	public int countByEmpNoAndEmail(String empno, String email) {
		
		return 0;
	}
}
