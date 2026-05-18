package kr.or.saeroi.AiChatbot;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.service.AiServices;

@Service
public class aiChatService {

	@Autowired
	private ChatLanguageModel geminiModel;

	@Autowired
	private DbTool dbTool;
	
	@Value("${gemini.api.key}")
	private String apikey;
	
	ChatMemory chatMemory = MessageWindowChatMemory.withMaxMessages(10); //질문내용 전역변수로 고정
	
	MesAssistant assistant;
	
	@Autowired
    public void init() {
		this.assistant = AiServices.builder(MesAssistant.class)
						.chatLanguageModel(geminiModel)
						.chatMemory(chatMemory)
						.tools(dbTool)
						.build();
    }
	
	public String getChatResponse(List<aiChatContents> history) {
//		System.out.println("현재 사용 중인 키: " + (apikey != null ? apikey.substring(0, 4) + "****" : "null"));
		//langchain4j방식으로 전환해서 주석 궁금하면 LangChain4j파일로
//		String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent";
		try {
			// 멀티턴을 langchain4j의 클래스가 대체
//			aiChatText requestBody = new aiChatText(history); 	//기억할 채팅 히스토리
//			System.out.println("dbTool확인: " + dbTool);
//			assistant = AiServices.builder(MesAssistant.class)
//						.chatLanguageModel(geminiModel)
//						.chatMemory(chatMemory)
//						.tools(dbTool)
//						.build();
//			HttpHeaders headers = new HttpHeaders();
//			headers.setContentType(MediaType.APPLICATION_JSON);
			//langchain4j방식으로 전환해서 주석 궁금하면 LangChain4j파일로
//			headers.set("x-goog-api-key", apikey);
			//langchain4j방식으로 전환해서 주석 궁금하면 LangChain4j파일로
//			HttpEntity<aiChatText> entity = new HttpEntity<aiChatText>(requestBody,headers);
			//langchain4j방식으로 전환해서 주석 궁금하면 LangChain4j파일로
//			ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
			String lastUserMsg = history.get(history.size()-1).getParts().get(0).getText();
			return assistant.chat(lastUserMsg);
		} catch (org.springframework.web.client.HttpClientErrorException e) {
			System.out.println("구글 에러 응답: " + e.getResponseBodyAsString());
		    return "에러 발생: " + e.getResponseBodyAsString();
		}catch (Exception e) {
			e.printStackTrace();
			return "에러 발생: " + e.getMessage();
		} 
	}
	
}
