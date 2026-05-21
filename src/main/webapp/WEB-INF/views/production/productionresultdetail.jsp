<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">생산실적 상세</h2>

			<div class="detail_path">
				생산관리 &gt; 생산실적 등록 &gt; 생산실적 상세
			</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${mode ne 'edit'}">
				<button type="button"
					class="detail_btn_green"
					onclick="location.href='${pageContext.request.contextPath}/production/productionresult/detail?prodId=${result.prodId}&mode=edit'">

					<svg width="16"
						height="16"
						viewBox="0 0 24 24"
						fill="none"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>

					수정
				</button>
			</c:if>

			<c:if test="${mode eq 'edit'}">

				<button type="submit"
					class="detail_btn_green"
					form="updateForm">

					<svg width="16"
						height="16"
						viewBox="0 0 24 24"
						fill="none"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>

					저장
				</button>

				<button type="button"
					class="detail_btn_line"
					onclick="location.href='${pageContext.request.contextPath}/production/productionresult/detail?prodId=${result.prodId}'">

					<svg width="16"
						height="16"
						viewBox="0 0 24 24"
						fill="none"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>

					취소
				</button>

			</c:if>

			<button type="button"
				class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/production/productionresult'">

				<svg width="16"
					height="16"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;"
					aria-hidden="true">
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


	<form id="updateForm"
		method="post"
		action="${pageContext.request.contextPath}/production/productionresult/update"
		onsubmit="return checkProductionResultUpdate();">

		<input type="hidden"
			name="prodId"
			value="${result.prodId}">

		<div class="detail_card">

			<div class="detail_card_title">LOT 추적 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>실적번호</th>
						<td>${result.docNo}</td>

						<th>작업지시번호</th>
						<td>${result.workOrderDocNo}</td>

						<th>LOT번호</th>
						<td>${result.productLot}</td>
					</tr>

					<tr>
						<th>생산계획번호</th>
						<td>${result.prodPlanDocNo}</td>

						<th>생산상태</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<select name="prodStatus"
										id="updateProdStatus"
										class="search-select"
										required>

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
								</c:when>

								<c:otherwise>
									<c:choose>
										<c:when test="${result.prodStatus eq '완료'}">
											<span class="detail_status_badge detail_status_pass">
												${result.prodStatus}
											</span>
										</c:when>

										<c:when test="${result.prodStatus eq '진행중'}">
											<span class="detail_status_badge detail_status_conditional">
												${result.prodStatus}
											</span>
										</c:when>

										<c:otherwise>
											<span class="detail_status_badge detail_status_fail">
												${result.prodStatus}
											</span>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>

			</table>

		</div>


		<div class="detail_card">

			<div class="detail_card_title">생산실적 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>품목코드</th>
						<td>${result.itemCode}</td>

						<th>품목명</th>
						<td>${result.itemName}</td>

						<th>품목구분</th>
						<td>
							<c:choose>
								<c:when test="${result.itemType eq 'FG'}">완제품</c:when>
								<c:when test="${result.itemType eq 'RM'}">원자재</c:when>
								<c:when test="${result.itemType eq 'SM'}">부자재</c:when>
								<c:otherwise>${result.itemType}</c:otherwise>
							</c:choose>
						</td>
					</tr>

					<tr>
						<th>지시수량</th>
						<td>${result.orderQty}</td>

						<th>생산수량</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number"
										name="prodQty"
										id="updateProdQty"
										class="search-input"
										min="1"
										value="${result.prodQty}"
										required>
								</c:when>

								<c:otherwise>
									${result.prodQty}
								</c:otherwise>
							</c:choose>
						</td>

						<th>단위</th>
						<td>${result.itemUnit}</td>
					</tr>

					<tr>
						<th>불량수량</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number"
										name="lossQty"
										id="updateLossQty"
										class="search-input"
										min="0"
										value="${result.lossQty}">
								</c:when>

								<c:otherwise>
									${result.lossQty}
								</c:otherwise>
							</c:choose>
						</td>

						<th>양품수량</th>
						<td>
							${result.prodQty - result.lossQty}
						</td>

						<th>생산일자</th>
						<td>${result.prodDate}</td>
					</tr>

					<tr>
						<th>작업지시일</th>
						<td>${result.orderDate}</td>

						<th>담당자</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<select name="empId"
										id="updateEmpId"
										class="search-select"
										required>

										<option value="">선택</option>

										<c:forEach var="emp"
											items="${empList}">

											<option value="${emp.empId}"
												<c:if test="${result.empId eq emp.empId}">selected</c:if>>
												${emp.ename} / ${emp.dept}
											</option>

										</c:forEach>

									</select>
								</c:when>

								<c:otherwise>
									${result.ename}
									<c:if test="${not empty result.dept}">
										/ ${result.dept}
									</c:if>
								</c:otherwise>
							</c:choose>
						</td>

						<th>생성일</th>
						<td>${result.createdDate}</td>
					</tr>

					<tr>
						<th>수정일</th>
						<td>${result.updatedDate}</td>

						<th>비고</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<textarea name="remark"
										class="detail_textarea"
										placeholder="생산실적 관련 메모를 입력하세요.">${result.remark}</textarea>
								</c:when>

								<c:otherwise>
									<c:choose>
										<c:when test="${empty result.remark}">
											-
										</c:when>

										<c:otherwise>
											${result.remark}
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>

			</table>

		</div>

	</form>

</div>


<script>
	// 생산실적 수정 방어코딩이다.
	function checkProductionResultUpdate() {

		var prodQty =
			document.getElementById("updateProdQty");

		var lossQty =
			document.getElementById("updateLossQty");

		var prodStatus =
			document.getElementById("updateProdStatus");

		var empId =
			document.getElementById("updateEmpId");

		if (prodQty != null &&
				(prodQty.value == "" || Number(prodQty.value) <= 0)) {

			alert("생산수량은 1 이상 입력해주세요.");
			return false;
		}

		if (lossQty != null &&
				lossQty.value != "" &&
				Number(lossQty.value) < 0) {

			alert("불량수량은 0 이상 입력해주세요.");
			return false;
		}

		if (prodStatus != null &&
				prodStatus.value == "") {

			alert("생산상태를 선택해주세요.");
			return false;
		}

		if (empId != null &&
				empId.value == "") {

			alert("담당자를 선택해주세요.");
			return false;
		}

		return true;
	}
</script>