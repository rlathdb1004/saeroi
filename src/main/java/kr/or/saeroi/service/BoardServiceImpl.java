package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.BoardDAO;
import kr.or.saeroi.dto.BoradDTO;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDAO boardDAO;
	//공지 목록
	@Override
	public List<BoradDTO> _ser_select_Notice(String startDate, String endDate, String keyword) {
		return boardDAO._dao_select_Notice(startDate, endDate, keyword);
	}
	//공지 등록
	@Override
	public int _ser_insert_Notice(String title, String content, String empno, String status, String remark) {
		return boardDAO._dao_insert_Notice(title, content, empno, status, remark);
	}
	//공지 삭제
	@Override
	public int _ser_delete_Notice(String[] notice_id, String role, String empno) {
		return boardDAO._dao_delete_Notice(notice_id, role, empno);
	}	
	//공지 상세
	@Override
	public BoradDTO _ser_select_Notice_detail(String notice_id) {
		return boardDAO._dao_select_Notice_detail(notice_id);
	}
	//공지 조회수

	@Override
	public int _ser_update_Notice_view_count(String notice_id, String empno) {
		return boardDAO._dao_update_Notice_view_count(notice_id, empno);
	}
	//공지 수정
	@Override
	public int _ser_update_Notice(String notice_id, String title, String content, String status, String remark) {
		return boardDAO._dao_update_Notice(notice_id, title, content, status, remark);
	}
}