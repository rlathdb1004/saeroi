package kr.or.saeroi.controller;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.saeroi.dto.FindPwDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.LoginService;

@Controller
public class LoginController {

	@Autowired
	private LoginService loginService;

	// =====================================================
	// 로그인 페이지 이동
	// =====================================================
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String login(HttpSession session) {

		if(session.getAttribute("loginUser") != null) {

			return "redirect:/";
		}

		return "login";
	}

	// =====================================================
	// 로그인 처리
	// =====================================================
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login_proc(
			@RequestParam("empno") String empno,
			@RequestParam("pw") String pw,
			@RequestParam(value="autoLogin", required=false) String autoLogin,
			HttpSession session,
			HttpServletResponse response,
			Model model) {

		// =================================================
		// 로그인 확인
		// =================================================
		LoginDTO login =
			loginService.login(empno, pw);

		// =================================================
		// 로그인 성공
		// =================================================
		if(login != null) {

			// =============================================
			// 세션 저장
			// =============================================
			session.setAttribute(
				"loginUser",
				login);

			// =============================================
			// 자동 로그인 처리
			// =============================================
			if("Y".equals(autoLogin)) {

				String token =
					UUID.randomUUID().toString();

				loginService.update_auto_login_token(
					login.getEmpno(),
					token);

				Cookie cookie =
					new Cookie("autoLogin", token);

				cookie.setMaxAge(
					60 * 60 * 24 * 30);

				cookie.setPath("/");

				response.addCookie(cookie);
			}

			// =============================================
			// ★ 추가된 부분 ★
			// 작업자 로그인 시
			// 작업자 메인 화면 이동
			// =============================================
			if("WORKER".equals(
					login.getRole())) {

				return "redirect:/worker/main";
			}

			// =============================================
			// 관리자 / 매니저 메인 이동
			// =============================================
			return "redirect:/";
		}

		// =================================================
		// 로그인 실패
		// =================================================
		model.addAttribute(
			"errorMsg",
			"사번 또는 비밀번호가 올바르지 않습니다.");

		return "login";
	}

	// =====================================================
	// 비밀번호 찾기
	// =====================================================
	@ResponseBody
	@RequestMapping(value="/find_pw",
		method=RequestMethod.POST)

	public Map<String, Object> find_pw(
			@RequestBody FindPwDTO dto) {

		Map<String, Object> result =
			new HashMap<>();

		try {

			boolean exists =
				loginService.check_user(
					dto.getEmpno(),
					dto.getEmail());

			if (!exists) {

				result.put("success", false);

				result.put(
					"message",
					"일치하는 정보가 없습니다.");

				return result;
			}

			String tempPw =
				loginService.reset_pw(
					dto.getEmpno());

			loginService.send_temp_pw(
				dto.getEmail(),
				tempPw);

			result.put("success", true);

			result.put(
				"message",
				"임시 비밀번호가 이메일로 발송되었습니다.");

		} catch (Exception e) {

			e.printStackTrace();

			result.put("success", false);

			result.put(
				"message",
				"서버 오류가 발생했습니다.");
		}

		return result;
	}

	// =====================================================
	// 로그아웃
	// =====================================================
	@RequestMapping("/logout")
	public String logout(
			HttpSession session,
			HttpServletResponse response) {

		LoginDTO login =
			(LoginDTO) session.getAttribute(
				"loginUser");

		if(login != null) {

			loginService.clear_auto_login_token(
				login.getEmpno());
		}

		// =================================================
		// 세션 삭제
		// =================================================
		session.invalidate();

		// =================================================
		// 자동 로그인 쿠키 삭제
		// =================================================
		Cookie cookie =
			new Cookie("autoLogin", "");

		cookie.setMaxAge(0);

		cookie.setPath("/");

		response.addCookie(cookie);

		return "redirect:/login";
	}
}