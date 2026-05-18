<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 
	대시보드 본문 화면이다.
	이 파일은 layout.jsp의 <tiles:insertAttribute name="content" /> 위치에 들어간다.
--%>

<section class="dashboard-page">

	<%-- 핵심 KPI 전체 영역이다. --%>
	<div class="dashboard-section">

		<%-- 핵심 KPI 제목이다. --%>
		<div class="section-title-box">
			<h3 class="section-title">핵심 KPI</h3>
		</div>

		<%-- KPI 카드를 3개씩 2줄로 배치하기 위한 영역이다. --%>
		<div class="kpi-grid">

			<%-- 생산달성률 카드 --%>
			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">📊</span>
					<span class="kpi-name">생산달성률</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.0</strong>
					<span class="kpi-unit">%</span>
				</div>

				<div class="kpi-bottom">
					<span>목표</span>
					<strong>100.0%</strong>
				</div>
			</div>

			<%-- 납기 준수율 카드 --%>
			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">⏱</span>
					<span class="kpi-name">납기 준수율</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.0</strong>
					<span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>전체</span>
					<strong>0건</strong>
				</div>

				<div class="kpi-detail-row">
					<span>지연</span>
					<strong>0건</strong>
				</div>
			</div>

			<%-- OEE 카드 --%>
			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">🛡</span>
					<span class="kpi-name">OEE</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.0</strong>
					<span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>라인가동률</span>
					<strong>100.0%</strong>
				</div>

				<div class="kpi-detail-row">
					<span>생산성률</span>
					<strong>0.0%</strong>
				</div>

				<div class="kpi-detail-row">
					<span>품질양품률</span>
					<strong>0.0%</strong>
				</div>
			</div>

			<%-- 불량률 카드 --%>
			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">!</span>
					<span class="kpi-name">불량률</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.00</strong>
					<span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>검사 수량</span>
					<strong>0 kg</strong>
				</div>

				<div class="kpi-detail-row">
					<span>양품</span>
					<strong>0 kg</strong>
				</div>

				<div class="kpi-detail-row">
					<span>불량</span>
					<strong class="danger-text">0 kg</strong>
				</div>
			</div>

			<%-- 원가 편차율 카드 --%>
			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">▣</span>
					<span class="kpi-name">원가 편차율</span>
				</div>

				<div class="kpi-value-box">
					<strong class="kpi-value">0.00</strong>
					<span class="kpi-unit">%</span>
				</div>

				<div class="kpi-detail-row">
					<span>표준단가</span>
					<strong>0 원/kg</strong>
				</div>

				<div class="kpi-detail-row">
					<span>실제단가</span>
					<strong>0 원/kg</strong>
				</div>
			</div>

			<%-- 일일생산평가 카드 --%>
			<div class="kpi-card">
				<div class="kpi-card-top">
					<span class="kpi-icon">👤</span>
					<span class="kpi-name">일일생산평가</span>
				</div>

				<div class="kpi-empty-box">
					<span>금일 생산 평가 데이터 준비중</span>
				</div>
			</div>

		</div>
	</div>

	<%-- 최근 7일 추이 그래프 영역이다. 지금은 그래프 박스 위치만 먼저 잡는다. --%>
	<div class="dashboard-section">
		<div class="section-title-box">
			<h3 class="section-title">생산 / 품질 / 출하 / 생산원가 추이</h3>
			<span class="section-badge">최근 7일 추이도</span>
		</div>

		<div class="chart-grid">

	<%-- 생산 추이 그래프 카드이다. --%>
	<div class="chart-card">
		<h4>생산 추이</h4>
		<p>일자별 생산실적 기준</p>

		<%-- 
			현재는 DB 연결 전이라 SVG로 임시 그래프를 그려둔다.
			나중에 DB에서 최근 7일 생산량을 가져오면 Chart.js 또는 Ajax 데이터로 교체할 예정이다.
		--%>
		<div class="chart-placeholder">
			<svg class="mini-chart" viewBox="0 0 320 180">

				<%-- 그래프 배경 가로선이다. --%>
				<line x1="30" y1="30" x2="300" y2="30" />
				<line x1="30" y1="65" x2="300" y2="65" />
				<line x1="30" y1="100" x2="300" y2="100" />
				<line x1="30" y1="135" x2="300" y2="135" />

				<%-- 생산량 흐름을 보여주는 선이다. --%>
				<polyline class="chart-line blue-line"
					points="35,115 78,95 121,86 164,108 207,78 250,92 293,112" />

				<%-- 각 일자별 지점이다. --%>
				<circle class="blue-dot" cx="35" cy="115" r="4" />
				<circle class="blue-dot" cx="78" cy="95" r="4" />
				<circle class="blue-dot" cx="121" cy="86" r="4" />
				<circle class="blue-dot" cx="164" cy="108" r="4" />
				<circle class="blue-dot" cx="207" cy="78" r="4" />
				<circle class="blue-dot" cx="250" cy="92" r="4" />
				<circle class="blue-dot" cx="293" cy="112" r="4" />

				<%-- 하단 날짜 표시이다. --%>
				<text x="25" y="165">05-06</text>
				<text x="70" y="165">05-07</text>
				<text x="115" y="165">05-08</text>
				<text x="160" y="165">05-09</text>
				<text x="205" y="165">05-10</text>
				<text x="250" y="165">05-11</text>
				<text x="285" y="165">05-14</text>
			</svg>
		</div>
	</div>

	<%-- 품질 추이 그래프 카드이다. --%>
	<div class="chart-card">
		<h4>품질 추이</h4>
		<p>일자별 불량률 기준</p>

		<div class="chart-placeholder">
			<svg class="mini-chart" viewBox="0 0 320 180">

				<%-- 그래프 배경 가로선이다. --%>
				<line x1="30" y1="30" x2="300" y2="30" />
				<line x1="30" y1="65" x2="300" y2="65" />
				<line x1="30" y1="100" x2="300" y2="100" />
				<line x1="30" y1="135" x2="300" y2="135" />

				<%-- 불량률 흐름을 보여주는 선이다. --%>
				<polyline class="chart-line green-line"
					points="35,75 78,82 121,96 164,65 207,52 250,70 293,78" />

				<circle class="green-dot" cx="35" cy="75" r="4" />
				<circle class="green-dot" cx="78" cy="82" r="4" />
				<circle class="green-dot" cx="121" cy="96" r="4" />
				<circle class="green-dot" cx="164" cy="65" r="4" />
				<circle class="green-dot" cx="207" cy="52" r="4" />
				<circle class="green-dot" cx="250" cy="70" r="4" />
				<circle class="green-dot" cx="293" cy="78" r="4" />

				<text x="25" y="165">05-06</text>
				<text x="70" y="165">05-07</text>
				<text x="115" y="165">05-08</text>
				<text x="160" y="165">05-09</text>
				<text x="205" y="165">05-10</text>
				<text x="250" y="165">05-11</text>
				<text x="285" y="165">05-14</text>
			</svg>
		</div>
	</div>

	<%-- 출하 추이 그래프 카드이다. --%>
	<div class="chart-card">
		<h4>출하 추이</h4>
		<p>일자별 출하수량 기준</p>

		<div class="chart-placeholder">
			<svg class="mini-chart" viewBox="0 0 320 180">

				<%-- 그래프 배경 가로선이다. --%>
				<line x1="30" y1="30" x2="300" y2="30" />
				<line x1="30" y1="65" x2="300" y2="65" />
				<line x1="30" y1="100" x2="300" y2="100" />
				<line x1="30" y1="135" x2="300" y2="135" />

				<%-- 출하량 흐름을 보여주는 선이다. --%>
				<polyline class="chart-line blue-line"
					points="35,118 78,102 121,92 164,108 207,96 250,88 293,115" />

				<circle class="blue-dot" cx="35" cy="118" r="4" />
				<circle class="blue-dot" cx="78" cy="102" r="4" />
				<circle class="blue-dot" cx="121" cy="92" r="4" />
				<circle class="blue-dot" cx="164" cy="108" r="4" />
				<circle class="blue-dot" cx="207" cy="96" r="4" />
				<circle class="blue-dot" cx="250" cy="88" r="4" />
				<circle class="blue-dot" cx="293" cy="115" r="4" />

				<text x="25" y="165">05-06</text>
				<text x="70" y="165">05-07</text>
				<text x="115" y="165">05-08</text>
				<text x="160" y="165">05-09</text>
				<text x="205" y="165">05-10</text>
				<text x="250" y="165">05-11</text>
				<text x="285" y="165">05-14</text>
			</svg>
		</div>
	</div>

	<%-- 생산원가 추이 그래프 카드이다. --%>
	<div class="chart-card">
		<h4>생산원가 추이</h4>
		<p>일자별 평균 생산단가 기준</p>

		<div class="chart-placeholder">
			<svg class="mini-chart" viewBox="0 0 320 180">

				<%-- 그래프 배경 가로선이다. --%>
				<line x1="30" y1="30" x2="300" y2="30" />
				<line x1="30" y1="65" x2="300" y2="65" />
				<line x1="30" y1="100" x2="300" y2="100" />
				<line x1="30" y1="135" x2="300" y2="135" />

				<%-- 생산원가 흐름을 보여주는 선이다. --%>
				<polyline class="chart-line orange-line"
					points="35,78 78,84 121,92 164,100 207,92 250,84 293,76" />

				<circle class="orange-dot" cx="35" cy="78" r="4" />
				<circle class="orange-dot" cx="78" cy="84" r="4" />
				<circle class="orange-dot" cx="121" cy="92" r="4" />
				<circle class="orange-dot" cx="164" cy="100" r="4" />
				<circle class="orange-dot" cx="207" cy="92" r="4" />
				<circle class="orange-dot" cx="250" cy="84" r="4" />
				<circle class="orange-dot" cx="293" cy="76" r="4" />

				<text x="25" y="165">05-06</text>
				<text x="70" y="165">05-07</text>
				<text x="115" y="165">05-08</text>
				<text x="160" y="165">05-09</text>
				<text x="205" y="165">05-10</text>
				<text x="250" y="165">05-11</text>
				<text x="285" y="165">05-14</text>
			</svg>
		</div>
	</div>

</div>
	</div>

	<%-- 하단 영역이다. MES 운영 흐름, 오늘 알림, 최근 작업지시, 공지사항이 들어간다. --%>
	<div class="bottom-grid">

		<%-- 왼쪽 큰 영역이다. MES 운영 흐름과 최근 작업지시를 세로로 배치한다. --%>
		<div class="bottom-left">

			<div class="dashboard-section">
				<div class="section-title-box">
					<h3 class="section-title">MES 운영 흐름</h3>
				</div>

				<div class="flow-grid">

					<div class="flow-card">
						<strong>자재관리</strong>
						<span>입고 28건</span>
						<span>재고 부족 22건</span>
					</div>

					<div class="flow-card">
						<strong>생산계획</strong>
						<span>계획 15,000 EA</span>
						<span>지시 12,500 EA</span>
					</div>

					<div class="flow-card">
						<strong>작업지시</strong>
						<span>진행중 12건</span>
						<span>대기 6건</span>
					</div>

					<div class="flow-card">
						<strong>공정관리</strong>
						<span>검사 진행 15건</span>
						<span>불량 수량 12 EA</span>
					</div>

					<div class="flow-card">
						<strong>생산실적</strong>
						<span>지시량 12,500 EA</span>
						<span>오늘 실적 7,850 EA</span>
					</div>

					<div class="flow-card">
						<strong>출하관리</strong>
						<span>출하 대기 5건</span>
						<span>출하 완료 6건</span>
					</div>

				</div>
			</div>

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

		<%-- 오른쪽 작은 영역이다. 오늘 알림과 공지사항을 세로로 배치한다. --%>
		<div class="bottom-right">

			<div class="dashboard-section">
				<div class="section-title-box">
					<h3 class="section-title">오늘 알림</h3>
					<a href="#" class="more-link">더보기</a>
				</div>

				<ul class="alert-list">
					<li>
						<strong>설비 점검 예정</strong>
						<span>MC #03 정기 점검 예정</span>
						<em>09:00</em>
					</li>
					<li>
						<strong>자재 부족 알림</strong>
						<span>EPDM-011 재고 부족</span>
						<em>08:30</em>
					</li>
				</ul>
			</div>

			<div class="dashboard-section">
				<div class="section-title-box">
					<h3 class="section-title">공지사항</h3>
					<a href="#" class="more-link">더보기</a>
				</div>

				<ul class="notice-list">
					<li>
						<span>5월 설비 점검 일정 안내</span>
						<em>2025.05.07</em>
					</li>
					<li>
						<span>품질 기준 변경 안내</span>
						<em>2025.05.02</em>
					</li>
					<li>
						<span>근로자의 날 휴무 안내</span>
						<em>2025.04.29</em>
					</li>
				</ul>
			</div>

		</div>

	</div>

</section>