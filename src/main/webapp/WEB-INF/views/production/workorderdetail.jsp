<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">작업지시 상세</h2>

			<div class="detail_path">
				생산관리 &gt; 작업지시 관리 &gt; 작업지시 상세
			</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${mode ne 'edit'}">
				<button type="button"
					class="detail_btn_green"
					onclick="location.href='${pageContext.request.contextPath}/production/workorder/detail?orderId=${workOrder.orderId}&mode=edit'">

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
					id="saveBtn"
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
					id="cancelBtn"
					class="detail_btn_line"
					onclick="location.href='${pageContext.request.contextPath}/production/workorder/detail?orderId=${workOrder.orderId}'">

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
				onclick="location.href='${pageContext.request.contextPath}/production/workorder'">

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
		action="${pageContext.request.contextPath}/production/workorder/update">

		<input type="hidden"
			name="orderId"
			value="${workOrder.orderId}">

		<div class="detail_card">

			<div class="detail_card_title">LOT 추적 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>작업지시번호</th>
						<td>${workOrder.docNo}</td>

						<th>LOT번호</th>
						<td>${workOrder.productLot}</td>

						<th>작업상태</th>
						<td>
							<c:choose>
								<c:when test="${workOrder.prodStatus eq '완료'}">
									<span class="detail_status_badge detail_status_pass">
										${workOrder.prodStatus}
									</span>
								</c:when>

								<c:when test="${workOrder.prodStatus eq '진행중'}">
									<span class="detail_status_badge detail_status_conditional">
										${workOrder.prodStatus}
									</span>
								</c:when>

								<c:otherwise>
									<span class="detail_status_badge detail_status_fail">
										${workOrder.prodStatus}
									</span>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>

			</table>

		</div>


		<div class="detail_card">

			<div class="detail_card_title">기본 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>생산계획번호</th>
						<td>${workOrder.prodPlanDocNo}</td>

						<th>품목코드</th>
						<td>${workOrder.itemCode}</td>

						<th>품목명</th>
						<td>${workOrder.itemName}</td>
					</tr>

					<tr>
						<th>품목구분</th>
						<td>
							<c:choose>
								<c:when test="${workOrder.itemType eq 'FG'}">완제품</c:when>
								<c:when test="${workOrder.itemType eq 'RM'}">원자재</c:when>
								<c:when test="${workOrder.itemType eq 'SM'}">부자재</c:when>
								<c:otherwise>${workOrder.itemType}</c:otherwise>
							</c:choose>
						</td>

						<th>계획수량</th>
						<td>${workOrder.prodPlanQty}</td>

						<th>단위</th>
						<td>${workOrder.itemUnit}</td>
					</tr>

					<tr>
						<th>지시수량</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number"
										name="orderQty"
										class="search-input"
										min="1"
										value="${workOrder.orderQty}"
										required>
								</c:when>

								<c:otherwise>
									${workOrder.orderQty}
								</c:otherwise>
							</c:choose>
						</td>

						<th>작업지시일</th>
						<td>${workOrder.orderDate}</td>

						<th>생성일</th>
						<td>${workOrder.createdDate}</td>
					</tr>

					<tr>
						<th>라인</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<select name="lineId"
										class="search-select"
										required>

										<option value="">선택</option>

										<c:forEach var="line"
											items="${lineList}">

											<option value="${line.lineId}"
												<c:if test="${workOrder.lineId eq line.lineId}">selected</c:if>>
												${line.lineName}
											</option>

										</c:forEach>

									</select>
								</c:when>

								<c:otherwise>
									${workOrder.lineName}
								</c:otherwise>
							</c:choose>
						</td>

						<th>담당자</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<select name="empId"
										class="search-select"
										required>

										<option value="">선택</option>

										<c:forEach var="emp"
											items="${empList}">

											<option value="${emp.empId}"
												<c:if test="${workOrder.empId eq emp.empId}">selected</c:if>>
												${emp.ename} / ${emp.dept}
											</option>

										</c:forEach>

									</select>
								</c:when>

								<c:otherwise>
									${workOrder.ename}
									<c:if test="${not empty workOrder.dept}">
										/ ${workOrder.dept}
									</c:if>
								</c:otherwise>
							</c:choose>
						</td>

						<th>수정일</th>
						<td>${workOrder.updatedDate}</td>
					</tr>

					<tr>
						<th>비고</th>
						<td colspan="5">
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<textarea name="remark"
										class="detail_textarea"
										placeholder="작업지시 관련 메모를 입력하세요.">${workOrder.remark}</textarea>
								</c:when>

								<c:otherwise>
									<c:choose>
										<c:when test="${empty workOrder.remark}">
											-
										</c:when>

										<c:otherwise>
											${workOrder.remark}
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