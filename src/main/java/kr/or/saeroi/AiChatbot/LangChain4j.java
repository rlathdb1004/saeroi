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
	
	@Bean
	public ChatLanguageModel LangChainModel() {
		return GoogleAiGeminiChatModel.builder()
				.apiKey(apikey)
				.modelName("gemini-3-flash-preview")
				.build();
	}
}
