package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// Controller와 DAO 사이 연결
public interface InoutService {

	// 입출고 목록 조회
	public List<InoutDTO> getInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate);

	// 전체 개수 조회
	public int getInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate);

	public List<InoutDTO> getItemList();

	public int addInout(InoutDTO dto);

	public InoutDTO getInoutDetail(int inoutId);

	public int removeInout(String[] inoutIds);

	public int modifyInout(InoutDTO dto);
}