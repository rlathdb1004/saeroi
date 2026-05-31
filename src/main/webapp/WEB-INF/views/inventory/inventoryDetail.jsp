<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- =========================================================
	상세페이지 공통 CSS
	공통 파일은 건드리지 않고 기존 detail.css 그대로 사용
========================================================= --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>

			<h2 class="detail_title">
				재고 상세
			</h2>

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
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}'">

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

			</c:if>

			<button type="button"
				class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">

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

	<c:choose>

		<c:when test="${mode eq 'edit'}">

			<form id="updateForm"
				method="post"
				action="${pageContext.request.contextPath}/inventory/stockList/update">

				<input type="hidden"
					name="inventoryId"
					value="${inventory.inventoryId}">

				<div class="detail_card">

					<div class="detail_card_title">
						기본 정보
					</div>

					<table class="detail_info_table">

						<tbody>

							<%-- =====================================================
								INVENTORY 테이블 기본 컬럼
								INVENTORY_ID / ITEM_ID까지 상세에 표시한다.
							===================================================== --%>
							<tr>

								<th>재고번호</th>
								<td>${inventory.inventoryId}</td>

								<th>품목ID</th>
								<td>${inventory.itemId}</td>

								<th>품목코드</th>
								<td>${inventory.itemCode}</td>

							</tr>

							<tr>

								<th>품목명</th>
								<td>${inventory.itemName}</td>

								<th>품목유형</th>
								<td>

									<c:choose>
										<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
										<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
										<%-- SM은 우리 프로젝트 기준으로 완제품으로 표시 --%>
										<c:when test="${inventory.itemType eq 'SM'}">완제품</c:when>
										<c:otherwise>${inventory.itemType}</c:otherwise>
									</c:choose>

								</td>

								<th>재고단위</th>
								<td>${inventory.itemUnit}</td>

							</tr>

							<tr>

								<th>현재재고/단위</th>
								<td>

									<input type="number"
										name="inventoryStock"
										class="search-input"
										value="${inventory.inventoryStock}">

									${inventory.itemUnit}

								</td>

								<th>창고위치</th>
								<td>

									<input type="text"
										name="stockLocation"
										class="search-input"
										value="${inventory.stockLocation}">

								</td>

								<th>생성일</th>
								<td>${inventory.createdDate}</td>

							</tr>

							<tr>

								<th>수정일</th>
								<td>${inventory.updatedDate}</td>

								<th>비고</th>
								<td colspan="3">

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

				<div class="detail_card_title">
					기본 정보
				</div>

				<table class="detail_info_table">

					<tbody>

						<%-- =====================================================
							INVENTORY 테이블에 있는 컬럼을 상세페이지에 모두 표시한다.
							품목코드 / 품목명 / 품목유형 / 단위는 ITEM JOIN 표시용이다.
						===================================================== --%>
						<tr>

							<th>재고번호</th>
							<td>${inventory.inventoryId}</td>

							<th>품목ID</th>
							<td>${inventory.itemId}</td>

							<th>품목코드</th>
							<td>${inventory.itemCode}</td>

						</tr>

						<tr>

							<th>품목명</th>
							<td>${inventory.itemName}</td>

							<th>품목유형</th>
							<td>

								<c:choose>
									<c:when test="${inventory.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inventory.itemType eq 'RM'}">원자재</c:when>
									<%-- SM은 우리 프로젝트 기준으로 완제품으로 표시 --%>
										<c:when test="${inventory.itemType eq 'SM'}">완제품</c:when>
									<c:otherwise>${inventory.itemType}</c:otherwise>
								</c:choose>

							</td>

							<th>단위</th>
							<td>${inventory.itemUnit}</td>

						</tr>

						<tr>

							<th>현재재고/단위</th>
							<td><fmt:formatNumber value="${inventory.inventoryStock}" pattern="#,###" /> ${inventory.itemUnit}</td>

							<th>창고위치</th>
							<td>${inventory.stockLocation}</td>

							<th>생성일</th>
							<td>${inventory.createdDate}</td>

						</tr>

						<tr>

							<th>수정일</th>
							<td>${inventory.updatedDate}</td>

							<th>비고</th>
							<td colspan="3">${inventory.remark}</td>

						</tr>

					</tbody>

				</table>

			</div>

		</c:otherwise>

	</c:choose>


	<%-- =========================================================
		재고 입출고 내역서
		재고번호를 따라갔을 때 해당 품목의 입고 / 사용 / 출고 이력을 리스트로 확인한다.
		목록 테이블에는 추가하지 않고 상세페이지 하단에서만 보여준다.
	========================================================= --%>
	<div class="detail_card">

		<div class="detail_card_title">
			재고 입출고 내역서
		</div>

		<table class="detail_info_table">

			<thead>

				<tr>
					<th>구분</th>
					<th>입출고번호</th>
					<th>입출고일자</th>
					<th>LOT번호</th>
					<th>수량/단위</th>
					<th>상태</th>
					<th>비고</th>
					<th>등록일</th>
				</tr>

			</thead>

			<tbody>

				<c:choose>

					<c:when test="${empty inoutHistory}">

						<tr>
							<td colspan="8">
								입출고 내역이 없습니다.
							</td>
						</tr>

					</c:when>

					<c:otherwise>

						<c:forEach var="history" items="${inoutHistory}">

							<tr>
								<td>
									<c:choose>
										<c:when test="${history.inoutType eq 'MI'}">입고</c:when>
										<c:when test="${history.inoutType eq 'MO-PROD'}">사용/출고</c:when>
										<c:otherwise>${history.inoutType}</c:otherwise>
									</c:choose>
								</td>
								<td>${history.docNo}</td>
								<td>${history.inoutDate}</td>
								<td>${history.materialLot}</td>
								<td><fmt:formatNumber value="${history.inoutQty}" pattern="#,###" /> ${history.itemUnit}</td>
								<td>${history.status}</td>
								<td>${history.historyRemark}</td>
								<td>${history.historyCreatedDate}</td>
							</tr>

						</c:forEach>

					</c:otherwise>

				</c:choose>

			</tbody>

		</table>

	</div>

</div>
