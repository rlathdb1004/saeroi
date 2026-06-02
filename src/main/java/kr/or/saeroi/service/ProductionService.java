package kr.or.saeroi.service;

import java.io.ByteArrayOutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import kr.or.saeroi.dao.ProductionDAO;
import kr.or.saeroi.dto.ProductionDTO;

// 생산관리 Service이다.
// Service는 Controller와 DAO 사이에서 업무 흐름을 정리하는 역할을 한다.
@Service
public class ProductionService {

	// 생산관리 DAO를 주입받는다.
	@Autowired
	private ProductionDAO productionDAO;

	// QR 이동 URL 생성 시 contextPath를 확인하기 위해 ServletContext를 사용한다.
	@Autowired
	private ServletContext servletContext;

	// 작업지시서 A4 1장 출력 기준이다.
	private static final int PRINT_MATERIAL_LIMIT = 5;
	private static final int PRINT_EQUIPMENT_LIMIT = 4;

	// 모바일 QR 스캔 접속용 서버 주소이다.
	// 시연 PC의 내부 IP가 바뀌면 이 값만 수정하면 된다.
	private static final String QR_BASE_URL = "http://192.168.0.118:8080";


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

	// 생산계획을 선택 삭제한다.
	// 작업지시가 생성된 생산계획은 LOT/자재투입/생산실적 이력과 연결될 수 있으므로 삭제하지 않는다.
	@Transactional
	public int deleteProductionPlanList(List<Integer> prodPlanIds) {

		if (prodPlanIds == null || prodPlanIds.isEmpty()) {
			throw new IllegalArgumentException("삭제할 생산계획을 선택해주세요.");
		}

		for (Integer prodPlanId : prodPlanIds) {

			if (prodPlanId == null || prodPlanId <= 0) {
				throw new IllegalArgumentException("삭제할 생산계획 정보가 올바르지 않습니다.");
			}

			int workOrderCount =
					productionDAO.selectWorkOrderCountByProdPlanId(prodPlanId);

			if (workOrderCount > 0) {
				throw new IllegalArgumentException(
						"선택한 생산계획 중 작업지시가 생성된 항목이 있어 삭제할 수 없습니다.\n"
						+ "작업지시가 생성된 생산계획은 LOT/자재투입/생산실적 이력과 연결될 수 있으므로 삭제가 제한됩니다."
				);
			}
		}

		int deleteCount = 0;

		for (Integer prodPlanId : prodPlanIds) {
			deleteCount += productionDAO.deleteProductionPlan(prodPlanId);
		}

		if (deleteCount <= 0) {
			throw new IllegalArgumentException("삭제된 생산계획이 없습니다.");
		}

		return deleteCount;
	}


	// =========================================================
	// 2. 작업지시 관리
	// =========================================================

	public int selectWorkOrderCount(ProductionDTO productionDTO) {

		return productionDAO.selectWorkOrderCount(productionDTO);
	}

	public List<ProductionDTO> selectWorkOrderList(ProductionDTO productionDTO) {

		return productionDAO.selectWorkOrderList(productionDTO);
	}

	public List<ProductionDTO> selectWorkOrderPrintList(ProductionDTO productionDTO) {

		return productionDAO.selectWorkOrderPrintList(productionDTO);
	}

	public List<ProductionDTO> selectWorkOrderPrintDetailList(ProductionDTO productionDTO) {

		List<ProductionDTO> printList = new ArrayList<ProductionDTO>();

		if (productionDTO == null) {
			productionDTO = new ProductionDTO();
		}

		if (productionDTO.getOrderId() != null) {

			ProductionDTO workOrder =
					productionDAO.selectWorkOrderDetail(productionDTO.getOrderId());

			if (workOrder != null) {
				printList.add(workOrder);
			}

		} else {

			List<ProductionDTO> tempList =
					productionDAO.selectWorkOrderPrintList(productionDTO);

			if (tempList != null) {
				printList = tempList;
			}
		}

		setWorkOrderPrintSubInfo(printList);

		return printList;
	}


	private void setWorkOrderPrintSubInfo(List<ProductionDTO> printList) {

		if (printList == null || printList.isEmpty()) {
			return;
		}

		for (ProductionDTO workOrder : printList) {

			if (workOrder == null || workOrder.getOrderId() == null) {
				continue;
			}

			List<ProductionDTO> materialList =
					productionDAO.selectWorkOrderPrintMaterialList(workOrder.getOrderId());

			List<ProductionDTO> equipmentList =
					productionDAO.selectWorkOrderPrintEquipmentList(workOrder.getOrderId());

			setLimitedPrintMaterialList(workOrder, materialList);
			setLimitedPrintEquipmentList(workOrder, equipmentList);
		}
	}


	private void setLimitedPrintMaterialList(
			ProductionDTO workOrder,
			List<ProductionDTO> materialList) {

		List<ProductionDTO> limitedList = new ArrayList<ProductionDTO>();
		int extraCount = 0;

		if (materialList != null && !materialList.isEmpty()) {

			for (int i = 0; i < materialList.size(); i++) {

				if (i < PRINT_MATERIAL_LIMIT) {
					limitedList.add(materialList.get(i));
				}
			}

			if (materialList.size() > PRINT_MATERIAL_LIMIT) {
				extraCount = materialList.size() - PRINT_MATERIAL_LIMIT;
			}
		}

		workOrder.setPrintMaterialList(limitedList);
		workOrder.setPrintMaterialExtraCount(extraCount);
	}


	private void setLimitedPrintEquipmentList(
			ProductionDTO workOrder,
			List<ProductionDTO> equipmentList) {

		List<ProductionDTO> limitedList = new ArrayList<ProductionDTO>();
		int extraCount = 0;

		if (equipmentList != null && !equipmentList.isEmpty()) {

			for (int i = 0; i < equipmentList.size(); i++) {

				if (i < PRINT_EQUIPMENT_LIMIT) {
					limitedList.add(equipmentList.get(i));
				}
			}

			if (equipmentList.size() > PRINT_EQUIPMENT_LIMIT) {
				extraCount = equipmentList.size() - PRINT_EQUIPMENT_LIMIT;
			}
		}

		workOrder.setPrintEquipmentList(limitedList);
		workOrder.setPrintEquipmentExtraCount(extraCount);
	}

	public List<String> selectWorkOrderStatusList() {

		return productionDAO.selectWorkOrderStatusList();
	}

	public List<ProductionDTO> selectWorkOrderPlanList() {

		return productionDAO.selectWorkOrderPlanList();
	}

	public List<ProductionDTO> selectWorkOrderPlanList(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			productionDTO = new ProductionDTO();
		}

		return productionDAO.selectWorkOrderPlanList(productionDTO);
	}

	public List<ProductionDTO> selectLineList() {

		return productionDAO.selectLineList();
	}

	public List<ProductionDTO> selectWorkOrderEmpList() {

		return productionDAO.selectWorkOrderEmpList();
	}

	// 생산실적 등록/수정에서 사용할 담당자 목록을 조회한다.
	public List<ProductionDTO> selectProductionResultEmpList() {

		return productionDAO.selectProductionResultEmpList();
	}

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

		int result = productionDAO.insertWorkOrder(productionDTO);

		if (result <= 0) {
			throw new IllegalArgumentException("작업지시 등록에 실패했습니다.");
		}

		if (productionDTO.getOrderId() == null) {
			throw new IllegalArgumentException("작업지시번호 생성에 실패했습니다.");
		}

		ProductionDTO workOrderDetail =
				productionDAO.selectWorkOrderDetail(productionDTO.getOrderId());

		if (workOrderDetail == null) {
			throw new IllegalArgumentException("생성된 작업지시 정보를 다시 조회하지 못했습니다.");
		}

		if (workOrderDetail.getProductLot() == null
				|| workOrderDetail.getProductLot().trim().isEmpty()) {
			throw new IllegalArgumentException("작업지시 LOT 번호 생성에 실패했습니다.");
		}

		ProductionDTO appliedBom =
				productionDAO.selectWorkOrderAppliedBom(productionDTO.getOrderId());

		if (appliedBom == null || appliedBom.getBomId() == null) {
			throw new IllegalArgumentException(
					"해당 완제품에 사용 가능한 BOM이 없습니다. BOM 등록 후 작업지시를 생성하세요."
			);
		}

		List<ProductionDTO> materialList =
				productionDAO.selectWorkOrderBomMaterialList(productionDTO.getOrderId());

		if (materialList == null || materialList.isEmpty()) {
			throw new IllegalArgumentException(
					"해당 BOM에 등록된 원자재 구성 정보가 없습니다. BOM 상세를 등록하세요."
			);
		}

		int materialInoutCount =
				productionDAO.selectWorkOrderMaterialInoutCount(productionDTO.getOrderId());

		if (materialInoutCount > 0) {
			return result;
		}

		int materialResult =
				productionDAO.insertWorkOrderMaterialInoutByBom(productionDTO);

		if (materialResult <= 0) {
			throw new IllegalArgumentException("BOM 기준 원자재 투입 이력 생성에 실패했습니다.");
		}

		return result;
	}

	public ProductionDTO selectWorkOrderDetail(Integer orderId) {

		return productionDAO.selectWorkOrderDetail(orderId);
	}

	public int updateWorkOrder(ProductionDTO productionDTO) {

		return productionDAO.updateWorkOrder(productionDTO);
	}


	// =========================================================
	// 3. 작업지시 BOM / 원자재 자동투입 조회
	// =========================================================

	public ProductionDTO selectWorkOrderAppliedBom(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("작업지시 정보가 없습니다.");
		}

		return productionDAO.selectWorkOrderAppliedBom(orderId);
	}

	public List<ProductionDTO> selectWorkOrderBomMaterialList(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("작업지시 정보가 없습니다.");
		}

		return productionDAO.selectWorkOrderBomMaterialList(orderId);
	}

	public List<ProductionDTO> selectWorkOrderMaterialInoutList(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("작업지시 정보가 없습니다.");
		}

		return productionDAO.selectWorkOrderMaterialInoutList(orderId);
	}


	// =========================================================
	// 4. 생산실적 등록
	// =========================================================

	public int selectProductionResultCount(ProductionDTO productionDTO) {

		return productionDAO.selectProductionResultCount(productionDTO);
	}

	public List<ProductionDTO> selectProductionResultList(ProductionDTO productionDTO) {

		return productionDAO.selectProductionResultList(productionDTO);
	}

	public List<String> selectProductionResultStatusList() {

		return productionDAO.selectProductionResultStatusList();
	}

	// 생산실적 등록 모달에서 사용할 작업지시 목록을 조회한다.
	// 기본값은 소량 잔량 미포함이며, Mapper 기준 잔량 20EA 이상만 조회한다.
	public List<ProductionDTO> selectProductionResultOrderList() {

		ProductionDTO productionDTO = new ProductionDTO();
		productionDTO.setIncludeSmallRemain("N");

		return selectProductionResultOrderList(productionDTO);
	}

	// 생산실적 등록 모달에서 사용할 작업지시 목록을 조회한다.
	// includeSmallRemain 값이 Y이면 잔량 1EA 이상 작업지시까지 조회한다.
	public List<ProductionDTO> selectProductionResultOrderList(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			productionDTO = new ProductionDTO();
		}

		String includeSmallRemain = trimToEmpty(productionDTO.getIncludeSmallRemain());

		if ("Y".equalsIgnoreCase(includeSmallRemain)) {
			productionDTO.setIncludeSmallRemain("Y");
		} else {
			productionDTO.setIncludeSmallRemain("N");
		}

		return productionDAO.selectProductionResultOrderList(productionDTO);
	}

	public ProductionDTO selectProductionResultOrderByQr(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			throw new IllegalArgumentException("QR 작업지시 정보가 없습니다.");
		}

		if (productionDTO.getOrderId() == null) {
			throw new IllegalArgumentException("QR 작업지시 ID가 없습니다.");
		}

		return productionDAO.selectProductionResultOrderByQr(productionDTO);
	}

	@Transactional
	public int insertProductionResult(ProductionDTO productionDTO) {

		validateProductionResultInsert(productionDTO);

		return productionDAO.insertProductionResult(productionDTO);
	}

	public ProductionDTO selectProductionResultDetail(Integer prodId) {

		return productionDAO.selectProductionResultDetail(prodId);
	}

	@Transactional
	public int updateProductionResult(ProductionDTO productionDTO) {

		validateProductionResultUpdate(productionDTO);

		return productionDAO.updateProductionResult(productionDTO);
	}


	private void validateProductionResultInsert(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			throw new IllegalArgumentException("등록할 생산실적 정보가 없습니다.");
		}

		if (productionDTO.getOrderId() == null || productionDTO.getOrderId() <= 0) {
			throw new IllegalArgumentException("작업지시를 선택해주세요.");
		}

		if (productionDTO.getEmpId() == null || productionDTO.getEmpId() <= 0) {
			throw new IllegalArgumentException("담당자를 선택해주세요.");
		}

		if (isBlank(productionDTO.getProdDate())) {
			throw new IllegalArgumentException("생산일을 선택해주세요.");
		}

		if (productionDTO.getProdQty() == null || productionDTO.getProdQty() <= 0) {
			throw new IllegalArgumentException("생산수량은 1 이상 입력해주세요.");
		}

		if (productionDTO.getLossQty() == null) {
			productionDTO.setLossQty(0);
		}

		if (productionDTO.getLossQty() < 0) {
			throw new IllegalArgumentException("LOSS량은 0 이상 입력해주세요.");
		}

		if (productionDTO.getLossQty() > productionDTO.getProdQty()) {
			throw new IllegalArgumentException("LOSS량은 생산수량보다 클 수 없습니다.");
		}

		ProductionDTO orderSearchDTO = new ProductionDTO();
		orderSearchDTO.setOrderId(productionDTO.getOrderId());

		ProductionDTO orderInfo =
				productionDAO.selectProductionResultOrderByQr(orderSearchDTO);

		if (orderInfo == null) {
			throw new IllegalArgumentException(
					"등록 가능한 작업지시가 아닙니다. 이미 잔량이 없거나 작업지시 정보를 찾을 수 없습니다."
			);
		}

		int remainQty = getSafeInt(orderInfo.getRemainQty());
		int requestQty = getSafeInt(productionDTO.getProdQty())
				+ getSafeInt(productionDTO.getLossQty());

		if (remainQty <= 0) {
			throw new IllegalArgumentException("해당 작업지시는 잔량이 없어 생산실적을 등록할 수 없습니다.");
		}

		if (requestQty > remainQty) {
			throw new IllegalArgumentException(
					"생산수량과 LOSS량의 합은 작업지시 잔량보다 클 수 없습니다."
			);
		}

		productionDTO.setOrderQty(orderInfo.getOrderQty());

		if ("보류".equals(trimToEmpty(productionDTO.getProdStatus()))) {
			productionDTO.setProdStatus("보류");
		} else {
			productionDTO.setProdStatus("진행중");
		}
	}


	private void validateProductionResultUpdate(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			throw new IllegalArgumentException("수정할 생산실적 정보가 없습니다.");
		}

		if (productionDTO.getProdId() == null || productionDTO.getProdId() <= 0) {
			throw new IllegalArgumentException("수정할 생산실적 정보가 올바르지 않습니다.");
		}

		if (productionDTO.getEmpId() == null || productionDTO.getEmpId() <= 0) {
			throw new IllegalArgumentException("담당자를 선택해주세요.");
		}

		if (productionDTO.getProdQty() == null || productionDTO.getProdQty() <= 0) {
			throw new IllegalArgumentException("생산수량은 1 이상 입력해주세요.");
		}

		if (productionDTO.getLossQty() == null) {
			productionDTO.setLossQty(0);
		}

		if (productionDTO.getLossQty() < 0) {
			throw new IllegalArgumentException("LOSS량은 0 이상 입력해주세요.");
		}

		if (productionDTO.getLossQty() > productionDTO.getProdQty()) {
			throw new IllegalArgumentException("LOSS량은 생산수량보다 클 수 없습니다.");
		}

		ProductionDTO currentDetail =
				productionDAO.selectProductionResultDetail(productionDTO.getProdId());

		if (currentDetail == null || currentDetail.getOrderId() == null) {
			throw new IllegalArgumentException("기존 생산실적 정보를 찾을 수 없습니다.");
		}

		String requestStatus = trimToEmpty(productionDTO.getProdStatus());

		if ("취소".equals(requestStatus)) {
			productionDTO.setProdStatus("취소");
		} else if ("보류".equals(requestStatus)) {
			productionDTO.setProdStatus("보류");
		} else {
			productionDTO.setProdStatus("진행중");
		}

		if ("취소".equals(productionDTO.getProdStatus())) {
			productionDTO.setOrderId(currentDetail.getOrderId());
			productionDTO.setOrderQty(currentDetail.getOrderQty());
			return;
		}

		ProductionDTO orderSearchDTO = new ProductionDTO();
		orderSearchDTO.setOrderId(currentDetail.getOrderId());

		ProductionDTO orderInfo =
				productionDAO.selectProductionResultOrderByQr(orderSearchDTO);

		int remainQty = 0;

		if (orderInfo != null && orderInfo.getRemainQty() != null) {
			remainQty = getSafeInt(orderInfo.getRemainQty());
		}

		int currentCountedQty = 0;

		if (!"취소".equals(trimToEmpty(currentDetail.getProdStatus()))) {
			currentCountedQty =
					getSafeInt(currentDetail.getProdQty())
					+ getSafeInt(currentDetail.getLossQty());
		}

		int availableQty = remainQty + currentCountedQty;

		int requestQty =
				getSafeInt(productionDTO.getProdQty())
				+ getSafeInt(productionDTO.getLossQty());

		if (requestQty > availableQty) {
			throw new IllegalArgumentException(
					"생산수량과 LOSS량의 합은 작업지시 잔량보다 클 수 없습니다."
			);
		}

		productionDTO.setOrderId(currentDetail.getOrderId());
		productionDTO.setOrderQty(currentDetail.getOrderQty());
	}


	private int getSafeInt(Integer value) {

		if (value == null) {
			return 0;
		}

		return value;
	}


	private boolean isBlank(String value) {

		return value == null || value.trim().isEmpty();
	}


	private String trimToEmpty(String value) {

		if (value == null) {
			return "";
		}

		return value.trim();
	}


	// =========================================================
	// 5. 공정진행 현황
	// =========================================================

	public int selectProcessProgressCount(ProductionDTO productionDTO) {

		return productionDAO.selectProcessProgressCount(productionDTO);
	}

	public List<ProductionDTO> selectProcessProgressList(ProductionDTO productionDTO) {

		return productionDAO.selectProcessProgressList(productionDTO);
	}

	public List<String> selectProcessProgressStatusList() {

		return productionDAO.selectProcessProgressStatusList();
	}

	public ProductionDTO selectProcessProgressDetail(Integer orderId) {

		return productionDAO.selectProcessProgressDetail(orderId);
	}


	// =========================================================
	// 6. QR 생성 내부 메서드
	// =========================================================

	public byte[] createWorkOrderQrImageBytes(Integer orderId) {

		if (orderId == null || orderId <= 0) {
			throw new IllegalArgumentException("QR을 생성할 작업지시 정보가 없습니다.");
		}

		ProductionDTO workOrderDetail =
				productionDAO.selectWorkOrderDetail(orderId);

		if (workOrderDetail == null) {
			throw new IllegalArgumentException("작업지시 정보를 찾을 수 없습니다.");
		}

		if (workOrderDetail.getProductLot() == null
				|| workOrderDetail.getProductLot().trim().isEmpty()) {
			throw new IllegalArgumentException("QR에 포함할 LOT 번호가 없습니다.");
		}

		String qrUrl = buildWorkOrderQrUrl(workOrderDetail);

		try {
			Map<EncodeHintType, Object> hints =
					new HashMap<EncodeHintType, Object>();

			hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
			hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
			hints.put(EncodeHintType.MARGIN, 1);

			QRCodeWriter qrCodeWriter = new QRCodeWriter();

			BitMatrix bitMatrix = qrCodeWriter.encode(
					qrUrl,
					BarcodeFormat.QR_CODE,
					250,
					250,
					hints
			);

			ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

			MatrixToImageWriter.writeToStream(
					bitMatrix,
					"PNG",
					outputStream
			);

			return outputStream.toByteArray();

		} catch (WriterException e) {
			throw new IllegalArgumentException("QR 코드 생성에 실패했습니다.", e);

		} catch (Exception e) {
			throw new IllegalArgumentException("QR 이미지 변환에 실패했습니다.", e);
		}
	}


	private String buildWorkOrderQrUrl(ProductionDTO workOrderDetail) {

		if (workOrderDetail == null || workOrderDetail.getOrderId() == null) {
			throw new IllegalArgumentException("QR URL을 생성할 작업지시 정보가 없습니다.");
		}

		String productLot = workOrderDetail.getProductLot();

		if (productLot == null || productLot.trim().isEmpty()) {
			throw new IllegalArgumentException("QR URL에 포함할 LOT 번호가 없습니다.");
		}

		String contextPath = servletContext.getContextPath();

		if (contextPath == null || contextPath.trim().isEmpty()) {
			contextPath = "/saeroi";
		}

		String encodedLot = encodeUrl(productLot);

		return QR_BASE_URL
				+ contextPath
				+ "/production/productionresult"
				+ "?orderId=" + workOrderDetail.getOrderId()
				+ "&productLot=" + encodedLot
				+ "&openModal=Y";
	}


	private String encodeUrl(String value) {

		if (value == null) {
			return "";
		}

		return URLEncoder.encode(value, StandardCharsets.UTF_8);
	}

}