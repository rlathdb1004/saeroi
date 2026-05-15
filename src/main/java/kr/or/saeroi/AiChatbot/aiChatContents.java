package kr.or.saeroi.AiChatbot;

import java.util.ArrayList;
import java.util.List;

// 제미나이 api js에서햇던 데이터 contents parts text 구조만들기
public class aiChatContents {
	private String role;
	private List<aiChatPart> parts;
	
	public aiChatContents(String role, String text) {
		this.role = role;
		this.parts = new ArrayList<aiChatPart>();
		this.parts.add(new aiChatPart(text));
	}
	
	
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public List<aiChatPart> getParts() {
		return parts;
	}
	
	@Override
	public String toString() {
		return "aiChatContents [role=" + role + ", parts=" + parts + "]";
	}
}
