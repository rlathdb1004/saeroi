package kr.or.saeroi.AiChatbot;

import java.util.ArrayList;
import java.util.List;

// 제미나이 api js에서햇던 데이터 contents parts text 구조만들기
public class aiChatContents {
	private List<aiChatPart> parts;
	
	public aiChatContents(String text) {
		this.parts = new ArrayList<aiChatPart>();
		this.parts.add(new aiChatPart(text));
	}
	public List<aiChatPart> getParts() {
		return parts;
	}
}
