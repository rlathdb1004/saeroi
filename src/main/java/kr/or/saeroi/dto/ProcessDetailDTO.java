package kr.or.saeroi.dto;

import java.sql.Date;

/**
 * 공정상세 DTO
 *
 * 사용 메뉴:
 * - 기준정보관리 > 공정관리 > 공정 상세
 *
 * 사용 테이블:
 * - process_detail
 *
 * 역할:
 * - 공정별 작업표준서 이미지 관리
 * - 공정별 상세 설명 관리
 * - 하나의 공정에 여러 개의 상세 이미지/설명을 연결
 *
 * DB 컬럼 매핑 기준:
 * - process_detail.proc_id      : 공정상세 ID
 * - process_detail.proc_id2     : 공정 ID(process.proc_id)
 * - process_detail.proc_picture : 공정 이미지 경로
 * - process_detail.proc_content : 공정상세 설명
 * - process_detail.created_date : 등록일
 * - process_detail.updated_date : 수정일
 * - process_detail.remark       : 비고
 *
 * 주의:
 * - process_detail의 proc_id는 process.proc_id가 아니라 공정상세 PK이다.
 * - 그래서 DTO에서는 procDetailId로 구분한다.
 * - process_detail.proc_id2가 실제 process 테이블의 proc_id를 참조한다.
 */
public class ProcessDetailDTO {

    /**
     * 공정상세 ID
     *
     * DB 컬럼:
     * - process_detail.proc_id
     *
     * 설명:
     * - process_detail 테이블의 PK 역할
     * - 공정상세 1건을 구분하는 번호
     */
    private Integer procDetailId;

    /**
     * 공정 ID
     *
     * DB 컬럼:
     * - process_detail.proc_id2
     *
     * 설명:
     * - process 테이블의 proc_id를 참조한다.
     * - 어떤 공정에 속한 상세 이미지/설명인지 연결한다.
     */
    private Integer procId;

    /**
     * 공정 이미지 경로
     *
     * DB 컬럼:
     * - process_detail.proc_picture
     *
     * 예시:
     * - /resources/upload/process/process_1_20260602103000.png
     *
     * 설명:
     * - 실제 파일은 서버 업로드 폴더에 저장한다.
     * - DB에는 브라우저에서 접근 가능한 상대 경로를 저장한다.
     */
    private String procPicture;

    /**
     * 공정상세 설명
     *
     * DB 컬럼:
     * - process_detail.proc_content
     *
     * 설명:
     * - 작업표준서 설명
     * - 공정 주의사항
     * - 검사 기준
     * - 설비 세팅 조건 등을 입력할 수 있다.
     */
    private String procContent;

    /**
     * 등록일
     *
     * DB 컬럼:
     * - process_detail.created_date
     */
    private Date createdDate;

    /**
     * 수정일
     *
     * DB 컬럼:
     * - process_detail.updated_date
     */
    private Date updatedDate;

    /**
     * 비고
     *
     * DB 컬럼:
     * - process_detail.remark
     *
     * 설명:
     * - 화면에서는 30자 이내 기준으로 사용한다.
     */
    private String remark;


    // =========================================================
    // 화면 표시용 JOIN 컬럼
    // =========================================================

    /**
     * 공정코드
     *
     * JOIN 컬럼:
     * - process.proc_code
     */
    private String procCode;

    /**
     * 공정명
     *
     * JOIN 컬럼:
     * - process.proc_name
     */
    private String procName;

    /**
     * 품목 ID
     *
     * JOIN 컬럼:
     * - process.item_id
     */
    private Integer itemId;

    /**
     * 품목코드
     *
     * JOIN 컬럼:
     * - item.item_code
     */
    private String itemCode;

    /**
     * 품목명
     *
     * JOIN 컬럼:
     * - item.item_name
     */
    private String itemName;

    /**
     * 설비 ID
     *
     * JOIN 컬럼:
     * - process.equip_id
     */
    private Integer equipId;

    /**
     * 설비코드
     *
     * JOIN 컬럼:
     * - equipment.equip_code
     */
    private String equipCode;

    /**
     * 설비명
     *
     * JOIN 컬럼:
     * - equipment.equip_name
     */
    private String equipName;

    /**
     * 라인 ID
     *
     * JOIN 컬럼:
     * - equipment.line_id
     */
    private Integer lineId;

    /**
     * 라인코드
     *
     * JOIN 컬럼:
     * - line.line_code
     */
    private String lineCode;

    /**
     * 라인명
     *
     * JOIN 컬럼:
     * - line.line_name
     */
    private String lineName;


    // =========================================================
    // 검색 / 화면 제어용 필드
    // =========================================================

    /**
     * 검색 구분
     *
     * 예시:
     * - procName
     * - itemName
     * - equipName
     * - lineName
     */
    private String searchType;

    /**
     * 검색어
     */
    private String searchKeyword;


    // =========================================================
    // Getter / Setter
    // =========================================================

    public Integer getProcDetailId() {
        return procDetailId;
    }

    public void setProcDetailId(Integer procDetailId) {
        this.procDetailId = procDetailId;
    }

    public Integer getProcId() {
        return procId;
    }

    public void setProcId(Integer procId) {
        this.procId = procId;
    }

    public String getProcPicture() {
        return procPicture;
    }

    public void setProcPicture(String procPicture) {
        this.procPicture = procPicture;
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

    public Integer getEquipId() {
        return equipId;
    }

    public void setEquipId(Integer equipId) {
        this.equipId = equipId;
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
}