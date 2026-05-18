package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// 입출고 DB 작업 이름 정하는 파일
public interface InoutDAO {

	// 입출고 목록 조회
	public List<InoutDTO> selectInoutList(
			int startRow,
			int endRow,
			String searchType,
			String keyword,
			String startDate,
			String endDate);

	// 전체 개수 조회
	public int selectInoutCount(
			String searchType,
			String keyword,
			String startDate,
			String endDate);

	// 품목 목록 조회
	public List<InoutDTO> selectItemList();

	// 입출고 등록
	public int insertInout(InoutDTO dto);

	// 입출고 상세조회
	public InoutDTO selectInoutDetail(int inoutId);

	// 선택 삭제
	public int deleteInout(String[] inoutIds);

	// 입출고 수정
	public int updateInout(InoutDTO dto);
}