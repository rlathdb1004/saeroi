<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/production/productionplan">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label>

					<input type="date"
						name="startDate"
						class="search-date"
						value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label>

					<input type="date"
						name="endDate"
						class="search-date"
						value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="itemType"
						class="search-select">

						<option value="">전체</option>

						<c:forEach var="type"
							items="${itemTypeList}">

							<option value="${type}"
								<c:if test="${itemType eq type}">selected</c:if>>
								${type}
							</option>

						</c:forEach>

					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="생산계획번호 / 품목명 검색"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit"
						class="search-btn search-btn-main">
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/production/productionplan'">
						초기화
					</button>

				</div>

			</div>

		</div>

	</form>


	<div class="coTableTop">

		<p class="coTotalCount">
			총 ${pageInfo.totalCount}건
		</p>

	</div>


	<div class="coTableWrap">

		<table class="coTable">

			<thead>
				<tr>
					<th class="mobile_show">
						<label id="checkAllLabel">선택</label>

						<input type="checkbox"
							id="checkAll"
							style="display:none;">
					</th>

					<th class="mobile_hidden">생산계획번호</th>
					<th class="mobile_show">품목명</th>
					<th class="mobile_show">계획수량</th>
					<th class="mobile_hidden">단위</th>
					<th class="mobile_show">계획일자</th>
					<th class="mobile_hidden">납기일</th>
					<th class="mobile_show">상세</th>
				</tr>
			</thead>

			<tbody>

				<c:forEach var="production"
					items="${list}">

					<tr>
						<td class="mobile_show">
							<input type="checkbox"
								name="prodPlanIds"
								value="${production.prodPlanId}">
						</td>

						<td class="mobile_hidden"
							title="${production.docNo}">
							${production.docNo}
						</td>

						<td class="mobile_show"
							title="${production.itemName}">
							${production.itemName}
						</td>

						<td class="mobile_show">
							${production.prodPlanQty}
						</td>

						<td class="mobile_hidden">
							${production.itemUnit}
						</td>

						<td class="mobile_show">
							${production.prodPlanDate}
						</td>

						<td class="mobile_hidden">
							${production.dueDate}
						</td>

						<td class="mobile_show">
							<button type="button"
								class="coDetailBtn"
								onclick="location.href='${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${production.prodPlanId}'">
								보기
							</button>
						</td>
					</tr>

				</c:forEach>

				<c:if test="${empty list}">
					<tr>
						<td colspan="8">
							조회된 생산계획이 없습니다.
						</td>
					</tr>
				</c:if>

			</tbody>

		</table>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>