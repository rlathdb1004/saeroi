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
					<td>${defect.defect_date}</td>

					<th>검사번호</th>
					<td>${defect.insp_doc_no}</td>
				</tr>

				<tr>
					<th>품목명</th>
					<td>${defect.item_name}</td>

					<th>LOT번호</th>
					<td>${defect.product_lot}</td>

					<th>검사자</th>
					<td>${defect.ename}</td>
				</tr>

				<tr>
					<th>불량명</th>
					<td>
						<span class="detail_status_badge defect_status_badge">${defect.defect_name}</span>
					</td>

					<th>불량수량</th>
					<td>${defect.defect_qty}</td>

					<th>불량번호</th>
					<td>${defect.defect_list_id}</td>
				</tr>

				<tr>
					<th>비고</th>
					<td colspan="5">${defect.remark}</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
