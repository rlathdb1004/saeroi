package kr.or.saeroi.dto;

import java.sql.Date;

/**
 * 품목관리 DTO
 * - 기준정보관리 > 품목관리에서 사용
 * - item 테이블 기본 컬럼 + 화면 표시용 조인 컬럼 + 검색조건 포함
 */
public class ItemDTO {

    // =========================================================
    // item 테이블 기본 컬럼
    // =========================================================

    private Integer itemId;        // 품목 ID
    private Integer supplierId;    // 공급처 ID
    private Integer clientId;      // 납품처 ID

    private String itemCode;       // 품목코드
    private String itemName;       // 품목명

    // 품목구분 코드: FG(완제품), RM(원자재), SM(부자재)
    private String itemType;

    private Integer safetyStock;   // 안전재고
    private String itemUnit;       // 단위
    private String remark;         // 비고

    private Date createdDate;      // 등록일
    private Date updatedDate;      // 수정일

    // 사용여부: Y(사용), N(미사용)
    private String useYn;


    // =========================================================
    // 화면 표시용 컬럼
    // =========================================================

    private String supplierName;        // 공급처명
    private String deliveryClientName;  // 납품처명

    private String itemTypeName;        // 품목구분 표시명
    private String useYnName;           // 사용여부 표시명


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: itemCode, itemName, itemType, supplierName, deliveryClientName
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public ItemDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public Integer getClientId() {
        return clientId;
    }

    public void setClientId(Integer clientId) {
        this.clientId = clientId;
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

    public Integer getSafetyStock() {
        return safetyStock;
    }

    public void setSafetyStock(Integer safetyStock) {
        this.safetyStock = safetyStock;
    }

    public String getItemUnit() {
        return itemUnit;
    }

    public void setItemUnit(String itemUnit) {
        this.itemUnit = itemUnit;
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

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getDeliveryClientName() {
        return deliveryClientName;
    }

    public void setDeliveryClientName(String deliveryClientName) {
        this.deliveryClientName = deliveryClientName;
    }

    public String getItemTypeName() {
        return itemTypeName;
    }

    public void setItemTypeName(String itemTypeName) {
        this.itemTypeName = itemTypeName;
    }

    public String getUseYnName() {
        return useYnName;
    }

    public void setUseYnName(String useYnName) {
        this.useYnName = useYnName;
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


    // =========================================================
    // toString
    // =========================================================

    @Override
    public String toString() {
        return "ItemDTO [itemId=" + itemId
                + ", supplierId=" + supplierId
                + ", clientId=" + clientId
                + ", itemCode=" + itemCode
                + ", itemName=" + itemName
                + ", itemType=" + itemType
                + ", safetyStock=" + safetyStock
                + ", itemUnit=" + itemUnit
                + ", remark=" + remark
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", useYn=" + useYn
                + ", supplierName=" + supplierName
                + ", deliveryClientName=" + deliveryClientName
                + ", itemTypeName=" + itemTypeName
                + ", useYnName=" + useYnName
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + "]";
    }
}