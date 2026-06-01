<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<c:set var="canManageQuality"
	value="${sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'}" />

<style>
.inspection_related_grid {
	display: grid;
	grid-template-columns: 1fr;
	gap: 16px;
	margin-top: 16px;
}

.inspection_related_table {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid #E1E8E3;
}

.inspection_related_table th, .inspection_related_table td {
	border: 1px solid #E1E8E3;
	padding: 11px 10px;
	text-align: center;
	font-size: 14px;
}

.inspection_related_table th {
	background: #F4F8F5;
	font-weight: 700;
	white-space: nowrap;
}

.inspection_related_table .coTextLeft {
	text-align: left;
}

.inspection_related_row {
	cursor: pointer;
}

.inspection_related_row:hover td {
	background: #F8FCF9;
}
/* .coStatusReady { */
/*     background-color: #F5F5F5; */
/*     color: #757575; */
/*     border: 1px solid #E0E0E0; */
/* } */
</style>

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">검사 상세</h2>
			<div class="detail_path">품질관리 &gt; 검사관리 &gt; 검사 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${canManageQuality}">
				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="inspectionDetailForm" style="display: none;">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>

					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="changeInspectionEditMode(false);" style="display: none;">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>

					취소
				</button>

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeInspectionEditMode(true);">

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
			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">

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

		<form id="inspectionDetailForm" method="post" accept-charset="UTF-8"
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

						<th>검사일자</th>
						<td><span class="viewMode">${inspection.insp_date}</span> <input
							type="date" name="insp_date" class="detailInput editMode"
							value="${inspection.insp_date}" style="display: none;" required>
						</td>

						<th>검사상태</th>
						<td>${inspection.insp_status}</td>
					</tr>

					<tr>
						<th>검사자</th>
						<td>${inspection.ename}</td>

						<th>부서</th>
						<td>${inspection.dept}</td>

						<th>검사결과</th>
						<td><span class="viewMode"> <c:choose>
									<c:when test="${inspection.result == '조건부'}">
										<span class="coStatus coStatusStop">${inspection.result}</span>
									</c:when>
									<c:when test="${inspection.result == '대기'}">
										<span class="coStatus coStatusUse">${inspection.result}</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusUse">${inspection.result}</span>
									</c:otherwise>
								</c:choose>
						</span> <select name="result" class="detailInput editMode"
							style="display: none;" required>
								<option value="합격"
									<c:if test="${inspection.result == '합격'}">selected</c:if>>합격</option>
								<option value="조건부"
									<c:if test="${inspection.result == '조건부'}">selected</c:if>>조건부</option>
						</select></td>
					</tr>


					<!-- 						<th>검사구분</th> -->
					<!-- 						<td> -->
					<%-- 							<span class="viewMode">${inspection.insp_type}</span> --%>
					<!-- 							<select name="insp_type" class="detailInput editMode" -->
					<!-- 								style="display: none;" required> -->
					<!-- 								<option value="외관검사" -->
					<%-- 									<c:if test="${inspection.insp_type == '외관검사'}">selected</c:if>>외관검사</option> --%>
					<!-- 								<option value="치수검사" -->
					<%-- 									<c:if test="${inspection.insp_type == '치수검사'}">selected</c:if>>치수검사</option> --%>
					<!-- 								<option value="품질판정" -->
					<%-- 									<c:if test="${inspection.insp_type == '품질판정'}">selected</c:if>>품질판정</option> --%>
					<!-- 								<option value="재검사" -->
					<%-- 									<c:if test="${inspection.insp_type == '재검사'}">selected</c:if>>재검사</option> --%>
					<!-- 								<option value="수입검사" -->
					<%-- 									<c:if test="${inspection.insp_type == '수입검사'}">selected</c:if>>수입검사</option> --%>
					<!-- 								<option value="공정검사" -->
					<%-- 									<c:if test="${inspection.insp_type == '공정검사'}">selected</c:if>>공정검사</option> --%>
					<!-- 								<option value="최종검사" -->
					<%-- 									<c:if test="${inspection.insp_type == '최종검사'}">selected</c:if>>최종검사</option> --%>
					<!-- 							</select> -->
					<!-- 						</td> -->

					<tr>
						<th>검사수량</th>
						<td><span class="viewMode">${inspection.inspection_qty}${inspection.item_unit}</span>
							<input type="number" name="inspection_qty"
							class="detailInput editMode" value="${inspection.inspection_qty}"
							min="0" style="display: none;" required></td>

						<th>양품수량</th>
						<td><span class="viewMode">${inspection.good_qty}${inspection.item_unit}</span>
							<input type="number" name="good_qty" class="detailInput editMode"
							value="${inspection.good_qty}" min="0" style="display: none;"
							required></td>

						<th>비고</th>
						<td><span class="viewMode">${inspection.remark}</span> <input
							type="text" name="remark" class="detailInput editMode"
							value="${inspection.remark}" style="display: none;"></td>
					</tr>
					<tr>
				</tbody>
			</table>

		</form>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">생산 및 품목 정보</div>

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
					<th>품목코드</th>
					<td>${inspection.item_code}</td>

					<th>품목명</th>
					<td colspan="3">${inspection.item_name}</td>
				</tr>

				<tr>
					<th>LOT번호</th>
					<td>${inspection.product_lot}</td>

					<th>생산문서번호</th>
					<td>${inspection.prod_doc_no}</td>

					<th>작업지시번호</th>
					<td>${inspection.work_order_doc_no}</td>
				</tr>

				<tr>
					<th>생산일자</th>
					<td>${inspection.prod_date}</td>

					<th>생산수량</th>
					<td>${inspection.prod_qty}${inspection.item_unit}</td>

					<th>손실수량</th>
					<td>${inspection.loss_qty}${inspection.item_unit}</td>
				</tr>

				<tr>
					<th>생산상태</th>
					<td>${inspection.prod_status}</td>

					<th>지시수량</th>
					<td>${inspection.order_qty}${inspection.item_unit}</td>

					<th>지시일자</th>
					<td>${inspection.order_date}</td>
				</tr>

				<tr>
					<th>등록일</th>
					<td>${inspection.created_date}</td>

					<th>수정일</th>
					<td colspan="3">${inspection.updated_date}</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="inspection_related_grid">
		<div class="detail_card">
			<div class="detail_card_title">불량 정보</div>

			<table class="inspection_related_table">
				<thead>
					<tr>
						<th>불량코드</th>
						<th>발생일시</th>
						<th>품목명</th>
						<th>LOT번호</th>
						<th>불량명</th>
						<th>검사자</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="defect" items="${inspectionDefectList}">
						<tr class="inspection_related_row"
							onclick="location.href='${pageContext.request.contextPath}/quality/defect_detail?defect_list_id=${defect.defect_list_id}'">
							<td>${defect.defect_code}</td>
							<td>${defect.defect_date}</td>
							<td class="coTextLeft">${defect.item_name}</td>
							<td>${defect.product_lot}</td>
							<td>${defect.defect_name}</td>
							<td>${defect.ename}</td>
						</tr>
					</c:forEach>

					<c:if test="${empty inspectionDefectList}">
						<tr>
							<td colspan="6">등록된 불량 정보가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

		<div class="detail_card">
			<div class="detail_card_title">조치 및 처리내역</div>

			<table class="inspection_related_table">
				<thead>
					<tr>
						<th>불량명</th>
						<th>조치일시</th>
						<th>조치부서</th>
						<th>조치담당자</th>
						<th>조치내용</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="action" items="${inspectionActionList}">
						<tr class="inspection_related_row"
							onclick="location.href='${pageContext.request.contextPath}/quality/defect_detail?defect_list_id=${action.defect_list_id}'">
							<td>${action.defect_name}</td>
							<td>${action.action_date}</td>
							<td>${action.dept}</td>
							<td>${action.action_ename}</td>
							<td class="coTextLeft">${action.action_content}</td>
						</tr>
					</c:forEach>

					<c:if test="${empty inspectionActionList}">
						<tr>
							<td colspan="5">등록된 조치 및 처리내역이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>

</div>

<script>
	function changeInspectionEditMode(isEdit) {
		const viewModes = document.querySelectorAll('.viewMode');
		const editModes = document.querySelectorAll('.editMode');

		const editBtn = document.getElementById('editBtn');
		const saveBtn = document.getElementById('saveBtn');
		const cancelBtn = document.getElementById('cancelBtn');
		const form = document.getElementById('inspectionDetailForm');

		viewModes.forEach(function(el) {
			el.style.display = isEdit ? 'none' : '';
		});

		editModes.forEach(function(el) {
			el.style.display = isEdit ? '' : 'none';
		});

		if (editBtn) {
			editBtn.style.display = isEdit ? 'none' : 'inline-flex';
		}

		if (saveBtn) {
			saveBtn.style.display = isEdit ? 'inline-flex' : 'none';
		}

		if (cancelBtn) {
			cancelBtn.style.display = isEdit ? 'inline-flex' : 'none';
		}

		if (!isEdit && form) {
			form.reset();
		}
	}
</script>
