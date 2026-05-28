package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import kr.or.saeroi.dto.CommentDTO;

public class CommentImplDAO implements CommentDAO {

	@Autowired
	SqlSession sqlSession;

	//댓글 목록
	@Override
	public List<CommentDTO> _dao_select_Comment(int board_id) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("board_id", board_id);

		List<CommentDTO> comment_list = sqlSession.selectList("mapper.comment._select_comment", param);

		System.out.println("comment_list 실행 건수: " + comment_list.size());

		return comment_list;
	}
	//댓글 등록
	@Override
	public int _dao_insert_Comment(int board_id, Integer parent_comment_id, String empno, String content) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("board_id", board_id);
		param.put("parent_comment_id", parent_comment_id);
		param.put("empno", empno);
		param.put("content", content);

		int insert_comment = sqlSession.insert("mapper.comment._insert_comment", param);
		System.out.println("insert_comment 실행 건수: " + insert_comment);

		return insert_comment;
	}

	//댓글 삭제
	@Override
	public int _dao_delete_Comment(int comment_id, String empno, String role) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("comment_id",comment_id);
		param.put("empno", empno);
		param.put("role", role);
		
		//댓글 삭제는 delete보단 update가 나음
		//댓글 삭제의 경우 use_yn = N으로 바뀌는 방식이어야 대댓글 구조가 안 깨짐
		int delete_comment = sqlSession.update("mapper.comment._delete_comment",param);
		System.out.println("delete_comment 실행 건수: " + delete_comment);
		return delete_comment;
	}
	//댓글 하나 조회
	@Override
	public CommentDTO _dao_select_Comment_detail(int comment_id) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("comment_id", comment_id);
		
		CommentDTO select_comment_one = sqlSession.selectOne("mapper.comment._select_comment_one",param);
		
		return select_comment_one;
	}

}
