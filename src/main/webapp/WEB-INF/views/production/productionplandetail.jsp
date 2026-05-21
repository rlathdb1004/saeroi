<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">생산계획 상세</h2>

			<div class="detail_path">생산관리 &gt; 생산계획 관리 &gt; 생산계획 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${mode ne 'edit'}">
				<button type="button" class="detail_btn_green"
					onclick="location.href='${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${production.prodPlanId}&mode=edit'">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
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

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="updateForm">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
				<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
				<path d="M17 21v-8H7v8"></path>
				<path d="M7 3v5h8"></path>
			</svg>

					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="location.href='${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${production.prodPlanId}'">

					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
				<path d="M18 6L6 18"></path>
				<path d="M6 6l12 12"></path>
			</svg>

					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/production/productionplan'">

				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
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

	<form id="updateForm" method="post"
		action="${pageContext.request.contextPath}/production/productionplan/update">

		<%-- 수정 시 어떤 생산계획인지 구분하기 위한 값이다. 화면에는 보여주지 않는다. --%>
		<input type="hidden" name="prodPlanId"
			value="${production.prodPlanId}">

		<div class="detail_card">

			<div class="detail_card_title">기본 정보</div>

			<table class="detail_info_table">

				<tbody>
					<tr>
						<th>생산계획번호</th>
						<td>${production.docNo}</td>

						<th>품목코드</th>
						<td>${production.itemCode}</td>

						<th>품목명</th>
						<td>${production.itemName}</td>
					</tr>

					<tr>
						<th>품목구분</th>
						<td><c:choose>
								<c:when test="${production.itemType eq 'FG'}">완제품</c:when>
								<c:when test="${production.itemType eq 'RM'}">원자재</c:when>
								<c:when test="${production.itemType eq 'SM'}">부자재</c:when>
								<c:otherwise>${production.itemType}</c:otherwise>
							</c:choose></td>

						<th>계획수량</th>
						<td><c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number" name="prodPlanQty" class="search-input"
										min="0" value="${production.prodPlanQty}">
								</c:when>

								<c:otherwise>
									${production.prodPlanQty}
								</c:otherwise>
							</c:choose></td>

						<th>단위</th>
						<td>${production.itemUnit}</td>
					</tr>

					<tr>
						<th>계획일자</th>
						<td><c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="date" name="prodPlanDate" class="search-input"
										value="${production.prodPlanDate}">
								</c:when>

								<c:otherwise>
									${production.prodPlanDate}
								</c:otherwise>
							</c:choose></td>

						<th>납기일</th>
						<td><c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="date" name="dueDate" class="search-input"
										value="${production.dueDate}">
								</c:when>

								<c:otherwise>
									${production.dueDate}
								</c:otherwise>
							</c:choose></td>

						<th>생성일</th>
						<td>${production.createdDate}</td>
					</tr>

					<tr>
						<th>수정일</th>
						<td>${production.updatedDate}</td>

						<th>비고</th>
						<td colspan="3"><c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="text" name="remark" class="search-input"
										value="${production.remark}">
								</c:when>

								<c:otherwise>
									${production.remark}
								</c:otherwise>
							</c:choose></td>
					</tr>
				</tbody>

			</table>

		</div>

	</form>

</div>