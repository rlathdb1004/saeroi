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
				Document document = FileSystemDocumentLoader.loadDocument(Paths.get(resource.getURI()), parser);
				DocumentSplitter splitter = DocumentSplitters.recursive(500,50);
				
				java.util.List<TextSegment> segments = splitter.split(document);
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
