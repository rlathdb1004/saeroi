package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.MasterClientDTO;

/**
 * 기준관리 > 거래처관리 DAO
 *
 * 기준:
 * - 기존 ClientDTO / ClientDAO와 충돌 방지를 위해 MasterClient 명칭 사용
 * - MyBatis SqlSession 사용
 * - ServiceImpl 사용 안 함
 * - 실제 DELETE 대신 use_yn = 'N' 미사용 처리
 * - 거래처코드는 client_code prefix 기준으로 자동생성
 */
@Repository
public class MasterClientDAO {

    @Autowired
    private SqlSession sqlSession;


    // =========================================================
    // 1. 거래처 목록 / 상세
    // =========================================================

    /**
     * 거래처 목록 조회
     */
    public List<MasterClientDTO> selectMasterClientList(MasterClientDTO masterClientDTO) {
        return sqlSession.selectList("masterClient.selectMasterClientList", masterClientDTO);
    }


    /**
     * 거래처 목록 총 건수 조회
     */
    public int selectMasterClientCount(MasterClientDTO masterClientDTO) {
        return sqlSession.selectOne("masterClient.selectMasterClientCount", masterClientDTO);
    }


    /**
     * 거래처 상세 조회
     */
    public MasterClientDTO selectMasterClientDetail(int clientId) {
        return sqlSession.selectOne("masterClient.selectMasterClientDetail", clientId);
    }


    // =========================================================
    // 2. 거래처 등록 / 수정 / 미사용 처리
    // =========================================================

    /**
     * 거래처 등록
     */
    public int insertMasterClient(MasterClientDTO masterClientDTO) {
        return sqlSession.insert("masterClient.insertMasterClient", masterClientDTO);
    }


    /**
     * 거래처 수정
     */
    public int updateMasterClient(MasterClientDTO masterClientDTO) {
        return sqlSession.update("masterClient.updateMasterClient", masterClientDTO);
    }


    /**
     * 거래처 선택 삭제
     *
     * 처리:
     * - 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리
     */
    public int deleteMasterClientList(List<Integer> clientIdList) {
        return sqlSession.update("masterClient.deleteMasterClientList", clientIdList);
    }


    /**
     * 거래처코드 중복 확인
     *
     * 등록:
     * - clientId null
     *
     * 수정:
     * - 현재 clientId 제외
     */
    public int selectMasterClientCodeCount(MasterClientDTO masterClientDTO) {
        return sqlSession.selectOne("masterClient.selectMasterClientCodeCount", masterClientDTO);
    }


    // =========================================================
    // 3. 거래처코드 자동생성 / prefix
    // =========================================================

    /**
     * 기존 거래처코드 prefix 목록 조회
     *
     * 예:
     * - BP-SUP
     * - BP-CUS
     *
     * 신규 거래처구분이 생기면 직접 입력해서 확장 가능하다.
     */
    public List<String> selectClientCodePrefixList() {
        return sqlSession.selectList("masterClient.selectClientCodePrefixList");
    }


    /**
     * 다음 거래처코드 자동생성
     *
     * 예:
     * - clientCodePrefix = BP-SUP
     * - 기존 최대 코드 = BP-SUP-005
     * - 반환 코드 = BP-SUP-006
     */
    public String selectNextClientCode(String clientCodePrefix) {

        Map<String, Object> paramMap = new HashMap<String, Object>();

        paramMap.put("clientCodePrefix", clientCodePrefix);

        return sqlSession.selectOne("masterClient.selectNextClientCode", paramMap);
    }
}