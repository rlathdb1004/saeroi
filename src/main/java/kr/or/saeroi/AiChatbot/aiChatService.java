package kr.or.saeroi.AiChatbot;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class aiChatService {

	@Autowired
	private RestTemplate restTemplate;
	
	@Value("${gemini.api.key}")
	private String apikey;
	
	
	public String getChatResponse(List<aiChatContents> history) {
		System.out.println("현재 사용 중인 키: " + (apikey != null ? apikey.substring(0, 4) + "****" : "null"));
		String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent";
		try {
			aiChatText requestBody = new aiChatText(history);
			
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			
			headers.set("x-goog-api-key", apikey);
			
			HttpEntity<aiChatText> entity = new HttpEntity<aiChatText>(requestBody,headers);
			
			ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
			
			return response.getBody();
		} catch (org.springframework.web.client.HttpClientErrorException e) {
			System.out.println("구글 에러 응답: " + e.getResponseBodyAsString());
		    return "에러 발생: " + e.getResponseBodyAsString();
		}catch (Exception e) {
			e.printStackTrace();
			return "에러 발생: " + e.getMessage();
		} 
	}
	
}
