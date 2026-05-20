<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 디테일 페이지 공통 CSS를 연결한다. --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<%-- 팀원별 메뉴에 맞게 상세 페이지 제목을 변경한다. --%>
			<h2 class="detail_title">검사 상세</h2>

			<%-- 현재 페이지 위치를 표시한다. --%>
			<div class="detail_path">품질관리 &gt; 검사관리 &gt; 검사 상세</div>
		</div>

		<div class="detail_btn_area">

			<%-- 목록으로 버튼은 새 창이 아니라 현재 페이지에서 목록 화면으로 이동한다. --%>
			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">

				<%-- 목록 아이콘 SVG이다. --%>
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

			<%-- 수정 버튼은 새 창이 아니라 현재 페이지에서 입력창으로 변경한다. --%>
			<button type="button" class="detail_btn_green" id="detailEditBtn">

				<%-- 수정 아이콘 SVG이다. --%>
				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path d="M12 20h9"></path>
					<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
				</svg>

				수정
			</button>

			<%-- 저장 버튼은 수정 버튼을 누른 뒤 JS에서 보여줄 예정이다. --%>
			<button type="submit" class="detail_btn_green detailInput"
				form="inspectionDetailForm" style="display: none;">저장</button>
		</div>
	</div>

	<div class="detail_card">
		<%-- 상세 정보 카드 제목이다. --%>
		<div class="detail_card_title">기본 정보</div>

		<form id="inspectionDetailForm" method="post"
			action="${pageContext.request.contextPath}/quality/inspection/update">

			<input type="hidden" name="insp_id" value="${inspection.insp_id}">

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
						<th>검사번호</th>
						<td>${inspection.doc_no}</td>

						<th>검사일시</th>
						<td><span class="detailText">${inspection.insp_date}</span> <input
							type="date" name="insp_date" class="detailInput"
							value="${inspection.insp_date}" style="display: none;"></td>

						<th>품목명</th>
						<td><span class="detailText">${inspection.item_name}</span> <input
							type="text" name="item_name" class="detailInput"
							value="${inspection.item_name}" style="display: none;"></td>
					</tr>

					<tr>
						<th>LOT번호</th>
						<td>${inspection.product_lot}</td>

						<th>검사자</th>
						<td><span class="detailText">${inspection.ename}</span> <input
							type="text" name="ename" class="detailInput"
							value="${inspection.ename}" style="display: none;"></td>

						<th>검사결과</th>
						<td><span
							class="detailText detail_status_badge detail_status_pass">
								${inspection.result} </span> <select name="result" class="detailInput"
							style="display: none;">
								<option value="합격"
									<c:if test="${inspection.result == '합격'}">selected</c:if>>합격</option>
								<option value="조건부"
									<c:if test="${inspection.result == '조건부'}">selected</c:if>>조건부</option>
						</select></td>
					</tr>

					<tr>
						<th>검사구분</th>
						<td><span class="detailText">${inspection.insp_type}</span> <select
							name="insp_type" class="detailInput" style="display: none;">
								<option value="외관검사"
									<c:if test="${inspection.insp_type == '외관검사'}">selected</c:if>>외관검사</option>
								<option value="치수검사"
									<c:if test="${inspection.insp_type == '치수검사'}">selected</c:if>>치수검사</option>
								<option value="품질판정"
									<c:if test="${inspection.insp_type == '품질판정'}">selected</c:if>>품질판정</option>
								<option value="재검사"
									<c:if test="${inspection.insp_type == '재검사'}">selected</c:if>>재검사</option>
						</select></td>

						<th>검사수량</th>
						<td><span class="detailText">${inspection.inspection_qty}</span>
							<input type="number" name="inspection_qty" class="detailInput"
							value="${inspection.inspection_qty}" style="display: none;">
						</td>

						<th>양품수량</th>
						<td><span class="detailText">${inspection.good_qty}</span> <input
							type="number" name="good_qty" class="detailInput"
							value="${inspection.good_qty}" style="display: none;"></td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="5"><span class="detailText">${inspection.remark}</span>
							<input type="text" name="remark" class="detailInput"
							value="${inspection.remark}" style="display: none;"></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>

	<%-- 팀원별로 추가 상세 정보가 필요할 때 사용하는 영역이다. --%>
	<!-- 	<div class="detail_content_area"> -->
	<!-- 		<div class="detail_empty_box">팀원별 상세 내용을 추가하는 영역입니다.</div> -->
	<!-- 	</div> -->

</div>
<script
	src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>

