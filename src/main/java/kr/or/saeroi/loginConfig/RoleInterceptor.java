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

	    String uri = request.getRequestURI();

	    // 로그인 없이 접근 허용
	    if (uri.contains("/login")
	        || uri.contains("/find_pw")
	        || uri.contains("/resources/")) {

	        return true;
	    }

	    HttpSession session = request.getSession(false);

	    if (session == null) {
	        response.sendRedirect(request.getContextPath() + "/login");
	        return false;
	    }

	    LoginDTO loginUser =
	        (LoginDTO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        response.sendRedirect(request.getContextPath() + "/login");
	        return false;
	    }

	    String role = loginUser.getRole();

        
        if ("ADMIN".equalsIgnoreCase(role)) {
            return true;
        }           
        
        if("MANAGER".equalsIgnoreCase(role)) {
        	if(uri.contains("/master")) {
        		response.setContentType("text/html; charset=UTF-8");
                response.getWriter().write(
                    "<script>" + "alert('접근 권한이 없습니다.');" +
                    "location.href='" + request.getContextPath() + "/';" +
                    "</script>"
                );
                response.getWriter().flush();

                return false;
        	}
        	return true;
        }

        if ("WORKER".equalsIgnoreCase(role)) {

            if (uri.contains("/worker/main")
                || uri.contains("/board/notice")
                || uri.contains("/board/suggestion")
                || uri.contains("/production/workorder")
                || uri.contains("/production/productionresult")
                || uri.contains("/worker/productionresult")
                || uri.contains("/worker/workorder")
                || uri.contains("/notice/list")
                || uri.contains("/mypage")                
                || uri.contains("/quality/inspection")                
                || uri.contains("/weather/current")
                || uri.contains("/weather/today")) {

                return true;
            }

            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write(
                "<script>" + "alert('접근 권한이 없습니다.');" +
                "location.href='" + request.getContextPath() + "/worker/main';" +
                "</script>"
            );
            response.getWriter().flush();

            return false;
        }
        
        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }
}