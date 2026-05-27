package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.SystemUserAuthDTO;

/**
 * 시스템관리 > 사용자/권한관리 DAO
 *
 * 기준:
 * - emp 테이블 기준
 * - MyBatis SqlSession 사용
 * - namespace: systemUserAuth
 * - 권한은 emp.role 그대로 사용
 * - 숫자 role_level 사용 안 함
 */
@Repository
public class SystemUserAuthDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "systemUserAuth.";


    /**
     * 사용자/권한 목록 조회
     *
     * @param dto 검색조건 DTO
     * @return 사용자/권한 목록
     */
    public List<SystemUserAuthDTO> selectSystemUserAuthList(SystemUserAuthDTO dto) {
        return sqlSession.selectList(NAMESPACE + "selectSystemUserAuthList", dto);
    }


    /**
     * 사용자/권한 목록 건수 조회
     *
     * @param dto 검색조건 DTO
     * @return 목록 건수
     */
    public int selectSystemUserAuthCount(SystemUserAuthDTO dto) {
        return sqlSession.selectOne(NAMESPACE + "selectSystemUserAuthCount", dto);
    }


    /**
     * 사용자/권한 상세 조회
     *
     * @param empId 사원 ID
     * @return 사용자/권한 상세 DTO
     */
    public SystemUserAuthDTO selectSystemUserAuthDetail(int empId) {
        return sqlSession.selectOne(NAMESPACE + "selectSystemUserAuthDetail", empId);
    }


    /**
     * 신규계정 생성
     *
     * @param dto 신규계정 DTO
     * @return 처리 건수
     */
    public int insertSystemUserAuth(SystemUserAuthDTO dto) {
        return sqlSession.insert(NAMESPACE + "insertSystemUserAuth", dto);
    }


    /**
     * 계정정보/권한 수정
     *
     * @param dto 수정 DTO
     * @return 처리 건수
     */
    public int updateSystemUserAuth(SystemUserAuthDTO dto) {
        return sqlSession.update(NAMESPACE + "updateSystemUserAuth", dto);
    }


    /**
     * 임시비밀번호 발급
     *
     * @param dto 비밀번호 변경 DTO
     * @return 처리 건수
     */
    public int updateSystemUserAuthPassword(SystemUserAuthDTO dto) {
        return sqlSession.update(NAMESPACE + "updateSystemUserAuthPassword", dto);
    }


    /**
     * 계정 상태 일괄 변경
     *
     * 실제 DELETE 하지 않고 status로 관리한다.
     *
     * @param empIdList 사원 ID 목록
     * @param status 변경할 상태
     * @return 처리 건수
     */
    public int updateSystemUserAuthStatusList(List<Integer> empIdList, String status) {

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("empIdList", empIdList);
        paramMap.put("status", status);

        return sqlSession.update(NAMESPACE + "updateSystemUserAuthStatusList", paramMap);
    }


    /**
     * 사번 중복 건수 조회
     *
     * 등록 시:
     * - empId 없음
     *
     * 수정 시:
     * - 현재 empId 제외하고 중복 체크
     *
     * @param dto 사용자 DTO
     * @return 중복 건수
     */
    public int selectSystemUserAuthCountByEmpno(SystemUserAuthDTO dto) {
        return sqlSession.selectOne(NAMESPACE + "selectSystemUserAuthCountByEmpno", dto);
    }


    /**
     * 이메일 중복 건수 조회
     *
     * 등록 시:
     * - empId 없음
     *
     * 수정 시:
     * - 현재 empId 제외하고 중복 체크
     *
     * @param dto 사용자 DTO
     * @return 중복 건수
     */
    public int selectSystemUserAuthCountByEmail(SystemUserAuthDTO dto) {
        return sqlSession.selectOne(NAMESPACE + "selectSystemUserAuthCountByEmail", dto);
    }


    /**
     * 다음 사번 자동생성
     *
     * 예:
     * - E2026001
     * - E2026002
     *
     * @param empnoPrefix 사번 prefix
     * @return 다음 사번
     */
    public String selectNextEmpno(String empnoPrefix) {

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("empnoPrefix", empnoPrefix);

        return sqlSession.selectOne(NAMESPACE + "selectNextEmpno", paramMap);
    }


    /**
     * 재직 ADMIN 계정 수 조회
     *
     * @return 재직 ADMIN 수
     */
    public int selectActiveAdminCount() {
        return sqlSession.selectOne(NAMESPACE + "selectActiveAdminCount");
    }


    /**
     * 특정 계정을 제외한 재직 ADMIN 계정 수 조회
     *
     * @param empId 제외할 사원 ID
     * @return 해당 계정 제외 재직 ADMIN 수
     */
    public int selectActiveAdminCountExceptEmp(int empId) {
        return sqlSession.selectOne(NAMESPACE + "selectActiveAdminCountExceptEmp", empId);
    }


    /**
     * 권한별 계정 수 조회
     *
     * @return 권한별 계정 수
     */
    public List<Map<String, Object>> selectSystemUserAuthRoleCount() {
        return sqlSession.selectList(NAMESPACE + "selectSystemUserAuthRoleCount");
    }


    /**
     * 상태별 계정 수 조회
     *
     * @return 상태별 계정 수
     */
    public List<Map<String, Object>> selectSystemUserAuthStatusCount() {
        return sqlSession.selectList(NAMESPACE + "selectSystemUserAuthStatusCount");
    }
}