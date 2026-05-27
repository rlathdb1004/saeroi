package kr.or.saeroi.dto;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 기준관리 > 설비관리 DTO
 *
 * 기준
 * - 사이드바 설비관리 업무 메뉴와 충돌 방지를 위해 MasterEquipment 명칭 사용
 * - equipment 테이블 기본 컬럼 + 라인/거래처 표시용 조인 컬럼 + 검색조건 포함
 * - 설비구분은 고정값이 아니므로 equip_code의 prefix로 관리
 * - 신규 설비구분은 별도 DB 컬럼 추가 없이 equipCodePrefix 화면값으로 처리
 * - 품목관리/BOM관리 기준에 맞춰 Lombok 사용하지 않고 getter/setter 명시
 */
public class MasterEquipmentDTO {

    // =========================================================
    // equipment 테이블 기본 컬럼
    // =========================================================

    private Integer equipId;        // 설비 ID
    private Integer lineId;         // 라인 ID
    private Integer clientId;       // 제조사/거래처 ID

    private String equipCode;       // 설비코드
    private String equipName;       // 설비명
    private String equipStatus;     // 설비상태
    private String equipLoc;        // 설치위치

    private Integer equipPrice;     // 설비금액

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date buyDate;           // 구매일

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createdDate;       // 등록일

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date updatedDate;       // 수정일

    private String useYn;           // 사용여부
    private String remark;          // 비고


    // =========================================================
    // 설비코드 / 설비구분 화면 처리용
    // =========================================================

    /*
     * 설비구분 prefix
     *
     * 예:
     * - EQ-CUT
     * - EQ-LAM
     * - EQ-PRS
     * - EQ-VIS
     * - EQ-DRY
     * - EQ-WASH
     *
     * 주의:
     * - DB에 별도 컬럼으로 저장하지 않는다.
     * - equip_code에서 마지막 "-001" 같은 순번 부분을 제외한 prefix로 관리한다.
     * - 신규 설비구분을 등록할 때도 이 값으로 자동생성한다.
     */
    private String equipCodePrefix;


    // =========================================================
    // 화면 표시용 JOIN 컬럼
    // =========================================================

    private String lineCode;        // 라인코드
    private String lineName;        // 라인명
    private String lineStatus;      // 라인상태

    private String clientCode;      // 거래처코드
    private String clientName;      // 제조사/거래처명
    private String clientType;      // 거래처구분


    // =========================================================
    // 화면 표시용 변환 컬럼
    // =========================================================

    private String equipStatusName; // 설비상태 표시명
    private String useYnName;       // 사용여부 표시명


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: equipCode, equipName, equipCodePrefix, lineName, clientName, equipStatus, useYn
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public MasterEquipmentDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

    public Integer getEquipId() {
        return equipId;
    }

    public void setEquipId(Integer equipId) {
        this.equipId = equipId;
    }

    public Integer getLineId() {
        return lineId;
    }

    public void setLineId(Integer lineId) {
        this.lineId = lineId;
    }

    public Integer getClientId() {
        return clientId;
    }

    public void setClientId(Integer clientId) {
        this.clientId = clientId;
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

    public Integer getEquipPrice() {
        return equipPrice;
    }

    public void setEquipPrice(Integer equipPrice) {
        this.equipPrice = equipPrice;
    }

    public Date getBuyDate() {
        return buyDate;
    }

    public void setBuyDate(Date buyDate) {
        this.buyDate = buyDate;
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

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getEquipCodePrefix() {
        return equipCodePrefix;
    }

    public void setEquipCodePrefix(String equipCodePrefix) {
        this.equipCodePrefix = equipCodePrefix;
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

    public String getClientCode() {
        return clientCode;
    }

    public void setClientCode(String clientCode) {
        this.clientCode = clientCode;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getClientType() {
        return clientType;
    }

    public void setClientType(String clientType) {
        this.clientType = clientType;
    }

    public String getEquipStatusName() {
        return equipStatusName;
    }

    public void setEquipStatusName(String equipStatusName) {
        this.equipStatusName = equipStatusName;
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
        return "MasterEquipmentDTO [equipId=" + equipId
                + ", lineId=" + lineId
                + ", clientId=" + clientId
                + ", equipCode=" + equipCode
                + ", equipName=" + equipName
                + ", equipStatus=" + equipStatus
                + ", equipLoc=" + equipLoc
                + ", equipPrice=" + equipPrice
                + ", buyDate=" + buyDate
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", useYn=" + useYn
                + ", remark=" + remark
                + ", equipCodePrefix=" + equipCodePrefix
                + ", lineCode=" + lineCode
                + ", lineName=" + lineName
                + ", lineStatus=" + lineStatus
                + ", clientCode=" + clientCode
                + ", clientName=" + clientName
                + ", clientType=" + clientType
                + ", equipStatusName=" + equipStatusName
                + ", useYnName=" + useYnName
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + "]";
    }
}