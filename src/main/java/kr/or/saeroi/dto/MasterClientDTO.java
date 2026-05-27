package kr.or.saeroi.dto;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 기준관리 > 거래처관리 DTO
 *
 * 기준:
 * - 기준관리 거래처 마스터 전용 DTO
 * - 기존 ClientDTO는 품목/설비 자동완성 호환용으로 유지
 * - 거래처관리 페이지는 MasterClientDTO 사용
 * - client 테이블 기본 컬럼 + 화면 표시용 컬럼 + 검색조건 포함
 * - 품목관리 기준에 맞춰 Lombok 사용하지 않고 getter/setter 명시
 */
public class MasterClientDTO {

    // =========================================================
    // client 테이블 기본 컬럼
    // =========================================================
	private double latitude;
	private double longitude;
    private Integer clientId;       // 거래처 ID

    private String clientCode;      // 거래처코드
    private String clientName;      // 거래처명
    private String clientType;      // 거래처구분: SUP, CUS 등

    private String clientAdress;    // 주소
    private String clientMan;       // 담당자
    private String clientTel;       // 전화번호
    private String clientDept;      // 담당부서

    private String remark;          // 비고

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createdDate;       // 등록일

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date updatedDate;       // 수정일

    private String useYn;           // 사용여부


    // =========================================================
    // 화면 표시용 변환 컬럼
    // =========================================================

    private String clientTypeName;  // 거래처구분 표시명
    private String useYnName;       // 사용여부 표시명


    // =========================================================
    // 화면 참고용 컬럼
    // =========================================================

    private Integer itemCount;      // 연결된 품목 수
    private Integer equipmentCount; // 연결된 설비 수


    // =========================================================
    // 거래처코드 자동생성 / 구분 처리용
    // =========================================================

    /*
     * 거래처코드 prefix
     *
     * 예:
     * - BP-SUP
     * - BP-CUS
     *
     * 주의:
     * - DB에 별도 컬럼으로 저장하지 않는다.
     * - client_code의 마지막 "-001" 같은 순번을 제외한 prefix로 관리한다.
     */
    private String clientCodePrefix;


    // =========================================================
    // 검색 조건
    // =========================================================

    // 검색구분: clientCode, clientName, clientType, clientMan, clientTel, useYn
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public MasterClientDTO() {
    }




    // =========================================================
    // Getter / Setter
    // =========================================================

    public double getLatitude() {
    	return latitude;
    }
    
    
    public void setLatitude(double latitude) {
    	this.latitude = latitude;
    }
    
    
    public double getLongitude() {
    	return longitude;
    }
    
    
    public void setLongitude(double longitude) {
    	this.longitude = longitude;
    }
    
    
    public Integer getClientId() {
    	return clientId;
    }
    
    
    public void setClientId(Integer clientId) {
    	this.clientId = clientId;
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
    
    
    public String getClientAdress() {
    	return clientAdress;
    }
    
    
    public void setClientAdress(String clientAdress) {
    	this.clientAdress = clientAdress;
    }
    
    
    public String getClientMan() {
    	return clientMan;
    }
    
    
    public void setClientMan(String clientMan) {
    	this.clientMan = clientMan;
    }
    
    
    public String getClientTel() {
    	return clientTel;
    }
    
    
    public void setClientTel(String clientTel) {
    	this.clientTel = clientTel;
    }
    
    
    public String getClientDept() {
    	return clientDept;
    }
    
    
    public void setClientDept(String clientDept) {
    	this.clientDept = clientDept;
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
    
    
    public String getClientTypeName() {
    	return clientTypeName;
    }
    
    
    public void setClientTypeName(String clientTypeName) {
    	this.clientTypeName = clientTypeName;
    }
    
    
    public String getUseYnName() {
    	return useYnName;
    }
    
    
    public void setUseYnName(String useYnName) {
    	this.useYnName = useYnName;
    }
    
    
    public Integer getItemCount() {
    	return itemCount;
    }
    
    
    public void setItemCount(Integer itemCount) {
    	this.itemCount = itemCount;
    }
    
    
    public Integer getEquipmentCount() {
    	return equipmentCount;
    }
    
    
    public void setEquipmentCount(Integer equipmentCount) {
    	this.equipmentCount = equipmentCount;
    }
    
    
    public String getClientCodePrefix() {
    	return clientCodePrefix;
    }
    
    
    public void setClientCodePrefix(String clientCodePrefix) {
    	this.clientCodePrefix = clientCodePrefix;
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
    	return "MasterClientDTO [latitude=" + latitude + ", longitude=" + longitude + ", clientId=" + clientId
    			+ ", clientCode=" + clientCode + ", clientName=" + clientName + ", clientType=" + clientType
    			+ ", clientAdress=" + clientAdress + ", clientMan=" + clientMan + ", clientTel=" + clientTel
    			+ ", clientDept=" + clientDept + ", remark=" + remark + ", createdDate=" + createdDate
    			+ ", updatedDate=" + updatedDate + ", useYn=" + useYn + ", clientTypeName=" + clientTypeName
    			+ ", useYnName=" + useYnName + ", itemCount=" + itemCount + ", equipmentCount=" + equipmentCount
    			+ ", clientCodePrefix=" + clientCodePrefix + ", searchType=" + searchType + ", searchKeyword="
    			+ searchKeyword + "]";
    }

}