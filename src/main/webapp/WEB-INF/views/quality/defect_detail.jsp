<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<style>
.defect_status_badge {
	background-color: #FDECEC;
	color: #C62828;
	border: 1px solid #F5CACA;
}
</style>

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">불량 상세</h2>
			<div class="detail_path">품질관리 &gt; 불량관리 &gt; 불량 상세</div>
		</div>

		<div class="detail_btn_area">
			<button type="submit" id="saveBtn" class="detail_btn_green"
				form="defectDetailForm" style="display: none;">

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

			<button type="button" id="cancelBtn" class="detail_btn_line"
				onclick="changeEditMode(false);" style="display: none;">

				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path d="M18 6L6 18"></path>
					<path d="M6 6l12 12"></path>
				</svg>

				취소
			</button>

			<button type="button" id="editBtn" class="detail_btn_green"
				onclick="changeEditMode(true);">

				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path d="M12 20h9"></path>
					<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
				</svg>

				수정
			</button>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/quality/defect'">

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

		<form id="defectDetailForm" method="post"
			action="${pageContext.request.contextPath}/quality/defect/update">

			<input type="hidden" name="defect_list_id"
				value="${defect.defect_list_id}">

			<table class="detail_info_table">
				<colgroup>
					<col style="width: 12%;">
					<col style="width: 21%;">
					<col style="width: 12%;">
					<col style="width: 21%;">
					<col style="width: 12%;">
					<col style="width: 22%;">
				</colgroup>

				<tbody>
					<tr>
						<th>불량코드</th>
						<td>${defect.defect_code}</td>

						<th>발생일시</th>
						<td><span class="detailText">${defect.defect_date}</span> <input
							type="date" name="defect_date" class="detailInput"
							value="${defect.defect_date}" style="display: none;" required>
						</td>

						<th>품목명</th>
						<td>${defect.item_name}</td>
					</tr>

					<tr>
						<th>LOT번호</th>
						<td>${defect.product_lot}</td>

						<th>검사자</th>
						<td>${defect.ename}</td>

						<th>불량명</th>
						<td><span class="detailText detail_status_badge defect_status_badge">${defect.defect_name}</span>
							<select name="defect_id" class="detailInput"
							data-selected="${defect.defect_id}" style="display: none;"
							required>
								<option value="${defect.defect_id}" selected>${defect.defect_name}</option>
						</select></td>
					</tr>

					<tr>
						<th>검사번호</th>
						<td>${defect.insp_id}</td>

						<th>불량수량</th>
						<td><span class="detailText">${defect.defect_qty}</span> <input
							type="number" name="defect_qty" class="detailInput"
							value="${defect.defect_qty}" style="display: none;" min="0"
							required></td>

						<th>불량번호</th>
						<td>${defect.defect_list_id}</td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="5"><span class="detailText">${defect.remark}</span>
							<input type="text" name="remark" class="detailInput"
							value="${defect.remark}" style="display: none;"></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>

<script
	src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>
