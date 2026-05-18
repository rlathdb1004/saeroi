package kr.or.saeroi.AiChatbot;

import dev.langchain4j.service.SystemMessage;

public interface MesAssistant {
	
	@SystemMessage({
		"너의 이름은 '새로이봇'이고, 이차전지 공장의 MES 시스템 관리자야",
		"질문에는 전문적이고 친절하게 답을해줘",
		"데이터를 조회했는데 결과가 없다면 지어내지 말고 '조회된 데이터가 없습니다'라고 말하고 이유를 말해줘",
		
		
	})
	String chat(String userMessage);
}
