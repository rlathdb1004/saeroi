<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: productionplandetail.jsp
	메뉴: 생산관리 > 생산계획 관리 > 생산계획 상세

	기준:
	- URL: /production/productionplan/detail?prodPlanId=...
	- Controller return: production/productionplandetail.tiles
	- 2번째 팀원 상세페이지 기준으로 detail.css 공통 클래스 사용
	- 버튼 기준:
	  조회모드: [수정] [목록]
	  수정모드: [저장] [취소] [목록]
	- 수정 가능 항목:
	  계획수량, 계획일자, 납기일, 비고
	- 수정 불가 항목:
	  생산계획 ID, 생산계획번호, 문서순번, 품목 ID, 품목코드, 품목명, 품목구분, 단위, 등록일, 수정일
	- 모바일 대응은 common/mobile.css의 detail_info_table 기준 사용
	- 누락 컬럼 방지:
	  생산계획 ID, 생산계획번호, 문서순번, 품목 ID, 품목코드, 품목명, 품목구분, 단위,
	  계획수량, 계획일자, 납기일, 등록일, 수정일, 비고 전부 표시
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<div class="detail_header">

		<div>
			<h2 class="detail_title">생산계획 상세</h2>
			<div class="detail_path">생산관리 &gt; 생산계획 관리 &gt; 생산계획 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty production}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeProductionPlanEditMode(true);">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path
							d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
						</path>
					</svg>

					수정
				</button>


				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="productionPlanDetailForm"
					style="display: none;">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
						</path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>

					저장
				</button>


				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="changeProductionPlanEditMode(false);"
					style="display: none;">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>

					취소
				</button>

			</c:if>


			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/productionplan'">

				<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
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


	<c:choose>

		<c:when test="${not empty production}">

			<form id="productionPlanDetailForm" method="post"
				action="${contextPath}/production/productionplan/update"
				onsubmit="return checkProductionPlanUpdate();">

				<input type="hidden" name="prodPlanId"
					value="${production.prodPlanId}">


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
								<th>생산계획 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.prodPlanId}">
											${production.prodPlanId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산계획번호</th>
								<td title="${production.docNo}">
									<c:choose>
										<c:when test="${not empty production.docNo}">
											${production.docNo}
										</c:when>
										<c:otherwise>
											PP-${production.prodPlanId}
										</c:otherwise>
									</c:choose>
								</td>

								<th>문서순번</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.docSeq}">
											${production.docSeq}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.createdDate}">
											${production.createdDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td colspan="3">
									<c:choose>
										<c:when test="${not empty production.updatedDate}">
											${production.updatedDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">품목 정보</div>

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
								<th>품목 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.itemId}">
											${production.itemId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목코드</th>
								<td title="${production.itemCode}">
									<c:choose>
										<c:when test="${not empty production.itemCode}">
											${production.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.itemType}">
											${production.itemType}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>품목명</th>
								<td colspan="3" title="${production.itemName}">
									<c:choose>
										<c:when test="${not empty production.itemName}">
											${production.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>단위</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.itemUnit}">
											${production.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">계획 정보</div>

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
								<th>계획수량 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty production.prodPlanQty}">
												<fmt:formatNumber value="${production.prodPlanQty}"
													pattern="#,##0" />
												${production.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div class="editMode production_plan_input_wrap"
										style="display: none;">
										<input type="number" name="prodPlanQty"
											id="prodPlanQty"
											class="detailInput"
											value="${production.prodPlanQty}"
											min="1"
											oninput="setPlanQtyPreview();"
											disabled required>

										<span class="production_plan_unit_text">
											${production.itemUnit}
										</span>

										<span id="qtyPreviewText" class="detail_help_text">
											현재 수량:
											<fmt:formatNumber value="${production.prodPlanQty}"
												pattern="#,##0" />
											${production.itemUnit}
										</span>
									</div>
								</td>

								<th>계획일자 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty production.prodPlanDate}">
												${production.prodPlanDate}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<input type="date" name="prodPlanDate"
										id="prodPlanDate"
										class="detailInput editMode"
										value="${production.prodPlanDate}"
										onchange="checkPlanDateRange();"
										style="display: none;"
										disabled required>
								</td>

								<th>납기일 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty production.dueDate}">
												${production.dueDate}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<input type="date" name="dueDate"
										id="dueDate"
										class="detailInput editMode"
										value="${production.dueDate}"
										onchange="checkPlanDateRange();"
										style="display: none;"
										disabled required>

									<div id="dateCheckText"
										class="detail_help_text editMode"
										style="display: none;">
										납기일은 계획일자와 같거나 이후여야 합니다.
									</div>
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">비고</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 88%;">
						</colgroup>

						<tbody>
							<tr>
								<th>비고</th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty production.remark}">
												${production.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<textarea name="remark"
										id="remark"
										class="detailInput editMode production_plan_remark"
										maxlength="500"
										placeholder="생산계획 관련 메모를 입력하세요."
										style="display: none;"
										disabled>${production.remark}</textarea>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="detail_help_text">
						생산계획번호와 품목 정보는 수정하지 않습니다.
						작업지시가 생성된 생산계획은 수량과 날짜 변경 시 생산 흐름에 영향을 줄 수 있습니다.
					</div>

				</div>

			</form>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 생산계획 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* 생산계획 상세 전용 최소 보정: 공통 detail.css 입력 스타일을 유지하면서 단위와 안내문만 정렬한다. */
.production_plan_input_wrap {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.production_plan_input_wrap .detailInput {
	flex: 0 1 190px;
	width: 190px !important;
}

.production_plan_unit_text {
	flex: 0 0 auto;
	color: #374151;
	font-size: 14px;
	white-space: nowrap;
}

.production_plan_input_wrap .detail_help_text {
	margin-top: 0 !important;
	white-space: normal;
}

.production_plan_remark {
	min-height: 90px;
}

@media screen and (max-width: 768px) {
	.production_plan_input_wrap {
		align-items: stretch;
		flex-direction: column;
		gap: 6px;
	}

	.production_plan_input_wrap .detailInput {
		width: 100% !important;
		flex-basis: auto;
	}

	.production_plan_input_wrap .detail_help_text {
		margin-top: 4px !important;
	}
}
</style>


<script>
	function changeProductionPlanEditMode(isEdit) {

		const viewModes = document.querySelectorAll(".viewMode");
		const editModes = document.querySelectorAll(".editMode");
		const editControls = document.querySelectorAll(".editMode input, .editMode select, .editMode textarea, input.editMode, select.editMode, textarea.editMode");

		const editBtn = document.getElementById("editBtn");
		const saveBtn = document.getElementById("saveBtn");
		const cancelBtn = document.getElementById("cancelBtn");
		const form = document.getElementById("productionPlanDetailForm");

		viewModes.forEach(function(el) {
			el.style.display = isEdit ? "none" : "";
		});

		editModes.forEach(function(el) {
			el.style.display = isEdit ? "" : "none";
		});

		editControls.forEach(function(el) {
			el.disabled = !isEdit;
		});

		if (editBtn) {
			editBtn.style.display = isEdit ? "none" : "inline-flex";
		}

		if (saveBtn) {
			saveBtn.style.display = isEdit ? "inline-flex" : "none";
		}

		if (cancelBtn) {
			cancelBtn.style.display = isEdit ? "inline-flex" : "none";
		}

		if (!isEdit && form) {
			form.reset();
		}

		if (isEdit) {
			setPlanQtyPreview();
			checkPlanDateRange();
		}
	}


	function setPlanQtyPreview() {

		const qtyElement = document.getElementById("prodPlanQty");
		const previewElement = document.getElementById("qtyPreviewText");

		if (qtyElement == null || previewElement == null) {
			return;
		}

		const qty = qtyElement.value;
		const unit = "${production.itemUnit}";

		if (qty == null || qty === "") {
			previewElement.innerHTML = "계획수량을 입력하세요.";
			return;
		}

		if (Number(qty) <= 0) {
			previewElement.innerHTML = "계획수량은 1 이상 입력해야 합니다.";
			return;
		}

		previewElement.innerHTML =
			"입력수량: " + formatNumber(qty) + " " + (unit || "");
	}


	function checkPlanDateRange() {

		const prodPlanDateElement = document.getElementById("prodPlanDate");
		const dueDateElement = document.getElementById("dueDate");
		const dateCheckText = document.getElementById("dateCheckText");

		if (prodPlanDateElement == null
				|| dueDateElement == null
				|| dateCheckText == null) {
			return true;
		}

		const prodPlanDate = prodPlanDateElement.value;
		const dueDate = dueDateElement.value;

		if (prodPlanDate === "" || dueDate === "") {
			dateCheckText.innerHTML =
				"납기일은 계획일자와 같거나 이후여야 합니다.";
			return true;
		}

		if (dueDate < prodPlanDate) {
			dateCheckText.innerHTML =
				"납기일은 계획일자보다 빠를 수 없습니다.";
			return false;
		}

		dateCheckText.innerHTML =
			"계획일자와 납기일이 정상입니다.";
		return true;
	}


	function checkProductionPlanUpdate() {

		const prodPlanQty = document.getElementById("prodPlanQty").value;
		const prodPlanDate = document.getElementById("prodPlanDate").value;
		const dueDate = document.getElementById("dueDate").value;

		if (prodPlanQty === "" || Number(prodPlanQty) <= 0) {
			alert("계획수량은 1 이상 입력해주세요.");
			document.getElementById("prodPlanQty").focus();
			return false;
		}

		if (prodPlanDate === "") {
			alert("계획일자를 선택해주세요.");
			document.getElementById("prodPlanDate").focus();
			return false;
		}

		if (dueDate === "") {
			alert("납기일을 선택해주세요.");
			document.getElementById("dueDate").focus();
			return false;
		}

		if (dueDate < prodPlanDate) {
			alert("납기일은 계획일자보다 빠를 수 없습니다.");
			document.getElementById("dueDate").focus();
			return false;
		}

		if (!confirm("생산계획 정보를 수정하시겠습니까?")) {
			return false;
		}

		return true;
	}


	function formatNumber(value) {

		if (value == null || value === "") {
			return "";
		}

		const numberValue = Number(value);

		if (isNaN(numberValue)) {
			return value;
		}

		return numberValue.toLocaleString();
	}


	<c:if test="${mode eq 'edit'}">
		changeProductionPlanEditMode(true);
	</c:if>
</script>