package kr.or.saeroi.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.saeroi.dto.LoginDTO;

// =========================================================
// 작업자 메인 컨트롤러
// =========================================================
@Controller
public class WorkerController {

	// =====================================================
	// 작업자 메인
	// =====================================================
	@RequestMapping("/worker/main")
	public String workerMain(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 사용자 정보
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 페이지 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 작업자만 접근 가능
		// =================================================
		if (!"WORKER".equals(
				loginUser.getRole())) {

			return "redirect:/";
		}

		// =================================================
		// 작업자 정보 전달
		// =================================================
		model.addAttribute(
			"workerName",
			loginUser.getEname());

		model.addAttribute(
			"workerDept",
			loginUser.getDept());

		// =================================================
		// Tiles 사용 안함
		// 단독 JSP 실행
		// =================================================
		return "worker/workerMain";
	}
}