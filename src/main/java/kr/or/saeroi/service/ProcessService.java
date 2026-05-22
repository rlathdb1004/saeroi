package kr.or.saeroi.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.saeroi.dao.ProcessDAO;
import kr.or.saeroi.dto.ItemDTO;
import kr.or.saeroi.dto.ProcessDTO;
import kr.or.saeroi.dto.ProcessDetailDTO;

/**
 * 공정관리 Service
 *
 * 역할:
 * - Controller와 DAO 사이에서 공정관리 업무 로직을 처리한다.
 * - 공정 목록/상세 조회, 등록, 수정, 선택삭제를 처리한다.
 * - 공정상세 이미지/작업표준서 목록, 등록, 수정, 삭제를 처리한다.
 * - 등록/수정 전 필수값 검증과 공정 중복검사를 수행한다.
 * - 완제품/설비 자동완성 기능을 처리한다.
 *
 * 메뉴:
 * - 기준정보관리 > 공정관리
 *
 * 기준:
 * - 품목관리 ItemService 구조 기준
 * - BOM관리 BomService 구조 기준
 * - ServiceImpl 사용 안 함
 */
@Service
public class ProcessService {

    /**
     * 공정관리 DAO
     * - 실제 DB 접근은 DAO에서 처리한다.
     */
    @Autowired
    private ProcessDAO processDAO;


    // =========================================================
    // 1. 공정 조회
    // =========================================================

    /**
     * 공정 목록 조회
     *
     * @param processDTO 검색조건(searchType, searchKeyword)을 담은 DTO
     * @return 공정 목록
     */
    public List<ProcessDTO> getProcessList(ProcessDTO processDTO) {
        return processDAO.selectProcessList(processDTO);
    }


    /**
     * 공정 목록 총 건수 조회
     *
     * @param processDTO 검색조건(searchType, searchKeyword)을 담은 DTO
     * @return 검색조건에 맞는 공정 총 건수
     */
    public int getProcessCount(ProcessDTO processDTO) {
        return processDAO.selectProcessCount(processDTO);
    }


    /**
     * 공정 상세 조회
     *
     * @param procId 공정 ID
     * @return 공정 상세 정보
     */
    public ProcessDTO getProcessDetail(int procId) {
        return processDAO.selectProcessDetail(procId);
    }


    // =========================================================
    // 2. 공정 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 공정 등록
     *
     * 처리 흐름:
     * 1. 필수값 검증
     * 2. 공정 중복검사
     * 3. 공정 등록
     *
     * 반환값:
     * - 1 이상: 등록 성공
     * - 0: 등록 실패
     * - -1: 공정 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param processDTO 등록할 공정 정보
     * @return 등록 처리 결과
     */
    public int addProcess(ProcessDTO processDTO) {

        String validateMessage = validateProcess(processDTO);

        if (validateMessage != null) {
            return -2;
        }

        int duplicateCount = processDAO.selectProcessDuplicateCount(processDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return processDAO.insertProcess(processDTO);
    }


    /**
     * 공정 수정
     *
     * 처리 흐름:
     * 1. 공정 ID 확인
     * 2. 필수값 검증
     * 3. 공정 중복검사
     * 4. 공정 수정
     *
     * 반환값:
     * - 1 이상: 수정 성공
     * - 0: 수정 실패
     * - -1: 공정 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param processDTO 수정할 공정 정보
     * @return 수정 처리 결과
     */
    public int modifyProcess(ProcessDTO processDTO) {

        if (processDTO == null || processDTO.getProcId() == null) {
            return -2;
        }

        String validateMessage = validateProcess(processDTO);

        if (validateMessage != null) {
            return -2;
        }

        int duplicateCount = processDAO.selectProcessDuplicateCount(processDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return processDAO.updateProcess(processDTO);
    }


    /**
     * 공정 선택 삭제
     *
     * 처리 방식:
     * - process_detail 먼저 삭제
     * - process 삭제
     *
     * 주의:
     * - process 테이블에는 use_yn 컬럼이 없다.
     * - 현재 DB 구조를 바꾸지 않는 기준에서는 DELETE 처리한다.
     *
     * @param procIdList 선택한 공정 ID 목록
     * @return 삭제된 공정 건수
     */
    @Transactional
    public int removeProcessList(List<Integer> procIdList) {

        if (procIdList == null || procIdList.isEmpty()) {
            return 0;
        }

        return processDAO.deleteProcessList(procIdList);
    }


    /**
     * 공정코드 중복 여부 확인
     *
     * 기준:
     * - proc_code 단독 중복검사
     * - 수정 시에는 현재 proc_id를 제외하고 검사한다.
     *
     * @param processDTO 공정코드, procId를 담은 DTO
     * @return true: 중복 있음 / false: 중복 없음
     */
    public boolean isDuplicateProcess(ProcessDTO processDTO) {

        if (processDTO == null) {
            return false;
        }

        if (processDTO.getProcCode() == null || processDTO.getProcCode().trim().isEmpty()) {
            return false;
        }

        return processDAO.selectProcessDuplicateCount(processDTO) > 0;
    }


    // =========================================================
    // 3. 공정상세 이미지 / 작업표준서 조회
    // =========================================================

    /**
     * 공정상세 목록 조회
     *
     * 사용 위치:
     * - 공정 상세보기 페이지 하단
     * - 작업표준서 이미지 목록
     *
     * 조건:
     * - process_detail.proc_id2 = process.proc_id
     *
     * @param procId 공정 ID
     * @return 공정상세 이미지/설명 목록
     */
    public List<ProcessDetailDTO> getProcessDetailList(int procId) {

        if (procId <= 0) {
            return Collections.emptyList();
        }

        List<ProcessDetailDTO> processDetailList = processDAO.selectProcessDetailList(procId);

        if (processDetailList == null) {
            return Collections.emptyList();
        }

        return processDetailList;
    }


    /**
     * 공정상세 단건 조회
     *
     * 사용 위치:
     * - 공정상세 수정 전 기존 이미지 경로 확인
     * - 공정상세 삭제 전 기존 이미지 경로 확인
     *
     * @param procDetailId 공정상세 ID
     * @return 공정상세 1건
     */
    public ProcessDetailDTO getProcessDetailOne(int procDetailId) {

        if (procDetailId <= 0) {
            return null;
        }

        return processDAO.selectProcessDetailOne(procDetailId);
    }


    // =========================================================
    // 4. 공정상세 이미지 / 작업표준서 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 공정상세 등록
     *
     * 처리 흐름:
     * 1. 공정 ID 확인
     * 2. 이미지/설명/비고 중 하나 이상 입력 확인
     * 3. 공정상세 등록
     *
     * 반환값:
     * - 1 이상: 등록 성공
     * - 0: 등록 실패
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param processDetailDTO 등록할 공정상세 정보
     * @return 등록 처리 결과
     */
    public int addProcessDetail(ProcessDetailDTO processDetailDTO) {

        String validateMessage = validateProcessDetail(processDetailDTO);

        if (validateMessage != null) {
            return -2;
        }

        return processDAO.insertProcessDetail(processDetailDTO);
    }


    /**
     * 공정상세 수정
     *
     * 처리 흐름:
     * 1. 공정상세 ID 확인
     * 2. 공정 ID 확인
     * 3. 이미지/설명/비고 중 하나 이상 입력 확인
     * 4. 공정상세 수정
     *
     * 설명:
     * - 새 이미지가 넘어오면 proc_picture까지 수정한다.
     * - 새 이미지가 없으면 Mapper에서 기존 proc_picture를 유지한다.
     *
     * 반환값:
     * - 1 이상: 수정 성공
     * - 0: 수정 실패
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param processDetailDTO 수정할 공정상세 정보
     * @return 수정 처리 결과
     */
    public int modifyProcessDetail(ProcessDetailDTO processDetailDTO) {

        if (processDetailDTO == null || processDetailDTO.getProcDetailId() == null) {
            return -2;
        }

        String validateMessage = validateProcessDetail(processDetailDTO);

        if (validateMessage != null) {
            return -2;
        }

        return processDAO.updateProcessDetail(processDetailDTO);
    }


    /**
     * 공정상세 선택 삭제
     *
     * 사용 위치:
     * - 공정 상세보기 페이지의 작업표준서 선택 삭제
     *
     * @param procDetailIdList 선택한 공정상세 ID 목록
     * @return 삭제된 건수
     */
    public int removeProcessDetailList(List<Integer> procDetailIdList) {

        if (procDetailIdList == null || procDetailIdList.isEmpty()) {
            return 0;
        }

        return processDAO.deleteProcessDetailList(procDetailIdList);
    }


    /**
     * 공정상세 단건 삭제
     *
     * 사용 위치:
     * - 필요 시 공정상세 1건만 삭제
     *
     * @param procDetailId 공정상세 ID
     * @return 삭제된 건수
     */
    public int removeProcessDetailOne(int procDetailId) {

        if (procDetailId <= 0) {
            return 0;
        }

        return processDAO.deleteProcessDetailOne(procDetailId);
    }


    // =========================================================
    // 5. 자동완성 / 선택 목록
    // =========================================================

    /**
     * 완제품 자동완성 조회
     *
     * 사용 위치:
     * - 공정 등록 모달의 품목 자동완성
     * - 공정 수정 화면의 품목 자동완성
     *
     * 대상:
     * - item_type = 'FG'
     * - use_yn = 'Y'
     *
     * @param keyword 검색어
     * @return 완제품 후보 목록
     */
    public List<ItemDTO> getProductItemAutoComplete(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        return processDAO.selectProductItemAutoComplete(keyword.trim());
    }


    /**
     * 완제품 선택 목록 조회
     *
     * 사용 위치:
     * - 공정 등록 모달 초기 데이터
     * - 공정 수정 화면 selectbox 구성
     *
     * 대상:
     * - item_type = 'FG'
     *
     * @return 완제품 목록
     */
    public List<ItemDTO> getProductItemList() {

        List<ItemDTO> productItemList = processDAO.selectProductItemList();

        if (productItemList == null) {
            return Collections.emptyList();
        }

        return productItemList;
    }


    /**
     * 설비 자동완성 조회
     *
     * 사용 위치:
     * - 공정 등록 모달의 설비 자동완성
     * - 공정 수정 화면의 설비 자동완성
     *
     * @param keyword 검색어
     * @return 설비 후보 목록
     */
    public List<ProcessDTO> getEquipmentAutoComplete(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        return processDAO.selectEquipmentAutoComplete(keyword.trim());
    }


    /**
     * 설비 선택 목록 조회
     *
     * 사용 위치:
     * - 공정 등록 모달 초기 데이터
     * - 공정 수정 화면 selectbox 구성
     *
     * @return 설비 목록
     */
    public List<ProcessDTO> getEquipmentList() {

        List<ProcessDTO> equipmentList = processDAO.selectEquipmentList();

        if (equipmentList == null) {
            return Collections.emptyList();
        }

        return equipmentList;
    }


    // =========================================================
    // 6. 내부 검증 메서드
    // =========================================================

    /**
     * 공정 등록/수정 전 필수값 검증
     *
     * 현재 공정관리 필수 기준:
     * - 완제품 item_id
     * - 설비 equip_id
     * - 공정코드
     * - 공정명
     *
     * @param processDTO 공정 정보
     * @return 오류 메시지. 문제가 없으면 null
     */
    private String validateProcess(ProcessDTO processDTO) {

        if (processDTO == null) {
            return "공정 정보가 없습니다.";
        }

        if (processDTO.getItemId() == null) {
            return "완제품을 선택하세요.";
        }

        if (processDTO.getEquipId() == null) {
            return "설비를 선택하세요.";
        }

        if (processDTO.getProcCode() == null || processDTO.getProcCode().trim().isEmpty()) {
            return "공정코드를 입력하세요.";
        }

        if (processDTO.getProcName() == null || processDTO.getProcName().trim().isEmpty()) {
            return "공정명을 입력하세요.";
        }

        /*
         * proc_content, remark는 설명/비고 성격이므로 필수 검증하지 않는다.
         * created_date, updated_date는 Mapper에서 SYSDATE로 처리한다.
         */

        return null;
    }


    /**
     * 공정상세 등록/수정 전 필수값 검증
     *
     * 현재 공정상세 필수 기준:
     * - 공정 ID
     * - 이미지, 설명, 비고 중 하나 이상
     *
     * 설명:
     * - 공정상세는 작업표준서 이미지 관리 용도이지만,
     *   설명만 별도 등록할 수도 있으므로 이미지를 무조건 필수로 두지 않는다.
     * - 이미지 확장자/파일 크기 검증은 Controller에서 업로드 파일을 받을 때 처리한다.
     *
     * @param processDetailDTO 공정상세 정보
     * @return 오류 메시지. 문제가 없으면 null
     */
    private String validateProcessDetail(ProcessDetailDTO processDetailDTO) {

        if (processDetailDTO == null) {
            return "공정상세 정보가 없습니다.";
        }

        if (processDetailDTO.getProcId() == null) {
            return "공정 ID가 없습니다.";
        }

        boolean hasPicture = processDetailDTO.getProcPicture() != null
                && !processDetailDTO.getProcPicture().trim().isEmpty();

        boolean hasContent = processDetailDTO.getProcContent() != null
                && !processDetailDTO.getProcContent().trim().isEmpty();

        boolean hasRemark = processDetailDTO.getRemark() != null
                && !processDetailDTO.getRemark().trim().isEmpty();

        if (!hasPicture && !hasContent && !hasRemark) {
            return "이미지, 설명, 비고 중 하나 이상 입력하세요.";
        }

        if (processDetailDTO.getRemark() != null
                && processDetailDTO.getRemark().trim().length() > 30) {
            return "비고는 30자 이내로 입력하세요.";
        }

        return null;
    }
    
    /**
     * 공정코드 자동완성 조회
     *
     * 사용 위치:
     * - 공정 등록 모달
     * - 공정 수정 화면
     *
     * @param keyword 검색어
     * @return 기존 공정코드 후보 목록
     */
    public List<ProcessDTO> getProcCodeAutoComplete(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        return processDAO.selectProcCodeAutoComplete(keyword.trim());
    }
}