<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">재고 상세</h2>

			<div class="detail_path">
				자재/재고관리 &gt; 재고조회 관리 &gt; 재고 상세
			</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<c:if test="${mode ne 'edit'}">
					<button type="button"
						class="detail_btn_green"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}&mode=edit'">

						<svg width="16" height="16" viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">
							<path d="M12 20h9"></path>
							<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
						</svg>

						수정
					</button>
				</c:if>

				<c:if test="${mode eq 'edit'}">

					<%-- 팀장님이 준 저장 버튼 --%>
					<button type="submit"
						id="saveBtn"
						class="detail_btn_green"
						form="updateForm">

						<svg width="16" height="16" viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">
							<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
							<path d="M17 21v-8H7v8"></path>
							<path d="M7 3v5h8"></path>
						</svg>

						저장
					</button>

					<%-- 팀장님이 준 취소 버튼 --%>
					<button type="button"
						id="cancelBtn"
						class="detail_btn_line"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}'">

						<svg width="16" height="16" viewBox="0 0 24 24"
							fill="none" stroke="currentColor" stroke-width="2"
							stroke-linecap="round" stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">
							<path d="M18 6L6 18"></path>
							<path d="M6 6l12 12"></path>
						</svg>

						취소
					</button>

				</c:if>

			</c:if>

			<button type="button"
				class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/inventory/inventoryStatus'">

				<svg width="16" height="16" viewBox="0 0 24 24"
					fill="none" stroke="currentColor" stroke-width="2"
					stroke-linecap="round" stroke-linejoin="round"
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

	<c:choose>

		<c:when test="${mode eq 'edit'}">

			<form id="updateForm"
				method="post"
				action="${pageContext.request.contextPath}/inventory/stockList/update">

				<input type="hidden"
					name="inventoryId"
					value="${inventory.inventoryId}">

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
								<th>재고번호</th>
								<td>${inventory.inventoryId}</td>

								<th>품목코드</th>
								<td>${inventory.itemCode}</td>

								<th>품목명</th>
								<td>${inventory.itemName}</td>
							</tr>

							<tr>
								<th>품목유형</th>
								<td>
									<c:choose>
										<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
										<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
										<c:when test="${inventory.itemType eq 'SM'}">부자재</c:when>
										<c:otherwise>${inventory.itemType}</c:otherwise>
									</c:choose>
								</td>

								<th>현재재고</th>
								<td>
									<input type="number"
										name="inventoryStock"
										class="search-input"
										value="${inventory.inventoryStock}">
								</td>

								<th>단위</th>
								<td>${inventory.itemUnit}</td>
							</tr>

							<tr>
								<th>창고위치</th>
								<td>
									<input type="text"
										name="stockLocation"
										class="search-input"
										value="${inventory.stockLocation}">
								</td>

								<th>생성일</th>
								<td>${inventory.createdDate}</td>

								<th>수정일</th>
								<td>${inventory.updatedDate}</td>
							</tr>

							<tr>
								<th>비고</th>
								<td colspan="5">
									<input type="text"
										name="remark"
										class="search-input"
										value="${inventory.remark}">
								</td>
							</tr>
						</tbody>
					</table>
				</div>

			</form>

		</c:when>

		<c:otherwise>

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
							<th>재고번호</th>
							<td>${inventory.inventoryId}</td>

							<th>품목코드</th>
							<td>${inventory.itemCode}</td>

							<th>품목명</th>
							<td>${inventory.itemName}</td>
						</tr>

						<tr>
							<th>품목유형</th>
							<td>
								<c:choose>
									<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
									<c:when test="${inventory.itemType eq 'SM'}">부자재</c:when>
									<c:otherwise>${inventory.itemType}</c:otherwise>
								</c:choose>
							</td>

							<th>현재재고</th>
							<td>${inventory.inventoryStock}</td>

							<th>단위</th>
							<td>${inventory.itemUnit}</td>
						</tr>

						<tr>
							<th>창고위치</th>
							<td>${inventory.stockLocation}</td>

							<th>생성일</th>
							<td>${inventory.createdDate}</td>

							<th>수정일</th>
							<td>${inventory.updatedDate}</td>
						</tr>

						<tr>
							<th>비고</th>
							<td colspan="5">${inventory.remark}</td>
						</tr>
					</tbody>
				</table>
			</div>

		</c:otherwise>

	</c:choose>

</div>