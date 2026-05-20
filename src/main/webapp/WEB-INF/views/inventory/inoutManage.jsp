<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 관리자 / 매니저 권한 체크 --%>
<c:set var="isAdmin"
	value="${sessionScope.member.role eq 'ADMIN'
		or sessionScope.member.role eq 'MANAGER'
		or sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'
		or sessionScope.member.job eq '관리자'
		or sessionScope.loginUser.job eq '관리자'}" />

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">
			<div class="search-row">

				<div class="search-item">
					<label class="search-label">입출고구분</label>

					<select name="inoutType" class="search-select">
						<option value="">전체</option>

						<option value="MI"
							<c:if test="${inoutType eq 'MI'}">selected</c:if>>
							입고
						</option>

						<option value="MO-PROD"
							<c:if test="${inoutType eq 'MO-PROD'}">selected</c:if>>
							출고
						</option>
					</select>
				</div>

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
					<label class="search-label">검색어</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<%-- 검색 버튼 아이콘 추가 --%>
					<button type="submit"
						class="search-btn search-btn-main">

						<svg viewBox="0 0 24 24"
							fill="none"
							style="width:16px; height:16px; margin-right:4px;">

							<circle cx="10.5"
								cy="10.5"
								r="7.5"
								stroke="currentColor"
								stroke-width="2">
							</circle>

							<path d="M16 16L21 21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

						</svg>

						검색

					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">

						초기화

					</button>

				</div>

			</div>
		</div>
	</form>

	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/materialIn/delete">

		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<%-- 관리자 / 매니저만 등록, 선택 삭제 버튼 보임 --%>
			<c:if test="${isAdmin}">

				<div class="search-btn-right">

					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">

						등록

					</button>

					<button type="button"
						class="search-btn search-btn-sub"
						onclick="deleteCheck()">

						선택 삭제

					</button>

				</div>

			</c:if>

		</div>

		<div class="coTableWrap">

			<table class="coTable">

				<thead>

					<tr>

						<th>
							<label for="checkAll">선택</label>

							<input type="checkbox"
								id="checkAll"
								style="display:none;">
						</th>

						<th>입출고번호</th>
						<th>입출고구분</th>
						<th>품목명</th>
						<th>입출고량</th>
						<th>단위</th>
						<th>일자</th>
						<th>상세</th>

					</tr>

				</thead>

				<tbody>

					<c:forEach var="inout" items="${list}">

						<tr>

							<td>
								<input type="checkbox"
									name="inoutIds"
									value="${inout.inoutId}">
							</td>

							<td title="${inout.docNo}">
								${inout.docNo}
							</td>

							<td>

								<c:choose>

									<c:when test="${inout.inoutType eq 'MI'}">
										입고
									</c:when>

									<c:when test="${inout.inoutType eq 'MO-PROD'}">
										출고
									</c:when>

									<c:otherwise>
										${inout.inoutType}
									</c:otherwise>

								</c:choose>

							</td>

							<td title="${inout.itemName}">
								${inout.itemName}
							</td>

							<td>
								${inout.inoutQty}
							</td>

							<td>
								${inout.itemUnit}
							</td>

							<td>
								${inout.inoutDate}
							</td>

							<td>

								<button type="button"
									class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}'">

									보기

								</button>

							</td>

						</tr>

					</c:forEach>

				</tbody>

			</table>

		</div>

	</form>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>