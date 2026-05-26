package kr.or.saeroi.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

/**
 * 거래처 DTO
 *
 * 사용 위치:
 * - 품목관리 공급처/납품처 자동완성 Ajax
 * - 설비관리 거래처 selectbox
 *
 * 주의:
 * - MyBatis Mapper와 Ajax JS는 camelCase(clientId, clientName)를 사용한다.
 * - 기존 설비관리 JSP/DAO는 snake_case(client_id, client_name)를 사용하고 있어
 *   호환용 getter/setter를 함께 둔다.
 */
@Data
public class ClientDTO {

    private Integer clientId;
    private String clientCode;
    private String clientName;
    private String clientType;
    private String clientAdress;
    private String clientMan;
    private String clientTel;
    private String clientDept;
    private String remark;
    private String useYn;

    // =========================================================
    // 기존 설비관리 코드 호환용 메서드
    // - EquipmentDAO: setClient_id(), setClient_name() 사용
    // - equipment.jsp: ${client.client_id}, ${client.client_name} 사용
    // =========================================================

    @JsonIgnore
    public Integer getClient_id() {
        return clientId;
    }

    public void setClient_id(Integer clientId) {
        this.clientId = clientId;
    }

    @JsonIgnore
    public String getClient_name() {
        return clientName;
    }

    public void setClient_name(String clientName) {
        this.clientName = clientName;
    }

    @JsonIgnore
    public String getClient_code() {
        return clientCode;
    }

    public void setClient_code(String clientCode) {
        this.clientCode = clientCode;
    }

    @JsonIgnore
    public String getClient_type() {
        return clientType;
    }

    public void setClient_type(String clientType) {
        this.clientType = clientType;
    }

    @JsonIgnore
    public String getClient_adress() {
        return clientAdress;
    }

    public void setClient_adress(String clientAdress) {
        this.clientAdress = clientAdress;
    }

    @JsonIgnore
    public String getClient_man() {
        return clientMan;
    }

    public void setClient_man(String clientMan) {
        this.clientMan = clientMan;
    }

    @JsonIgnore
    public String getClient_tel() {
        return clientTel;
    }

    public void setClient_tel(String clientTel) {
        this.clientTel = clientTel;
    }

    @JsonIgnore
    public String getClient_dept() {
        return clientDept;
    }

    public void setClient_dept(String clientDept) {
        this.clientDept = clientDept;
    }

    @JsonIgnore
    public String getUse_yn() {
        return useYn;
    }

    public void setUse_yn(String useYn) {
        this.useYn = useYn;
    }
}