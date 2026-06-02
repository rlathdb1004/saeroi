<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<c:set var="isAdmin"
	value="${
		sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'
        }" />
<style>
.coTable {
	table-layout: auto;
}
.coTable th:first-child, .coTable td:first-child {
	width: 90px;
	min-width: 90px;
	max-width: 90px;
}

@media screen and (max-width: 768px) {

	.coTable {
		table-layout: fixed;		
	}
	
	.coTable th:last-child,
	.coTable td:last-child {
		width: 72px;
		min-width: 72px;
		max-width: 72px;
		padding: 0 4px;
	}
	
	.coTable th:first-child,
	.coTable td:first-child {
		width: 72px;
		min-width: 72px;
		max-width: 72px;
	}	
	.coTable th,
	.coTable td {
		padding: 0 6px;		
	}	
	.coDetailBtn {
		min-width: auto;
		font-size: 12px;
	}
}
</style>

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/equipment/equipment">

		<div class="search-box">
			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label> <select name="searchType"
						class="search-select">

						<option value="all">전체</option>

						<option value="equip_code"
							<c:if test="${searchType eq 'equip_code'}">selected</c:if>>
							설비코드</option>
						<option value="equip_name"
							<c:if test="${searchType eq 'equip_name'}">selected</c:if>>
							설비명</option>
						<option value="equip_status"
							<c:if test="${searchType eq 'equip_status'}">selected
									</c:if>>
							설비 상태</option>
						<option value="equip_loc"
							<c:if test="${searchType eq 'equip_loc'}">selected</c:if>>
							설비 위치</option>
						<option value="client_name"
							<c:if test="${searchType eq 'client_name'}">selected</c:if>>
							제조사</option>

					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="keyword" class="search-input" placeholder="검색키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn 	search-btn-main">

						<svg viewBox="0 0 24 24" fill="none">
									<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor"
								stroke-width="2">
									</circle>

									<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round">
									</path>
								</svg>

						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/equipment/equipment'">

						<svg viewBox="0 0 24 24" fill="none">
									<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>

									<path d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round">
									</path>
								</svg>

						초기화
					</button>

				</div>

			</div>
		</div>

	</form>

	<form method="post" id="deleteForm"
		action="${pageContext.request.contextPath}/equipment/delete">

		<div class="coTableTop">

			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

		</div>

		<div class="coTableWrap">

			<table class="coTable">
				<thead>
					<tr>
						<th class="mobile_show">설비 상태</th>
						<th class="mobile_show">설비 코드</th>
						<th class="mobile_show">설비명</th>
						<th class="mobile_hidden">설치 위치</th>
						<th class="mobile_hidden">제조사</th>
						<th class="mobile_show">비고</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="eqp" items="${list}">

						<tr>
							<td class="mobile_show"><c:choose>
									<c:when test="${eqp.equip_status == '가동'}">
										<span class="coStatus coStatusUse">가동</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusStop">
											${eqp.equip_status} </span>
									</c:otherwise>
								</c:choose></td>
							<td class="mobile_show">${eqp.equip_code}</td>
							<td class="mobile_show">${eqp.equip_name}</td>

							<td class="mobile_hidden">${eqp.equip_loc}</td>
							<td class="mobile_hidden">${eqp.client_name}</td>
							<td class="mobile_show">${eqp.remark}</td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/equipment/equipment/detail?equip_id=${eqp.equip_id}'">
									보기</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</form>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>