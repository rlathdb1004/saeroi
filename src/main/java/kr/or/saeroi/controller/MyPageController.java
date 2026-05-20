package kr.or.saeroi.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.LoginService;

@Controller
public class MyPageController {
	
	@Autowired
	private LoginService loginService;

	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {

	    LoginDTO loginUser =
	        (LoginDTO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        return "redirect:/login";
	    }

	    model.addAttribute("user", loginUser);

	    return "myPage.tiles";
	}
	
	@PostMapping("/mypage/update")
	public String updateMyPage(
	        @RequestParam("email") String email,
	        @RequestParam("emp_tel") String emp_tel,
	        HttpSession session,
	        RedirectAttributes redirectAttributes) {

	    LoginDTO loginUser =
	            (LoginDTO) session.getAttribute("loginUser");
	    
	    if (loginUser == null) {
	        return "redirect:/login";
	    }

	    LoginDTO dto = new LoginDTO();
	    dto.setEmpno(loginUser.getEmpno());
	    dto.setEmail(email);
	    dto.setEmp_tel(emp_tel);
	    
	    int result = loginService.update_my_page(dto);

	    if (result > 0) {

	        loginUser.setEmail(email);
	        loginUser.setEmp_tel(emp_tel);

	        session.setAttribute("loginUser", loginUser);

	        redirectAttributes.addFlashAttribute(
	                "successMsg",
	                "회원정보가 수정되었습니다."
	        );

	    } else {

	        redirectAttributes.addFlashAttribute(
	                "errorMsg",
	                "회원정보 수정에 실패했습니다."
	        );
	    }

	    return "redirect:/mypage";
	}
}