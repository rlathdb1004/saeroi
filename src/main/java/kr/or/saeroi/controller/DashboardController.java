package kr.or.saeroi.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

	@GetMapping("/")
	public String main() {
		// 사용자가 http://localhost:8080/saeroi 로 처음 접속했을 때 실행된다.
		// 첫 화면도 대시보드로 보여주기 위해 dashboard.tiles를 반환한다.
		return "dashboard.tiles";
	}

	@GetMapping("/dashboard")
	public String dashboard() {
		// 사용자가 사이드바에서 대시보드 메뉴를 클릭했을 때 실행된다.
		// /saeroi/dashboard 주소로 들어와도 같은 대시보드 화면을 보여준다.
		return "dashboard.tiles";
	}
}