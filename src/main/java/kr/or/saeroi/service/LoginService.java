package kr.or.saeroi.service;

import java.sql.Connection;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.LoginDAO;
import kr.or.saeroi.dto.LoginDTO;

@Service
public class LoginService {

    @Autowired
    private LoginDAO loginDAO;

    @Autowired
    private DataSource dataSource;

    public LoginDTO login(String empno, String pw) {

        Connection conn = null;

        try {
            conn = dataSource.getConnection();

            LoginDTO login = loginDAO.FindEmpNo(conn, empno);

            if(login == null) {
                return null;
            }

            if(login.getEmp_pw().equals(pw)) {
                return login;
            }

            return null;

        } catch (Exception e) {
            throw new RuntimeException("로그인 실패", e);
        } finally {
            try {
                if(conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean check_user(String empno, String email) {
        return loginDAO.countByEmpNoAndEmail(empno, email) > 0;
    }

	
	public String reset_pw(String empno) {
		// TODO Auto-generated method stub
		return null;
	}

	public void send_temp_pw(String email, String tempPw) {
		// TODO Auto-generated method stub
		
	}
}