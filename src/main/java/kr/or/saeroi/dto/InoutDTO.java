package kr.or.saeroi.dto;

import java.sql.Date;

// =============================================================
// 자재 입출고 DTO
// MATERIAL_INOUT + ITEM + CLIENT + INVENTORY 테이블 조회 데이터 저장
// 거래처 정보는 거래처명 / 담당자만 사용
// 창고 정보는 창고위치 / 현재재고만 사용
// =============================================================
public class InoutDTO {

	// =============================================================
	// MATERIAL_INOUT 테이블 컬럼
	// =============================================================
	private int inoutId;          // 입출고 ID
	private int empId;            // 사원 ID
	private String inoutType;     // 입출고 구분
	private String materialLot;   // 자재 LOT 번호
	private int inoutQty;         // 입출고 수량
	private Date inoutDate;       // 입출고 일자
	private String remark;        // 비고
	private Date createdDate;     // 생성일시
	private Date updatedDate;     // 수정일시
	private String useYn;         // 사용 여부
	private String status;        // 상태
	private int orderId;          // 작업지시 ID
	private int itemId;           // 품목 ID
	private String docNo;         // 입출고 문서번호
	private int docSeq;           // 문서 순번

	// =============================================================
	// ITEM 테이블 JOIN 조회용 컬럼
	// =============================================================
	private String itemCode;      // 품목코드
	private String itemName;      // 품목명
	private String itemType;      // 품목유형
	private String itemUnit;      // 단위

	// =============================================================
	// CLIENT 테이블 JOIN 조회용 컬럼
	// CLIENT.CLIENT_NAME = 거래처명
	// CLIENT.CLIENT_MAN  = 담당자
	// =============================================================
	private String clientName;       // 거래처명
	private String clientManager;    // 담당자

	// =============================================================
	// INVENTORY 테이블 JOIN 조회용 컬럼
	// INVENTORY.STOCK_LOCATION   = 창고위치
	// INVENTORY.INVENTORY_STOCK  = 현재재고
	// =============================================================
	private String stockLocation;    // 창고위치
	private int inventoryStock;      // 현재재고

	// =============================================================
	// 입출고 ID
	// =============================================================
	public int getInoutId() {
		return inoutId;
	}

	public void setInoutId(int inoutId) {
		this.inoutId = inoutId;
	}

	// =============================================================
	// 사원 ID
	// =============================================================
	public int getEmpId() {
		return empId;
	}

	public void setEmpId(int empId) {
		this.empId = empId;
	}

	// =============================================================
	// 입출고 구분
	// =============================================================
	public String getInoutType() {
		return inoutType;
	}

	public void setInoutType(String inoutType) {
		this.inoutType = inoutType;
	}

	// =============================================================
	// 자재 LOT 번호
	// =============================================================
	public String getMaterialLot() {
		return materialLot;
	}

	public void setMaterialLot(String materialLot) {
		this.materialLot = materialLot;
	}

	// =============================================================
	// 입출고 수량
	// =============================================================
	public int getInoutQty() {
		return inoutQty;
	}

	public void setInoutQty(int inoutQty) {
		this.inoutQty = inoutQty;
	}

	// =============================================================
	// 입출고 일자
	// =============================================================
	public Date getInoutDate() {
		return inoutDate;
	}

	public void setInoutDate(Date inoutDate) {
		this.inoutDate = inoutDate;
	}

	// =============================================================
	// 비고
	// =============================================================
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	// =============================================================
	// 생성일시
	// =============================================================
	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	// =============================================================
	// 수정일시
	// =============================================================
	public Date getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(Date updatedDate) {
		this.updatedDate = updatedDate;
	}

	// =============================================================
	// 사용 여부
	// =============================================================
	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	// =============================================================
	// 상태
	// =============================================================
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	// =============================================================
	// 작업지시 ID
	// =============================================================
	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	// =============================================================
	// 품목 ID
	// =============================================================
	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	// =============================================================
	// 입출고 문서번호
	// =============================================================
	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	// =============================================================
	// 문서 순번
	// =============================================================
	public int getDocSeq() {
		return docSeq;
	}

	public void setDocSeq(int docSeq) {
		this.docSeq = docSeq;
	}

	// =============================================================
	// 품목코드
	// =============================================================
	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	// =============================================================
	// 품목명
	// =============================================================
	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	// =============================================================
	// 품목유형
	// =============================================================
	public String getItemType() {
		return itemType;
	}

	public void setItemType(String itemType) {
		this.itemType = itemType;
	}

	// =============================================================
	// 단위
	// =============================================================
	public String getItemUnit() {
		return itemUnit;
	}

	public void setItemUnit(String itemUnit) {
		this.itemUnit = itemUnit;
	}

	// =============================================================
	// 거래처명
	// =============================================================
	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	// =============================================================
	// 담당자
	// DB 컬럼명은 CLIENT_MAN
	// DTO에서는 화면에서 쓰기 편하게 clientManager 이름 사용
	// =============================================================
	public String getClientManager() {
		return clientManager;
	}

	public void setClientManager(String clientManager) {
		this.clientManager = clientManager;
	}

	// =============================================================
	// 창고위치
	// =============================================================
	public String getStockLocation() {
		return stockLocation;
	}

	public void setStockLocation(String stockLocation) {
		this.stockLocation = stockLocation;
	}

	// =============================================================
	// 현재재고
	// =============================================================
	public int getInventoryStock() {
		return inventoryStock;
	}

	public void setInventoryStock(int inventoryStock) {
		this.inventoryStock = inventoryStock;
	}
}
