package kr.or.saeroi.AiChatbot;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.service.AiServices;

@Service
public class aiChatService {

	@Autowired
	private ChatLanguageModel geminiModel;

	@Autowired
	private DbTool dbTool;

	@Autowired
	private ContentRetriever contentRetriever;
	
	@Value("${gemini.api.key}")
	private String apikey;
	
	
	private final Map<String, MesAssistant> assistantCache = new ConcurrentHashMap<>();
	
	
	MesAssistant assistant;
	
    public MesAssistant assistanUser(String empno) {
		MesAssistant assistant = assistantCache.get(empno);
		if(assistant == null) {
			ChatMemory userChatMemory = MessageWindowChatMemory.withMaxMessages(10);
				//Langchin4j가 만든 규격 (내가만든 파일의 @Been요소)
			assistant = AiServices.builder(MesAssistant.class)
	                .chatLanguageModel(geminiModel)
	                .chatMemory(userChatMemory)
	                .tools(dbTool)
	                .contentRetriever(contentRetriever)
	                .build();
			assistantCache.put(empno, assistant);
		}
		return assistant;
    }
	
	public String getChatResponse(List<aiChatContents> history, String empno, String ename) {
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
		
			if (history == null || history.isEmpty()) {
		        return "보낸 메시지가 없습니다.";
		    }
			
			MesAssistant assistant = assistanUser(empno);
			
			String lastUserMsg = history.get(history.size()-1).getParts().get(0).getText();
			
			String today = LocalDate.now().toString();
			
			String prompt ="오늘의 실제 날짜는 " + today + "입니다."
							+ " 이 날짜를 기준으로 '오늘', '어제', '내일' 등을 계산하세요." + lastUserMsg 
							+"현재 대화 중인 관리자의 이름은'"+ename +"' 사원번호는'"+empno+"'입니다";
			
			return assistant.chat(prompt);
		} catch (org.springframework.web.client.HttpClientErrorException e) {
			System.out.println("구글 에러 응답: " + e.getResponseBodyAsString());
		    return "에러 발생: " + e.getResponseBodyAsString();
		}catch (Exception e) {
			e.printStackTrace();
			return "에러 발생: " + e.getMessage();
		} 
	}
	
}
