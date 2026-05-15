package kr.or.saeroi.member.service;

import java.sql.Connection;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.member.dao.LoginDAO;
import kr.or.saeroi.member.dto.LoginDTO;

@Service
public class LoginService {

    @Autowired
    private LoginDAO loginDAO;

    @Autowired
    private DataSource dataSource;

    public LoginDTO login(String emp_no, String pw) {

        Connection conn = null;

        try {
            conn = dataSource.getConnection();

            LoginDTO login = loginDAO.FindEmpNo(conn, emp_no);

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
}