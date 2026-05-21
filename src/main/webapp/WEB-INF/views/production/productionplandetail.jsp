<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">생산계획 상세</h2>

			<div class="detail_path">
				생산관리 &gt; 생산계획 관리 &gt; 생산계획 상세
			</div>
		</div>

		<div class="detail_btn_area">

			<%-- 상세 보기 상태에서는 수정 버튼을 보여준다. --%>
			<c:if test="${mode ne 'edit'}">
				<button type="button"
					class="detail_btn_green"
					onclick="location.href='${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${production.prodPlanId}&mode=edit'">
					수정
				</button>
			</c:if>

			<%-- 수정 상태에서는 저장 버튼을 보여준다. --%>
			<c:if test="${mode eq 'edit'}">
				<button type="submit"
					class="detail_btn_green"
					form="updateForm">
					저장
				</button>

				<button type="button"
					class="detail_btn_line"
					onclick="location.href='${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${production.prodPlanId}'">
					취소
				</button>
			</c:if>

			<%-- 목록 페이지로 이동한다. --%>
			<button type="button"
				class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/production/productionplan'">
				목록
			</button>

		</div>
	</div>

	<form id="updateForm"
		method="post"
		action="${pageContext.request.contextPath}/production/productionplan/update">

		<%-- 수정 시 어떤 생산계획인지 구분하기 위한 값이다. 화면에는 보여주지 않는다. --%>
		<input type="hidden"
			name="prodPlanId"
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
						<td>
							<c:choose>
								<c:when test="${production.itemType eq 'FG'}">완제품</c:when>
								<c:when test="${production.itemType eq 'RM'}">원자재</c:when>
								<c:when test="${production.itemType eq 'SM'}">부자재</c:when>
								<c:otherwise>${production.itemType}</c:otherwise>
							</c:choose>
						</td>

						<th>계획수량</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="number"
										name="prodPlanQty"
										class="search-input"
										min="0"
										value="${production.prodPlanQty}">
								</c:when>

								<c:otherwise>
									${production.prodPlanQty}
								</c:otherwise>
							</c:choose>
						</td>

						<th>단위</th>
						<td>${production.itemUnit}</td>
					</tr>

					<tr>
						<th>계획일자</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="date"
										name="prodPlanDate"
										class="search-input"
										value="${production.prodPlanDate}">
								</c:when>

								<c:otherwise>
									${production.prodPlanDate}
								</c:otherwise>
							</c:choose>
						</td>

						<th>납기일</th>
						<td>
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="date"
										name="dueDate"
										class="search-input"
										value="${production.dueDate}">
								</c:when>

								<c:otherwise>
									${production.dueDate}
								</c:otherwise>
							</c:choose>
						</td>

						<th>생성일</th>
						<td>${production.createdDate}</td>
					</tr>

					<tr>
						<th>수정일</th>
						<td>${production.updatedDate}</td>

						<th>비고</th>
						<td colspan="3">
							<c:choose>
								<c:when test="${mode eq 'edit'}">
									<input type="text"
										name="remark"
										class="search-input"
										value="${production.remark}">
								</c:when>

								<c:otherwise>
									${production.remark}
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>

			</table>

		</div>

	</form>

</div>