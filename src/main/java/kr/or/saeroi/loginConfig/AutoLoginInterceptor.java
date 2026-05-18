package kr.or.saeroi.loginConfig;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.LoginService;

@Component
public class AutoLoginInterceptor implements HandlerInterceptor {

    @Autowired
    private LoginService loginService;

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        String uri = request.getRequestURI();

        if(uri.contains("/login")) {
            return true;
        }

        HttpSession session = request.getSession();
        if(session.getAttribute("loginUser") != null) {
            return true;
        }

        Cookie[] cookies = request.getCookies();

        if(cookies != null) {

            for(Cookie cookie : cookies) {

                if("autoLogin".equals(cookie.getName())) {

                    String token = cookie.getValue();

                    LoginDTO login = loginService.find_token(token);

                    if(login != null) {
                        session.setAttribute("loginUser", login);
                    } else {
                        Cookie del = new Cookie("autoLogin", null);
                        del.setMaxAge(0);
                        del.setPath("/");
                        response.addCookie(del);
                    }                    
                    System.out.println("SESSION USER = " + session.getAttribute("loginUser"));
                    break;
                }
            }
        }
        
        return true;
    }
    @Override
    public void postHandle(HttpServletRequest request,
                           HttpServletResponse response,
                           Object handler,
                           ModelAndView modelAndView) throws Exception {
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex) throws Exception {
    }
    
}
