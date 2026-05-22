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
 * - 공정별 이미지 관리
 * - 공정별 작업표준서 이미지 관리
 * - 공정별 상세 설명 관리
 * - 하나의 공정에 여러 개의 이미지/설명을 연결
 *
 * DB 컬럼 매핑:
 * - process_detail.proc_id      -> procDetailId
 * - process_detail.proc_id2     -> procId
 * - process_detail.proc_picture -> procPicture
 * - process_detail.proc_content -> procContent
 * - process_detail.created_date -> createdDate
 * - process_detail.updated_date -> updatedDate
 * - process_detail.remark       -> remark
 *
 * 주의:
 * - process_detail.proc_id는 공정 ID가 아니라 공정상세 ID이다.
 * - process_detail.proc_id2가 process.proc_id를 참조한다.
 */
public class ProcessDetailDTO {

    /**
     * 공정상세 ID
     *
     * DB 컬럼:
     * - process_detail.proc_id
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
     */
    private Integer procId;

    /**
     * 공정 이미지 경로
     *
     * DB 컬럼:
     * - process_detail.proc_picture
     *
     * 예시:
     * - /resources/upload/process/process_1_20260602103000123.png
     */
    private String procPicture;

    /**
     * 공정상세 설명
     *
     * DB 컬럼:
     * - process_detail.proc_content
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
     */
    private String remark;


    // =========================================================
    // 화면 표시용 JOIN 컬럼
    // =========================================================

    /**
     * 공정코드
     *
     * JOIN:
     * - process.proc_code
     */
    private String procCode;

    /**
     * 공정명
     *
     * JOIN:
     * - process.proc_name
     */
    private String procName;

    /**
     * 품목 ID
     *
     * JOIN:
     * - process.item_id
     */
    private Integer itemId;

    /**
     * 품목코드
     *
     * JOIN:
     * - item.item_code
     */
    private String itemCode;

    /**
     * 품목명
     *
     * JOIN:
     * - item.item_name
     */
    private String itemName;

    /**
     * 설비 ID
     *
     * JOIN:
     * - process.equip_id
     */
    private Integer equipId;

    /**
     * 설비코드
     *
     * JOIN:
     * - equipment.equip_code
     */
    private String equipCode;

    /**
     * 설비명
     *
     * JOIN:
     * - equipment.equip_name
     */
    private String equipName;

    /**
     * 라인 ID
     *
     * JOIN:
     * - equipment.line_id
     */
    private Integer lineId;

    /**
     * 라인코드
     *
     * JOIN:
     * - line.line_code
     */
    private String lineCode;

    /**
     * 라인명
     *
     * JOIN:
     * - line.line_name
     */
    private String lineName;


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
}