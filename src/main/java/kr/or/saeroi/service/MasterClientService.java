package kr.or.saeroi.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.MasterClientDAO;
import kr.or.saeroi.dto.MasterClientDTO;

/**
 * 기준관리 > 거래처관리 Service
 *
 * 기준:
 * - 기존 ClientDTO / ClientDAO와 충돌 방지를 위해 MasterClient 명칭 사용
 * - ServiceImpl 만들지 않음
 * - 품목관리 기준 중심 적용
 * - 실제 DELETE 대신 use_yn = 'N' 미사용 처리
 * - 거래처코드는 client_code prefix 기준으로 자동생성
 */
@Service
public class MasterClientService {

    @Autowired
    private MasterClientDAO masterClientDAO;


    // =========================================================
    // 1. 거래처 목록 / 상세
    // =========================================================

    /**
     * 거래처 목록 조회
     */
    public List<MasterClientDTO> getMasterClientList(MasterClientDTO masterClientDTO) {

        cleanSearchCondition(masterClientDTO);

        return masterClientDAO.selectMasterClientList(masterClientDTO);
    }


    /**
     * 거래처 목록 총 건수 조회
     */
    public int getMasterClientCount(MasterClientDTO masterClientDTO) {

        cleanSearchCondition(masterClientDTO);

        return masterClientDAO.selectMasterClientCount(masterClientDTO);
    }


    /**
     * 거래처 상세 조회
     */
    public MasterClientDTO getMasterClientDetail(Integer clientId) {

        if (clientId == null || clientId <= 0) {
            throw new IllegalArgumentException("거래처 정보가 올바르지 않습니다.");
        }

        MasterClientDTO masterClientDTO = masterClientDAO.selectMasterClientDetail(clientId);

        if (masterClientDTO == null) {
            throw new IllegalArgumentException("조회된 거래처 정보가 없습니다.");
        }

        return masterClientDTO;
    }


    // =========================================================
    // 2. 거래처 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 거래처 등록
     */
    public int addMasterClient(MasterClientDTO masterClientDTO) {

        validateMasterClient(masterClientDTO, false);

        setDefaultValue(masterClientDTO);

        int duplicateCount = masterClientDAO.selectMasterClientCodeCount(masterClientDTO);

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("이미 등록된 거래처코드입니다.");
        }

        return masterClientDAO.insertMasterClient(masterClientDTO);
    }


    /**
     * 거래처 수정
     */
    public int modifyMasterClient(MasterClientDTO masterClientDTO) {

        validateMasterClient(masterClientDTO, true);

        setDefaultValue(masterClientDTO);

        int duplicateCount = masterClientDAO.selectMasterClientCodeCount(masterClientDTO);

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("이미 등록된 거래처코드입니다.");
        }

        return masterClientDAO.updateMasterClient(masterClientDTO);
    }


    /**
     * 거래처 선택 삭제
     *
     * 처리:
     * - 실제 삭제하지 않고 use_yn = 'N' 처리
     */
    public int deleteMasterClientList(List<Integer> clientIdList) {

        List<Integer> validClientIdList = cleanClientIdList(clientIdList);

        if (validClientIdList.isEmpty()) {
            throw new IllegalArgumentException("선택된 거래처가 없습니다.");
        }

        return masterClientDAO.deleteMasterClientList(validClientIdList);
    }


    // =========================================================
    // 3. 거래처코드 prefix / 자동생성
    // =========================================================

    /**
     * 기존 거래처코드 prefix 목록 조회
     *
     * 예:
     * - BP-SUP
     * - BP-CUS
     */
    public List<String> getClientCodePrefixList() {

        List<String> clientCodePrefixList = masterClientDAO.selectClientCodePrefixList();

        if (clientCodePrefixList == null) {
            return new ArrayList<String>();
        }

        return clientCodePrefixList;
    }


    /**
     * 다음 거래처코드 생성
     *
     * 예:
     * - BP-SUP -> BP-SUP-006
     * - BP-CUS -> BP-CUS-004
     * - BP-MAN -> BP-MAN-001
     */
    public String getNextClientCode(String clientCodePrefix) {

        clientCodePrefix = normalizeClientCodePrefix(clientCodePrefix);

        validateClientCodePrefix(clientCodePrefix);

        return masterClientDAO.selectNextClientCode(clientCodePrefix);
    }


    // =========================================================
    // 4. 내부 공통 검증
    // =========================================================

    /**
     * 거래처 등록/수정 검증
     */
    private void validateMasterClient(MasterClientDTO masterClientDTO, boolean isModify) {

        if (masterClientDTO == null) {
            throw new IllegalArgumentException("거래처 정보가 없습니다.");
        }

        if (isModify && (masterClientDTO.getClientId() == null || masterClientDTO.getClientId() <= 0)) {
            throw new IllegalArgumentException("수정할 거래처 정보가 올바르지 않습니다.");
        }

        masterClientDTO.setClientCode(cleanString(masterClientDTO.getClientCode()).toUpperCase());
        masterClientDTO.setClientName(cleanString(masterClientDTO.getClientName()));
        masterClientDTO.setClientType(cleanString(masterClientDTO.getClientType()).toUpperCase());
        masterClientDTO.setClientAdress(cleanString(masterClientDTO.getClientAdress()));
        masterClientDTO.setClientMan(cleanString(masterClientDTO.getClientMan()));
        masterClientDTO.setClientTel(cleanString(masterClientDTO.getClientTel()));
        masterClientDTO.setClientDept(cleanString(masterClientDTO.getClientDept()));
        masterClientDTO.setRemark(cleanString(masterClientDTO.getRemark()));
        masterClientDTO.setUseYn(cleanString(masterClientDTO.getUseYn()).toUpperCase());

        if (masterClientDTO.getClientCode().length() == 0) {
            throw new IllegalArgumentException("거래처코드를 입력해 주세요.");
        }

        if (masterClientDTO.getClientCode().length() > 50) {
            throw new IllegalArgumentException("거래처코드는 50자 이내로 입력해 주세요.");
        }

        validateClientCodeFormat(masterClientDTO.getClientCode());

        if (masterClientDTO.getClientName().length() == 0) {
            throw new IllegalArgumentException("거래처명을 입력해 주세요.");
        }

        if (masterClientDTO.getClientName().length() > 100) {
            throw new IllegalArgumentException("거래처명은 100자 이내로 입력해 주세요.");
        }

        if (masterClientDTO.getClientType().length() == 0) {
            throw new IllegalArgumentException("거래처구분을 선택하거나 입력해 주세요.");
        }

        if (masterClientDTO.getClientType().length() > 30) {
            throw new IllegalArgumentException("거래처구분은 30자 이내로 입력해 주세요.");
        }

        if (!masterClientDTO.getClientType().matches("^[A-Z0-9]+(-[A-Z0-9]+)*$")) {
            throw new IllegalArgumentException("거래처구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: SUP, CUS");
        }

        if (masterClientDTO.getClientAdress().length() > 200) {
            throw new IllegalArgumentException("주소는 200자 이내로 입력해 주세요.");
        }

        if (masterClientDTO.getClientMan().length() > 50) {
            throw new IllegalArgumentException("담당자는 50자 이내로 입력해 주세요.");
        }

        if (masterClientDTO.getClientTel().length() > 30) {
            throw new IllegalArgumentException("전화번호는 30자 이내로 입력해 주세요.");
        }

        if (masterClientDTO.getClientDept().length() > 50) {
            throw new IllegalArgumentException("담당부서는 50자 이내로 입력해 주세요.");
        }

        if (masterClientDTO.getUseYn().length() == 0) {
            masterClientDTO.setUseYn("Y");
        }

        if (!"Y".equals(masterClientDTO.getUseYn()) && !"N".equals(masterClientDTO.getUseYn())) {
            throw new IllegalArgumentException("사용여부는 Y 또는 N만 입력할 수 있습니다.");
        }

        if (masterClientDTO.getRemark().length() > 500) {
            throw new IllegalArgumentException("비고는 500자 이내로 입력해 주세요.");
        }
    }


    /**
     * 거래처코드 prefix 정규화
     *
     * 허용 입력 예:
     * - SUP      -> BP-SUP
     * - BP-SUP   -> BP-SUP
     * - bp-cus   -> BP-CUS
     */
    private String normalizeClientCodePrefix(String clientCodePrefix) {

        clientCodePrefix = cleanString(clientCodePrefix).toUpperCase();

        if (clientCodePrefix.length() == 0) {
            return "";
        }

        if (!clientCodePrefix.startsWith("BP-")) {
            clientCodePrefix = "BP-" + clientCodePrefix;
        }

        return clientCodePrefix;
    }


    /**
     * 거래처코드 prefix 검증
     */
    private void validateClientCodePrefix(String clientCodePrefix) {

        if (clientCodePrefix.length() == 0) {
            throw new IllegalArgumentException("거래처구분을 선택하거나 신규 입력해 주세요.");
        }

        if (clientCodePrefix.length() > 46) {
            throw new IllegalArgumentException("거래처구분은 46자 이내로 입력해 주세요.");
        }

        if (!clientCodePrefix.matches("^BP-[A-Z0-9]+(-[A-Z0-9]+)*$")) {
            throw new IllegalArgumentException("거래처구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: BP-SUP");
        }
    }


    /**
     * 거래처코드 형식 검증
     *
     * 허용 예:
     * - BP-SUP-001
     * - BP-CUS-001
     * - BP-MAN-001
     */
    private void validateClientCodeFormat(String clientCode) {

        if (!clientCode.matches("^BP-[A-Z0-9]+(-[A-Z0-9]+)*-[0-9]{3}$")) {
            throw new IllegalArgumentException("거래처코드 형식이 올바르지 않습니다. 예: BP-SUP-001");
        }
    }


    /**
     * 기본값 세팅
     */
    private void setDefaultValue(MasterClientDTO masterClientDTO) {

        if (isBlank(masterClientDTO.getUseYn())) {
            masterClientDTO.setUseYn("Y");
        }
    }


    /**
     * 검색조건 정리
     */
    private void cleanSearchCondition(MasterClientDTO masterClientDTO) {

        if (masterClientDTO == null) {
            return;
        }

        masterClientDTO.setSearchType(cleanString(masterClientDTO.getSearchType()));
        masterClientDTO.setSearchKeyword(cleanString(masterClientDTO.getSearchKeyword()));
    }


    /**
     * 선택삭제 ID 정리
     */
    private List<Integer> cleanClientIdList(List<Integer> clientIdList) {

        List<Integer> validClientIdList = new ArrayList<Integer>();

        if (clientIdList == null) {
            return validClientIdList;
        }

        for (Integer clientId : clientIdList) {
            if (clientId != null && clientId > 0 && !validClientIdList.contains(clientId)) {
                validClientIdList.add(clientId);
            }
        }

        return validClientIdList;
    }


    /**
     * 문자열 trim + null 방어
     */
    private String cleanString(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }


    /**
     * 빈 문자열 확인
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().length() == 0;
    }
}