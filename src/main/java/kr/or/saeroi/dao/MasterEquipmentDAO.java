package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.ClientDTO;
import kr.or.saeroi.dto.LineDTO;
import kr.or.saeroi.dto.MasterEquipmentDTO;

/**
 * 기준관리 > 설비관리 DAO
 *
 * 기준:
 * - 사이드바 설비관리 업무 메뉴와 충돌 방지를 위해 MasterEquipment 명칭 사용
 * - MyBatis SqlSession 사용
 * - ServiceImpl 사용 안 함
 * - 설비구분은 고정값이 아니라 equip_code prefix 기준으로 관리
 */
@Repository
public class MasterEquipmentDAO {

    @Autowired
    private SqlSession sqlSession;


    // =========================================================
    // 1. 설비 마스터 목록 / 상세
    // =========================================================

    /**
     * 설비 목록 조회
     */
    public List<MasterEquipmentDTO> selectMasterEquipmentList(MasterEquipmentDTO masterEquipmentDTO) {
        return sqlSession.selectList("masterEquipment.selectMasterEquipmentList", masterEquipmentDTO);
    }


    /**
     * 설비 목록 총 건수 조회
     */
    public int selectMasterEquipmentCount(MasterEquipmentDTO masterEquipmentDTO) {
        return sqlSession.selectOne("masterEquipment.selectMasterEquipmentCount", masterEquipmentDTO);
    }


    /**
     * 설비 상세 조회
     */
    public MasterEquipmentDTO selectMasterEquipmentDetail(int equipId) {
        return sqlSession.selectOne("masterEquipment.selectMasterEquipmentDetail", equipId);
    }


    // =========================================================
    // 2. 설비 마스터 등록 / 수정 / 미사용 처리
    // =========================================================

    /**
     * 설비 등록
     */
    public int insertMasterEquipment(MasterEquipmentDTO masterEquipmentDTO) {
        return sqlSession.insert("masterEquipment.insertMasterEquipment", masterEquipmentDTO);
    }


    /**
     * 설비 수정
     */
    public int updateMasterEquipment(MasterEquipmentDTO masterEquipmentDTO) {
        return sqlSession.update("masterEquipment.updateMasterEquipment", masterEquipmentDTO);
    }


    /**
     * 설비 선택 삭제
     *
     * 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리
     */
    public int deleteMasterEquipmentList(List<Integer> equipIdList) {
        return sqlSession.update("masterEquipment.deleteMasterEquipmentList", equipIdList);
    }


    /**
     * 설비코드 중복 확인
     *
     * 등록:
     * - equipId null
     *
     * 수정:
     * - 현재 equipId 제외
     */
    public int selectMasterEquipmentCodeCount(MasterEquipmentDTO masterEquipmentDTO) {
        return sqlSession.selectOne("masterEquipment.selectMasterEquipmentCodeCount", masterEquipmentDTO);
    }


    // =========================================================
    // 3. 등록/수정 화면용 기준 데이터
    // =========================================================

    /**
     * 라인 목록 조회
     */
    public List<LineDTO> selectLineList() {
        return sqlSession.selectList("masterEquipment.selectLineList");
    }


    /**
     * 거래처 목록 조회
     *
     * 제조사 전용 테이블이 없으므로 client 테이블을 사용한다.
     */
    public List<ClientDTO> selectClientList() {
        return sqlSession.selectList("masterEquipment.selectClientList");
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
     * 신규 설비구분은 이 목록에 없더라도 사용자가 직접 입력 가능하다.
     */
    public List<String> selectEquipCodePrefixList() {
        return sqlSession.selectList("masterEquipment.selectEquipCodePrefixList");
    }


    // =========================================================
    // 4. 자동완성
    // =========================================================

    /**
     * 거래처 자동완성 조회
     */
    public List<ClientDTO> selectClientAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("masterEquipment.selectClientAutoComplete", paramMap);
    }


    /**
     * 라인 자동완성 조회
     */
    public List<LineDTO> selectLineAutoComplete(String keyword) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("keyword", keyword);

        return sqlSession.selectList("masterEquipment.selectLineAutoComplete", paramMap);
    }


    // =========================================================
    // 5. 설비코드 자동생성
    // =========================================================

    /**
     * 다음 설비코드 자동생성
     *
     * 예:
     * - equipCodePrefix = EQ-CUT
     * - 기존 최대 코드 = EQ-CUT-004
     * - 반환 코드 = EQ-CUT-005
     *
     * 신규 prefix도 가능:
     * - equipCodePrefix = EQ-DRY
     * - 기존 코드 없음
     * - 반환 코드 = EQ-DRY-001
     */
    public String selectNextEquipCode(String equipCodePrefix) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("equipCodePrefix", equipCodePrefix);

        return sqlSession.selectOne("masterEquipment.selectNextEquipCode", paramMap);
    }
}