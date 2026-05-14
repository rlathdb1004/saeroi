package kr.or.saeroi.AiChatbot;

import org.springframework.beans.factory.annotation.Autowired;
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
	
	private final String key = "AIzaSyCVVUxDvv9YVpjiqB9oiygQ02C1m10tMqw";
	private final String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key="+key;
	
	public String getChatResponse(String prompt) {
		try {
			aiChatText requestBody = new aiChatText(prompt);
			
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			
			HttpEntity<aiChatText> entity = new HttpEntity<aiChatText>(requestBody,headers);
			
			ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
			return response.getBody();
		} catch (Exception e) {
			e.printStackTrace();
			return "에러 발생: " + e.getMessage();
		}
	}
	
}
