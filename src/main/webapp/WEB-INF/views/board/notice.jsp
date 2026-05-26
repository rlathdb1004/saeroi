<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/board/notice">

		<div class="search-box">
			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label>
					<input type="date" name="startDate" class="search-date"
						value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label>
					<input type="date" name="endDate" class="search-date"
						value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>
					<input type="text" name="keyword" class="search-input"
						placeholder="검색키워드" value="${keyword}">
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5"
								stroke="currentColor" stroke-width="2"></circle>
							<path d="M16 16L21 21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/board/notice'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M18 4V7H21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round"></path>
						</svg>
						초기화
					</button>
				</div>

			</div>
		</div>
	</form>

	<form method="post" id="deleteForm" accept-charset="UTF-8"
		action="${pageContext.request.contextPath}/board/notice/delete">

		<div class="coTableTop">
			<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<div class="search-btn-right">

					<button type="button" class="search-btn search-btn-main"
						onclick="location.href='${pageContext.request.contextPath}/board/notice/add'">
						<svg viewBox="0 0 24 24" fill="none">
							<path d="M12 5V19" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
							<path d="M5 12H19" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
						</svg>
						등록
					</button>

					<button type="submit" class="search-btn search-btn-sub">
						<svg viewBox="0 0 24 24" fill="none">
							<path d="M4 7H20" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
							<path d="M10 11V17" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
							<path d="M14 11V17" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
							<path d="M6 7L7 21H17L18 7" stroke="currentColor"
								stroke-width="2" stroke-linejoin="round"></path>
							<path d="M9 7V4H15V7" stroke="currentColor"
								stroke-width="2" stroke-linejoin="round"></path>
						</svg>
						선택 삭제
					</button>

				</div>
			</c:if>
		</div>

		<div class="coTableWrap">
			<table class="coTable">
				<thead>
					<tr>
						<th class="mobile_show checkAllHeader" style="cursor: pointer;">선택</th>
						<th class="mobile_hidden">공지번호</th>
						<th class="mobile_show">제목</th>
						<th class="mobile_hidden">작성자</th>
						<th class="mobile_show">작성일</th>
						<th class="mobile_hidden">조회수</th>
						<th class="mobile_hidden">상태</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="notice" items="${list}">
						<tr>
							<td class="mobile_show">
								<input type="checkbox" name="notice_id"
									value="${notice.notice_id}">
							</td>

							<td class="mobile_hidden">${notice.notice_id}</td>
							<td class="coTextLeft mobile_show">${notice.title}</td>
							<td class="mobile_hidden">${notice.dept}</td>
							<td class="mobile_show">${notice.created_date}</td>
							<td class="mobile_hidden">${notice.view_count}</td>

							<td class="mobile_hidden">
								<c:choose>
									<c:when test="${notice.status == '게시'}">
										<span class="coStatus coStatusUse">${notice.status}</span>
									</c:when>
									<c:otherwise>
										<span class="coStatus coStatusStop">${notice.status}</span>
									</c:otherwise>
								</c:choose>
							</td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/board/notice/detail?notice_id=${notice.notice_id}'">
									보기
								</button>
							</td>
						</tr>
					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="8">조회된 공지사항이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

	</form>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script
	src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>