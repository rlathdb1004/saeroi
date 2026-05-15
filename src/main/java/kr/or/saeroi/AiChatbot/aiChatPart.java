package kr.or.saeroi.AiChatbot;
//제미나이 api js에서햇던 데이터 contents parts text 구조만들기
public class aiChatPart {

	String text;
	
	public aiChatPart(String text) {
		this.text = text;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text=text;
	}
	@Override
	public String toString() {
		return "aiChatPart [text=" + text + "]";
	}
	
}
