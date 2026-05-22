<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 
	대시보드 본문 화면이다.
	이 파일은 layout.jsp의 <tiles:insertAttribute name="content" /> 위치에 들어간다.
--%>

<section class="dashboard-page">

	<%-- 핵심 KPI 전체 영역이다. --%>
	<div class="dashboard-section">

		<div class="section-title-box">
			<h3 class="section-title">핵심 KPI</h3>
		</div>

		<%-- KPI 카드를 PC 기준 3개씩 2줄로 배치한다. --%>
		<div class="kpi-grid">

			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">📊</span> <span class="kpi-name">생산달성률</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.0</strong> <span class="kpi-unit">%</span>
				</div>

				<div class="kpi-bottom">
					<span>목표</span> <strong>100.0%</strong>
				</div>
			</div>

			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">⏱</span> <span class="kpi-name">납기
						준수율</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.0</strong> <span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>전체</span> <strong>0건</strong>
				</div>

				<div class="kpi-detail-row">
					<span>지연</span> <strong>0건</strong>
				</div>
			</div>

			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">🛡</span> <span class="kpi-name">OEE</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.0</strong> <span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>라인가동률</span> <strong>100.0%</strong>
				</div>

				<div class="kpi-detail-row">
					<span>생산성률</span> <strong>0.0%</strong>
				</div>

				<div class="kpi-detail-row">
					<span>품질양품률</span> <strong>0.0%</strong>
				</div>
			</div>

			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">!</span> <span class="kpi-name">불량률</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.00</strong> <span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>검사 수량</span> <strong>0 kg</strong>
				</div>

				<div class="kpi-detail-row">
					<span>양품</span> <strong>0 kg</strong>
				</div>

				<div class="kpi-detail-row">
					<span>불량</span> <strong class="danger-text">0 kg</strong>
				</div>
			</div>

			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">▣</span> <span class="kpi-name">원가
						편차율</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.00</strong> <span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>표준단가</span> <strong>0 원/kg</strong>
				</div>

				<div class="kpi-detail-row">
					<span>실제단가</span> <strong>0 원/kg</strong>
				</div>
			</div>

			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">👤</span> <span class="kpi-name">일일생산평가</span>
				</div>

				<div class="kpi-empty-box">
					<span>금일 생산 평가 데이터 준비중</span>
				</div>
			</div>

		</div>
	</div>

	<%-- 최근 7일 추이 그래프 영역이다. 그래프는 한 줄에 하나씩 크게 보여준다. --%>
	<div class="dashboard-section">
		<div class="section-title-box">
			<h3 class="section-title">생산 / 품질 / 출하 / 생산원가 추이</h3>
			<span class="section-badge">최근 7일 추이도</span>
		</div>

		<div class="chart-grid">

			<div class="chart-card">
				<h4>생산 추이</h4>
				<p>일자별 생산실적 기준</p>

				<div class="chart-placeholder">
					<svg class="mini-chart" viewBox="0 0 320 180">
						<line x1="30" y1="30" x2="300" y2="30" />
						<line x1="30" y1="65" x2="300" y2="65" />
						<line x1="30" y1="100" x2="300" y2="100" />
						<line x1="30" y1="135" x2="300" y2="135" />

						<polyline class="chart-line blue-line"
							points="35,115 78,95 121,86 164,108 207,78 250,92 293,112" />

						<circle class="blue-dot" cx="35" cy="115" r="4" />
						<circle class="blue-dot" cx="78" cy="95" r="4" />
						<circle class="blue-dot" cx="121" cy="86" r="4" />
						<circle class="blue-dot" cx="164" cy="108" r="4" />
						<circle class="blue-dot" cx="207" cy="78" r="4" />
						<circle class="blue-dot" cx="250" cy="92" r="4" />
						<circle class="blue-dot" cx="293" cy="112" r="4" />

						<text class="chart-value" x="35" y="104">320</text>
						<text class="chart-value" x="78" y="84">410</text>
						<text class="chart-value" x="121" y="75">460</text>
						<text class="chart-value" x="164" y="97">350</text>
						<text class="chart-value" x="207" y="67">520</text>
						<text class="chart-value" x="250" y="81">430</text>
						<text class="chart-value" x="293" y="101">330</text>

						<text class="chart-date" x="35" y="165">05-06</text>
						<text class="chart-date" x="78" y="165">05-07</text>
						<text class="chart-date" x="121" y="165">05-08</text>
						<text class="chart-date" x="164" y="165">05-09</text>
						<text class="chart-date" x="207" y="165">05-10</text>
						<text class="chart-date" x="250" y="165">05-11</text>
						<text class="chart-date" x="293" y="165">05-14</text>
					</svg>
				</div>
			</div>

			<div class="chart-card">
				<h4>품질 추이</h4>
				<p>일자별 불량률 기준</p>

				<div class="chart-placeholder">
					<svg class="mini-chart" viewBox="0 0 320 180">
						<line x1="30" y1="30" x2="300" y2="30" />
						<line x1="30" y1="65" x2="300" y2="65" />
						<line x1="30" y1="100" x2="300" y2="100" />
						<line x1="30" y1="135" x2="300" y2="135" />

						<polyline class="chart-line green-line"
							points="35,75 78,82 121,96 164,65 207,52 250,70 293,78" />

						<circle class="green-dot" cx="35" cy="75" r="4" />
						<circle class="green-dot" cx="78" cy="82" r="4" />
						<circle class="green-dot" cx="121" cy="96" r="4" />
						<circle class="green-dot" cx="164" cy="65" r="4" />
						<circle class="green-dot" cx="207" cy="52" r="4" />
						<circle class="green-dot" cx="250" cy="70" r="4" />
						<circle class="green-dot" cx="293" cy="78" r="4" />

						<text class="chart-value" x="35" y="64">1.2%</text>
						<text class="chart-value" x="78" y="71">1.5%</text>
						<text class="chart-value" x="121" y="85">2.1%</text>
						<text class="chart-value" x="164" y="54">0.8%</text>
						<text class="chart-value" x="207" y="41">0.5%</text>
						<text class="chart-value" x="250" y="59">1.0%</text>
						<text class="chart-value" x="293" y="67">1.3%</text>

						<text class="chart-date" x="35" y="165">05-06</text>
						<text class="chart-date" x="78" y="165">05-07</text>
						<text class="chart-date" x="121" y="165">05-08</text>
						<text class="chart-date" x="164" y="165">05-09</text>
						<text class="chart-date" x="207" y="165">05-10</text>
						<text class="chart-date" x="250" y="165">05-11</text>
						<text class="chart-date" x="293" y="165">05-14</text>
					</svg>
				</div>
			</div>

			<div class="chart-card">
				<h4>출하 추이</h4>
				<p>일자별 출하수량 기준</p>

				<div class="chart-placeholder">
					<svg class="mini-chart" viewBox="0 0 320 180">
						<line x1="30" y1="30" x2="300" y2="30" />
						<line x1="30" y1="65" x2="300" y2="65" />
						<line x1="30" y1="100" x2="300" y2="100" />
						<line x1="30" y1="135" x2="300" y2="135" />

						<polyline class="chart-line blue-line"
							points="35,118 78,102 121,92 164,108 207,96 250,88 293,115" />

						<circle class="blue-dot" cx="35" cy="118" r="4" />
						<circle class="blue-dot" cx="78" cy="102" r="4" />
						<circle class="blue-dot" cx="121" cy="92" r="4" />
						<circle class="blue-dot" cx="164" cy="108" r="4" />
						<circle class="blue-dot" cx="207" cy="96" r="4" />
						<circle class="blue-dot" cx="250" cy="88" r="4" />
						<circle class="blue-dot" cx="293" cy="115" r="4" />

						<text class="chart-value" x="35" y="107">180</text>
						<text class="chart-value" x="78" y="91">240</text>
						<text class="chart-value" x="121" y="81">300</text>
						<text class="chart-value" x="164" y="97">220</text>
						<text class="chart-value" x="207" y="85">270</text>
						<text class="chart-value" x="250" y="77">320</text>
						<text class="chart-value" x="293" y="104">190</text>

						<text class="chart-date" x="35" y="165">05-06</text>
						<text class="chart-date" x="78" y="165">05-07</text>
						<text class="chart-date" x="121" y="165">05-08</text>
						<text class="chart-date" x="164" y="165">05-09</text>
						<text class="chart-date" x="207" y="165">05-10</text>
						<text class="chart-date" x="250" y="165">05-11</text>
						<text class="chart-date" x="293" y="165">05-14</text>
					</svg>
				</div>
			</div>

			<div class="chart-card">
				<h4>생산원가 추이</h4>
				<p>일자별 평균 생산단가 기준</p>

				<div class="chart-placeholder">
					<svg class="mini-chart" viewBox="0 0 320 180">
						<line x1="30" y1="30" x2="300" y2="30" />
						<line x1="30" y1="65" x2="300" y2="65" />
						<line x1="30" y1="100" x2="300" y2="100" />
						<line x1="30" y1="135" x2="300" y2="135" />

						<polyline class="chart-line orange-line"
							points="35,78 78,84 121,92 164,100 207,92 250,84 293,76" />

						<circle class="orange-dot" cx="35" cy="78" r="4" />
						<circle class="orange-dot" cx="78" cy="84" r="4" />
						<circle class="orange-dot" cx="121" cy="92" r="4" />
						<circle class="orange-dot" cx="164" cy="100" r="4" />
						<circle class="orange-dot" cx="207" cy="92" r="4" />
						<circle class="orange-dot" cx="250" cy="84" r="4" />
						<circle class="orange-dot" cx="293" cy="76" r="4" />

						<text class="chart-value" x="35" y="67">1,050</text>
						<text class="chart-value" x="78" y="73">1,080</text>
						<text class="chart-value" x="121" y="81">1,120</text>
						<text class="chart-value" x="164" y="89">1,160</text>
						<text class="chart-value" x="207" y="81">1,120</text>
						<text class="chart-value" x="250" y="73">1,080</text>
						<text class="chart-value" x="293" y="65">1,040</text>

						<text class="chart-date" x="35" y="165">05-06</text>
						<text class="chart-date" x="78" y="165">05-07</text>
						<text class="chart-date" x="121" y="165">05-08</text>
						<text class="chart-date" x="164" y="165">05-09</text>
						<text class="chart-date" x="207" y="165">05-10</text>
						<text class="chart-date" x="250" y="165">05-11</text>
						<text class="chart-date" x="293" y="165">05-14</text>
					</svg>
				</div>
			</div>

		</div>
	</div>

	<%-- MES 운영 흐름 영역이다. --%>
	<div class="dashboard-section flow-section">

		<div class="section-title-box">
			<h3 class="section-title">MES 운영 흐름</h3>
			<a href="#" class="more-link">더보기 〉</a>
		</div>

		<div class="flow-grid">

			<div class="flow-card">
				<div class="flow-icon flow-teal">
					<svg viewBox="0 0 64 64" aria-hidden="true">
			<%-- 막대그래프 첫 번째 막대이다. --%>
			<rect x="13" y="34" width="6" height="18" rx="1" />

			<%-- 막대그래프 두 번째 막대이다. --%>
			<rect x="25" y="26" width="6" height="26" rx="1" />

			<%-- 막대그래프 세 번째 막대이다. --%>
			<rect x="37" y="18" width="6" height="34" rx="1" />

			<%-- 하단 기준선이다. --%>
			<rect x="10" y="52" width="38" height="3" rx="1" />

			<%-- 상승 추이선이다. --%>
			<path class="icon-stroke" d="M12 31L24 22L35 28L47 14" />

			<%-- 상승 화살표 머리이다. --%>
			<path class="icon-stroke" d="M42 14H47V19" />
		</svg>
				</div>

				<strong>생산실적</strong>

				<div class="flow-info">
					<span><em>지시량</em><b>12,500 EA</b></span> <span><em>오늘
							실적</em><b>7,850 EA</b></span>
				</div>

				<a
					href="${pageContext.request.contextPath}/production/productionresult"
					class="flow-more">더보기 〉</a>
			</div>

			<div class="flow-card">
				<div class="flow-icon flow-green">
					<svg viewBox="0 0 64 64">
		<%-- 클립보드 몸통이다. --%>
		<path
							d="M18 13H46C48.2 13 50 14.8 50 17V56H14V17C14 14.8 15.8 13 18 13Z" />

		<%-- 클립보드 상단 집게 부분이다. --%>
		<path d="M25 7H39C40.1 7 41 7.9 41 9V16H23V9C23 7.9 23.9 7 25 7Z" />

		<%-- 클립보드 안쪽 흰색 줄이다. --%>
		<rect class="icon-white" x="24" y="25" width="20" height="4" rx="1" />
		<rect class="icon-white" x="24" y="35" width="20" height="4" rx="1" />
		<rect class="icon-white" x="24" y="45" width="14" height="4" rx="1" />
	</svg>
				</div>

				<strong>생산계획</strong>

				<div class="flow-info">
					<span><em>계획</em><b>15,000 EA</b></span> <span><em>지시</em><b>12,500
							EA</b></span>
				</div>

				<a
					href="${pageContext.request.contextPath}/production/productionplan"
					class="flow-more">더보기 〉</a>
			</div>

			<div class="flow-card">
				<div class="flow-icon flow-orange">
					<svg viewBox="0 0 64 64">
						<path d="M16 6H40L52 18V58H16V6Z" />
						<path class="icon-white" d="M40 7V19H52Z" />
						<rect class="icon-white" x="25" y="30" width="22" height="4" />
						<rect class="icon-white" x="25" y="40" width="18" height="4" />
					</svg>
				</div>

				<strong>작업지시</strong>

				<div class="flow-info">
					<span><em>진행중</em><b>12건</b></span> <span><em>대기</em><b>6건</b></span>
				</div>

				<a href="${pageContext.request.contextPath}/production/workorder"
					class="flow-more">더보기 〉</a>
			</div>

			<div class="flow-card">
				<div class="flow-icon flow-purple">
					<svg viewBox="0 0 64 64">
						<path
							d="M32 5L54 14V30C54 44 45 55 32 60C19 55 10 44 10 30V14L32 5Z" />
						<path class="icon-white" d="M23 32L29 38L43 24L47 28L29 46L19 36Z" />
					</svg>
				</div>

				<strong>품질관리</strong>

				<div class="flow-info">
					<span><em>검사 진행</em><b>15건</b></span> <span><em>불량 수량</em><b>123
							EA</b></span>
				</div>

				<a href="${pageContext.request.contextPath}/quality/inspection"
					class="flow-more">더보기 〉</a>
			</div>

			<div class="flow-card">
				<div class="flow-icon flow-teal">
					<svg viewBox="0 0 64 64">
		<%-- 막대그래프 첫 번째 막대이다. --%>
		<rect x="13" y="34" width="7" height="20" rx="1" />

		<%-- 막대그래프 두 번째 막대이다. --%>
		<rect x="27" y="26" width="7" height="28" rx="1" />

		<%-- 막대그래프 세 번째 막대이다. --%>
		<rect x="41" y="18" width="7" height="36" rx="1" />

		<%-- 하단 기준선이다. --%>
		<rect x="10" y="54" width="45" height="4" rx="1" />

		<%-- 상승 추이선이다. --%>
		<path class="icon-line-thick" d="M14 31L28 21L41 27L55 12" />

		<%-- 상승 화살표 머리이다. --%>
		<path class="icon-line-thick" d="M47 12H55V20" />
	</svg>
				</div>

				<strong>생산실적</strong>

				<div class="flow-info">
					<span><em>지시량</em><b>12,500 EA</b></span> <span><em>오늘
							실적</em><b>7,850 EA</b></span>
				</div>

				<a
					href="${pageContext.request.contextPath}/production/productionresult"
					class="flow-more">더보기 〉</a>
			</div>

			<div class="flow-card">
				<div class="flow-icon flow-indigo">
					<svg viewBox="0 0 64 64">
		<%-- 트럭 적재함이다. --%>
		<path d="M8 21H37V44H8V21Z" />

		<%-- 트럭 운전석이다. --%>
		<path d="M37 29H49L57 37V44H37V29Z" />

		<%-- 운전석 창문이다. --%>
		<path class="icon-white" d="M43 33H48L52 38H43V33Z" />

		<%-- 왼쪽 바퀴이다. --%>
		<circle cx="20" cy="48" r="6" />

		<%-- 오른쪽 바퀴이다. --%>
		<circle cx="48" cy="48" r="6" />

		<%-- 바퀴 안쪽 흰색 원이다. --%>
		<circle class="icon-white" cx="20" cy="48" r="2.5" />
		<circle class="icon-white" cx="48" cy="48" r="2.5" />
	</svg>
				</div>

				<strong>출하관리</strong>

				<div class="flow-info">
					<span><em>출하 대기</em><b>5건</b></span> <span><em>금일 출하</em><b>6건</b></span>
				</div>

				<a href="#" class="flow-more">더보기 〉</a>
			</div>

		</div>
	</div>

	<%-- 하단 영역이다. --%>
	<div class="bottom-grid">

		<div class="bottom-left">

			<div class="dashboard-section">
				<div class="section-title-box">
					<h3 class="section-title">최근 작업지시</h3>
				</div>

				<table class="dashboard-table">
					<thead>
						<tr>
							<th>작업지시번호</th>
							<th>품목명</th>
							<th>규격</th>
							<th>수량(EA)</th>
							<th>지시일</th>
							<th>상태</th>
							<th>진행률</th>
						</tr>
					</thead>

					<tbody>
						<tr>
							<td>WO-250508-006</td>
							<td>EVG-1001</td>
							<td>10T</td>
							<td>2,000</td>
							<td>2025.05.08</td>
							<td><span class="status-chip progress">진행중</span></td>
							<td>60%</td>
						</tr>

						<tr>
							<td>WO-250508-005</td>
							<td>EVG-1002</td>
							<td>15T</td>
							<td>1,500</td>
							<td>2025.05.08</td>
							<td><span class="status-chip wait">대기</span></td>
							<td>0%</td>
						</tr>
					</tbody>
				</table>
			</div>

		</div>

		<div class="bottom-right">

			<div class="dashboard-section">
				<div class="section-title-box">
					<h3 class="section-title">오늘 알림</h3>
					<a href="#" class="more-link">더보기</a>
				</div>

				<ul class="alert-list">
					<li><strong>설비 점검 예정</strong> <span>MC #03 정기 점검 예정</span> <em>09:00</em>
					</li>

					<li><strong>자재 부족 알림</strong> <span>EPDM-011 재고 부족</span> <em>08:30</em>
					</li>
				</ul>
			</div>

			<div class="dashboard-section">
				<div class="section-title-box">
					<h3 class="section-title">공지사항</h3>
					<a href="#" class="more-link">더보기</a>
				</div>

				<ul class="notice-list">
					<li><span>5월 설비 점검 일정 안내</span> <em>2025.05.07</em></li>

					<li><span>품질 기준 변경 안내</span> <em>2025.05.02</em></li>

					<li><span>근로자의 날 휴무 안내</span> <em>2025.04.29</em></li>
				</ul>
			</div>

		</div>

	</div>

</section>