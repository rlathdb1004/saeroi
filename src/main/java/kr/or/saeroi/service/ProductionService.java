package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.ProductionDAO;
import kr.or.saeroi.dto.ProductionDTO;

// 생산관리 Service이다.
// Service는 Controller와 DAO 사이에서 업무 흐름을 정리하는 역할을 한다.
@Service
public class ProductionService {

	// 생산관리 DAO를 주입받는다.
	@Autowired
	private ProductionDAO productionDAO;

	// 생산계획 목록 총 건수를 조회한다.
	public int selectProductionPlanCount(ProductionDTO productionDTO) {

		return productionDAO.selectProductionPlanCount(productionDTO);
	}

	// 생산계획 목록을 조회한다.
	public List<ProductionDTO> selectProductionPlanList(ProductionDTO productionDTO) {

		return productionDAO.selectProductionPlanList(productionDTO);
	}

	// 검색 select box에 사용할 품목 구분 목록을 조회한다.
	public List<String> selectItemTypeList() {

		return productionDAO.selectItemTypeList();
	}
	
	// 생산계획 상세 정보를 조회한다.
	public ProductionDTO selectProductionPlanDetail(Integer prodPlanId) {

		return productionDAO.selectProductionPlanDetail(prodPlanId);
	}

	// 생산계획 정보를 수정한다.
	public int updateProductionPlan(ProductionDTO productionDTO) {

		return productionDAO.updateProductionPlan(productionDTO);
	}
}