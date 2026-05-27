package kr.or.saeroi.controller;

import java.lang.reflect.Method;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.saeroi.dto.SystemUserAuthDTO;
import kr.or.saeroi.service.SystemUserAuthService;

/**
 * 기준정보관리 > 사용자/권한관리 Controller
 *
 * 기준:
 * - URL: /system/userauth
 * - JSP 위치: /WEB-INF/views/master/userauth.jsp
 * - 상세 JSP 위치: /WEB-INF/views/master/userauthDetail.jsp
 * - Tiles return: master/userauth.tiles, master/userauthDetail.tiles
 * - emp 테이블 기준
 * - 로그인 ID는 emp.empno 사번 사용
 * - email은 로그인 ID가 아니라 연락용 이메일
 * - 권한은 emp.role 그대로 사용
 * - role 값: ADMIN, MANAGER, QC, MAINT, WORKER
 * - 숫자 role_level 사용 안 함
 * - 실제 DELETE 없음
 * - 계정 사용 여부는 status로 관리: 재직, 휴직, 퇴사, 잠금
 * - 신규계정/임시비밀번호는 Service에서 BCrypt 암호화 후 저장
 */
@Controller
@RequestMapping("/system")
public class SystemUserAuthController {

    @Autowired
    private SystemUserAuthService systemUserAuthService;


    // =========================================================
    // 1. 사용자/권한 목록
    // =========================================================

    /**
     * 사용자/권한관리 목록 화면
     *
     * 요청:
     * - GET /system/userauth
     */
    @RequestMapping(value = "/userauth", method = RequestMethod.GET)
    public String userAuthList(
            @ModelAttribute SystemUserAuthDTO systemUserAuthDTO,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size,
            Model model) {

        if (size != 5 && size != 10 && size != 20 && size != 30) {
            size = 5;
        }

        if (page < 1) {
            page = 1;
        }

        List<SystemUserAuthDTO> allUserAuthList =
                systemUserAuthService.selectSystemUserAuthList(systemUserAuthDTO);

        if (allUserAuthList == null) {
            allUserAuthList = Collections.emptyList();
        }

        int userAuthCount =
                systemUserAuthService.selectSystemUserAuthCount(systemUserAuthDTO);

        if (userAuthCount < 0) {
            userAuthCount = 0;
        }

        int totalPage = (int) Math.ceil((double) userAuthCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        if (page > totalPage) {
            page = totalPage;
        }

        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allUserAuthList.size());

        List<SystemUserAuthDTO> userAuthList = Collections.emptyList();

        if (fromIndex < allUserAuthList.size()) {
            userAuthList = allUserAuthList.subList(fromIndex, toIndex);
        }

        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        Map<String, Object> pageInfo = new HashMap<String, Object>();
        pageInfo.put("page", page);
        pageInfo.put("size", size);
        pageInfo.put("totalCount", userAuthCount);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("hasPrev", page > 1);
        pageInfo.put("hasNext", page < totalPage);
        pageInfo.put("prevPage", page - 1);
        pageInfo.put("nextPage", page + 1);

        List<Map<String, Object>> roleCountList =
                systemUserAuthService.selectSystemUserAuthRoleCount();

        List<Map<String, Object>> statusCountList =
                systemUserAuthService.selectSystemUserAuthStatusCount();

        model.addAttribute("userAuthList", userAuthList);
        model.addAttribute("userAuthCount", userAuthCount);
        model.addAttribute("systemUserAuthDTO", systemUserAuthDTO);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/system/userauth");

        model.addAttribute("roleCountList", roleCountList);
        model.addAttribute("statusCountList", statusCountList);

        return "master/userauth.tiles";
    }


    // =========================================================
    // 2. 사용자/권한 상세
    // =========================================================

    /**
     * 사용자/권한관리 상세 화면
     *
     * 요청:
     * - GET /system/userauth/detail?empId=1
     */
    @RequestMapping(value = "/userauth/detail", method = RequestMethod.GET)
    public String userAuthDetail(
            @RequestParam("empId") Integer empId,
            Model model,
            RedirectAttributes rttr) {

        try {
            SystemUserAuthDTO userAuthDetail =
                    systemUserAuthService.selectSystemUserAuthDetail(empId);

            model.addAttribute("userAuthDetail", userAuthDetail);

            return "master/userauthDetail.tiles";

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/system/userauth";
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "사용자 상세 조회 중 오류가 발생했습니다.");
            return "redirect:/system/userauth";
        }
    }


    // =========================================================
    // 3. 신규계정 생성
    // =========================================================

    /**
     * 신규계정 생성
     *
     * 요청:
     * - POST /system/userauth/add
     *
     * 처리:
     * - 로그인 ID는 empno 사용
     * - empno 미입력 시 자동생성
     * - 임시비밀번호 생성
     * - BCrypt 암호화 후 emp_pw 저장
     * - 평문 임시비밀번호는 화면에 1회 표시
     */
    @RequestMapping(value = "/userauth/add", method = RequestMethod.POST)
    public String addUserAuth(
            @ModelAttribute SystemUserAuthDTO systemUserAuthDTO,
            RedirectAttributes rttr) {

        try {
            SystemUserAuthDTO resultDTO =
                    systemUserAuthService.insertSystemUserAuth(systemUserAuthDTO);

            rttr.addFlashAttribute("msg", "신규계정이 생성되었습니다.");
            rttr.addFlashAttribute("tempPassword", resultDTO.getTempPassword());
            rttr.addFlashAttribute("tempPasswordEmpno", resultDTO.getEmpno());
            rttr.addFlashAttribute("tempPasswordEname", resultDTO.getEname());

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "신규계정 생성 중 오류가 발생했습니다.");
        }

        return "redirect:/system/userauth";
    }


    // =========================================================
    // 4. 계정정보/권한 수정
    // =========================================================

    /**
     * 계정정보/권한 수정
     *
     * 요청:
     * - POST /system/userauth/modify
     */
    @RequestMapping(value = "/userauth/modify", method = RequestMethod.POST)
    public String modifyUserAuth(
            @ModelAttribute SystemUserAuthDTO systemUserAuthDTO,
            HttpSession session,
            RedirectAttributes rttr) {

        Integer empId = systemUserAuthDTO.getEmpId();
        Integer loginEmpId = getLoginEmpId(session);

        try {
            int result =
                    systemUserAuthService.updateSystemUserAuth(systemUserAuthDTO, loginEmpId);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "사용자 정보가 수정되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "수정된 사용자 정보가 없습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "사용자 정보 수정 중 오류가 발생했습니다.");
        }

        if (empId == null || empId <= 0) {
            return "redirect:/system/userauth";
        }

        return "redirect:/system/userauth/detail?empId=" + empId;
    }


    // =========================================================
    // 5. 임시비밀번호 발급
    // =========================================================

    /**
     * 임시비밀번호 발급
     *
     * 요청:
     * - POST /system/userauth/resetPw
     *
     * 처리:
     * - 새 임시비밀번호 생성
     * - BCrypt 암호화 후 emp_pw 저장
     * - 평문 임시비밀번호는 화면에 1회 표시
     */
    @RequestMapping(value = "/userauth/resetPw", method = RequestMethod.POST)
    public String resetTempPassword(
            @RequestParam("empId") Integer empId,
            RedirectAttributes rttr) {

        try {
            SystemUserAuthDTO resultDTO =
                    systemUserAuthService.resetTempPassword(empId);

            rttr.addFlashAttribute("msg", "임시비밀번호가 발급되었습니다.");
            rttr.addFlashAttribute("tempPassword", resultDTO.getTempPassword());
            rttr.addFlashAttribute("tempPasswordEmpno", resultDTO.getEmpno());
            rttr.addFlashAttribute("tempPasswordEname", resultDTO.getEname());

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "임시비밀번호 발급 중 오류가 발생했습니다.");
        }

        if (empId == null || empId <= 0) {
            return "redirect:/system/userauth";
        }

        return "redirect:/system/userauth/detail?empId=" + empId;
    }


    // =========================================================
    // 6. 계정 상태 일괄 변경
    // =========================================================

    /**
     * 계정 상태 일괄 변경
     *
     * 요청:
     * - POST /system/userauth/status
     *
     * 처리:
     * - 실제 DELETE 없음
     * - status로 계정 상태 관리
     * - 목록 화면에서 선택 계정 잠금/재직/휴직/퇴사 처리 가능
     */
    @RequestMapping(value = "/userauth/status", method = RequestMethod.POST)
    public String updateUserAuthStatusList(
            @RequestParam(value = "empIdList", required = false) List<Integer> empIdList,
            @RequestParam("status") String status,
            HttpSession session,
            RedirectAttributes rttr) {

        Integer loginEmpId = getLoginEmpId(session);

        try {
            int result =
                    systemUserAuthService.updateSystemUserAuthStatusList(
                            empIdList,
                            status,
                            loginEmpId
                    );

            if (result > 0) {
                rttr.addFlashAttribute("msg", "선택한 계정 상태가 변경되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "변경된 계정이 없습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "계정 상태 변경 중 오류가 발생했습니다.");
        }

        return "redirect:/system/userauth";
    }


    // =========================================================
    // 7. Ajax / 자동생성 / 중복 체크
    // =========================================================

    /**
     * 다음 사번 자동생성
     *
     * 요청:
     * - GET /system/userauth/nextEmpno
     */
    @ResponseBody
    @RequestMapping(value = "/userauth/nextEmpno", method = RequestMethod.GET)
    public String nextEmpno() {

        try {
            return systemUserAuthService.selectNextEmpno();
        } catch (Exception e) {
            return "";
        }
    }


    /**
     * 사번 중복 체크
     *
     * 요청:
     * - GET /system/userauth/checkEmpno?empno=E2026001
     * - GET /system/userauth/checkEmpno?empno=E2026001&empId=1
     */
    @ResponseBody
    @RequestMapping(value = "/userauth/checkEmpno", method = RequestMethod.GET)
    public Map<String, Object> checkEmpno(
            @RequestParam("empno") String empno,
            @RequestParam(value = "empId", required = false) Integer empId) {

        Map<String, Object> resultMap = new HashMap<String, Object>();

        try {
            SystemUserAuthDTO dto = new SystemUserAuthDTO();
            dto.setEmpId(empId);
            dto.setEmpno(empno);

            int count = systemUserAuthService.selectSystemUserAuthCountByEmpno(dto);

            resultMap.put("available", count == 0);
            resultMap.put("count", count);

            if (count == 0) {
                resultMap.put("message", "사용 가능한 로그인 ID/사번입니다.");
            } else {
                resultMap.put("message", "이미 등록된 로그인 ID/사번입니다.");
            }

        } catch (Exception e) {
            resultMap.put("available", false);
            resultMap.put("count", 0);
            resultMap.put("message", "사번 중복 체크 중 오류가 발생했습니다.");
        }

        return resultMap;
    }


    /**
     * 연락 이메일 중복 체크
     *
     * 현재 기준:
     * - 로그인 ID는 empno이므로 이메일 중복은 필수 검증이 아니다.
     * - 기존 JS에서는 사용하지 않지만 필요 시 호출 가능하도록 남겨둔다.
     *
     * 요청:
     * - GET /system/userauth/checkEmail?email=user1@saeroi.co.kr
     * - GET /system/userauth/checkEmail?email=user1@saeroi.co.kr&empId=1
     */
    @ResponseBody
    @RequestMapping(value = "/userauth/checkEmail", method = RequestMethod.GET)
    public Map<String, Object> checkEmail(
            @RequestParam("email") String email,
            @RequestParam(value = "empId", required = false) Integer empId) {

        Map<String, Object> resultMap = new HashMap<String, Object>();

        try {
            SystemUserAuthDTO dto = new SystemUserAuthDTO();
            dto.setEmpId(empId);
            dto.setEmail(email);

            int count = systemUserAuthService.selectSystemUserAuthCountByEmail(dto);

            resultMap.put("available", count == 0);
            resultMap.put("count", count);

            if (count == 0) {
                resultMap.put("message", "사용 가능한 연락 이메일입니다.");
            } else {
                resultMap.put("message", "이미 등록된 연락 이메일입니다.");
            }

        } catch (Exception e) {
            resultMap.put("available", false);
            resultMap.put("count", 0);
            resultMap.put("message", "연락 이메일 중복 체크 중 오류가 발생했습니다.");
        }

        return resultMap;
    }


    // =========================================================
    // 8. 내부 메소드
    // =========================================================

    /**
     * 현재 로그인 사용자 emp_id 조회
     *
     * 프로젝트마다 세션 attribute명이 다를 수 있어서 아래 순서로 확인한다.
     *
     * 1. loginEmpId
     * 2. empId
     * 3. loginUser 객체의 getEmpId()
     * 4. loginUser 객체의 getEmp_id()
     *
     * 세션에서 찾지 못하면 null 반환.
     */
    private Integer getLoginEmpId(HttpSession session) {

        if (session == null) {
            return null;
        }

        Object loginEmpId = session.getAttribute("loginEmpId");

        if (loginEmpId instanceof Integer) {
            return (Integer) loginEmpId;
        }

        Object empId = session.getAttribute("empId");

        if (empId instanceof Integer) {
            return (Integer) empId;
        }

        Object loginUser = session.getAttribute("loginUser");

        Integer result = extractIntegerProperty(loginUser, "getEmpId");

        if (result != null) {
            return result;
        }

        result = extractIntegerProperty(loginUser, "getEmp_id");

        if (result != null) {
            return result;
        }

        return null;
    }


    /**
     * 리플렉션으로 Integer getter 값을 꺼낸다.
     */
    private Integer extractIntegerProperty(Object target, String methodName) {

        if (target == null || methodName == null) {
            return null;
        }

        try {
            Method method = target.getClass().getMethod(methodName);
            Object value = method.invoke(target);

            if (value instanceof Integer) {
                return (Integer) value;
            }

            if (value instanceof Number) {
                return ((Number) value).intValue();
            }

            if (value instanceof String) {
                return Integer.parseInt((String) value);
            }

        } catch (Exception e) {
            return null;
        }

        return null;
    }
}