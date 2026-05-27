package kr.or.saeroi.service;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.SystemUserAuthDAO;
import kr.or.saeroi.dto.SystemUserAuthDTO;

/**
 * 기준정보관리 > 사용자/권한관리 Service
 *
 * 기준:
 * - ServiceImpl 만들지 않음
 * - emp 테이블 기준
 * - 로그인 ID는 emp.empno 사번 사용
 * - email은 로그인 ID가 아니라 연락용 이메일
 * - 권한은 emp.role 그대로 사용
 * - role 값: ADMIN, MANAGER, QC, MAINT, WORKER
 * - 숫자 role_level 사용 안 함
 * - 실제 DELETE 없음
 * - 계정 사용 여부는 status로 관리: 재직, 휴직, 퇴사, 잠금
 * - 신규계정/임시비밀번호는 BCrypt 암호화 후 emp_pw 저장
 * - 전화번호는 입력은 유연하게 받고 010-1111-1111 형식으로 정규화
 */
@Service
public class SystemUserAuthService {

    @Autowired
    private SystemUserAuthDAO systemUserAuthDAO;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;


    private static final List<String> ROLE_LIST = Arrays.asList(
            "ADMIN", "MANAGER", "QC", "MAINT", "WORKER"
    );

    private static final List<String> STATUS_LIST = Arrays.asList(
            "재직", "휴직", "퇴사", "잠금"
    );

    private static final String DEFAULT_ROLE = "WORKER";
    private static final String DEFAULT_STATUS = "재직";


    // =========================================================
    // 1. 목록 / 건수 / 상세
    // =========================================================

    public List<SystemUserAuthDTO> selectSystemUserAuthList(SystemUserAuthDTO dto) {
        normalizeSearchDTO(dto);
        return systemUserAuthDAO.selectSystemUserAuthList(dto);
    }


    public int selectSystemUserAuthCount(SystemUserAuthDTO dto) {
        normalizeSearchDTO(dto);
        return systemUserAuthDAO.selectSystemUserAuthCount(dto);
    }


    public SystemUserAuthDTO selectSystemUserAuthDetail(int empId) {

        if (empId <= 0) {
            throw new IllegalArgumentException("조회할 사용자 정보가 없습니다.");
        }

        SystemUserAuthDTO detail = systemUserAuthDAO.selectSystemUserAuthDetail(empId);

        if (detail == null) {
            throw new IllegalArgumentException("조회된 사용자 정보가 없습니다.");
        }

        return detail;
    }


    // =========================================================
    // 2. 신규계정 생성
    // =========================================================

    /**
     * 신규계정 생성
     *
     * 처리 기준:
     * - 로그인 ID는 empno 사용
     * - 사번 미입력 시 자동생성: E + 현재연도 + 3자리 순번
     * - 권한 미입력 시 WORKER
     * - 상태 미입력 시 재직
     * - 임시비밀번호 생성 후 BCrypt 암호화 저장
     * - 화면에는 tempPassword를 1회 표시할 수 있도록 DTO에 담아 반환
     *
     * @param dto 신규계정 DTO
     * @return 생성 결과 DTO
     */
    public SystemUserAuthDTO insertSystemUserAuth(SystemUserAuthDTO dto) {

        if (dto == null) {
            throw new IllegalArgumentException("등록할 사용자 정보가 없습니다.");
        }

        normalizeUserDTO(dto);

        if (isEmpty(dto.getEmpno())) {
            dto.setEmpno(selectNextEmpno());
        }

        validateRequiredForInsert(dto);

        checkDuplicateEmpno(dto);

        String tempPassword = generateTempPassword();
        String encodedPassword = passwordEncoder.encode(tempPassword);

        dto.setEmpPw(encodedPassword);
        dto.setTempPassword(tempPassword);
        dto.setPasswordChanged(true);

        int result = systemUserAuthDAO.insertSystemUserAuth(dto);

        if (result <= 0) {
            throw new IllegalArgumentException("신규계정 생성에 실패했습니다.");
        }

        return dto;
    }


    // =========================================================
    // 3. 계정정보/권한 수정
    // =========================================================

    /**
     * 계정정보/권한 수정
     *
     * 처리 기준:
     * - empno, emp_pw는 일반 수정 대상에서 제외
     * - 권한/상태 변경 시 마지막 ADMIN 보호
     * - 로그인 사용자가 자기 자신의 ADMIN 권한을 낮추거나 잠그지 못하게 보호
     *
     * @param dto 수정 DTO
     * @param loginEmpId 현재 로그인 사용자 emp_id
     * @return 처리 건수
     */
    public int updateSystemUserAuth(SystemUserAuthDTO dto, Integer loginEmpId) {

        if (dto == null || dto.getEmpId() == null) {
            throw new IllegalArgumentException("수정할 사용자 정보가 없습니다.");
        }

        normalizeUserDTO(dto);

        validateRequiredForUpdate(dto);

        SystemUserAuthDTO before =
                systemUserAuthDAO.selectSystemUserAuthDetail(dto.getEmpId());

        if (before == null) {
            throw new IllegalArgumentException("수정할 사용자 정보가 없습니다.");
        }

        validateAdminProtection(before, dto, loginEmpId);

        return systemUserAuthDAO.updateSystemUserAuth(dto);
    }


    // =========================================================
    // 4. 임시비밀번호 발급
    // =========================================================

    /**
     * 임시비밀번호 발급
     *
     * 처리 기준:
     * - 새 임시비밀번호 생성
     * - BCrypt 암호화 후 emp_pw 업데이트
     * - 평문 임시비밀번호는 화면에 1회 표시할 수 있도록 DTO에 담아 반환
     *
     * @param empId 대상 emp_id
     * @return 임시비밀번호 포함 DTO
     */
    public SystemUserAuthDTO resetTempPassword(Integer empId) {

        if (empId == null || empId <= 0) {
            throw new IllegalArgumentException("임시비밀번호를 발급할 사용자 정보가 없습니다.");
        }

        SystemUserAuthDTO target =
                systemUserAuthDAO.selectSystemUserAuthDetail(empId);

        if (target == null) {
            throw new IllegalArgumentException("임시비밀번호를 발급할 사용자 정보가 없습니다.");
        }

        String tempPassword = generateTempPassword();
        String encodedPassword = passwordEncoder.encode(tempPassword);

        SystemUserAuthDTO updateDTO = new SystemUserAuthDTO();
        updateDTO.setEmpId(empId);
        updateDTO.setEmpPw(encodedPassword);

        int result = systemUserAuthDAO.updateSystemUserAuthPassword(updateDTO);

        if (result <= 0) {
            throw new IllegalArgumentException("임시비밀번호 발급에 실패했습니다.");
        }

        target.setTempPassword(tempPassword);
        target.setPasswordChanged(true);

        return target;
    }


    // =========================================================
    // 5. 계정 상태 일괄 변경
    // =========================================================

    /**
     * 계정 상태 일괄 변경
     *
     * 처리 기준:
     * - 실제 DELETE 하지 않음
     * - status 값으로 계정 상태 관리
     * - 마지막 ADMIN 잠금/퇴사/휴직 방지
     * - 자기 자신 잠금/퇴사/휴직 방지
     *
     * @param empIdList 대상 emp_id 목록
     * @param status 변경할 상태
     * @param loginEmpId 현재 로그인 사용자 emp_id
     * @return 처리 건수
     */
    public int updateSystemUserAuthStatusList(
            List<Integer> empIdList,
            String status,
            Integer loginEmpId) {

        if (empIdList == null || empIdList.isEmpty()) {
            throw new IllegalArgumentException("상태를 변경할 계정을 선택하세요.");
        }

        status = normalizeStatus(status);

        if (!STATUS_LIST.contains(status)) {
            throw new IllegalArgumentException("사용할 수 없는 계정 상태입니다.");
        }

        for (Integer empId : empIdList) {

            if (empId == null || empId <= 0) {
                throw new IllegalArgumentException("잘못된 사용자 정보가 포함되어 있습니다.");
            }

            SystemUserAuthDTO before =
                    systemUserAuthDAO.selectSystemUserAuthDetail(empId);

            if (before == null) {
                throw new IllegalArgumentException("조회되지 않는 사용자 정보가 포함되어 있습니다.");
            }

            SystemUserAuthDTO after = new SystemUserAuthDTO();
            after.setEmpId(before.getEmpId());
            after.setRole(before.getRole());
            after.setStatus(status);

            validateAdminProtection(before, after, loginEmpId);
        }

        return systemUserAuthDAO.updateSystemUserAuthStatusList(empIdList, status);
    }


    // =========================================================
    // 6. 중복 체크 / 자동생성 / 통계
    // =========================================================

    /**
     * 사번 중복 체크
     *
     * 로그인 ID는 empno 기준이다.
     *
     * @param dto 사용자 DTO
     * @return 중복 건수
     */
    public int selectSystemUserAuthCountByEmpno(SystemUserAuthDTO dto) {

        if (dto == null || isEmpty(dto.getEmpno())) {
            return 0;
        }

        dto.setEmpno(normalizeUpper(dto.getEmpno()));

        return systemUserAuthDAO.selectSystemUserAuthCountByEmpno(dto);
    }


    /**
     * 연락 이메일 중복 체크
     *
     * 현재 기준:
     * - email은 로그인 ID가 아니라 연락용 이메일이다.
     * - 필수 검증으로 사용하지 않는다.
     * - 필요 시 Ajax 확인용으로만 사용 가능하다.
     *
     * @param dto 사용자 DTO
     * @return 중복 건수
     */
    public int selectSystemUserAuthCountByEmail(SystemUserAuthDTO dto) {

        if (dto == null || isEmpty(dto.getEmail())) {
            return 0;
        }

        dto.setEmail(trim(dto.getEmail()));

        return systemUserAuthDAO.selectSystemUserAuthCountByEmail(dto);
    }


    /**
     * 다음 사번 자동생성
     *
     * 예:
     * - E2026001
     * - E2026013
     *
     * @return 다음 사번
     */
    public String selectNextEmpno() {

        String empnoPrefix = "E" + LocalDate.now().getYear();

        return systemUserAuthDAO.selectNextEmpno(empnoPrefix);
    }


    public int selectActiveAdminCount() {
        return systemUserAuthDAO.selectActiveAdminCount();
    }


    public List<Map<String, Object>> selectSystemUserAuthRoleCount() {
        return systemUserAuthDAO.selectSystemUserAuthRoleCount();
    }


    public List<Map<String, Object>> selectSystemUserAuthStatusCount() {
        return systemUserAuthDAO.selectSystemUserAuthStatusCount();
    }


    // =========================================================
    // 7. 내부 검증 메소드
    // =========================================================

    private void validateRequiredForInsert(SystemUserAuthDTO dto) {

        if (isEmpty(dto.getEmpno())) {
            throw new IllegalArgumentException("로그인 ID/사번을 입력하세요.");
        }

        if (isEmpty(dto.getEname())) {
            throw new IllegalArgumentException("이름을 입력하세요.");
        }

        if (isEmpty(dto.getRole())) {
            throw new IllegalArgumentException("권한을 선택하세요.");
        }

        if (isEmpty(dto.getStatus())) {
            throw new IllegalArgumentException("상태를 선택하세요.");
        }

        validateRoleAndStatus(dto);
    }


    private void validateRequiredForUpdate(SystemUserAuthDTO dto) {

        if (dto.getEmpId() == null || dto.getEmpId() <= 0) {
            throw new IllegalArgumentException("수정할 사용자 정보가 없습니다.");
        }

        if (isEmpty(dto.getEname())) {
            throw new IllegalArgumentException("이름을 입력하세요.");
        }

        if (isEmpty(dto.getRole())) {
            throw new IllegalArgumentException("권한을 선택하세요.");
        }

        if (isEmpty(dto.getStatus())) {
            throw new IllegalArgumentException("상태를 선택하세요.");
        }

        validateRoleAndStatus(dto);
    }


    private void validateRoleAndStatus(SystemUserAuthDTO dto) {

        if (!ROLE_LIST.contains(dto.getRole())) {
            throw new IllegalArgumentException("사용할 수 없는 권한입니다.");
        }

        if (!STATUS_LIST.contains(dto.getStatus())) {
            throw new IllegalArgumentException("사용할 수 없는 계정 상태입니다.");
        }
    }


    private void checkDuplicateEmpno(SystemUserAuthDTO dto) {

        int count = systemUserAuthDAO.selectSystemUserAuthCountByEmpno(dto);

        if (count > 0) {
            throw new IllegalArgumentException("이미 등록된 로그인 ID/사번입니다.");
        }
    }


    /**
     * 관리자 보호 검증
     *
     * 방어 기준:
     * - 마지막 재직 ADMIN은 권한 변경 불가
     * - 마지막 재직 ADMIN은 재직 외 상태로 변경 불가
     * - 로그인 사용자가 자기 자신의 ADMIN 권한을 낮추거나 잠금/퇴사/휴직 처리 불가
     */
    private void validateAdminProtection(
            SystemUserAuthDTO before,
            SystemUserAuthDTO after,
            Integer loginEmpId) {

        if (before == null || after == null) {
            throw new IllegalArgumentException("사용자 권한 검증 정보가 없습니다.");
        }

        boolean targetIsActiveAdmin =
                "ADMIN".equals(before.getRole())
                && DEFAULT_STATUS.equals(before.getStatus());

        boolean willNotBeActiveAdmin =
                !"ADMIN".equals(after.getRole())
                || !DEFAULT_STATUS.equals(after.getStatus());

        if (targetIsActiveAdmin && willNotBeActiveAdmin) {

            int activeAdminCountExceptTarget =
                    systemUserAuthDAO.selectActiveAdminCountExceptEmp(before.getEmpId());

            if (activeAdminCountExceptTarget <= 0) {
                throw new IllegalArgumentException(
                        "마지막 관리자 계정은 권한 변경 또는 비활성 처리할 수 없습니다."
                );
            }
        }

        boolean isSelf =
                loginEmpId != null
                && before.getEmpId() != null
                && loginEmpId.intValue() == before.getEmpId().intValue();

        if (isSelf && "ADMIN".equals(before.getRole()) && willNotBeActiveAdmin) {
            throw new IllegalArgumentException(
                    "본인의 관리자 권한을 낮추거나 계정을 비활성 처리할 수 없습니다."
            );
        }

        if (isSelf && !DEFAULT_STATUS.equals(after.getStatus())) {
            throw new IllegalArgumentException(
                    "본인 계정은 휴직, 퇴사, 잠금 처리할 수 없습니다."
            );
        }
    }


    // =========================================================
    // 8. 내부 정리 메소드
    // =========================================================

    private void normalizeSearchDTO(SystemUserAuthDTO dto) {

        if (dto == null) {
            return;
        }

        dto.setSearchType(trim(dto.getSearchType()));
        dto.setSearchKeyword(trim(dto.getSearchKeyword()));
    }


    private void normalizeUserDTO(SystemUserAuthDTO dto) {

        if (dto == null) {
            return;
        }

        dto.setEmpno(normalizeUpper(dto.getEmpno()));
        dto.setEname(trim(dto.getEname()));
        dto.setDept(trim(dto.getDept()));
        dto.setJob(trim(dto.getJob()));
        dto.setEmpTel(normalizePhone(dto.getEmpTel()));
        dto.setEmail(trim(dto.getEmail()));

        dto.setRole(normalizeRole(dto.getRole()));
        dto.setStatus(normalizeStatus(dto.getStatus()));
    }


    private String normalizeRole(String role) {

        if (isEmpty(role)) {
            return DEFAULT_ROLE;
        }

        return role.trim().toUpperCase();
    }


    private String normalizeStatus(String status) {

        if (isEmpty(status)) {
            return DEFAULT_STATUS;
        }

        return status.trim();
    }


    private String normalizeUpper(String value) {

        if (isEmpty(value)) {
            return "";
        }

        return value.trim().toUpperCase();
    }


    /**
     * 전화번호 정규화
     *
     * 허용:
     * - 01011111111
     * - 010.1111.1111
     * - 010-1111-1111
     * - 010 1111 1111
     *
     * 저장:
     * - 010-1111-1111
     *
     * @param value 입력 전화번호
     * @return 정규화된 전화번호
     */
    private String normalizePhone(String value) {

        if (isEmpty(value)) {
            return null;
        }

        String onlyNumber = value.replaceAll("[^0-9]", "");

        if (onlyNumber.length() == 11) {
            return onlyNumber.replaceAll("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        }

        if (onlyNumber.length() == 10) {
            return onlyNumber.replaceAll("(\\d{2,3})(\\d{3,4})(\\d{4})", "$1-$2-$3");
        }

        throw new IllegalArgumentException("전화번호 형식이 올바르지 않습니다. 예: 010-1111-1111");
    }


    private String trim(String value) {

        if (value == null) {
            return null;
        }

        return value.trim();
    }


    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }


    // =========================================================
    // 9. 임시비밀번호 생성
    // =========================================================

    /**
     * 임시비밀번호 생성
     *
     * 예:
     * - Saeroi@4821
     * - Saeroi@7392
     *
     * @return 임시비밀번호
     */
    private String generateTempPassword() {

        SecureRandom random = new SecureRandom();

        int number = random.nextInt(9000) + 1000;

        return "Saeroi@" + number;
    }
}