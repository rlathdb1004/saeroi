<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: processprogressdetail.jsp
	메뉴: 생산관리 > 공정진행 현황 > 공정진행 상세

	기준:
	- URL: /production/processprogress/detail
	- Controller return: production/processprogressdetail.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 공정진행 상세는 작업지시 기준 진행률 / 누적 생산수량 / 누적 불량수량 조회 화면
	- 수정은 최신 생산실적(PRODUCTION) 1건이 있는 경우에만 가능
	- 수정 가능: 생산수량, 불량수량, 진행상태, 담당자, 비고
	- 작업지시번호, LOT, 품목, 라인, 지시수량은 수정하지 않음
	- 지시수량 / 누적생산수량 / 누적불량수량 / 최신 실적수량 천단위 표시
	- 공용 detail.css 클래스명 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">공정진행 상세</h2>
			<div class="detail_path">생산관리 &gt; 공정진행 현황 &gt; 공정진행 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty progress and not empty progress.prodId}">

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
					form="processProgressUpdateForm" style="display: none;">
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
					onclick="location.href='${contextPath}/production/processprogress/detail?orderId=${progress.orderId}'"
					style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/processprogress'">
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

		<c:when test="${not empty progress}">

			<form id="processProgressUpdateForm"
				action="${contextPath}/production/processprogress/update"
				method="post"
				onsubmit="return validateProcessProgressUpdateForm();">

				<input type="hidden" name="orderId" value="${progress.orderId}" />
				<input type="hidden" name="prodId" value="${progress.prodId}" />

				<%-- =====================================================
				     작업지시 / 품목 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">작업지시 정보</div>

					<table class="detail_info_table process_progress_detail_table">
						<tbody>

							<tr>
								<th>작업지시번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.docNo}">
											${progress.docNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>완제품 LOT</th>
								<td title="${progress.productLot}">
									<c:choose>
										<c:when test="${not empty progress.productLot}">
											${progress.productLot}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>작업지시일</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.orderDate}">
											${progress.orderDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>품목코드</th>
								<td title="${progress.itemCode}">
									<c:choose>
										<c:when test="${not empty progress.itemCode}">
											${progress.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목명</th>
								<td title="${progress.itemName}">
									<c:choose>
										<c:when test="${not empty progress.itemName}">
											${progress.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.itemType}">
											${progress.itemType}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>라인코드</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.lineCode}">
											${progress.lineCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>라인명</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.lineName}">
											${progress.lineName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>지시수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.orderQty}">
											<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
											${progress.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

						</tbody>
					</table>

				</div>


				<%-- =====================================================
				     진행률 요약
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">진행률 요약</div>

					<div class="process-progress-summary">

						<div class="process-progress-summary-item">
							<div class="summary-label">지시수량</div>
							<div class="summary-value">
								<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
								${progress.itemUnit}
							</div>
						</div>

						<div class="process-progress-summary-item">
							<div class="summary-label">누적 생산수량</div>
							<div class="summary-value">
								<fmt:formatNumber value="${progress.totalProdQty}" pattern="#,##0" />
								${progress.itemUnit}
							</div>
						</div>

						<div class="process-progress-summary-item">
							<div class="summary-label">누적 불량수량</div>
							<div class="summary-value summary-loss">
								<fmt:formatNumber value="${progress.totalLossQty}" pattern="#,##0" />
								${progress.itemUnit}
							</div>
						</div>

						<div class="process-progress-summary-item">
							<div class="summary-label">진행상태</div>
							<div class="summary-value">
								<c:choose>
									<c:when test="${progress.progressStatus eq '완료'}">
										<span class="detail_status_badge detail_status_pass">완료</span>
									</c:when>

									<c:when test="${progress.progressStatus eq '보류'}">
										<span class="detail_status_badge detail_status_fail">보류</span>
									</c:when>

									<c:otherwise>
										<span class="detail_status_badge">
											${progress.progressStatus}
										</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

					</div>

					<div class="process-progress-rate-panel">

						<div class="process-progress-rate-top">
							<span>진행률</span>

							<strong>
								<c:choose>
									<c:when test="${not empty progress.progressRate}">
										${progress.progressRate}%
									</c:when>
									<c:otherwise>0%</c:otherwise>
								</c:choose>
							</strong>
						</div>

						<div class="process-progress-detail-bar">
							<div class="process-progress-detail-bar-fill"
								style="width:${empty progress.progressRate ? 0 : progress.progressRate}%;">
							</div>
						</div>

					</div>

					<div class="detail_help_text">
						진행률은 누적 생산수량 ÷ 지시수량 기준으로 계산됩니다.
					</div>

				</div>


				<%-- =====================================================
				     최신 생산실적 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">최신 생산실적 정보</div>

					<c:choose>

						<c:when test="${not empty progress.prodId}">

							<table class="detail_info_table process_progress_detail_table">
								<tbody>

									<tr>
										<th>실적 ID</th>
										<td>${progress.prodId}</td>

										<th>생산일자</th>
										<td>
											<c:choose>
												<c:when test="${not empty progress.prodDate}">
													${progress.prodDate}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>담당자</th>
										<td>
											<span data-view-value>
												<c:choose>
													<c:when test="${not empty progress.ename}">
														${progress.ename}
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
															<c:if test="${emp.empId == progress.empId}">selected</c:if>>
															${emp.ename} / ${emp.dept}
														</option>
													</c:forEach>
												</select>
											</div>
										</td>
									</tr>


									<tr>
										<th>생산수량</th>
										<td>
											<span data-view-value>
												<c:choose>
													<c:when test="${not empty progress.prodQty}">
														<fmt:formatNumber value="${progress.prodQty}" pattern="#,##0" />
														${progress.itemUnit}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</span>

											<div data-edit-box style="display: none;">
												<div class="process-progress-qty-box">
													<input type="number" name="prodQty" id="prodQty"
														class="detail_input"
														value="${progress.prodQty}"
														min="1"
														oninput="setProcessProgressQtyPreview();"
														data-edit-control disabled required />

													<input type="text"
														class="detail_input process-progress-unit-input"
														value="${progress.itemUnit}" readonly>
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
													<c:when test="${not empty progress.lossQty}">
														<fmt:formatNumber value="${progress.lossQty}" pattern="#,##0" />
														${progress.itemUnit}
													</c:when>
													<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
												</c:choose>
											</span>

											<div data-edit-box style="display: none;">
												<input type="number" name="lossQty" id="lossQty"
													class="detail_input"
													value="${progress.lossQty}"
													min="0"
													oninput="setProcessProgressQtyPreview();"
													data-edit-control disabled />

												<div id="lossQtyPreviewText" class="detail_help_text">
													불량수량은 생산수량보다 클 수 없습니다.
												</div>
											</div>
										</td>

										<th>진행상태</th>
										<td>
											<span data-view-value>
												<c:choose>
													<c:when test="${progress.progressStatus eq '완료'}">
														<span class="detail_status_badge detail_status_pass">완료</span>
													</c:when>
													<c:when test="${progress.progressStatus eq '보류'}">
														<span class="detail_status_badge detail_status_fail">보류</span>
													</c:when>
													<c:otherwise>
														<span class="detail_status_badge">
															${progress.progressStatus}
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
														<c:if test="${progress.progressStatus eq '진행중'}">selected</c:if>>
														진행중
													</option>
													<option value="완료"
														<c:if test="${progress.progressStatus eq '완료'}">selected</c:if>>
														완료
													</option>
													<option value="보류"
														<c:if test="${progress.progressStatus eq '보류'}">selected</c:if>>
														보류
													</option>
												</select>
											</div>
										</td>
									</tr>


									<tr>
										<th>부서</th>
										<td>
											<c:choose>
												<c:when test="${not empty progress.dept}">
													${progress.dept}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>비고</th>
										<td colspan="3">
											<span data-view-value>
												<c:choose>
													<c:when test="${not empty progress.remark}">
														${progress.remark}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</span>

											<div data-edit-box style="display: none;">
												<textarea name="remark" id="remark"
													class="detail_textarea process-progress-remark"
													maxlength="500"
													data-edit-control disabled>${progress.remark}</textarea>
											</div>
										</td>
									</tr>

								</tbody>
							</table>

							<div class="detail_help_text">
								수정은 최신 생산실적 1건에만 적용됩니다. 누적수량은 전체 생산실적 합계 기준으로 다시 계산됩니다.
							</div>

						</c:when>


						<c:otherwise>
							<div class="detail_empty_box">
								아직 등록된 생산실적이 없습니다. 목록 화면의 공정실적 등록 버튼으로 실적을 먼저 등록하세요.
							</div>
						</c:otherwise>

					</c:choose>

				</div>

			</form>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 공정진행 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* 공정진행 상세 전용: 3쌍(th+td) 테이블 폭 넘침 방지 */
.process_progress_detail_table {
	width: 100%;
	table-layout: fixed;
}

.process_progress_detail_table th {
	width: 9%;
	white-space: nowrap;
}

.process_progress_detail_table td {
	width: 24.3%;
	min-width: 0;
	vertical-align: middle;
	word-break: break-all;
}

.process_progress_detail_table .detail_input,
.process_progress_detail_table .detail_select,
.process_progress_detail_table .detail_textarea,
.process_progress_detail_table input,
.process_progress_detail_table select,
.process_progress_detail_table textarea {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.process_progress_detail_table .detail_help_text {
	margin-top: 6px;
	white-space: normal;
	word-break: keep-all;
	line-height: 1.4;
}

/* 진행률 요약 카드 */
.process-progress-summary {
	display: grid;
	grid-template-columns: repeat(4, minmax(0, 1fr));
	gap: 12px;
	margin-bottom: 18px;
}

.process-progress-summary-item {
	padding: 14px 16px;
	border: 1px solid #e5e8eb;
	border-radius: 10px;
	background: #f7f9fb;
	box-sizing: border-box;
}

.summary-label {
	font-size: 13px;
	color: #666;
	margin-bottom: 8px;
}

.summary-value {
	font-size: 18px;
	font-weight: 700;
	color: #222;
	word-break: keep-all;
}

.summary-loss {
	color: #b04747;
}

.process-progress-rate-panel {
	padding: 16px;
	border: 1px solid #e5e8eb;
	border-radius: 10px;
	background: #fff;
}

.process-progress-rate-top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 10px;
	color: #333;
}

.process-progress-rate-top span {
	font-size: 14px;
	font-weight: 700;
}

.process-progress-rate-top strong {
	font-size: 20px;
	font-weight: 800;
}

.process-progress-detail-bar {
	width: 100%;
	height: 12px;
	border-radius: 999px;
	background: #e9edf2;
	overflow: hidden;
}

.process-progress-detail-bar-fill {
	height: 100%;
	border-radius: 999px;
	background: #2f7d5b;
}

.process-progress-qty-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.process-progress-qty-box .detail_input:first-child {
	flex: 1 1 auto;
	min-width: 0;
}

.process-progress-unit-input {
	flex: 0 0 70px;
	text-align: center;
}

.process-progress-remark {
	min-height: 70px;
	resize: vertical;
}

@media (max-width: 900px) {
	.process-progress-summary {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
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
			setProcessProgressQtyPreview();
		}
	}


	/*
	 * 생산수량 / 불량수량 천단위 미리보기
	 */
	function setProcessProgressQtyPreview() {

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
		var unit = "${progress.itemUnit}";

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
	 * 공정진행 최신 실적 수정 검증
	 */
	function validateProcessProgressUpdateForm() {

		var prodIdElement = document.querySelector("input[name='prodId']");
		var prodQty = document.getElementById("prodQty").value;
		var lossQty = document.getElementById("lossQty").value;
		var prodStatus = document.getElementById("prodStatus").value;
		var empId = document.getElementById("empId").value;

		if (prodIdElement == null || prodIdElement.value === "") {
			alert("수정할 생산실적 정보가 없습니다.");
			return false;
		}

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
			alert("진행상태를 선택해주세요.");
			document.getElementById("prodStatus").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("empId").focus();
			return false;
		}

		if (!confirm("최신 공정실적 정보를 수정하시겠습니까?")) {
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


	<c:if test="${mode eq 'edit' and not empty progress.prodId}">
		changeEditMode(true);
	</c:if>
</script>