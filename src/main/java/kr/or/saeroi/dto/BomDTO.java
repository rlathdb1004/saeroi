package kr.or.saeroi.dto;

import java.sql.Date;
import java.util.List;

/**
 * BOM관리 DTO
 * - 기준정보관리 > BOM관리에서 사용
 * - bom 테이블 기본 컬럼 + 완제품 표시용 조인 컬럼 + 검색조건 포함
 */
public class BomDTO {

    // =========================================================
    // bom 테이블 기본 컬럼
    // =========================================================

    private Integer bomId;         // BOM ID
    private String bomCode;        // BOM 코드
    private Integer version;       // 버전

    // 사용여부: Y(사용), N(미사용)
    private String useYn;

    private String remark;         // 비고
    private Date createdDate;      // 등록일
    private Date updatedDate;      // 수정일

    // 완제품 품목 ID
    private Integer itemId;


    // =========================================================
    // 화면 표시용 컬럼
    // =========================================================

    private String itemCode;       // 완제품 코드
    private String itemName;       // 완제품명
    private String itemType;       // 품목구분 코드
    private String itemTypeName;   // 품목구분 표시명
    private String itemUnit;       // 단위

    private String useYnName;      // 사용여부 표시명

    private Integer detailCount;   // BOM 상세 품목 수


    // =========================================================
    // 상세 화면 표시용
    // =========================================================

    private List<BomDetailDTO> bomDetailList;


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: bomCode, itemCode, itemName, useYn
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public BomDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

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

    public List<BomDetailDTO> getBomDetailList() {
        return bomDetailList;
    }

    public void setBomDetailList(List<BomDetailDTO> bomDetailList) {
        this.bomDetailList = bomDetailList;
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
        return "BomDTO [bomId=" + bomId
                + ", bomCode=" + bomCode
                + ", version=" + version
                + ", useYn=" + useYn
                + ", remark=" + remark
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", itemId=" + itemId
                + ", itemCode=" + itemCode
                + ", itemName=" + itemName
                + ", itemType=" + itemType
                + ", itemTypeName=" + itemTypeName
                + ", itemUnit=" + itemUnit
                + ", useYnName=" + useYnName
                + ", detailCount=" + detailCount
                + ", bomDetailList=" + bomDetailList
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + "]";
    }
}