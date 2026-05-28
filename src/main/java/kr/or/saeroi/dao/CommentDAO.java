package kr.or.saeroi.dao;

import java.util.List;

import kr.or.saeroi.dto.CommentDTO;

public interface CommentDAO {

	// 게시글 번호로 댓글 목록 조회
	List<CommentDTO> _dao_select_Comment(int board_id);

	// 댓글 등록
	int _dao_insert_Comment(int board_id, Integer parent_comment_id, String empno, String content);

	// 댓글 삭제
	int _dao_delete_Comment(int comment_id, String empno, String role);

	// 댓글 번호로 댓글 하나 조회
	CommentDTO _dao_select_Comment_detail(int comment_id);
}
