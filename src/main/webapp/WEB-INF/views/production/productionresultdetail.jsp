<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: productionresultdetail.jsp
	메뉴: 생산관리 > 생산실적 등록 > 생산실적 상세

	기준:
	- URL: /production/productionresult/detail
	- Controller return: production/productionresultdetail.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 실적번호, 작업지시번호, LOT, 품목 정보는 수정하지 않음
	- 수정 가능: 생산수량, 불량수량, 생산상태, 담당자, 비고
	- 생산수량 / 불량수량 / 지시수량 천단위 표시
	- 수정 시 생산수량 1 이상, 불량수량 0 이상, 불량수량 <= 생산수량 검증
	- 공용 detail.css 클래스명 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">생산실적 상세</h2>
			<div class="detail_path">생산관리 &gt; 생산실적 등록 &gt; 생산실적 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty result}">

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
					form="productionResultUpdateForm" style="display: none;">
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
					onclick="location.href='${contextPath}/production/productionresult/detail?prodId=${result.prodId}'"
					style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/productionresult'">
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

		<c:when test="${not empty result}">

			<form id="productionResultUpdateForm"
				action="${contextPath}/production/productionresult/update"
				method="post"
				onsubmit="return validateProductionResultUpdateForm();">

				<input type="hidden" name="prodId" value="${result.prodId}" />

				<div class="detail_card">

					<div class="detail_card_title">생산실적 기본 정보</div>

					<table class="detail_info_table production_result_detail_table">
						<tbody>

							<tr>
								<th>실적번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.docNo}">
											${result.docNo}
										</c:when>
										<c:otherwise>
											PRD-${result.prodId}
										</c:otherwise>
									</c:choose>
								</td>

								<th>작업지시번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.workOrderDocNo}">
											${result.workOrderDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산계획번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.prodPlanDocNo}">
											${result.prodPlanDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>완제품 LOT</th>
								<td title="${result.productLot}">
									<c:choose>
										<c:when test="${not empty result.productLot}">
											${result.productLot}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목코드</th>
								<td title="${result.itemCode}">
									<c:choose>
										<c:when test="${not empty result.itemCode}">
											${result.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.itemType}">
											${result.itemType}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>품목명</th>
								<td colspan="3" title="${result.itemName}">
									<c:choose>
										<c:when test="${not empty result.itemName}">
											${result.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>단위</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.itemUnit}">
											${result.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>지시수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.orderQty}">
											<fmt:formatNumber value="${result.orderQty}" pattern="#,##0" />
											${result.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산수량</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty result.prodQty}">
												<fmt:formatNumber value="${result.prodQty}" pattern="#,##0" />
												${result.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<div class="production-result-qty-box">
											<input type="number" name="prodQty" id="prodQty"
												class="detail_input"
												value="${result.prodQty}"
												min="1"
												oninput="setProductionResultQtyPreview();"
												data-edit-control disabled required />

											<input type="text"
												class="detail_input production-result-unit-input"
												value="${result.itemUnit}" readonly>
										</div>

										<div id="prodQtyPreviewText" class="detail_help_text">
											생산수량을 입력하세요.
										</div>
									</div>
								</td>

								<th>불량수량</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty result.lossQty}">
												<fmt:formatNumber value="${result.lossQty}" pattern="#,##0" />
												${result.itemUnit}
											</c:when>
											<c:otherwise>0 ${result.itemUnit}</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="lossQty" id="lossQty"
											class="detail_input"
											value="${result.lossQty}"
											min="0"
											oninput="setProductionResultQtyPreview();"
											data-edit-control disabled />

										<div id="lossQtyPreviewText" class="detail_help_text">
											불량수량은 생산수량보다 클 수 없습니다.
										</div>
									</div>
								</td>
							</tr>


							<tr>
								<th>생산일자</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.prodDate}">
											${result.prodDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>작업지시일</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.orderDate}">
											${result.orderDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산상태</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${result.prodStatus eq '완료'}">
												<span class="detail_status_badge detail_status_pass">완료</span>
											</c:when>
											<c:when test="${result.prodStatus eq '보류'}">
												<span class="detail_status_badge detail_status_fail">보류</span>
											</c:when>
											<c:otherwise>
												<span class="detail_status_badge">
													${result.prodStatus}
												</span>
											</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="prodStatus" id="prodStatus"
											class="detail_select"
											data-edit-control disabled required>
											<option value="">선택</option>
											<option value="진행중"
												<c:if test="${result.prodStatus eq '진행중'}">selected</c:if>>
												진행중
											</option>
											<option value="완료"
												<c:if test="${result.prodStatus eq '완료'}">selected</c:if>>
												완료
											</option>
											<option value="보류"
												<c:if test="${result.prodStatus eq '보류'}">selected</c:if>>
												보류
											</option>
										</select>
									</div>
								</td>
							</tr>


							<tr>
								<th>담당자</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty result.ename}">
												${result.ename}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="empId" id="empId"
											class="detail_select"
											data-edit-control disabled required>
											<option value="">선택</option>

											<c:forEach var="emp" items="${empList}">
												<option value="${emp.empId}"
													<c:if test="${emp.empId == result.empId}">selected</c:if>>
													${emp.ename} / ${emp.dept}
												</option>
											</c:forEach>
										</select>
									</div>
								</td>

								<th>부서</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.dept}">
											${result.dept}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>직무</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.job}">
											${result.job}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.createdDate}">
											${result.createdDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.updatedDate}">
											${result.updatedDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>문서순번</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.docSeq}">
											${result.docSeq}
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
											<c:when test="${not empty result.remark}">
												${result.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<textarea name="remark" id="remark"
											class="detail_textarea production-result-remark"
											maxlength="500"
											data-edit-control disabled>${result.remark}</textarea>
									</div>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="detail_help_text">
						실적번호, 작업지시번호, LOT, 품목 정보는 수정하지 않습니다.
						생산수량과 불량수량은 품질/진행률 지표에 반영되므로 신중히 수정하세요.
					</div>

				</div>

			</form>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 생산실적 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* 생산실적 상세 전용: 3쌍(th+td) 테이블 폭 넘침 방지 */
.production_result_detail_table {
	width: 100%;
	table-layout: fixed;
}

.production_result_detail_table th {
	width: 9%;
	white-space: nowrap;
}

.production_result_detail_table td {
	width: 24.3%;
	min-width: 0;
	vertical-align: middle;
	word-break: break-all;
}

.production_result_detail_table .detail_input,
.production_result_detail_table .detail_select,
.production_result_detail_table .detail_textarea,
.production_result_detail_table input,
.production_result_detail_table select,
.production_result_detail_table textarea {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.production_result_detail_table .detail_help_text {
	margin-top: 6px;
	white-space: normal;
	word-break: keep-all;
	line-height: 1.4;
}

.production-result-qty-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.production-result-qty-box .detail_input:first-child {
	flex: 1 1 auto;
	min-width: 0;
}

.production-result-unit-input {
	flex: 0 0 70px;
	text-align: center;
}

.production-result-remark {
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
			setProductionResultQtyPreview();
		}
	}


	/*
	 * 생산수량 / 불량수량 천단위 미리보기
	 */
	function setProductionResultQtyPreview() {

		var prodQtyElement = document.getElementById("prodQty");
		var lossQtyElement = document.getElementById("lossQty");
		var prodPreview = document.getElementById("prodQtyPreviewText");
		var lossPreview = document.getElementById("lossQtyPreviewText");

		if (prodQtyElement == null
				|| lossQtyElement == null
				|| prodPreview == null
				|| lossPreview == null) {
			return;
		}

		var prodQty = prodQtyElement.value;
		var lossQty = lossQtyElement.value;
		var unit = "${result.itemUnit}";

		if (prodQty == null || prodQty === "") {
			prodPreview.innerHTML = "생산수량을 입력하세요.";
		} else if (Number(prodQty) <= 0) {
			prodPreview.innerHTML = "생산수량은 1 이상 입력해야 합니다.";
		} else {
			prodPreview.innerHTML =
				"생산수량: " + formatNumber(prodQty) + " " + (unit || "");
		}

		if (lossQty == null || lossQty === "") {
			lossPreview.innerHTML = "불량수량 미입력 시 0으로 처리됩니다.";
			return;
		}

		if (Number(lossQty) < 0) {
			lossPreview.innerHTML = "불량수량은 0 이상 입력해야 합니다.";
			return;
		}

		if (prodQty !== "" && Number(lossQty) > Number(prodQty)) {
			lossPreview.innerHTML = "불량수량은 생산수량보다 클 수 없습니다.";
			return;
		}

		lossPreview.innerHTML =
			"불량수량: " + formatNumber(lossQty) + " " + (unit || "");
	}


	/*
	 * 생산실적 수정 검증
	 */
	function validateProductionResultUpdateForm() {

		var prodQty = document.getElementById("prodQty").value;
		var lossQty = document.getElementById("lossQty").value;
		var prodStatus = document.getElementById("prodStatus").value;
		var empId = document.getElementById("empId").value;

		if (prodQty === "" || Number(prodQty) <= 0) {
			alert("생산수량은 1 이상 입력해주세요.");
			document.getElementById("prodQty").focus();
			return false;
		}

		if (lossQty === "") {
			document.getElementById("lossQty").value = 0;
			lossQty = 0;
		}

		if (Number(lossQty) < 0) {
			alert("불량수량은 0 이상 입력해주세요.");
			document.getElementById("lossQty").focus();
			return false;
		}

		if (Number(lossQty) > Number(prodQty)) {
			alert("불량수량은 생산수량보다 클 수 없습니다.");
			document.getElementById("lossQty").focus();
			return false;
		}

		if (prodStatus === "") {
			alert("생산상태를 선택해주세요.");
			document.getElementById("prodStatus").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("empId").focus();
			return false;
		}

		if (!confirm("생산실적 정보를 수정하시겠습니까?")) {
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