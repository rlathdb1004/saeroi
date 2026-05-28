<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<c:set var="isLogin" value="${not empty sessionScope.loginUser}" />
<c:set var="isAdmin" value="${sessionScope.loginUser.role eq 'ADMIN'}" />
<c:set var="isWriter"
	value="${isLogin and sessionScope.loginUser.empno eq board.empno}" />
<c:set var="canModifyBoard" value="${isAdmin or isWriter}" />

<style>
.board_content_box {
	min-height: 220px;
	white-space: pre-line;
	line-height: 1.7;
}

.board_content_textarea {
	width: 100%;
	min-height: 220px;
	resize: vertical;
}

.board_file_area {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
	min-height: 42px;
	padding: 0 12px;
	border: 1px solid #4f8068;
	border-radius: 6px;
	background-color: #f8fffb;
	box-sizing: border-box;
}

.board_file_link {
	color: #12362b;
	font-size: 14px;
	font-weight: 600;
	text-decoration: none;
}

.board_file_link:hover {
	text-decoration: underline;
}

.board_file_empty {
	color: #6b7280;
	font-size: 14px;
}

.coStatusWait {
	color: #8a5a00;
	background: #fff4cc;
	border: 1px solid #f2d27a;
}

.board_comment_card {
	margin-top: 18px;
}

.board_comment_write {
	display: flex;
	gap: 10px;
	margin-top: 12px;
}

.board_comment_input_area {
	flex: 1;
	height: auto;
	min-height: 80px;
	padding: 0;
	align-items: stretch;
}

.board_comment_textarea {
	width: 100%;
	min-height: 80px;
	padding: 12px;
	border: 0;
	outline: none;
	background: transparent;
	resize: vertical;
	font-size: 14px;
	font-family: inherit;
	box-sizing: border-box;
}

.board_comment_list {
	margin-top: 18px;
	border-top: 1px solid #d9e2dd;
}

.board_comment_item {
	padding: 14px 0;
	border-bottom: 1px solid #d9e2dd;
}

.board_comment_meta {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 8px;
	font-size: 13px;
	color: #647067;
}

.board_comment_writer {
	font-weight: 700;
	color: #12362b;
}

.board_comment_content {
	white-space: pre-line;
	line-height: 1.6;
}

.board_comment_delete_form {
	margin: 0;
}
</style>

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">게시판 상세</h2>
			<div class="detail_path">게시판 &gt; 건의사항 &gt; 건의사항 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${canModifyBoard}">
				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>

					수정
				</button>

				<button type="submit" class="search-btn search-btn-sub">
					<svg viewBox="0 0 24 24" fill="none">
		<path d="M4 7H20" stroke="currentColor" stroke-width="2"
							stroke-linecap="round"></path>
		<path d="M10 11V17" stroke="currentColor" stroke-width="2"
							stroke-linecap="round"></path>
		<path d="M14 11V17" stroke="currentColor" stroke-width="2"
							stroke-linecap="round"></path>
		<path d="M6 7L7 21H17L18 7" stroke="currentColor" stroke-width="2"
							stroke-linejoin="round"></path>
		<path d="M9 7V4H15V7" stroke="currentColor" stroke-width="2"
							stroke-linejoin="round"></path>
	</svg>
					삭제
				</button>
			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/board/suggestion'">
				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path d="M8 6h13"></path>
					<path d="M8 12h13"></path>
					<path d="M8 18h13"></path>
					<path d="M3 6h.01"></path>
					<path d="M3 12h.01"></path>
					<path d="M3 18h.01"></path>
				</svg>
				목록
			</button>

		</div>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">기본 정보</div>

		<form id="boardDetailForm" method="post" accept-charset="UTF-8"
			action="${pageContext.request.contextPath}/board/suggestion/update">

			<input type="hidden" name="board_id" value="${board.board_id}">

			<table class="detail_info_table">
				<colgroup>
					<col style="width: 12%;">
					<col style="width: 38%;">
					<col style="width: 12%;">
					<col style="width: 38%;">
				</colgroup>

				<tbody>
					<tr>
						<th>게시번호</th>
						<td>${board.board_id}</td>

						<th>처리상태</th>
						<td><span class="viewMode"> <c:choose>
									<c:when test="${board.status == '처리완료'}">
										<span class="coStatus coStatusUse">${board.status}</span>
									</c:when>
									<c:when test="${board.status == '반려'}">
										<span class="coStatus coStatusStop">${board.status}</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusWait">${board.status}</span>
									</c:otherwise>
								</c:choose>
						</span> <select name="status" class="detailInput editMode"
							style="display: none;">
								<option value="접수"
									<c:if test="${board.status == '접수'}">selected</c:if>>
									접수</option>
								<option value="처리완료"
									<c:if test="${board.status == '처리완료'}">selected</c:if>>
									처리완료</option>
								<option value="반려"
									<c:if test="${board.status == '반려'}">selected</c:if>>
									반려</option>
						</select></td>
					</tr>

					<tr>
						<th>제목</th>
						<td colspan="3"><span class="viewMode">${board.title}</span>
							<input type="text" name="title" class="detailInput editMode"
							value="${board.title}" style="display: none;" required></td>
					</tr>

					<tr>
						<th>작성자</th>
						<td>${board.ename}</td>

						<th>부서</th>
						<td>${board.dept}</td>
					</tr>

					<tr>
						<th>조회수</th>
						<td>${board.view_count}</td>

						<th>작성일</th>
						<td>${board.created_date}</td>
					</tr>

					<tr>
						<th>수정일</th>
						<td>${board.updated_date}</td>

						<th>비고</th>
						<td><span class="viewMode">${board.remark}</span> <input
							type="text" name="remark" class="detailInput editMode"
							value="${board.remark}" style="display: none;"></td>
					</tr>

					<tr>
						<th>내용</th>
						<td colspan="3">
							<div class="board_content_box viewMode">${board.content}</div> <textarea
								name="content"
								class="detailInput board_content_textarea editMode"
								style="display: none;" required>${board.content}</textarea>
						</td>
					</tr>

					<tr>
						<th>첨부파일</th>
						<td colspan="3">
							<div class="board_file_area">
								<c:choose>
									<c:when test="${not empty boardFile.file_path}">
										<a class="board_file_link"
											href="${pageContext.request.contextPath}${boardFile.file_path}"
											download="${boardFile.file_title}">
											${boardFile.file_title} </a>
									</c:when>

									<c:otherwise>
										<span class="board_file_empty">첨부파일 없음</span>
									</c:otherwise>
								</c:choose>
							</div>
						</td>
					</tr>
				</tbody>
			</table>

		</form>
	</div>

	<form id="boardDeleteForm" method="post"
		action="${pageContext.request.contextPath}/board/suggestion/delete"
		onsubmit="return confirm('삭제하시겠습니까?');">
		<input type="hidden" name="board_id" value="${board.board_id}">
	</form>

	<div class="detail_card board_comment_card">
		<div class="detail_card_title">댓글</div>

		<c:choose>
			<c:when test="${not empty sessionScope.loginUser}">
				<form method="post" accept-charset="UTF-8"
					action="${pageContext.request.contextPath}/board/suggestion/comment/add">

					<input type="hidden" name="board_id" value="${board.board_id}">

					<div class="board_comment_write">
						<div class="board_file_area board_comment_input_area">
							<textarea name="content" class="board_comment_textarea"
								placeholder="댓글을 입력하세요." required></textarea>
						</div>

						<button type="submit" class="search-btn search-btn-main">
							<svg viewBox="0 0 24 24" fill="none">
								<path d="M12 5V19" stroke="currentColor" stroke-width="2"
									stroke-linecap="round"></path>
								<path d="M5 12H19" stroke="currentColor" stroke-width="2"
									stroke-linecap="round"></path>
							</svg>
							등록
						</button>
					</div>
				</form>
			</c:when>

			<c:otherwise>
				<div class="board_file_area">
					<span class="board_file_empty">로그인 후 댓글을 작성할 수 있습니다.</span>
				</div>
			</c:otherwise>
		</c:choose>

		<div class="board_comment_list">
			<c:forEach var="comment" items="${commentList}">
				<c:set var="canDeleteComment"
					value="${sessionScope.loginUser.role eq 'ADMIN'
						or sessionScope.loginUser.empno eq comment.empno}" />

				<div class="board_comment_item">
					<div class="board_comment_meta">
						<div>
							<span class="board_comment_writer">${comment.ename}</span> <span>${comment.created_date}</span>
						</div>

						<c:if test="${canDeleteComment}">
							<form class="board_comment_delete_form" method="post"
								action="${pageContext.request.contextPath}/board/suggestion/comment/delete"
								onsubmit="return confirm('댓글을 삭제하시겠습니까?');">

								<input type="hidden" name="board_id" value="${board.board_id}">
								<input type="hidden" name="comment_id"
									value="${comment.comment_id}">

								<button type="submit" class="search-btn search-btn-sub">
									<svg viewBox="0 0 24 24" fill="none">
										<path d="M4 7H20" stroke="currentColor" stroke-width="2"
											stroke-linecap="round"></path>
										<path d="M10 11V17" stroke="currentColor" stroke-width="2"
											stroke-linecap="round"></path>
										<path d="M14 11V17" stroke="currentColor" stroke-width="2"
											stroke-linecap="round"></path>
										<path d="M6 7L7 21H17L18 7" stroke="currentColor"
											stroke-width="2" stroke-linejoin="round"></path>
										<path d="M9 7V4H15V7" stroke="currentColor" stroke-width="2"
											stroke-linejoin="round"></path>
									</svg>
									삭제
								</button>
							</form>
						</c:if>
					</div>

					<div class="board_comment_content">${comment.content}</div>
				</div>
			</c:forEach>

			<c:if test="${empty commentList}">
				<div class="board_comment_item">
					<div class="board_comment_content">등록된 댓글이 없습니다.</div>
				</div>
			</c:if>
		</div>
	</div>

</div>

<script>
	document.addEventListener('DOMContentLoaded', function() {
		const editBtn = document.getElementById('editBtn');
		const form = document.getElementById('boardDetailForm');

		if (!editBtn) {
			return;
		}

		editBtn.addEventListener('click', function() {
			const isEditMode = editBtn.dataset.mode === 'edit';

			if (!isEditMode) {
				document.querySelectorAll('.viewMode').forEach(function(el) {
					el.style.display = 'none';
				});

				document.querySelectorAll('.editMode').forEach(function(el) {
					el.style.display = '';
				});

				editBtn.dataset.mode = 'edit';
				editBtn.textContent = '저장';
				return;
			}

			form.submit();
		});
	});
</script>