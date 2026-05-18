package kr.or.saeroi.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.dto.FindPwDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.LoginService;

@Controller
public class LoginController {
	 @Autowired
	    private LoginService loginService;

    @RequestMapping(value="/login", method=RequestMethod.GET)
    public String login() {

        return "login";
    }
    
    @RequestMapping(value="/login", method=RequestMethod.POST)
    public String login_proc(
            @RequestParam("empno") String empno,
            @RequestParam("pw") String pw,
            HttpSession session,
            Model model) {

    	 LoginDTO login = loginService.login(empno, pw);

        if(login != null) {

            session.setAttribute("loginUser", login);

            return "redirect:/";
        }        
        
        model.addAttribute("errorMsg", "사번 또는 비밀번호가 올바르지 않습니다.");
        return "login";
    }
    
    @RequestMapping(value="/findPw", method=RequestMethod.POST)
    public Map<String, Object> findPassword(@RequestBody FindPwDTO dto) {

        Map<String, Object> result = new HashMap<>();

        boolean exists = loginService.check_user(dto.getEmpno(), dto.getEmail());

        if (!exists) {
            result.put("success", false);
            result.put("message", "일치하는 정보가 없습니다.");
            return result;
        }

        String tempPw = loginService.reset_pw(dto.getEmpno());

        loginService.send_temp_pw(dto.getEmail(), tempPw);

        result.put("success", true);
        result.put("message", "임시 비밀번호가 이메일로 발송되었습니다.");

        return result;
    }

}
    
