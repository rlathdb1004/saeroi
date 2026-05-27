<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">검사 상세</h2>
			<div class="detail_path">품질관리 &gt; 검사관리 &gt; 검사 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">
				<button type="button" class="detail_btn_green" id="editBtn">
					수정
				</button>
			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">
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
								value="${inspection.insp_date}" style="display: none;" required>
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
									합격
								</option>
								<option value="조건부"
									<c:if test="${inspection.result == '조건부'}">selected</c:if>>
									조건부
								</option>
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
									수입검사
								</option>
								<option value="공정검사"
									<c:if test="${inspection.insp_type == '공정검사'}">selected</c:if>>
									공정검사
								</option>
								<option value="최종검사"
									<c:if test="${inspection.insp_type == '최종검사'}">selected</c:if>>
									최종검사
								</option>
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
							<input type="text" name="remark" class="detailInput editMode"
								value="${inspection.remark}" style="display: none;">
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
	const form = document.getElementById('inspectionDetailForm');

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