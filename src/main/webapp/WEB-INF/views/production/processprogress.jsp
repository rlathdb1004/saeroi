<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: processprogress.jsp
	메뉴: 생산관리 > 공정진행 현황

	기준:
	- URL: /production/processprogress
	- Controller return: production/processprogress.tiles
	- 공정진행 현황은 작업지시와 생산실적 기준 자동 조회 화면
	- 별도 등록/삭제 기능 없음
	- 생산수량 + LOSS량 기준으로 진행률 계산
	- 진행상태는 Mapper에서 계산
	  대기 / 진행중 / 완료 / 보류 / 취소
	- 검색어 input placeholder는 생산관리 공통 기준 "검색 키워드"로 통일
	- 전체검색은 Mapper에서 상세페이지 주요 항목까지 대소문자 구분 없이 일부 포함 검색
	- 진행중은 완료와 같은 정상 스타일로 표시한다

	목록 컬럼 기준:
	- PC: 8개
	  1 작업지시번호
	  2 LOT번호
	  3 품목명
	  4 지시수량
	  5 생산누계
	  6 진행률
	  7 진행상태
	  8 상세

	- 모바일: 5개
	  1 LOT번호
	  2 생산누계
	  3 진행률
	  4 진행상태
	  5 상세
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<form class="search-form" method="get"
		action="${contextPath}/production/processprogress">

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
					<label class="search-label">진행상태</label>

					<select name="prodStatus" class="search-select">
						<option value="">전체</option>

						<c:forEach var="status" items="${processProgressStatusList}">
							<option value="${status}"
								<c:if test="${prodStatus eq status}">selected</c:if>>
								${status}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text" name="keyword" class="search-input"
						placeholder="검색 키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5"
								stroke="currentColor" stroke-width="2">
							</circle>
							<path d="M16 16L21 21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round">
							</path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/production/processprogress'">
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


	<div class="coTableTop">

		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

		<div class="process-progress-guide">
			작업지시와 생산실적 기준 자동 조회 화면입니다.
		</div>

	</div>


	<div class="coTableWrap">

		<table class="coTable process-progress-table">

			<thead>
				<tr>
					<th class="mobile_hidden">작업지시번호</th>
					<th class="mobile_show">LOT번호</th>
					<th class="mobile_hidden">품목명</th>
					<th class="mobile_hidden">지시수량</th>
					<th class="mobile_show">생산누계</th>
					<th class="mobile_show">진행률</th>
					<th class="mobile_show">진행상태</th>
					<th class="mobile_show">상세</th>
				</tr>
			</thead>

			<tbody>

				<c:choose>

					<c:when test="${not empty list}">

						<c:forEach var="progress" items="${list}">

							<tr>
								<td class="mobile_hidden" title="${progress.workOrderDocNo}">
									${progress.workOrderDocNo}
								</td>

								<td class="mobile_show" title="${progress.productLot}">
									${progress.productLot}
								</td>

								<td class="coTextLeft mobile_hidden"
									title="${progress.itemName}">
									${progress.itemName}
								</td>

								<td class="mobile_hidden">
									<fmt:formatNumber value="${progress.orderQty}"
										pattern="#,##0" />
									${progress.itemUnit}
								</td>

								<td class="mobile_show">
									<fmt:formatNumber value="${progress.totalProdQty}"
										pattern="#,##0" />
									${progress.itemUnit}
								</td>

								<td class="mobile_show">
									<div class="progress-rate-wrap">

										<div class="progress-rate-text">
											<fmt:formatNumber value="${progress.progressRate}"
												pattern="#,##0" />%
										</div>

										<div class="progress-rate-bar">
											<div class="progress-rate-fill"
												style="width: ${progress.progressRate}%;">
											</div>
										</div>

									</div>
								</td>

								<td class="mobile_show">
									<c:choose>

										<c:when
											test="${progress.progressStatus eq '완료' or progress.progressStatus eq '진행중'}">
											<span class="coStatus coStatusUse">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:when
											test="${progress.progressStatus eq '취소' or progress.progressStatus eq '보류'}">
											<span class="coStatus coStatusStop">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:otherwise>
											<span class="coStatus">
												${progress.progressStatus}
											</span>
										</c:otherwise>

									</c:choose>
								</td>

								<td class="mobile_show">
									<button type="button" class="coDetailBtn"
										onclick="location.href='${contextPath}/production/processprogress/detail?orderId=${progress.orderId}'">
										보기
									</button>
								</td>
							</tr>

						</c:forEach>

					</c:when>

					<c:otherwise>
						<tr>
							<td colspan="8">조회된 공정진행 현황이 없습니다.</td>
						</tr>
					</c:otherwise>

				</c:choose>

			</tbody>

		</table>

	</div>


	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>


<style>
.process-progress-guide {
	font-size: 13px;
	color: #666;
	white-space: nowrap;
}

.progress-rate-wrap {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 5px;
	min-width: 70px;
}

.progress-rate-text {
	font-size: 13px;
	font-weight: 600;
	color: #333;
	line-height: 1;
}

.progress-rate-bar {
	width: 72px;
	height: 6px;
	border-radius: 999px;
	background: #e8edf3;
	overflow: hidden;
}

.progress-rate-fill {
	height: 100%;
	border-radius: 999px;
	background: currentColor;
	color: #4a6cf7;
}

@media (max-width: 768px) {
	.process-progress-guide {
		display: none;
	}

	.progress-rate-bar {
		width: 56px;
	}
}
</style>