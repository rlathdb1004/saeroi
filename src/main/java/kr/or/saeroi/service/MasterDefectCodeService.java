package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.MasterDefectCodeDAO;
import kr.or.saeroi.dto.MasterDefectCodeDTO;

/**
 * 기준관리 > 불량코드관리 Service
 *
 * 기준:
 * - ServiceImpl 만들지 않음
 * - Controller → Service → DAO → Mapper 흐름
 * - 실제 DELETE 금지, use_yn = 'N' 미사용 처리
 * - 불량코드 자동생성: prefix + 3자리 일련번호
 */
@Service
public class MasterDefectCodeService {

    @Autowired
    private MasterDefectCodeDAO masterDefectCodeDAO;


    /**
     * 불량코드 목록 조회
     *
     * @param dto 검색조건 DTO
     * @return 불량코드 목록
     */
    public List<MasterDefectCodeDTO> selectMasterDefectCodeList(MasterDefectCodeDTO dto) {
        return masterDefectCodeDAO.selectMasterDefectCodeList(dto);
    }


    /**
     * 불량코드 목록 건수 조회
     *
     * @param dto 검색조건 DTO
     * @return 목록 건수
     */
    public int selectMasterDefectCodeCount(MasterDefectCodeDTO dto) {
        return masterDefectCodeDAO.selectMasterDefectCodeCount(dto);
    }


    /**
     * 불량코드 상세 조회
     *
     * @param defectId 불량코드 ID
     * @return 불량코드 상세 DTO
     */
    public MasterDefectCodeDTO selectMasterDefectCodeDetail(int defectId) {
        return masterDefectCodeDAO.selectMasterDefectCodeDetail(defectId);
    }


    /**
     * 불량코드 등록
     *
     * 처리 기준:
     * - 사용여부 미입력 시 Y
     * - 불량코드 미입력 시 prefix 기준으로 자동생성
     * - prefix는 대문자 변환, 공백 제거
     * - 중복 불량코드는 등록 불가
     *
     * @param dto 등록 DTO
     * @return 처리 건수
     */
    public int insertMasterDefectCode(MasterDefectCodeDTO dto) {

        normalizeDefectCodeDTO(dto);

        // 불량코드가 없으면 prefix 기준으로 자동생성
        if (isEmpty(dto.getDefectCode())) {

            String prefix = normalizePrefix(dto.getDefectCodePrefix());

            if (isEmpty(prefix)) {
                throw new IllegalArgumentException("불량코드 구분을 입력하세요.");
            }

            String nextDefectCode = masterDefectCodeDAO.selectNextDefectCode(prefix);
            dto.setDefectCode(nextDefectCode);
            dto.setDefectCodePrefix(prefix);
        }

        dto.setDefectCode(normalizeCode(dto.getDefectCode()));

        // 불량코드 중복 체크
        int duplicateCount = masterDefectCodeDAO.selectMasterDefectCodeCountByCode(dto);

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("이미 등록된 불량코드입니다.");
        }

        return masterDefectCodeDAO.insertMasterDefectCode(dto);
    }


    /**
     * 불량코드 수정
     *
     * 처리 기준:
     * - 기존 불량코드 직접 수정 가능
     * - 불량코드 중복 체크
     * - 사용여부 미입력 시 Y
     *
     * @param dto 수정 DTO
     * @return 처리 건수
     */
    public int updateMasterDefectCode(MasterDefectCodeDTO dto) {

        if (dto.getDefectId() == null) {
            throw new IllegalArgumentException("수정할 불량코드 ID가 없습니다.");
        }

        normalizeDefectCodeDTO(dto);

        if (isEmpty(dto.getDefectCode())) {
            throw new IllegalArgumentException("불량코드를 입력하세요.");
        }

        dto.setDefectCode(normalizeCode(dto.getDefectCode()));

        // 불량코드 중복 체크
        int duplicateCount = masterDefectCodeDAO.selectMasterDefectCodeCountByCode(dto);

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("이미 등록된 불량코드입니다.");
        }

        return masterDefectCodeDAO.updateMasterDefectCode(dto);
    }


    /**
     * 불량코드 선택 미사용 처리
     *
     * 실제 DELETE 하지 않고 use_yn = 'N' 으로 처리한다.
     *
     * @param defectIdList 불량코드 ID 목록
     * @return 처리 건수
     */
    public int deleteMasterDefectCodeList(List<Integer> defectIdList) {

        if (defectIdList == null || defectIdList.isEmpty()) {
            throw new IllegalArgumentException("미사용 처리할 불량코드를 선택하세요.");
        }

        return masterDefectCodeDAO.deleteMasterDefectCodeList(defectIdList);
    }


    /**
     * 불량코드 prefix 목록 조회
     *
     * @return prefix 목록
     */
    public List<String> selectDefectCodePrefixList() {
        return masterDefectCodeDAO.selectDefectCodePrefixList();
    }


    /**
     * prefix 기준 다음 불량코드 조회
     *
     * 등록 모달에서 prefix 선택/입력 후 미리보기용으로 사용할 수 있다.
     *
     * @param defectCodePrefix 불량코드 prefix
     * @return 다음 불량코드
     */
    public String selectNextDefectCode(String defectCodePrefix) {

        String prefix = normalizePrefix(defectCodePrefix);

        if (isEmpty(prefix)) {
            return "";
        }

        return masterDefectCodeDAO.selectNextDefectCode(prefix);
    }


    // =========================================================
    // 내부 공통 처리 메소드
    // =========================================================

    /**
     * DTO 기본값/문자열 정리
     *
     * @param dto 불량코드 DTO
     */
    private void normalizeDefectCodeDTO(MasterDefectCodeDTO dto) {

        if (dto == null) {
            throw new IllegalArgumentException("불량코드 정보가 없습니다.");
        }

        dto.setDefectCodePrefix(normalizePrefix(dto.getDefectCodePrefix()));

        if (!isEmpty(dto.getDefectCode())) {
            dto.setDefectCode(normalizeCode(dto.getDefectCode()));
        }

        dto.setDefectType(trim(dto.getDefectType()));
        dto.setDefectName(trim(dto.getDefectName()));
        dto.setRemark(trim(dto.getRemark()));

        if (isEmpty(dto.getUseYn())) {
            dto.setUseYn("Y");
        } else {
            dto.setUseYn(dto.getUseYn().trim().toUpperCase());

            if (!"Y".equals(dto.getUseYn()) && !"N".equals(dto.getUseYn())) {
                dto.setUseYn("Y");
            }
        }
    }


    /**
     * 불량코드 prefix 정리
     *
     * 예:
     * - " dcd-dim " → "DCD-DIM"
     * - "DCD-DIM-001" → "DCD-DIM"
     *
     * @param prefix 입력 prefix
     * @return 정리된 prefix
     */
    private String normalizePrefix(String prefix) {

        if (isEmpty(prefix)) {
            return "";
        }

        String result = prefix.trim().toUpperCase();
        result = result.replaceAll("\\s+", "");

        // 사용자가 전체 코드(DCD-DIM-001)를 넣은 경우 prefix만 남긴다.
        result = result.replaceAll("-[0-9]{3}$", "");

        return result;
    }


    /**
     * 불량코드 정리
     *
     * 예:
     * - " dcd-dim-001 " → "DCD-DIM-001"
     *
     * @param code 입력 코드
     * @return 정리된 코드
     */
    private String normalizeCode(String code) {

        if (isEmpty(code)) {
            return "";
        }

        String result = code.trim().toUpperCase();
        result = result.replaceAll("\\s+", "");

        return result;
    }


    /**
     * 문자열 trim 처리
     *
     * @param value 입력 문자열
     * @return trim 결과
     */
    private String trim(String value) {

        if (value == null) {
            return null;
        }

        return value.trim();
    }


    /**
     * 빈 문자열 체크
     *
     * @param value 입력 문자열
     * @return 비어있으면 true
     */
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}