package kr.or.saeroi.AiChatbot;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

// 제미나이 api js에서햇던 데이터 contents parts text 구조만들기
@Data
public class aiChatContents {
	private String role;
	private List<aiChatPart> parts;
	
	public aiChatContents(String role, String text) {
		this.role = role;
		this.parts = new ArrayList<aiChatPart>();
		this.parts.add(new aiChatPart(text));
	}
	
	
}
