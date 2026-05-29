package kr.or.saeroi.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.CommentService;

@Controller
@RequestMapping("/board/suggestion/comment")
public class CommentController {

	@Autowired
	CommentService commentService;

	// 댓글/답글 등록
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public String comment_add(HttpSession session,
			@RequestParam(required = false) String board_id,
			@RequestParam(required = false) Integer parent_comment_id,
			@RequestParam(required = false) String content) {

		if (board_id == null || board_id.equals("")) {
			return "redirect:/board/suggestion";
		}

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		if (content == null || content.trim().equals("")) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		commentService._ser_insert_Comment(Integer.parseInt(board_id),
				parent_comment_id, loginUser.getEmpno(), content);

		return "redirect:/board/suggestion/detail?board_id=" + board_id;
	}

	// 댓글/답글 수정
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String comment_update(HttpSession session,
			@RequestParam(required = false) String board_id,
			@RequestParam(required = false) String comment_id,
			@RequestParam(required = false) String content) {

		if (board_id == null || board_id.equals("")) {
			return "redirect:/board/suggestion";
		}

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		if (comment_id == null || comment_id.equals("")) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		if (content == null || content.trim().equals("")) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		commentService._ser_update_Comment(Integer.parseInt(comment_id),
				loginUser.getEmpno(), loginUser.getRole(), content);

		return "redirect:/board/suggestion/detail?board_id=" + board_id;
	}

	// 댓글/답글 삭제
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String comment_delete(HttpSession session,
			@RequestParam(required = false) String board_id,
			@RequestParam(required = false) String comment_id) {

		if (board_id == null || board_id.equals("")) {
			return "redirect:/board/suggestion";
		}

		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		if (comment_id == null || comment_id.equals("")) {
			return "redirect:/board/suggestion/detail?board_id=" + board_id;
		}

		commentService._ser_delete_Comment(Integer.parseInt(comment_id),
				loginUser.getEmpno(), loginUser.getRole());

		return "redirect:/board/suggestion/detail?board_id=" + board_id;
	}
}
