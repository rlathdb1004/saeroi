package kr.or.saeroi.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.BoradDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	BoardService boardService;

	// 공지사항 등록 권한 확인
	// ADMIN, MANAGER만 공지사항을 등록할 수 있음
	private boolean canWriteNotice(LoginDTO loginUser) {
		return loginUser != null &&
				("ADMIN".equals(loginUser.getRole()) ||
				"MANAGER".equals(loginUser.getRole()));
	}

	// 공지사항 수정 권한 확인
	// ADMIN은 모든 공지를 수정할 수 있고
	// MANAGER는 본인이 작성한 공지만 수정할 수 있음
	private boolean canModifyNotice(LoginDTO loginUser, BoradDTO notice) {
		if (loginUser == null || notice == null) {
			return false;
		}

		if ("ADMIN".equals(loginUser.getRole())) {
			return true;
		}

		if ("MANAGER".equals(loginUser.getRole())
				&& loginUser.getEmpno() != null
				&& loginUser.getEmpno().equals(notice.getEmpno())) {
			return true;
		}

		return false;
	}

	// 공지사항 목록
	@RequestMapping("/notice")
	public String notice(Model model,
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size,
			@RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate,
			@RequestParam(required = false) String keyword) {

		// 검색 조건에 맞는 공지사항 전체 목록을 조회
		List<BoradDTO> list =
				boardService._ser_select_Notice(startDate, endDate, keyword);

		// 전체 건수를 구함
		int totalCount = list.size();

		// 현재 페이지에서 보여줄 시작 위치와 끝 위치를 계산
		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;

		// 시작 위치가 전체 건수보다 크면 전체 건수로 맞춤
		if (startIndex > totalCount) {
			startIndex = totalCount;
		}

		// 끝 위치가 전체 건수보다 크면 전체 건수로 맞춤
		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		// 전체 목록 중 현재 페이지에 보여줄 만큼만 잘라냄
		List<BoradDTO> page_list =
				list.subList(startIndex, endIndex);

		// 페이징 정보를 만듦
		PageDTO pageInfo =
				new PageDTO(page, size, totalCount);

		// JSP로 목록과 페이징 정보를 보냄
		model.addAttribute("list", page_list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/board/notice");

		// 검색 조건을 JSP로 다시 보내서 검색값이 유지되게 함
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("keyword", keyword);

		// 페이징을 눌러도 검색 조건이 유지되도록 검색 파라미터를 만듦
		String searchParam = "";

		if (startDate != null && !startDate.equals("")) {
			searchParam += "&startDate=" + startDate;
		}

		if (endDate != null && !endDate.equals("")) {
			searchParam += "&endDate=" + endDate;
		}

		if (keyword != null && !keyword.equals("")) {
			searchParam += "&keyword=" + keyword;
		}

		model.addAttribute("searchParam", searchParam);

		return "board/notice.tiles";
	}

	// 공지사항 등록
	@RequestMapping(value = "/notice/add", method = RequestMethod.POST)
	public String notice_add(Model model,
			HttpSession session,
			@RequestParam(required = false) String title,
			@RequestParam(required = false) String content,
			@RequestParam(required = false) String status,
			@RequestParam(required = false) String remark) {

		// 로그인한 사용자 정보를 세션에서 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 등록 권한이 없으면 공지사항 목록으로 돌려보냄
		if (!canWriteNotice(loginUser)) {
			return "redirect:/board/notice";
		}

		// 작성자 사번을 가져옴
		String empno =
				loginUser.getEmpno();

		// 공지사항을 등록
		int insert_result =
				boardService._ser_insert_Notice(title, content, empno, status, remark);

		System.out.println("notice_insert_result: " + insert_result);

		return "redirect:/board/notice";
	}

	// 공지사항 삭제
	@RequestMapping(value = "/notice/delete", method = RequestMethod.POST)
	public String notice_delete(Model model,
			HttpSession session,
			@RequestParam(value = "notice_id", required = false) String[] notice_id) {

		// 로그인한 사용자 정보를 세션에서 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 삭제 권한이 없으면 공지사항 목록으로 돌려보냄
		if (!canWriteNotice(loginUser)) {
			return "redirect:/board/notice";
		}

		// 선택된 공지사항이 있으면 삭제
		if (notice_id != null && notice_id.length > 0) {
			int delete_result =
					boardService._ser_delete_Notice(
							notice_id,
							loginUser.getRole(),
							loginUser.getEmpno());

			System.out.println("notice_delete_result: " + delete_result);
		}

		return "redirect:/board/notice";
	}

	// 공지사항 상세
	@RequestMapping("/notice/detail")
	public String notice_detail(Model model,
			HttpSession session,
			@RequestParam(required = false) String notice_id) {

		// 공지번호가 없으면 목록으로 돌려보냄
		if (notice_id == null || notice_id.equals("")) {
			return "redirect:/board/notice";
		}

		// 로그인한 사용자 정보를 세션에서 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		String empno = null;

		if (loginUser != null) {
			empno = loginUser.getEmpno();
		}

		// 작성자가 아닌 사용자가 보면 조회수를 1 증가
		boardService._ser_update_Notice_view_count(notice_id, empno);

		// 공지사항 상세 정보를 조회
		BoradDTO notice =
				boardService._ser_select_Notice_detail(notice_id);

		// JSP에서 사용할 수 있도록 상세 정보를 보냄
		model.addAttribute("notice", notice);

		return "board/notice_detail.tiles";
	}

	// 공지사항 수정
	@RequestMapping(value = "/notice/update", method = RequestMethod.POST)
	public String notice_update(Model model,
			HttpSession session,
			@RequestParam(required = false) String notice_id,
			@RequestParam(required = false) String title,
			@RequestParam(required = false) String content,
			@RequestParam(required = false) String status,
			@RequestParam(required = false) String remark) {

		// 공지번호가 없으면 목록으로 돌려보냄
		if (notice_id == null || notice_id.equals("")) {
			return "redirect:/board/notice";
		}

		// 로그인한 사용자 정보를 세션에서 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 수정하려는 공지사항의 기존 정보를 조회
		BoradDTO notice =
				boardService._ser_select_Notice_detail(notice_id);

		// 수정 권한이 없으면 상세 페이지로 돌려보냄
		if (!canModifyNotice(loginUser, notice)) {
			return "redirect:/board/notice/detail?notice_id=" + notice_id;
		}

		// 공지 수정
		int update_result =
				boardService._ser_update_Notice(
						notice_id, title, content, status, remark);

		System.out.println("notice_update_result: " + update_result);

		return "redirect:/board/notice/detail?notice_id=" + notice_id;
	}

	// 공지사항 등록 페이지
	@RequestMapping(value = "/notice/add", method = RequestMethod.GET)
	public String notice_add_page(HttpSession session) {

		// 로그인한 사용자 정보를 세션에서 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 등록 권한이 없으면 공지사항 목록으로 돌려보냄
		if (!canWriteNotice(loginUser)) {
			return "redirect:/board/notice";
		}

		return "board/notice_add.tiles";
	}
}