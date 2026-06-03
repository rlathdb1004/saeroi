<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- 대시보드 본문 화면이다. --%>

<section class="dashboard-page">

	<%-- 대시보드 데이터 기준시간 영역이다. --%>
	<section class="dash-time-card">
		<div class="dash-time-left">
			<span class="dash-time-icon"> <svg viewBox="0 0 24 24"
					aria-hidden="true">
				<circle cx="12" cy="12" r="9"></circle>
				<path d="M12 7V12L15 14"></path>
			</svg>
			</span> <strong>데이터 기준시간</strong> <span id="dashCurrentTime"
				class="dash-current-time">0000-00-00 (월) 00:00:00</span>
		</div>

		<div class="dash-time-control">
			<span class="dash-time-control-label">기준 상태</span> <span
				id="dashTimeStatus" class="dash-time-status"> <span
				class="dash-time-status-dot"></span> 접속시점 기준
			</span>

			<button type="button" id="dashTimeRefreshBtn"
				class="dash-time-refresh-btn">
				<span class="dash-time-refresh-icon"> <svg
						viewBox="0 0 24 24" aria-hidden="true">
					<path d="M21 12A9 9 0 0 1 6.5 19.1"></path>
					<path d="M3 12A9 9 0 0 1 17.5 4.9"></path>
					<path d="M6 19H3V16"></path>
					<path d="M18 5H21V8"></path>
				</svg>
				</span> 기준시간 갱신
			</button>
		</div>
	</section>

	<%-- KPI 5대 관리자 영역이다. --%>
	<section class="dash-kpi-panel">

		<div class="dash-kpi-panel-head">
			<h3>KPI 5대 관리자</h3>
		</div>

		<section class="dash-kpi-grid">

			<article class="dash-kpi-card dash-kpi-click"
				id="dashAchievementKpiCard" data-kpi-type="achievement"
				data-kpi-title="생산달성률">

				<div class="dash-kpi-head">
					<strong>생산달성률</strong> <span class="dash-info-mini">i</span>
				</div>

				<div class="dash-kpi-body">
					<span class="dash-kpi-icon dash-green-icon"> <svg
							viewBox="0 0 24 24" aria-hidden="true">
						<circle cx="12" cy="12" r="8"></circle>
						<circle cx="12" cy="12" r="4"></circle>
						<path d="M12 12L18 6"></path>
						<path d="M17 6H20V9"></path>
					</svg>
					</span>

					<div class="dash-kpi-value dash-green-text">
						<strong> <fmt:formatNumber
								value="${dashKpiAchievementRate}" pattern="#,##0.0" />
						</strong> <span>%</span>
					</div>
				</div>

				<div class="dash-kpi-detail">
					<span> 목표 <strong> <fmt:formatNumber
								value="${dashKpiProdTargetQty}" pattern="#,##0" /> EA
					</strong>
					</span> <span> 실적 <strong> <fmt:formatNumber
								value="${dashKpiProdActualQty}" pattern="#,##0" /> EA
					</strong>
					</span>
				</div>

				<div class="dash-kpi-bottom">
					<c:choose>
						<c:when test="${dashKpiAchievementCompareNoPrevData}">
							<strong class="dash-neutral-text">전일 데이터 없음</strong>
						</c:when>

						<c:otherwise>
							<span>전일 대비</span>
							<strong class="${dashKpiAchievementCompareClass}"> <c:choose>
									<c:when
										test="${empty dashKpiAchievementComparePoint or dashKpiAchievementComparePoint eq 0}">
									변동 없음
								</c:when>
									<c:otherwise>
									${dashKpiAchievementCompareArrow}
									<fmt:formatNumber value="${dashKpiAchievementComparePoint}"
											pattern="#,##0.0" />%p
								</c:otherwise>
								</c:choose>
							</strong>
						</c:otherwise>
					</c:choose>
				</div>
			</article>

			<article class="dash-kpi-card dash-kpi-click"
				id="dashProductionKpiCard" data-kpi-type="production"
				data-kpi-title="금일 생산량">

				<div class="dash-kpi-head">
					<strong>금일 생산량</strong> <span class="dash-info-mini">i</span>
				</div>

				<div class="dash-kpi-body">
					<span class="dash-kpi-icon dash-green-icon"> <svg
							viewBox="0 0 24 24" aria-hidden="true">
						<path d="M5 19V13"></path>
						<path d="M10 19V9"></path>
						<path d="M15 19V5"></path>
						<path d="M20 19V11"></path>
					</svg>
					</span>

					<div class="dash-kpi-value dash-green-text">
						<strong> <fmt:formatNumber value="${dashKpiTodayProdQty}"
								pattern="#,##0" />
						</strong> <span>EA</span>
					</div>
				</div>

				<div class="dash-kpi-detail">
					<span> 전일 <strong> <fmt:formatNumber
								value="${dashKpiPrevProdQty}" pattern="#,##0" /> EA
					</strong>
					</span>
				</div>

				<div class="dash-kpi-bottom">
					<c:choose>
						<c:when test="${dashKpiTodayProdCompareNoPrevData}">
							<strong class="dash-neutral-text">전일 데이터 없음</strong>
						</c:when>

						<c:otherwise>
							<span>전일 대비</span>
							<strong class="${dashKpiTodayProdCompareClass}"> <c:choose>
									<c:when
										test="${empty dashKpiTodayProdCompareQty or dashKpiTodayProdCompareQty eq 0}">
									변동 없음
								</c:when>
									<c:otherwise>
									${dashKpiTodayProdCompareArrow}
									<fmt:formatNumber value="${dashKpiTodayProdCompareQty}"
											pattern="#,##0" /> EA
								</c:otherwise>
								</c:choose>
							</strong>
						</c:otherwise>
					</c:choose>
				</div>
			</article>

			<article class="dash-kpi-card dash-kpi-click" id="dashDefectKpiCard"
				data-kpi-type="defect" data-kpi-title="불량률">

				<div class="dash-kpi-head">
					<strong>불량률</strong> <span class="dash-info-mini">i</span>
				</div>

				<div class="dash-kpi-body">
					<span class="dash-kpi-icon dash-red-icon"> <svg
							viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
						<path d="M9 9L15 15"></path>
						<path d="M15 9L9 15"></path>
					</svg>
					</span>

					<div class="dash-kpi-value dash-red-text">
						<strong> <fmt:formatNumber value="${dashKpiDefectRate}"
								pattern="#,##0.0" />
						</strong> <span>%</span>
					</div>
				</div>

				<div class="dash-kpi-detail">
					<span> 불량 <strong> <fmt:formatNumber
								value="${dashKpiDefectQty}" pattern="#,##0" /> EA
					</strong>
					</span> <span> 검사 <strong> <fmt:formatNumber
								value="${dashKpiInspectionQty}" pattern="#,##0" /> EA
					</strong>
					</span>
				</div>

				<div class="dash-kpi-bottom">
					<c:choose>
						<c:when test="${dashKpiDefectCompareNoPrevData}">
							<strong class="dash-neutral-text">전일 데이터 없음</strong>
						</c:when>

						<c:otherwise>
							<span>전일 대비</span>
							<strong class="${dashKpiDefectCompareClass}"> <c:choose>
									<c:when
										test="${empty dashKpiDefectComparePoint or dashKpiDefectComparePoint eq 0}">
									변동 없음
								</c:when>
									<c:otherwise>
									${dashKpiDefectCompareArrow}
									<fmt:formatNumber value="${dashKpiDefectComparePoint}"
											pattern="#,##0.0" />%p
								</c:otherwise>
								</c:choose>
							</strong>
						</c:otherwise>
					</c:choose>
				</div>
			</article>

			<article class="dash-kpi-card dash-kpi-click" id="dashOeeKpiCard"
				data-kpi-type="oee" data-kpi-title="OEE">

				<div class="dash-kpi-head">
					<strong>OEE</strong> <span class="dash-info-mini">i</span>
				</div>

				<div class="dash-kpi-body">
					<span class="dash-kpi-icon dash-green-icon dash-oee-icon"> <svg
							class="dash-oee-svg" viewBox="0 0 64 64" aria-hidden="true">
						<path class="dash-oee-arc"
								d="M12 42C12 30.95 20.95 22 32 22C43.05 22 52 30.95 52 42"></path>
						<path class="dash-oee-tick" d="M16 42H10"></path>
						<path class="dash-oee-tick" d="M20.5 30.5L16.2 26.2"></path>
						<path class="dash-oee-tick" d="M32 26V19"></path>
						<path class="dash-oee-tick" d="M43.5 30.5L47.8 26.2"></path>
						<path class="dash-oee-tick" d="M54 42H48"></path>
						<path class="dash-oee-needle" d="M32 42L44 30"></path>
						<circle class="dash-oee-center" cx="32" cy="42" r="4"></circle>
					</svg>
					</span>

					<div class="dash-kpi-value dash-green-text">
						<strong> <fmt:formatNumber value="${dashKpiOeeRate}"
								pattern="#,##0.0" />
						</strong> <span>%</span>
					</div>
				</div>

				<div class="dash-kpi-detail">
					<span> 가동 <strong> <fmt:formatNumber
								value="${dashKpiOeeRunTime}" pattern="#,##0" />분
					</strong>
					</span> <span> 계획 <strong> <fmt:formatNumber
								value="${dashKpiOeePlanTime}" pattern="#,##0" />분
					</strong>
					</span>
				</div>

				<div class="dash-kpi-bottom">
					<c:choose>
						<c:when test="${dashKpiOeeCompareNoPrevData}">
							<strong class="dash-neutral-text">전일 데이터 없음</strong>
						</c:when>

						<c:otherwise>
							<span>전일 대비</span>
							<strong class="${dashKpiOeeCompareClass}"> <c:choose>
									<c:when
										test="${empty dashKpiOeeComparePoint or dashKpiOeeComparePoint eq 0}">
									변동 없음
								</c:when>
									<c:otherwise>
									${dashKpiOeeCompareArrow}
									<fmt:formatNumber value="${dashKpiOeeComparePoint}"
											pattern="#,##0.0" />%p
								</c:otherwise>
								</c:choose>
							</strong>
						</c:otherwise>
					</c:choose>
				</div>
			</article>

			<article class="dash-kpi-card dash-kpi-click" id="dashDelayKpiCard"
				data-kpi-type="delay" data-kpi-title="지연 작업지시">

				<div class="dash-kpi-head">
					<strong>지연 작업지시</strong> <span class="dash-info-mini">i</span>
				</div>

				<div class="dash-kpi-body">
					<span class="dash-kpi-icon dash-orange-icon"> <svg
							viewBox="0 0 24 24" aria-hidden="true">
						<circle cx="12" cy="12" r="9"></circle>
						<path d="M12 7V12L16 15"></path>
					</svg>
					</span>

					<div class="dash-kpi-value dash-orange-text">
						<strong> <fmt:formatNumber
								value="${dashKpiDelayOrderCount}" pattern="#,##0" />
						</strong> <span>건</span>
					</div>
				</div>

				<div class="dash-kpi-detail">
					<span> 지연 수량 <strong> <fmt:formatNumber
								value="${dashKpiDelayQty}" pattern="#,##0" /> EA
					</strong>
					</span>
				</div>

				<div class="dash-kpi-bottom">
					<c:choose>
						<c:when test="${dashKpiDelayCompareNoPrevData}">
							<strong class="dash-neutral-text">전일 데이터 없음</strong>
						</c:when>

						<c:otherwise>
							<span>전일 대비</span>
							<strong class="${dashKpiDelayCompareClass}"> <c:choose>
									<c:when
										test="${empty dashKpiDelayCompareCount or dashKpiDelayCompareCount eq 0}">
									변동 없음
								</c:when>
									<c:otherwise>
									${dashKpiDelayCompareArrow}
									<fmt:formatNumber value="${dashKpiDelayCompareCount}"
											pattern="#,##0" />건
								</c:otherwise>
								</c:choose>
							</strong>
						</c:otherwise>
					</c:choose>
				</div>
			</article>

		</section>

		<%-- KPI 상세 모달 영역이다. --%>
		<div class="dash-kpi-modal-backdrop" id="dashKpiModalBackdrop">
			<div class="dash-kpi-modal">

				<div class="dash-kpi-modal-head">
					<div>
						<h3 id="dashKpiModalTitle">생산달성률 상세</h3>
						<p>선택한 주차와 전주 데이터를 비교한다.</p>
					</div>

					<button type="button" class="dash-kpi-modal-close"
						id="dashKpiModalClose">×</button>
				</div>

				<div class="dash-kpi-modal-week">
					<button type="button" class="dash-kpi-week-btn"
						id="dashKpiPrevWeekBtn">‹ 이전 주</button>

					<div class="dash-kpi-week-center">
						<strong id="dashKpiWeekRange">-</strong> <span
							id="dashKpiPrevWeekRange">비교 기간 -</span>
					</div>

					<div class="dash-kpi-week-picker">
						<label for="dashKpiWeekDate">주차 선택</label> <input type="date"
							id="dashKpiWeekDate">
					</div>

					<button type="button" class="dash-kpi-week-btn"
						id="dashKpiNextWeekBtn">다음 주 ›</button>
				</div>

				<div class="dash-kpi-modal-summary">
					<div>
						<span>이번 주 평균 달성률</span> <strong id="dashKpiCurrentAvg">0.0%</strong>
					</div>

					<div>
						<span>전주 평균 달성률</span> <strong id="dashKpiPrevAvg">0.0%</strong>
					</div>

					<div>
						<span>증감</span> <strong id="dashKpiCompareAvg"
							class="dash-neutral-text">변동 없음</strong>
					</div>
				</div>

				<div class="dash-kpi-modal-table-grid">
					<div class="dash-kpi-modal-table-box">
						<h4 id="dashKpiCurrentTableTitle">이번 주</h4>

						<table class="dash-kpi-modal-table">
							<thead>
								<tr>
									<th>날짜</th>
									<th>계획량</th>
									<th>실적량</th>
									<th>달성률</th>
								</tr>
							</thead>
							<tbody id="dashKpiCurrentTbody">
								<tr>
									<td colspan="4">조회 중입니다.</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="dash-kpi-modal-table-box">
						<h4 id="dashKpiPrevTableTitle">전주</h4>

						<table class="dash-kpi-modal-table">
							<thead>
								<tr>
									<th>날짜</th>
									<th>계획량</th>
									<th>실적량</th>
									<th>달성률</th>
								</tr>
							</thead>
							<tbody id="dashKpiPrevTbody">
								<tr>
									<td colspan="4">조회 중입니다.</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<div class="dash-kpi-modal-foot">
					<span>계획량, 실적량, 달성률은 생산 일자 기준으로 집계된다.</span>
				</div>

			</div>
		</div>

	</section>

	<%-- 현장 이슈와 LOT 현황 영역이다. --%>
	<section class="dash-alert-panel">

		<div class="dash-alert-panel-head">
			<h3>현장 이슈 &amp; LOT 현황</h3>
		</div>

		<div class="dash-alert-main ${dashIssueBoxClass}">
			<span class="dash-alert-bell"> <svg viewBox="0 0 24 24"
					aria-hidden="true">
			<path d="M18 8A6 6 0 0 0 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8"></path>
			<path d="M10 21H14"></path>
		</svg>
			</span> <strong>긴급 알림</strong> <em> <c:choose>
					<c:when test="${empty dashIssueTotalCount}">
				0
			</c:when>
					<c:otherwise>
						<fmt:formatNumber value="${dashIssueTotalCount}" pattern="#,##0" />
					</c:otherwise>
				</c:choose>건
			</em>
		</div>

		<div
			class="dash-alert-items${empty dashIssueTotalCount or dashIssueTotalCount le 0 ? ' dash-alert-items-empty' : ''}">

			<c:if test="${empty dashIssueTotalCount or dashIssueTotalCount le 0}">
				<div class="dash-alert-card dash-alert-empty-card">
					<div class="dash-alert-text">
						<div class="dash-alert-title-row">
							<strong>현재 긴급 이슈 없음</strong>
							<time>-</time>
						</div>

						<span>현재 처리 필요한 불량, 설비 고장, 지연 작업지시가 없습니다.</span>
					</div>
				</div>
			</c:if>

			<c:if test="${dashDefectIssueYn eq 'Y'}">
	<div class="dash-alert-card dash-dashboard-detail-click" data-detail-type="defectIssue">
					<div class="dash-alert-text">
						<div class="dash-alert-title-row">
							<strong>불량 경고</strong>
							<time>${dashDefectIssueTime}</time>
						</div>

						<span class="dash-alert-desc"> 불량률 <fmt:formatNumber
								value="${dashDefectIssueRate}" pattern="#,##0.0" />% <span
							class="dash-alert-desc-sub"> (기준 <fmt:formatNumber
									value="${dashDefectStandardRate}" pattern="#,##0.0" />% 초과)
						</span>
						</span>
					</div>
				</div>
			</c:if>

			<c:if test="${dashTroubleIssueYn eq 'Y'}">
	<div class="dash-alert-card dash-dashboard-detail-click" data-detail-type="equipmentIssue">
					<div class="dash-alert-text">
						<div class="dash-alert-title-row">
							<strong>설비 고장</strong>
							<time>${dashTroubleIssueTime}</time>
						</div>

						<span> 미조치 설비 고장 <fmt:formatNumber
								value="${dashTroubleCount}" pattern="#,##0" />건 발생
						</span>
					</div>
				</div>
			</c:if>

			<c:if test="${dashDelayIssueYn eq 'Y'}">
	<div class="dash-alert-card dash-alert-orange dash-dashboard-detail-click" data-detail-type="delayLot">
					<div class="dash-alert-text">
						<div class="dash-alert-title-row">
							<strong>지연 작업지시</strong>
							<time>${dashDelayIssueTime}</time>
						</div>

						<span> 지연 작업지시 <fmt:formatNumber
								value="${dashDelayOrderCount}" pattern="#,##0" />건 발생
						</span>
					</div>
				</div>
			</c:if>
		</div>

		<div class="dash-lot-row">
			<div class="dash-lot-box dash-dashboard-detail-click"
				data-detail-type="delayLot">
				<span class="dash-lot-icon dash-lot-red-icon"> <svg
						viewBox="0 0 24 24" aria-hidden="true">
				<circle cx="12" cy="12" r="9"></circle>
				<path d="M12 7V12L15 14"></path>
			</svg>
				</span>

				<div class="dash-lot-info">
					<span>생산지연 LOT</span> <strong class="dash-red-text"> <c:choose>
							<c:when test="${empty dashDelayLotCount}">
						0
					</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${dashDelayLotCount}" pattern="#,##0" />
							</c:otherwise>
						</c:choose>건
					</strong>
				</div>

				<em class="dash-lot-arrow">›</em>
			</div>

			<div class="dash-lot-box dash-dashboard-detail-click"
				data-detail-type="inspectionWaitLot">
				<span class="dash-lot-icon dash-lot-orange-icon"> <svg
						viewBox="0 0 24 24" aria-hidden="true">
				<path d="M8 3H16"></path>
				<path d="M9 3V7"></path>
				<path d="M15 3V7"></path>
				<rect x="6" y="7" width="12" height="14" rx="2"></rect>
				<path d="M9 12H15"></path>
				<path d="M9 16H13"></path>
			</svg>
				</span>

				<div class="dash-lot-info">
					<span>검사대기 LOT</span> <strong class="dash-orange-text"> <c:choose>
							<c:when test="${empty dashInspectionWaitLotCount}">
						0
					</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${dashInspectionWaitLotCount}"
									pattern="#,##0" />
							</c:otherwise>
						</c:choose>건
					</strong>
				</div>

				<em class="dash-lot-arrow">›</em>
			</div>

			<div class="dash-lot-box dash-dashboard-detail-click"
				data-detail-type="shipmentWaitLot">
				<span class="dash-lot-icon dash-lot-blue-icon"> <svg
						viewBox="0 0 24 24" aria-hidden="true">
				<path d="M21 8L12 3L3 8L12 13L21 8Z"></path>
				<path d="M3 8V16L12 21L21 16V8"></path>
				<path d="M12 13V21"></path>
			</svg>
				</span>

				<div class="dash-lot-info">
					<span>완제품 출하대기 LOT</span> <strong class="dash-blue-text">
						<c:choose>
							<c:when test="${empty dashFinishedShipWaitLotCount}">
						0
					</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${dashFinishedShipWaitLotCount}"
									pattern="#,##0" />
							</c:otherwise>
						</c:choose>건
					</strong>
				</div>

				<em class="dash-lot-arrow">›</em>
			</div>
		</div>

	</section>

	<%-- 현장 이슈와 LOT 간략 목록 모달 영역이다. --%>
	<div class="dash-dashboard-detail-modal-backdrop"
		id="dashDashboardDetailModalBackdrop">
		<div class="dash-dashboard-detail-modal">

			<div class="dash-dashboard-detail-modal-head">
				<div>
					<h3 id="dashDashboardDetailModalTitle">상세 목록</h3>
					<p id="dashDashboardDetailModalDesc">선택한 항목의 간략 목록을 조회한다.</p>
				</div>

				<button type="button" class="dash-dashboard-detail-modal-close"
					id="dashDashboardDetailModalClose">×</button>
			</div>

			<div class="dash-dashboard-detail-modal-body">
				<table class="dash-dashboard-detail-table">
					<thead id="dashDashboardDetailThead">
						<tr>
							<th>항목</th>
							<th>내용</th>
							<th>상태</th>
							<th>상세</th>
						</tr>
					</thead>

					<tbody id="dashDashboardDetailTbody">
						<tr>
							<td colspan="4">조회 중입니다.</td>
						</tr>
					</tbody>
				</table>
			</div>

		</div>
	</div>

	<%-- 주요 운영 지표 추이 영역이다. --%>
	<section class="dash-chart-panel">

		<%-- 주요 운영 지표 추이 제목 영역이다. --%>
		<div class="dash-chart-panel-head">
			<h3>주요 운영 지표 추이</h3>

			<div class="dash-chart-period">
				<span class="dash-chart-period-icon"> <svg
						viewBox="0 0 24 24" aria-hidden="true">
						<path d="M8 2V5"></path>
						<path d="M16 2V5"></path>
						<rect x="4" y="4" width="16" height="17" rx="2"></rect>
						<path d="M8 11H16"></path>
						<path d="M8 15H13"></path>
					</svg>
				</span> 최근 7일 추이
			</div>
		</div>

		<%-- 주요 운영 지표 추이 그래프 목록이다. --%>
		<div class="dash-chart-grid">

			<article class="dash-card dash-chart-card">
				<div class="dash-card-head">
					<h3>생산실적 추이</h3>

					<div class="dash-card-head-right">
						<span class="dash-unit-text">단위: EA</span>
					</div>
				</div>

				<div class="dash-chart-box dash-chart-box-lg">
					<canvas id="productionChart"></canvas>
				</div>

				<div class="dash-chart-summary">
					<div class="dash-summary-item">
						<span class="dash-summary-label">이번 주 실적</span> <strong
							class="dash-summary-value dash-green-text"> <fmt:formatNumber
								value="${dashProdWeekResult}" pattern="#,##0" /> EA
						</strong>
					</div>

					<div class="dash-summary-item">
						<span class="dash-summary-label">계획 대비</span> <strong
							class="dash-summary-value dash-green-text"> <fmt:formatNumber
								value="${dashProdPlanRate}" pattern="#,##0.0" />%
						</strong>
					</div>

					<div class="dash-summary-item">
						<span class="dash-summary-label">전주 대비</span> <strong
							class="dash-summary-value ${dashProdWeekCompareClass}">
							${dashProdWeekCompareArrow} <fmt:formatNumber
								value="${dashProdWeekCompareRate}" pattern="#,##0.0" />%
						</strong>
					</div>
				</div>
			</article>

			<article class="dash-card dash-chart-card">
				<div class="dash-card-head">
					<h3>불량 추이</h3>

					<div class="dash-card-head-right">
						<span class="dash-unit-text">단위: %</span>
					</div>
				</div>

				<div class="dash-chart-box dash-chart-box-lg">
					<canvas id="defectChart"></canvas>
				</div>

				<div class="dash-chart-summary dash-chart-summary-red">
					<div class="dash-summary-item">
						<span class="dash-summary-label">이번 주 불량률</span> <strong
							class="dash-summary-value dash-red-text"> <fmt:formatNumber
								value="${dashDefectWeekRate}" pattern="#,##0.0" />%
						</strong>
					</div>

					<div class="dash-summary-item">
						<span class="dash-summary-label">불량 수량</span> <strong
							class="dash-summary-value dash-red-text"> <fmt:formatNumber
								value="${dashDefectWeekQty}" pattern="#,##0" /> EA
						</strong>
					</div>

					<div class="dash-summary-item">
						<span class="dash-summary-label">전주 대비</span> <strong
							class="dash-summary-value ${dashDefectWeekCompareClass}">
							${dashDefectWeekCompareArrow} <fmt:formatNumber
								value="${dashDefectWeekCompareRate}" pattern="#,##0.0" />%
						</strong>
					</div>
				</div>
			</article>

<!-- 			<article class="dash-card dash-chart-card"> -->
<!-- 				<div class="dash-card-head"> -->
<!-- 					<h3>납기 준수율 추이</h3> -->

<!-- 					<div class="dash-card-head-right"> -->
<!-- 						<span class="dash-unit-text">단위: %</span> -->
<!-- 					</div> -->
<!-- 				</div> -->

<!-- 				<div class="dash-chart-box dash-chart-box-lg"> -->
<%-- 					<canvas id="deliveryChart"></canvas> --%>
<!-- 				</div> -->

<!-- 				<div class="dash-chart-summary"> -->
<!-- 					<div class="dash-summary-item"> -->
<!-- 						<span class="dash-summary-label">이번 주 준수율</span> <strong -->
<%-- 							class="dash-summary-value dash-black-text"> <fmt:formatNumber --%>
<%-- 								value="${dashDeliveryWeekRate}" pattern="#,##0.0" />% --%>
<!-- 						</strong> -->
<!-- 					</div> -->

<!-- 					<div class="dash-summary-item"> -->
<!-- 						<span class="dash-summary-label">목표 대비</span> <strong -->
<%-- 							class="dash-summary-value ${dashDeliveryTargetCompareClass}"> --%>
<%-- 							${dashDeliveryTargetCompareArrow} <fmt:formatNumber --%>
<%-- 								value="${dashDeliveryTargetCompareRate}" pattern="#,##0.0" />% --%>
<!-- 						</strong> -->
<!-- 					</div> -->

<!-- 					<div class="dash-summary-item"> -->
<!-- 						<span class="dash-summary-label">지연 작업지시</span> <strong -->
<%-- 							class="dash-summary-value dash-red-text"> <fmt:formatNumber --%>
<%-- 								value="${dashKpiDelayOrderCount}" pattern="#,##0" />건 --%>
<!-- 						</strong> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</article> -->

			<article class="dash-card dash-facility-card">
				<div class="dash-card-head">
					<h3>설비 가동 현황</h3>

					<div class="dash-card-head-right dash-facility-head-right">
						<div class="dash-facility-head-meta">
							<span class="dash-unit-text">단위: %</span> <span
								class="dash-total-text"> 전체 <fmt:formatNumber
									value="${dashFacilityTotalCount}" pattern="#,##0" />대
							</span>
						</div>

						<div class="dash-facility-toggle" aria-label="설비 가동 차트 표시 선택">
							<button type="button" class="dash-facility-toggle-btn is-active"
								data-facility-index="0">
								<i class="dash-facility-toggle-dot dash-facility-toggle-green"></i>
								가동
							</button>

							<button type="button" class="dash-facility-toggle-btn is-active"
								data-facility-index="1">
								<i class="dash-facility-toggle-dot dash-facility-toggle-gray"></i>
								비가동
							</button>
						</div>
					</div>
				</div>

				<div class="dash-facility-body">
					<div class="dash-facility-chart">
						<canvas id="facilityChart"></canvas>

						<div class="dash-facility-center">
							<strong> <fmt:formatNumber
									value="${dashFacilityRunRate}" pattern="#,##0.0" />%
							</strong> <span>가동률</span>
						</div>
					</div>

					<ul class="dash-facility-list">
						<li><i class="dash-legend-dot dash-legend-green"></i> <span>가동</span>
							<div class="dash-facility-meta">
								<strong> <fmt:formatNumber
										value="${dashFacilityRunningCount}" pattern="#,##0" />대
								</strong> <em class="dash-green-text"> <fmt:formatNumber
										value="${dashFacilityRunRate}" pattern="#,##0.0" />%
								</em>
							</div></li>

						<li><i class="dash-legend-dot dash-legend-orange"></i> <span>점검/대기</span>
							<div class="dash-facility-meta">
								<strong> <fmt:formatNumber
										value="${dashFacilityCheckCount}" pattern="#,##0" />대
								</strong> <em class="dash-orange-text"> <fmt:formatNumber
										value="${dashFacilityCheckRate}" pattern="#,##0.0" />%
								</em>
							</div></li>

						<li><i class="dash-legend-dot dash-legend-red"></i> <span>비가동/정지</span>
							<div class="dash-facility-meta">
								<strong> <fmt:formatNumber
										value="${dashFacilityStopCount}" pattern="#,##0" />대
								</strong> <em class="dash-red-text"> <fmt:formatNumber
										value="${dashFacilityStopRate}" pattern="#,##0.0" />%
								</em>
							</div></li>
					</ul>
				</div>

				<div class="dash-chart-summary dash-chart-summary-neutral">
					<div class="dash-summary-item">
						<span class="dash-summary-label">가동률 목표</span> <strong
							class="dash-summary-value"> <fmt:formatNumber
								value="${dashFacilityTargetRate}" pattern="#,##0.0" />%
						</strong>
					</div>

					<div class="dash-summary-item">
						<span class="dash-summary-label">목표 대비</span> <strong
							class="dash-summary-value ${dashFacilityTargetClass}">
							${dashFacilityTargetArrow} <fmt:formatNumber
								value="${dashFacilityTargetGap}" pattern="#,##0.0" />%p
						</strong>
					</div>

					<div class="dash-summary-item">
						<span class="dash-summary-label">비가동률</span> <strong
							class="dash-summary-value dash-orange-text"> <fmt:formatNumber
								value="${dashFacilityNonRunRate}" pattern="#,##0.0" />%
						</strong>
					</div>
				</div>
			</article>
		</div>

	</section>

	<%-- MES 운영 흐름 영역이다. --%>
	<section class="dash-flow-card">

		<%-- MES 운영 흐름 제목 영역이다. --%>
		<div class="dash-flow-panel-head">
			<h3>MES 운영 흐름도</h3>
		</div>

		<%-- MES 운영 흐름 부모 테이블이다. --%>
		<table class="dash-flow-inner-table">
			<tbody>
				<tr>
					<td>
						<div class="dash-flow-scroll">
							<div class="dash-flow-list">

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M3 7L12 2L21 7L12 12L3 7Z"></path>
											<path d="M3 17L12 22L21 17"></path>
											<path d="M3 12L12 17L21 12"></path>
										</svg>
									</span> 자재입고
								</div>

								<em>›</em>

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/production/productionplan'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M8 2V5"></path>
											<path d="M16 2V5"></path>
											<rect x="4" y="4" width="16" height="17" rx="2"></rect>
											<path d="M8 11H16"></path>
											<path d="M8 15H13"></path>
										</svg>
									</span> 생산계획
								</div>

								<em>›</em>

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/production/workorder'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M8 6H21"></path>
											<path d="M8 12H21"></path>
											<path d="M8 18H21"></path>
											<path d="M3 6H3.01"></path>
											<path d="M3 12H3.01"></path>
											<path d="M3 18H3.01"></path>
										</svg>
									</span> 작업지시
								</div>

								<em>›</em>

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/production/processprogress'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<circle cx="12" cy="12" r="3"></circle>
											<path
												d="M19.4 15A1.65 1.65 0 0 0 20 13.8A1.65 1.65 0 0 0 19.4 12.6L17.9 11.4A6.5 6.5 0 0 0 17.2 9.7L17.8 7.8A1.65 1.65 0 0 0 17 5.9A1.65 1.65 0 0 0 15 6.1L13.5 7.2A6.5 6.5 0 0 0 10.5 7.2L9 6.1A1.65 1.65 0 0 0 7 5.9A1.65 1.65 0 0 0 6.2 7.8L6.8 9.7A6.5 6.5 0 0 0 6.1 11.4L4.6 12.6A1.65 1.65 0 0 0 4 13.8A1.65 1.65 0 0 0 4.6 15L6.1 16.2A6.5 6.5 0 0 0 6.8 17.9L6.2 19.8A1.65 1.65 0 0 0 7 21.7A1.65 1.65 0 0 0 9 21.5L10.5 20.4A6.5 6.5 0 0 0 13.5 20.4L15 21.5A1.65 1.65 0 0 0 17 21.7A1.65 1.65 0 0 0 17.8 19.8L17.2 17.9A6.5 6.5 0 0 0 17.9 16.2Z"></path>
										</svg>
									</span> 공정진행
								</div>

								<em>›</em>

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/production/productionresult'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M4 19V5"></path>
											<path d="M4 19H20"></path>
											<path d="M8 16V11"></path>
											<path d="M12 16V8"></path>
											<path d="M16 16V13"></path>
										</svg>
									</span> 생산실적
								</div>

								<em>›</em>

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
											<path d="M9 12L11 14L15 10"></path>
										</svg>
									</span> 품질검사
								</div>

								<em>›</em>

								<div class="dash-flow-step"
									onclick="location.href='${pageContext.request.contextPath}/inventory/inventoryStatus'">
									<span> <svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M3 7H16V17H3Z"></path>
											<path d="M16 10H20L22 13V17H16Z"></path>
											<circle cx="7" cy="19" r="2"></circle>
											<circle cx="18" cy="19" r="2"></circle>
										</svg>
									</span> 출하
								</div>

							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</section>

	<%-- 하단 현황 영역이다. --%>
	<section class="dash-bottom-grid">

		<article class="dash-card dash-bottom-card dash-defect-top5">
			<div class="dash-card-head">
				<h3>불량 TOP5</h3>
				<a href="${pageContext.request.contextPath}/quality/defect"
					class="dash-more-link">더보기</a>
			</div>

			<table class="dash-simple-table">
				<thead>
					<tr>
						<th>순위</th>
						<th>불량유형</th>
						<th>건수</th>
						<th>퍼센트</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>
						<c:when test="${empty dashDefectTopList}">
							<tr>
								<td colspan="4">최근 7일 불량 데이터가 없습니다.</td>
							</tr>
						</c:when>

						<c:otherwise>
							<c:forEach var="defect" items="${dashDefectTopList}"
								varStatus="status">
								<tr>
									<td>${status.count}</td>

									<td><c:choose>
											<c:when test="${empty defect.defect_type}">
										-
									</c:when>
											<c:otherwise>
												<c:out value="${defect.defect_type}" />
											</c:otherwise>
										</c:choose></td>

									<td><fmt:formatNumber value="${defect.defect_qty}"
											pattern="#,##0" /></td>

									<td><fmt:formatNumber value="${defect.sort_no}"
											pattern="#,##0" />%</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</article>

		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3>최근 작업지시</h3>
				<a href="${pageContext.request.contextPath}/production/workorder"
					class="dash-more-link">더보기</a>
			</div>

			<table class="dash-simple-table">
				<thead>
					<tr>
						<th>작업지시</th>
						<th>품목</th>
						<th>수량</th>
						<th>상태</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>
						<c:when test="${empty dashWorkOrderList}">
							<tr>
								<td colspan="4">최근 작업지시 데이터가 없습니다.</td>
							</tr>
						</c:when>

						<c:otherwise>
							<c:forEach var="workOrder" items="${dashWorkOrderList}">
								<tr>
									<td title="${workOrder.docNo}"><c:choose>
											<c:when test="${empty workOrder.docNo}">
										-
									</c:when>
											<c:otherwise>
												<c:out value="${workOrder.docNo}" />
											</c:otherwise>
										</c:choose></td>

									<td title="${workOrder.itemName}"><c:choose>
											<c:when test="${empty workOrder.itemName}">
										-
									</c:when>
											<c:otherwise>
												<c:out value="${workOrder.itemName}" />
											</c:otherwise>
										</c:choose></td>

									<td><fmt:formatNumber value="${workOrder.orderQty}"
											pattern="#,##0" /> ${workOrder.itemUnit}</td>

									<td><c:choose>
											<c:when test="${workOrder.prodStatus eq '완료'}">
												<span class="coStatus coStatusUse">
													${workOrder.prodStatus} </span>
											</c:when>

											<c:when
												test="${workOrder.prodStatus eq '취소' or workOrder.prodStatus eq '보류'}">
												<span class="coStatus coStatusStop">
													${workOrder.prodStatus} </span>
											</c:when>

											<c:otherwise>
												<span class="coStatus"> <c:choose>
														<c:when test="${empty workOrder.prodStatus}">
													대기
												</c:when>
														<c:otherwise>
													${workOrder.prodStatus}
												</c:otherwise>
													</c:choose>
												</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</article>
		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3>
					<a href="${pageContext.request.contextPath}/board/notice">공지사항</a>
				</h3>
				<a href="${pageContext.request.contextPath}/board/notice"
					class="dash-more-link">더보기</a>
			</div>

			<ul class="dash-notice-list">
				<c:choose>
					<c:when test="${empty dashNoticeList}">
						<li><a href="${pageContext.request.contextPath}/board/notice">
								<span>등록된 공지사항이 없습니다.</span> <em>-</em>
						</a></li>
					</c:when>

					<c:otherwise>
						<c:forEach var="notice" items="${dashNoticeList}">
							<li><a
								href="${pageContext.request.contextPath}/board/notice"> <span><c:out
											value="${notice.title}" /></span> <em><c:out
											value="${notice.created_date}" /></em>
							</a></li>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</ul>
		</article>

	</section>

</section>

<%-- Chart.js 그래프 라이브러리이다. --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
	// 대시보드 기준시간과 차트를 생성한다.
	document.addEventListener("DOMContentLoaded", function() {

		// 데이터 기준시간을 저장한다.
		const dashAccessTime = new Date();

		// 현재 표시 중인 기준시간을 저장한다.
		let dashBaseTime = new Date(dashAccessTime);

		// 기준시간 표시 요소를 찾는다.
		const dashTimeText = document.getElementById("dashCurrentTime");

		// 기준상태 표시 요소를 찾는다.
		const dashTimeStatus = document.getElementById("dashTimeStatus");

		// 기준시간 갱신 버튼을 찾는다.
		const dashTimeRefreshBtn = document.getElementById("dashTimeRefreshBtn");

		// 숫자를 두 자리로 만든다.
		function dashAddZero(value) {
			return String(value).padStart(2, "0");
		}

		// 기준시간 표시 형식을 만든다.
		function dashFormatTime(dateValue) {
			const weekText = [ "일", "월", "화", "수", "목", "금", "토" ];
			const year = dateValue.getFullYear();
			const month = dashAddZero(dateValue.getMonth() + 1);
			const date = dashAddZero(dateValue.getDate());
			const day = weekText[dateValue.getDay()];
			const hour = dashAddZero(dateValue.getHours());
			const minute = dashAddZero(dateValue.getMinutes());
			const second = dashAddZero(dateValue.getSeconds());

			return year + "-" + month + "-" + date + " (" + day + ") "
					+ hour + ":" + minute + ":" + second;
		}

		// 기준시간을 화면에 출력한다.
		function dashRenderBaseTime() {
			if (dashTimeText == null) {
				return;
			}

			dashTimeText.textContent = dashFormatTime(dashBaseTime);
		}

		// 기준상태 문구를 변경한다.
		function dashChangeTimeStatus(statusText) {
			if (dashTimeStatus == null) {
				return;
			}

			dashTimeStatus.innerHTML = '<span class="dash-time-status-dot"></span>' + statusText;
		}

		// 기준시간 갱신 버튼 이벤트이다.
		if (dashTimeRefreshBtn != null) {
			dashTimeRefreshBtn.addEventListener("click", function() {
				dashBaseTime = new Date();

				dashRenderBaseTime();
				dashChangeTimeStatus("갱신시점 기준");

				// 이후 DB 연동 시 이 위치에서 KPI, 알림, LOT 데이터를 다시 조회하면 된다.
				// 예: loadDashboardData(dashBaseTime);
			});
		}

		// 처음 접속 시 접속시점 기준으로 출력한다.
		dashRenderBaseTime();
		dashChangeTimeStatus("접속시점 기준");

		// Chart.js가 없으면 차트 생성만 중단한다.
		if (typeof Chart === "undefined") {
			return;
		}

		// 차트 색상값이다.
		const chartGreen = "#1F7A57";
		const chartGreenSoft = "rgba(31, 122, 87, 0.18)";
		const chartGreenSoftEnd = "rgba(31, 122, 87, 0.02)";
		const chartRed = "#EF4444";
		const chartRedSoft = "rgba(239, 68, 68, 0.18)";
		const chartRedSoftEnd = "rgba(239, 68, 68, 0.02)";
		const chartGray = "#A8B2C1";
		const chartGrid = "rgba(148, 163, 184, 0.20)";
		const chartText = "#111827";

		// Chart.js 기본 글꼴 설정이다.
		if (Chart.defaults.font != null) {
			Chart.defaults.font.family = "'Pretendard', 'Noto Sans KR', Arial, sans-serif";
		}

		// Chart.js 기본 글자 색상 설정이다.
		if (Chart.defaults.color != null) {
			Chart.defaults.color = chartText;
		}

		// 공통 라벨이다.
		const labels = [ "05/22", "05/23", "05/24", "05/25", "05/26", "05/27", "05/28" ];

		// 생산실적 추이 DB 데이터이다.
		const productionLabels = [
			<c:forEach var="row" items="${dashProductionTrendList}" varStatus="status">
				"${row.LABEL}"<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		const productionPlanData = [
			<c:forEach var="row" items="${dashProductionTrendList}" varStatus="status">
				${row.PLANQTY}<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		const productionResultData = [
			<c:forEach var="row" items="${dashProductionTrendList}" varStatus="status">
				${row.PRODQTY}<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		// 생산실적 추이 Y축 최대값을 DB 데이터 기준으로 계산한다.
		const productionMaxValue = Math.max(
			...productionPlanData,
			...productionResultData,
			0
		);

		const productionYAxisMax = productionMaxValue <= 0
			? 1000
			: Math.ceil((productionMaxValue * 1.2) / 1000) * 1000;

		const productionYAxisStep = productionYAxisMax <= 5000
			? 1000
			: Math.ceil((productionYAxisMax / 5) / 1000) * 1000;

		// 불량 추이 DB 데이터이다.
		const defectLabels = [
			<c:forEach var="row" items="${dashDefectTrendList}" varStatus="status">
				"${row.LABEL}"<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		const defectRateData = [
			<c:forEach var="row" items="${dashDefectTrendList}" varStatus="status">
				${row.DEFECTRATE}<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		const defectQtyData = [
			<c:forEach var="row" items="${dashDefectTrendList}" varStatus="status">
				${row.DEFECTQTY}<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		// 불량 추이 Y축 최대값을 DB 데이터 기준으로 계산한다.
		const defectMaxValue = Math.max(...defectRateData, 0);

		const defectYAxisMax = defectMaxValue <= 0
			? 5
			: Math.ceil(defectMaxValue * 1.3);

		const defectYAxisStep = defectYAxisMax <= 5
			? 1
			: Math.ceil(defectYAxisMax / 5);

		// 납기 준수율 추이 DB 데이터이다.
		const deliveryLabels = [
			<c:forEach var="row" items="${dashDeliveryTrendList}" varStatus="status">
				"${row.LABEL}"<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		const deliveryRateData = [
			<c:forEach var="row" items="${dashDeliveryTrendList}" varStatus="status">
				<c:choose>
					<c:when test="${empty row.DELIVERYRATE}">null</c:when>
					<c:otherwise>${row.DELIVERYRATE}</c:otherwise>
				</c:choose><c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		const deliveryTargetData = [
			<c:forEach var="row" items="${dashDeliveryTrendList}" varStatus="status">
				<c:choose>
					<c:when test="${empty row.TARGETRATE}">95</c:when>
					<c:otherwise>${row.TARGETRATE}</c:otherwise>
				</c:choose><c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		// 납기 준수율 Y축 기준값이다.
		const deliveryYAxisMax = 100;
		const deliveryYAxisStep = 20;

		// 숫자 포맷터이다.
		const dashNumberFormatter = new Intl.NumberFormat("ko-KR");

		// 숫자에 콤마를 붙인다.
		function dashFormatNumber(value) {
			return dashNumberFormatter.format(value);
		}

		// 라인 차트용 그라데이션이다.
		function dashCreateLineGradient(chart, startColor, endColor) {
			if (chart == null || chart.ctx == null || chart.chartArea == null) {
				return startColor;
			}

			const ctx = chart.ctx;
			const chartArea = chart.chartArea;
			const gradient = ctx.createLinearGradient(0, chartArea.top, 0, chartArea.bottom);

			gradient.addColorStop(0, startColor);
			gradient.addColorStop(1, endColor);

			return gradient;
		}

		// 막대 차트용 그라데이션이다.
		function dashCreateBarGradient(chart) {
			if (chart == null || chart.ctx == null || chart.chartArea == null) {
				return "rgba(31, 122, 87, 0.28)";
			}

			const ctx = chart.ctx;
			const chartArea = chart.chartArea;
			const gradient = ctx.createLinearGradient(0, chartArea.top, 0, chartArea.bottom);

			gradient.addColorStop(0, "rgba(31, 122, 87, 0.60)");
			gradient.addColorStop(1, "rgba(31, 122, 87, 0.10)");

			return gradient;
		}

		// 둥근 사각형을 그린다.
		function dashDrawRoundRect(ctx, x, y, width, height, radius) {
			ctx.beginPath();
			ctx.moveTo(x + radius, y);
			ctx.lineTo(x + width - radius, y);
			ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
			ctx.lineTo(x + width, y + height - radius);
			ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
			ctx.lineTo(x + radius, y + height);
			ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
			ctx.lineTo(x, y + radius);
			ctx.quadraticCurveTo(x, y, x + radius, y);
			ctx.closePath();
		}

		// 차트 요소의 좌표를 안전하게 가져온다.
		function dashGetChartElementPosition(element) {
			if (element == null) {
				return null;
			}

			if (typeof element.getProps === "function") {
				const props = element.getProps([ "x", "y" ], true);

				if (props != null && props.x != null && props.y != null) {
					return {
						x : props.x,
						y : props.y
					};
				}
			}

			if (element.x != null && element.y != null) {
				return {
					x : element.x,
					y : element.y
				};
			}

			if (element._model != null && element._model.x != null && element._model.y != null) {
				return {
					x : element._model.x,
					y : element._model.y
				};
			}

			if (typeof element.tooltipPosition === "function") {
				const tooltipPosition = element.tooltipPosition();

				if (tooltipPosition != null && tooltipPosition.x != null && tooltipPosition.y != null) {
					return {
						x : tooltipPosition.x,
						y : tooltipPosition.y
					};
				}
			}

			return null;
		}

		// 마지막 값 배지를 그리는 플러그인이다.
		const dashValueBadgePlugin = {
			id : "dashValueBadge",
			afterDatasetsDraw : function(chart) {
				try {
					if (chart == null || chart.options == null || chart.options.plugins == null) {
						return;
					}

					const badgeOption = chart.options.plugins.dashValueBadge;

					if (badgeOption == null || badgeOption.display === false) {
						return;
					}

					const datasetIndex = badgeOption.datasetIndex != null ? badgeOption.datasetIndex : 0;
					const meta = chart.getDatasetMeta(datasetIndex);

					if (meta == null || meta.hidden === true || meta.data == null || meta.data.length === 0) {
						return;
					}

					const dataIndex = badgeOption.dataIndex != null ? badgeOption.dataIndex : meta.data.length - 1;
					const element = meta.data[dataIndex];
					const pointPosition = dashGetChartElementPosition(element);

					if (pointPosition == null) {
						return;
					}

					const chartArea = chart.chartArea;

					if (chartArea == null) {
						return;
					}

					const dataset = chart.data.datasets[datasetIndex];
					const rawValue = dataset.data[dataIndex];
					const labelText = typeof badgeOption.formatter === "function"
							? badgeOption.formatter(rawValue)
							: String(rawValue);

					const ctx = chart.ctx;
					const offsetX = badgeOption.offsetX != null ? badgeOption.offsetX : 12;
					const offsetY = badgeOption.offsetY != null ? badgeOption.offsetY : -18;
					const paddingX = 12;
					const badgeHeight = 30;
					const radius = 8;

					ctx.save();
					ctx.font = "900 13px Pretendard, 'Noto Sans KR', Arial, sans-serif";

					const textWidth = ctx.measureText(labelText).width;
					const badgeWidth = textWidth + paddingX * 2;

					let badgeX = pointPosition.x + offsetX;
					let badgeY = pointPosition.y + offsetY - badgeHeight / 2;

					if (badgeX + badgeWidth > chartArea.right - 2) {
						badgeX = chartArea.right - badgeWidth - 2;
					}

					if (badgeX < chartArea.left + 2) {
						badgeX = chartArea.left + 2;
					}

					if (badgeY < chartArea.top + 4) {
						badgeY = chartArea.top + 4;
					}

					if (badgeY + badgeHeight > chartArea.bottom - 4) {
						badgeY = chartArea.bottom - badgeHeight - 4;
					}

					ctx.fillStyle = badgeOption.backgroundColor || chartGreen;
					dashDrawRoundRect(ctx, badgeX, badgeY, badgeWidth, badgeHeight, radius);
					ctx.fill();

					ctx.fillStyle = badgeOption.textColor || "#FFFFFF";
					ctx.textAlign = "center";
					ctx.textBaseline = "middle";
					ctx.fillText(labelText, badgeX + badgeWidth / 2, badgeY + badgeHeight / 2 + 1);

					ctx.restore();
				} catch (error) {
					console.warn("차트 배지 표시 중 오류가 발생했습니다.", error);
				}
			}
		};

		// 범례 공통 옵션이다.
		function dashCreateLegendOption() {
			return {
				display : true,
				position : "top",
				align : "end",
				labels : {
					usePointStyle : true,
					pointStyle : "circle",
					boxWidth : 8,
					boxHeight : 8,
					padding : 14,
					color : chartText,
					font : {
						size : 12,
						weight : "800"
					}
				}
			};
		}

		// 툴팁 공통 옵션이다.
		function dashCreateTooltipOption(formatter) {
			return {
				backgroundColor : "rgba(17, 24, 39, 0.92)",
				padding : 10,
				titleFont : {
					size : 12,
					weight : "800"
				},
				bodyFont : {
					size : 12,
					weight : "700"
				},
				callbacks : {
					label : function(context) {
						const value = context.raw;
						return context.dataset.label + ": " + formatter(value);
					}
				}
			};
		}

		// 라인 차트 공통 옵션이다.
		function dashCreateLineOption(yMax, stepSize, tickFormatter, tooltipFormatter) {
			return {
				responsive : true,
				maintainAspectRatio : false,
				interaction : {
					mode : "index",
					intersect : false
				},
				layout : {
					padding : {
						top : 10,
						right : 12,
						left : 0,
						bottom : 0
					}
				},
				plugins : {
					legend : dashCreateLegendOption(),
					tooltip : dashCreateTooltipOption(tooltipFormatter)
				},
				scales : {
					x : {
						grid : {
							display : false
						},
						ticks : {
							font : {
								size : 11,
								weight : "800"
							}
						},
						border : {
							display : false
						}
					},
					y : {
						beginAtZero : true,
						suggestedMax : yMax,
						ticks : {
							stepSize : stepSize,
							font : {
								size : 11,
								weight : "800"
							},
							callback : tickFormatter
						},
						grid : {
							color : chartGrid,
							drawTicks : false
						},
						border : {
							display : false
						}
					}
				}
			};
		}

		// 차트를 안전하게 생성한다.
		function dashCreateChart(chartName, canvas, config) {
			if (canvas == null) {
				return;
			}

			try {
				new Chart(canvas, config);
			} catch (error) {
				console.error(chartName + " 생성 중 오류가 발생했습니다.", error);
			}
		}

		// 생산실적 추이 차트이다.
		const productionCanvas = document.getElementById("productionChart");

		if (productionCanvas != null) {
			const productionOption = dashCreateLineOption(
					productionYAxisMax,
					productionYAxisStep,
					function(value) {
						return dashFormatNumber(value);
					},
					function(value) {
						return dashFormatNumber(value) + " EA";
					}
			);

			productionOption.plugins.dashValueBadge = {
				display : true,
				datasetIndex : 1,
				formatter : function(value) {
					return dashFormatNumber(value);
				},
				backgroundColor : "#16A34A",
				textColor : "#FFFFFF",
				offsetX : 10,
				offsetY : -12
			};

			// 생산실적 그래프 클릭 시 생산 리포트로 이동한다.
			productionOption.onClick = function() {
				location.href = "${pageContext.request.contextPath}/report/productionreport";
			};

			// 생산실적 그래프에 마우스를 올리면 클릭 가능하게 보여준다.
			productionOption.onHover = function(event) {
				const target = event.native != null ? event.native.target : event.target;

				if (target != null) {
					target.style.cursor = "pointer";
				}
			};

			dashCreateChart("생산실적 추이 차트", productionCanvas, {
				type : "line",
				plugins : [ dashValueBadgePlugin ],
				data : {
					labels : productionLabels,
					datasets : [
						{
							label : "계획",
							data : productionPlanData,
							borderColor : chartGray,
							borderWidth : 2,
							borderDash : [ 6, 6 ],
							pointRadius : 0,
							pointHoverRadius : 0,
							fill : false,
							tension : 0.38
						},
						{
							label : "실적",
							data : productionResultData,
							borderColor : chartGreen,
							backgroundColor : function(context) {
								return dashCreateLineGradient(context.chart, chartGreenSoft, chartGreenSoftEnd);
							},
							fill : true,
							borderWidth : 3,
							pointRadius : 5,
							pointHoverRadius : 6,
							pointBackgroundColor : "#FFFFFF",
							pointBorderColor : chartGreen,
							pointBorderWidth : 3,
							tension : 0.38
						}
					]
				},
				options : productionOption
			});
		}

		// 불량 추이 차트이다.
		const defectCanvas = document.getElementById("defectChart");

		if (defectCanvas != null) {
			const defectOption = dashCreateLineOption(
					defectYAxisMax,
					defectYAxisStep,
					function(value) {
						return value === 0 ? "0" : Number(value).toFixed(1);
					},
					function(value) {
						return Number(value).toFixed(1) + "%";
					}
			);

			defectOption.plugins.dashValueBadge = {
				display : true,
				datasetIndex : 0,
				formatter : function(value) {
					return Number(value).toFixed(1) + "%";
				},
				backgroundColor : "#FF4D5A",
				textColor : "#FFFFFF",
				offsetX : 10,
				offsetY : -12
			};

			// 불량 추이 그래프 클릭 시 품질 리포트로 이동한다.
			defectOption.onClick = function() {
				location.href = "${pageContext.request.contextPath}/report/chart";
			};

			// 불량 추이 그래프에 마우스를 올리면 클릭 가능하게 보여준다.
			defectOption.onHover = function(event) {
				const target = event.native != null ? event.native.target : event.target;

				if (target != null) {
					target.style.cursor = "pointer";
				}
			};

			dashCreateChart("불량 추이 차트", defectCanvas, {
				type : "line",
				plugins : [ dashValueBadgePlugin ],
				data : {
					labels : defectLabels,
					datasets : [
						{
							label : "불량률",
							data : defectRateData,
							borderColor : chartRed,
							backgroundColor : function(context) {
								return dashCreateLineGradient(context.chart, chartRedSoft, chartRedSoftEnd);
							},
							fill : true,
							borderWidth : 3,
							pointRadius : 5,
							pointHoverRadius : 6,
							pointBackgroundColor : "#FFFFFF",
							pointBorderColor : chartRed,
							pointBorderWidth : 3,
							tension : 0.38
						}
					]
				},
				options : defectOption
			});
		}

		// 납기 준수율 추이 차트이다.
		const deliveryCanvas = document.getElementById("deliveryChart");

		if (deliveryCanvas != null) {
			const deliveryOption = dashCreateLineOption(
					deliveryYAxisMax,
					deliveryYAxisStep,
					function(value) {
						return dashFormatNumber(value) + "%";
					},
					function(value) {
						return dashFormatNumber(value) + "%";
					}
			);

			deliveryOption.plugins.dashValueBadge = {
				display : true,
				datasetIndex : 0,
				formatter : function(value) {
					return dashFormatNumber(value) + "%";
				},
				backgroundColor : "#16A34A",
				textColor : "#FFFFFF",
				offsetX : 10,
				offsetY : -26
			};

			// 납기 준수율 막대에 마우스를 올리면 포인터로 보여준다.
			deliveryOption.onHover = function(event, elements) {
				const target = event.native != null ? event.native.target : event.target;

				if (target == null) {
					return;
				}

				target.style.cursor = elements != null && elements.length > 0 ? "pointer" : "default";
			};

			// 납기 준수율 그래프 클릭 시 작업지시 화면으로 이동한다.
			deliveryOption.onClick = function() {
				location.href = "${pageContext.request.contextPath}/production/workorder";
			};

			dashCreateChart("납기 준수율 추이 차트", deliveryCanvas, {
				type : "bar",
				plugins : [ dashValueBadgePlugin ],
				data : {
					labels : deliveryLabels,
					datasets : [
						{
							type : "bar",
							label : "납기 준수율",
							data : deliveryRateData,
							backgroundColor : function(context) {
								if (context.active) {
									return "#1F7A57";
								}

								return dashCreateBarGradient(context.chart);
							},
							borderColor : function(context) {
								if (context.active) {
									return "#166243";
								}

								return "rgba(31, 122, 87, 0.16)";
							},
							borderWidth : function(context) {
								return context.active ? 2 : 0;
							},
							borderRadius : 10,
							borderSkipped : false,
							barPercentage : 0.62,
							categoryPercentage : 0.7
						},
						{
							type : "line",
							label : "목표 준수율",
							data : deliveryTargetData,
							borderColor : chartGray,
							borderWidth : 2,
							borderDash : [ 6, 6 ],
							pointRadius : 0,
							pointHoverRadius : 0,
							fill : false,
							tension : 0
						}
					]
				},
				options : deliveryOption
			});
		}

		// 설비 게이지 끝 포인트를 그리는 플러그인이다.
		const dashFacilityGaugePointPlugin = {
			id : "dashFacilityGaugePoint",
			afterDatasetsDraw : function(chart) {
				try {
					const meta = chart.getDatasetMeta(0);

					if (meta == null || meta.data == null || meta.data.length === 0) {
						return;
					}

					// 가동 항목이 숨겨져 있으면 동그라미도 숨긴다.
					if (typeof chart.getDataVisibility === "function" && !chart.getDataVisibility(0)) {
						return;
					}

					const activeArc = meta.data[0];

					if (activeArc == null) {
						return;
					}

					// true를 쓰면 최종 위치 기준이라 동그라미가 따로 움직인다.
					// false를 써야 현재 애니메이션 위치 기준으로 그래프와 같이 움직인다.
					const arcProps = typeof activeArc.getProps === "function"
							? activeArc.getProps([ "x", "y", "innerRadius", "outerRadius", "endAngle" ], false)
							: activeArc;

					const centerX = arcProps.x;
					const centerY = arcProps.y;
					const innerRadius = arcProps.innerRadius;
					const outerRadius = arcProps.outerRadius;
					const endAngle = arcProps.endAngle;

					if (centerX == null || centerY == null || innerRadius == null || outerRadius == null || endAngle == null) {
						return;
					}

					const pointRadius = (innerRadius + outerRadius) / 2;
					const pointX = centerX + Math.cos(endAngle) * pointRadius;
					const pointY = centerY + Math.sin(endAngle) * pointRadius;
					const ctx = chart.ctx;

					ctx.save();
					ctx.beginPath();
					ctx.arc(pointX, pointY, 8, 0, Math.PI * 2);
					ctx.fillStyle = "#FFFFFF";
					ctx.fill();
					ctx.lineWidth = 3;
					ctx.strokeStyle = chartGreen;
					ctx.stroke();
					ctx.restore();
				} catch (error) {
					console.warn("설비 게이지 포인트 표시 중 오류가 발생했습니다.", error);
				}
			}
		};

		// 설비 가동 현황 차트이다.
		const facilityCanvas = document.getElementById("facilityChart");

		if (facilityCanvas != null) {
			const facilityChart = new Chart(facilityCanvas, {
				type : "doughnut",
				plugins : [ dashFacilityGaugePointPlugin ],
				data : {
					labels : [ "가동", "비가동" ],
					datasets : [
						{
							data : [
								Number("${dashFacilityRunRate}"),
								Number("${dashFacilityNonRunRate}")
							],
							backgroundColor : function(context) {
								const chart = context.chart;
								const chartArea = chart.chartArea;

								if (context.active) {
									return context.dataIndex === 0 ? "#1F7A57" : "#D1D5DB";
								}

								if (chartArea == null) {
									return context.dataIndex === 0 ? "rgba(31, 122, 87, 0.34)" : "rgba(229, 231, 235, 0.95)";
								}

								const gradient = chart.ctx.createLinearGradient(chartArea.left, chartArea.top, chartArea.right, chartArea.bottom);

								if (context.dataIndex === 0) {
									gradient.addColorStop(0, "rgba(31, 122, 87, 0.52)");
									gradient.addColorStop(0.55, "rgba(31, 122, 87, 0.34)");
									gradient.addColorStop(1, "rgba(31, 122, 87, 0.16)");

									return gradient;
								}

								gradient.addColorStop(0, "rgba(229, 231, 235, 0.98)");
								gradient.addColorStop(1, "rgba(229, 231, 235, 0.55)");

								return gradient;
							},
							hoverBackgroundColor : [ "#1F7A57", "#D1D5DB" ],
							hoverBorderColor : [ "#166243", "#C7CDD4" ],
							borderColor : "#FFFFFF",
							borderWidth : 2,
							hoverBorderWidth : 3,
							hoverOffset : 0
						}
					]
				},
				options : {
					responsive : true,
					maintainAspectRatio : false,
					cutout : "68%",
					rotation : -90,
					circumference : 180,

					// 설비 가동 현황에 마우스를 올리면 클릭 가능하게 보여준다.
					onHover : function(event) {
						const target = event.native != null ? event.native.target : event.target;

						if (target != null) {
							target.style.cursor = "pointer";
						}
					},

					// 설비 가동 현황 클릭 시 설비 가동 현황 페이지로 이동한다.
					onClick : function() {
						location.href = "${pageContext.request.contextPath}/equipment/equipmentstatus";
					},

					plugins : {
						legend : {
							display : false
						},
						tooltip : {
							backgroundColor : "rgba(17, 24, 39, 0.92)",
							padding : 10,
							titleFont : {
								size : 12,
								weight : "800"
							},
							bodyFont : {
								size : 12,
								weight : "700"
							},
							callbacks : {
								label : function(context) {
									return context.label + ": " + Number(context.raw).toFixed(1) + "%";
								}
							}
						}
					}
				}
			});

			// 설비 가동 현황 버튼을 클릭하면 차트 항목을 보이거나 숨긴다.
			document.querySelectorAll(".dash-facility-toggle-btn").forEach(function(button) {
				button.addEventListener("click", function() {
					const dataIndex = Number(button.getAttribute("data-facility-index"));

					if (Number.isNaN(dataIndex)) {
						return;
					}

					if (typeof facilityChart.toggleDataVisibility === "function") {
						facilityChart.toggleDataVisibility(dataIndex);
					} else {
						const meta = facilityChart.getDatasetMeta(0);

						if (meta != null && meta.data != null && meta.data[dataIndex] != null) {
							meta.data[dataIndex].hidden = !meta.data[dataIndex].hidden;
						}
					}

					button.classList.toggle("is-active");
					facilityChart.update();
				});
			});
		}
	});
	
	(function() {
		const contextPath = '${pageContext.request.contextPath}';

		const kpiCards = document.querySelectorAll('.dash-kpi-click');
		const modalBackdrop = document.getElementById('dashKpiModalBackdrop');
		const modalClose = document.getElementById('dashKpiModalClose');
		const modalCloseBottom = document.getElementById('dashKpiModalCloseBottom');
		const prevWeekBtn = document.getElementById('dashKpiPrevWeekBtn');
		const nextWeekBtn = document.getElementById('dashKpiNextWeekBtn');
		const weekDateInput = document.getElementById('dashKpiWeekDate');

		const modalTitle = document.getElementById('dashKpiModalTitle');
		const weekRange = document.getElementById('dashKpiWeekRange');
		const prevWeekRange = document.getElementById('dashKpiPrevWeekRange');
		const currentAvg = document.getElementById('dashKpiCurrentAvg');
		const prevAvg = document.getElementById('dashKpiPrevAvg');
		const compareAvg = document.getElementById('dashKpiCompareAvg');
		const compareAvgLabel = compareAvg ? compareAvg.previousElementSibling : null;
		const currentTableTitle = document.getElementById('dashKpiCurrentTableTitle');
		const prevTableTitle = document.getElementById('dashKpiPrevTableTitle');
		const currentTbody = document.getElementById('dashKpiCurrentTbody');
		const prevTbody = document.getElementById('dashKpiPrevTbody');
		const modalFootText = document.querySelector('.dash-kpi-modal-foot span');
		

		const currentTableHead = currentTbody.closest('table').querySelector('thead');
		const prevTableHead = prevTbody.closest('table').querySelector('thead');

		let currentBaseDate = getTodayText();
		let currentKpiType = 'achievement';

		const kpiConfig = {
				achievement: {
					title: '생산달성률 상세',
					currentLabel: '이번 주 평균 달성률',
					prevLabel: '전주 평균 달성률',
					goodIncrease: true,
					unitType: 'rate',
					head: ['날짜', '계획량', '실적량', '달성률'],
					footText: '계획량, 실적량, 달성률은 생산 일자 기준으로 집계된다.'
				},
				production: {
					title: '금일 생산량 상세',
					currentLabel: '이번 주 총 생산량',
					prevLabel: '전주 총 생산량',
					goodIncrease: true,
					unitType: 'qty',
					head: ['날짜', '생산량', '누적 생산량', '비고'],
					footText: '생산량은 생산실적 등록일 기준으로 집계된다.'
				},
				defect: {
					title: '불량률 상세',
					currentLabel: '이번 주 평균 불량률',
					prevLabel: '전주 평균 불량률',
					goodIncrease: false,
					unitType: 'rate',
					head: ['날짜', '검사수량', '불량수량', '불량률'],
					footText: '불량률은 불량수량을 검사수량으로 나눈 기준으로 계산된다.'
				},
				oee: {
					title: 'OEE 상세',
					currentLabel: '이번 주 평균 OEE',
					prevLabel: '전주 평균 OEE',
					goodIncrease: true,
					unitType: 'rate',
					head: ['날짜', '가동시간', '계획시간', 'OEE'],
					footText: 'OEE는 가동시간을 계획시간으로 나눈 기준으로 계산된다.'
				},
				delay: {
					title: '지연 작업지시 상세',
					currentLabel: '이번 주 지연건수',
					prevLabel: '전주 지연건수',
					goodIncrease: false,
					unitType: 'count',
					head: ['날짜', '지연건수', '지연수량', '비고'],
					footText: '지연 작업지시는 납기일이 지났고 생산이 완료되지 않은 작업지시 기준으로 집계된다.'
				}
			};

		kpiCards.forEach(function(card) {
			card.addEventListener('click', function() {
				currentKpiType = card.dataset.kpiType;
				currentBaseDate = getTodayText();

				if (weekDateInput) {
					weekDateInput.value = currentBaseDate;
				}

				openModal();
				loadKpiWeek(currentKpiType, currentBaseDate);
			});
		});

		if (modalClose) {
			modalClose.addEventListener('click', closeModal);
		}

		if (modalCloseBottom) {
			modalCloseBottom.addEventListener('click', closeModal);
		}

		if (modalBackdrop) {
			modalBackdrop.addEventListener('click', function(event) {
				if (event.target === modalBackdrop) {
					closeModal();
				}
			});
		}

		if (prevWeekBtn) {
			prevWeekBtn.addEventListener('click', function() {
				currentBaseDate = moveDate(currentBaseDate, -7);

				if (weekDateInput) {
					weekDateInput.value = currentBaseDate;
				}

				loadKpiWeek(currentKpiType, currentBaseDate);
			});
		}

		if (nextWeekBtn) {
			nextWeekBtn.addEventListener('click', function() {
				currentBaseDate = moveDate(currentBaseDate, 7);

				if (weekDateInput) {
					weekDateInput.value = currentBaseDate;
				}

				loadKpiWeek(currentKpiType, currentBaseDate);
			});
		}

		if (weekDateInput) {
			weekDateInput.addEventListener('change', function() {
				if (!weekDateInput.value) {
					return;
				}

				currentBaseDate = weekDateInput.value;
				loadKpiWeek(currentKpiType, currentBaseDate);
			});
		}

		function openModal() {
			modalBackdrop.classList.add('is-open');
		}

		function closeModal() {
			modalBackdrop.classList.remove('is-open');
		}

		function loadKpiWeek(kpiType, baseDate) {
			setLoading(kpiType);

			fetch(contextPath + '/dashboard/kpi/week-detail?kpiType='
					+ encodeURIComponent(kpiType)
					+ '&baseDate='
					+ encodeURIComponent(baseDate))
				.then(function(response) {
					return response.json();
				})
				.then(function(data) {
					if (!data || !data.success) {
						setError();
						return;
					}

					renderKpiWeek(kpiType, data.kpiWeekList || []);
				})
				.catch(function() {
					setError();
				});
		}

		function renderKpiWeek(kpiType, list) {
			const config = kpiConfig[kpiType];

			const currentList = list.filter(function(row) {
				return getValue(row, 'PERIOD_TYPE') === 'CURRENT';
			});

			const prevList = list.filter(function(row) {
				return getValue(row, 'PERIOD_TYPE') === 'PREV';
			});

			const currentSummary = getSummary(kpiType, currentList);
			const prevSummary = getSummary(kpiType, prevList);

			setHead(config.head);
			setWeekText(currentList, prevList);

			modalTitle.textContent = config.title;
			currentAvg.previousElementSibling.textContent = config.currentLabel;
			prevAvg.previousElementSibling.textContent = config.prevLabel;

			currentAvg.textContent = formatSummaryValue(kpiType, currentSummary.value);
			prevAvg.textContent = formatSummaryValue(kpiType, prevSummary.value);

			renderCompare(config, currentSummary.value, prevSummary.value);
			renderTable(kpiType, currentTbody, currentList, currentSummary);
			renderTable(kpiType, prevTbody, prevList, prevSummary);
		}

		function setHead(headList) {
			let html = '<tr>';

			headList.forEach(function(head) {
				html += '<th>' + head + '</th>';
			});

			html += '</tr>';

			currentTableHead.innerHTML = html;
			prevTableHead.innerHTML = html;
		}

		function setWeekText(currentList, prevList) {
			const currentStart = currentList.length > 0 ? getValue(currentList[0], 'WEEK_START') : '-';
			const currentEnd = currentList.length > 0 ? getValue(currentList[0], 'WEEK_END') : '-';
			const prevStart = prevList.length > 0 ? getValue(prevList[0], 'WEEK_START') : '-';
			const prevEnd = prevList.length > 0 ? getValue(prevList[0], 'WEEK_END') : '-';

			weekRange.textContent = currentStart + ' ~ ' + currentEnd;
			prevWeekRange.textContent = '비교 기간: ' + prevStart + ' ~ ' + prevEnd;

			currentTableTitle.textContent = '이번 주 (' + currentStart + ' ~ ' + currentEnd + ')';
			prevTableTitle.textContent = '전주 (' + prevStart + ' ~ ' + prevEnd + ')';
		}

		function getSummary(kpiType, rows) {
			if (kpiType === 'achievement') {
				return getAchievementSummary(rows);
			}

			if (kpiType === 'production') {
				return getProductionSummary(rows);
			}

			if (kpiType === 'defect') {
				return getDefectSummary(rows);
			}

			if (kpiType === 'cost') {
				return getCostSummary(rows);
			}

			if (kpiType === 'oee') {
				return getOeeSummary(rows);
			}

			if (kpiType === 'delay') {
				return getDelaySummary(rows);
			}

			return { value: 0 };
		}

		function getAchievementSummary(rows) {
			let planQty = 0;
			let actualQty = 0;

			rows.forEach(function(row) {
				planQty += Number(getValue(row, 'PLAN_QTY')) || 0;
				actualQty += Number(getValue(row, 'ACTUAL_QTY')) || 0;
			});

			const rate = planQty === 0 ? 0 : roundOne(actualQty / planQty * 100);

			return {
				planQty: planQty,
				actualQty: actualQty,
				value: rate
			};
		}

		function getProductionSummary(rows) {
			let prodQty = 0;

			rows.forEach(function(row) {
				prodQty += Number(getValue(row, 'PROD_QTY')) || 0;
			});

			return {
				prodQty: prodQty,
				value: prodQty
			};
		}

		function getDefectSummary(rows) {
			let inspectionQty = 0;
			let defectQty = 0;

			rows.forEach(function(row) {
				inspectionQty += Number(getValue(row, 'INSPECTION_QTY')) || 0;
				defectQty += Number(getValue(row, 'DEFECT_QTY')) || 0;
			});

			const rate = inspectionQty === 0 ? 0 : roundOne(defectQty / inspectionQty * 100);

			return {
				inspectionQty: inspectionQty,
				defectQty: defectQty,
				value: rate
			};
		}

		function getCostSummary(rows) {
			let actualTotal = 0;
			let actualCount = 0;
			let targetTotal = 0;
			let targetCount = 0;

			rows.forEach(function(row) {
				const actualCost = Number(getValue(row, 'ACTUAL_COST')) || 0;
				const targetCost = Number(getValue(row, 'TARGET_COST')) || 0;

				if (actualCost > 0) {
					actualTotal += actualCost;
					actualCount++;
				}

				if (targetCost > 0) {
					targetTotal += targetCost;
					targetCount++;
				}
			});

			const actualAvg = actualCount === 0 ? 0 : Math.round(actualTotal / actualCount);
			const targetAvg = targetCount === 0 ? 0 : Math.round(targetTotal / targetCount);

			return {
				actualCost: actualAvg,
				targetCost: targetAvg,
				value: actualAvg
			};
		}

		function getOeeSummary(rows) {
			let runtimeMin = 0;
			let planTimeMin = 0;

			rows.forEach(function(row) {
				runtimeMin += Number(getValue(row, 'RUNTIME_MIN')) || 0;
				planTimeMin += Number(getValue(row, 'PLAN_TIME_MIN')) || 0;
			});

			const rate = planTimeMin === 0 ? 0 : roundOne(runtimeMin / planTimeMin * 100);

			return {
				runtimeMin: runtimeMin,
				planTimeMin: planTimeMin,
				value: rate
			};
		}

		function getDelaySummary(rows) {
			let delayCount = 0;
			let delayQty = 0;

			rows.forEach(function(row) {
				delayCount += Number(getValue(row, 'DELAY_COUNT')) || 0;
				delayQty += Number(getValue(row, 'DELAY_QTY')) || 0;
			});

			return {
				delayCount: delayCount,
				delayQty: delayQty,
				value: delayCount
			};
		}

		function renderTable(kpiType, tbody, rows, summary) {
			if (!rows || rows.length === 0) {
				tbody.innerHTML = '<tr><td colspan="4">조회된 데이터가 없습니다.</td></tr>';
				return;
			}

			if (kpiType === 'achievement') {
				renderAchievementTable(tbody, rows, summary);
				return;
			}

			if (kpiType === 'production') {
				renderProductionTable(tbody, rows, summary);
				return;
			}

			if (kpiType === 'defect') {
				renderDefectTable(tbody, rows, summary);
				return;
			}

			if (kpiType === 'cost') {
				renderCostTable(tbody, rows, summary);
				return;
			}

			if (kpiType === 'oee') {
				renderOeeTable(tbody, rows, summary);
				return;
			}

			if (kpiType === 'delay') {
				renderDelayTable(tbody, rows, summary);
			}
		}

		function renderAchievementTable(tbody, rows, summary) {
			let html = '';

			rows.forEach(function(row) {
				html += '<tr>';
				html += '<td>' + getDateText(row) + '</td>';
				html += '<td>' + formatNumber(getValue(row, 'PLAN_QTY')) + ' EA</td>';
				html += '<td>' + formatNumber(getValue(row, 'ACTUAL_QTY')) + ' EA</td>';
				html += '<td class="dash-green-text">' + formatRate(getValue(row, 'ACHIEVEMENT_RATE')) + '</td>';
				html += '</tr>';
			});

			html += '<tr class="dash-kpi-total-row">';
			html += '<td>합계 / 평균</td>';
			html += '<td>' + formatNumber(summary.planQty) + ' EA</td>';
			html += '<td>' + formatNumber(summary.actualQty) + ' EA</td>';
			html += '<td>' + formatRate(summary.value) + '</td>';
			html += '</tr>';

			tbody.innerHTML = html;
		}

		function renderProductionTable(tbody, rows, summary) {
			let html = '';
			let accQty = 0;
			const accMap = {};

			rows.slice().reverse().forEach(function(row) {
				accQty += Number(getValue(row, 'PROD_QTY')) || 0;
				accMap[getValue(row, 'DISPLAY_DATE')] = accQty;
			});

			rows.forEach(function(row) {
				html += '<tr>';
				html += '<td>' + getDateText(row) + '</td>';
				html += '<td class="dash-green-text">' + formatNumber(getValue(row, 'PROD_QTY')) + ' EA</td>';
				html += '<td>' + formatNumber(accMap[getValue(row, 'DISPLAY_DATE')]) + ' EA</td>';
				html += '<td>-</td>';
				html += '</tr>';
			});

			html += '<tr class="dash-kpi-total-row">';
			html += '<td>합계</td>';
			html += '<td>' + formatNumber(summary.prodQty) + ' EA</td>';
			html += '<td>' + formatNumber(summary.prodQty) + ' EA</td>';
			html += '<td>-</td>';
			html += '</tr>';

			tbody.innerHTML = html;
		}

		function renderDefectTable(tbody, rows, summary) {
			let html = '';

			rows.forEach(function(row) {
				const inspectionQty = Number(getValue(row, 'INSPECTION_QTY')) || 0;
				const defectQty = Number(getValue(row, 'DEFECT_QTY')) || 0;
				const defectRate = Number(getValue(row, 'DEFECT_RATE')) || 0;

				let inspectionText = '-';
				let defectText = '-';
				let rateText = '-';

				if (inspectionQty > 0) {
					inspectionText = formatNumber(inspectionQty) + ' EA';
					defectText = formatNumber(defectQty) + ' EA';
					rateText = formatRate(defectRate);
				}

				html += '<tr>';
				html += '<td>' + getDateText(row) + '</td>';
				html += '<td>' + inspectionText + '</td>';
				html += '<td class="dash-red-text">' + defectText + '</td>';
				html += '<td class="dash-red-text">' + rateText + '</td>';
				html += '</tr>';
			});

			html += '<tr class="dash-kpi-total-row">';
			html += '<td>합계 / 평균</td>';
			html += '<td>' + formatNumber(summary.inspectionQty) + ' EA</td>';
			html += '<td>' + formatNumber(summary.defectQty) + ' EA</td>';

			if (summary.inspectionQty > 0) {
				html += '<td>' + formatRate(summary.value) + '</td>';
			} else {
				html += '<td>-</td>';
			}

			html += '</tr>';

			tbody.innerHTML = html;
		}
		
		function renderCostTable(tbody, rows, summary) {
			let html = '';

			rows.forEach(function(row) {
				const targetCost = Number(getValue(row, 'TARGET_COST')) || 0;
				const actualCost = Number(getValue(row, 'ACTUAL_COST')) || 0;
				const gap = actualCost - targetCost;

				let actualCostText = '-';
				let gapClass = 'dash-neutral-text';
				let gapText = '-';

				if (actualCost > 0) {
					actualCostText = formatNumber(actualCost) + ' 원/EA';

					if (gap > 0) {
						gapClass = 'dash-red-text';
						gapText = '▲ ' + formatNumber(Math.abs(gap)) + ' 원';
					} else if (gap < 0) {
						gapClass = 'dash-green-text';
						gapText = '▼ ' + formatNumber(Math.abs(gap)) + ' 원';
					}
				}

				html += '<tr>';
				html += '<td>' + getDateText(row) + '</td>';
				html += '<td>' + formatNumber(targetCost) + ' 원/EA</td>';
				html += '<td>' + actualCostText + '</td>';
				html += '<td class="' + gapClass + '">' + gapText + '</td>';
				html += '</tr>';
			});

			html += '<tr class="dash-kpi-total-row">';
			html += '<td>평균</td>';
			html += '<td>' + formatNumber(summary.targetCost) + ' 원/EA</td>';

			if (summary.actualCost > 0) {
				html += '<td>' + formatNumber(summary.actualCost) + ' 원/EA</td>';
			} else {
				html += '<td>-</td>';
			}

			html += '<td>-</td>';
			html += '</tr>';

			tbody.innerHTML = html;
		}

		function renderOeeTable(tbody, rows, summary) {
			let html = '';

			rows.forEach(function(row) {
				const runtimeMin = Number(getValue(row, 'RUNTIME_MIN')) || 0;
				const planTimeMin = Number(getValue(row, 'PLAN_TIME_MIN')) || 0;
				const oeeRate = Number(getValue(row, 'OEE_RATE')) || 0;

				let runtimeText = '-';
				let planTimeText = '-';
				let oeeText = '-';

				if (planTimeMin > 0) {
					runtimeText = formatNumber(runtimeMin) + '분';
					planTimeText = formatNumber(planTimeMin) + '분';
					oeeText = formatRate(oeeRate);
				}

				html += '<tr>';
				html += '<td>' + getDateText(row) + '</td>';
				html += '<td>' + runtimeText + '</td>';
				html += '<td>' + planTimeText + '</td>';
				html += '<td class="dash-green-text">' + oeeText + '</td>';
				html += '</tr>';
			});

			html += '<tr class="dash-kpi-total-row">';
			html += '<td>합계 / 평균</td>';
			html += '<td>' + formatNumber(summary.runtimeMin) + '분</td>';
			html += '<td>' + formatNumber(summary.planTimeMin) + '분</td>';

			if (summary.planTimeMin > 0) {
				html += '<td>' + formatRate(summary.value) + '</td>';
			} else {
				html += '<td>-</td>';
			}

			html += '</tr>';

			tbody.innerHTML = html;
		}

		function renderDelayTable(tbody, rows, summary) {
			let html = '';

			rows.forEach(function(row) {
				html += '<tr>';
				html += '<td>' + getDateText(row) + '</td>';
				html += '<td class="dash-orange-text">' + formatNumber(getValue(row, 'DELAY_COUNT')) + '건</td>';
				html += '<td>' + formatNumber(getValue(row, 'DELAY_QTY')) + ' EA</td>';
				html += '<td>-</td>';
				html += '</tr>';
			});

			html += '<tr class="dash-kpi-total-row">';
			html += '<td>합계</td>';
			html += '<td>' + formatNumber(summary.delayCount) + '건</td>';
			html += '<td>' + formatNumber(summary.delayQty) + ' EA</td>';
			html += '<td>-</td>';
			html += '</tr>';

			tbody.innerHTML = html;
		}

		function renderCompare(config, currentValue, prevValue) {
			const diff = currentValue - prevValue;

			compareAvg.className = '';

			if (prevValue === 0 && currentValue > 0) {
				if (compareAvgLabel) {
					compareAvgLabel.textContent = '비교 불가';
				}

				compareAvg.textContent = '전주 데이터 없음';
				compareAvg.classList.add('dash-neutral-text');
				return;
			}

			if (Math.abs(diff) < 0.05) {
				if (compareAvgLabel) {
					compareAvgLabel.textContent = '변동 없음';
				}

				compareAvg.textContent = '-';
				compareAvg.classList.add('dash-neutral-text');
				return;
			}

			const isIncrease = diff > 0;
			const isGood = isIncrease === config.goodIncrease;
			const arrow = isIncrease ? '▲ ' : '▼ ';

			if (compareAvgLabel) {
				compareAvgLabel.textContent = isIncrease ? '증가' : '감소';
			}

			compareAvg.classList.add(isGood ? 'dash-green-text' : 'dash-red-text');
			compareAvg.textContent = arrow + formatCompareValue(config.unitType, Math.abs(diff));
		}

		function formatSummaryValue(kpiType, value) {
			if (kpiType === 'production') {
				return formatNumber(value) + ' EA';
			}

			if (kpiType === 'cost') {
				return formatNumber(value) + ' 원/EA';
			}

			if (kpiType === 'delay') {
				return formatNumber(value) + '건';
			}

			return formatRate(value);
		}

		function formatCompareValue(unitType, value) {
			if (unitType === 'qty') {
				return formatNumber(value) + ' EA';
			}

			if (unitType === 'cost') {
				return formatNumber(value) + ' 원';
			}

			if (unitType === 'count') {
				return formatNumber(value) + '건';
			}

			return Number(value || 0).toFixed(1) + '%p';
		}

		function setLoading(kpiType) {
			const config = kpiConfig[kpiType];

			modalTitle.textContent = config.title;
			currentAvg.previousElementSibling.textContent = config.currentLabel;
			prevAvg.previousElementSibling.textContent = config.prevLabel;
			
			if (modalFootText) {
				modalFootText.textContent = config.footText;
			}
			

			weekRange.textContent = '조회 중입니다.';
			prevWeekRange.textContent = '비교 기간 조회 중입니다.';
			currentAvg.textContent = '-';
			prevAvg.textContent = '-';
			
			if (compareAvgLabel) {
				compareAvgLabel.textContent = '증감';
			}
			
			compareAvg.textContent = '-';
			compareAvg.className = 'dash-neutral-text';
			currentTbody.innerHTML = '<tr><td colspan="4">조회 중입니다.</td></tr>';
			prevTbody.innerHTML = '<tr><td colspan="4">조회 중입니다.</td></tr>';
		}

		function setError() {
			weekRange.textContent = '조회 실패';
			prevWeekRange.textContent = '데이터를 불러오지 못했습니다.';
			currentTbody.innerHTML = '<tr><td colspan="4">데이터 조회 중 오류가 발생했습니다.</td></tr>';
			prevTbody.innerHTML = '<tr><td colspan="4">데이터 조회 중 오류가 발생했습니다.</td></tr>';
		}

		function getDateText(row) {
			return getValue(row, 'DISPLAY_DATE') + ' (' + getValue(row, 'DAY_NAME') + ')';
		}

		function getValue(row, key) {
			return row[key] || row[key.toLowerCase()] || row[toCamelCase(key)] || '';
		}

		function toCamelCase(key) {
			return key.toLowerCase().replace(/_([a-z])/g, function(match, letter) {
				return letter.toUpperCase();
			});
		}

		function formatNumber(value) {
			return Number(value || 0).toLocaleString('ko-KR');
		}

		function formatRate(value) {
			return Number(value || 0).toFixed(1) + '%';
		}

		
		function roundOne(value) {
			return Math.round(value * 10) / 10;
		}

		function getTodayText() {
			const today = new Date();
			const year = today.getFullYear();
			const month = String(today.getMonth() + 1).padStart(2, '0');
			const date = String(today.getDate()).padStart(2, '0');

			return year + '-' + month + '-' + date;
		}

		function moveDate(dateText, day) {
			const date = new Date(dateText);
			date.setDate(date.getDate() + day);

			const year = date.getFullYear();
			const month = String(date.getMonth() + 1).padStart(2, '0');
			const targetDate = String(date.getDate()).padStart(2, '0');

			return year + '-' + month + '-' + targetDate;
		}
	})();
	
	(function() {
		const contextPath = '${pageContext.request.contextPath}';

		const detailItems = document.querySelectorAll('.dash-dashboard-detail-click');
		const detailBackdrop = document.getElementById('dashDashboardDetailModalBackdrop');
		const detailClose = document.getElementById('dashDashboardDetailModalClose');
		const detailTitle = document.getElementById('dashDashboardDetailModalTitle');
		const detailDesc = document.getElementById('dashDashboardDetailModalDesc');
		const detailThead = document.getElementById('dashDashboardDetailThead');
		const detailTbody = document.getElementById('dashDashboardDetailTbody');

		const detailConfig = {
			defectIssue: {
				title: '불량 경고 상세',
				desc: '금일 발생한 불량 LOT를 간략하게 조회한다.',
				head: ['LOT번호', '품목명', '불량유형', '불량수량', '발생일', '상세'],
				fields: [
					{ key: 'PRODUCT_LOT' },
					{ key: 'ITEM_NAME' },
					{ key: 'DEFECT_NAME' },
					{ key: 'DEFECT_QTY', suffix: ' EA', danger: true, number: true },
					{ key: 'DEFECT_DATE' }
				]
			},
			equipmentIssue: {
				title: '설비 고장 상세',
				desc: '현재 미조치 상태인 설비 고장 내역을 조회한다.',
				head: ['설비명', '고장내용', '발생일시', '상태', '상세'],
				fields: [
					{ key: 'EQUIP_NAME' },
					{ key: 'TROUBLE_CONTENT' },
					{ key: 'TROUBLE_DATE' },
					{ key: 'TROUBLE_STATUS', danger: true }
				]
			},
			delayLot: {
				title: '생산지연 LOT 상세',
				desc: '납기일이 당일 또는 경과되었지만 생산이 완료되지 않은 LOT를 조회한다.',
				head: ['LOT번호', '품목명', '납기일', '잔여수량', '현재상태', '상세'],
				fields: [
					{ key: 'PRODUCT_LOT' },
					{ key: 'ITEM_NAME' },
					{ key: 'DUE_DATE' },
					{ key: 'REMAIN_QTY', suffix: ' EA', danger: true, number: true },
					{ key: 'DELAY_STATUS', danger: true }
				]
			},
			inspectionWaitLot: {
				title: '검사대기 LOT 상세',
				desc: '검사 대기 상태인 LOT를 조회한다.',
				head: ['LOT번호', '품목명', '검사번호', '검사일', '상태', '상세'],
				fields: [
					{ key: 'PRODUCT_LOT' },
					{ key: 'ITEM_NAME' },
					{ key: 'INSP_DOC_NO' },
					{ key: 'INSP_DATE' },
					{ key: 'INSP_STATUS', warning: true }
				]
			},
			shipmentWaitLot: {
				title: '완제품 출하대기 LOT 상세',
				desc: '검사는 완료되었지만 아직 출하되지 않은 LOT를 조회한다.',
				head: ['LOT번호', '품목명', '입고일', '상태', '상세'],
				fields: [
					{ key: 'PRODUCT_LOT' },
					{ key: 'ITEM_NAME' },
					{ key: 'INOUT_DATE' },
					{ key: 'SHIP_STATUS', info: true }
				]
			}
		};

		detailItems.forEach(function(item) {
			item.addEventListener('click', function(event) {
				event.preventDefault();
				event.stopPropagation();

				const detailType = item.dataset.detailType;

				if (!detailConfig[detailType]) {
					return;
				}

				openDetailModal();
				setDetailLoading(detailType);
				loadDashboardDetailList(detailType);
			});
		});

		if (detailClose) {
			detailClose.addEventListener('click', closeDetailModal);
		}

		if (detailBackdrop) {
			detailBackdrop.addEventListener('click', function(event) {
				if (event.target === detailBackdrop) {
					closeDetailModal();
				}
			});
		}

		function openDetailModal() {
			detailBackdrop.classList.add('is-open');
		}

		function closeDetailModal() {
			detailBackdrop.classList.remove('is-open');
		}

		function setDetailLoading(detailType) {
			const config = detailConfig[detailType];

			detailTitle.textContent = config.title;
			detailDesc.textContent = config.desc;
			renderDetailHead(config.head);

			detailTbody.innerHTML = '<tr><td colspan="' + config.head.length + '">조회 중입니다.</td></tr>';
		}

		function loadDashboardDetailList(detailType) {
			fetch(contextPath + '/dashboard/detail/list?detailType=' + encodeURIComponent(detailType))
				.then(function(response) {
					return response.json();
				})
				.then(function(data) {
					if (!data || !data.success) {
						setDetailError(detailType);
						return;
					}

					renderDashboardDetailList(detailType, data.detailList || []);
				})
				.catch(function() {
					setDetailError(detailType);
				});
		}

		function renderDetailHead(headList) {
			let html = '<tr>';

			headList.forEach(function(head) {
				html += '<th>' + head + '</th>';
			});

			html += '</tr>';
			detailThead.innerHTML = html;
		}

		function renderDashboardDetailList(detailType, list) {
			const config = detailConfig[detailType];

			if (!list || list.length === 0) {
				detailTbody.innerHTML =
					'<tr><td colspan="' + config.head.length + '">조회된 데이터가 없습니다.</td></tr>';
				return;
			}

			let html = '';

			list.forEach(function(row) {
				const detailUrl = buildDetailUrl(detailType, row);

				html += '<tr class="dash-dashboard-detail-row" data-url="' + escapeHtml(detailUrl) + '">';

				config.fields.forEach(function(field) {
					const value = getDetailValue(row, field.key);
					const text = formatDetailCell(value, field);
					const className = getDetailCellClass(field);

					html += '<td class="' + className + '" title="' + escapeHtml(text) + '">' + escapeHtml(text) + '</td>';
				});

				html += '<td><button type="button" class="dash-dashboard-detail-link" data-url="' + escapeHtml(detailUrl) + '">상세</button></td>';
				html += '</tr>';
			});

			detailTbody.innerHTML = html;
			bindDetailButtons();
		}

		function buildDetailUrl(detailType, row) {
			if (detailType === 'defectIssue') {
				return contextPath + '/quality/defect_detail?defect_list_id='
					+ encodeURIComponent(getDetailValue(row, 'DEFECT_LIST_ID'));
			}

			if (detailType === 'equipmentIssue') {
				const historyId = getDetailValue(row, 'HISTORY_ID');

				if (historyId) {
					return contextPath + '/equipment/equipmentstatus/detail?history_id='
						+ encodeURIComponent(historyId);
				}

				return contextPath + '/equipment/equipmentstatus';
			}

			return contextPath + '/lot/lothistory/detail?orderId='
				+ encodeURIComponent(getDetailValue(row, 'ORDER_ID'));
		}

		function bindDetailButtons() {
			const rows = detailTbody.querySelectorAll('.dash-dashboard-detail-row');

			rows.forEach(function(row) {
				row.addEventListener('click', function() {
					const url = row.dataset.url;

					if (url) {
						location.href = url;
					}
				});
			});

			const buttons = detailTbody.querySelectorAll('.dash-dashboard-detail-link');

			buttons.forEach(function(button) {
				button.addEventListener('click', function(event) {
					event.stopPropagation();

					const url = button.dataset.url;

					if (url) {
						location.href = url;
					}
				});
			});
		}

		function setDetailError(detailType) {
			const config = detailConfig[detailType];

			detailTbody.innerHTML =
				'<tr><td colspan="' + config.head.length + '">데이터 조회 중 오류가 발생했습니다.</td></tr>';
		}

		function getDetailCellClass(field) {
			if (field.danger) {
				return 'dash-red-text';
			}

			if (field.warning) {
				return 'dash-orange-text';
			}

			if (field.info) {
				return 'dash-blue-text';
			}

			return '';
		}

		function formatDetailCell(value, field) {
			if (value === null || value === undefined || value === '') {
				return '-';
			}

			if (field.number) {
				return Number(value || 0).toLocaleString('ko-KR') + (field.suffix || '');
			}

			return String(value) + (field.suffix || '');
		}

		function getDetailValue(row, key) {
			return row[key] || row[key.toLowerCase()] || row[toDetailCamelCase(key)] || '';
		}

		function toDetailCamelCase(key) {
			return key.toLowerCase().replace(/_([a-z])/g, function(match, letter) {
				return letter.toUpperCase();
			});
		}

		function escapeHtml(value) {
			return String(value || '')
				.replace(/&/g, '&amp;')
				.replace(/</g, '&lt;')
				.replace(/>/g, '&gt;')
				.replace(/"/g, '&quot;')
				.replace(/'/g, '&#039;');
		}
	})();
</script>