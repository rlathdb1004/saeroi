package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.LoginDTO;

@Repository
public class LoginDAO {

    @Autowired
    private DataSource dataSource;
    
    public LoginDTO find_empno(String empno) {

        LoginDTO login = null;

        String sql =
            "SELECT EMPNO, EMP_PW, ENAME, DEPT, JOB, HIRE_DATE, " +
            "EMP_TEL, EMAIL, STATUS, ROLE, CREATED_DATE, UPDATED_DATE " +
            "FROM EMP WHERE EMPNO = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, empno);

            try (ResultSet rs = ps.executeQuery()) {

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
            }

        } catch (Exception e) {
            throw new RuntimeException("사번 조회 실패", e);
        }

        return login;
    }    
    
    public int check_empno_email(String empno, String email) {

        int count = 0;

        String sql =
            "SELECT COUNT(*) CNT FROM EMP WHERE EMPNO = ? AND EMAIL = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, empno);
            ps.setString(2, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    count = rs.getInt("CNT");
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("사번/이메일 확인 실패", e);
        }

        return count;
    }
    
    public void update_pw(String empno, String hashPw) {

        String sql =
            "UPDATE EMP SET EMP_PW = ?, UPDATED_DATE = SYSDATE WHERE EMPNO = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashPw);
            ps.setString(2, empno);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("비밀번호 변경 실패", e);
        }
    }
    
	public void update_auto_login_token(String empno, String token) {

	    String sql =
	        "UPDATE EMP " +
	        "SET AUTO_LOGIN_TOKEN = ? " +
	        "WHERE EMPNO = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, token);
	        ps.setString(2, empno);

	        ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public LoginDTO find_token(String token) {

	    LoginDTO login = null;

	    String sql =
	        "SELECT EMPNO, EMP_PW, ENAME, DEPT, JOB, HIRE_DATE, " +
	        "EMP_TEL, EMAIL, STATUS, ROLE, CREATED_DATE, UPDATED_DATE " +
	        "FROM EMP WHERE AUTO_LOGIN_TOKEN = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, token);

	        try (ResultSet rs = ps.executeQuery()) {

	            if (rs.next()) {

	                login = new LoginDTO();
	                login.setEmpno(rs.getString("EMPNO"));
	                login.setEmp_pw(rs.getString("EMP_PW"));
	                login.setEname(rs.getString("ENAME"));
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
	        }

	    } catch (Exception e) {
	        throw new RuntimeException("자동로그인 조회 실패", e);
	    }

	    return login;
	}
	
	public void clear_auto_login_token(String empno) {

	    String sql = "UPDATE EMP SET AUTO_LOGIN_TOKEN = NULL WHERE EMPNO = ?";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, empno);
	        ps.executeUpdate();

	    } catch (Exception e) {
	        throw new RuntimeException("토큰 삭제 실패", e);
	    }
	}
}
