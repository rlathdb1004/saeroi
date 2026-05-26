package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.BoradDTO;

@Repository
public class BoardDAOImpl implements BoardDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	//공지 목록
	@Override
	public List<BoradDTO> _dao_select_Notice(String startDate, String endDate, String keyword) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("keyword", keyword);

		return sqlSession.selectList("mapper.board._select_Notice", param);
	}
	//공지 등록
	@Override
	public int _dao_insert_Notice(String title, String content, String empno, String status, String remark) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("title", title);
		param.put("content", content);
		param.put("empno", empno);
		param.put("status", status);
		param.put("remark", remark);

		return sqlSession.insert("mapper.board._insert_Notice", param);
	}
	//공지 삭제
	@Override
	public int _dao_delete_Notice(String[] notice_id, String role, String empno) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("notice_id", notice_id);
		param.put("role", role);
		param.put("empno", empno);

		return sqlSession.delete("mapper.board._delete_Notice", param);
	}
	//공지 상세
	@Override
	public BoradDTO _dao_select_Notice_detail(String notice_id) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("notice_id", notice_id);

		return sqlSession.selectOne("mapper.board._select_Notice_detail", param);
	}
	//공지 조회수
	@Override
	public int _dao_update_Notice_view_count(String notice_id, String empno) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("notice_id", notice_id);
		param.put("empno", empno);

		return sqlSession.update("mapper.board._update_Notice_view_count", param);
	}
	//공지 수정
	@Override
	public int _dao_update_Notice(String notice_id, String title, String content, String status, String remark) {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("notice_id", notice_id);
		param.put("title", title);
		param.put("content", content);
		param.put("status", status);
		param.put("remark", remark);

		return sqlSession.update("mapper.board._update_Notice", param);
	}
}