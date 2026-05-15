package kr.or.saeroi.AiChatbot;

import java.util.ArrayList;
import java.util.List;
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
	public String gemini(@RequestBody List<Map<String, Object>> params) {
		List<aiChatContents> history = new ArrayList<aiChatContents>();
		
		for(Map<String, Object> msg : params) {
			String role = (String) msg.get("role");
			String text = (String) msg.get("text");
			history.add(new aiChatContents(role,text));
		}
		return aiChatservice.getChatResponse(history);
	}
}
