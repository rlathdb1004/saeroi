package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.LotDAO;
import kr.or.saeroi.dto.LotDTO;

// LOT 이력추적 Service이다.
@Service
public class LotService {

	// LOT 이력추적 DAO를 주입받는다.
	@Autowired
	private LotDAO lotDAO;

	// LOT 이력 목록 총 건수를 조회한다.
	public int selectLotHistoryCount(LotDTO lotDTO) {

		return lotDAO.selectLotHistoryCount(lotDTO);
	}

	// LOT 이력 목록을 조회한다.
	public List<LotDTO> selectLotHistoryList(LotDTO lotDTO) {

		return lotDAO.selectLotHistoryList(lotDTO);
	}

	// LOT 이력 상세 정보를 조회한다.
	public LotDTO selectLotHistoryDetail(Integer orderId) {

		return lotDAO.selectLotHistoryDetail(orderId);
	}
}