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

	// LOT 이력 상세 기본 정보를 조회한다.
	public LotDTO selectLotHistoryDetail(Integer orderId) {

		return lotDAO.selectLotHistoryDetail(orderId);
	}

	// LOT 기준 자재 투입 이력을 조회한다.
	public List<LotDTO> selectLotMaterialHistoryList(Integer orderId) {

		return lotDAO.selectLotMaterialHistoryList(orderId);
	}

	// LOT 기준 생산실적 이력을 조회한다.
	public List<LotDTO> selectLotProductionHistoryList(Integer orderId) {

		return lotDAO.selectLotProductionHistoryList(orderId);
	}

	// LOT 기준 품질검사 이력을 조회한다.
	public List<LotDTO> selectLotInspectionHistoryList(Integer orderId) {

		return lotDAO.selectLotInspectionHistoryList(orderId);
	}

	// LOT 기준 불량 이력을 조회한다.
	public List<LotDTO> selectLotDefectHistoryList(Integer orderId) {

		return lotDAO.selectLotDefectHistoryList(orderId);
	}

	// LOT 기준 완제품 입출고 이력을 조회한다.
	public List<LotDTO> selectLotProductInoutHistoryList(Integer orderId) {

		return lotDAO.selectLotProductInoutHistoryList(orderId);
	}
}