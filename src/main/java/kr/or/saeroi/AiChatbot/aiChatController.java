package kr.or.saeroi.AiChatbot;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.saeroi.dto.LoginDTO;

@Controller
public class aiChatController {

	@Autowired
	aiChatService aiChatservice;
	
	@RequestMapping("/chat")
	public String chat() {
		
		return "chat.tiles";
	}

	@RequestMapping(value = "/gemini", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String gemini(@RequestBody List<Map<String, Object>> params, HttpSession session) {
		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
		//오류방지
		String empno = "GUEST"; 
		String ename = "게스트";
		if(loginUser != null) {
			empno = loginUser.getEmpno();
			ename = loginUser.getEname();
		}
		
		System.out.println("loginUser"+loginUser);
		List<aiChatContents> history = new ArrayList<aiChatContents>();
		
		for(Map<String, Object> msg : params) {
			String role = (String) msg.get("role");
			String text = (String) msg.get("text");
			
			history.add(new aiChatContents(role,text));
		}
		return aiChatservice.getChatResponse(history, empno, ename);
	}
}
