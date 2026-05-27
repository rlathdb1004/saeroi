package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.MasterDefectCodeDTO;

/**
 * 기준관리 > 불량코드관리 DAO
 *
 * 기준:
 * - MyBatis SqlSession 사용
 * - namespace: masterDefectCode
 * - 기존 DefectDTO / 품질관리 불량관리 기능과 충돌 방지를 위해 MasterDefectCode로 분리
 */
@Repository
public class MasterDefectCodeDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "masterDefectCode.";


    /**
     * 불량코드 목록 조회
     *
     * @param dto 검색조건 DTO
     * @return 불량코드 목록
     */
    public List<MasterDefectCodeDTO> selectMasterDefectCodeList(MasterDefectCodeDTO dto) {
        return sqlSession.selectList(NAMESPACE + "selectMasterDefectCodeList", dto);
    }


    /**
     * 불량코드 목록 건수 조회
     *
     * @param dto 검색조건 DTO
     * @return 목록 건수
     */
    public int selectMasterDefectCodeCount(MasterDefectCodeDTO dto) {
        return sqlSession.selectOne(NAMESPACE + "selectMasterDefectCodeCount", dto);
    }


    /**
     * 불량코드 상세 조회
     *
     * @param defectId 불량코드 ID
     * @return 불량코드 상세 DTO
     */
    public MasterDefectCodeDTO selectMasterDefectCodeDetail(int defectId) {
        return sqlSession.selectOne(NAMESPACE + "selectMasterDefectCodeDetail", defectId);
    }


    /**
     * 불량코드 등록
     *
     * @param dto 등록 DTO
     * @return 처리 건수
     */
    public int insertMasterDefectCode(MasterDefectCodeDTO dto) {
        return sqlSession.insert(NAMESPACE + "insertMasterDefectCode", dto);
    }


    /**
     * 불량코드 수정
     *
     * @param dto 수정 DTO
     * @return 처리 건수
     */
    public int updateMasterDefectCode(MasterDefectCodeDTO dto) {
        return sqlSession.update(NAMESPACE + "updateMasterDefectCode", dto);
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
        return sqlSession.update(NAMESPACE + "deleteMasterDefectCodeList", defectIdList);
    }


    /**
     * 불량코드 중복 건수 조회
     *
     * 등록 시:
     * - defectId 없음
     *
     * 수정 시:
     * - 현재 defectId 제외하고 중복 체크
     *
     * @param dto 불량코드 DTO
     * @return 중복 건수
     */
    public int selectMasterDefectCodeCountByCode(MasterDefectCodeDTO dto) {
        return sqlSession.selectOne(NAMESPACE + "selectMasterDefectCodeCountByCode", dto);
    }


    /**
     * 불량코드 prefix 목록 조회
     *
     * 예:
     * - DCD-DIM
     * - DCD-CUT
     * - DCD-ADH
     * - DEF-BAR
     *
     * @return prefix 목록
     */
    public List<String> selectDefectCodePrefixList() {
        return sqlSession.selectList(NAMESPACE + "selectDefectCodePrefixList");
    }


    /**
     * prefix 기준 다음 불량코드 자동생성
     *
     * 예:
     * - DCD-DIM -> DCD-DIM-002
     * - DCD-PIN -> DCD-PIN-001
     *
     * @param defectCodePrefix 불량코드 prefix
     * @return 다음 불량코드
     */
    public String selectNextDefectCode(String defectCodePrefix) {

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("defectCodePrefix", defectCodePrefix);

        return sqlSession.selectOne(NAMESPACE + "selectNextDefectCode", paramMap);
    }
}