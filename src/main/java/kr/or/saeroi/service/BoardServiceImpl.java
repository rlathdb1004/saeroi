package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.saeroi.dao.BoardDAO;
import kr.or.saeroi.dto.BoradDTO;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDAO boardDAO;

	// 공지 목록
	@Override
	public List<BoradDTO> _ser_select_Notice(String startDate, String endDate, String keyword, String role) {
		return boardDAO._dao_select_Notice(startDate, endDate, keyword, role);
	}

	// 다음 공지번호 조회
	@Override
	public int _ser_select_next_Notice_id() {
		return boardDAO._dao_select_next_Notice_id();
	}

	// 공지 등록
	@Override
	public int _ser_insert_Notice(int notice_id, String title, String content, String empno, String status,
			String remark) {
		return boardDAO._dao_insert_Notice(notice_id, title, content, empno, status, remark);
	}

	// 공지 첨부파일 등록
	@Override
	public int _ser_insert_Notice_file(int notice_id, String file_title, String saved_title, String file_path,
			long file_size) {
		return boardDAO._dao_insert_Notice_file(notice_id, file_title, saved_title, file_path, file_size);
	}

	// 공지 삭제
	@Override
	public int _ser_delete_Notice(String[] notice_id, String role, String empno) {
		return boardDAO._dao_delete_Notice(notice_id, role, empno);
	}

	// 공지 상세
	@Override
	public BoradDTO _ser_select_Notice_detail(String notice_id, String role) {
		return boardDAO._dao_select_Notice_detail(notice_id, role);
	}

	// 공지 첨부파일 조회
	@Override
	public BoradDTO _ser_select_Notice_file(String notice_id) {
		return boardDAO._dao_select_Notice_file(notice_id);
	}

	// 공지 조회수
	@Override
	public int _ser_update_Notice_view_count(String notice_id, String empno) {
		return boardDAO._dao_update_Notice_view_count(notice_id, empno);
	}

	// 공지 수정
	@Override
	public int _ser_update_Notice(String notice_id, String title, String content, String status, String remark) {
		return boardDAO._dao_update_Notice(notice_id, title, content, status, remark);
	}

	// 게시판 목록 조회
	@Override
	public List<BoradDTO> _ser_select_Board(String startDate, String endDate, String keyword) {
		return boardDAO._dao_select_Board(startDate, endDate, keyword);
	}

	// 다음 게시판 번호 조회
	@Override
	public int _ser_select_next_Board_id() {
		return boardDAO._dao_select_next_Board_id();
	}

	// 게시판 등록
	@Override
	public int _ser_insert_Board(int board_id, String title, String content, String empno, String status,
			String remark) {
		return boardDAO._dao_insert_Board(board_id, title, content, empno, status, remark);
	}

	// 게시판 첨부파일 등록
	@Override
	public int _ser_insert_Board_file(int board_id, String file_title, String saved_title, String file_path,
			long file_size) {
		return boardDAO._dao_insert_Board_file(board_id, file_title, saved_title, file_path, file_size);
	}

	// 게시판 삭제
	@Override
	public int _ser_delete_Board(String[] board_id, String role, String empno) {
		return boardDAO._dao_delete_Board(board_id, role, empno);
	}

	// 게시판 상세 조회
	@Override
	public BoradDTO _ser_select_Board_detail(String board_id, String role) {
		return boardDAO._dao_select_Board_detail(board_id, role);
	}

	// 게시판 첨부파일 조회
	@Override
	public BoradDTO _ser_select_Board_file(String board_id) {
		return boardDAO._dao_select_Board_file(board_id);
	}

	// 게시판 조회수 증가
	@Override
	public int _ser_update_Board_view_count(String board_id, String empno) {
		return boardDAO._dao_update_Board_view_count(board_id, empno);
	}

	// 게시판 수정
	@Override
	public int _ser_update_Board(String board_id, String title, String content,
			String status, String use_yn, String remark, String role, String empno) {

		return boardDAO._dao_update_Board(board_id, title, content, status,
				use_yn, remark, role, empno);
	}
}