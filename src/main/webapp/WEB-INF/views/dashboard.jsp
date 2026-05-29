<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

	<%-- KPI 핵심 6대 지표 영역이다. --%>
<section class="dash-kpi-panel">

	<div class="dash-kpi-panel-head">
		<h3>KPI 핵심 6대 지표</h3>
	</div>

	<section class="dash-kpi-grid">

		<article class="dash-kpi-card">
			<div class="dash-kpi-head">
				<strong>생산달성률</strong>
				<span class="dash-info-mini">i</span>
			</div>

			<div class="dash-kpi-body">
				<span class="dash-kpi-icon dash-green-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<circle cx="12" cy="12" r="8"></circle>
						<circle cx="12" cy="12" r="4"></circle>
						<path d="M12 12L18 6"></path>
						<path d="M17 6H20V9"></path>
					</svg>
				</span>

				<div class="dash-kpi-value dash-green-text">
					<strong>96.4</strong>
					<span>%</span>
				</div>
			</div>

			<div class="dash-kpi-detail">
				<span>목표 <strong>20,000 EA</strong></span>
				<span>실적 <strong>19,280 EA</strong></span>
			</div>

			<div class="dash-kpi-bottom">
				<span>전일 대비</span>
				<strong class="dash-up">▲ 2.1%p</strong>
			</div>
		</article>

		<article class="dash-kpi-card">
			<div class="dash-kpi-head">
				<strong>금일 생산량</strong>
				<span class="dash-info-mini">i</span>
			</div>

			<div class="dash-kpi-body">
				<span class="dash-kpi-icon dash-green-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<path d="M5 19V13"></path>
						<path d="M10 19V9"></path>
						<path d="M15 19V5"></path>
						<path d="M20 19V11"></path>
					</svg>
				</span>

				<div class="dash-kpi-value dash-green-text">
					<strong>12,480</strong>
					<span>EA</span>
				</div>
			</div>

			<div class="dash-kpi-detail">
				<span>전일 <strong>11,230 EA</strong></span>
			</div>

			<div class="dash-kpi-bottom">
				<span>전일 대비</span>
				<strong class="dash-up">▲ 1,250 EA</strong>
			</div>
		</article>

		<article class="dash-kpi-card">
			<div class="dash-kpi-head">
				<strong>불량률</strong>
				<span class="dash-info-mini">i</span>
			</div>

			<div class="dash-kpi-body">
				<span class="dash-kpi-icon dash-red-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
						<path d="M9 9L15 15"></path>
						<path d="M15 9L9 15"></path>
					</svg>
				</span>

				<div class="dash-kpi-value dash-red-text">
					<strong>1.8</strong>
					<span>%</span>
				</div>
			</div>

			<div class="dash-kpi-detail">
				<span>불량 <strong>225 EA</strong></span>
				<span>검사 <strong>12,480 EA</strong></span>
			</div>

			<div class="dash-kpi-bottom">
				<span>전일 대비</span>
				<strong class="dash-down">▼ 0.4%p</strong>
			</div>
		</article>

		<article class="dash-kpi-card">
			<div class="dash-kpi-head">
				<strong>생산원가</strong>
				<span class="dash-info-mini">i</span>
			</div>

			<div class="dash-kpi-body">
				<span class="dash-kpi-icon dash-blue-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 2V22"></path>
						<path d="M17 5H9.5C7.6 5 6 6.3 6 8C6 9.7 7.6 11 9.5 11H14.5C16.4 11 18 12.3 18 14C18 15.7 16.4 17 14.5 17H6"></path>
					</svg>
				</span>

				<div class="dash-kpi-value dash-blue-text">
					<strong>842</strong>
					<span>만원</span>
				</div>
			</div>

			<div class="dash-kpi-detail">
				<span>목표 <strong>880 만원</strong></span>
				<span>실적 <strong>842 만원</strong></span>
			</div>

			<div class="dash-kpi-bottom">
				<span>전일 대비</span>
				<strong class="dash-up">▼ 18만원</strong>
			</div>
		</article>

		<article class="dash-kpi-card">
			<div class="dash-kpi-head">
				<strong>OEE</strong>
				<span class="dash-info-mini">i</span>
			</div>

			<div class="dash-kpi-body">
				<span class="dash-kpi-icon dash-green-icon dash-oee-icon">
					<svg class="dash-oee-svg" viewBox="0 0 64 64" aria-hidden="true">
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
					<strong>87.6</strong>
					<span>%</span>
				</div>
			</div>

			<div class="dash-kpi-detail">
				<span>설비 효율 기준</span>
			</div>

			<div class="dash-kpi-bottom">
				<span>전일 대비</span>
				<strong class="dash-up">▲ 1.1%p</strong>
			</div>
		</article>

		<article class="dash-kpi-card">
			<div class="dash-kpi-head">
				<strong>지연 작업지시</strong>
				<span class="dash-info-mini">i</span>
			</div>

			<div class="dash-kpi-body">
				<span class="dash-kpi-icon dash-orange-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<circle cx="12" cy="12" r="9"></circle>
						<path d="M12 7V12L16 15"></path>
					</svg>
				</span>

				<div class="dash-kpi-value dash-orange-text">
					<strong>8</strong>
					<span>건</span>
				</div>
			</div>

			<div class="dash-kpi-detail">
				<span>지연 수량 <strong>2,340 EA</strong></span>
			</div>

			<div class="dash-kpi-bottom">
				<span>전일 대비</span>
				<strong class="dash-orange-text">▲ 2건</strong>
			</div>
		</article>

	</section>

</section>

	<%-- 현장 이슈와 LOT 현황 영역이다. --%>
<section class="dash-alert-panel">

	<div class="dash-alert-panel-head">
		<h3>현장 이슈 &amp; LOT 현황</h3>
		<p>주요 현장 이슈와 LOT 진행 현황을 확인하세요.</p>
	</div>

	<div class="dash-alert-main">
		<span class="dash-alert-bell">
			<svg viewBox="0 0 24 24" aria-hidden="true">
				<path d="M18 8A6 6 0 0 0 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8"></path>
				<path d="M10 21H14"></path>
			</svg>
		</span>

		<strong>긴급 알림</strong>
		<em>3건</em>
	</div>

	<div class="dash-alert-items">
		<div class="dash-alert-card">
			<div class="dash-alert-text">
				<div class="dash-alert-title-row">
					<strong>불량 경고</strong>
					<time>10:18</time>
				</div>

				<span>불량률 1.8% (기준 1.5% 초과)</span>
			</div>
		</div>

		<div class="dash-alert-card">
			<div class="dash-alert-text">
				<div class="dash-alert-title-row">
					<strong>설비 고장</strong>
					<time>09:25</time>
				</div>

				<span>M-10 OC 석서 이상</span>
			</div>
		</div>

		<div class="dash-alert-card dash-alert-orange">
			<div class="dash-alert-text">
				<div class="dash-alert-title-row">
					<strong>지연 작업지시</strong>
					<time>10:20</time>
				</div>

				<span>지연 작업지시 8건 발생</span>
			</div>
		</div>
	</div>

	<div class="dash-lot-row">
		<div class="dash-lot-box">
			<span class="dash-lot-icon dash-lot-red-icon">
				<svg viewBox="0 0 24 24" aria-hidden="true">
					<circle cx="12" cy="12" r="9"></circle>
					<path d="M12 7V12L15 14"></path>
				</svg>
			</span>

			<div class="dash-lot-info">
				<span>지연 LOT</span>
				<strong class="dash-red-text">2건</strong>
			</div>

			<em class="dash-lot-arrow">›</em>
		</div>

		<div class="dash-lot-box">
			<span class="dash-lot-icon dash-lot-orange-icon">
				<svg viewBox="0 0 24 24" aria-hidden="true">
					<path d="M8 3H16"></path>
					<path d="M9 3V7"></path>
					<path d="M15 3V7"></path>
					<rect x="6" y="7" width="12" height="14" rx="2"></rect>
					<path d="M9 12H15"></path>
					<path d="M9 16H13"></path>
				</svg>
			</span>

			<div class="dash-lot-info">
				<span>검사대기 LOT</span>
				<strong class="dash-orange-text">5건</strong>
			</div>

			<em class="dash-lot-arrow">›</em>
		</div>

		<div class="dash-lot-box">
			<span class="dash-lot-icon dash-lot-blue-icon">
				<svg viewBox="0 0 24 24" aria-hidden="true">
					<path d="M21 8L12 3L3 8L12 13L21 8Z"></path>
					<path d="M3 8V16L12 21L21 16V8"></path>
					<path d="M12 13V21"></path>
				</svg>
			</span>

			<div class="dash-lot-info">
				<span>출하대기 LOT</span>
				<strong class="dash-blue-text">7건</strong>
			</div>

			<em class="dash-lot-arrow">›</em>
		</div>
	</div>

</section>

	
	<%-- 주요 그래프 영역이다. --%>
	<section class="dash-chart-grid">

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head">
				<h3>생산실적 추이</h3>
				<span>단위: EA</span>
			</div>

			<div class="dash-chart-box">
				<canvas id="productionChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head">
				<h3>불량 추이</h3>
				<span>단위: %</span>
			</div>

			<div class="dash-chart-box">
				<canvas id="defectChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head">
				<h3>생산원가 추이</h3>
				<span>단위: 만원</span>
			</div>

			<div class="dash-chart-box">
				<canvas id="costChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-facility-card">
			<div class="dash-card-head">
				<h3>설비 가동 현황</h3>
				<span>전체 48대</span>
			</div>

			<div class="dash-facility-body">
				<div class="dash-facility-chart">
					<canvas id="facilityChart"></canvas>

					<div class="dash-facility-center">
						<strong>82.3%</strong> <span>가동률</span>
					</div>
				</div>

				<ul class="dash-facility-list">
					<li><i class="dash-legend-dot dash-legend-green"></i> <span>가동</span>
						<strong>32대</strong></li>
					<li><i class="dash-legend-dot dash-legend-light"></i> <span>대기</span>
						<strong>10대</strong></li>
					<li><i class="dash-legend-dot dash-legend-gray"></i> <span>정지</span>
						<strong>6대</strong></li>
				</ul>
			</div>

			<p class="dash-facility-total">
				전체 설비 <strong>48대</strong> 기준
			</p>
		</article>

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

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M3 7L12 2L21 7L12 12L3 7Z"></path>
											<path d="M3 17L12 22L21 17"></path>
											<path d="M3 12L12 17L21 12"></path>
										</svg>
									</span>
									1. 자재입고
								</div>

								<em>›</em>

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M8 2V5"></path>
											<path d="M16 2V5"></path>
											<rect x="4" y="4" width="16" height="17" rx="2"></rect>
											<path d="M8 11H16"></path>
											<path d="M8 15H13"></path>
										</svg>
									</span>
									2. 생산계획
								</div>

								<em>›</em>

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M8 6H21"></path>
											<path d="M8 12H21"></path>
											<path d="M8 18H21"></path>
											<path d="M3 6H3.01"></path>
											<path d="M3 12H3.01"></path>
											<path d="M3 18H3.01"></path>
										</svg>
									</span>
									3. 작업지시
								</div>

								<em>›</em>

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<circle cx="12" cy="12" r="3"></circle>
											<path d="M19.4 15A1.65 1.65 0 0 0 20 13.8A1.65 1.65 0 0 0 19.4 12.6L17.9 11.4A6.5 6.5 0 0 0 17.2 9.7L17.8 7.8A1.65 1.65 0 0 0 17 5.9A1.65 1.65 0 0 0 15 6.1L13.5 7.2A6.5 6.5 0 0 0 10.5 7.2L9 6.1A1.65 1.65 0 0 0 7 5.9A1.65 1.65 0 0 0 6.2 7.8L6.8 9.7A6.5 6.5 0 0 0 6.1 11.4L4.6 12.6A1.65 1.65 0 0 0 4 13.8A1.65 1.65 0 0 0 4.6 15L6.1 16.2A6.5 6.5 0 0 0 6.8 17.9L6.2 19.8A1.65 1.65 0 0 0 7 21.7A1.65 1.65 0 0 0 9 21.5L10.5 20.4A6.5 6.5 0 0 0 13.5 20.4L15 21.5A1.65 1.65 0 0 0 17 21.7A1.65 1.65 0 0 0 17.8 19.8L17.2 17.9A6.5 6.5 0 0 0 17.9 16.2Z"></path>
										</svg>
									</span>
									4.공정진행
								</div>

								<em>›</em>

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M4 19V5"></path>
											<path d="M4 19H20"></path>
											<path d="M8 16V11"></path>
											<path d="M12 16V8"></path>
											<path d="M16 16V13"></path>
										</svg>
									</span>
									5. 생산실적
								</div>

								<em>›</em>

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
											<path d="M9 12L11 14L15 10"></path>
										</svg>
									</span>
									6. 품질검사
								</div>

								<em>›</em>

								<div class="dash-flow-step">
									<span>
										<svg viewBox="0 0 24 24" aria-hidden="true">
											<path d="M3 7H16V17H3Z"></path>
											<path d="M16 10H20L22 13V17H16Z"></path>
											<circle cx="7" cy="19" r="2"></circle>
											<circle cx="18" cy="19" r="2"></circle>
										</svg>
									</span>
									7. 출하
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

		<article class="dash-card dash-bottom-card">
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
						<th>비율</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>1</td>
						<td>외관 불량</td>
						<td>72</td>
						<td><span class="dash-bar"><em style="width: 82%;"></em></span></td>
					</tr>
					<tr>
						<td>2</td>
						<td>치수 불량</td>
						<td>58</td>
						<td><span class="dash-bar"><em style="width: 66%;"></em></span></td>
					</tr>
					<tr>
						<td>3</td>
						<td>기포</td>
						<td>43</td>
						<td><span class="dash-bar"><em style="width: 48%;"></em></span></td>
					</tr>
					<tr>
						<td>4</td>
						<td>성형 불량</td>
						<td>31</td>
						<td><span class="dash-bar"><em style="width: 36%;"></em></span></td>
					</tr>
					<tr>
						<td>5</td>
						<td>혼입</td>
						<td>21</td>
						<td><span class="dash-bar"><em style="width: 24%;"></em></span></td>
					</tr>
				</tbody>
			</table>
		</article>

		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3>최근 작업지시</h3>
				<a href="${pageContext.request.contextPath}/production/workOrder"
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
					<tr>
						<td>WO-0528-001</td>
						<td>GSK-A01</td>
						<td>2,000</td>
						<td><span class="dash-state dash-state-green">진행</span></td>
					</tr>
					<tr>
						<td>WO-0528-002</td>
						<td>GSK-B02</td>
						<td>1,500</td>
						<td><span class="dash-state dash-state-orange">대기</span></td>
					</tr>
					<tr>
						<td>WO-0528-003</td>
						<td>GSK-C03</td>
						<td>3,000</td>
						<td><span class="dash-state dash-state-blue">검사</span></td>
					</tr>
					<tr>
						<td>WO-0528-004</td>
						<td>GSK-D04</td>
						<td>1,200</td>
						<td><span class="dash-state dash-state-green">진행</span></td>
					</tr>
					<tr>
						<td>WO-0528-005</td>
						<td>GSK-E05</td>
						<td>2,400</td>
						<td><span class="dash-state dash-state-orange">대기</span></td>
					</tr>
				</tbody>
			</table>
		</article>

		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3>공지사항</h3>
				<a href="${pageContext.request.contextPath}/board/notice"
					class="dash-more-link">더보기</a>
			</div>

			<ul class="dash-notice-list">
				<li><a href="${pageContext.request.contextPath}/board/notice"><span>5월
							정기 안전 점검 안내</span><em>05-28</em></a></li>
				<li><a href="${pageContext.request.contextPath}/board/notice"><span>MES
							시스템 정기 점검 안내</span><em>05-27</em></a></li>
				<li><a href="${pageContext.request.contextPath}/board/notice"><span>생산
							보고서 자동 생성 기능 업데이트</span><em>05-26</em></a></li>
				<li><a href="${pageContext.request.contextPath}/board/notice"><span>여름철
							작업장 안전 수칙 안내</span><em>05-25</em></a></li>
				<li><a href="${pageContext.request.contextPath}/board/notice"><span>현장
							작업자 QR 등록 안내</span><em>05-24</em></a></li>
			</ul>
		</article>

	</section>

</section>

<%-- Chart.js 그래프 라이브러리이다. --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
	// 대시보드 기준시간과 차트를 생성한다.
	document
			.addEventListener(
					"DOMContentLoaded",
					function() {

						// 데이터 기준시간을 저장한다.
						const dashAccessTime = new Date();

						// 현재 표시 중인 기준시간을 저장한다.
						let dashBaseTime = new Date(dashAccessTime);

						// 기준시간 표시 요소를 찾는다.
						const dashTimeText = document
								.getElementById("dashCurrentTime");

						// 기준상태 표시 요소를 찾는다.
						const dashTimeStatus = document
								.getElementById("dashTimeStatus");

						// 기준시간 갱신 버튼을 찾는다.
						const dashTimeRefreshBtn = document
								.getElementById("dashTimeRefreshBtn");

						// 숫자를 두 자리로 만든다.
						function dashAddZero(value) {
							return String(value).padStart(2, "0");
						}

						// 기준시간 표시 형식을 만든다.
						function dashFormatTime(dateValue) {
							const weekText = [ "일", "월", "화", "수", "목", "금",
									"토" ];
							const year = dateValue.getFullYear();
							const month = dashAddZero(dateValue.getMonth() + 1);
							const date = dashAddZero(dateValue.getDate());
							const day = weekText[dateValue.getDay()];
							const hour = dashAddZero(dateValue.getHours());
							const minute = dashAddZero(dateValue.getMinutes());
							const second = dashAddZero(dateValue.getSeconds());

							return year + "-" + month + "-" + date + " (" + day
									+ ") " + hour + ":" + minute + ":" + second;
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

							dashTimeStatus.innerHTML = '<span class="dash-time-status-dot"></span>'
									+ statusText;
						}

						// 기준시간 갱신 버튼 이벤트이다.
						if (dashTimeRefreshBtn != null) {
							dashTimeRefreshBtn.addEventListener("click",
									function() {
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
						const chartGreenLight = "rgba(31, 122, 87, 0.14)";
						const chartRed = "#C94646";
						const chartRedLight = "rgba(201, 70, 70, 0.16)";
						const chartGray = "#B7C1BA";
						const chartGrid = "rgba(129, 140, 130, 0.22)";
						const chartText = "#111827";

						// 차트 기본 글꼴 설정이다.
						Chart.defaults.font.family = "'Pretendard', 'Noto Sans KR', Arial, sans-serif";
						Chart.defaults.color = chartText;

						const labels = [ "05/22", "05/23", "05/24", "05/25",
								"05/26", "05/27", "05/28" ];

						// 차트 상단 토글 버튼 옵션이다.
						const chartLegendOption = {
							display : true,
							position : "top",
							align : "end",
							labels : {
								usePointStyle : true,
								pointStyle : "circle",
								boxWidth : 8,
								boxHeight : 8,
								padding : 12,
								color : chartText,
								font : {
									size : 11,
									weight : "800"
								}
							}
						};

						// 차트 공통 옵션이다.
						const commonOption = {
							responsive : true,
							maintainAspectRatio : false,
							plugins : {
								legend : chartLegendOption,
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
									}
								}
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
									grid : {
										color : chartGrid,
										drawTicks : false
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
								}
							}
						};

						// 생산실적 추이 차트이다.
						const productionCanvas = document
								.getElementById("productionChart");

						if (productionCanvas != null) {
							new Chart(
									productionCanvas,
									{
										type : "line",
										data : {
											labels : labels,
											datasets : [
													{
														label : "계획",
														data : [ 17000, 18500,
																17800, 19000,
																20000, 19500,
																20000 ],
														borderColor : chartGray,
														borderWidth : 2,
														borderDash : [ 6, 6 ],
														pointRadius : 0,
														tension : 0.35
													},
													{
														label : "실적",
														data : [ 16200, 17600,
																17100, 18400,
																19200, 18800,
																19280 ],
														borderColor : chartGreen,
														backgroundColor : chartGreenLight,
														fill : true,
														borderWidth : 3,
														pointRadius : 4,
														pointHoverRadius : 6,
														pointBackgroundColor : "#FFFFFF",
														pointBorderColor : chartGreen,
														pointBorderWidth : 3,
														tension : 0.35
													} ]
										},
										options : commonOption
									});
						}

						// 불량 추이 차트이다.
						const defectCanvas = document
								.getElementById("defectChart");

						if (defectCanvas != null) {
							new Chart(defectCanvas, {
								type : "line",
								data : {
									labels : labels,
									datasets : [ {
										label : "불량률",
										data : [ 2.1, 1.9, 2.0, 1.7, 2.2, 2.0,
												1.8 ],
										borderColor : chartRed,
										backgroundColor : chartRedLight,
										fill : true,
										borderWidth : 3,
										pointRadius : 4,
										pointHoverRadius : 6,
										pointBackgroundColor : "#FFFFFF",
										pointBorderColor : chartRed,
										pointBorderWidth : 3,
										tension : 0.35
									} ]
								},
								options : commonOption
							});
						}

						// 생산원가 추이 차트이다.
						const costCanvas = document.getElementById("costChart");

						if (costCanvas != null) {
							new Chart(costCanvas, {
								type : "bar",
								data : {
									labels : labels,
									datasets : [ {
										label : "생산원가",
										data : [ 920, 890, 910, 875, 860, 850,
												842 ],
										backgroundColor : chartGreenLight,
										borderColor : chartGreen,
										borderWidth : 1,
										borderRadius : 8
									} ]
								},
								options : commonOption
							});
						}

						// 설비 가동 현황 차트이다.
						const facilityCanvas = document
								.getElementById("facilityChart");

						if (facilityCanvas != null) {
							new Chart(
									facilityCanvas,
									{
										type : "doughnut",
										data : {
											labels : [ "가동", "대기", "정지" ],
											datasets : [ {
												data : [ 32, 10, 6 ],
												backgroundColor : [ chartGreen,
														"#A9CDB9", "#D1D5DB" ],
												borderWidth : 0
											} ]
										},
										options : {
											responsive : true,
											maintainAspectRatio : false,
											cutout : "72%",
											rotation : -90,
											circumference : 180,
											plugins : {
												legend : {
													display : false
												},
												tooltip : {
													backgroundColor : "rgba(17, 24, 39, 0.92)",
													padding : 10
												}
											}
										}
									});
						}
					});
</script>

