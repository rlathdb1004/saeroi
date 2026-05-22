<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">공정진행 상세</h2>

			<div class="detail_path">
				생산관리 &gt; 공정진행 현황 &gt; 공정진행 상세
			</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${mode ne 'edit'}">
				<button type="button"
					class="detail_btn_green"
					onclick="location.href='${pageContext.request.contextPath}/production/processprogress/detail?orderId=${progress.orderId}&mode=edit'">

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
					onclick="location.href='${pageContext.request.contextPath}/production/processprogress/detail?orderId=${progress.orderId}'">

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
				onclick="location.href='${pageContext.request.contextPath}/production/processprogress'">

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
		action="${pageContext.request.contextPath}/production/processprogress/update"
		onsubmit="return checkProcessProgressUpdate();">

		<input type="hidden"
			name="orderId"
			value="${progress.orderId}">

		<input type="hidden"
			name="prodId"
			value="${progress.prodId}">

		<div class="detail_card">

			<div class="detail_card_title">LOT 추적 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>작업지시번호</th>
						<td>${progress.docNo}</td>

						<th>LOT번호</th>
						<td>${progress.productLot}</td>

						<th>진행상태</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<select name="prodStatus"
										id="updateProdStatus"
										class="search-select"
										required>

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
								</c:when>

								<c:otherwise>
									<c:choose>
										<c:when test="${progress.progressStatus eq '완료'}">
											<span class="detail_status_badge detail_status_pass">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:when test="${progress.progressStatus eq '진행중'}">
											<span class="detail_status_badge detail_status_conditional">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:otherwise>
											<span class="detail_status_badge detail_status_fail">
												${progress.progressStatus}
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

			<div class="detail_card_title">공정진행 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>품목코드</th>
						<td>${progress.itemCode}</td>

						<th>품목구분</th>
						<td>
							<c:choose>
								<c:when test="${progress.itemType eq 'FG'}">완제품</c:when>
								<c:when test="${progress.itemType eq 'RM'}">원자재</c:when>
								<c:when test="${progress.itemType eq 'SM'}">부자재</c:when>
								<c:otherwise>${progress.itemType}</c:otherwise>
							</c:choose>
						</td>

						<th>라인</th>
						<td>${progress.lineName}</td>
					</tr>

					<tr>
						<th>품목명</th>
						<td colspan="3">${progress.itemName}</td>

						<th>작업지시일</th>
						<td>${progress.orderDate}</td>
					</tr>

					<tr>
						<th>단위</th>
						<td>${progress.itemUnit}</td>

						<th>지시수량</th>
						<td>${progress.orderQty}</td>

						<th>진행률</th>
						<td>${progress.progressRate}%</td>
					</tr>

					<tr>
						<th>누적 생산수량</th>
						<td>${progress.totalProdQty}</td>

						<th>누적 불량수량</th>
						<td>${progress.totalLossQty}</td>

						<th>양품수량</th>
						<td>${progress.totalProdQty - progress.totalLossQty}</td>
					</tr>

					<tr>
						<th>최근 생산수량</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number"
										name="prodQty"
										id="updateProdQty"
										class="search-input"
										min="1"
										value="${progress.prodQty}"
										required>
								</c:when>

								<c:otherwise>
									${progress.prodQty}
								</c:otherwise>
							</c:choose>
						</td>

						<th>최근 불량수량</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number"
										name="lossQty"
										id="updateLossQty"
										class="search-input"
										min="0"
										value="${progress.lossQty}">
								</c:when>

								<c:otherwise>
									${progress.lossQty}
								</c:otherwise>
							</c:choose>
						</td>

						<th>잔여수량</th>
						<td>${progress.orderQty - progress.totalProdQty}</td>
					</tr>

					<tr>
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
												<c:if test="${progress.empId eq emp.empId}">selected</c:if>>
												${emp.ename} / ${emp.dept}
											</option>

										</c:forEach>

									</select>
								</c:when>

								<c:otherwise>
									${progress.ename}
									<c:if test="${not empty progress.dept}">
										/ ${progress.dept}
									</c:if>
								</c:otherwise>
							</c:choose>
						</td>

						<th>비고</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<textarea name="remark"
										class="detail_textarea"
										placeholder="공정진행 관련 메모를 입력하세요.">${progress.remark}</textarea>
								</c:when>

								<c:otherwise>
									<c:choose>
										<c:when test="${empty progress.remark}">
											-
										</c:when>

										<c:otherwise>
											${progress.remark}
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</td>

						<th></th>
						<td></td>
					</tr>
				</tbody>

			</table>

		</div>

	</form>

</div>


<script>
	// 공정진행 수정 방어코딩이다.
	function checkProcessProgressUpdate() {

		var prodId =
			document.querySelector("input[name='prodId']").value;

		var prodQty =
			document.getElementById("updateProdQty");

		var lossQty =
			document.getElementById("updateLossQty");

		var prodStatus =
			document.getElementById("updateProdStatus");

		var empId =
			document.getElementById("updateEmpId");

		if (prodId == "") {
			alert("수정할 생산실적이 없습니다. 먼저 공정진행 등록을 진행해주세요.");
			return false;
		}

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

			alert("진행상태를 선택해주세요.");
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