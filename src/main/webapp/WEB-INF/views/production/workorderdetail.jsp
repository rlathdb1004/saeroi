<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: workorderdetail.jsp
	메뉴: 생산관리 > 작업지시 관리 > 작업지시 상세

	기준:
	- URL: /production/workorder/detail
	- Controller return: production/workorderdetail.tiles
	- 생산관리 파일 구조 유지
	  DTO / DAO / Service / Controller / Mapper는 생산관리 1개 파일로 관리
	  JSP만 페이지별 관리
	- 작업지시번호, 완제품 LOT, 생산계획, 품목 정보는 수정하지 않음
	- 수정 가능: 라인, 담당자, 지시수량, 비고
	- 적용 BOM / BOM 기준 원자재 소요량 / 자동 생성된 원자재 투입 이력 표시
	- 공용 detail.css 클래스명 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">작업지시 상세</h2>
			<div class="detail_path">생산관리 &gt; 작업지시 관리 &gt; 작업지시 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty workOrder}">

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
					form="workOrderUpdateForm" style="display: none;">
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
					onclick="location.href='${contextPath}/production/workorder/detail?orderId=${workOrder.orderId}'"
					style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/workorder'">
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

		<c:when test="${not empty workOrder}">

			<form id="workOrderUpdateForm"
				action="${contextPath}/production/workorder/update"
				method="post"
				onsubmit="return validateWorkOrderUpdateForm();">

				<input type="hidden" name="orderId" value="${workOrder.orderId}" />

				<div class="detail_card">

					<div class="detail_card_title">작업지시 기본 정보</div>

					<table class="detail_info_table workorder_detail_table">
						<tbody>

							<tr>
								<th>작업지시번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.docNo}">
											${workOrder.docNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>완제품 LOT</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.productLot}">
											${workOrder.productLot}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>작업상태</th>
								<td>
									<c:choose>
										<c:when test="${workOrder.prodStatus eq '완료'}">
											<span class="detail_status_badge detail_status_pass">완료</span>
										</c:when>
										<c:when test="${workOrder.prodStatus eq '보류' or workOrder.prodStatus eq '취소'}">
											<span class="detail_status_badge detail_status_fail">
												${workOrder.prodStatus}
											</span>
										</c:when>
										<c:otherwise>
											<span class="detail_status_badge">
												${workOrder.prodStatus}
											</span>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>생산계획번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.prodPlanDocNo}">
											${workOrder.prodPlanDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목코드</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.itemCode}">
											${workOrder.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목명</th>
								<td title="${workOrder.itemName}">
									<c:choose>
										<c:when test="${not empty workOrder.itemName}">
											${workOrder.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>계획수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.prodPlanQty}">
											<fmt:formatNumber value="${workOrder.prodPlanQty}" pattern="#,##0" />
											${workOrder.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>지시수량</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty workOrder.orderQty}">
												<fmt:formatNumber value="${workOrder.orderQty}" pattern="#,##0" />
												${workOrder.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="orderQty" id="orderQty"
											class="detail_input"
											value="${workOrder.orderQty}"
											min="1"
											data-edit-control disabled required />
									</div>
								</td>

								<th>작업지시일</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.orderDate}">
											${workOrder.orderDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>생산라인</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty workOrder.lineName}">
												${workOrder.lineName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="lineId" id="lineId" class="detail_select"
											data-edit-control disabled required>
											<option value="">선택</option>

											<c:forEach var="line" items="${lineList}">
												<option value="${line.lineId}"
													<c:if test="${line.lineId == workOrder.lineId}">selected</c:if>>
													${line.lineName}
												</option>
											</c:forEach>
										</select>
									</div>
								</td>

								<th>담당자</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty workOrder.ename}">
												${workOrder.ename}
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
													<c:if test="${emp.empId == workOrder.empId}">selected</c:if>>
													${emp.ename} / ${emp.dept}
												</option>
											</c:forEach>
										</select>
									</div>
								</td>

								<th>납기일</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.dueDate}">
											${workOrder.dueDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.createdDate}">
											${workOrder.createdDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty workOrder.updatedDate}">
											${workOrder.updatedDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>비고</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty workOrder.remark}">
												${workOrder.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="remark" id="remark"
											class="detail_input"
											value="${workOrder.remark}"
											maxlength="500"
											data-edit-control disabled />
									</div>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="detail_help_text">
						작업지시번호, 완제품 LOT, 생산계획, 품목 정보는 수정하지 않습니다.
						지시수량 변경 시 기존 자동투입 이력과 차이가 생길 수 있으므로 신중히 수정하세요.
					</div>

				</div>

			</form>


			<%-- =====================================================
			     적용 BOM 정보
			     ===================================================== --%>
			<div class="detail_card">

				<div class="detail_card_title">적용 BOM 정보</div>

				<c:choose>
					<c:when test="${not empty appliedBom}">

						<table class="detail_info_table workorder_detail_table">
							<tbody>
								<tr>
									<th>BOM 코드</th>
									<td>
										<c:choose>
											<c:when test="${not empty appliedBom.bomCode}">
												${appliedBom.bomCode}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<th>버전</th>
									<td>
										<c:choose>
											<c:when test="${not empty appliedBom.bomVersion}">
												V${appliedBom.bomVersion}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<th>사용여부</th>
									<td>
										<c:choose>
											<c:when test="${appliedBom.bomUseYn eq 'Y'}">
												<span class="detail_status_badge detail_status_pass">사용</span>
											</c:when>
											<c:otherwise>
												<span class="detail_status_badge detail_status_fail">미사용</span>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<tr>
									<th>완제품 코드</th>
									<td>${appliedBom.itemCode}</td>

									<th>완제품명</th>
									<td title="${appliedBom.itemName}">
										${appliedBom.itemName}
									</td>

									<th>단위</th>
									<td>${appliedBom.itemUnit}</td>
								</tr>
							</tbody>
						</table>

					</c:when>

					<c:otherwise>
						<div class="detail_empty_box">
							적용 가능한 BOM 정보가 없습니다.
						</div>
					</c:otherwise>
				</c:choose>

			</div>


			<%-- =====================================================
			     BOM 기준 원자재 소요량
			     ===================================================== --%>
			<div class="detail_card">

				<div class="detail_card_title">BOM 기준 원자재 소요량</div>

				<div class="workorder_sub_table_wrap">

					<table class="workorder_sub_table">
						<thead>
							<tr>
								<th>순번</th>
								<th>자재코드</th>
								<th>자재명</th>
								<th>기준소요량</th>
								<th>필요수량</th>
								<th>가용수량</th>
								<th>상태</th>
							</tr>
						</thead>

						<tbody>
							<c:choose>
								<c:when test="${not empty bomMaterialList}">

									<c:forEach var="material" items="${bomMaterialList}" varStatus="status">
										<tr>
											<td>${status.count}</td>

											<td title="${material.materialItemCode}">
												${material.materialItemCode}
											</td>

											<td class="coTextLeft" title="${material.materialItemName}">
												${material.materialItemName}
											</td>

											<td>
												<fmt:formatNumber value="${material.bomQty}" pattern="#,##0.####" />
												${material.materialItemUnit}
											</td>

											<td>
												<fmt:formatNumber value="${material.requiredQty}" pattern="#,##0.####" />
												${material.materialItemUnit}
											</td>

											<td>
												<fmt:formatNumber value="${material.availableQty}" pattern="#,##0.####" />
												${material.materialItemUnit}
											</td>

											<td>
												<c:choose>
													<c:when test="${material.shortageYn eq 'Y'}">
														<span class="detail_status_badge detail_status_fail">부족</span>
													</c:when>
													<c:otherwise>
														<span class="detail_status_badge detail_status_pass">정상</span>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>

								</c:when>

								<c:otherwise>
									<tr>
										<td colspan="7">조회된 BOM 원자재 구성 정보가 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>

				</div>

				<div class="detail_help_text">
					필요수량은 작업지시수량 × BOM 기준소요량으로 계산됩니다.
				</div>

			</div>


			<%-- =====================================================
			     자동 생성된 원자재 투입 이력
			     ===================================================== --%>
			<div class="detail_card">

				<div class="detail_card_title">원자재 투입 이력</div>

				<div class="workorder_sub_table_wrap">

					<table class="workorder_sub_table">
						<thead>
							<tr>
								<th>순번</th>
								<th>입출고유형</th>
								<th>원자재 LOT</th>
								<th>자재코드</th>
								<th>자재명</th>
								<th>투입수량</th>
								<th>투입일</th>
								<th>담당자</th>
								<th>상태</th>
							</tr>
						</thead>

						<tbody>
							<c:choose>
								<c:when test="${not empty materialInoutList}">

									<c:forEach var="inout" items="${materialInoutList}" varStatus="status">
										<tr>
											<td>${status.count}</td>

											<td>${inout.inoutType}</td>

											<td title="${inout.materialLot}">
												${inout.materialLot}
											</td>

											<td title="${inout.materialItemCode}">
												${inout.materialItemCode}
											</td>

											<td class="coTextLeft" title="${inout.materialItemName}">
												${inout.materialItemName}
											</td>

											<td>
												<fmt:formatNumber value="${inout.inoutQty}" pattern="#,##0.####" />
												${inout.materialItemUnit}
											</td>

											<td>${inout.inoutDate}</td>

											<td>
												<c:choose>
													<c:when test="${not empty inout.ename}">
														${inout.ename}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</td>

											<td>
												<c:choose>
													<c:when test="${inout.inoutStatus eq '완료'}">
														<span class="detail_status_badge detail_status_pass">완료</span>
													</c:when>
													<c:otherwise>
														<span class="detail_status_badge">
															${inout.inoutStatus}
														</span>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>

								</c:when>

								<c:otherwise>
									<tr>
										<td colspan="9">조회된 원자재 투입 이력이 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>

				</div>

				<div class="detail_help_text">
					작업지시 등록 시 BOM 기준으로 MATERIAL_INOUT에 MO-PROD 이력이 자동 생성됩니다.
				</div>

			</div>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 작업지시 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* 작업지시 상세 전용: 3쌍(th+td) 테이블 폭 넘침 방지 */
.workorder_detail_table {
	width: 100%;
	table-layout: fixed;
}

.workorder_detail_table th {
	width: 9%;
	white-space: nowrap;
}

.workorder_detail_table td {
	width: 24.3%;
	min-width: 0;
	vertical-align: middle;
	word-break: break-all;
}

.workorder_detail_table .detail_input,
.workorder_detail_table .detail_select,
.workorder_detail_table input,
.workorder_detail_table select {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.workorder_detail_table .detail_help_text {
	margin-top: 6px;
	white-space: normal;
	word-break: keep-all;
	line-height: 1.4;
}

/* BOM/자재투입 표 */
.workorder_sub_table_wrap {
	width: 100%;
	overflow-x: auto;
}

.workorder_sub_table {
	width: 100%;
	min-width: 900px;
	border-collapse: collapse;
	table-layout: fixed;
}

.workorder_sub_table th,
.workorder_sub_table td {
	padding: 10px 8px;
	border-bottom: 1px solid #e5e8eb;
	text-align: center;
	font-size: 14px;
	vertical-align: middle;
	word-break: keep-all;
}

.workorder_sub_table th {
	background: #f7f9fb;
	font-weight: 700;
	color: #333;
}

.workorder_sub_table td {
	color: #333;
}

.workorder_sub_table .coTextLeft {
	text-align: left;
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
	}


	/*
	 * 작업지시 수정 검증
	 */
	function validateWorkOrderUpdateForm() {

		var lineId = document.getElementById("lineId").value;
		var empId = document.getElementById("empId").value;
		var orderQty = document.getElementById("orderQty").value;

		if (lineId === "") {
			alert("생산라인을 선택해주세요.");
			document.getElementById("lineId").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("empId").focus();
			return false;
		}

		if (orderQty === "" || Number(orderQty) <= 0) {
			alert("지시수량은 1 이상 입력해주세요.");
			document.getElementById("orderQty").focus();
			return false;
		}

		if (!confirm("작업지시 정보를 수정하시겠습니까?\n기존 원자재 투입 이력은 자동 재계산되지 않습니다.")) {
			return false;
		}

		return true;
	}


	<c:if test="${mode eq 'edit'}">
		changeEditMode(true);
	</c:if>
</script>