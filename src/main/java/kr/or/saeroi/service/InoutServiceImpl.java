package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dao.InoutDAO;
import kr.or.saeroi.dao.InoutDAOImpl;
import kr.or.saeroi.dto.InoutDTO;

// Service 실제 내용
public class InoutServiceImpl implements InoutService {

	private InoutDAO dao = new InoutDAOImpl();

	public List<InoutDTO> getInoutList(
			int startRow,
			int endRow,
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		return dao.selectInoutList(
				startRow,
				endRow,
				searchType,
				keyword,
				startDate,
				endDate);
	}

	public int getInoutCount(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		return dao.selectInoutCount(
				searchType,
				keyword,
				startDate,
				endDate);
	}

	public List<InoutDTO> getItemList() {
		return dao.selectItemList();
	}

	public int addInout(InoutDTO dto) {
		return dao.insertInout(dto);
	}

	public InoutDTO getInoutDetail(int inoutId) {
		return dao.selectInoutDetail(inoutId);
	}
}