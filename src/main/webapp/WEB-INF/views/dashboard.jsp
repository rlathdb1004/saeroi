<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 대시보드 본문 화면이다. --%>

<section class="dashboard-page">

	<%-- KPI 핵심 지표 영역이다. --%>
	<section class="dash-kpi-grid">

		<article class="dash-card dash-kpi-card">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<span class="dash-title-icon">
						<svg viewBox="0 0 24 24" aria-hidden="true">
							<path d="M4 19V5"></path>
							<path d="M4 19H20"></path>
							<path d="M8 16V11"></path>
							<path d="M12 16V8"></path>
							<path d="M16 16V13"></path>
						</svg>
					</span>
					<h3 class="dash-card-title">생산달성률</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-kpi-split">
				<div class="dash-donut" style="--rate: 87.6;">
					<div class="dash-donut-center">
						<strong>87.6</strong>
						<span>%</span>
						<em>목표 100%</em>
					</div>
				</div>

				<div class="dash-kpi-detail-list">
					<div class="dash-kpi-detail-item">
						<span class="dash-detail-icon">
							<svg viewBox="0 0 24 24" aria-hidden="true">
								<path d="M8 2V5"></path>
								<path d="M16 2V5"></path>
								<path d="M4 9H20"></path>
								<rect x="4" y="4" width="16" height="17" rx="2"></rect>
							</svg>
						</span>
						<div>
							<span>계획</span>
							<strong>15,000 EA</strong>
						</div>
					</div>

					<div class="dash-kpi-detail-item">
						<span class="dash-detail-icon">
							<svg viewBox="0 0 24 24" aria-hidden="true">
								<path d="M4 19V5"></path>
								<path d="M4 19H20"></path>
								<path d="M8 16V12"></path>
								<path d="M12 16V8"></path>
								<path d="M16 16V10"></path>
							</svg>
						</span>
						<div>
							<span>실적</span>
							<strong>13,140 EA</strong>
						</div>
					</div>
				</div>
			</div>
		</article>

		<article class="dash-card dash-kpi-card">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">납기 준수율</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-kpi-split">
				<div class="dash-donut" style="--rate: 95.4;">
					<div class="dash-donut-center">
						<strong>95.4</strong>
						<span>%</span>
						<em>전주 92.1% ▲</em>
					</div>
				</div>

				<div class="dash-progress-list">
					<div class="dash-progress-row">
						<span><i class="dash-dot dash-dot-green"></i>준수</span>
						<div class="dash-progress-track"><em style="width: 95.4%;"></em></div>
						<strong>95.4%</strong>
					</div>

					<div class="dash-progress-row">
						<span><i class="dash-dot dash-dot-gray"></i>미준수</span>
						<div class="dash-progress-track"><em class="dash-progress-gray" style="width: 4.6%;"></em></div>
						<strong>4.6%</strong>
					</div>
				</div>
			</div>
		</article>

		<article class="dash-card dash-kpi-card">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">OEE</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-kpi-split">
				<div class="dash-donut" style="--rate: 82.1;">
					<div class="dash-donut-center">
						<strong>82.1</strong>
						<span>%</span>
						<em>전주 78.3% ▲</em>
					</div>
				</div>

				<div class="dash-progress-list">
					<div class="dash-progress-row">
						<span><i class="dash-dot dash-dot-green"></i>가동 효율</span>
						<div class="dash-progress-track"><em style="width: 82.1%;"></em></div>
						<strong>82.1%</strong>
					</div>

					<div class="dash-progress-row">
						<span><i class="dash-dot dash-dot-gray"></i>손실 효율</span>
						<div class="dash-progress-track"><em class="dash-progress-gray" style="width: 17.9%;"></em></div>
						<strong>17.9%</strong>
					</div>
				</div>
			</div>
		</article>

		<article class="dash-card dash-kpi-card dash-kpi-card-defect">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<span class="dash-title-icon">
						<svg viewBox="0 0 24 24" aria-hidden="true">
							<path d="M12 3L21 20H3L12 3Z"></path>
							<path d="M12 9V13"></path>
							<path d="M12 17H12.01"></path>
						</svg>
					</span>
					<h3 class="dash-card-title">불량률</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-scale-body">
				<div class="dash-scale-value">
					<strong>1.8</strong>
					<span>%</span>
					<em>전주 2.1% ▼</em>
				</div>

				<div class="dash-scale-area">
					<div class="dash-scale-labels">
						<span>0%</span>
						<span>목표 2.0%</span>
						<span>5%</span>
					</div>
					<div class="dash-scale-track">
						<em style="width: 36%;"></em>
						<i style="left: 40%;"></i>
					</div>
				</div>
			</div>
		</article>

		<article class="dash-card dash-kpi-card dash-kpi-card-cost">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<span class="dash-title-icon dash-title-blue">
						<svg viewBox="0 0 24 24" aria-hidden="true">
							<path d="M12 3A9 9 0 1 0 21 12"></path>
							<path d="M21 3V9H15"></path>
							<path d="M21 9L15 3"></path>
						</svg>
					</span>
					<h3 class="dash-card-title">원가 편차율</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-scale-body">
				<div class="dash-scale-value dash-good-value">
					<strong>-2.4</strong>
					<span>%</span>
					<em>전주 -1.1% ▼</em>
				</div>

				<div class="dash-scale-area">
					<div class="dash-scale-labels">
						<span>-5%</span>
						<span>0%</span>
						<span>+5%</span>
					</div>
					<div class="dash-scale-track">
						<em style="width: 31%;"></em>
						<i style="left: 50%;"></i>
					</div>
				</div>
			</div>
		</article>

		<article class="dash-card dash-kpi-card">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<span class="dash-title-icon">
						<svg viewBox="0 0 24 24" aria-hidden="true">
							<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
							<path d="M9 12L11 14L15 10"></path>
						</svg>
					</span>
					<h3 class="dash-card-title">금일 생산평가</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-eval-body">
				<div class="dash-eval-text">
					<strong>정상</strong>
					<span>이상 없음</span>
				</div>

				<div class="dash-eval-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<path d="M20 6L9 17L4 12"></path>
					</svg>
				</div>
			</div>
		</article>

	</section>

	<%-- 주요 추이 그래프 영역이다. --%>
	<section class="dash-chart-grid">

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head dash-chart-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">생산실적 추이</h3>
					<span class="dash-unit-text">단위: EA</span>
				</div>

				<div class="dash-chart-value">
					<strong>13,140</strong>
					<span>오늘 실적</span>
				</div>
			</div>

			<div class="dash-canvas-wrap">
				<canvas id="productionChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head dash-chart-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">불량 추이</h3>
					<span class="dash-unit-text">단위: %</span>
				</div>

				<div class="dash-chart-value dash-chart-value-red">
					<strong>1.8%</strong>
					<span>목표 2.0%</span>
				</div>
			</div>

			<div class="dash-canvas-wrap">
				<canvas id="defectChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head dash-chart-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">생산원가 추이</h3>
					<span class="dash-unit-text">단위: 원/EA</span>
				</div>

				<div class="dash-chart-value">
					<strong>1,050</strong>
					<span>목표 1,200</span>
				</div>
			</div>

			<div class="dash-canvas-wrap">
				<canvas id="costChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head dash-chart-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">OEE 추이</h3>
					<span class="dash-unit-text">단위: %</span>
				</div>

				<div class="dash-chart-value">
					<strong>82.1%</strong>
					<span>전주 78.3% ▲</span>
				</div>
			</div>

			<div class="dash-canvas-wrap">
				<canvas id="oeeChart"></canvas>
			</div>
		</article>

	</section>

	<%-- MES 운영 흐름 영역이다. --%>
	<section class="dash-card dash-flow-section">
		<div class="dash-card-head">
			<h3 class="dash-card-title">MES 운영 흐름</h3>
			<a href="${pageContext.request.contextPath}/production/processprogress" class="dash-more-link">더보기</a>
		</div>

		<div class="dash-flow-list">
			<div class="dash-flow-step">
				<span class="dash-flow-icon">▤</span>
				<strong>작업지시</strong>
			</div>
			<i>→</i>
			<div class="dash-flow-step">
				<span class="dash-flow-icon">□</span>
				<strong>자재투입</strong>
			</div>
			<i>→</i>
			<div class="dash-flow-step">
				<span class="dash-flow-icon">⚙</span>
				<strong>생산진행</strong>
			</div>
			<i>→</i>
			<div class="dash-flow-step">
				<span class="dash-flow-icon">✓</span>
				<strong>품질검사</strong>
			</div>
			<i>→</i>
			<div class="dash-flow-step">
				<span class="dash-flow-icon">▣</span>
				<strong>완료 / 출하</strong>
			</div>
		</div>
	</section>

	<%-- 하단 정보 영역이다. --%>
	<section class="dash-bottom-grid">

		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3 class="dash-card-title">최근 작업지시</h3>
				<a href="${pageContext.request.contextPath}/production/workorder" class="dash-more-link">더보기</a>
			</div>

			<table class="dash-work-table">
				<thead>
					<tr>
						<th>지시번호</th>
						<th>품목명</th>
						<th>진행률</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>WO-25-0518-003</td>
						<td>SA-1000</td>
						<td>
							<div class="dash-table-progress"><em style="width: 100%;"></em><span>100%</span></div>
						</td>
						<td><span class="dash-status dash-status-green">완료</span></td>
					</tr>
					<tr>
						<td>WO-25-0518-002</td>
						<td>SA-2000</td>
						<td>
							<div class="dash-table-progress"><em style="width: 75%;"></em><span>75%</span></div>
						</td>
						<td><span class="dash-status dash-status-blue">진행중</span></td>
					</tr>
					<tr>
						<td>WO-25-0517-003</td>
						<td>SA-3000</td>
						<td>
							<div class="dash-table-progress"><em style="width: 60%;"></em><span>60%</span></div>
						</td>
						<td><span class="dash-status dash-status-blue">진행중</span></td>
					</tr>
					<tr>
						<td>WO-25-0517-002</td>
						<td>SA-4000</td>
						<td>
							<div class="dash-table-progress"><em style="width: 20%;"></em><span>20%</span></div>
						</td>
						<td><span class="dash-status dash-status-gray">대기</span></td>
					</tr>
				</tbody>
			</table>
		</article>

		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3 class="dash-card-title">공지사항</h3>
				<a href="${pageContext.request.contextPath}/board/notice" class="dash-more-link">더보기</a>
			</div>

			<ul class="dash-list">
				<li><a href="${pageContext.request.contextPath}/board/notice">5월 정기 설비 점검 안내</a><span>2025-05-16</span></li>
				<li><a href="${pageContext.request.contextPath}/board/notice">MES 시스템 점검 작업 안내</a><span>2025-05-15</span></li>
				<li><a href="${pageContext.request.contextPath}/board/notice">품질 기준 변경 안내</a><span>2025-05-14</span></li>
				<li><a href="${pageContext.request.contextPath}/board/notice">안전보건 교육 일정 안내</a><span>2025-05-12</span></li>
			</ul>
		</article>

		<article class="dash-card dash-bottom-card">
			<div class="dash-card-head">
				<h3 class="dash-card-title">오늘 알림</h3>
				<a href="${pageContext.request.contextPath}/dashboard" class="dash-more-link">더보기</a>
			</div>

			<ul class="dash-alert-list">
				<li>
					<span class="dash-alert-icon dash-alert-green">!</span>
					<div><strong>설비 경고: MC-03 온도 이상</strong><em>10:08</em></div>
				</li>
				<li>
					<span class="dash-alert-icon dash-alert-orange">!</span>
					<div><strong>자재 부족: BOLT-M 재고 부족</strong><em>09:42</em></div>
				</li>
				<li>
					<span class="dash-alert-icon dash-alert-blue">i</span>
					<div><strong>작업지시 WO-25-0518-002 진행 중</strong><em>08:30</em></div>
				</li>
				<li>
					<span class="dash-alert-icon dash-alert-blue">i</span>
					<div><strong>품질 이슈: QC-02 검사 대기</strong><em>08:15</em></div>
				</li>
			</ul>
		</article>

	</section>

</section>

<%-- Chart.js 그래프 라이브러리이다. --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
	// 대시보드 그래프를 생성한다.
	document.addEventListener("DOMContentLoaded", function () {
		if (typeof Chart === "undefined") {
			return;
		}

		const chartGreen = "#008B4F";
		const chartGreenLight = "rgba(0, 139, 79, 0.22)";
		const chartGray = "#CBD5E1";
		const chartText = "#334155";
		const chartGrid = "#E5E7EB";
		const chartRed = "#DC2626";

		Chart.defaults.font.family = "'Pretendard', 'Noto Sans KR', Arial, sans-serif";
		Chart.defaults.color = chartText;
		Chart.defaults.plugins.legend.display = false;

		const labels = ["5/12", "5/13", "5/14", "5/15", "5/16", "5/17", "5/18"];

		// 공통 옵션을 반환한다.
		function getCommonOptions(maxValue, stepSize, unitCallback) {
			return {
				responsive: true,
				maintainAspectRatio: false,
				interaction: {
					mode: "index",
					intersect: false
				},
				plugins: {
					tooltip: {
						backgroundColor: "rgba(17, 24, 39, 0.9)",
						padding: 10,
						titleFont: {
							size: 12,
							weight: "700"
						},
						bodyFont: {
							size: 12,
							weight: "600"
						},
						displayColors: true
					}
				},
				scales: {
					x: {
						grid: {
							display: false
						},
						ticks: {
							font: {
								size: 11,
								weight: "700"
							}
						},
						border: {
							display: false
						}
					},
					y: {
						beginAtZero: true,
						max: maxValue,
						ticks: {
							stepSize: stepSize,
							font: {
								size: 11,
								weight: "700"
							},
							callback: unitCallback
						},
						grid: {
							color: chartGrid
						},
						border: {
							display: false
						}
					}
				}
			};
		}

		// 생산실적 추이 그래프이다.
		new Chart(document.getElementById("productionChart"), {
			type: "bar",
			data: {
				labels: labels,
				datasets: [
					{
						type: "bar",
						label: "실적",
						data: [11200, 12500, 11800, 12800, 12100, 12700, 13140],
						backgroundColor: [
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreen
						],
						borderRadius: 7,
						barThickness: 34
					},
					{
						type: "line",
						label: "계획",
						data: [15000, 15000, 15000, 15000, 15000, 15000, 15000],
						borderColor: "#475569",
						borderWidth: 2,
						borderDash: [6, 6],
						pointRadius: 0,
						tension: 0
					}
				]
			},
			options: getCommonOptions(20000, 5000, function (value) {
				return value === 0 ? "0" : (value / 1000) + "K";
			})
		});

		// 불량 추이 그래프이다.
		new Chart(document.getElementById("defectChart"), {
			type: "line",
			data: {
				labels: labels,
				datasets: [
					{
						label: "불량률",
						data: [2.2, 2.6, 2.1, 2.7, 2.3, 2.2, 1.8],
						borderColor: chartRed,
						backgroundColor: "rgba(220, 38, 38, 0.08)",
						fill: true,
						borderWidth: 3,
						pointRadius: 4,
						pointHoverRadius: 6,
						pointBackgroundColor: chartRed,
						pointBorderColor: "#FFFFFF",
						pointBorderWidth: 2,
						tension: 0.35
					},
					{
						label: "목표",
						data: [2, 2, 2, 2, 2, 2, 2],
						borderColor: "#475569",
						borderWidth: 2,
						borderDash: [6, 6],
						pointRadius: 0,
						tension: 0
					}
				]
			},
			options: getCommonOptions(4, 1, function (value) {
				return value + "%";
			})
		});

		// 생산원가 추이 그래프이다.
		new Chart(document.getElementById("costChart"), {
			type: "bar",
			data: {
				labels: labels,
				datasets: [
					{
						type: "bar",
						label: "원가",
						data: [1180, 1260, 1210, 1270, 1220, 1240, 1050],
						backgroundColor: [
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreenLight,
							chartGreen
						],
						borderRadius: 7,
						barThickness: 34
					},
					{
						type: "line",
						label: "목표",
						data: [1200, 1200, 1200, 1200, 1200, 1200, 1200],
						borderColor: "#475569",
						borderWidth: 2,
						borderDash: [6, 6],
						pointRadius: 0,
						tension: 0
					}
				]
			},
			options: getCommonOptions(1800, 600, function (value) {
				return value.toLocaleString();
			})
		});

		// OEE 추이 그래프이다.
		new Chart(document.getElementById("oeeChart"), {
			type: "line",
			data: {
				labels: labels,
				datasets: [
					{
						label: "OEE",
						data: [68.4, 72.1, 70.2, 75.4, 71.8, 78.3, 82.1],
						borderColor: chartGreen,
						backgroundColor: "rgba(0, 139, 79, 0.08)",
						fill: true,
						borderWidth: 3,
						pointRadius: 4,
						pointHoverRadius: 6,
						pointBackgroundColor: chartGreen,
						pointBorderColor: "#FFFFFF",
						pointBorderWidth: 2,
						tension: 0.35
					},
					{
						label: "목표",
						data: [80, 80, 80, 80, 80, 80, 80],
						borderColor: "#475569",
						borderWidth: 2,
						borderDash: [6, 6],
						pointRadius: 0,
						tension: 0
					}
				]
			},
			options: getCommonOptions(100, 25, function (value) {
				return value + "%";
			})
		});
	});
</script>