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

	// 현재공정으로 보여줄 라인명이다.
	private String currentProcess;

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

	// 비고이다.
	private String remark;

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