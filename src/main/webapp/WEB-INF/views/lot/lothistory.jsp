<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<form class="search-form" method="get"
		action="${pageContext.request.contextPath}/lot/lothistory">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label> <input type="date"
						name="startDate" class="search-date" value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label> <input type="date"
						name="endDate" class="search-date" value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">진행상태</label> <select
						name="progressStatus" class="search-select">

						<option value="">전체</option>

						<option value="대기"
							<c:if test="${progressStatus eq '대기'}">selected</c:if>>
							대기</option>

						<option value="진행중"
							<c:if test="${progressStatus eq '진행중'}">selected</c:if>>
							진행중</option>

						<option value="완료"
							<c:if test="${progressStatus eq '완료'}">selected</c:if>>
							완료</option>

					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="keyword" class="search-input" placeholder="검색키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn search-btn-main">

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
						onclick="location.href='${pageContext.request.contextPath}/lot/lothistory'">

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


	<form method="post" id="lotHistoryForm">

		<div class="coTableTop">

			<p class="coTotalCount">총 ${empty pageInfo.totalCount ? 0 : pageInfo.totalCount}건
			</p>

		</div>


		<div class="coTableWrap">

			<table class="coTable">

				<thead>
					<tr>
						<th class="mobile_show"><label id="lotHistoryCheckAllLabel">선택</label>

							<input type="checkbox" id="lotHistoryCheckAll"
							style="display: none;"></th>

						<th class="mobile_show">LOT번호</th>
						<th class="mobile_hidden">품목명</th>
						<th class="mobile_hidden">작업지시번호</th>
						<th class="mobile_hidden">현재공정</th>
						<th class="mobile_hidden">생산수량</th>
						<th class="mobile_hidden">검사결과</th>
						<th class="mobile_show">진행상태</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="lot" items="${list}">

						<tr>
							<td class="mobile_show"><input type="checkbox"
								name="orderIds" value="${lot.orderId}"></td>

							<td class="mobile_show" title="${lot.productLot}">
								${lot.productLot}</td>

							<td class="coTextLeft mobile_hidden" title="${lot.itemName}">
								${lot.itemName}</td>

							<td class="mobile_hidden" title="${lot.workOrderDocNo}">
								${lot.workOrderDocNo}</td>

							<td class="mobile_hidden" title="${lot.currentProcess}">
								${lot.currentProcess}</td>

							<td class="mobile_hidden">${lot.prodQty}</td>

							<td class="mobile_hidden"><c:choose>
									<c:when test="${lot.inspResult eq '합격'}">
										<span class="coStatus coStatusUse"> ${lot.inspResult} </span>
									</c:when>

									<c:when test="${lot.inspResult eq '불합격'}">
										<span class="coStatus coStatusStop"> ${lot.inspResult}
										</span>
									</c:when>

									<c:when test="${lot.inspResult eq '조건부 합격'}">
										<span class="coStatus"> ${lot.inspResult} </span>
									</c:when>

									<c:otherwise>
										<span class="coStatus"> ${empty lot.inspResult ? '-' : lot.inspResult}
										</span>
									</c:otherwise>
								</c:choose></td>

							<td class="mobile_show"><c:choose>
									<c:when test="${lot.progressStatus eq '완료'}">
										<span class="coStatus coStatusUse">
											${lot.progressStatus} </span>
									</c:when>

									<c:when test="${lot.progressStatus eq '보류'}">
										<span class="coStatus coStatusStop">
											${lot.progressStatus} </span>
									</c:when>

									<c:otherwise>
										<span class="coStatus"> ${empty lot.progressStatus ? '-' : lot.progressStatus}
										</span>
									</c:otherwise>
								</c:choose></td>

							<td class="mobile_show">
								<button type="button" class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/lot/lothistory/detail?orderId=${lot.orderId}'">
									보기</button>
							</td>
						</tr>

					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="9">조회된 LOT 이력이 없습니다.</td>
						</tr>
					</c:if>

				</tbody>

			</table>

		</div>

		<jsp:include page="/WEB-INF/views/common/paging.jsp" />

	</form>

</div>


<script>
	// LOT 이력추적 목록의 전체 선택 상태를 변경한다.
	document.getElementById("lotHistoryCheckAllLabel").onclick = function() {

		// 숨겨진 전체 선택 체크박스를 찾는다.
		var checkAll = document.getElementById("lotHistoryCheckAll");

		// 현재 체크 상태를 반대로 바꾼다.
		checkAll.checked = !checkAll.checked;

		// LOT 이력 체크박스 목록을 전부 찾는다.
		var checkboxList = document
				.querySelectorAll("#lotHistoryForm input[name='lotIds']");

		// 체크박스 개수만큼 반복한다.
		for (var i = 0; i < checkboxList.length; i++) {

			// 전체 선택 상태와 동일하게 체크 상태를 맞춘다.
			checkboxList[i].checked = checkAll.checked;
		}
	};
</script>