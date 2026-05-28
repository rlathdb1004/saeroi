package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.CommentDTO;

public interface CommentService {

	// 댓글 목록
	List<CommentDTO> _ser_select_Comment(int board_id);

	// 댓글 등록
	int _ser_insert_Comment(int board_id, Integer parent_comment_id, String empno, String content);

	// 댓글 삭제
	int _ser_delete_Comment(int comment_id, String empno, String role);

	// 댓글 번호로 댓글 하나 조회
	CommentDTO _ser_select_Comment_detail(int comment_id);
}
