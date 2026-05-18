package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// Controller와 DAO 사이 연결
public interface InoutService {

	// 입출고 목록 조회
	public List<InoutDTO> getInoutList(
			int startRow,
			int endRow,
			String searchType,
			String keyword,
			String startDate,
			String endDate);

	// 전체 개수 조회
	public int getInoutCount(
			String searchType,
			String keyword,
			String startDate,
			String endDate);

	// 품목 목록 조회
	public List<InoutDTO> getItemList();

	// 입출고 등록
	public int addInout(InoutDTO dto);

	// 입출고 상세조회
	public InoutDTO getInoutDetail(int inoutId);

	// 선택 삭제
	public int removeInout(String[] inoutIds);
}