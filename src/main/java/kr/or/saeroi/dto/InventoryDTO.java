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

	@Override
	public String toString() {
		return "InventoryDTO [inventoryId=" + inventoryId + ", inventoryStock=" + inventoryStock + ", remark=" + remark
				+ ", stockLocation=" + stockLocation + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate
				+ ", itemId=" + itemId + ", itemCode=" + itemCode + ", itemName=" + itemName + ", itemType=" + itemType
				+ ", itemUnit=" + itemUnit + "]";
	}
	
	
}