<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<c:set var="canManageQuality"
	value="${sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'}" />

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
						<path
							d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
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

						<th>검사일시</th>
						<td>
							<span class="viewMode">${inspection.insp_date}</span>
							<input type="date" name="insp_date"
								class="detailInput editMode"
								value="${inspection.insp_date}" style="display: none;"
								required>
						</td>

						<th>품목명</th>
						<td>${inspection.item_name}</td>
					</tr>

					<tr>
						<th>LOT번호</th>
						<td>${inspection.product_lot}</td>

						<th>검사자</th>
						<td>${inspection.ename}</td>

						<th>검사결과</th>
						<td>
							<span class="viewMode">
								<c:choose>
									<c:when test="${inspection.result == '조건부'}">
										<span class="coStatus coStatusStop">${inspection.result}</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusUse">${inspection.result}</span>
									</c:otherwise>
								</c:choose>
							</span>

							<select name="result" class="detailInput editMode"
								style="display: none;" required>
								<option value="합격"
									<c:if test="${inspection.result == '합격'}">selected</c:if>>
									합격</option>
								<option value="조건부"
									<c:if test="${inspection.result == '조건부'}">selected</c:if>>
									조건부</option>
							</select>
						</td>
					</tr>

					<tr>
						<th>검사구분</th>
						<td>
							<span class="viewMode">${inspection.insp_type}</span>
							<select name="insp_type" class="detailInput editMode"
								style="display: none;" required>
								<option value="수입검사"
									<c:if test="${inspection.insp_type == '수입검사'}">selected</c:if>>
									수입검사</option>
								<option value="공정검사"
									<c:if test="${inspection.insp_type == '공정검사'}">selected</c:if>>
									공정검사</option>
								<option value="최종검사"
									<c:if test="${inspection.insp_type == '최종검사'}">selected</c:if>>
									최종검사</option>
							</select>
						</td>

						<th>검사수량</th>
						<td>
							<span class="viewMode">${inspection.inspection_qty}</span>
							<input type="number" name="inspection_qty"
								class="detailInput editMode"
								value="${inspection.inspection_qty}" min="0"
								style="display: none;" required>
						</td>

						<th>양품수량</th>
						<td>
							<span class="viewMode">${inspection.good_qty}</span>
							<input type="number" name="good_qty"
								class="detailInput editMode"
								value="${inspection.good_qty}" min="0"
								style="display: none;" required>
						</td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="5">
							<span class="viewMode">${inspection.remark}</span>
							<input type="text" name="remark"
								class="detailInput editMode"
								value="${inspection.remark}" style="display: none;">
						</td>
					</tr>
				</tbody>
			</table>

		</form>
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