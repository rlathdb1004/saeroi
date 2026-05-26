<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<style>
.notice_content_textarea {
	width: 100%;
	min-height: 180px;
	resize: vertical;
}

.notice_file_area {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
	height: 42px;
	padding: 0 12px;
	border: 1px solid #4f8068;
	border-radius: 6px;
	background-color: #f8fffb;
	box-sizing: border-box;
}

.notice_file_input {
	display: none;
}

.notice_file_btn {
	height: 28px;
	padding: 0 12px;
	border: 1px solid #4f8068;
	border-radius: 5px;
	background-color: #ffffff;
	color: #12362b;
	font-size: 13px;
	font-weight: 600;
	line-height: 26px;
	cursor: pointer;
	box-sizing: border-box;
}

.notice_file_btn:hover {
	background-color: #eaf4ef;
}

.notice_file_name {
	color: #111827;
	font-size: 13px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
</style>

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">공지 등록</h2>
			<div class="detail_path">공지사항 &gt; 공지 등록</div>
		</div>

		<div class="detail_btn_area">

			<button type="submit" class="detail_btn_green" form="noticeAddForm">
				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path
						d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
					<path d="M17 21v-8H7v8"></path>
					<path d="M7 3v5h8"></path>
				</svg>
				저장
			</button>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/board/notice'">
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

		<form id="noticeAddForm" method="post" enctype="multipart/form-data"
			accept-charset="UTF-8"
			action="${pageContext.request.contextPath}/board/notice/add">

			<table class="detail_info_table">
				<colgroup>
					<col style="width: 12%;">
					<col style="width: 38%;">
					<col style="width: 12%;">
					<col style="width: 38%;">
				</colgroup>

				<tbody>
					<tr>
						<th>제목</th>
						<td colspan="3">
							<input type="text" name="title" class="detailInput"
								placeholder="공지 제목을 입력하세요." required>
						</td>
					</tr>

					<tr>
						<th>작성자</th>
						<td>MES 관리자</td>

						<th>상태</th>
						<td>
							<select name="status" class="detailInput" required>
								<option value="게시" selected>게시</option>
								<option value="비게시">비게시</option>
							</select>
						</td>
					</tr>

					<tr>
						<th>내용</th>
						<td colspan="3">
							<textarea name="content"
								class="detailInput notice_content_textarea"
								placeholder="공지 내용을 입력하세요." required></textarea>
						</td>
					</tr>

					<tr>
						<th>첨부파일</th>
						<td colspan="3">
							<div class="notice_file_area">
								<label for="noticeFile" class="notice_file_btn">파일 선택</label>

								<span id="noticeFileName" class="notice_file_name">
									선택된 파일 없음
								</span>

								<input type="file" id="noticeFile" name="noticeFile"
									class="notice_file_input"
									onchange="document.getElementById('noticeFileName').innerText = this.files.length > 0 ? this.files[0].name : '선택된 파일 없음';">
							</div>
						</td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="3">
							<input type="text" name="remark" class="detailInput"
								placeholder="비고를 입력하세요.">
						</td>
					</tr>
				</tbody>
			</table>

		</form>
	</div>

</div>