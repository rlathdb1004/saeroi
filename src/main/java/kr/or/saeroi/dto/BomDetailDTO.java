package kr.or.saeroi.dto;

import java.util.Date;

/**
 * BOM 상세 DTO
 *
 * 역할:
 * - bom_detail 테이블의 기본 컬럼을 담는다.
 * - BOM 상세 화면에서 원자재/부자재 품목 조인 표시값을 함께 담는다.
 *
 * 기준 테이블:
 * - bom_detail
 *
 * 주요 조인:
 * - bom_detail.item_id = item.item_id
 */
public class BomDetailDTO {

	// =========================================================
	// 1. bom_detail 테이블 기본 컬럼
	// =========================================================

	private Integer bomDetailId;
	private Integer bomId;
	private Double qty;
	private Date createdDate;
	private Date updatedDate;
	private String remark;
	private Integer itemId;

	// =========================================================
	// 2. 원자재/부자재 item 조인 표시 컬럼
	// =========================================================

	private String itemCode;
	private String itemName;
	private String itemType;
	private String itemTypeName;
	private String itemUnit;

	// =========================================================
	// 3. BOM 마스터 조인 표시 컬럼
	// =========================================================

	private String bomCode;
	private Integer version;
	private String useYn;

	public Integer getBomDetailId() {
		return bomDetailId;
	}

	public void setBomDetailId(Integer bomDetailId) {
		this.bomDetailId = bomDetailId;
	}

	public Integer getBomId() {
		return bomId;
	}

	public void setBomId(Integer bomId) {
		this.bomId = bomId;
	}

	public Double getQty() {
		return qty;
	}

	public void setQty(Double qty) {
		this.qty = qty;
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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Integer getItemId() {
		return itemId;
	}

	public void setItemId(Integer itemId) {
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

	public String getItemTypeName() {
		return itemTypeName;
	}

	public void setItemTypeName(String itemTypeName) {
		this.itemTypeName = itemTypeName;
	}

	public String getItemUnit() {
		return itemUnit;
	}

	public void setItemUnit(String itemUnit) {
		this.itemUnit = itemUnit;
	}

	public String getBomCode() {
		return bomCode;
	}

	public void setBomCode(String bomCode) {
		this.bomCode = bomCode;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	@Override
	public String toString() {
		return "BomDetailDTO [bomDetailId=" + bomDetailId + ", bomId=" + bomId + ", qty=" + qty + ", createdDate="
				+ createdDate + ", updatedDate=" + updatedDate + ", remark=" + remark + ", itemId=" + itemId
				+ ", itemCode=" + itemCode + ", itemName=" + itemName + ", itemType=" + itemType
				+ ", itemTypeName=" + itemTypeName + ", itemUnit=" + itemUnit + ", bomCode=" + bomCode
				+ ", version=" + version + ", useYn=" + useYn + "]";
	}
}