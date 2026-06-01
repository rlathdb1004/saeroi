package kr.or.saeroi.dto;

import lombok.Data;

// LOT 이력추적에서 사용하는 데이터 전달 객체이다.
@Data
public class LotDTO {

	// 작업지시 ID이다.
	private Integer orderId;

	// 생산계획 ID이다.
	private Integer prodPlanId;

	// 품목 ID이다.
	private Integer itemId;

	// 생산실적 ID이다.
	private Integer prodId;

	// 검사 ID이다.
	private Integer inspId;

	// LOT 번호이다.
	private String productLot;

	// 생산계획 문서번호이다.
	private String prodPlanDocNo;

	// 작업지시 문서번호이다.
	private String workOrderDocNo;

	// 생산실적 문서번호이다.
	private String prodDocNo;

	// 검사 문서번호이다.
	private String inspDocNo;

	// 품목코드이다.
	private String itemCode;

	// 품목명이다.
	private String itemName;

	// 품목구분이다.
	private String itemType;

	// 품목단위이다.
	private String itemUnit;

	// 안전재고이다.
	private Integer safetyStock;

	// 납품 거래처 코드이다.
	private String clientCode;

	// 납품 거래처명이다.
	private String clientName;

	// 납품 거래처 구분이다.
	private String clientType;

	// 납품 거래처 사업자번호이다.
	private String clientBusinessNo;

	// 납품 거래처 주소이다.
	private String clientAddress;

	// 납품 거래처 담당자이다.
	private String clientManager;

	// 납품 거래처 연락처이다.
	private String clientTel;

	// 납품 거래처 부서이다.
	private String clientDept;

	// 현재 품목 재고이다.
	private Integer inventoryStock;

	// 재고 위치이다.
	private String stockLocation;

	// 재고 비고이다.
	private String inventoryRemark;

	// 완제품 LOT 총 입고수량이다.
	private Integer productInQtyTotal;

	// 완제품 LOT 총 출고수량이다.
	private Integer productOutQtyTotal;

	// 완제품 LOT 현재 잔량이다.
	private Integer productRemainQty;

	// 현재공정으로 보여줄 라인명이다.
	private String currentProcess;

	// 라인코드이다.
	private String lineCode;

	// 라인명이다.
	private String lineName;

	// 생산계획수량이다.
	private Integer prodPlanQty;

	// 작업지시수량이다.
	private Integer orderQty;

	// 생산수량이다.
	private Integer prodQty;

	// 불량수량이다.
	private Integer lossQty;

	// 양품수량이다.
	private Integer goodQty;

	// 검사수량이다.
	private Integer inspectionQty;

	// 진행률이다.
	private Integer progressRate;

	// 진행상태이다.
	private String progressStatus;

	// 검사결과이다.
	private String inspResult;

	// 생산계획일이다.
	private String prodPlanDate;

	// 납기일이다.
	private String dueDate;

	// 작업지시일이다.
	private String orderDate;

	// 생산일자이다.
	private String prodDate;

	// 검사일자이다.
	private String inspDate;

	// 담당자명이다.
	private String ename;

	// 부서명이다.
	private String dept;

	// 작업지시 담당자명이다.
	private String workOrderEmpName;

	// 비고이다.
	private String remark;

	// QR 이동 URL이다.
	private String qrUrl;

	// QR 이미지 경로이다.
	private String qrImagePath;

	// 자재 입출고 ID이다.
	private Integer inoutId;

	// 자재 품목 ID이다.
	private Integer materialItemId;

	// 자재 품목코드이다.
	private String materialItemCode;

	// 자재 품목명이다.
	private String materialItemName;

	// 자재 품목구분이다.
	private String materialItemType;

	// 자재 입출고 문서번호이다.
	private String materialDocNo;

	// 자재 LOT 번호이다.
	private String materialLot;

	// 입출고 구분 코드이다.
	private String inoutType;

	// 입출고 구분명이다.
	private String inoutTypeName;

	// 입출고 수량이다.
	private Integer inoutQty;

	// 입출고 일자이다.
	private String inoutDate;

	// 입출고 상태이다.
	private String inoutStatus;

	// 입출고 담당자명이다.
	private String inoutEmpName;

	// 자재 입출고 비고이다.
	private String materialRemark;

	// 생산상태이다.
	private String prodStatus;

	// 검사상태이다.
	private String inspectionStatus;

	// 생산 담당자명이다.
	private String prodEmpName;

	// 생산실적 비고이다.
	private String prodRemark;

	// 검사유형이다.
	private String inspType;

	// 검사상태이다.
	private String inspStatus;

	// 검사 양품수량이다.
	private Integer inspectionGoodQty;

	// 검사 불량수량이다.
	private Integer inspectionBadQty;

	// 검사 담당자명이다.
	private String inspEmpName;

	// 검사 비고이다.
	private String inspRemark;

	// 불량 이력 ID이다.
	private Integer defectListId;

	// 불량코드 ID이다.
	private Integer defectId;

	// 불량 문서번호이다.
	private String defectDocNo;

	// 불량코드이다.
	private String defectCode;

	// 불량명이다.
	private String defectName;

	// 불량유형이다.
	private String defectType;

	// 불량수량이다.
	private Integer defectQty;

	// 불량일자이다.
	private String defectDate;

	// 불량사진 경로이다.
	private String defectPhoto;

	// 불량 비고이다.
	private String defectRemark;

	// 조치 건수이다.
	private Integer actionCount;

	// 조치일자이다.
	private String actionDate;

	// 조치내용이다.
	private String actionContent;

	// 완제품 입출고 ID이다.
	private Integer productInoutId;

	// 완제품 입출고 문서번호이다.
	private String productInoutDocNo;

	// 완제품 입출고 구분 코드이다.
	private String productInoutType;

	// 완제품 입출고 구분명이다.
	private String productInoutTypeName;

	// 완제품 입출고 수량이다.
	private Integer productInoutQty;

	// 완제품 입출고 일자이다.
	private String productInoutDate;

	// 완제품 입출고 상태이다.
	private String productInoutStatus;

	// 완제품 입출고 담당자명이다.
	private String productInoutEmpName;

	// 완제품 입출고 비고이다.
	private String productInoutRemark;

	// 완제품 입출고 LOT 번호이다.
	private String productInoutProductLot;

	// 완제품 입출고 품목코드이다.
	private String productInoutItemCode;

	// 완제품 입출고 품목명이다.
	private String productInoutItemName;

	// 완제품 입출고 품목구분이다.
	private String productInoutItemType;

	// 완제품 입출고 품목단위이다.
	private String productInoutItemUnit;

	// 완제품 입출고 안전재고이다.
	private Integer productInoutSafetyStock;

	// 완제품 입출고와 연결된 검사번호이다.
	private String productInoutInspDocNo;

	// 완제품 입출고 거래처 코드이다.
	private String productInoutClientCode;

	// 완제품 입출고 거래처명이다.
	private String productInoutClientName;

	// 완제품 입출고 거래처 구분이다.
	private String productInoutClientType;

	// 완제품 입출고 거래처 사업자번호이다.
	private String productInoutClientBusinessNo;

	// 완제품 입출고 거래처 주소이다.
	private String productInoutClientAddress;

	// 완제품 입출고 거래처 담당자이다.
	private String productInoutClientManager;

	// 완제품 입출고 거래처 연락처이다.
	private String productInoutClientTel;

	// 완제품 입출고 거래처 부서이다.
	private String productInoutClientDept;

	// 완제품 입출고 품목 현재 재고이다.
	private Integer productInoutInventoryStock;

	// 완제품 입출고 재고 위치이다.
	private String productInoutStockLocation;

	// 완제품 입출고 재고 비고이다.
	private String productInoutInventoryRemark;

	// 완제품 LOT 누적 입고수량이다.
	private Integer productInoutLotInQty;

	// 완제품 LOT 누적 출고수량이다.
	private Integer productInoutLotOutQty;

	// 완제품 LOT 현재 잔량이다.
	private Integer productInoutLotRemainQty;

	// 검색 조건 시작일이다.
	private String startDate;

	// 검색 조건 종료일이다.
	private String endDate;

	// 검색키워드이다.
	private String keyword;

	// 검색 구분이다.
	private String searchType;

	// Oracle ROWNUM 페이징 시작 행 번호이다.
	private Integer startRow;

	// Oracle ROWNUM 페이징 마지막 행 번호이다.
	private Integer endRow;
}
