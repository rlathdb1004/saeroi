package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.CommentDAO;
import kr.or.saeroi.dto.CommentDTO;

@Service
public class CommentServiceImpl implements CommentService{

	@Autowired
	CommentDAO commentDAO;
	
	//댓글 목록
	@Override
	public List<CommentDTO> _ser_select_Comment(int board_id) {
		System.out.println("_ser_select_comment 실행 됨");
		
		List<CommentDTO> result_list = commentDAO._dao_select_Comment(board_id);
		return result_list;
	}

	//댓글 등록
	@Override
	public int _ser_insert_Comment(int board_id, Integer parent_comment_id, String empno, String content) {
		
		System.out.println("_ser_insert_comment 실행 됨");
		int insert_list = commentDAO._dao_insert_Comment(board_id, parent_comment_id, empno, content);
		
		return insert_list;
		
	}

	//댓글 수정
	@Override
	public int _ser_update_Comment(int comment_id, String empno, String role, String content) {
		System.out.println("_ser_update_comment 실행 됨");

		int update_list = commentDAO._dao_update_Comment(comment_id, empno, role, content);
		return update_list;
	}

	//댓글 삭제
	@Override
	public int _ser_delete_Comment(int comment_id, String empno, String role) {
		System.out.println("_ser_delete_comment 실행 됨");
	
		int delete_list = commentDAO._dao_delete_Comment(comment_id, empno, role);
		return delete_list;
	}

	//댓글 한개 조회
	@Override
	public CommentDTO _ser_select_Comment_detail(int comment_id) {
		System.out.println("_dao_selet_comment_detail 실행 됨");
		
		CommentDTO select_comment_detail = commentDAO._dao_select_Comment_detail(comment_id);
		
		return select_comment_detail;
	}

}
