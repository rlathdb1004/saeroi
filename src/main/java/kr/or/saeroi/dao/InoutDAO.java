package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// 입출고 DB 작업 이름 정하는 파일
public interface InoutDAO {

	// ===============================
	// 팀장님 기존 Tool 코드용
	// ===============================
	public List<InoutDTO> selectInoutList(
			String searchType,
			String keyword,
			String startDate,
			String endDate);

	// ===============================
	// 네 입출고구분 검색 추가용
	// ===============================
	public List<InoutDTO> selectInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate);

	// 전체 개수 조회
	public int selectInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate);

	public List<InoutDTO> selectItemList();

	public int insertInout(InoutDTO dto);

	public InoutDTO selectInoutDetail(int inoutId);

	public int deleteInout(String[] inoutIds);

	public int updateInout(InoutDTO dto);
}