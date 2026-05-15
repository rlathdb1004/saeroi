package kr.or.saeroi.AiChatbot;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import dev.langchain4j.agent.tool.Tool;
import kr.or.saeroi.dao.QualityDAO;

public class DbTool {

	@Autowired
	private QualityDAO qualityDAO;
	
	@Tool("이차전지 공장의 특정 생산 라인의 현재 배터리 재고를 조회합니다.")
	public String getLineStatus(String lineName) {
		
		Map<String, Object> data = qualityDAO.selectLineStatus(lineName);
		return data.toString();
	}
}
