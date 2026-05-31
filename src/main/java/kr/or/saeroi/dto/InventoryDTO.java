package kr.or.saeroi.dto;

import java.sql.Date;

// 재고 DTO
public class InventoryDTO {

	private int inventoryId;
	private int inventoryStock;
	private String remark;
	private String stockLocation;
	private Date createdDate;
	private Date updatedDate;
	private int itemId;

	private String itemCode;
	private String itemName;
	private String itemType;
	private String itemUnit;

	// =========================================================================
	// 재고조회 목록 / 상세페이지 입출고 내역 표시용
	// INVENTORY 테이블 컬럼은 아니고 MATERIAL_INOUT 집계 / 내역 조회용 값이다.
	// =========================================================================
	private int inQty;             // 입고량 합계
	private int useQty;            // 사용량 합계, 작업지시 투입 출고 기준
	private int outQty;            // 일반 출고량 합계

	// =========================================================================
	// 재고 상세페이지 하단 입출고 내역 리스트 출력용
	// 특정 재고번호를 따라갔을 때 해당 품목의 입출고 흐름을 보여주기 위한 값이다.
	// =========================================================================
	private int inoutId;           // 입출고 ID
	private String inoutType;      // 입출고 구분
	private String materialLot;    // LOT 번호
	private int inoutQty;          // 입출고 수량
	private Date inoutDate;        // 입출고 일자
	private String docNo;          // 입출고 번호
	private String status;         // 상태
	private String useYn;          // 사용여부
	private String historyRemark;  // 입출고 내역 비고
	private Date historyCreatedDate; // 입출고 내역 등록일
	private Date historyUpdatedDate; // 입출고 내역 수정일

	public int getInventoryId() {
		return inventoryId;
	}

	public void setInventoryId(int inventoryId) {
		this.inventoryId = inventoryId;
	}

	public int getInventoryStock() {
		return inventoryStock;
	}

	public void setInventoryStock(int inventoryStock) {
		this.inventoryStock = inventoryStock;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getStockLocation() {
		return stockLocation;
	}

	public void setStockLocation(String stockLocation) {
		this.stockLocation = stockLocation;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public Date getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(Date updatedDate) {
		this.updatedDate = updatedDate;
	}

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemType() {
		return itemType;
	}

	public void setItemType(String itemType) {
		this.itemType = itemType;
	}

	public String getItemUnit() {
		return itemUnit;
	}

	public void setItemUnit(String itemUnit) {
		this.itemUnit = itemUnit;
	}


	public int getInQty() {
		return inQty;
	}

	public void setInQty(int inQty) {
		this.inQty = inQty;
	}

	public int getUseQty() {
		return useQty;
	}

	public void setUseQty(int useQty) {
		this.useQty = useQty;
	}

	public int getOutQty() {
		return outQty;
	}

	public void setOutQty(int outQty) {
		this.outQty = outQty;
	}

	public int getInoutId() {
		return inoutId;
	}

	public void setInoutId(int inoutId) {
		this.inoutId = inoutId;
	}

	public String getInoutType() {
		return inoutType;
	}

	public void setInoutType(String inoutType) {
		this.inoutType = inoutType;
	}

	public String getMaterialLot() {
		return materialLot;
	}

	public void setMaterialLot(String materialLot) {
		this.materialLot = materialLot;
	}

	public int getInoutQty() {
		return inoutQty;
	}

	public void setInoutQty(int inoutQty) {
		this.inoutQty = inoutQty;
	}

	public Date getInoutDate() {
		return inoutDate;
	}

	public void setInoutDate(Date inoutDate) {
		this.inoutDate = inoutDate;
	}

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}


	// =========================================================================
	// 재고 상세페이지 입출고 내역 비고
	// =========================================================================
	public String getHistoryRemark() {
		return historyRemark;
	}

	public void setHistoryRemark(String historyRemark) {
		this.historyRemark = historyRemark;
	}

	// =========================================================================
	// 재고 상세페이지 입출고 내역 등록일
	// =========================================================================
	public Date getHistoryCreatedDate() {
		return historyCreatedDate;
	}

	public void setHistoryCreatedDate(Date historyCreatedDate) {
		this.historyCreatedDate = historyCreatedDate;
	}

	// =========================================================================
	// 재고 상세페이지 입출고 내역 수정일
	// =========================================================================
	public Date getHistoryUpdatedDate() {
		return historyUpdatedDate;
	}

	public void setHistoryUpdatedDate(Date historyUpdatedDate) {
		this.historyUpdatedDate = historyUpdatedDate;
	}

	@Override
	public String toString() {
		return "InventoryDTO [inventoryId=" + inventoryId + ", inventoryStock=" + inventoryStock + ", remark=" + remark
				+ ", stockLocation=" + stockLocation + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate
				+ ", itemId=" + itemId + ", itemCode=" + itemCode + ", itemName=" + itemName + ", itemType=" + itemType
				+ ", itemUnit=" + itemUnit + "]";
	}
	
	
}