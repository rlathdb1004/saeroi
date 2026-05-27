package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.BoradDTO;

public interface BoardService {

	// 공지 목록
	List<BoradDTO> _ser_select_Notice(String startDate, String endDate, String keyword, String role);

	// 다음 공지번호 조회
	int _ser_select_next_Notice_id();

	// 공지 등록
	int _ser_insert_Notice(int notice_id, String title, String content, String empno, String status, String remark);

	// 공지 첨부파일 등록
	int _ser_insert_Notice_file(int notice_id, String file_title, String saved_title, String file_path, long file_size);

	// 공지 삭제
	int _ser_delete_Notice(String[] notice_id, String role, String empno);

	// 공지 상세
	BoradDTO _ser_select_Notice_detail(String notice_id, String role);

	// 공지 첨부파일 조회
	BoradDTO _ser_select_Notice_file(String notice_id);

	// 공지 조회수
	int _ser_update_Notice_view_count(String notice_id, String empno);

	// 공지 수정
	int _ser_update_Notice(String notice_id, String title, String content, String status, String remark);

	// 게시판 목록
	List<BoradDTO> _ser_select_Board(String startDate, String endDate, String keyword);

	// 다음 게시판 번호 조회
	int _ser_select_next_Board_id();

	// 게시판 등록
	int _ser_insert_Board(int board_id, String title, String content, String empno,
			String status, String remark);

	// 게시판 첨부파일 등록
	int _ser_insert_Board_file(int board_id, String file_title, String saved_title,
			String file_path, long file_size);

	// 게시판 삭제
	int _ser_delete_Board(String[] board_id, String role, String empno);

	// 게시판 상세 조회
	BoradDTO _ser_select_Board_detail(String board_id, String role);

	// 게시판 첨부파일 조회
	BoradDTO _ser_select_Board_file(String board_id);

	// 게시판 조회수 증가
	int _ser_update_Board_view_count(String board_id, String empno);

	// 게시판 수정
	int _ser_update_Board(String board_id, String title, String content,
			String status, String remark, String role, String empno);
}