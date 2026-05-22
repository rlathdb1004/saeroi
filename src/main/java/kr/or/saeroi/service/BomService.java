package kr.or.saeroi.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.saeroi.dao.BomDAO;
import kr.or.saeroi.dto.BomDTO;
import kr.or.saeroi.dto.BomDetailDTO;
import kr.or.saeroi.dto.ItemDTO;

/**
 * BOM관리 Service
 *
 * 역할:
 * - Controller와 DAO 사이에서 BOM관리 업무 로직을 처리한다.
 * - BOM 목록/상세 조회, 등록, 수정, 선택삭제를 처리한다.
 * - 등록/수정 전 필수값 검증과 BOM코드 중복검사를 수행한다.
 * - 완제품/자재 자동완성, BOM코드 자동생성 기능을 처리한다.
 *
 * 메뉴:
 * - 기준정보관리 > BOM관리
 *
 * 기준:
 * - 품목관리 ItemService 구조 기준
 * - ServiceImpl 사용 안 함
 */
@Service
public class BomService {

    /**
     * BOM관리 DAO
     * - 실제 DB 접근은 DAO에서 처리한다.
     */
    @Autowired
    private BomDAO bomDAO;


    // =========================================================
    // 1. BOM 마스터 조회
    // =========================================================

    /**
     * BOM 목록 조회
     *
     * @param bomDTO 검색조건(searchType, searchKeyword)을 담은 DTO
     * @return BOM 목록
     */
    public List<BomDTO> getBomList(BomDTO bomDTO) {
        return bomDAO.selectBomList(bomDTO);
    }


    /**
     * BOM 목록 총 건수 조회
     *
     * @param bomDTO 검색조건(searchType, searchKeyword)을 담은 DTO
     * @return 검색조건에 맞는 BOM 총 건수
     */
    public int getBomCount(BomDTO bomDTO) {
        return bomDAO.selectBomCount(bomDTO);
    }


    /**
     * BOM 상세 기본정보 조회
     *
     * @param bomId BOM ID
     * @return BOM 상세 기본정보
     */
    public BomDTO getBomDetail(int bomId) {
        return bomDAO.selectBomDetail(bomId);
    }


    /**
     * BOM 상세 기본정보 + 구성품 목록 조회
     *
     * 사용 위치:
     * - BOM 상세보기 화면
     *
     * @param bomId BOM ID
     * @return BOM 기본정보와 상세 구성품 목록이 포함된 DTO
     */
    public BomDTO getBomDetailWithItems(int bomId) {

        BomDTO bomDTO = bomDAO.selectBomDetail(bomId);

        if (bomDTO == null) {
            return null;
        }

        List<BomDetailDTO> bomDetailList = bomDAO.selectBomDetailList(bomId);
        bomDTO.setBomDetailList(bomDetailList);

        return bomDTO;
    }


    // =========================================================
    // 2. BOM 마스터 등록 / 수정 / 삭제
    // =========================================================

    /**
     * BOM 마스터만 등록
     *
     * 처리 흐름:
     * 1. 필수값 검증
     * 2. BOM코드 중복검사
     * 3. BOM 등록
     *
     * 반환값:
     * - 1 이상: 등록 성공
     * - 0: 등록 실패
     * - -1: BOM코드 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param bomDTO 등록할 BOM 정보
     * @return 등록 처리 결과
     */
    public int addBom(BomDTO bomDTO) {

        String validateMessage = validateBom(bomDTO);

        if (validateMessage != null) {
            return -2;
        }

        int duplicateCount = bomDAO.selectBomCodeCount(bomDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return bomDAO.insertBom(bomDTO);
    }


    /**
     * BOM 마스터 + 상세 구성품 등록
     *
     * 사용 위치:
     * - BOM 등록 모달에서 완제품과 구성품을 함께 저장할 때
     *
     * 처리 흐름:
     * 1. BOM 마스터 필수값 검증
     * 2. BOM 상세 구성품 검증
     * 3. BOM코드 중복검사
     * 4. BOM 마스터 등록
     * 5. BOM 상세 N건 등록
     *
     * 반환값:
     * - 1 이상: 등록 성공
     * - 0: 등록 실패
     * - -1: BOM코드 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param bomDTO 등록할 BOM 마스터 정보
     * @param bomDetailList 등록할 BOM 상세 구성품 목록
     * @return 등록 처리 결과
     */
    @Transactional
    public int addBom(BomDTO bomDTO, List<BomDetailDTO> bomDetailList) {

        String validateMessage = validateBom(bomDTO);

        if (validateMessage != null) {
            return -2;
        }

        String detailValidateMessage = validateBomDetailList(bomDetailList);

        if (detailValidateMessage != null) {
            return -2;
        }

        int duplicateCount = bomDAO.selectBomCodeCount(bomDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        int insertCount = bomDAO.insertBom(bomDTO);

        if (insertCount <= 0) {
            return 0;
        }

        Integer bomId = bomDTO.getBomId();

        if (bomId == null) {
            return 0;
        }

        for (BomDetailDTO bomDetailDTO : bomDetailList) {

            if (bomDetailDTO == null) {
                continue;
            }

            bomDetailDTO.setBomId(bomId);
            bomDAO.insertBomDetail(bomDetailDTO);
        }

        return insertCount;
    }


    /**
     * BOM 마스터 수정
     *
     * 처리 흐름:
     * 1. 필수값 검증
     * 2. BOM코드 중복검사
     * 3. BOM 수정
     *
     * 반환값:
     * - 1 이상: 수정 성공
     * - 0: 수정 실패
     * - -1: BOM코드 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param bomDTO 수정할 BOM 정보
     * @return 수정 처리 결과
     */
    public int modifyBom(BomDTO bomDTO) {

        if (bomDTO == null || bomDTO.getBomId() == null) {
            return -2;
        }

        String validateMessage = validateBom(bomDTO);

        if (validateMessage != null) {
            return -2;
        }

        int duplicateCount = bomDAO.selectBomCodeCount(bomDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return bomDAO.updateBom(bomDTO);
    }


    /**
     * BOM 마스터 + 상세 구성품 전체 수정
     *
     * 사용 위치:
     * - 상세 화면에서 BOM 기본정보와 구성품 목록을 한 번에 저장할 때
     *
     * 처리 방식:
     * - BOM 마스터는 update
     * - BOM 상세는 기존 구성품 전체 삭제 후 화면에서 넘어온 구성품 재등록
     *
     * 반환값:
     * - 1 이상: 수정 성공
     * - 0: 수정 실패
     * - -1: BOM코드 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param bomDTO 수정할 BOM 마스터 정보
     * @param bomDetailList 수정할 BOM 상세 구성품 목록
     * @return 수정 처리 결과
     */
    @Transactional
    public int modifyBom(BomDTO bomDTO, List<BomDetailDTO> bomDetailList) {

        if (bomDTO == null || bomDTO.getBomId() == null) {
            return -2;
        }

        String validateMessage = validateBom(bomDTO);

        if (validateMessage != null) {
            return -2;
        }

        String detailValidateMessage = validateBomDetailList(bomDetailList);

        if (detailValidateMessage != null) {
            return -2;
        }

        int duplicateCount = bomDAO.selectBomCodeCount(bomDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        int updateCount = bomDAO.updateBom(bomDTO);

        if (updateCount <= 0) {
            return 0;
        }

        bomDAO.deleteBomDetailByBomId(bomDTO.getBomId());

        for (BomDetailDTO bomDetailDTO : bomDetailList) {

            if (bomDetailDTO == null) {
                continue;
            }

            bomDetailDTO.setBomId(bomDTO.getBomId());
            bomDAO.insertBomDetail(bomDetailDTO);
        }

        return updateCount;
    }


    /**
     * BOM 선택 삭제
     *
     * 처리 방식:
     * - 실제 DELETE가 아니라 use_yn = 'N'으로 변경한다.
     * - BOM은 생산, 자재투입, LOT 흐름의 기준정보가 될 수 있으므로
     *   물리 삭제보다 미사용 처리가 안전하다.
     *
     * @param bomIdList 선택한 BOM ID 목록
     * @return 미사용 처리된 건수
     */
    public int removeBomList(List<Integer> bomIdList) {

        if (bomIdList == null || bomIdList.isEmpty()) {
            return 0;
        }

        return bomDAO.deleteBomList(bomIdList);
    }


    /**
     * BOM코드 중복 여부 확인
     *
     * @param bomDTO BOM코드, bomId를 담은 DTO
     * @return true: 중복 있음 / false: 중복 없음
     */
    public boolean isDuplicateBomCode(BomDTO bomDTO) {

        if (bomDTO == null || bomDTO.getBomCode() == null || bomDTO.getBomCode().trim().isEmpty()) {
            return false;
        }

        return bomDAO.selectBomCodeCount(bomDTO) > 0;
    }


    // =========================================================
    // 3. BOM 상세 구성품 조회 / 등록 / 수정 / 삭제
    // =========================================================

    /**
     * BOM 상세 구성품 목록 조회
     *
     * @param bomId BOM ID
     * @return BOM 상세 구성품 목록
     */
    public List<BomDetailDTO> getBomDetailList(int bomId) {
        return bomDAO.selectBomDetailList(bomId);
    }


    /**
     * BOM 상세 구성품 단건 조회
     *
     * @param bomDetailId BOM 상세 ID
     * @return BOM 상세 구성품 단건 정보
     */
    public BomDetailDTO getBomDetailOne(int bomDetailId) {
        return bomDAO.selectBomDetailOne(bomDetailId);
    }


    /**
     * BOM 상세 구성품 등록
     *
     * 반환값:
     * - 1 이상: 등록 성공
     * - 0: 등록 실패
     * - -1: 같은 BOM에 같은 구성품 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param bomDetailDTO 등록할 BOM 상세 구성품
     * @return 등록 처리 결과
     */
    public int addBomDetail(BomDetailDTO bomDetailDTO) {

        String validateMessage = validateBomDetail(bomDetailDTO);

        if (validateMessage != null) {
            return -2;
        }

        int duplicateCount = bomDAO.selectBomDetailItemCount(bomDetailDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return bomDAO.insertBomDetail(bomDetailDTO);
    }


    /**
     * BOM 상세 구성품 수정
     *
     * 반환값:
     * - 1 이상: 수정 성공
     * - 0: 수정 실패
     * - -1: 같은 BOM에 같은 구성품 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param bomDetailDTO 수정할 BOM 상세 구성품
     * @return 수정 처리 결과
     */
    public int modifyBomDetail(BomDetailDTO bomDetailDTO) {

        if (bomDetailDTO == null || bomDetailDTO.getBomDetailId() == null) {
            return -2;
        }

        String validateMessage = validateBomDetail(bomDetailDTO);

        if (validateMessage != null) {
            return -2;
        }

        int duplicateCount = bomDAO.selectBomDetailItemCount(bomDetailDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return bomDAO.updateBomDetail(bomDetailDTO);
    }


    /**
     * BOM 상세 구성품 선택 삭제
     *
     * 처리 방식:
     * - bom_detail 테이블에는 use_yn 컬럼이 없다.
     * - 따라서 BOM 상세 구성품 삭제는 물리 DELETE로 처리한다.
     * - BOM 마스터 삭제는 removeBomList에서 use_yn = 'N'으로 처리한다.
     *
     * @param bomDetailIdList 선택한 BOM 상세 ID 목록
     * @return 삭제된 건수
     */
    public int removeBomDetailList(List<Integer> bomDetailIdList) {

        if (bomDetailIdList == null || bomDetailIdList.isEmpty()) {
            return 0;
        }

        return bomDAO.deleteBomDetailList(bomDetailIdList);
    }


    // =========================================================
    // 4. 자동완성 / 자동생성
    // =========================================================

    /**
     * 완제품 자동완성 조회
     *
     * 사용 위치:
     * - BOM 등록 모달의 완제품 자동완성
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

        return bomDAO.selectProductItemAutoComplete(keyword.trim());
    }


    /**
     * 자재/부자재 자동완성 조회
     *
     * 사용 위치:
     * - BOM 등록 모달의 구성품 자동완성
     * - BOM 상세 화면의 구성품 자동완성
     *
     * 대상:
     * - item_type IN ('RM', 'SM')
     * - use_yn = 'Y'
     *
     * @param keyword 검색어
     * @return 자재/부자재 후보 목록
     */
    public List<ItemDTO> getMaterialItemAutoComplete(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        return bomDAO.selectMaterialItemAutoComplete(keyword.trim());
    }


    /**
     * 완제품 선택 목록 조회
     *
     * 사용 위치:
     * - BOM 등록 모달 초기 데이터
     * - 필요 시 selectbox 구성
     *
     * @return 완제품 목록
     */
    public List<ItemDTO> getProductItemList() {
        return bomDAO.selectProductItemList();
    }


    /**
     * 자재/부자재 선택 목록 조회
     *
     * 사용 위치:
     * - BOM 구성품 선택
     *
     * @return 자재/부자재 목록
     */
    public List<ItemDTO> getMaterialItemList() {
        return bomDAO.selectMaterialItemList();
    }


    /**
     * 다음 BOM코드 자동생성
     *
     * 사용 위치:
     * - BOM 등록 모달에서 완제품 선택 후 자동생성
     *
     * 예:
     * - 완제품 코드: FG-GSK-ION5-EPDM-001
     * - BOM 코드: BOM-FG-GSK-ION5-EPDM-001
     *
     * @param itemId 완제품 품목 ID
     * @return 다음 BOM 코드
     */
    public String getNextBomCode(Integer itemId) {

        if (itemId == null) {
            return "";
        }

        String nextBomCode = bomDAO.selectNextBomCode(itemId);

        if (nextBomCode == null) {
            return "";
        }

        return nextBomCode;
    }


    /**
     * 다음 BOM 버전 조회
     *
     * 사용 위치:
     * - BOM 등록 모달에서 완제품 선택 후 version 자동 세팅
     *
     * @param itemId 완제품 품목 ID
     * @return 다음 BOM 버전
     */
    public int getNextBomVersion(Integer itemId) {

        if (itemId == null) {
            return 1;
        }

        return bomDAO.selectNextBomVersion(itemId);
    }


    // =========================================================
    // 5. Controller 보조용 변환 메서드
    // =========================================================

    /**
     * Controller에서 배열 파라미터로 받은 BOM 상세 값을 List<BomDetailDTO>로 변환한다.
     *
     * 사용 예:
     * - detailItemIds: 구성품 item_id 배열
     * - detailQtys: 구성품 소요량 배열
     * - detailRemarks: 구성품 비고 배열
     *
     * @param detailItemIds 구성품 품목 ID 배열
     * @param detailQtys 구성품 소요량 배열
     * @param detailRemarks 구성품 비고 배열
     * @return BOM 상세 DTO 목록
     */
    public List<BomDetailDTO> makeBomDetailList(Integer[] detailItemIds, Double[] detailQtys, String[] detailRemarks) {

        List<BomDetailDTO> bomDetailList = new ArrayList<BomDetailDTO>();

        if (detailItemIds == null || detailQtys == null) {
            return bomDetailList;
        }

        int size = detailItemIds.length;

        for (int i = 0; i < size; i++) {

            Integer itemId = detailItemIds[i];

            Double qty = null;
            if (i < detailQtys.length) {
                qty = detailQtys[i];
            }

            String remark = null;
            if (detailRemarks != null && i < detailRemarks.length) {
                remark = detailRemarks[i];
            }

            BomDetailDTO bomDetailDTO = new BomDetailDTO();
            bomDetailDTO.setItemId(itemId);
            bomDetailDTO.setQty(qty);
            bomDetailDTO.setRemark(remark);

            bomDetailList.add(bomDetailDTO);
        }

        return bomDetailList;
    }


    // =========================================================
    // 6. 내부 검증 메서드
    // =========================================================

    /**
     * BOM 마스터 등록/수정 전 필수값 검증
     *
     * 현재 BOM관리 필수 기준:
     * - BOM코드
     * - 완제품 item_id
     * - 버전
     *
     * @param bomDTO BOM 정보
     * @return 오류 메시지. 문제가 없으면 null
     */
    private String validateBom(BomDTO bomDTO) {

        if (bomDTO == null) {
            return "BOM 정보가 없습니다.";
        }

        if (bomDTO.getBomCode() == null || bomDTO.getBomCode().trim().isEmpty()) {
            return "BOM코드를 자동생성하세요.";
        }

        if (bomDTO.getItemId() == null) {
            return "완제품을 선택하세요.";
        }

        if (bomDTO.getVersion() == null || bomDTO.getVersion() <= 0) {
            return "BOM 버전은 1 이상이어야 합니다.";
        }

        /*
         * useYn은 화면에서 값이 안 넘어와도 Mapper에서 기본값 Y로 처리 가능하다.
         * 따라서 여기서는 필수 검증하지 않는다.
         */

        return null;
    }


    /**
     * BOM 상세 구성품 단건 필수값 검증
     *
     * 현재 BOM 상세 필수 기준:
     * - BOM ID
     * - 구성품 item_id
     * - 소요량 qty > 0
     *
     * @param bomDetailDTO BOM 상세 정보
     * @return 오류 메시지. 문제가 없으면 null
     */
    private String validateBomDetail(BomDetailDTO bomDetailDTO) {

        if (bomDetailDTO == null) {
            return "BOM 구성품 정보가 없습니다.";
        }

        if (bomDetailDTO.getBomId() == null) {
            return "BOM 정보가 없습니다.";
        }

        if (bomDetailDTO.getItemId() == null) {
            return "구성품을 선택하세요.";
        }

        if (bomDetailDTO.getQty() == null || bomDetailDTO.getQty() <= 0) {
            return "소요량은 0보다 커야 합니다.";
        }

        return null;
    }


    /**
     * BOM 상세 구성품 목록 필수값 검증
     *
     * 검증 기준:
     * - 구성품이 1건 이상 있어야 한다.
     * - 각 구성품 item_id가 있어야 한다.
     * - 각 구성품 소요량은 0보다 커야 한다.
     * - 같은 BOM 안에서 같은 구성품이 중복되면 안 된다.
     *
     * @param bomDetailList BOM 상세 구성품 목록
     * @return 오류 메시지. 문제가 없으면 null
     */
    private String validateBomDetailList(List<BomDetailDTO> bomDetailList) {

        if (bomDetailList == null || bomDetailList.isEmpty()) {
            return "BOM 구성품을 1개 이상 추가하세요.";
        }

        Set<Integer> itemIdSet = new HashSet<Integer>();

        for (BomDetailDTO bomDetailDTO : bomDetailList) {

            if (bomDetailDTO == null) {
                return "BOM 구성품 정보가 없습니다.";
            }

            if (bomDetailDTO.getItemId() == null) {
                return "구성품을 선택하세요.";
            }

            if (bomDetailDTO.getQty() == null || bomDetailDTO.getQty() <= 0) {
                return "소요량은 0보다 커야 합니다.";
            }

            if (itemIdSet.contains(bomDetailDTO.getItemId())) {
                return "같은 구성품이 중복되었습니다.";
            }

            itemIdSet.add(bomDetailDTO.getItemId());
        }

        return null;
    }
}