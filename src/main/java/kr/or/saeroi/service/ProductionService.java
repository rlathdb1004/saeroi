package kr.or.saeroi.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
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

	// QR 이미지 파일을 실제 웹 리소스 경로에 저장하기 위해 ServletContext를 사용한다.
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

	// 작업지시 검색조건에 맞는 전체 인쇄용 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPrintList(ProductionDTO productionDTO) {

		return productionDAO.selectWorkOrderPrintList(productionDTO);
	}
	
	// 작업지시 인쇄용 상세 목록을 조회한다.
	// orderId가 있으면 단건 인쇄, orderId가 없으면 검색조건 기준 전체 인쇄이다.
	// 각 작업지시에 BOM/자재 LOT 목록과 라인/설비 목록을 붙인다.
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


	// 작업지시 인쇄 목록에 자재/BOM 목록과 설비 목록을 붙인다.
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


	// 작업지시서 A4 1장 조건에 맞게 자재/BOM 목록을 최대 5건까지만 담는다.
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


	// 작업지시서 A4 1장 조건에 맞게 라인/설비 목록을 최대 4건까지만 담는다.
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

	// 작업지시 검색 select box에 사용할 작업상태 목록을 조회한다.
	public List<String> selectWorkOrderStatusList() {

		return productionDAO.selectWorkOrderStatusList();
	}

	// 작업지시 등록 모달에서 사용할 생산계획 목록을 조회한다.
	public List<ProductionDTO> selectWorkOrderPlanList() {

		return productionDAO.selectWorkOrderPlanList();
	}

	// 작업지시 등록 모달에서 사용할 생산계획 목록을 조회한다.
	// includePastPlan 값에 따라 지난 생산계획 포함 여부를 제어한다.
	public List<ProductionDTO> selectWorkOrderPlanList(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			productionDTO = new ProductionDTO();
		}

		return productionDAO.selectWorkOrderPlanList(productionDTO);
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
	 * 3. 생성된 작업지시 상세 재조회
	 * 4. 작업지시 LOT 기반 QR URL 생성
	 * 5. QR 이미지 파일 생성
	 * 6. WORK_ORDER에 qr_url, qr_image_path 저장
	 * 7. 작업지시 → 생산계획 → 완제품 item_id 기준으로 사용중 BOM 조회
	 * 8. BOM_DETAIL 기준 필요 원자재 목록 조회
	 * 9. MATERIAL_INOUT에 MO-PROD 자재투입 이력 자동 생성
	 *
	 * 주의:
	 * - @Transactional 적용
	 * - QR 생성, BOM 조회, 자재투입 중 하나라도 실패하면 작업지시 등록도 같이 롤백한다.
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

		// 작업지시 등록 후 생성된 LOT, 문서번호를 재조회한다.
		ProductionDTO workOrderDetail =
				productionDAO.selectWorkOrderDetail(productionDTO.getOrderId());

		if (workOrderDetail == null) {
			throw new IllegalArgumentException("생성된 작업지시 정보를 다시 조회하지 못했습니다.");
		}

		if (workOrderDetail.getProductLot() == null
				|| workOrderDetail.getProductLot().trim().isEmpty()) {
			throw new IllegalArgumentException("작업지시 LOT 번호 생성에 실패했습니다.");
		}

		// QR URL과 QR 이미지 파일을 생성하고 work_order에 저장한다.
		ProductionDTO qrDTO = createWorkOrderQrInfo(workOrderDetail);

		int qrResult = productionDAO.updateWorkOrderQr(qrDTO);

		if (qrResult <= 0) {
			throw new IllegalArgumentException("작업지시 QR 정보 저장에 실패했습니다.");
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

	// 작업지시 등록 후 생성된 QR 정보를 저장한다.
	public int updateWorkOrderQr(ProductionDTO productionDTO) {

		return productionDAO.updateWorkOrderQr(productionDTO);
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

	// QR 스캔 진입 시 자동입력할 작업지시 정보를 조회한다.
	public ProductionDTO selectProductionResultOrderByQr(ProductionDTO productionDTO) {

		if (productionDTO == null) {
			throw new IllegalArgumentException("QR 작업지시 정보가 없습니다.");
		}

		if (productionDTO.getOrderId() == null) {
			throw new IllegalArgumentException("QR 작업지시 ID가 없습니다.");
		}

		return productionDAO.selectProductionResultOrderByQr(productionDTO);
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


	// =========================================================
	// 6. QR 생성 내부 메서드
	// =========================================================

	// 작업지시 ID 기준으로 QR 이미지를 실시간 생성해서 PNG byte 배열로 반환한다.
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
	
	// 작업지시 LOT 기반 QR URL과 QR 이미지 경로를 만든다.
	private ProductionDTO createWorkOrderQrInfo(ProductionDTO workOrderDetail) {

		if (workOrderDetail == null || workOrderDetail.getOrderId() == null) {
			throw new IllegalArgumentException("QR을 생성할 작업지시 정보가 없습니다.");
		}

		String productLot = workOrderDetail.getProductLot();

		if (productLot == null || productLot.trim().isEmpty()) {
			throw new IllegalArgumentException("QR에 포함할 LOT 번호가 없습니다.");
		}

		String qrUrl = buildWorkOrderQrUrl(workOrderDetail);

		String qrFileName = "work_order_qr_"
				+ workOrderDetail.getOrderId()
				+ "_"
				+ safeFileName(productLot)
				+ ".png";

		String qrWebDir = "/resources/upload/qr/workorder";
		String qrImagePath = qrWebDir + "/" + qrFileName;

		saveQrImage(qrUrl, qrWebDir, qrFileName);

		ProductionDTO qrDTO = new ProductionDTO();

		qrDTO.setOrderId(workOrderDetail.getOrderId());
		qrDTO.setQrUrl(qrUrl);
		qrDTO.setQrImagePath(qrImagePath);

		return qrDTO;
	}
	
	// 작업지시 LOT 기반 QR 이동 URL을 생성한다.
	// 모바일에서 접속할 수 있도록 내부 IP가 포함된 절대 URL로 생성한다.
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

	// QR 이미지를 웹 리소스 폴더에 PNG로 저장한다.
	private void saveQrImage(String qrUrl, String qrWebDir, String qrFileName) {

		if (qrUrl == null || qrUrl.trim().isEmpty()) {
			throw new IllegalArgumentException("QR URL이 없습니다.");
		}

		try {
			String realDirPath = servletContext.getRealPath(qrWebDir);

			if (realDirPath == null || realDirPath.trim().isEmpty()) {
				throw new IllegalArgumentException("QR 이미지 저장 경로를 확인할 수 없습니다.");
			}

			File realDir = new File(realDirPath);

			if (!realDir.exists()) {
				boolean created = realDir.mkdirs();

				if (!created) {
					throw new IllegalArgumentException("QR 이미지 저장 폴더 생성에 실패했습니다.");
				}
			}

			Path qrFilePath = Paths.get(realDirPath, qrFileName);

			Map<EncodeHintType, Object> hints = new HashMap<EncodeHintType, Object>();
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

			MatrixToImageWriter.writeToPath(bitMatrix, "PNG", qrFilePath);

		} catch (WriterException e) {
			throw new IllegalArgumentException("QR 코드 생성에 실패했습니다.", e);
		} catch (Exception e) {
			throw new IllegalArgumentException("QR 이미지 저장에 실패했습니다.", e);
		}
	}

	// URL 파라미터 인코딩 처리이다.
	private String encodeUrl(String value) {

		if (value == null) {
			return "";
		}

		return URLEncoder.encode(value, StandardCharsets.UTF_8);
	}

	// 파일명으로 안전하게 사용할 문자열로 변환한다.
	private String safeFileName(String value) {

		if (value == null || value.trim().isEmpty()) {
			return "lot";
		}

		return value.replaceAll("[^a-zA-Z0-9가-힣._-]", "_");
	}
}