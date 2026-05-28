<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- CEO 대시보드 본문 화면이다. --%>

<section class="dashboard-page">

	<%-- 오늘 공장 운영 상태를 가장 먼저 보여주는 대표 상태판이다. --%>
	<section class="dash-hero-card">
		<div class="dash-hero-left">
			<div class="dash-hero-icon">
				<svg viewBox="0 0 24 24" aria-hidden="true">
					<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
					<path d="M9 12L11 14L15 10"></path>
				</svg>
			</div>

			<div class="dash-hero-text">
				<span>오늘 공장 운영 상태</span>
				<strong>정상 운영 중</strong>
				<p>모든 핵심 지표가 목표 범위 내에서 안정적으로 운영되고 있습니다.</p>
				<em>기준 시간 16:20:53</em>
			</div>
		</div>

		<div class="dash-hero-metrics">
			<div class="dash-hero-metric">
				<span>금일 생산량</span>
				<strong>13,140 <em>EA</em></strong>
				<p>계획 대비 87.6%</p>
			</div>

			<div class="dash-hero-metric dash-hero-metric-red">
				<span>불량률</span>
				<strong>1.8 <em>%</em></strong>
				<p>목표 2.0% 이하</p>
			</div>

			<div class="dash-hero-metric">
				<span>설비 가동률</span>
				<strong>82.3 <em>%</em></strong>
				<p>가동 중 32대</p>
			</div>

			<div class="dash-hero-metric">
				<span>납기 준수율</span>
				<strong>95.4 <em>%</em></strong>
				<p>준수 건 125건</p>
			</div>
		</div>
	</section>

	<%-- 핵심 KPI 카드 영역이다. --%>
	<section class="dash-kpi-grid">

		<article class="dash-card dash-kpi-card dash-kpi-card-production">
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

			<div class="dash-kpi-body">
				<div class="dash-donut" style="--rate: 87.6;">
					<div class="dash-donut-center">
						<strong>87.6</strong>
						<span>%</span>
						<em>목표 100%</em>
					</div>
				</div>

				<div class="dash-kpi-detail-list">
					<div>
						<span>계획</span>
						<strong>15,000 <em>EA</em></strong>
					</div>
					<div>
						<span>실적</span>
						<strong>13,140 <em>EA</em></strong>
					</div>
				</div>
			</div>

			<div class="dash-card-bottom dash-card-bottom-green">
				<span>전주 대비</span>
				<strong>+ 3.2%p ↑</strong>
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

			<div class="dash-half-gauge" style="--gauge-deg: 64.8deg; --gauge-color: #EF4444;">
				<div class="dash-half-gauge-center">
					<strong>1.8</strong>
					<span>%</span>
					<em>목표 2.0%</em>
				</div>
			</div>

			<div class="dash-defect-scale">
				<div class="dash-scale-label">
					<span>0%</span>
					<strong>2%</strong>
					<span>5%</span>
				</div>
				<div class="dash-scale-track">
					<em style="width: 36%;"></em>
					<i style="left: 40%;"></i>
				</div>
			</div>

			<div class="dash-card-bottom dash-card-bottom-red">
				<span>목표 초과</span>
				<strong>+ 0.2%p ↑</strong>
			</div>
		</article>

		<article class="dash-card dash-kpi-card">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<span class="dash-title-icon">
						<svg viewBox="0 0 24 24" aria-hidden="true">
							<path d="M8 2V5"></path>
							<path d="M16 2V5"></path>
							<path d="M4 9H20"></path>
							<rect x="4" y="4" width="16" height="17" rx="2"></rect>
							<path d="M9 14L11 16L15 12"></path>
						</svg>
					</span>
					<h3 class="dash-card-title">납기 준수율</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-half-gauge" style="--gauge-deg: 171.7deg; --gauge-color: #008B4F;">
				<div class="dash-half-gauge-center">
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

			<div class="dash-card-bottom dash-card-bottom-green">
				<span>전주 대비</span>
				<strong>+ 3.3%p ↑</strong>
			</div>
		</article>

		<article class="dash-card dash-kpi-card">
			<div class="dash-card-head">
				<div class="dash-title-box">
					<span class="dash-title-icon">
						<svg viewBox="0 0 24 24" aria-hidden="true">
							<path d="M4 19V5"></path>
							<path d="M4 19H20"></path>
							<path d="M8 16V10"></path>
							<path d="M12 16V7"></path>
							<path d="M16 16V12"></path>
						</svg>
					</span>
					<h3 class="dash-card-title">OEE</h3>
					<span class="dash-info-mark">i</span>
				</div>
			</div>

			<div class="dash-half-gauge" style="--gauge-deg: 147.8deg; --gauge-color: #008B4F;">
				<div class="dash-half-gauge-center">
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

			<div class="dash-card-bottom dash-card-bottom-green">
				<span>전주 대비</span>
				<strong>+ 3.8%p ↑</strong>
			</div>
		</article>

	</section>

	<%-- 그래프와 운영 정보를 함께 보여주는 영역이다. --%>
	<section class="dash-main-grid">

		<article class="dash-card dash-chart-card">
			<div class="dash-card-head dash-chart-head">
				<div class="dash-title-box">
					<h3 class="dash-card-title">생산실적 추이</h3>
					<span class="dash-unit-text">단위: EA</span>
				</div>

				<div class="dash-chart-legend">
					<span><i class="dash-legend-line dash-legend-gray"></i>계획</span>
					<span><i class="dash-legend-line dash-legend-green"></i>실적</span>
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
					<span class="dash-unit-text">단위: % / EA</span>
				</div>

				<div class="dash-chart-legend">
					<span><i class="dash-legend-line dash-legend-red"></i>불량률</span>
					<span><i class="dash-legend-bar"></i>불량 수</span>
				</div>
			</div>

			<div class="dash-canvas-wrap">
				<canvas id="defectChart"></canvas>
			</div>
		</article>

		<article class="dash-card dash-side-card">
			<div class="dash-card-head">
				<h3 class="dash-card-title">설비 가동 현황</h3>
				<span class="dash-live-mark">실시간</span>
			</div>

			<div class="dash-equipment-body">
				<div class="dash-equipment-donut" style="--run-end: 66.7%; --stop-end: 87.5%;">
					<div class="dash-equipment-center">
						<span>전체 설비</span>
						<strong>48</strong>
						<em>대</em>
					</div>
				</div>

				<div class="dash-equipment-list">
					<div>
						<span><i class="dash-dot dash-dot-green"></i>가동 중</span>
						<strong>32대</strong>
					</div>
					<div>
						<span><i class="dash-dot dash-dot-orange"></i>정지 중</span>
						<strong>10대</strong>
					</div>
					<div>
						<span><i class="dash-dot dash-dot-red"></i>이상 정지</span>
						<strong>6대</strong>
					</div>
				</div>
			</div>

			<div class="dash-equipment-rate">
				<span>가동률</span>
				<strong>82.3%</strong>
				<em>전주 79.1% ▲</em>
			</div>
		</article>

		<article class="dash-card dash-side-card">
			<div class="dash-card-head">
				<h3 class="dash-card-title">공지사항</h3>
				<a href="${pageContext.request.contextPath}/board/notice" class="dash-more-link">더보기</a>
			</div>

			<ul class="dash-notice-list">
				<li>
					<span class="dash-notice-badge dash-notice-green">공지</span>
					<a href="${pageContext.request.contextPath}/board/notice">5월 정기 안전 점검 안내</a>
					<em>05-27</em>
				</li>
				<li>
					<span class="dash-notice-badge dash-notice-green">공지</span>
					<a href="${pageContext.request.contextPath}/board/notice">MES 시스템 정기 점검 안내</a>
					<em>05-26</em>
				</li>
				<li>
					<span class="dash-notice-badge dash-notice-blue">알림</span>
					<a href="${pageContext.request.contextPath}/board/notice">생산 보고서 자동 생성 기능 업데이트</a>
					<em>05-25</em>
				</li>
				<li>
					<span class="dash-notice-badge dash-notice-orange">안전</span>
					<a href="${pageContext.request.contextPath}/board/notice">여름철 작업장 안전 수칙 안내</a>
					<em>05-24</em>
				</li>
			</ul>
		</article>

	</section>

	<%-- 하단 요약 영역이다. --%>
	<section class="dash-footer-summary">
		<article class="dash-card dash-footer-card dash-eval-card">
			<div class="dash-footer-icon">
				<svg viewBox="0 0 24 24" aria-hidden="true">
					<path d="M12 22S20 18 20 10V5L12 2L4 5V10C4 18 12 22 12 22Z"></path>
					<path d="M9 12L11 14L15 10"></path>
				</svg>
			</div>

			<div>
				<span>금일 생산평가</span>
				<strong>정상</strong>
				<em>이상 없음</em>
			</div>
		</article>

		<article class="dash-card dash-footer-card dash-cost-card">
			<div>
				<span>원가 편차율</span>
				<strong>-2.4%</strong>
				<em>전주 -1.1% ▼</em>
			</div>

			<div class="dash-cost-track">
				<span>-5%</span>
				<div><em style="width: 31%;"></em></div>
				<span>0%</span>
				<div><em class="dash-cost-track-gray" style="width: 26%;"></em></div>
				<span>+5%</span>
			</div>
		</article>

		<a href="${pageContext.request.contextPath}/report/productionReport" class="dash-report-btn">
			상세 리포트 보기
			<span>›</span>
		</a>
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

		const productionCanvas = document.getElementById("productionChart");
		const defectCanvas = document.getElementById("defectChart");

		if (!productionCanvas || !defectCanvas) {
			return;
		}

		const chartGreen = "#008B4F";
		const chartGreenDark = "#006B3D";
		const chartGray = "#9CA3AF";
		const chartLightGray = "rgba(156, 163, 175, 0.22)";
		const chartText = "#374151";
		const chartGrid = "rgba(229, 231, 235, 0.85)";
		const chartRed = "#EF4444";
		const chartRedLight = "rgba(239, 68, 68, 0.18)";

		Chart.defaults.font.family = "'Pretendard', 'Noto Sans KR', Arial, sans-serif";
		Chart.defaults.color = chartText;
		Chart.defaults.plugins.legend.display = false;

		const labels = ["05/21", "05/22", "05/23", "05/24", "05/25", "05/26", "05/27"];

		// 생산실적 그래프 그라데이션 배경이다.
		const productionCtx = productionCanvas.getContext("2d");
		const productionGradient = productionCtx.createLinearGradient(0, 0, 0, 260);
		productionGradient.addColorStop(0, "rgba(0, 139, 79, 0.26)");
		productionGradient.addColorStop(1, "rgba(0, 139, 79, 0.02)");

		// 공통 툴팁 옵션이다.
		const tooltipOption = {
			backgroundColor: "rgba(17, 24, 39, 0.92)",
			padding: 11,
			titleFont: {
				size: 12,
				weight: "800"
			},
			bodyFont: {
				size: 12,
				weight: "700"
			},
			displayColors: true,
			boxPadding: 5
		};

		// 생산실적 추이 그래프이다.
		new Chart(productionCanvas, {
			type: "line",
			data: {
				labels: labels,
				datasets: [
					{
						label: "계획",
						data: [10000, 13000, 11800, 13200, 15100, 12400, 14500],
						borderColor: chartGray,
						borderWidth: 2,
						borderDash: [7, 6],
						pointRadius: 0,
						pointHoverRadius: 4,
						tension: 0.35
					},
					{
						label: "실적",
						data: [7000, 10200, 8800, 10600, 14300, 10800, 11800],
						borderColor: chartGreen,
						backgroundColor: productionGradient,
						fill: true,
						borderWidth: 3,
						pointRadius: 4,
						pointHoverRadius: 6,
						pointBackgroundColor: "#FFFFFF",
						pointBorderColor: chartGreen,
						pointBorderWidth: 3,
						tension: 0.35
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				interaction: {
					mode: "index",
					intersect: false
				},
				plugins: {
					tooltip: tooltipOption
				},
				scales: {
					x: {
						grid: {
							display: false
						},
						ticks: {
							padding: 8,
							font: {
								size: 11,
								weight: "800"
							}
						},
						border: {
							display: false
						}
					},
					y: {
						beginAtZero: true,
						max: 20000,
						ticks: {
							stepSize: 5000,
							padding: 8,
							font: {
								size: 11,
								weight: "800"
							},
							callback: function (value) {
								return value === 0 ? "0" : (value / 1000) + "k";
							}
						},
						grid: {
							color: chartGrid,
							drawTicks: false
						},
						border: {
							display: false
						}
					}
				}
			}
		});

		// 불량 추이 그래프이다.
		new Chart(defectCanvas, {
			type: "bar",
			data: {
				labels: labels,
				datasets: [
					{
						type: "bar",
						label: "불량 수",
						data: [230, 300, 210, 260, 340, 250, 280],
						backgroundColor: chartLightGray,
						borderRadius: 8,
						barThickness: 28,
						yAxisID: "y1",
						order: 2
					},
					{
						type: "line",
						label: "불량률",
						data: [1.2, 2.0, 1.6, 1.2, 1.9, 1.4, 1.8],
						borderColor: chartRed,
						backgroundColor: chartRedLight,
						borderWidth: 3,
						pointRadius: 4,
						pointHoverRadius: 7,
						pointBackgroundColor: "#FFFFFF",
						pointBorderColor: chartRed,
						pointBorderWidth: 3,
						tension: 0.35,
						yAxisID: "y",
						order: 1
					},
					{
						type: "line",
						label: "목표",
						data: [2, 2, 2, 2, 2, 2, 2],
						borderColor: "rgba(239, 68, 68, 0.35)",
						borderWidth: 2,
						borderDash: [6, 6],
						pointRadius: 0,
						tension: 0,
						yAxisID: "y",
						order: 0
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				interaction: {
					mode: "index",
					intersect: false
				},
				plugins: {
					tooltip: tooltipOption
				},
				scales: {
					x: {
						grid: {
							display: false
						},
						ticks: {
							padding: 8,
							font: {
								size: 11,
								weight: "800"
							}
						},
						border: {
							display: false
						}
					},
					y: {
						beginAtZero: true,
						max: 4,
						position: "left",
						ticks: {
							stepSize: 1,
							padding: 8,
							font: {
								size: 11,
								weight: "800"
							},
							callback: function (value) {
								return value + "%";
							}
						},
						grid: {
							color: chartGrid,
							drawTicks: false
						},
						border: {
							display: false
						}
					},
					y1: {
						beginAtZero: true,
						max: 600,
						position: "right",
						ticks: {
							stepSize: 150,
							padding: 8,
							font: {
								size: 11,
								weight: "800"
							}
						},
						grid: {
							drawOnChartArea: false
						},
						border: {
							display: false
						}
					}
				}
			}
		});
	});
</script>