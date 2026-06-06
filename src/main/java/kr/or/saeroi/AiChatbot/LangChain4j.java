package kr.or.saeroi.AiChatbot;

import java.io.IOException;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentParser;
import dev.langchain4j.data.document.DocumentSplitter;
import dev.langchain4j.data.document.loader.FileSystemDocumentLoader;
import dev.langchain4j.data.document.parser.apache.tika.ApacheTikaDocumentParser;
import dev.langchain4j.data.document.splitter.DocumentSplitters;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.googleai.GoogleAiEmbeddingModel;
import dev.langchain4j.model.googleai.GoogleAiGeminiChatModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import dev.langchain4j.rag.content.retriever.ContentRetriever;

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
				.maxRetries(3) //503등 에러가 나면 최대 3회 재시도
				.build();
	}
	
	@Bean
	public EmbeddingModel embeddingModel() {
		return GoogleAiEmbeddingModel.builder()
				.apiKey(apikey)
				.modelName("gemini-embedding-001")
				.build();
	}
	
	@Bean
	public EmbeddingStore<TextSegment> embeddingStore(){
		return new InMemoryEmbeddingStore<TextSegment>();
	}
	@Bean
	public ContentRetriever contenRetriever(EmbeddingModel embeddingModel,  
			EmbeddingStore<TextSegment> embeddingStore) {
		
		try {
			PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
				
			Resource[] resources = resolver.getResources("classpath:/RAG/*.txt");
			
			DocumentParser parser = new ApacheTikaDocumentParser();
			for (Resource resource : resources) {
				// 위 경로의 .txt파일을 Document로 변환
				Document document = FileSystemDocumentLoader.loadDocument(Paths.get(resource.getURI()), parser);
				// 스플릿으로 쪼갤준비
				DocumentSplitter splitter = DocumentSplitters.recursive(500,50);
				
				//스플릿으로 쪼개기
				java.util.List<TextSegment> segments = splitter.split(document);
				//쪼갠문자를 임배딩해서 스토어에 담기
				java.util.List<dev.langchain4j.data.embedding.Embedding> embeddings = embeddingModel.embedAll(segments).content();
				embeddingStore.addAll(embeddings, segments);
				
				System.out.println("RAG 로딩 완료: " + resource.getFilename() + " (" + segments.size() + " 조각 분할 저장됨)");
			}
			
		} catch(IOException e) {
			System.err.println("RAG 매뉴얼 문서 로딩 중 오류 발생: " + e.getMessage());
		}
		return EmbeddingStoreContentRetriever.builder()
				.embeddingStore(embeddingStore)
				.embeddingModel(embeddingModel)
				.maxResults(3)
				.minScore(0.6)
				.build();
	}
	
	
	
}
