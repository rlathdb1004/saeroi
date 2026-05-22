package kr.or.saeroi.dto;

import java.sql.Date;

/**
 * BOM 상세 DTO
 * - 기준정보관리 > BOM관리 > BOM 상세에서 사용
 * - bom_detail 테이블 기본 컬럼 + 자재/완제품 표시용 조인 컬럼 + 검색조건 포함
 */
public class BomDetailDTO {

    // =========================================================
    // bom_detail 테이블 기본 컬럼
    // =========================================================

    private Integer bomDetailId;   // BOM 상세 ID
    private Integer bomId;         // BOM ID

    private Double qty;            // 소요량

    private Date createdDate;      // 등록일
    private Date updatedDate;      // 수정일

    private String remark;         // 비고

    // 투입 품목 ID
    private Integer itemId;


    // =========================================================
    // 자재/부자재 품목 표시용 컬럼
    // =========================================================

    private String itemCode;       // 투입 품목 코드
    private String itemName;       // 투입 품목명
    private String itemType;       // 투입 품목구분 코드
    private String itemTypeName;   // 투입 품목구분 표시명
    private String itemUnit;       // 투입 품목 단위


    // =========================================================
    // BOM 마스터 표시용 컬럼
    // =========================================================

    private String bomCode;        // BOM 코드
    private Integer version;       // BOM 버전

    private String useYn;          // BOM 사용여부
    private String useYnName;      // BOM 사용여부 표시명


    // =========================================================
    // 완제품 표시용 컬럼
    // =========================================================

    private Integer productItemId;     // 완제품 품목 ID
    private String productItemCode;    // 완제품 코드
    private String productItemName;    // 완제품명
    private String productItemType;    // 완제품 품목구분 코드
    private String productItemTypeName;// 완제품 품목구분 표시명
    private String productItemUnit;    // 완제품 단위


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: bomCode, productItemCode, productItemName, itemCode, itemName
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public BomDetailDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

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

    public String getUseYnName() {
        return useYnName;
    }

    public void setUseYnName(String useYnName) {
        this.useYnName = useYnName;
    }

    public Integer getProductItemId() {
        return productItemId;
    }

    public void setProductItemId(Integer productItemId) {
        this.productItemId = productItemId;
    }

    public String getProductItemCode() {
        return productItemCode;
    }

    public void setProductItemCode(String productItemCode) {
        this.productItemCode = productItemCode;
    }

    public String getProductItemName() {
        return productItemName;
    }

    public void setProductItemName(String productItemName) {
        this.productItemName = productItemName;
    }

    public String getProductItemType() {
        return productItemType;
    }

    public void setProductItemType(String productItemType) {
        this.productItemType = productItemType;
    }

    public String getProductItemTypeName() {
        return productItemTypeName;
    }

    public void setProductItemTypeName(String productItemTypeName) {
        this.productItemTypeName = productItemTypeName;
    }

    public String getProductItemUnit() {
        return productItemUnit;
    }

    public void setProductItemUnit(String productItemUnit) {
        this.productItemUnit = productItemUnit;
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
        return "BomDetailDTO [bomDetailId=" + bomDetailId
                + ", bomId=" + bomId
                + ", qty=" + qty
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", remark=" + remark
                + ", itemId=" + itemId
                + ", itemCode=" + itemCode
                + ", itemName=" + itemName
                + ", itemType=" + itemType
                + ", itemTypeName=" + itemTypeName
                + ", itemUnit=" + itemUnit
                + ", bomCode=" + bomCode
                + ", version=" + version
                + ", useYn=" + useYn
                + ", useYnName=" + useYnName
                + ", productItemId=" + productItemId
                + ", productItemCode=" + productItemCode
                + ", productItemName=" + productItemName
                + ", productItemType=" + productItemType
                + ", productItemTypeName=" + productItemTypeName
                + ", productItemUnit=" + productItemUnit
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + "]";
    }
}