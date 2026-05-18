package kr.or.saeroi.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class LoginDTO {	
	private String empno;
	private String emp_pw;
	private String ename;	
	private String dept;
	private String job;
	private Timestamp hire_date;
	private String emp_tel;
	private String email;	
	private String status;
	private String role;	
	private Timestamp created_date;
	private Timestamp updated_date;	
}

