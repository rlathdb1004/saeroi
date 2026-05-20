package kr.or.saeroi.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.ItemDAO;
import kr.or.saeroi.dto.ClientDTO;
import kr.or.saeroi.dto.ItemDTO;

/**
 * 품목관리 Service
 *
 * 역할:
 * - Controller와 DAO 사이에서 품목관리 업무 로직을 처리한다.
 * - 품목 목록/상세 조회, 등록, 수정, 선택삭제를 처리한다.
 * - 등록/수정 전 필수값 검증과 품목코드 중복검사를 수행한다.
 * - 공급처/납품처 자동완성, 품목코드 자동생성 기능을 처리한다.
 *
 * 메뉴:
 * - 기준정보관리 > 품목관리
 */
@Service
public class ItemService {

    /**
     * 품목관리 DAO
     * - 실제 DB 접근은 DAO에서 처리한다.
     */
    @Autowired
    private ItemDAO itemDAO;


    // =========================================================
    // 1. 품목 조회
    // =========================================================

    /**
     * 품목 목록 조회
     *
     * @param itemDTO 검색조건(searchType, searchKeyword)을 담은 DTO
     * @return 품목 목록
     */
    public List<ItemDTO> getItemList(ItemDTO itemDTO) {
        return itemDAO.selectItemList(itemDTO);
    }


    /**
     * 품목 목록 총 건수 조회
     *
     * @param itemDTO 검색조건(searchType, searchKeyword)을 담은 DTO
     * @return 검색조건에 맞는 품목 총 건수
     */
    public int getItemCount(ItemDTO itemDTO) {
        return itemDAO.selectItemCount(itemDTO);
    }


    /**
     * 품목 상세 조회
     *
     * @param itemId 품목 ID
     * @return 품목 상세 정보
     */
    public ItemDTO getItemDetail(int itemId) {
        return itemDAO.selectItemDetail(itemId);
    }


    // =========================================================
    // 2. 품목 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 품목 등록
     *
     * 처리 흐름:
     * 1. 필수값 검증
     * 2. 품목코드 중복검사
     * 3. 품목 등록
     *
     * 반환값:
     * - 1 이상: 등록 성공
     * - 0: 등록 실패
     * - -1: 품목코드 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param itemDTO 등록할 품목 정보
     * @return 등록 처리 결과
     */
    public int addItem(ItemDTO itemDTO) {

        // DB NOT NULL 오류가 나기 전에 Service에서 먼저 필수값을 검증한다.
        String validateMessage = validateItem(itemDTO);

        if (validateMessage != null) {
            return -2;
        }

        // 품목코드는 업무상 중복되면 안 되므로 등록 전 중복 확인한다.
        int duplicateCount = itemDAO.selectItemCodeCount(itemDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        // 필수값 정상 + 중복 없음이면 등록 처리한다.
        return itemDAO.insertItem(itemDTO);
    }


    /**
     * 품목 수정
     *
     * 처리 흐름:
     * 1. 필수값 검증
     * 2. 품목코드 중복검사
     * 3. 품목 수정
     *
     * 반환값:
     * - 1 이상: 수정 성공
     * - 0: 수정 실패
     * - -1: 품목코드 중복
     * - -2: 필수값 누락 또는 입력값 오류
     *
     * @param itemDTO 수정할 품목 정보
     * @return 수정 처리 결과
     */
    public int modifyItem(ItemDTO itemDTO) {

        // 수정 시에도 필수값 검증은 필요하다.
        String validateMessage = validateItem(itemDTO);

        if (validateMessage != null) {
            return -2;
        }

        // 수정 시에는 Mapper에서 현재 itemId를 제외하고 품목코드 중복 여부를 검사한다.
        int duplicateCount = itemDAO.selectItemCodeCount(itemDTO);

        if (duplicateCount > 0) {
            return -1;
        }

        return itemDAO.updateItem(itemDTO);
    }


    /**
     * 품목 선택 삭제
     *
     * 처리 방식:
     * - 실제 DELETE가 아니라 use_yn = 'N'으로 변경한다.
     * - 기준정보는 생산계획, BOM, 재고 등 다른 테이블에서 참조될 수 있으므로
     *   물리 삭제보다 미사용 처리가 안전하다.
     *
     * @param itemIdList 선택한 품목 ID 목록
     * @return 미사용 처리된 건수
     */
    public int removeItemList(List<Integer> itemIdList) {

        // 선택된 품목이 없으면 DB를 호출하지 않는다.
        if (itemIdList == null || itemIdList.isEmpty()) {
            return 0;
        }

        return itemDAO.deleteItemList(itemIdList);
    }


    /**
     * 품목코드 중복 여부 확인
     *
     * 사용 위치:
     * - 등록/수정 전 검증
     * - 필요 시 Ajax 중복확인
     *
     * @param itemDTO 품목코드, itemId를 담은 DTO
     * @return true: 중복 있음 / false: 중복 없음
     */
    public boolean isDuplicateItemCode(ItemDTO itemDTO) {
        return itemDAO.selectItemCodeCount(itemDTO) > 0;
    }


    // =========================================================
    // 3. 자동완성 / 자동생성
    // =========================================================

    /**
     * 거래처 자동완성 조회
     *
     * 사용 위치:
     * - 품목 등록 모달의 공급처 자동완성
     * - 품목 등록 모달의 납품처 자동완성
     *
     * clientType:
     * - SUP: 공급처
     * - CUS: 납품처/고객사
     *
     * 처리 기준:
     * - clientType이 없으면 조회하지 않는다.
     * - 검색어가 없으면 조회하지 않는다.
     * - 검색어 앞뒤 공백은 제거한다.
     *
     * @param clientType 거래처 구분
     * @param keyword 검색어
     * @return 거래처 후보 목록
     */
    public List<ClientDTO> getClientAutoComplete(String clientType, String keyword) {

        if (clientType == null || clientType.trim().isEmpty()) {
            return Collections.emptyList();
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        return itemDAO.selectClientAutoComplete(clientType.trim(), keyword.trim());
    }


    /**
     * 다음 품목코드 자동생성
     *
     * 사용 위치:
     * - 품목 등록 모달의 자동생성 버튼
     *
     * 예:
     * - itemCodePrefix = FG-GSK-ION5-EPDM
     * - 기존 최대 코드 = FG-GSK-ION5-EPDM-001
     * - 반환 코드 = FG-GSK-ION5-EPDM-002
     *
     * 처리 기준:
     * - prefix가 없으면 빈 문자열 반환
     * - 사용자가 prefix 뒤에 실수로 "-001"까지 입력한 경우에는 그대로 처리하면 안 됨
     *   그래서 Controller/JSP에서도 안내하고, Service에서도 최소한 공백 제거만 한다.
     *
     * @param itemCodePrefix 품목코드 앞부분
     * @return 다음 품목코드
     */
    public String getNextItemCode(String itemCodePrefix) {

        if (itemCodePrefix == null || itemCodePrefix.trim().isEmpty()) {
            return "";
        }

        return itemDAO.selectNextItemCode(itemCodePrefix.trim());
    }


    // =========================================================
    // 4. 내부 검증 메서드
    // =========================================================

    /**
     * 품목 등록/수정 전 필수값 검증
     *
     * 검증 이유:
     * - DB의 NOT NULL은 최후의 방어선이다.
     * - 사용자가 잘못 입력했을 때 DB 오류가 아니라 화면 메시지로 처리하기 위해
     *   Service에서 먼저 검증한다.
     *
     * 현재 품목관리 필수 기준:
     * - 품목코드
     * - 품목명
     * - 품목구분
     * - 공급처
     * - 단위
     *
     * @param itemDTO 품목 정보
     * @return 오류 메시지. 문제가 없으면 null
     */
    private String validateItem(ItemDTO itemDTO) {

        if (itemDTO == null) {
            return "품목 정보가 없습니다.";
        }

        if (itemDTO.getItemCode() == null || itemDTO.getItemCode().trim().isEmpty()) {
            return "품목코드를 자동생성하세요.";
        }

        if (itemDTO.getItemName() == null || itemDTO.getItemName().trim().isEmpty()) {
            return "품목명을 입력하세요.";
        }

        if (itemDTO.getItemType() == null || itemDTO.getItemType().trim().isEmpty()) {
            return "품목구분을 선택하세요.";
        }

        if (itemDTO.getSupplierId() == null) {
            return "공급처를 선택하세요.";
        }

        if (itemDTO.getItemUnit() == null || itemDTO.getItemUnit().trim().isEmpty()) {
            return "단위를 선택하세요.";
        }

        /*
         * useYn은 화면에서 값이 안 넘어와도 Mapper에서 기본값 Y로 처리 가능하다.
         * 따라서 여기서는 필수 검증하지 않는다.
         */

        return null;
    }
}