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
	- 공정진행 현황은 별도 등록하지 않는다.
	- 생산실적 등록(PRODUCTION) 데이터를 작업지시 기준으로 누적 집계해서 실시간 조회한다.
	- 진행률은 Mapper에서 계산된 progressRate를 사용한다.
	- 완료 건은 Mapper 기준으로 기본 목록에서 제외한다.
	- PC 목록 8컬럼 / 모바일 5컬럼 기준
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<%-- =========================================================
	     1. 검색 영역
	     ========================================================= --%>
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
						placeholder="작업지시번호 / LOT / 품목코드 / 품명 / 라인"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor"
								stroke-width="2"></circle>
							<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/production/processprogress'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"></path>
							<path d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round"></path>
						</svg>
						초기화
					</button>

				</div>

			</div>

		</div>

	</form>


	<%-- =========================================================
	     2. 목록 상단
	     ========================================================= --%>
	<div class="coTableTop">

		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

		<div class="process_progress_notice">
			생산실적 등록 기준으로 자동 집계됩니다.
		</div>

	</div>


	<%-- =========================================================
	     3. 목록
	     ========================================================= --%>
	<div class="coTableWrap">

		<table class="coTable process_progress_table">

			<colgroup>
				<col class="pp_col_doc_col">
				<col class="pp_col_lot_col">
				<col class="pp_col_item_col">
				<col class="pp_col_line_col">
				<col class="pp_col_order_qty_col">
				<col class="pp_col_prod_qty_col">
				<col class="pp_col_progress_col">
				<col class="pp_col_detail_col">
			</colgroup>

			<thead>
				<tr>
					<th class="pp_col_doc mobile_hidden">작업지시번호</th>
					<th class="pp_col_lot mobile_show">LOT번호</th>
					<th class="pp_col_item mobile_hidden">품목명</th>
					<th class="pp_col_line mobile_hidden">라인</th>
					<th class="pp_col_order_qty mobile_show">지시수량</th>
					<th class="pp_col_prod_qty mobile_show">누적생산</th>
					<th class="pp_col_progress mobile_show">진행률</th>
					<th class="pp_col_detail mobile_show">상세</th>
				</tr>
			</thead>

			<tbody>

				<c:forEach var="progress" items="${list}">

					<tr>
						<td class="pp_col_doc mobile_hidden"
							title="${progress.workOrderDocNo}">
							${progress.workOrderDocNo}
						</td>

						<td class="pp_col_lot mobile_show"
							title="${progress.productLot}">
							${progress.productLot}
						</td>

						<td class="pp_col_item mobile_hidden"
							title="${progress.itemName}">
							${progress.itemName}
						</td>

						<td class="pp_col_line mobile_hidden"
							title="${progress.lineName}">
							${progress.lineName}
						</td>

						<td class="pp_col_order_qty mobile_show">
							<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
							${progress.itemUnit}
						</td>

						<td class="pp_col_prod_qty mobile_show">
							<fmt:formatNumber value="${progress.totalProdQty}" pattern="#,##0" />
							${progress.itemUnit}
						</td>

						<td class="pp_col_progress mobile_show">

							<div class="progress_cell">

								<div class="progress_bar">
									<div class="progress_bar_fill"
										style="width:${progress.progressRate}%;"></div>
								</div>

								<div class="progress_text">

									<span class="progress_rate_text">
										<fmt:formatNumber value="${progress.progressRate}"
											pattern="#,##0" />%
									</span>

									<c:choose>
										<c:when test="${progress.progressStatus eq '완료'}">
											<span class="coStatus coStatusUse">
												${progress.progressStatus}
											</span>
										</c:when>

										<c:when
											test="${progress.progressStatus eq '보류' or progress.progressStatus eq '취소'}">
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

								</div>

							</div>

						</td>

						<td class="pp_col_detail mobile_show">
							<button type="button" class="coDetailBtn"
								onclick="location.href='${contextPath}/production/processprogress/detail?orderId=${progress.orderId}'">
								보기
							</button>
						</td>
					</tr>

				</c:forEach>

				<c:if test="${empty list}">
					<tr>
						<td colspan="8">조회된 공정진행 정보가 없습니다.</td>
					</tr>
				</c:if>

			</tbody>

		</table>

	</div>


	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>


<style>
.process_progress_notice {
	font-size: 13px;
	color: #666;
	line-height: 32px;
	white-space: nowrap;
}

.coPageWrap .coTable.process_progress_table {
	width: 100%;
	table-layout: fixed;
}

.coPageWrap .coTable.process_progress_table th,
.coPageWrap .coTable.process_progress_table td {
	white-space: nowrap;
	word-break: keep-all;
	overflow: hidden;
	text-overflow: ellipsis;
	box-sizing: border-box;
	text-align: center;
}

/* 공정진행현황 컬럼폭 보정
   공용 CSS의 첫 번째 컬럼 폭 규칙을 이 페이지에서만 덮어쓴다. */
.coPageWrap .coTable.process_progress_table th:nth-child(1),
.coPageWrap .coTable.process_progress_table td:nth-child(1) {
	width: 13% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(2),
.coPageWrap .coTable.process_progress_table td:nth-child(2) {
	width: 16% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(3),
.coPageWrap .coTable.process_progress_table td:nth-child(3) {
	width: 19% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(4),
.coPageWrap .coTable.process_progress_table td:nth-child(4) {
	width: 11% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(5),
.coPageWrap .coTable.process_progress_table td:nth-child(5) {
	width: 11% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(6),
.coPageWrap .coTable.process_progress_table td:nth-child(6) {
	width: 11% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(7),
.coPageWrap .coTable.process_progress_table td:nth-child(7) {
	width: 13% !important;
}

.coPageWrap .coTable.process_progress_table th:nth-child(8),
.coPageWrap .coTable.process_progress_table td:nth-child(8) {
	width: 6% !important;
}

/* colgroup을 넣어둔 경우에도 같은 폭을 적용한다. */
.coPageWrap .coTable.process_progress_table col:nth-child(1) {
	width: 13% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(2) {
	width: 16% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(3) {
	width: 19% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(4) {
	width: 11% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(5) {
	width: 11% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(6) {
	width: 11% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(7) {
	width: 13% !important;
}

.coPageWrap .coTable.process_progress_table col:nth-child(8) {
	width: 6% !important;
}

.progress_cell {
	width: 100%;
	min-width: 0;
}

.progress_bar {
	width: 100%;
	height: 7px;
	background: #e9edf0;
	border-radius: 99px;
	overflow: hidden;
	margin-bottom: 5px;
}

.progress_bar_fill {
	height: 100%;
	background: #174c3c;
	border-radius: 99px;
}

.progress_text {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 6px;
	font-size: 12px;
	color: #444;
	white-space: nowrap;
	min-width: 0;
}

.progress_rate_text {
	font-weight: 700;
	color: #333;
}

.coPageWrap .coTable.process_progress_table th.pp_col_detail,
.coPageWrap .coTable.process_progress_table td.pp_col_detail {
	text-align: center;
	vertical-align: middle;
	padding-left: 0;
	padding-right: 0;
}

.coPageWrap .coTable.process_progress_table td.pp_col_detail .coDetailBtn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	float: none;
	margin: 0 auto;
	vertical-align: middle;
}

/* 모바일 5컬럼: LOT번호 / 지시수량 / 누적생산 / 진행률 / 상세 */
@media (max-width: 768px) {
	.process_progress_notice {
		display: none;
	}

	.coPageWrap .coTable.process_progress_table th,
	.coPageWrap .coTable.process_progress_table td {
		font-size: 12px;
		padding-left: 6px;
		padding-right: 6px;
	}

	.progress_bar {
		display: none;
	}

	.progress_text {
		gap: 3px;
	}

	.coPageWrap .coTable.process_progress_table th:nth-child(2),
	.coPageWrap .coTable.process_progress_table td:nth-child(2),
	.coPageWrap .coTable.process_progress_table col:nth-child(2) {
		width: 30% !important;
	}

	.coPageWrap .coTable.process_progress_table th:nth-child(5),
	.coPageWrap .coTable.process_progress_table td:nth-child(5),
	.coPageWrap .coTable.process_progress_table col:nth-child(5) {
		width: 18% !important;
	}

	.coPageWrap .coTable.process_progress_table th:nth-child(6),
	.coPageWrap .coTable.process_progress_table td:nth-child(6),
	.coPageWrap .coTable.process_progress_table col:nth-child(6) {
		width: 18% !important;
	}

	.coPageWrap .coTable.process_progress_table th:nth-child(7),
	.coPageWrap .coTable.process_progress_table td:nth-child(7),
	.coPageWrap .coTable.process_progress_table col:nth-child(7) {
		width: 24% !important;
	}

	.coPageWrap .coTable.process_progress_table th:nth-child(8),
	.coPageWrap .coTable.process_progress_table td:nth-child(8),
	.coPageWrap .coTable.process_progress_table col:nth-child(8) {
		width: 10% !important;
	}
}
</style>