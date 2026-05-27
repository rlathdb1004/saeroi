<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: productionplandetail.jsp
	메뉴: 생산관리 > 생산계획 관리 > 생산계획 상세

	기준:
	- URL: /production/productionplan/detail
	- Controller return: production/productionplandetail.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 생산계획번호, 품목 정보는 수정하지 않음
	- 수정 가능: 계획수량, 계획일자, 납기일, 비고
	- 계획수량 천단위 표시
	- 수정 시 계획수량 1 이상, 납기일 >= 계획일자 검증
	- 공용 detail.css 클래스명 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">생산계획 상세</h2>
			<div class="detail_path">생산관리 &gt; 생산계획 관리 &gt; 생산계획 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty production}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path
							d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
						</path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="productionPlanUpdateForm" style="display: none;">
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
					onclick="location.href='${contextPath}/production/productionplan/detail?prodPlanId=${production.prodPlanId}'"
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


	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<c:choose>

		<c:when test="${not empty production}">

			<form id="productionPlanUpdateForm"
				action="${contextPath}/production/productionplan/update"
				method="post"
				onsubmit="return validateProductionPlanUpdateForm();">

				<input type="hidden" name="prodPlanId"
					value="${production.prodPlanId}" />

				<div class="detail_card">

					<div class="detail_card_title">생산계획 기본 정보</div>

					<table class="detail_info_table production_plan_detail_table">
						<tbody>

							<tr>
								<th>생산계획번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty production.docNo}">
											${production.docNo}
										</c:when>
										<c:otherwise>
											PP-${production.prodPlanId}
										</c:otherwise>
									</c:choose>
								</td>

								<th>품목코드</th>
								<td>
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


							<tr>
								<th>계획수량</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty production.prodPlanQty}">
												<fmt:formatNumber value="${production.prodPlanQty}"
													pattern="#,##0" />
												${production.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<div class="production-plan-qty-box">
											<input type="number" name="prodPlanQty" id="prodPlanQty"
												class="detail_input"
												value="${production.prodPlanQty}"
												min="1"
												oninput="setPlanQtyPreview();"
												data-edit-control disabled required />

											<input type="text" class="detail_input production-plan-unit-input"
												value="${production.itemUnit}" readonly>
										</div>

										<div id="qtyPreviewText" class="detail_help_text">
											계획수량을 입력하세요.
										</div>
									</div>
								</td>

								<th>계획일자</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty production.prodPlanDate}">
												${production.prodPlanDate}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="date" name="prodPlanDate" id="prodPlanDate"
											class="detail_input"
											value="${production.prodPlanDate}"
											onchange="checkPlanDateRange();"
											data-edit-control disabled required />
									</div>
								</td>

								<th>납기일</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty production.dueDate}">
												${production.dueDate}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="date" name="dueDate" id="dueDate"
											class="detail_input"
											value="${production.dueDate}"
											onchange="checkPlanDateRange();"
											data-edit-control disabled required />

										<div id="dateCheckText" class="detail_help_text">
											납기일은 계획일자와 같거나 이후여야 합니다.
										</div>
									</div>
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
								<td>
									<c:choose>
										<c:when test="${not empty production.updatedDate}">
											${production.updatedDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
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
								<th>비고</th>
								<td colspan="5">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty production.remark}">
												${production.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<textarea name="remark" id="remark"
											class="detail_textarea production-plan-remark"
											maxlength="500"
											data-edit-control disabled>${production.remark}</textarea>
									</div>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="detail_help_text">
						생산계획번호와 품목 정보는 수정하지 않습니다.
						생산계획이 작업지시로 연결된 이후에는 수량과 날짜 변경에 주의하세요.
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
/* 생산계획 상세 전용: 3쌍(th+td) 테이블 폭 넘침 방지 */
.production_plan_detail_table {
	width: 100%;
	table-layout: fixed;
}

.production_plan_detail_table th {
	width: 9%;
	white-space: nowrap;
}

.production_plan_detail_table td {
	width: 24.3%;
	min-width: 0;
	vertical-align: middle;
	word-break: break-all;
}

.production_plan_detail_table .detail_input,
.production_plan_detail_table .detail_select,
.production_plan_detail_table .detail_textarea,
.production_plan_detail_table input,
.production_plan_detail_table select,
.production_plan_detail_table textarea {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.production_plan_detail_table .detail_help_text {
	margin-top: 6px;
	white-space: normal;
	word-break: keep-all;
	line-height: 1.4;
}

.production-plan-qty-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.production-plan-qty-box .detail_input:first-child {
	flex: 1 1 auto;
	min-width: 0;
}

.production-plan-unit-input {
	flex: 0 0 70px;
	text-align: center;
}

.production-plan-remark {
	min-height: 70px;
	resize: vertical;
}

/* =========================================================
   생산관리 상세 공통 폭 보정
   - th 줄바꿈 방지
   - 컬럼명 영역 벗어남 방지
   - 횡스크롤 방지
   - 긴 데이터는 말줄임 처리
   ========================================================= */

/* 3쌍(th+td) 상세 테이블 공통 */
.production_plan_detail_table,
.workorder_detail_table,
.production_result_detail_table,
.process_progress_detail_table {
	width: 100%;
	max-width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
}

/* 컬럼명 폭 확대: 기존 9% → 12% */
.production_plan_detail_table th,
.workorder_detail_table th,
.production_result_detail_table th,
.process_progress_detail_table th {
	width: 12%;
	min-width: 0;
	padding-left: 12px;
	padding-right: 8px;
	white-space: nowrap;
	word-break: keep-all;
	overflow: hidden;
	text-overflow: clip;
	box-sizing: border-box;
	font-size: 13px;
}

/* 값 영역 폭 조정: 3쌍 기준 12% + 21.33% */
.production_plan_detail_table td,
.workorder_detail_table td,
.production_result_detail_table td,
.process_progress_detail_table td {
	width: 21.333%;
	min-width: 0;
	padding-left: 14px;
	padding-right: 10px;
	vertical-align: middle;
	white-space: nowrap;
	word-break: keep-all;
	overflow: hidden;
	text-overflow: ellipsis;
	box-sizing: border-box;
	font-size: 14px;
}

/* colspan 셀은 폭 자동 처리 */
.production_plan_detail_table td[colspan],
.workorder_detail_table td[colspan],
.production_result_detail_table td[colspan],
.process_progress_detail_table td[colspan] {
	width: auto;
}

/* 수정 input/select/textarea는 셀 안에서만 100% */
.production_plan_detail_table .detail_input,
.production_plan_detail_table .detail_select,
.production_plan_detail_table .detail_textarea,
.workorder_detail_table .detail_input,
.workorder_detail_table .detail_select,
.workorder_detail_table .detail_textarea,
.production_result_detail_table .detail_input,
.production_result_detail_table .detail_select,
.production_result_detail_table .detail_textarea,
.process_progress_detail_table .detail_input,
.process_progress_detail_table .detail_select,
.process_progress_detail_table .detail_textarea {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

/* 도움말은 줄바꿈 허용 */
.production_plan_detail_table .detail_help_text,
.workorder_detail_table .detail_help_text,
.production_result_detail_table .detail_help_text,
.process_progress_detail_table .detail_help_text {
	white-space: normal;
	word-break: keep-all;
	line-height: 1.4;
}

/* 카드 내부 횡스크롤 방지 */
.detail_card {
	max-width: 100%;
	overflow-x: hidden;
	box-sizing: border-box;
}

/* 작업지시 상세의 BOM/자재투입 표 횡스크롤 제거 */
.workorder_sub_table_wrap {
	width: 100%;
	max-width: 100%;
	overflow-x: hidden;
}

.workorder_sub_table {
	width: 100%;
	min-width: 0;
	max-width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
}

.workorder_sub_table th,
.workorder_sub_table td {
	padding: 9px 6px;
	white-space: nowrap;
	word-break: keep-all;
	overflow: hidden;
	text-overflow: ellipsis;
	box-sizing: border-box;
	font-size: 13px;
}

/* 진행률 요약 카드도 영역 밖으로 안 나가게 */
.process-progress-summary {
	width: 100%;
	max-width: 100%;
	box-sizing: border-box;
}

.process-progress-summary-item {
	min-width: 0;
	overflow: hidden;
}

.summary-value {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}
</style>


<script>
	/*
	 * 상세 수정 모드 전환
	 */
	function changeEditMode(isEdit) {

		var viewValueList = document.querySelectorAll("[data-view-value]");
		var editBoxList = document.querySelectorAll("[data-edit-box]");
		var editControlList = document.querySelectorAll("[data-edit-control]");

		for (var i = 0; i < viewValueList.length; i++) {
			viewValueList[i].style.display = isEdit ? "none" : "";
		}

		for (var j = 0; j < editBoxList.length; j++) {
			editBoxList[j].style.display = isEdit ? "block" : "none";
		}

		for (var k = 0; k < editControlList.length; k++) {
			editControlList[k].disabled = !isEdit;
		}

		document.getElementById("editBtn").style.display =
			isEdit ? "none" : "inline-flex";

		document.getElementById("saveBtn").style.display =
			isEdit ? "inline-flex" : "none";

		document.getElementById("cancelBtn").style.display =
			isEdit ? "inline-flex" : "none";

		if (isEdit) {
			setPlanQtyPreview();
			checkPlanDateRange();
		}
	}


	/*
	 * 계획수량 천단위 미리보기
	 */
	function setPlanQtyPreview() {

		var qtyElement = document.getElementById("prodPlanQty");
		var previewElement = document.getElementById("qtyPreviewText");

		if (qtyElement == null || previewElement == null) {
			return;
		}

		var qty = qtyElement.value;
		var unit = "${production.itemUnit}";

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


	/*
	 * 계획일자 / 납기일 검증
	 */
	function checkPlanDateRange() {

		var prodPlanDateElement = document.getElementById("prodPlanDate");
		var dueDateElement = document.getElementById("dueDate");
		var dateCheckText = document.getElementById("dateCheckText");

		if (prodPlanDateElement == null
				|| dueDateElement == null
				|| dateCheckText == null) {
			return true;
		}

		var prodPlanDate = prodPlanDateElement.value;
		var dueDate = dueDateElement.value;

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


	/*
	 * 생산계획 수정 검증
	 */
	function validateProductionPlanUpdateForm() {

		var prodPlanQty = document.getElementById("prodPlanQty").value;
		var prodPlanDate = document.getElementById("prodPlanDate").value;
		var dueDate = document.getElementById("dueDate").value;

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

		if (!confirm("생산계획을 수정하시겠습니까?")) {
			return false;
		}

		return true;
	}


	/*
	 * 숫자 천단위 구분 표시
	 */
	function formatNumber(value) {

		if (value == null || value === "") {
			return "";
		}

		var numberValue = Number(value);

		if (isNaN(numberValue)) {
			return value;
		}

		return numberValue.toLocaleString();
	}


	<c:if test="${mode eq 'edit'}">
		changeEditMode(true);
	</c:if>
</script>