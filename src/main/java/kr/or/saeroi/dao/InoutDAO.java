package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// 입출고 DB 작업 이름 정하는 파일
public interface InoutDAO {

	// 입출고 목록 10개씩 조회
	public List<InoutDTO> selectInoutList(int startRow, int endRow);

	// 전체 개수 조회
	public int selectInoutCount();
}