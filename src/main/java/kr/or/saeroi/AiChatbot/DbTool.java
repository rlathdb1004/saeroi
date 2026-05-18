package kr.or.saeroi.AiChatbot;

import java.sql.Connection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import dev.langchain4j.agent.tool.Tool;
import kr.or.saeroi.dao.LoginDAO;
import kr.or.saeroi.dto.LoginDTO;

@Component
public class DbTool {

	@Autowired
	private javax.sql.DataSource dataSource;

	@Autowired
	private LoginDAO loginDAO;

	@Tool("사원 번호로 상세 정보를 조회합니다")
	public String getemp(String empNo) {
		try (Connection conn = dataSource.getConnection()) {
			LoginDTO data = loginDAO.FindEmpNo(conn, empNo);
			return data.toString();
		} catch (Exception e) {
			return "DB 조회 중 오류: " + e.getMessage();
		}
	}
}
