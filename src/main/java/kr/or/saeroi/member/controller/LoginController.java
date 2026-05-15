package kr.or.saeroi.member.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.member.dto.LoginDTO;
import kr.or.saeroi.member.service.LoginService;

@Controller
public class LoginController {
	 @Autowired
	    private LoginService loginService;

    @RequestMapping(value="/login", method=RequestMethod.GET)
    public String login() {

        return "login";
    }
    
    @RequestMapping(value="/login", method=RequestMethod.POST)
    public String loginProc(
            @RequestParam("emp_no") String emp_no,
            @RequestParam("pw") String pw,
            HttpSession session,
            Model model) {

    	 LoginDTO login = loginService.login(emp_no, pw);

        if(login != null) {

            session.setAttribute("loginUser", login);

            return "redirect:/";
        }        
        
        model.addAttribute("errorMsg", "사번 또는 비밀번호가 올바르지 않습니다.");
        return "login";
    }
}
    
