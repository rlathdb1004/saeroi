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

	// 생산계획 등록 모달에서 사용할 품목 목록을 조회한다.
	public List<ProductionDTO> selectItemList() {

		return productionDAO.selectItemList();
	}

	// 생산계획을 등록한다.
	public int insertProductionPlan(ProductionDTO productionDTO) {

		return productionDAO.insertProductionPlan(productionDTO);
	}

	// 작업지시 목록 총 건수를 조회한다.
	public int selectWorkOrderCount(ProductionDTO productionDTO) {

		return productionDAO.selectWorkOrderCount(productionDTO);
	}

	// 작업지시 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderList(ProductionDTO productionDTO) {

		return productionDAO.selectWorkOrderList(productionDTO);
	}

	// 작업지시 검색 select box에 사용할 작업상태 목록을 조회한다.
	public List<String> selectWorkOrderStatusList() {

		return productionDAO.selectWorkOrderStatusList();
	}

	// 작업지시 등록 모달에서 사용할 생산계획 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPlanList() {

		return productionDAO.selectWorkOrderPlanList();
	}

	// 작업지시 등록 모달에서 사용할 라인 목록을 조회한다.
	public List<ProductionDTO> selectLineList() {

		return productionDAO.selectLineList();
	}

	// 작업지시 등록 모달에서 사용할 담당자 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderEmpList() {

		return productionDAO.selectWorkOrderEmpList();
	}

	// 작업지시를 등록한다.
	public int insertWorkOrder(ProductionDTO productionDTO) {

		return productionDAO.insertWorkOrder(productionDTO);
	}

	// 작업지시 상세 정보를 조회한다.
	public ProductionDTO selectWorkOrderDetail(Integer orderId) {

		return productionDAO.selectWorkOrderDetail(orderId);
	}

	// 작업지시 정보를 수정한다.
	public int updateWorkOrder(ProductionDTO productionDTO) {

		return productionDAO.updateWorkOrder(productionDTO);
	}

	// 생산실적 목록 총 건수를 조회한다.
	public int selectProductionResultCount(ProductionDTO productionDTO) {

		return productionDAO.selectProductionResultCount(productionDTO);
	}

	// 생산실적 목록을 조회한다.
	public List<ProductionDTO> selectProductionResultList(ProductionDTO productionDTO) {

		return productionDAO.selectProductionResultList(productionDTO);
	}

	// 생산실적 검색 select box에 사용할 생산상태 목록을 조회한다.
	public List<String> selectProductionResultStatusList() {

		return productionDAO.selectProductionResultStatusList();
	}

	// 생산실적 등록 모달에서 사용할 작업지시 목록을 조회한다.
	public List<ProductionDTO> selectProductionResultOrderList() {

		return productionDAO.selectProductionResultOrderList();
	}

	// 생산실적을 등록한다.
	public int insertProductionResult(ProductionDTO productionDTO) {

		return productionDAO.insertProductionResult(productionDTO);
	}

	// 생산실적 상세 정보를 조회한다.
	public ProductionDTO selectProductionResultDetail(Integer prodId) {

		return productionDAO.selectProductionResultDetail(prodId);
	}

	// 생산실적 정보를 수정한다.
	public int updateProductionResult(ProductionDTO productionDTO) {

		return productionDAO.updateProductionResult(productionDTO);
	}
}