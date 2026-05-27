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

	// 작업지시 검색 select box에 사용할 작업상태 목록을 조회한다.
	public List<String> selectWorkOrderStatusList() {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderStatusList");
	}

	// 작업지시 등록 모달에서 사용할 생산계획 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPlanList() {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderPlanList");
	}

	// 작업지시 등록 모달에서 사용할 라인 목록을 조회한다.
	public List<ProductionDTO> selectLineList() {

		return sqlSession.selectList(
				NAMESPACE + "selectLineList");
	}

	// 작업지시 등록 모달에서 사용할 담당자 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderEmpList() {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderEmpList");
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

	// 작업지시 정보를 수정한다.
	public int updateWorkOrder(ProductionDTO productionDTO) {

		return sqlSession.update(
				NAMESPACE + "updateWorkOrder",
				productionDTO);
	}


	// =========================================================
	// 3. 작업지시 BOM / 원자재 자동투입
	// =========================================================

	// 작업지시에 적용될 BOM 마스터 정보를 조회한다.
	// 작업지시 → 생산계획 → 완제품 item_id → 사용중 BOM 순서로 조회한다.
	public ProductionDTO selectWorkOrderAppliedBom(Integer orderId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectWorkOrderAppliedBom",
				orderId);
	}

	// 작업지시 기준 BOM 상세 원자재 목록을 조회한다.
	// 작업지시 수량 * BOM 소요량으로 필요수량을 계산해 조회한다.
	public List<ProductionDTO> selectWorkOrderBomMaterialList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderBomMaterialList",
				orderId);
	}

	// 작업지시에 이미 자동 생성된 자재투입 이력이 있는지 확인한다.
	// 중복 자동투입 방지용이다.
	public int selectWorkOrderMaterialInoutCount(Integer orderId) {

		return sqlSession.selectOne(
				NAMESPACE + "selectWorkOrderMaterialInoutCount",
				orderId);
	}

	// 작업지시 등록 후 BOM 기준으로 MATERIAL_INOUT에 원자재 출고/투입 이력을 자동 생성한다.
	// inout_type은 MO-PROD로 저장한다.
	public int insertWorkOrderMaterialInoutByBom(ProductionDTO productionDTO) {

		return sqlSession.insert(
				NAMESPACE + "insertWorkOrderMaterialInoutByBom",
				productionDTO);
	}

	// 작업지시 상세 화면에서 보여줄 원자재 투입 이력 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderMaterialInoutList(Integer orderId) {

		return sqlSession.selectList(
				NAMESPACE + "selectWorkOrderMaterialInoutList",
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
	public List<ProductionDTO> selectProductionResultOrderList() {

		return sqlSession.selectList(
				NAMESPACE + "selectProductionResultOrderList");
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