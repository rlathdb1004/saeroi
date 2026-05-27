package kr.or.saeroi.dto;

import java.sql.Date;

/**
 * 기준정보관리 > 사용자/권한관리 DTO
 *
 * 기준:
 * - emp 테이블 기준 사용자/권한관리 전용 DTO
 * - 로그인 ID는 emp.empno 사번 사용
 * - email은 로그인 ID가 아니라 연락용 이메일
 * - 권한은 숫자 레벨 없이 emp.role 그대로 사용
 * - role 값: ADMIN, MANAGER, QC, MAINT, WORKER
 * - 신규계정 생성, 계정정보 수정, 권한 수정, 임시비밀번호 발급에 사용
 * - emp 테이블 기본 컬럼 + 화면 표시용 컬럼 + 검색조건 포함
 * - 품목관리 기준에 맞춰 Lombok 사용하지 않고 getter/setter 명시
 */
public class SystemUserAuthDTO {

    // =========================================================
    // emp 테이블 기본 컬럼
    // =========================================================

    private Integer empId;          // 사원 ID

    private String empno;           // 로그인 ID/사번
    private String empPw;           // 비밀번호 BCrypt 암호화 저장 기준

    private String ename;           // 이름
    private String dept;            // 부서
    private String job;             // 직무

    private Date hireDate;          // 입사일

    private String empTel;          // 전화번호
    private String email;           // 연락 이메일

    private String status;          // 계정/재직 상태: 재직, 휴직, 퇴사, 잠금
    private String role;            // 권한: ADMIN, MANAGER, QC, MAINT, WORKER

    private Date createdDate;       // 등록일
    private Date updatedDate;       // 수정일


    // =========================================================
    // 신규계정 / 임시비밀번호 처리용
    // =========================================================

    /*
     * 신규계정 생성 또는 임시비밀번호 발급 시 화면에 1회 표시할 평문 임시비밀번호.
     *
     * 주의:
     * - DB에는 저장하지 않는다.
     * - DB 저장은 empPw에 BCrypt 암호화된 값으로 저장한다.
     */
    private String tempPassword;

    /*
     * 비밀번호 변경 여부.
     *
     * 예:
     * - 신규계정 생성 시 true
     * - 임시비밀번호 발급 시 true
     * - 일반 정보 수정 시 false
     */
    private Boolean passwordChanged;


    // =========================================================
    // 화면 표시용 변환 컬럼
    // =========================================================

    private String roleName;        // 권한 표시명
    private String statusName;      // 상태 표시명


    // =========================================================
    // 관리자 보호 / 화면 제어용 컬럼
    // =========================================================

    /*
     * 마지막 관리자 여부.
     *
     * 마지막 ADMIN 계정은 권한 변경, 잠금, 퇴사 처리 방지용으로 사용한다.
     */
    private Boolean lastAdmin;

    /*
     * 현재 로그인 사용자 본인 여부.
     *
     * 자기 자신의 ADMIN 권한 강등, 잠금, 퇴사 처리 방지용으로 사용한다.
     */
    private Boolean selfAccount;

    /*
     * 해당 계정이 관리자 권한인지 여부.
     */
    private Boolean adminAccount;


    // =========================================================
    // 검색 조건
    // =========================================================

    /*
     * 검색구분:
     * empno, ename, dept, job, role, status, email, empTel
     */
    private String searchType;

    // 검색어
    private String searchKeyword;


    // =========================================================
    // 페이징 / 화면 보조
    // =========================================================

    private Integer page;           // 현재 페이지
    private Integer size;           // 페이지당 개수


    // =========================================================
    // 기본 생성자
    // =========================================================

    public SystemUserAuthDTO() {
    }


    // =========================================================
    // Getter / Setter
    // =========================================================

    public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public String getEmpno() {
        return empno;
    }

    public void setEmpno(String empno) {
        this.empno = empno;
    }

    public String getEmpPw() {
        return empPw;
    }

    public void setEmpPw(String empPw) {
        this.empPw = empPw;
    }

    public String getEname() {
        return ename;
    }

    public void setEname(String ename) {
        this.ename = ename;
    }

    public String getDept() {
        return dept;
    }

    public void setDept(String dept) {
        this.dept = dept;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public String getEmpTel() {
        return empTel;
    }

    public void setEmpTel(String empTel) {
        this.empTel = empTel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }



    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }



    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }



    public String getTempPassword() {
        return tempPassword;
    }

    public void setTempPassword(String tempPassword) {
        this.tempPassword = tempPassword;
    }

    public Boolean getPasswordChanged() {
        return passwordChanged;
    }

    public void setPasswordChanged(Boolean passwordChanged) {
        this.passwordChanged = passwordChanged;
    }



    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }



    public Boolean getLastAdmin() {
        return lastAdmin;
    }

    public void setLastAdmin(Boolean lastAdmin) {
        this.lastAdmin = lastAdmin;
    }

    public Boolean getSelfAccount() {
        return selfAccount;
    }

    public void setSelfAccount(Boolean selfAccount) {
        this.selfAccount = selfAccount;
    }

    public Boolean getAdminAccount() {
        return adminAccount;
    }

    public void setAdminAccount(Boolean adminAccount) {
        this.adminAccount = adminAccount;
    }



    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }



    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }


    // =========================================================
    // toString
    // =========================================================

    @Override
    public String toString() {
        return "SystemUserAuthDTO [empId=" + empId
                + ", empno=" + empno
                + ", ename=" + ename
                + ", dept=" + dept
                + ", job=" + job
                + ", hireDate=" + hireDate
                + ", empTel=" + empTel
                + ", email=" + email
                + ", status=" + status
                + ", role=" + role
                + ", createdDate=" + createdDate
                + ", updatedDate=" + updatedDate
                + ", passwordChanged=" + passwordChanged
                + ", roleName=" + roleName
                + ", statusName=" + statusName
                + ", lastAdmin=" + lastAdmin
                + ", selfAccount=" + selfAccount
                + ", adminAccount=" + adminAccount
                + ", searchType=" + searchType
                + ", searchKeyword=" + searchKeyword
                + ", page=" + page
                + ", size=" + size
                + "]";
    }
}