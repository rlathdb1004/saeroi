package kr.or.saeroi.loginConfig;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.or.saeroi.dto.LoginDTO;

@Component
public class RoleInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return true;
        }

        LoginDTO loginUser =
            (LoginDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            return true;
        }

        // 관리자, 매니저는 모두 허용
        if ("ADMIN".equals(loginUser.getRole())
            || "MANAGER".equals(loginUser.getRole())) {
        	
            return true;
        }

        String uri = request.getRequestURI();

        // 작업자(USER) 허용 페이지
//        if ("WORKER".equals(loginUser.getRole())) {
//
//        	if (uri.contains("/worker/main")
//        	        || uri.contains("/board/notice")
//        	        || uri.contains("/board/suggestion")
//        	        || uri.contains("/production/workorder")
//        	        || uri.contains("/production/productionresult")) {
//
//                return true;
//            }
//        }
        
//        response.setContentType("text/html; charset=UTF-8");
//
//        response.getWriter().println(
//            "<script>" +
//            "alert('접근 권한이 없습니다.');" +
//            "location.href='" + request.getContextPath() + "/worker/main';" +
//            "</script>"
//        );
//
//        response.getWriter().flush();        
       
        return true;
    }
}