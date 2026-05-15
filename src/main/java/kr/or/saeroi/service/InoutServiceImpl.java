package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dao.InoutDAO;
import kr.or.saeroi.dao.InoutDAOImpl;
import kr.or.saeroi.dto.InoutDTO;

// Service 실제 내용
public class InoutServiceImpl implements InoutService {

	private InoutDAO dao = new InoutDAOImpl();

	public List<InoutDTO> getInoutList(int startRow, int endRow) {
		return dao.selectInoutList(startRow, endRow);
	}

	public int getInoutCount() {
		return dao.selectInoutCount();
	}
}