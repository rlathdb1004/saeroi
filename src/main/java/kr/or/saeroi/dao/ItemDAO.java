package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ClientDTO;
import kr.or.saeroi.dto.ItemDTO;

/**
 * 품목관리 DAO
 *
 * 역할:
 * - Service에서 요청한 품목관리 DB 작업을 MyBatis Mapper로 전달한다.
 * - 실제 SQL은 itemMapper.xml에 작성되어 있다.
 *
 * 연결 Mapper:
 * - namespace: item
 * - 파일명: itemMapper.xml
 */
@Repository
public class ItemDAO {

    /**
     * MyBatis SQL 실행 객체
     *
     * 설명:
     * - mybatis.xml에 등록된 sqlSession Bean을 주입받아 사용한다.
     * - Mapper XML의 SQL을 실행하는 역할을 한다.
     */
    @Autowired
    private SqlSession sqlSession;


    /**
     * 품목 목록 조회
     *
     * 사용 위치:
     * - 기준정보관리 > 품목관리 목록 화면
     *
     * 검색 조건:
     * - searchType
     * - searchKeyword
     *
     * 호출 Mapper:
     * - item.selectItemList
     */
    public List<ItemDTO> selectItemList(ItemDTO itemDTO) {
        return sqlSession.selectList("item.selectItemList", itemDTO);
    }


    /**
     * 품목 목록 총 건수 조회
     *
     * 사용 위치:
     * - 목록 상단의 "총 n건" 표시
     * - 추후 페이징 계산
     *
     * 호출 Mapper:
     * - item.selectItemCount
     */
    public int selectItemCount(ItemDTO itemDTO) {
        return sqlSession.selectOne("item.selectItemCount", itemDTO);
    }


    /**
     * 품목 상세 조회
     *
     * 사용 위치:
     * - 목록의 상세 버튼 클릭
     * - 품목 상세보기 페이지
     *
     * 조건:
     * - item_id 기준으로 1건 조회
     *
     * 호출 Mapper:
     * - item.selectItemDetail
     */
    public ItemDTO selectItemDetail(int itemId) {
        return sqlSession.selectOne("item.selectItemDetail", itemId);
    }


    /**
     * 품목 등록
     *
     * 사용 위치:
     * - 품목 등록 모달 저장 처리
     *
     * 설명:
     * - itemDTO에 담긴 품목 정보를 item 테이블에 INSERT한다.
     * - item_id 생성은 itemMapper.xml의 insertItem 내부 selectKey에서 처리한다.
     *
     * 호출 Mapper:
     * - item.insertItem
     */
    public int insertItem(ItemDTO itemDTO) {
        return sqlSession.insert("item.insertItem", itemDTO);
    }


    /**
     * 품목 수정
     *
     * 사용 위치:
     * - 품목 수정 처리
     *
     * 조건:
     * - item_id 기준으로 수정한다.
     *
     * 호출 Mapper:
     * - item.updateItem
     */
    public int updateItem(ItemDTO itemDTO) {
        return sqlSession.update("item.updateItem", itemDTO);
    }


    /**
     * 품목 선택 삭제
     *
     * 사용 위치:
     * - PC 목록 화면의 선택 삭제 버튼
     *
     * 처리 방식:
     * - 실제 DELETE가 아니라 use_yn = 'N'으로 변경한다.
     * - 기준정보는 다른 테이블에서 참조될 수 있으므로 물리 삭제보다 미사용 처리가 안전하다.
     *
     * 호출 Mapper:
     * - item.deleteItemList
     */
    public int deleteItemList(List<Integer> itemIdList) {
        return sqlSession.update("item.deleteItemList", itemIdList);
    }


    /**
     * 품목코드 중복 확인
     *
     * 사용 위치:
     * - 품목 등록 전 중복 검사
     * - 품목 수정 전 중복 검사
     *
     * 설명:
     * - 등록 시에는 itemId가 null인 상태로 검사한다.
     * - 수정 시에는 현재 itemId를 제외하고 중복 여부를 검사한다.
     *
     * 호출 Mapper:
     * - item.selectItemCodeCount
     */
    public int selectItemCodeCount(ItemDTO itemDTO) {
        return sqlSession.selectOne("item.selectItemCodeCount", itemDTO);
    }


    /**
     * 거래처 자동완성 조회
     *
     * 사용 위치:
     * - 품목 등록 모달의 공급처 자동완성
     * - 품목 등록 모달의 납품처 자동완성
     *
     * 파라미터:
     * - clientType: SUP 또는 CUS
     *   SUP = 공급처
     *   CUS = 납품처/고객사
     *
     * - keyword: 사용자가 입력한 검색어
     *
     * 처리 방식:
     * - Mapper XML에 여러 값을 넘겨야 하므로 Map에 담아서 전달한다.
     *
     * 호출 Mapper:
     * - item.selectClientAutoComplete
     */
    public List<ClientDTO> selectClientAutoComplete(String clientType, String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("clientType", clientType);
        paramMap.put("keyword", keyword);

        return sqlSession.selectList("item.selectClientAutoComplete", paramMap);
    }


    /**
     * 다음 품목코드 자동생성
     *
     * 사용 위치:
     * - 품목 등록 모달에서 "자동생성" 버튼 클릭
     *
     * 예:
     * - itemCodePrefix = FG-GSK-ION5-EPDM
     * - 기존 최대 코드 = FG-GSK-ION5-EPDM-001
     * - 반환 코드 = FG-GSK-ION5-EPDM-002
     *
     * 처리 방식:
     * - Mapper에서 prefix 기준으로 기존 품목코드의 마지막 3자리 번호를 찾는다.
     * - 가장 큰 번호 + 1을 해서 다음 품목코드를 만든다.
     *
     * 호출 Mapper:
     * - item.selectNextItemCode
     */
    public String selectNextItemCode(String itemCodePrefix) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("itemCodePrefix", itemCodePrefix);

        return sqlSession.selectOne("item.selectNextItemCode", paramMap);
    }
}