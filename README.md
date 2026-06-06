SAEROI (EV용 배터리 절연 가스켓 제조 MES & AI 비서)

LangChain4j와 Gemini API를 활용하여 제조 실행 시스템(MES) 데이터의 실시간 조회 및 분석을 지원하는 AI 융합 스마트 팩토리 플랫폼입니다.

기술 스택 (Tech Stack)
- Backend: Java, Spring Framework, Spring MVC
- Database: Oracle, DBeaver
- Frontend: JavaScript, JSP, HTML5, CSS
- AI & Libraries: LangChain4j, Gemini API, Kakao Map API, ApexCharts

팀원 및 역할 분담 (Contributors)
- PARKMINHO-KK (김민권)
  - 백엔드 아키텍처 설계 및 프론트엔드-데이터베이스 간 End-to-End 데이터 흐름 구현
  - LangChain4j 및 Gemini API 기반 AI 챗봇('새로이봇') 고도화
  - MessageWindowChatMemory 적용을 통한 멀티턴 대화 토큰 절약 및 응답속도 개선
  - 메뉴 라우팅 가이드북 구축 및 RAG 패턴 적용을 통한 동적 URL 추천 UI 구현
  - ApexCharts 기반 다중 축(Multi-Axis) 공정 계획 대비 불량 통계 시각화

핵심 기능 및 트러블슈팅 (Key Features & Troubleshooting)
1. AI 기반 실시간 공정 데이터 조회
- 사용자의 자연어 질문을 분석하여 Function Calling 방식으로 DAO를 실행하고 DB 정보를 실시간 집계 및 응답합니다.

2. 멀티턴 대화 최적화 (토큰 및 비용 절감)
- 문제: 대화 누적으로 인한 컨텍스트 비대화로 토큰 소모량 급증 및 응답 속도 저하 발생
- 해결: Langchain4j의 MessageWindowChatMemory를 도입하여 최신 10개의 대화만 컨텍스트로 유지함으로써 응답속도 개선 및 API 비용 최소화

3. RAG 기반 Dynamic UX 라우팅
- 문제: 하드코딩된 URL 분기 처리로 인해 의도 파악 오류 및 UX 라우팅 실패 현상 발생
- 해결: 메뉴 구조 가이드를 텍스트화하고 RAG 패턴 기반 임베딩 검색을 적용하여 질문 문맥에 맞는 링크를 동적 추천하도록 개선
