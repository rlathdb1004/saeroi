package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.BomDTO;
import kr.or.saeroi.dto.BomDetailDTO;
import kr.or.saeroi.dto.ItemDTO;

/**
 * BOM관리 DAO
 *
 * 역할:
 * - Service에서 요청한 BOM관리 DB 작업을 MyBatis Mapper로 전달한다.
 * - 실제 SQL은 BomMapper.xml에 작성한다.
 *
 * 연결 Mapper:
 * - namespace: bom
 * - 파일명: BomMapper.xml
 *
 * 기준:
 * - 품목관리 ItemDAO 구조 기준
 * - SqlSession 사용
 * - ServiceImpl 사용 안 함
 */
@Repository
public class BomDAO {

    /**
     * MyBatis SQL 실행 객체
     *
     * 설명:
     * - mybatis 설정에 등록된 sqlSession Bean을 주입받아 사용한다.
     * - Mapper XML의 SQL을 실행하는 역할을 한다.
     */
    @Autowired
    private SqlSession sqlSession;


    // =========================================================
    // BOM 마스터 목록 / 상세
    // =========================================================

    /**
     * BOM 목록 조회
     *
     * 사용 위치:
     * - 기준정보관리 > BOM관리 목록 화면
     *
     * 검색 조건:
     * - searchType
     * - searchKeyword
     *
     * 호출 Mapper:
     * - bom.selectBomList
     */
    public List<BomDTO> selectBomList(BomDTO bomDTO) {
        return sqlSession.selectList("bom.selectBomList", bomDTO);
    }


    /**
     * BOM 목록 총 건수 조회
     *
     * 사용 위치:
     * - 목록 상단의 "총 n건" 표시
     * - Controller 페이징 계산
     *
     * 호출 Mapper:
     * - bom.selectBomCount
     */
    public int selectBomCount(BomDTO bomDTO) {
        return sqlSession.selectOne("bom.selectBomCount", bomDTO);
    }


    /**
     * BOM 상세 조회
     *
     * 사용 위치:
     * - 목록의 상세 버튼 클릭
     * - BOM 상세보기 페이지
     *
     * 조건:
     * - bom_id 기준으로 1건 조회
     *
     * 호출 Mapper:
     * - bom.selectBomDetail
     */
    public BomDTO selectBomDetail(int bomId) {
        return sqlSession.selectOne("bom.selectBomDetail", bomId);
    }


    // =========================================================
    // BOM 마스터 등록 / 수정 / 삭제
    // =========================================================

    /**
     * BOM 등록
     *
     * 사용 위치:
     * - BOM 등록 모달 저장 처리
     *
     * 설명:
     * - bomDTO에 담긴 BOM 정보를 bom 테이블에 INSERT한다.
     * - bom_id 생성은 BomMapper.xml의 insertBom 내부 selectKey에서 처리한다.
     *
     * 호출 Mapper:
     * - bom.insertBom
     */
    public int insertBom(BomDTO bomDTO) {
        return sqlSession.insert("bom.insertBom", bomDTO);
    }


    /**
     * BOM 수정
     *
     * 사용 위치:
     * - BOM 상세 화면 수정 처리
     *
     * 조건:
     * - bom_id 기준으로 수정한다.
     *
     * 호출 Mapper:
     * - bom.updateBom
     */
    public int updateBom(BomDTO bomDTO) {
        return sqlSession.update("bom.updateBom", bomDTO);
    }


    /**
     * BOM 선택 삭제
     *
     * 사용 위치:
     * - PC 목록 화면의 선택 삭제 버튼
     *
     * 처리 방식:
     * - 실제 DELETE가 아니라 use_yn = 'N'으로 변경한다.
     * - BOM은 생산/자재투입/LOT 흐름에서 참조될 수 있으므로 물리 삭제보다 미사용 처리가 안전하다.
     *
     * 호출 Mapper:
     * - bom.deleteBomList
     */
    public int deleteBomList(List<Integer> bomIdList) {
        return sqlSession.update("bom.deleteBomList", bomIdList);
    }


    /**
     * BOM코드 중복 확인
     *
     * 사용 위치:
     * - BOM 등록 전 중복 검사
     * - BOM 수정 전 중복 검사
     *
     * 설명:
     * - 등록 시에는 bomId가 null인 상태로 검사한다.
     * - 수정 시에는 현재 bomId를 제외하고 중복 여부를 검사한다.
     *
     * 호출 Mapper:
     * - bom.selectBomCodeCount
     */
    public int selectBomCodeCount(BomDTO bomDTO) {
        return sqlSession.selectOne("bom.selectBomCodeCount", bomDTO);
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
     * 호출 Mapper:
     * - bom.selectNextBomCode
     */
    public String selectNextBomCode(Integer itemId) {
        return sqlSession.selectOne("bom.selectNextBomCode", itemId);
    }


    /**
     * 다음 BOM 버전 조회
     *
     * 사용 위치:
     * - 동일 완제품에 대해 새 BOM을 등록할 때 version 자동 계산
     *
     * 처리:
     * - 해당 item_id의 기존 최대 version + 1
     * - 기존 BOM이 없으면 1
     *
     * 호출 Mapper:
     * - bom.selectNextBomVersion
     */
    public int selectNextBomVersion(Integer itemId) {
        return sqlSession.selectOne("bom.selectNextBomVersion", itemId);
    }


    // =========================================================
    // BOM 상세 목록 / 단건
    // =========================================================

    /**
     * BOM 상세 구성품 목록 조회
     *
     * 사용 위치:
     * - BOM 상세보기 페이지
     * - 해당 BOM에 연결된 원자재/부자재 목록 출력
     *
     * 조건:
     * - bom_id 기준 조회
     *
     * 호출 Mapper:
     * - bom.selectBomDetailList
     */
    public List<BomDetailDTO> selectBomDetailList(int bomId) {
        return sqlSession.selectList("bom.selectBomDetailList", bomId);
    }


    /**
     * BOM 상세 구성품 단건 조회
     *
     * 사용 위치:
     * - 구성품 수정 또는 중복 확인 보조
     *
     * 조건:
     * - bom_detail_id 기준 조회
     *
     * 호출 Mapper:
     * - bom.selectBomDetailOne
     */
    public BomDetailDTO selectBomDetailOne(int bomDetailId) {
        return sqlSession.selectOne("bom.selectBomDetailOne", bomDetailId);
    }


    // =========================================================
    // BOM 상세 등록 / 수정 / 삭제
    // =========================================================

    /**
     * BOM 상세 등록
     *
     * 사용 위치:
     * - BOM 등록 시 구성품 N건 등록
     * - BOM 상세 화면에서 구성품 추가
     *
     * 설명:
     * - bom_detail_id 생성은 BomMapper.xml의 insertBomDetail 내부 selectKey에서 처리한다.
     *
     * 호출 Mapper:
     * - bom.insertBomDetail
     */
    public int insertBomDetail(BomDetailDTO bomDetailDTO) {
        return sqlSession.insert("bom.insertBomDetail", bomDetailDTO);
    }


    /**
     * BOM 상세 수정
     *
     * 사용 위치:
     * - BOM 상세 화면에서 구성품 소요량/비고 수정
     *
     * 조건:
     * - bom_detail_id 기준으로 수정한다.
     *
     * 호출 Mapper:
     * - bom.updateBomDetail
     */
    public int updateBomDetail(BomDetailDTO bomDetailDTO) {
        return sqlSession.update("bom.updateBomDetail", bomDetailDTO);
    }


    /**
     * BOM 상세 선택 삭제
     *
     * 사용 위치:
     * - BOM 상세 화면의 구성품 선택 삭제
     *
     * 처리 방식:
     * - bom_detail 테이블에는 use_yn 컬럼이 없다.
     * - 따라서 BOM 상세 구성품 삭제는 물리 DELETE로 처리한다.
     * - BOM 마스터 삭제는 use_yn = 'N' 미사용 처리한다.
     *
     * 호출 Mapper:
     * - bom.deleteBomDetailList
     */
    public int deleteBomDetailList(List<Integer> bomDetailIdList) {
        return sqlSession.delete("bom.deleteBomDetailList", bomDetailIdList);
    }


    /**
     * BOM ID 기준 BOM 상세 전체 삭제
     *
     * 사용 위치:
     * - BOM 상세 수정 시 기존 구성품 전체 삭제 후 재등록 방식이 필요할 때
     *
     * 주의:
     * - 일반 선택삭제와 달리 내부 처리용 메서드다.
     *
     * 호출 Mapper:
     * - bom.deleteBomDetailByBomId
     */
    public int deleteBomDetailByBomId(int bomId) {
        return sqlSession.delete("bom.deleteBomDetailByBomId", bomId);
    }


    /**
     * BOM 상세 구성품 중복 확인
     *
     * 사용 위치:
     * - 같은 BOM에 같은 원자재/부자재가 중복 등록되는 것을 방지
     *
     * 조건:
     * - bom_id
     * - item_id
     * - 수정 시 현재 bom_detail_id 제외
     *
     * 호출 Mapper:
     * - bom.selectBomDetailItemCount
     */
    public int selectBomDetailItemCount(BomDetailDTO bomDetailDTO) {
        return sqlSession.selectOne("bom.selectBomDetailItemCount", bomDetailDTO);
    }


    // =========================================================
    // 자동완성 / 선택 데이터
    // =========================================================

    /**
     * 완제품 자동완성 조회
     *
     * 사용 위치:
     * - BOM 등록 모달의 완제품 검색
     *
     * 대상:
     * - item_type = 'FG'
     * - use_yn = 'Y'
     *
     * 파라미터:
     * - keyword: 사용자가 입력한 검색어
     *
     * 호출 Mapper:
     * - bom.selectProductItemAutoComplete
     */
    public List<ItemDTO> selectProductItemAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("bom.selectProductItemAutoComplete", paramMap);
    }


    /**
     * 자재/부자재 자동완성 조회
     *
     * 사용 위치:
     * - BOM 등록 모달의 구성품 검색
     * - BOM 상세 수정 화면의 구성품 검색
     *
     * 대상:
     * - item_type IN ('RM', 'SM')
     * - use_yn = 'Y'
     *
     * 파라미터:
     * - keyword: 사용자가 입력한 검색어
     *
     * 호출 Mapper:
     * - bom.selectMaterialItemAutoComplete
     */
    public List<ItemDTO> selectMaterialItemAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("bom.selectMaterialItemAutoComplete", paramMap);
    }


    /**
     * 완제품 선택 목록 조회
     *
     * 사용 위치:
     * - BOM 등록 모달 초기 데이터
     * - 필요 시 selectbox 구성
     *
     * 대상:
     * - item_type = 'FG'
     * - use_yn = 'Y'
     *
     * 호출 Mapper:
     * - bom.selectProductItemList
     */
    public List<ItemDTO> selectProductItemList() {
        return sqlSession.selectList("bom.selectProductItemList");
    }


    /**
     * 자재/부자재 선택 목록 조회
     *
     * 사용 위치:
     * - BOM 구성품 선택
     *
     * 대상:
     * - item_type IN ('RM', 'SM')
     * - use_yn = 'Y'
     *
     * 호출 Mapper:
     * - bom.selectMaterialItemList
     */
    public List<ItemDTO> selectMaterialItemList() {
        return sqlSession.selectList("bom.selectMaterialItemList");
    }
}