package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.CommentDTO;

@Repository
public class CommentImplDAO implements CommentDAO {

	@Autowired
	SqlSession sqlSession;

	@Override
	public List<CommentDTO> _dao_select_Comment(int board_id) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("board_id", board_id);

		List<CommentDTO> comment_list =
				sqlSession.selectList("mapper.comment._select_comment", param);

		System.out.println("comment_list 실행 건수: " + comment_list.size());

		return comment_list;
	}

	@Override
	public int _dao_insert_Comment(int board_id, Integer parent_comment_id,
			String empno, String content) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("board_id", board_id);
		param.put("parent_comment_id", parent_comment_id);
		param.put("empno", empno);
		param.put("content", content);

		int insert_comment =
				sqlSession.insert("mapper.comment._insert_comment", param);

		System.out.println("insert_comment 실행 건수: " + insert_comment);

		return insert_comment;
	}

	@Override
	public int _dao_delete_Comment(int comment_id, String empno, String role) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("comment_id", comment_id);
		param.put("empno", empno);
		param.put("role", role);

		int delete_comment =
				sqlSession.update("mapper.comment._delete_comment", param);

		System.out.println("delete_comment 실행 건수: " + delete_comment);

		return delete_comment;
	}

	@Override
	public CommentDTO _dao_select_Comment_detail(int comment_id) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("comment_id", comment_id);

		CommentDTO select_comment_one =
				sqlSession.selectOne("mapper.comment._select_comment_detail", param);

		return select_comment_one;
	}
}