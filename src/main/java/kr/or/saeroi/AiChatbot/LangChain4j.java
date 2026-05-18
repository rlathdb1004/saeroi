package kr.or.saeroi.AiChatbot;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.googleai.GoogleAiGeminiChatModel;

@Configuration
public class LangChain4j {

	@Value("${gemini.api.key}")
	private String apikey;
	
	// 기존엔 서비스에서 제미나이url을 땃지만 렝체인방식으로 간략화
	@Bean
	public ChatLanguageModel LangChainModel() {
		return GoogleAiGeminiChatModel.builder()
				.apiKey(apikey)
//				.modelName("gemini-3-flash-preview") 주석하고 아래꺼로 변경
				.modelName("gemini-2.5-flash")
				.build();
	}
}
