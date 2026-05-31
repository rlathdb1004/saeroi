package kr.or.saeroi.controller;

import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
	        @RequestParam("emp_pw") String emp_pw,
	        @RequestParam("emp_pw_new") String emp_pw_new,
	        @RequestParam("emp_pw_confirm") String emp_pw_confirm,
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

	    
	    if (emp_pw_new != null && !emp_pw_new.trim().isEmpty()) {	
	    	
	        if (emp_pw == null || emp_pw.trim().isEmpty()) {
	            redirectAttributes.addFlashAttribute(
	                    "errorMsg","현재 비밀번호를 입력해주세요.");
	            return "redirect:/mypage";
	        }

	        LoginDTO dbUser = loginService.find_empno(loginUser.getEmpno());

	        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

	        if (!encoder.matches(emp_pw, dbUser.getEmp_pw())) {

	            redirectAttributes.addFlashAttribute(
	                    "errorMsg","현재 비밀번호가 일치하지 않습니다.");
	            return "redirect:/mypage";
	        }

	        Set<String> exemptUsers = Set.of(
	                "test",
	                "testw",
	                "testmg"
	        );

	        if (!emp_pw_new.matches(
	                "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=\\-{}\\[\\]:;\"'<>,.?/\\\\|`~]).{8,}$")) {

	            if (!exemptUsers.contains(dbUser.getEmpno())) {

	                redirectAttributes.addFlashAttribute(
	                        "errorMsg",
	                        "비밀번호는 8자 이상이며 영문, 숫자, 특수문자를 포함해야 합니다.");

	                return "redirect:/mypage";
	            }
	        }
	        
	        if (!emp_pw_new.equals(emp_pw_confirm)) {

	            redirectAttributes.addFlashAttribute(
	                    "errorMsg","새 비밀번호가 일치하지 않습니다.");
	            return "redirect:/mypage";
	        }

	        String hash_pw = encoder.encode(emp_pw_new);
	        dto.setEmp_pw(hash_pw);
	    }

	    int result = loginService.update_my_page(dto);

	    if (result > 0) {

	        LoginDTO updatedUser = loginService.find_empno(loginUser.getEmpno());

	        session.setAttribute("loginUser", updatedUser);

	        redirectAttributes.addFlashAttribute(
	                "successMsg", "회원정보가 수정되었습니다.");

	    } else {

	        redirectAttributes.addFlashAttribute(
	                "errorMsg", "회원정보 수정에 실패했습니다.");
	    }

	    return "redirect:/mypage";
	}
}