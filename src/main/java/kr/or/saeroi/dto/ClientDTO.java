package kr.or.saeroi.dto;

/**
 * 거래처 DTO
 * - client 테이블 기준
 * - 품목관리 등록/수정 모달에서 공급처/납품처 자동완성에 사용
 */
public class ClientDTO {

    // =========================================================
    // client 테이블 기본 컬럼
    // =========================================================

    private Integer clientId;       // 거래처 ID
    private String clientCode;      // 거래처 코드
    private String clientName;      // 거래처명

    // 거래처 구분: SUP(공급처), CUS(고객사/납품처)
    private String clientType;

    private String clientAdress;    // 거래처 주소
    private String clientMan;       // 담당자명
    private String clientTel;       // 연락처
    private String clientDept;      // 담당부서
    private String remark;          // 비고
    private String useYn;           // 사용여부: Y(사용), N(미사용)


    // =========================================================
    // 검색 / 자동완성 조건
    // =========================================================

    // 자동완성 검색어
    private String keyword;


    // =========================================================
    // 기본 생성자
    // =========================================================

    public ClientDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

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

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }


    // =========================================================
    // toString
    // =========================================================

    @Override
    public String toString() {
        return "ClientDTO [clientId=" + clientId
                + ", clientCode=" + clientCode
                + ", clientName=" + clientName
                + ", clientType=" + clientType
                + ", clientAdress=" + clientAdress
                + ", clientMan=" + clientMan
                + ", clientTel=" + clientTel
                + ", clientDept=" + clientDept
                + ", remark=" + remark
                + ", useYn=" + useYn
                + ", keyword=" + keyword
                + "]";
    }
}