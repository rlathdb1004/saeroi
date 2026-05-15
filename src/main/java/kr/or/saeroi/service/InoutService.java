package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// Controller와 DAO 사이 연결
public interface InoutService {

	public List<InoutDTO> getInoutList(int startRow, int endRow);

	public int getInoutCount();
}