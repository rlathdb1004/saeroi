package kr.or.saeroi.dto;

import java.sql.Date;

// 입출고 한 줄 데이터를 담는 DTO
public class InoutDTO {

	private int inoutId;          // 입출고 ID
	private String inoutType;     // 입출고 구분
	private String materialLot;   // LOT 번호
	private int inoutQty;         // 입출고량
	private Date inoutDate;       // 입출고 일자
	private String status;        // 상태
	private int itemId;           // 품목 ID

	private String itemCode;      // 품목코드
	private String itemName;      // 품목명
	private String itemType;      // 품목유형
	private String itemUnit;      // 단위

	private String docNo;         // 입출고번호
	private int docSeq;           // 입출고 순번

	public int getInoutId() { return inoutId; }
	public void setInoutId(int inoutId) { this.inoutId = inoutId; }

	public String getInoutType() { return inoutType; }
	public void setInoutType(String inoutType) { this.inoutType = inoutType; }

	public String getMaterialLot() { return materialLot; }
	public void setMaterialLot(String materialLot) { this.materialLot = materialLot; }

	public int getInoutQty() { return inoutQty; }
	public void setInoutQty(int inoutQty) { this.inoutQty = inoutQty; }

	public Date getInoutDate() { return inoutDate; }
	public void setInoutDate(Date inoutDate) { this.inoutDate = inoutDate; }

	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public int getItemId() { return itemId; }
	public void setItemId(int itemId) { this.itemId = itemId; }

	public String getItemCode() { return itemCode; }
	public void setItemCode(String itemCode) { this.itemCode = itemCode; }

	public String getItemName() { return itemName; }
	public void setItemName(String itemName) { this.itemName = itemName; }

	public String getItemType() { return itemType; }
	public void setItemType(String itemType) { this.itemType = itemType; }

	public String getItemUnit() { return itemUnit; }
	public void setItemUnit(String itemUnit) { this.itemUnit = itemUnit; }

	public String getDocNo() { return docNo; }
	public void setDocNo(String docNo) { this.docNo = docNo; }

	public int getDocSeq() { return docSeq; }
	public void setDocSeq(int docSeq) { this.docSeq = docSeq; }
}