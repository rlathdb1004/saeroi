package kr.or.saeroi.dto;

import java.sql.Date;

/**
 * 공정관리 DTO
 * - 기준정보관리 > 공정관리에서 사용
 * - process 테이블 기본 컬럼 + 품목/설비/라인 표시용 조인 컬럼 + 검색조건 포함
 */
public class ProcessDTO {

    // =========================================================
    // process 테이블 기본 컬럼
    // =========================================================

    private Integer procId;        // 공정 ID

    private Integer itemId;        // 품목 ID
    private Integer equipId;       // 설비 ID

    private String procCode;       // 공정코드
    private String procName;       // 공정명
    private String procContent;    // 공정내용

    private Date createdDate;      // 등록일
    private Date updatedDate;      // 수정일

    private String remark;         // 비고


    // =========================================================
    // 품목 표시용 컬럼
    // =========================================================

    private String itemCode;       // 품목코드
    private String itemName;       // 품목명
    private String itemType;       // 품목구분 코드
    private String itemTypeName;   // 품목구분 표시명
    private String itemUnit;       // 품목 단위


    // =========================================================
    // 설비 표시용 컬럼
    // =========================================================

    private String equipCode;      // 설비코드
    private String equipName;      // 설비명
    private String equipStatus;    // 설비상태
    private String equipLoc;       // 설비위치


    // =========================================================
    // 라인 표시용 컬럼
    // =========================================================

    private Integer lineId;        // 라인 ID
    private String lineCode;       // 라인코드
    private String lineName;       // 라인명
    private String lineStatus;     // 라인상태


    // =========================================================
    // 화면 표시용 컬럼
    // =========================================================

    private String equipDisplayName;   // 설비 표시명
    private String lineDisplayName;    // 라인 표시명


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: procCode, procName, itemCode, itemName, equipCode, equipName, lineName
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public ProcessDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

    public Integer getProcId() {
        return procId;
    }

    public void setProcId(Integer procId) {
        this.procId = procId;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public Integer getEquipId() {
        return equipId;
    }

    public void setEquipId(Integer equipId) {
        this.equipId = equipId;
    }

    public String getProcCode() {
        return procCode;
    }

    public void setProcCode(String procCode) {
        this.procCode = procCode;
    }

    public String getProcName() {
        return procName;
    }

    public void setProcName(String procName) {
        this.procName = procName;
    }

    public String getProcContent() {
        return procContent;
    }

    public void setProcContent(String procContent) {
        this.procContent = procContent;
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

    public String getEquipCode() {
        return equipCode;
    }

    public void setEquipCode(String equipCode) {
        this.equipCode = equipCode;
    }

    public String getEquipName() {
        return equipName;
    }

    public void setEquipName(String equipName) {
        this.equipName = equipName;
    }

    public String getEquipStatus() {
        return equipStatus;
    }

    public void setEquipStatus(String equipStatus) {
        this.equipStatus = equipStatus;
    }

    public String getEquipLoc() {
        return equipLoc;
    }

    public void setEquipLoc(String equipLoc) {
        this.equipLoc = equipLoc;
    }

    public Integer getLineId() {
        return lineId;
    }

    public void setLineId(Integer lineId) {
        this.lineId = lineId;
    }

    public String getLineCode() {
        return lineCode;
    }

    public void setLineCode(String lineCode) {
        this.lineCode = lineCode;
    }

    public String getLineName() {
        return lineName;
    }

    public void setLineName(String lineName) {
        this.lineName = lineName;
    }

    public String getLineStatus() {
        return lineStatus;
    }

    public void setLineStatus(String lineStatus) {
        this.lineStatus = lineStatus;
    }

    public String getEquipDisplayName() {
        return equipDisplayName;
    }

    public void setEquipDisplayName(String equipDisplayName) {
        this.equipDisplayName = equipDisplayName;
    }

    public String getLineDisplayName() {
        return lineDisplayName;
    }

    public void setLineDisplayName(String lineDisplayName) {
        this.lineDisplayName = lineDisplayName;
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
        return "ProcessDTO [procId=" + procId
                + ", itemId=" + itemId
                + ", equipId=" + equipId
                + ", procCode=" + procCode
                + ", procName=" + procName
                + ", procContent=" + procContent
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", remark=" + remark
                + ", itemCode=" + itemCode
                + ", itemName=" + itemName
                + ", itemType=" + itemType
                + ", itemTypeName=" + itemTypeName
                + ", itemUnit=" + itemUnit
                + ", equipCode=" + equipCode
                + ", equipName=" + equipName
                + ", equipStatus=" + equipStatus
                + ", equipLoc=" + equipLoc
                + ", lineId=" + lineId
                + ", lineCode=" + lineCode
                + ", lineName=" + lineName
                + ", lineStatus=" + lineStatus
                + ", equipDisplayName=" + equipDisplayName
                + ", lineDisplayName=" + lineDisplayName
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + "]";
    }
}