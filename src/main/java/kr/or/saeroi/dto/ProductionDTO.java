package kr.or.saeroi.dto;

import java.util.List;

import lombok.Data;

// 생산관리에서 사용하는 데이터 전달 객체이다.
// 생산계획, 작업지시, 생산실적, 공정진행, BOM 기준 자재투입, 작업지시서 인쇄 정보를 함께 관리한다.
@Data
public class ProductionDTO {

	// =========================================================
	// 생산계획 production_plan
	// =========================================================

	// production_plan 테이블의 생산계획 ID이다.
	private Integer prodPlanId;

	// production_plan 테이블의 생산계획 수량이다.
	private Integer prodPlanQty;

	// production_plan 테이블의 생산계획 일자이다.
	private String prodPlanDate;

	// production_plan 테이블의 생성일이다.
	private String createdDate;

	// production_plan 테이블의 수정일이다.
	private String updatedDate;

	// 공통 비고이다.
	private String remark;

	// production_plan 테이블의 품목 ID이다.
	// 생산계획에서는 완제품 item_id를 의미한다.
	private Integer itemId;

	// production_plan 테이블의 납기일이다.
	private String dueDate;

	// production_plan 테이블의 생산계획 문서번호이다.
	private String docNo;

	// 작업지시 상세에서 보여줄 생산계획 문서번호이다.
	private String prodPlanDocNo;

	// production_plan 테이블의 문서 순번이다.
	private Integer docSeq;


	// =========================================================
	// 품목 item
	// =========================================================

	// item 테이블의 품목 코드이다.
	private String itemCode;

	// item 테이블의 품목명이다.
	private String itemName;

	// item 테이블의 품목 구분이다.
	private String itemType;

	// item 테이블의 품목 단위이다.
	private String itemUnit;


	// =========================================================
	// 검색 / 페이징 / 화면 제어
	// =========================================================

	// 검색 조건 시작일이다.
	private String startDate;

	// 검색 조건 종료일이다.
	private String endDate;

	// 검색어이다.
	private String keyword;

	// Oracle ROWNUM 페이징 시작 행 번호이다.
	private Integer startRow;

	// Oracle ROWNUM 페이징 마지막 행 번호이다.
	private Integer endRow;

	// 작업지시 등록 모달에서 지난 생산계획 포함 여부이다.
	// Y이면 생산계획일자가 지난 계획도 조회한다.
	private String includePastPlan;

	// QR 스캔 진입 시 등록 모달 자동 오픈 여부이다.
	private String openModal;


	// =========================================================
	// 작업지시 work_order
	// =========================================================

	// work_order 테이블의 작업지시 ID이다.
	private Integer orderId;

	// work_order 테이블의 생산라인 ID이다.
	private Integer lineId;

	// work_order 테이블의 담당자 ID이다.
	private Integer empId;

	// work_order 테이블의 완제품 LOT 번호이다.
	private String productLot;

	// work_order 테이블의 작업지시 수량이다.
	private Integer orderQty;

	// work_order 테이블의 작업지시 일자이다.
	private String orderDate;

	// 작업지시 문서번호를 따로 보여주기 위한 값이다.
	private String workOrderDocNo;

	// 작업지시로 이미 배정된 수량이다.
	private Integer orderedQty;

	// 생산계획수량 - 작업지시수량 합계로 계산한 잔여수량이다.
	private Integer remainQty;

	// 작업지시 QR 이동 URL이다.
	private String qrUrl;

	// 작업지시 QR 이미지 저장 경로이다.
	// 현재는 실시간 QR 생성 방식을 사용하므로 화면에서는 필수로 사용하지 않는다.
	private String qrImagePath;


	// =========================================================
	// 생산실적 production
	// =========================================================

	// production 테이블의 생산실적 ID이다.
	private Integer prodId;

	// production 테이블의 생산일자이다.
	private String prodDate;

	// production 테이블의 생산수량이다.
	private Integer prodQty;

	// production 테이블의 LOSS량이다.
	// 불량수량이 아니라 생산 중 손실수량이다.
	private Integer lossQty;

	// production 테이블의 생산 상태이다.
	private String prodStatus;

	// 검사 테이블 기준 양품수량 집계값이다.
	private Integer goodQty;

	// 불량 상세 테이블 기준 불량수량 집계값이다.
	private Integer defectQty;

	// 생산수량 = 양품수량 + 불량수량 + LOSS량 검증 결과이다.
	// Y: 일치, N: 불일치
	private String qtyCheckYn;

	// 생산수량 - (양품수량 + 불량수량 + LOSS량) 차이값이다.
	private Integer qtyDiff;


	// =========================================================
	// 라인 line
	// =========================================================

	// line 테이블의 라인 코드이다.
	private String lineCode;

	// line 테이블의 라인명이다.
	private String lineName;

	// line 테이블의 라인 상태이다.
	private String lineStatus;


	// =========================================================
	// 설비 equipment
	// 작업지시서 인쇄에서 라인 기준 설비 확인 목록에 사용한다.
	// =========================================================

	// equipment 테이블의 설비 ID이다.
	private Integer equipId;

	// equipment 테이블의 설비 코드이다.
	private String equipCode;

	// equipment 테이블의 설비명이다.
	private String equipName;

	// equipment 테이블의 설비 상태이다.
	private String equipStatus;

	// equipment 테이블의 설비 위치이다.
	private String equipLoc;


	// =========================================================
	// 사원 emp
	// =========================================================

	// emp 테이블의 사원번호이다.
	private String empno;

	// emp 테이블의 사원명이다.
	private String ename;

	// emp 테이블의 부서명이다.
	private String dept;

	// emp 테이블의 직무명이다.
	private String job;


	// =========================================================
	// 공정진행 현황
	// =========================================================

	// 공정진행 현황에서 사용할 누적 생산수량이다.
	private Integer totalProdQty;

	// 공정진행 현황에서 사용할 누적 LOSS량이다.
	private Integer totalLossQty;

	// 공정진행 현황에서 사용할 진행률이다.
	private Integer progressRate;

	// 공정진행 현황에서 사용할 진행상태이다.
	private String progressStatus;


	// =========================================================
	// BOM bom / bom_detail
	// 작업지시 등록 및 작업지시서 인쇄에서 적용 BOM 확인에 사용한다.
	// =========================================================

	// bom 테이블의 BOM ID이다.
	private Integer bomId;

	// bom 테이블의 BOM 코드이다.
	private String bomCode;

	// bom 테이블의 BOM 버전이다.
	private Integer bomVersion;

	// bom 테이블의 사용여부이다.
	private String bomUseYn;

	// bom_detail 테이블의 BOM 상세 ID이다.
	private Integer bomDetailId;

	// bom_detail 테이블의 기준 소요량이다.
	private Double bomQty;

	// 작업지시 수량 * BOM 소요량으로 계산된 필요수량이다.
	private Double requiredQty;


	// =========================================================
	// BOM 기준 투입 원자재 item
	// 완제품 itemId와 구분하기 위해 material prefix를 사용한다.
	// =========================================================

	// 투입 원자재/부자재 품목 ID이다.
	private Integer materialItemId;

	// 투입 원자재/부자재 품목 코드이다.
	private String materialItemCode;

	// 투입 원자재/부자재 품목명이다.
	private String materialItemName;

	// 투입 원자재/부자재 품목 구분이다.
	private String materialItemType;

	// 투입 원자재/부자재 단위이다.
	private String materialItemUnit;


	// =========================================================
	// 자재 입출고 material_inout
	// 작업지시 등록 시 BOM 기준으로 MO-PROD 자동 생성한다.
	// =========================================================

	// material_inout 테이블의 입출고 ID이다.
	private Integer inoutId;

	// material_inout 테이블의 입출고 유형이다.
	// 작업지시 자동 투입은 MO-PROD를 사용한다.
	private String inoutType;

	// material_inout 테이블의 원자재 LOT 번호이다.
	private String materialLot;

	// material_inout 테이블의 입출고 수량이다.
	private Double inoutQty;

	// material_inout 테이블의 입출고 일자이다.
	private String inoutDate;

	// material_inout 테이블의 상태이다.
	private String inoutStatus;

	// material_inout 테이블의 사용여부이다.
	private String useYn;

	// material_inout 테이블의 비고이다.
	private String inoutRemark;


	// =========================================================
	// 자재 가용성 / 화면 표시 보조
	// =========================================================

	// 해당 원자재의 사용 가능 재고수량이다.
	private Double availableQty;

	// 재고 부족 여부이다.
	// Y: 부족, N: 정상
	private String shortageYn;

	// 자재 자동투입 처리 결과 메시지이다.
	private String materialApplyMessage;

	// 작업지시 상세 또는 인쇄 목록 표시용 순번이다.
	private Integer rowNo;


	// =========================================================
	// 작업지시서 인쇄 전용 하위 목록
	// 작업지시 1건 = A4 1장 조건을 맞추기 위해 Service에서 목록을 제한해서 담는다.
	// =========================================================

	// 작업지시서에 출력할 BOM/자재 LOT 확인 목록이다.
	private List<ProductionDTO> printMaterialList;

	// 작업지시서에 출력할 라인/설비 확인 목록이다.
	private List<ProductionDTO> printEquipmentList;

	// 작업지시서 자재 목록에서 제한 행 수를 초과한 건수이다.
	// 예: 자재 7건 중 5건만 출력하면 2
	private Integer printMaterialExtraCount;

	// 작업지시서 설비 목록에서 제한 행 수를 초과한 건수이다.
	// 예: 설비 6건 중 4건만 출력하면 2
	private Integer printEquipmentExtraCount;
}