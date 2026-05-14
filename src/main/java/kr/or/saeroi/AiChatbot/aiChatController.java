package kr.or.saeroi.AiChatbot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class aiChatController {

	@Autowired
	aiChatService aiChatservice;
	
	@RequestMapping("/chat")
	public String chat() {
		
		return "chat";
	}
}
