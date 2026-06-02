package kr.or.saeroi.controller;

import java.io.File;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
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
	        @RequestParam(value = "profile_img", required = false)
	        MultipartFile profile_img,
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
	    
	    if (profile_img != null && !profile_img.isEmpty()) {
	    	
	    	String contentType = profile_img.getContentType();

	        if (contentType == null ||
	            !contentType.startsWith("image/")) {
	            redirectAttributes.addFlashAttribute(
	                    "errorMsg", "이미지 파일만 업로드 가능합니다.");
	            return "redirect:/mypage";
	        }

	        try {
	            String originalName = profile_img.getOriginalFilename();
	            String ext = originalName.substring(originalName.lastIndexOf("."));
	            String saveFileName = UUID.randomUUID().toString() + ext;
	            String uploadPath =
	            	    session.getServletContext()
	            	           .getRealPath("/resources/upload/profile/");
	            File dir = new File(uploadPath);

	            if (!dir.exists()) {
	                dir.mkdirs();
	            }

	            File saveFile = new File(uploadPath, saveFileName);
	            
	            if (loginUser.getProfile_img() != null) {

	                File oldFile = new File(
	                        uploadPath, loginUser.getProfile_img());

	                if (oldFile.exists()) {
	                    oldFile.delete();
	                }
	            }
	            
	            System.out.println("uploadPath : " + uploadPath);
	            System.out.println("saveFile : " + saveFile.getAbsolutePath());
	            System.out.println("exists dir : " + dir.exists());
	            
	            profile_img.transferTo(saveFile);	            
	            dto.setProfile_img(saveFileName);  
	            
	           
	            
	            System.out.println("saved : " + saveFile.exists());

	        } catch (Exception e) {

	            e.printStackTrace();
	            redirectAttributes.addFlashAttribute(
	                    "errorMsg", "프로필 사진 업로드 실패"
	            );
	            return "redirect:/mypage";
	        }

	    } else {	       
	        dto.setProfile_img(loginUser.getProfile_img());
	    }

	    	    
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