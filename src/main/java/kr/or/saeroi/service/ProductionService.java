package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.saeroi.dao.ProductionDAO;
import kr.or.saeroi.dto.ProductionDTO;

// 생산관리 Service이다.
// Service는 Controller와 DAO 사이에서 업무 흐름을 정리하는 역할을 한다.
@Service
public class ProductionService {

	// 생산관리 DAO를 주입받는다.
	@Autowired
	private ProductionDAO productionDAO;


	// =========================================================
	// 1. 생산계획 관리
	// =========================================================

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


	// =========================================================
	// 2. 작업지시 관리
	// =========================================================

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

	/**
	 * 작업지시를 등록한다.
	 *
	 * 처리 흐름:
	 * 1. WORK_ORDER 등록
	 * 2. Mapper selectKey로 생성된 orderId 확보
	 * 3. 작업지시 → 생산계획 → 완제품 item_id 기준으로 사용중 BOM 조회
	 * 4. BOM_DETAIL 기준 필요 원자재 목록 조회
	 * 5. MATERIAL_INOUT에 MO-PROD 자재투입 이력 자동 생성
	 *
	 * 주의:
	 * - @Transactional 적용
	 * - BOM이 없거나 BOM 상세가 없으면 작업지시 등록도 같이 롤백한다.
	 *
	 * @param productionDTO 작업지시 등록 DTO
	 * @return 작업지시 등록 처리 건수
	 */
	@Transactional
	public int insertWorkOrder(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			throw new IllegalArgumentException("등록할 작업지시 정보가 없습니다.");
		}

		if (productionDTO.getProdPlanId() == null) {
			throw new IllegalArgumentException("생산계획을 선택하세요.");
		}

		if (productionDTO.getOrderQty() == null || productionDTO.getOrderQty() <= 0) {
			throw new IllegalArgumentException("작업지시 수량을 1 이상 입력하세요.");
		}

		if (productionDTO.getLineId() == null) {
			throw new IllegalArgumentException("생산라인을 선택하세요.");
		}

		if (productionDTO.getEmpId() == null) {
			throw new IllegalArgumentException("담당자를 선택하세요.");
		}

		if (productionDTO.getOrderDate() == null
				|| productionDTO.getOrderDate().trim().isEmpty()) {
			throw new IllegalArgumentException("작업지시일자를 입력하세요.");
		}

		// 작업지시 등록
		int result = productionDAO.insertWorkOrder(productionDTO);

		if (result <= 0) {
			throw new IllegalArgumentException("작업지시 등록에 실패했습니다.");
		}

		// insertWorkOrder Mapper의 selectKey에서 orderId가 세팅되어야 한다.
		if (productionDTO.getOrderId() == null) {
			throw new IllegalArgumentException("작업지시번호 생성에 실패했습니다.");
		}

		// 작업지시에 적용될 BOM 마스터 조회
		ProductionDTO appliedBom =
				productionDAO.selectWorkOrderAppliedBom(productionDTO.getOrderId());

		if (appliedBom == null || appliedBom.getBomId() == null) {
			throw new IllegalArgumentException(
					"해당 완제품에 사용 가능한 BOM이 없습니다. BOM 등록 후 작업지시를 생성하세요."
			);
		}

		// 작업지시 기준 BOM 상세 원자재 목록 조회
		List<ProductionDTO> materialList =
				productionDAO.selectWorkOrderBomMaterialList(productionDTO.getOrderId());

		if (materialList == null || materialList.isEmpty()) {
			throw new IllegalArgumentException(
					"해당 BOM에 등록된 원자재 구성 정보가 없습니다. BOM 상세를 등록하세요."
			);
		}

		// 중복 자동투입 방지
		int materialInoutCount =
				productionDAO.selectWorkOrderMaterialInoutCount(productionDTO.getOrderId());

		if (materialInoutCount > 0) {
			return result;
		}

		// BOM 기준 원자재 투입 이력 자동 생성
		int materialResult =
				productionDAO.insertWorkOrderMaterialInoutByBom(productionDTO);

		if (materialResult <= 0) {
			throw new IllegalArgumentException("BOM 기준 원자재 투입 이력 생성에 실패했습니다.");
		}

		return result;
	}

	// 작업지시 상세 정보를 조회한다.
	public ProductionDTO selectWorkOrderDetail(Integer orderId) {

		return productionDAO.selectWorkOrderDetail(orderId);
	}

	// 작업지시 정보를 수정한다.
	public int updateWorkOrder(ProductionDTO productionDTO) {

		return productionDAO.updateWorkOrder(productionDTO);
	}


	// =========================================================
	// 3. 작업지시 BOM / 원자재 자동투입 조회
	// =========================================================

	// 작업지시에 적용된 BOM 마스터 정보를 조회한다.
	public ProductionDTO selectWorkOrderAppliedBom(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("작업지시 정보가 없습니다.");
		}

		return productionDAO.selectWorkOrderAppliedBom(orderId);
	}

	// 작업지시 기준 BOM 상세 원자재 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderBomMaterialList(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("작업지시 정보가 없습니다.");
		}

		return productionDAO.selectWorkOrderBomMaterialList(orderId);
	}

	// 작업지시 상세 화면에서 보여줄 원자재 투입 이력 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderMaterialInoutList(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("작업지시 정보가 없습니다.");
		}

		return productionDAO.selectWorkOrderMaterialInoutList(orderId);
	}


	// =========================================================
	// 4. 생산실적 등록
	// =========================================================

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


	// =========================================================
	// 5. 공정진행 현황
	// =========================================================

	// 공정진행 현황 목록 총 건수를 조회한다.
	public int selectProcessProgressCount(ProductionDTO productionDTO) {

		return productionDAO.selectProcessProgressCount(productionDTO);
	}

	// 공정진행 현황 목록을 조회한다.
	public List<ProductionDTO> selectProcessProgressList(ProductionDTO productionDTO) {

		return productionDAO.selectProcessProgressList(productionDTO);
	}

	// 공정진행 현황 검색 select box에 사용할 진행상태 목록을 조회한다.
	public List<String> selectProcessProgressStatusList() {

		return productionDAO.selectProcessProgressStatusList();
	}

	// 공정진행 상세 정보를 조회한다.
	public ProductionDTO selectProcessProgressDetail(Integer orderId) {

		return productionDAO.selectProcessProgressDetail(orderId);
	}
}