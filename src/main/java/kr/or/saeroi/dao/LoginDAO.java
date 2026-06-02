package kr.or.saeroi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
            "SELECT EMP_ID, EMPNO, EMP_PW, ENAME, DEPT, JOB, HIRE_DATE, " +
            "EMP_TEL, EMAIL, STATUS, ROLE, CREATED_DATE, UPDATED_DATE, PROFILE_IMG " +
            "FROM EMP WHERE EMPNO = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, empno);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    login = new LoginDTO();
                    login.setEmp_id(rs.getInt("EMP_ID"));
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
                    login.setProfile_img(rs.getString("PROFILE_IMG"));
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
	
	public int update_my_page(LoginDTO dto) {

	    int result = 0;

	    String sql;
	    System.out.println("empno = " + dto.getEmpno());
	    System.out.println("profile_img = " + dto.getProfile_img());	    

	    if(dto.getEmp_pw() != null && !dto.getEmp_pw().isEmpty()) {

	        sql =
	            "UPDATE EMP " +
	            "SET EMAIL = ?, " +
	            "    EMP_TEL = ?, " +
	            "    PROFILE_IMG = ?, " +
	            "    EMP_PW = ?, " +
	            "    UPDATED_DATE = SYSTIMESTAMP " +
	            "WHERE EMPNO = ?";

	    } else {

	        sql =
	            "UPDATE EMP " +
	            "SET EMAIL = ?, " +
	            "    EMP_TEL = ?, " +
	            "    PROFILE_IMG = ?, " +
	            "    UPDATED_DATE = SYSTIMESTAMP " +
	            "WHERE EMPNO = ?";
	    }

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        if(dto.getEmp_pw() != null && !dto.getEmp_pw().isEmpty()) {

	            ps.setString(1, dto.getEmail());
	            ps.setString(2, dto.getEmp_tel());
	            ps.setString(3, dto.getProfile_img());
	            ps.setString(4, dto.getEmp_pw());
	            ps.setString(5, dto.getEmpno());

	        } else {

	            ps.setString(1, dto.getEmail());
	            ps.setString(2, dto.getEmp_tel());
	            ps.setString(3, dto.getProfile_img());
	            ps.setString(4, dto.getEmpno());
	        }

	        result = ps.executeUpdate();

	    } catch (Exception e) {
	        throw new RuntimeException("마이페이지 수정 실패", e);
	    }

	    return result;
	}
	
	public LoginDTO find_emp_name(String emp_name) {

        LoginDTO login = null;

        String sql =
            "SELECT EMPNO, EMP_PW, ENAME, DEPT, JOB, HIRE_DATE, " +
            "EMP_TEL, EMAIL, STATUS, ROLE, CREATED_DATE, UPDATED_DATE " +
            "FROM EMP WHERE ENAME = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, emp_name);

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
	
	public List<LoginDTO> emp_list() {

	    List<LoginDTO> list = new ArrayList<>();

	    String sql =
	        "SELECT EMP_ID, EMPNO, ENAME " +
	        "FROM EMP " +
//	        "WHERE STATUS = '재직' " +
	        "ORDER BY ENAME";

	    try (Connection conn = dataSource.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {

	            LoginDTO dto = new LoginDTO();
	            
	            dto.setEmp_id(rs.getInt("EMP_ID"));
	            dto.setEmpno(rs.getString("EMPNO"));
	            dto.setEname(rs.getString("ENAME"));

	            list.add(dto);
	        }

	    } catch (Exception e) {
	        throw new RuntimeException("사원 목록 조회 실패", e);
	    }

	    return list;
	}
}
