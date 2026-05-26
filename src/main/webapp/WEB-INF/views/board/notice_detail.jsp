<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<style>
.notice_content_box {
	min-height: 220px;
	white-space: pre-line;
	line-height: 1.7;
}

.notice_content_textarea {
	width: 100%;
	min-height: 220px;
	resize: vertical;
}

.notice_file_area {
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

.notice_file_link {
	color: #12362b;
	font-size: 14px;
	font-weight: 600;
	text-decoration: none;
}

.notice_file_link:hover {
	text-decoration: underline;
}

.notice_file_empty {
	color: #6b7280;
	font-size: 14px;
}
</style>

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">공지 상세</h2>
			<div class="detail_path">공지사항 &gt; 공지 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or (sessionScope.loginUser.role eq 'MANAGER'
				and sessionScope.loginUser.empno eq notice.empno)}">

				<button type="button" class="detail_btn_green" id="editBtn">
					수정
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/board/notice'">
				목록
			</button>

		</div>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">기본 정보</div>

		<form id="noticeDetailForm" method="post" accept-charset="UTF-8"
			action="${pageContext.request.contextPath}/board/notice/update">

			<input type="hidden" name="notice_id" value="${notice.notice_id}">

			<table class="detail_info_table">
				<colgroup>
					<col style="width: 12%;">
					<col style="width: 38%;">
					<col style="width: 12%;">
					<col style="width: 38%;">
				</colgroup>

				<tbody>
					<tr>
						<th>공지번호</th>
						<td>${notice.notice_id}</td>

						<th>상태</th>
						<td>
							<span class="viewMode">
								<c:choose>
									<c:when test="${notice.status == '게시'}">
										<span class="coStatus coStatusUse">${notice.status}</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusStop">${notice.status}</span>
									</c:otherwise>
								</c:choose>
							</span>

							<select name="status" class="detailInput editMode"
								style="display: none;">
								<option value="게시"
									<c:if test="${notice.status == '게시'}">selected</c:if>>
									게시
								</option>
								<option value="비게시"
									<c:if test="${notice.status == '비게시'}">selected</c:if>>
									비게시
								</option>
							</select>
						</td>
					</tr>

					<tr>
						<th>제목</th>
						<td colspan="3">
							<span class="viewMode">${notice.title}</span>

							<input type="text" name="title" class="detailInput editMode"
								value="${notice.title}" style="display: none;" required>
						</td>
					</tr>

					<tr>
						<th>작성자</th>
						<td>${notice.dept}</td>

						<th>작성일</th>
						<td>${notice.created_date}</td>
					</tr>

					<tr>
						<th>조회수</th>
						<td>${notice.view_count}</td>

						<th>수정일</th>
						<td>${notice.updated_date}</td>
					</tr>

					<tr>
						<th>내용</th>
						<td colspan="3">
							<div class="notice_content_box viewMode">
								${notice.content}
							</div>

							<textarea name="content"
								class="detailInput notice_content_textarea editMode"
								style="display: none;" required>${notice.content}</textarea>
						</td>
					</tr>

					<tr>
						<th>첨부파일</th>
						<td colspan="3">
							<div class="notice_file_area">
								<c:choose>
									<c:when test="${not empty noticeFile.file_path}">
										<a class="notice_file_link"
											href="${pageContext.request.contextPath}${noticeFile.file_path}"
											download="${noticeFile.file_title}">
											${noticeFile.file_title}
										</a>
									</c:when>

									<c:otherwise>
										<span class="notice_file_empty">첨부파일 없음</span>
									</c:otherwise>
								</c:choose>
							</div>
						</td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="3">
							<span class="viewMode">${notice.remark}</span>

							<input type="text" name="remark" class="detailInput editMode"
								value="${notice.remark}" style="display: none;">
						</td>
					</tr>
				</tbody>
			</table>

		</form>
	</div>

</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
	const editBtn = document.getElementById('editBtn');
	const form = document.getElementById('noticeDetailForm');

	if (!editBtn) {
		return;
	}

	editBtn.addEventListener('click', function () {
		const isEditMode = editBtn.dataset.mode === 'edit';

		if (!isEditMode) {
			document.querySelectorAll('.viewMode').forEach(function (el) {
				el.style.display = 'none';
			});

			document.querySelectorAll('.editMode').forEach(function (el) {
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