package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.BoradDTO;

public interface BoardService {

	//공지 목록
	List<BoradDTO> _ser_select_Notice(String startDate, String endDate, String keyword);

	//공지 등록
	int _ser_insert_Notice(String title, String content, String empno, String status, String remark);

	//공지 삭제
	int _ser_delete_Notice(String[] notice_id, String role, String empno);

	//공지 상세
	BoradDTO _ser_select_Notice_detail(String notice_id);

	//공지 조회수
	int _ser_update_Notice_view_count(String notice_id, String empno);

	//공지 수정
	int _ser_update_Notice(String notice_id, String title, String content, String status, String remark);
}