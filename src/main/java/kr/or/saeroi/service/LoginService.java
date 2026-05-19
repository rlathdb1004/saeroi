package kr.or.saeroi.service;

import java.sql.Connection;
import java.util.UUID;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import kr.or.saeroi.dao.LoginDAO;
import kr.or.saeroi.dto.LoginDTO;

@Service
public class LoginService {

    @Autowired
    private LoginDAO loginDAO;
    
    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    public LoginDTO login(String empno, String pw) {

        LoginDTO login = loginDAO.find_empno(empno);

        if(login == null) {
            return null;
        }
        
        if(!"재직".equals(login.getStatus())) {
            return null;
        }

        boolean match =
                passwordEncoder.matches(pw, login.getEmp_pw());

        if(match) {
            return login;
        }

        return null;
    }

    public boolean check_user(String empno, String email) {
        return loginDAO.check_empno_email(empno, email) > 0;
    }

    public String reset_pw(String empno) {
        String temp_pw =
                UUID.randomUUID().toString().substring(0, 8);

        String hash_pw =
                passwordEncoder.encode(temp_pw);
        loginDAO.update_pw(empno, hash_pw);

        return temp_pw;
    }

    public void send_temp_pw(String email, String tempPw) {

        SimpleMailMessage msg = new SimpleMailMessage();

        msg.setTo(email);
        msg.setSubject("임시 비밀번호 안내");
        msg.setText("임시 비밀번호는 " + tempPw + " 입니다.");

        mailSender.send(msg);
    }

    public void update_auto_login_token(String empno, String token) {

        loginDAO.update_auto_login_token(empno, token);
    }

	public LoginDTO find_token(String token) {

	    return loginDAO.find_token(token);
	}
	
	public void clear_auto_login_token(String empno) {
	    loginDAO.clear_auto_login_token(empno);
	}
	
	public int update_my_page(LoginDTO dto) {
	    return loginDAO.update_my_page(dto);
	}
}