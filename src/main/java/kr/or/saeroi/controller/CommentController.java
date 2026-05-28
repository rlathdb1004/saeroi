package kr.or.saeroi.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.CommentService;

@Controller
@RequestMapping("/board/suggestion/comment")
public class CommentController {

	@Autowired
	CommentService commentService;
	
	public String comment(Model model, 
			HttpSession session,
			@RequestParam(required = false) String board_id) {
		
		//로그인 한 사용자 정보 가져옴
		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
		
		//board_id 없으면 게시판 목록으로 이동함
//		if(board_id = null or "") {
//			return "redirect:/board/suggestion";
//		}
	
		
		
		
		return board_id;
	}
	
}
