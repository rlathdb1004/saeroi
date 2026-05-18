package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dao.InoutDAO;
import kr.or.saeroi.dao.InoutDAOImpl;
import kr.or.saeroi.dto.InoutDTO;

// Service 실제 내용
public class InoutServiceImpl implements InoutService {

	private InoutDAO dao = new InoutDAOImpl();

	// 입출고 목록 조회
	public List<InoutDTO> getInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		return dao.selectInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);
	}

	// 전체 개수 조회
	public int getInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate) {

		return dao.selectInoutCount(
				searchType,
				inoutType,
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

	public int removeInout(String[] inoutIds) {
		return dao.deleteInout(inoutIds);
	}

	public int modifyInout(InoutDTO dto) {
		return dao.updateInout(dto);
	}
}