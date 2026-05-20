package kr.or.saeroi.dto;

import java.util.Date;
import java.util.List;

/**
 * BOM 관리 DTO
 *
 * 역할:
 * - bom 테이블의 기본 컬럼을 담는다.
 * - BOM 목록/상세 화면에서 사용할 완제품 품목 조인 표시값을 함께 담는다.
 * - 상세 화면에서 BOM 상세 목록(bom_detail)을 함께 담을 수 있다.
 *
 * 기준 테이블:
 * - bom
 *
 * 주요 조인:
 * - bom.item_id = item.item_id
 */
public class BomDTO {

	// =========================================================
	// 1. bom 테이블 기본 컬럼
	// =========================================================

	private Integer bomId;
	private String bomCode;
	private Integer version;
	private String useYn;
	private String remark;
	private Date createdDate;
	private Date updatedDate;
	private Integer itemId;

	// =========================================================
	// 2. 완제품 item 조인 표시 컬럼
	// =========================================================

	private String itemCode;
	private String itemName;
	private String itemType;
	private String itemTypeName;
	private String itemUnit;

	// =========================================================
	// 3. 화면 표시/집계용 컬럼
	// =========================================================

	private String useYnName;
	private Integer detailCount;
	private Double totalQty;

	// =========================================================
	// 4. 검색조건
	// =========================================================

	private String searchType;
	private String searchKeyword;

	// =========================================================
	// 5. 상세 목록
	// =========================================================

	private List<BomDetailDTO> bomDetailList;

	public Integer getBomId() {
		return bomId;
	}

	public void setBomId(Integer bomId) {
		this.bomId = bomId;
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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	public String getUseYnName() {
		return useYnName;
	}

	public void setUseYnName(String useYnName) {
		this.useYnName = useYnName;
	}

	public Integer getDetailCount() {
		return detailCount;
	}

	public void setDetailCount(Integer detailCount) {
		this.detailCount = detailCount;
	}

	public Double getTotalQty() {
		return totalQty;
	}

	public void setTotalQty(Double totalQty) {
		this.totalQty = totalQty;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

	public List<BomDetailDTO> getBomDetailList() {
		return bomDetailList;
	}

	public void setBomDetailList(List<BomDetailDTO> bomDetailList) {
		this.bomDetailList = bomDetailList;
	}

	@Override
	public String toString() {
		return "BomDTO [bomId=" + bomId + ", bomCode=" + bomCode + ", version=" + version + ", useYn=" + useYn
				+ ", remark=" + remark + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate
				+ ", itemId=" + itemId + ", itemCode=" + itemCode + ", itemName=" + itemName + ", itemType="
				+ itemType + ", itemTypeName=" + itemTypeName + ", itemUnit=" + itemUnit + ", useYnName="
				+ useYnName + ", detailCount=" + detailCount + ", totalQty=" + totalQty + ", searchType="
				+ searchType + ", searchKeyword=" + searchKeyword + "]";
	}
}