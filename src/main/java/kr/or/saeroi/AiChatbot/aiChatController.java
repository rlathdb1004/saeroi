package kr.or.saeroi.AiChatbot;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class aiChatController {

	@Autowired
	aiChatService aiChatservice;
	
	@RequestMapping("/chat")
	public String chat() {
		
		return "chat";
	}

	@RequestMapping(value = "/gemini", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String gemini(@RequestBody Map<String, String> params) {
		String prompt = params.get("prompt");
		System.out.println(prompt);
		return aiChatservice.getChatResponse(prompt);
	}
}
