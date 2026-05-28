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
	- 공정진행 상세는 작업지시 기준으로 조회한다.
	- 생산실적이 있으면 production 테이블의 최신 실적 기준으로 표시한다.
	- LOSS_QTY는 불량수량이 아니라 LOSS량 / 손실수량이다.
	- 수정 가능: 담당자, 생산수량, LOSS량, 진행상태, 비고
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

			<c:if test="${not empty progress}">

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
				<input type="hidden" name="orderQty" value="${progress.orderQty}" />


				<div class="detail_card">

					<div class="detail_card_title">작업지시 기준 정보</div>

					<table class="detail_info_table progress_detail_table">
						<tbody>

							<tr>
								<th>작업지시번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.workOrderDocNo}">
											${progress.workOrderDocNo}
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
								<th>생산계획번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.prodPlanDocNo}">
											${progress.prodPlanDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산계획일</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.prodPlanDate}">
											${progress.prodPlanDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>납기일</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.dueDate}">
											${progress.dueDate}
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

								<th>단위</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.itemUnit}">
											${progress.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>라인</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.lineName}">
											${progress.lineName}
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
										<select name="empId" id="empId" class="detail_select"
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

								<th>최근 생산일</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.prodDate}">
											${progress.prodDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">진행 수량 정보</div>

					<table class="detail_info_table progress_detail_table">
						<tbody>

							<tr>
								<th>계획수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.prodPlanQty}">
											<fmt:formatNumber value="${progress.prodPlanQty}" pattern="#,##0" />
											${progress.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>작업지시수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.orderQty}">
											<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
											${progress.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>누적생산수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.totalProdQty}">
											<fmt:formatNumber value="${progress.totalProdQty}" pattern="#,##0" />
											${progress.itemUnit}
										</c:when>
										<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>최근 생산수량</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty progress.prodQty}">
												<fmt:formatNumber value="${progress.prodQty}" pattern="#,##0" />
												${progress.itemUnit}
											</c:when>
											<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="prodQty" id="prodQty"
											class="detail_input"
											value="${empty progress.prodQty ? 0 : progress.prodQty}"
											min="1"
											oninput="recalculateProgressRate();"
											data-edit-control disabled required />
									</div>
								</td>

								<th>누적 LOSS량</th>
								<td>
									<c:choose>
										<c:when test="${not empty progress.totalLossQty}">
											<fmt:formatNumber value="${progress.totalLossQty}" pattern="#,##0" />
											${progress.itemUnit}
										</c:when>
										<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
									</c:choose>
								</td>

								<th>최근 LOSS량</th>
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
											value="${empty progress.lossQty ? 0 : progress.lossQty}"
											min="0"
											data-edit-control disabled />
									</div>
								</td>
							</tr>


							<tr>
								<th>진행률</th>
								<td colspan="3">
									<div class="progress_detail_bar_wrap">
										<div class="progress_detail_bar">
											<div id="progressRateBar" class="progress_detail_bar_fill"
												style="width:${progress.progressRate}%;">
											</div>
										</div>

										<span id="progressRateText" class="progress_detail_rate">
											<fmt:formatNumber value="${progress.progressRate}" pattern="#,##0" />%
										</span>
									</div>
								</td>

								<th>진행상태</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${progress.progressStatus eq '완료'}">
												<span class="detail_status_badge detail_status_pass">
													완료
												</span>
											</c:when>

											<c:when test="${progress.progressStatus eq '보류' or progress.progressStatus eq '취소'}">
												<span class="detail_status_badge detail_status_fail">
													${progress.progressStatus}
												</span>
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
											class="detail_select" data-edit-control disabled required>
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
								<th>비고</th>
								<td colspan="5">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty progress.remark}">
												${progress.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="remark" id="remark"
											class="detail_input"
											value="${progress.remark}"
											maxlength="500"
											data-edit-control disabled />
									</div>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="detail_help_text">
						진행률은 누적생산수량 ÷ 작업지시수량 기준입니다.
						LOSS량은 불량수량이 아니라 생산 중 손실수량입니다.
					</div>

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
.progress_detail_table {
	width: 100%;
	table-layout: fixed;
}

.progress_detail_table th {
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

.progress_detail_table td {
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

.progress_detail_table td[colspan] {
	width: auto;
}

.progress_detail_table .detail_input,
.progress_detail_table .detail_select,
.progress_detail_table input,
.progress_detail_table select {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.progress_detail_bar_wrap {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
}

.progress_detail_bar {
	flex: 1;
	height: 9px;
	background: #e9edf0;
	border-radius: 99px;
	overflow: hidden;
}

.progress_detail_bar_fill {
	height: 100%;
	background: #174c3c;
	border-radius: 99px;
}

.progress_detail_rate {
	flex: 0 0 auto;
	font-size: 13px;
	font-weight: 700;
	color: #333;
}

.detail_help_text {
	margin-top: 10px;
	font-size: 13px;
	color: #666;
	line-height: 1.5;
	word-break: keep-all;
}
</style>


<script>
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

		recalculateProgressRate();
	}


	function recalculateProgressRate() {

		var prodQtyInput = document.getElementById("prodQty");
		var progressRateBar = document.getElementById("progressRateBar");
		var progressRateText = document.getElementById("progressRateText");

		if (prodQtyInput == null || progressRateBar == null || progressRateText == null) {
			return;
		}

		var orderQty = Number("${empty progress.orderQty ? 0 : progress.orderQty}");
		var prodQty = Number(prodQtyInput.value || 0);

		var rate = 0;

		if (orderQty > 0) {
			rate = Math.round((prodQty / orderQty) * 100);
		}

		if (rate > 100) {
			rate = 100;
		}

		if (rate < 0) {
			rate = 0;
		}

		progressRateBar.style.width = rate + "%";
		progressRateText.innerHTML = rate.toLocaleString() + "%";
	}


	function validateProcessProgressUpdateForm() {

		var prodId = "${progress.prodId}";
		var empId = document.getElementById("empId").value;
		var prodQty = document.getElementById("prodQty").value;
		var lossQty = document.getElementById("lossQty").value;
		var prodStatus = document.getElementById("prodStatus").value;

		if (prodId == null || prodId === "" || prodId === "0") {
			alert("수정할 생산실적 정보가 없습니다. 먼저 공정진행 또는 생산실적을 등록해주세요.");
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("empId").focus();
			return false;
		}

		if (prodQty === "" || Number(prodQty) <= 0) {
			alert("생산수량은 1 이상 입력해주세요.");
			document.getElementById("prodQty").focus();
			return false;
		}

		if (lossQty === "" || Number(lossQty) < 0) {
			alert("LOSS량은 0 이상 입력해주세요.");
			document.getElementById("lossQty").focus();
			return false;
		}

		if (Number(lossQty) > Number(prodQty)) {
			alert("LOSS량은 생산수량보다 클 수 없습니다.");
			document.getElementById("lossQty").focus();
			return false;
		}

		if (prodStatus === "") {
			alert("진행상태를 선택해주세요.");
			document.getElementById("prodStatus").focus();
			return false;
		}

		if (!confirm("공정진행 정보를 수정하시겠습니까?")) {
			return false;
		}

		return true;
	}


	<c:if test="${mode eq 'edit'}">
		changeEditMode(true);
	</c:if>
</script>