package kr.or.saeroi.AiChatbot;

import java.util.ArrayList;
import java.util.List;


//제미나이 api js에서햇던 데이터 contents parts text 구조만들기
public class aiChatText {
	private List<aiChatContents> contents;
	
	public aiChatText(List<aiChatContents> history) {
		this.contents = history;
	}
	public List<aiChatContents> getContents(){
		return contents;
	}
}
