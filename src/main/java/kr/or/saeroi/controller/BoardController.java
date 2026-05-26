package kr.or.saeroi.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.BoradDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	BoardService boardService;

	// 공지사항 작성 권한 확인
	private boolean canWriteNotice(LoginDTO loginUser) {
		return loginUser != null &&
				("ADMIN".equals(loginUser.getRole()) ||
				"MANAGER".equals(loginUser.getRole()));
	}

	// 공지사항 수정 권한 확인
	private boolean canModifyNotice(LoginDTO loginUser, BoradDTO notice) {
		if (loginUser == null || notice == null) {
			return false;
		}

		// ADMIN은 모든 공지 수정 가능
		if ("ADMIN".equals(loginUser.getRole())) {
			return true;
		}

		// MANAGER는 본인이 작성한 공지만 수정 가능
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
			HttpSession session,
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "5") int size,
			@RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate,
			@RequestParam(required = false) String keyword) {

		// 로그인한 사용자 정보 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		String role = null;

		// 로그인한 사용자 권한 가져옴
		if (loginUser != null) {
			role = loginUser.getRole();
		}

		// 검색 조건과 권한에 맞는 공지사항 목록 조회
		List<BoradDTO> list =
				boardService._ser_select_Notice(startDate, endDate, keyword, role);

		// 전체 건수 계산
		int totalCount = list.size();

		// 현재 페이지 시작 위치와 끝 위치 계산
		int startIndex = (page - 1) * size;
		int endIndex = startIndex + size;

		// 시작 위치 보정
		if (startIndex > totalCount) {
			startIndex = totalCount;
		}

		// 끝 위치 보정
		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		// 현재 페이지에 보여줄 목록만 자름
		List<BoradDTO> page_list =
				list.subList(startIndex, endIndex);

		// 페이징 정보 생성
		PageDTO pageInfo =
				new PageDTO(page, size, totalCount);

		// JSP로 목록과 페이징 정보 전달
		model.addAttribute("list", page_list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/board/notice");

		// 검색 조건 유지용 값 전달
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("keyword", keyword);

		// 페이징 검색 조건 유지용 파라미터 생성
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
			HttpServletRequest request,
			@RequestParam(required = false) String title,
			@RequestParam(required = false) String content,
			@RequestParam(required = false) String status,
			@RequestParam(required = false) String remark,
			@RequestParam(value = "noticeFile", required = false) MultipartFile noticeFile) throws IOException {

		// 로그인한 사용자 정보 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 등록 권한 없으면 목록으로 이동
		if (!canWriteNotice(loginUser)) {
			return "redirect:/board/notice";
		}

		// 작성자 사번 가져옴
		String empno =
				loginUser.getEmpno();

		// 첨부파일과 연결할 공지번호 먼저 조회
		int notice_id =
				boardService._ser_select_next_Notice_id();

		// 공지사항 등록 실행
		int insert_result =
				boardService._ser_insert_Notice(
						notice_id, title, content, empno, status, remark);

		// 첨부파일 있으면 파일 저장 후 DB 등록
		if (insert_result > 0 && noticeFile != null && !noticeFile.isEmpty()) {
			String originalFilename =
					noticeFile.getOriginalFilename();

			if (originalFilename != null && !originalFilename.trim().equals("")) {
				String savedFilename =
						makeNoticeSavedFilename(notice_id, originalFilename);

				String filePath =
						saveNoticeFile(noticeFile, request, savedFilename);

				boardService._ser_insert_Notice_file(
						notice_id,
						originalFilename,
						savedFilename,
						filePath,
						noticeFile.getSize());
			}
		}

		System.out.println("notice_insert_result: " + insert_result);

		return "redirect:/board/notice";
	}

	// 공지사항 삭제
	@RequestMapping(value = "/notice/delete", method = RequestMethod.POST)
	public String notice_delete(Model model,
			HttpSession session,
			@RequestParam(value = "notice_id", required = false) String[] notice_id) {

		// 로그인한 사용자 정보 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 삭제 권한 없으면 목록으로 이동
		if (!canWriteNotice(loginUser)) {
			return "redirect:/board/notice";
		}

		// 선택된 공지사항 삭제 실행
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

		// 공지번호 없으면 목록으로 이동
		if (notice_id == null || notice_id.equals("")) {
			return "redirect:/board/notice";
		}

		// 로그인한 사용자 정보 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		String empno = null;
		String role = null;

		// 로그인한 사용자 사번과 권한 가져옴
		if (loginUser != null) {
			empno = loginUser.getEmpno();
			role = loginUser.getRole();
		}

		// 공지사항 상세 조회
		BoradDTO notice =
				boardService._ser_select_Notice_detail(notice_id, role);

		// 조회 권한 없거나 없는 글이면 목록으로 이동
		if (notice == null) {
			return "redirect:/board/notice";
		}

		// 작성자 본인이 아니면 조회수 증가
		boardService._ser_update_Notice_view_count(notice_id, empno);

		// 조회수 증가 후 최신 상세 정보 다시 조회
		notice =
				boardService._ser_select_Notice_detail(notice_id, role);

		// 공지 첨부파일 조회
		BoradDTO noticeFile =
				boardService._ser_select_Notice_file(notice_id);

		// JSP로 상세 정보 전달
		model.addAttribute("notice", notice);
		model.addAttribute("noticeFile", noticeFile);

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

		// 공지번호 없으면 목록으로 이동
		if (notice_id == null || notice_id.equals("")) {
			return "redirect:/board/notice";
		}

		// 로그인한 사용자 정보 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		String role = null;

		// 로그인한 사용자 권한 가져옴
		if (loginUser != null) {
			role = loginUser.getRole();
		}

		// 수정 대상 공지사항 조회
		BoradDTO notice =
				boardService._ser_select_Notice_detail(notice_id, role);

		// 수정 권한 없으면 목록으로 이동
		if (!canModifyNotice(loginUser, notice)) {
			return "redirect:/board/notice";
		}

		// 공지사항 수정 실행
		int update_result =
				boardService._ser_update_Notice(
						notice_id, title, content, status, remark);

		System.out.println("notice_update_result: " + update_result);

		return "redirect:/board/notice/detail?notice_id=" + notice_id;
	}

	// 공지사항 등록 페이지
	@RequestMapping(value = "/notice/add", method = RequestMethod.GET)
	public String notice_add_page(HttpSession session) {

		// 로그인한 사용자 정보 가져옴
		LoginDTO loginUser =
				(LoginDTO) session.getAttribute("loginUser");

		// 등록 권한 없으면 목록으로 이동
		if (!canWriteNotice(loginUser)) {
			return "redirect:/board/notice";
		}

		return "board/notice_add.tiles";
	}

	// 공지 첨부파일 저장명 생성
	private String makeNoticeSavedFilename(int notice_id, String originalFilename) {

		String extension = "";

		int dotIndex =
				originalFilename.lastIndexOf(".");

		if (dotIndex != -1) {
			extension =
					originalFilename.substring(dotIndex);
		}

		String timestamp =
				new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());

		return "notice_" + notice_id + "_" + timestamp + extension;
	}

	// 공지 첨부파일 서버 저장
	private String saveNoticeFile(MultipartFile noticeFile,
			HttpServletRequest request,
			String savedFilename) throws IOException {

		String uploadRelativePath =
				"/resources/upload/notice/";

		String uploadRealPath =
				request.getServletContext().getRealPath(uploadRelativePath);

		File uploadDir =
				new File(uploadRealPath);

		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		File savedFile =
				new File(uploadDir, savedFilename);

		noticeFile.transferTo(savedFile);

		return uploadRelativePath + savedFilename;
	}
}