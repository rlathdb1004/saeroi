package kr.or.saeroi.dto;

import lombok.Data;

// 생산관리에서 사용하는 데이터 전달 객체이다.
// Lombok @Data를 사용하면 getter, setter, toString 등을 자동으로 만들어준다.
@Data
public class ProductionDTO {

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

	// production_plan 테이블의 비고이다.
	private String remark;

	// production_plan 테이블의 품목 ID이다.
	private Integer itemId;

	// production_plan 테이블의 납기일이다.
	private String dueDate;

	// production_plan 테이블의 생산계획 문서번호이다.
	private String docNo;

	// production_plan 테이블의 문서 순번이다.
	private Integer docSeq;

	// item 테이블의 품목 코드이다.
	private String itemCode;

	// item 테이블의 품목명이다.
	private String itemName;

	// item 테이블의 품목 구분이다.
	private String itemType;

	// item 테이블의 품목 단위이다.
	private String itemUnit;

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
}