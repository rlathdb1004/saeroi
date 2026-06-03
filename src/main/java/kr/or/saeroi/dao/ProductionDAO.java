package kr.or.saeroi.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ProductionDTO;

// 생산관리 DAO이다.
// DAO는 Controller나 Service에서 직접 SQL을 작성하지 않도록 MyBatis Mapper를 호출하는 역할만 한다.
@Repository
public class ProductionDAO {

	// MyBatis 실행 객체이다.
	@Autowired
	private SqlSessionTemplate sqlSession;

	// ProductionMapper.xml의 namespace와 반드시 동일해야 한다.
	private static final String NAMESPACE =
			"kr.or.saeroi.mapper.ProductionMapper.";


	// =========================================================
	// 1. 생산계획 관리
	// =========================================================

	// 생산계획 목록 총 건수를 조회한다.
	public int selectProductionPlanCount(ProductionDTO productionDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionPlanCount",
				productionDTO);
	}

	// 생산계획 목록을 조회한다.
	public List<ProductionDTO> selectProductionPlanList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectProductionPlanList",
				productionDTO);
	}

	// 검색 select box에 사용할 품목 구분 목록을 조회한다.
	public List<String> selectItemTypeList() {

		return sqlSession.selectList(
				NAMESPACE + "selectItemTypeList");
	}

	// 생산계획 상세 정보를 조회한다.
	public ProductionDTO selectProductionPlanDetail(Integer prodPlanId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionPlanDetail",
				prodPlanId);
	}

	// 생산계획 정보를 수정한다.
	public int updateProductionPlan(ProductionDTO productionDTO) {

		return sqlSession.update(
				NAMESPACE + "updateProductionPlan",
				productionDTO);
	}

	// 생산계획 등록 모달에서 사용할 품목 목록을 조회한다.
	public List<ProductionDTO> selectItemList() {

		return sqlSession.selectList(
				NAMESPACE + "selectItemList");
	}

	// 생산계획을 등록한다.
	public int insertProductionPlan(ProductionDTO productionDTO) {

		return sqlSession.insert(
				NAMESPACE + "insertProductionPlan",
				productionDTO);
	}

	// 생산계획 삭제 전 연결된 작업지시 건수를 확인한다.
	public int selectWorkOrderCountByProdPlanId(Integer prodPlanId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectWorkOrderCountByProdPlanId",
				prodPlanId);
	}

	// 작업지시가 연결되지 않은 생산계획을 삭제한다.
	public int deleteProductionPlan(Integer prodPlanId) {

		return sqlSession.delete(
				NAMESPACE + "deleteProductionPlan",
				prodPlanId);
	}


	// =========================================================
	// 2. 작업지시 관리
	// =========================================================

	// 작업지시 목록 총 건수를 조회한다.
	public int selectWorkOrderCount(ProductionDTO productionDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectWorkOrderCount",
				productionDTO);
	}

	// 작업지시 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderList",
				productionDTO);
	}

	// 작업지시 검색조건에 맞는 전체 인쇄용 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPrintList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderPrintList",
				productionDTO);
	}

	// 작업지시서 인쇄용 BOM / 자재 LOT 확인 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPrintMaterialList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderPrintMaterialList",
				orderId);
	}

	// 작업지시서 인쇄용 라인 / 설비 확인 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPrintEquipmentList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderPrintEquipmentList",
				orderId);
	}

	// 작업지시 검색 select box에 사용할 작업상태 목록을 조회한다.
	public List<String> selectWorkOrderStatusList() {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderStatusList");
	}

	// 작업지시 등록 모달에서 사용할 생산계획 목록을 조회한다.
	// 기존 Service/Controller 호환용 기본 메서드이다.
	public List<ProductionDTO> selectWorkOrderPlanList() {

		ProductionDTO productionDTO = new ProductionDTO();

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderPlanList",
				productionDTO);
	}

	// 작업지시 등록 모달에서 사용할 생산계획 목록을 조회한다.
	// includePastPlan 값에 따라 지난 생산계획 포함 여부를 제어한다.
	public List<ProductionDTO> selectWorkOrderPlanList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderPlanList",
				productionDTO);
	}

	// 작업지시 등록 모달에서 사용할 라인 목록을 조회한다.
	public List<ProductionDTO> selectLineList() {

		return sqlSession.selectList(
				NAMESPACE + "selectLineList");
	}

	// 작업지시 등록/수정에서 사용할 생산관리 담당자 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderEmpList() {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderEmpList");
	}

	// 생산실적 등록/수정에서 사용할 작업자 담당자 목록을 조회한다.
	public List<ProductionDTO> selectProductionResultEmpList() {

		return sqlSession.selectList(
				NAMESPACE + "selectProductionResultEmpList");
	}

	// 기존 호출 호환용 전체 재직자 목록이다.
	// 특정 화면에서는 selectWorkOrderEmpList 또는 selectProductionResultEmpList 사용을 우선한다.
	public List<ProductionDTO> selectEmpList() {

		return sqlSession.selectList(
				NAMESPACE + "selectEmpList");
	}

	// 작업지시를 등록한다.
	// Mapper의 selectKey에서 orderId가 DTO에 세팅되어야 한다.
	public int insertWorkOrder(ProductionDTO productionDTO) {

		return sqlSession.insert(
				NAMESPACE + "insertWorkOrder",
				productionDTO);
	}

	// 작업지시 상세 정보를 조회한다.
	public ProductionDTO selectWorkOrderDetail(Integer orderId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectWorkOrderDetail",
				orderId);
	}

	// 작업지시 등록 후 생성된 QR 정보를 저장한다.
	public int updateWorkOrderQr(ProductionDTO productionDTO) {

		return sqlSession.update(
				NAMESPACE + "updateWorkOrderQr",
				productionDTO);
	}

	// 작업지시 정보를 수정한다.
	public int updateWorkOrder(ProductionDTO productionDTO) {

		return sqlSession.update(
				NAMESPACE + "updateWorkOrder",
				productionDTO);
	}


	// =========================================================
	// 3. 작업지시 BOM / 원자재 자동투입
	// =========================================================

	// 작업지시 상세에서 BOM 기준 자재 소요량과 투입 이력을 함께 조회한다.
	public List<ProductionDTO> selectWorkOrderMaterialList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderMaterialList",
				orderId);
	}

	// 작업지시에 적용될 BOM 마스터 정보를 조회한다.
	// 기존 Service 호환용이다. 자재 목록 첫 번째 행의 BOM 정보를 사용한다.
	public ProductionDTO selectWorkOrderAppliedBom(Integer orderId) {

		List<ProductionDTO> materialList = sqlSession.selectList(
				NAMESPACE + "selectWorkOrderMaterialList",
				orderId);

		if (materialList == null || materialList.isEmpty()) {
			return null;
		}

		return materialList.get(0);
	}

	// 작업지시 기준 BOM 상세 원자재 목록을 조회한다.
	// 기존 Service 호환용이다.
	public List<ProductionDTO> selectWorkOrderBomMaterialList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderMaterialList",
				orderId);
	}

	// 작업지시에 이미 자동 생성된 자재투입 이력이 있는지 확인한다.
	// 기존 Service 호환용이다.
	public int selectWorkOrderMaterialInoutCount(Integer orderId) {

		List<ProductionDTO> materialList = sqlSession.selectList(
				NAMESPACE + "selectWorkOrderMaterialList",
				orderId);

		if (materialList == null || materialList.isEmpty()) {
			return 0;
		}

		int count = 0;

		for (ProductionDTO material : materialList) {

			if (material != null && material.getInoutId() != null) {
				count++;
			}
		}

		return count;
	}

	// 작업지시 등록 시 BOM 기준으로 자동 투입할 자재 목록을 조회한다.
	public List<ProductionDTO> selectBomMaterialForWorkOrder(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectBomMaterialForWorkOrder",
				productionDTO);
	}

	// 작업지시 등록 시 BOM 기준 자재 투입 이력을 1건 생성한다.
	public int insertMaterialOutByWorkOrder(ProductionDTO productionDTO) {

		return sqlSession.insert(
				NAMESPACE + "insertMaterialOutByWorkOrder",
				productionDTO);
	}

	// 작업지시 등록 후 BOM 기준으로 MATERIAL_INOUT에 원자재 출고/투입 이력을 자동 생성한다.
	// 기존 Service 호환용이다.
	public int insertWorkOrderMaterialInoutByBom(ProductionDTO productionDTO) {

		List<ProductionDTO> materialList = sqlSession.selectList(
				NAMESPACE + "selectBomMaterialForWorkOrder",
				productionDTO);

		if (materialList == null || materialList.isEmpty()) {
			return 0;
		}

		int result = 0;

		for (ProductionDTO material : materialList) {

			if (material == null) {
				continue;
			}

			ProductionDTO insertDTO = new ProductionDTO();

			insertDTO.setOrderId(productionDTO.getOrderId());
			insertDTO.setEmpId(productionDTO.getEmpId());
			insertDTO.setOrderDate(productionDTO.getOrderDate());

			insertDTO.setMaterialItemId(material.getMaterialItemId());
			insertDTO.setRequiredQty(material.getRequiredQty());

			result += sqlSession.insert(
					NAMESPACE + "insertMaterialOutByWorkOrder",
					insertDTO);
		}

		return result;
	}

	// 작업지시 상세 화면에서 보여줄 원자재 투입 이력 목록을 조회한다.
	// 기존 Service 호환용이다.
	public List<ProductionDTO> selectWorkOrderMaterialInoutList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderMaterialList",
				orderId);
	}


	// =========================================================
	// 4. 생산실적 등록
	// =========================================================

	// 생산실적 목록 총 건수를 조회한다.
	public int selectProductionResultCount(ProductionDTO productionDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionResultCount",
				productionDTO);
	}

	// 생산실적 목록을 조회한다.
	public List<ProductionDTO> selectProductionResultList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectProductionResultList",
				productionDTO);
	}

	// 생산실적 검색 select box에 사용할 생산상태 목록을 조회한다.
	public List<String> selectProductionResultStatusList() {

		return sqlSession.selectList(
				NAMESPACE + "selectProductionResultStatusList");
	}

	// 생산실적 등록 모달에서 사용할 작업지시 목록을 조회한다.
	// 기존 Service/Controller 호환용 기본 메서드이다.
	// 기본값은 소량 잔량 미포함이며 Mapper 기준 잔량 20EA 이상만 조회한다.
	public List<ProductionDTO> selectProductionResultOrderList() {

		ProductionDTO productionDTO = new ProductionDTO();
		productionDTO.setIncludeSmallRemain("N");

		return selectProductionResultOrderList(productionDTO);
	}

	// 생산실적 등록 모달에서 사용할 작업지시 목록을 조회한다.
	// includeSmallRemain 값에 따라 소량 잔량 포함 여부를 제어한다.
	public List<ProductionDTO> selectProductionResultOrderList(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			productionDTO = new ProductionDTO();
		}

		if (productionDTO.getIncludeSmallRemain() == null
				|| productionDTO.getIncludeSmallRemain().trim().length() == 0) {
			productionDTO.setIncludeSmallRemain("N");
		}

		return sqlSession.selectList(
				NAMESPACE + "selectProductionResultOrderList",
				productionDTO);
	}

	// QR 스캔 진입 시 자동입력할 작업지시 정보를 조회한다.
	public ProductionDTO selectProductionResultOrderByQr(ProductionDTO productionDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionResultOrderByQr",
				productionDTO);
	}

	// 생산실적을 등록한다.
	public int insertProductionResult(ProductionDTO productionDTO) {

		return sqlSession.insert(
				NAMESPACE + "insertProductionResult",
				productionDTO);
	}

	// 생산실적 상세 정보를 조회한다.
	public ProductionDTO selectProductionResultDetail(Integer prodId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProductionResultDetail",
				prodId);
	}

	// 생산실적 정보를 수정한다.
	public int updateProductionResult(ProductionDTO productionDTO) {

		return sqlSession.update(
				NAMESPACE + "updateProductionResult",
				productionDTO);
	}


	// =========================================================
	// 5. 공정진행 현황
	// =========================================================

	// 공정진행 현황 목록 총 건수를 조회한다.
	public int selectProcessProgressCount(ProductionDTO productionDTO) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProcessProgressCount",
				productionDTO);
	}

	// 공정진행 현황 목록을 조회한다.
	public List<ProductionDTO> selectProcessProgressList(ProductionDTO productionDTO) {

		return sqlSession.selectList(
				NAMESPACE + "selectProcessProgressList",
				productionDTO);
	}

	// 공정진행 현황 검색 select box에 사용할 진행상태 목록을 조회한다.
	public List<String> selectProcessProgressStatusList() {

		return sqlSession.selectList(
				NAMESPACE + "selectProcessProgressStatusList");
	}

	// 공정진행 상세 정보를 조회한다.
	public ProductionDTO selectProcessProgressDetail(Integer orderId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectProcessProgressDetail",
				orderId);
	}
}