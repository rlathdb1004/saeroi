package kr.or.saeroi.dto;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 기준관리 > 불량코드관리 DTO
 *
 * 기준:
 * - defect 테이블 기준정보 전용 DTO
 * - 기존 DefectDTO는 품질관리/불량이력용으로 유지
 * - 불량코드 기준관리 페이지는 MasterDefectCodeDTO 사용
 * - defect 테이블 기본 컬럼 + 화면 표시용 컬럼 + 검색조건 포함
 * - 품목관리 기준에 맞춰 Lombok 사용하지 않고 getter/setter 명시
 */
public class MasterDefectCodeDTO {

    // =========================================================
    // defect 테이블 기본 컬럼
    // =========================================================

    private Integer defectId;       // 불량코드 ID

    private String defectCode;      // 불량코드
    private String defectType;      // 불량유형
    private String defectName;      // 불량명

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createdDate;       // 등록일

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date updatedDate;       // 수정일

    private String remark;          // 비고

    // 사용여부: Y(사용), N(미사용)
    private String useYn;


    // =========================================================
    // 불량코드 자동생성 / 구분 처리용
    // =========================================================

    /*
     * 불량코드 prefix
     *
     * 예:
     * - DCD-DIM
     * - DCD-CUT
     * - DCD-ADH
     * - DCD-CONT
     * - DCD-CRK
     * - DEF-BAR
     *
     * 주의:
     * - DB에 별도 컬럼으로 저장하지 않는다.
     * - defect_code에서 마지막 "-001" 같은 순번 부분을 제외한 prefix로 관리한다.
     */
    private String defectCodePrefix;


    // =========================================================
    // 화면 표시용 변환 컬럼
    // =========================================================

    private String useYnName;       // 사용여부 표시명


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: defectCode, defectType, defectName, useYn
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public MasterDefectCodeDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

    public Integer getDefectId() {
        return defectId;
    }

    public void setDefectId(Integer defectId) {
        this.defectId = defectId;
    }

    public String getDefectCode() {
        return defectCode;
    }

    public void setDefectCode(String defectCode) {
        this.defectCode = defectCode;
    }

    public String getDefectType() {
        return defectType;
    }

    public void setDefectType(String defectType) {
        this.defectType = defectType;
    }

    public String getDefectName() {
        return defectName;
    }

    public void setDefectName(String defectName) {
        this.defectName = defectName;
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

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getDefectCodePrefix() {
        return defectCodePrefix;
    }

    public void setDefectCodePrefix(String defectCodePrefix) {
        this.defectCodePrefix = defectCodePrefix;
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
        return "MasterDefectCodeDTO [defectId=" + defectId
                + ", defectCode=" + defectCode
                + ", defectType=" + defectType
                + ", defectName=" + defectName
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", remark=" + remark
                + ", useYn=" + useYn
                + ", defectCodePrefix=" + defectCodePrefix
                + ", useYnName=" + useYnName
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + "]";
    }
}