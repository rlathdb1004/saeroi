package kr.or.saeroi.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.MasterEquipmentDAO;
import kr.or.saeroi.dto.ClientDTO;
import kr.or.saeroi.dto.LineDTO;
import kr.or.saeroi.dto.MasterEquipmentDTO;

/**
 * 기준관리 > 설비관리 Service
 *
 * 기준:
 * - 사이드바 설비관리 업무 메뉴와 충돌 방지를 위해 MasterEquipment 명칭 사용
 * - ServiceImpl 만들지 않음
 * - 품목관리 기준 중심 적용
 * - 설비구분은 고정값이 아니므로 equip_code prefix 기준으로 관리
 * - 신규 설비구분 prefix 직접 입력 가능
 * - 실제 DELETE 대신 use_yn = 'N' 미사용 처리
 */
@Service
public class MasterEquipmentService {

    @Autowired
    private MasterEquipmentDAO masterEquipmentDAO;


    // =========================================================
    // 1. 설비 마스터 목록 / 상세
    // =========================================================

    /**
     * 설비 목록 조회
     */
    public List<MasterEquipmentDTO> getMasterEquipmentList(MasterEquipmentDTO masterEquipmentDTO) {

        cleanSearchCondition(masterEquipmentDTO);

        return masterEquipmentDAO.selectMasterEquipmentList(masterEquipmentDTO);
    }


    /**
     * 설비 목록 총 건수 조회
     */
    public int getMasterEquipmentCount(MasterEquipmentDTO masterEquipmentDTO) {

        cleanSearchCondition(masterEquipmentDTO);

        return masterEquipmentDAO.selectMasterEquipmentCount(masterEquipmentDTO);
    }


    /**
     * 설비 상세 조회
     */
    public MasterEquipmentDTO getMasterEquipmentDetail(Integer equipId) {

        if (equipId == null || equipId <= 0) {
            throw new IllegalArgumentException("설비 정보가 올바르지 않습니다.");
        }

        MasterEquipmentDTO masterEquipmentDTO =
                masterEquipmentDAO.selectMasterEquipmentDetail(equipId);

        if (masterEquipmentDTO == null) {
            throw new IllegalArgumentException("조회된 설비 정보가 없습니다.");
        }

        return masterEquipmentDTO;
    }


    // =========================================================
    // 2. 설비 마스터 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 설비 등록
     */
    public int addMasterEquipment(MasterEquipmentDTO masterEquipmentDTO) {

        validateMasterEquipment(masterEquipmentDTO, false);

        setDefaultValue(masterEquipmentDTO);

        int duplicateCount =
                masterEquipmentDAO.selectMasterEquipmentCodeCount(masterEquipmentDTO);

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("이미 등록된 설비코드입니다.");
        }

        return masterEquipmentDAO.insertMasterEquipment(masterEquipmentDTO);
    }


    /**
     * 설비 수정
     */
    public int modifyMasterEquipment(MasterEquipmentDTO masterEquipmentDTO) {

        validateMasterEquipment(masterEquipmentDTO, true);

        setDefaultValue(masterEquipmentDTO);

        int duplicateCount =
                masterEquipmentDAO.selectMasterEquipmentCodeCount(masterEquipmentDTO);

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("이미 등록된 설비코드입니다.");
        }

        return masterEquipmentDAO.updateMasterEquipment(masterEquipmentDTO);
    }


    /**
     * 설비 선택 삭제
     *
     * 처리:
     * - 실제 삭제하지 않고 use_yn = 'N' 미사용 처리
     */
    public int deleteMasterEquipmentList(List<Integer> equipIdList) {

        List<Integer> validEquipIdList = cleanEquipIdList(equipIdList);

        if (validEquipIdList.isEmpty()) {
            throw new IllegalArgumentException("선택된 설비가 없습니다.");
        }

        return masterEquipmentDAO.deleteMasterEquipmentList(validEquipIdList);
    }


    // =========================================================
    // 3. 등록/수정 화면용 기준 데이터
    // =========================================================

    /**
     * 라인 목록 조회
     */
    public List<LineDTO> getLineList() {
        return masterEquipmentDAO.selectLineList();
    }


    /**
     * 거래처 목록 조회
     */
    public List<ClientDTO> getClientList() {
        return masterEquipmentDAO.selectClientList();
    }


    /**
     * 기존 설비구분 prefix 목록 조회
     *
     * 예:
     * - EQ-CUT
     * - EQ-LAM
     * - EQ-PRS
     * - EQ-VIS
     *
     * 신규 설비구분은 이 목록에 없어도 직접 입력 가능하다.
     */
    public List<String> getEquipCodePrefixList() {

        List<String> equipCodePrefixList =
                masterEquipmentDAO.selectEquipCodePrefixList();

        if (equipCodePrefixList == null) {
            return new ArrayList<String>();
        }

        return equipCodePrefixList;
    }


    /**
     * 거래처 자동완성
     */
    public List<ClientDTO> getClientAutoComplete(String keyword) {

        keyword = cleanString(keyword);

        if (keyword.length() < 1) {
            return new ArrayList<ClientDTO>();
        }

        return masterEquipmentDAO.selectClientAutoComplete(keyword);
    }


    /**
     * 라인 자동완성
     */
    public List<LineDTO> getLineAutoComplete(String keyword) {

        keyword = cleanString(keyword);

        if (keyword.length() < 1) {
            return new ArrayList<LineDTO>();
        }

        return masterEquipmentDAO.selectLineAutoComplete(keyword);
    }


    // =========================================================
    // 4. 설비코드 자동생성
    // =========================================================

    /**
     * 다음 설비코드 생성
     *
     * 예:
     * - EQ-CUT -> EQ-CUT-005
     * - EQ-DRY -> EQ-DRY-001
     */
    public String getNextEquipCode(String equipCodePrefix) {

        equipCodePrefix = normalizeEquipCodePrefix(equipCodePrefix);

        validateEquipCodePrefix(equipCodePrefix);

        return masterEquipmentDAO.selectNextEquipCode(equipCodePrefix);
    }


    // =========================================================
    // 5. 내부 공통 검증
    // =========================================================

    /**
     * 설비 등록/수정 검증
     */
    private void validateMasterEquipment(
            MasterEquipmentDTO masterEquipmentDTO,
            boolean isModify) {

        if (masterEquipmentDTO == null) {
            throw new IllegalArgumentException("설비 정보가 없습니다.");
        }

        if (isModify
                && (masterEquipmentDTO.getEquipId() == null
                    || masterEquipmentDTO.getEquipId() <= 0)) {
            throw new IllegalArgumentException("수정할 설비 정보가 올바르지 않습니다.");
        }

        masterEquipmentDTO.setEquipCode(cleanString(masterEquipmentDTO.getEquipCode()).toUpperCase());
        masterEquipmentDTO.setEquipName(cleanString(masterEquipmentDTO.getEquipName()));
        masterEquipmentDTO.setEquipStatus(cleanString(masterEquipmentDTO.getEquipStatus()));
        masterEquipmentDTO.setEquipLoc(cleanString(masterEquipmentDTO.getEquipLoc()));
        masterEquipmentDTO.setUseYn(cleanString(masterEquipmentDTO.getUseYn()).toUpperCase());
        masterEquipmentDTO.setRemark(cleanString(masterEquipmentDTO.getRemark()));

        if (masterEquipmentDTO.getEquipCode().length() == 0) {
            throw new IllegalArgumentException("설비코드를 입력해 주세요.");
        }

        if (masterEquipmentDTO.getEquipCode().length() > 50) {
            throw new IllegalArgumentException("설비코드는 50자 이내로 입력해 주세요.");
        }

        validateEquipCodeFormat(masterEquipmentDTO.getEquipCode());

        if (masterEquipmentDTO.getEquipName().length() == 0) {
            throw new IllegalArgumentException("설비명을 입력해 주세요.");
        }

        if (masterEquipmentDTO.getEquipName().length() > 100) {
            throw new IllegalArgumentException("설비명은 100자 이내로 입력해 주세요.");
        }

        if (masterEquipmentDTO.getLineId() == null
                || masterEquipmentDTO.getLineId() <= 0) {
            throw new IllegalArgumentException("라인을 선택해 주세요.");
        }

        if (masterEquipmentDTO.getClientId() == null
                || masterEquipmentDTO.getClientId() <= 0) {
            throw new IllegalArgumentException("제조사/거래처를 선택해 주세요.");
        }

        if (masterEquipmentDTO.getEquipStatus().length() == 0) {
            throw new IllegalArgumentException("설비상태를 선택해 주세요.");
        }

        if (masterEquipmentDTO.getEquipStatus().length() > 30) {
            throw new IllegalArgumentException("설비상태는 30자 이내로 입력해 주세요.");
        }

        if (masterEquipmentDTO.getEquipLoc().length() > 100) {
            throw new IllegalArgumentException("설치위치는 100자 이내로 입력해 주세요.");
        }

        if (masterEquipmentDTO.getUseYn().length() == 0) {
            masterEquipmentDTO.setUseYn("Y");
        }

        if (!"Y".equals(masterEquipmentDTO.getUseYn())
                && !"N".equals(masterEquipmentDTO.getUseYn())) {
            throw new IllegalArgumentException("사용여부는 Y 또는 N만 입력할 수 있습니다.");
        }

        if (masterEquipmentDTO.getEquipPrice() != null
                && masterEquipmentDTO.getEquipPrice() < 0) {
            throw new IllegalArgumentException("설비금액은 0 이상으로 입력해 주세요.");
        }

        if (masterEquipmentDTO.getRemark().length() > 500) {
            throw new IllegalArgumentException("비고는 500자 이내로 입력해 주세요.");
        }
    }


    /**
     * 설비코드 prefix 정규화
     *
     * 허용 입력 예:
     * - CUT      -> EQ-CUT
     * - EQ-CUT   -> EQ-CUT
     * - eq-dry   -> EQ-DRY
     */
    private String normalizeEquipCodePrefix(String equipCodePrefix) {

        equipCodePrefix = cleanString(equipCodePrefix).toUpperCase();

        if (equipCodePrefix.length() == 0) {
            return "";
        }

        if (!equipCodePrefix.startsWith("EQ-")) {
            equipCodePrefix = "EQ-" + equipCodePrefix;
        }

        return equipCodePrefix;
    }


    /**
     * 설비코드 prefix 검증
     */
    private void validateEquipCodePrefix(String equipCodePrefix) {

        if (equipCodePrefix.length() == 0) {
            throw new IllegalArgumentException("설비구분을 선택하거나 신규 입력해 주세요.");
        }

        if (equipCodePrefix.length() > 46) {
            throw new IllegalArgumentException("설비구분은 46자 이내로 입력해 주세요.");
        }

        if (!equipCodePrefix.matches("^EQ-[A-Z0-9]+(-[A-Z0-9]+)*$")) {
            throw new IllegalArgumentException("설비구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: EQ-CUT");
        }
    }


    /**
     * 설비코드 형식 검증
     *
     * 허용 예:
     * - EQ-CUT-001
     * - EQ-LAM-004
     * - EQ-DRY-001
     * - EQ-ROBOT-ARM-001
     */
    private void validateEquipCodeFormat(String equipCode) {

        if (!equipCode.matches("^EQ-[A-Z0-9]+(-[A-Z0-9]+)*-[0-9]{3}$")) {
            throw new IllegalArgumentException("설비코드 형식이 올바르지 않습니다. 예: EQ-CUT-001");
        }
    }


    /**
     * 기본값 세팅
     */
    private void setDefaultValue(MasterEquipmentDTO masterEquipmentDTO) {

        if (isBlank(masterEquipmentDTO.getUseYn())) {
            masterEquipmentDTO.setUseYn("Y");
        }

        if (isBlank(masterEquipmentDTO.getEquipStatus())) {
            masterEquipmentDTO.setEquipStatus("가동");
        }
    }


    /**
     * 검색조건 정리
     */
    private void cleanSearchCondition(MasterEquipmentDTO masterEquipmentDTO) {

        if (masterEquipmentDTO == null) {
            return;
        }

        masterEquipmentDTO.setSearchType(cleanString(masterEquipmentDTO.getSearchType()));
        masterEquipmentDTO.setSearchKeyword(cleanString(masterEquipmentDTO.getSearchKeyword()));
    }


    /**
     * 선택삭제 ID 정리
     */
    private List<Integer> cleanEquipIdList(List<Integer> equipIdList) {

        List<Integer> validEquipIdList = new ArrayList<Integer>();

        if (equipIdList == null) {
            return validEquipIdList;
        }

        for (Integer equipId : equipIdList) {
            if (equipId != null
                    && equipId > 0
                    && !validEquipIdList.contains(equipId)) {
                validEquipIdList.add(equipId);
            }
        }

        return validEquipIdList;
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