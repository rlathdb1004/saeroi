<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/worker.css">

<div class="workerPage workerKioskPage">

	<!-- 작업자 화면 상단 헤더다. -->
	<div class="workerHeader">

		<div class="workerLogoBox">

			<img src="${pageContext.request.contextPath}/resources/saeroi_logo.png"
				class="headerLogoImg"
				alt="로고">

			<div class="workerLogoTextBox">

				<div class="workerLogoText">
					SAEROI MES
				</div>

				<div class="workerLogoSubText">
					작업자 메인
				</div>

			</div>

		</div>

		<div class="workerHeaderRight">

			<div class="workerProfileBox"
				onclick="location.href='${pageContext.request.contextPath}/mypage'">

				<img src="${pageContext.request.contextPath}/resources/kim.png"
					class="workerProfileImg"
					alt="프로필">

				<span>
					${workerName} 작업자
				</span>

			</div>

			<div class="workerInfoBar"></div>

			<div class="workerInfoItem">
				${workerDept}
			</div>

			<div class="workerInfoBar"></div>

			<div class="workerInfoItem">
				☀ 23.8℃
			</div>

			<div class="workerInfoBar"></div>

			<div class="workerInfoItem">

				🕒
				<span id="workerClock"></span>

			</div>

			<div class="workerInfoBar"></div>

			<button type="button"
				class="workerLogoutBtn"
				onclick="location.href='${pageContext.request.contextPath}/logout'">

				<svg viewBox="0 0 24 24"
					class="workerLogoutSvg"
					fill="none"
					xmlns="http://www.w3.org/2000/svg">

					<path
						d="M10 7V5C10 3.9 10.9 3 12 3H18C19.1 3 20 3.9 20 5V19C20 20.1 19.1 21 18 21H12C10.9 21 10 20.1 10 19V17"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round" />

					<path
						d="M15 12H4"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round" />

					<path
						d="M7 8L3 12L7 16"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round" />

				</svg>

				<span>
					로그아웃
				</span>

			</button>

		</div>

	</div>

	<!-- 작업자 메인 컨텐츠다. -->
	<div class="workerKioskContent">

		<!-- 왼쪽 QR 스캔 패널이다. -->
		<div class="workerScanPanel"
			onclick="startWorkerQrScan()">

			<div class="workerScanTopGuide">
			
<!-- QR 터치 안내 손모양 SVG 아이콘이다. -->
<svg viewBox="0 0 24 24"
	class="workerGuideSvg"
	xmlns="http://www.w3.org/2000/svg"
	aria-hidden="true">

	<!-- 터치 표시 점이다. -->
	<circle cx="7.5" cy="4.5" r="1.1" fill="currentColor" />
	<circle cx="11.5" cy="3.5" r="1.2" fill="currentColor" />
	<circle cx="15.5" cy="4.8" r="1.1" fill="currentColor" />

	<!-- 손 터치 아이콘이다. -->
	<path
		d="M9 11.2V7.5C9 6.1 10.1 5 11.5 5C12.9 5 14 6.1 14 7.5V11.2C15.2 10.4 16 9 16 7.5C16 5 14 3 11.5 3C9 3 7 5 7 7.5C7 9 7.8 10.4 9 11.2Z"
		fill="currentColor" />

	<path
		d="M18.8 15.9L14.3 13.6C14.1 13.5 13.9 13.5 13.7 13.5H13V7.5C13 6.7 12.3 6 11.5 6C10.7 6 10 6.7 10 7.5V18.2L6.6 17.5C6.5 17.5 6.4 17.5 6.3 17.5C6 17.5 5.7 17.6 5.5 17.8L4.7 18.6L9.7 23.6C10 23.9 10.3 24 10.7 24H17.5C18.2 24 18.9 23.5 19 22.8L19.8 17.5C19.8 17.4 19.8 17.3 19.8 17.2C19.8 16.7 19.5 16.2 18.8 15.9Z"
		fill="currentColor" />

</svg>
	


	<span>
		QR 영역을 터치하면 스캔이 시작됩니다
	</span>

</div>

			<h1 class="workerScanTitle">

				QR을 스캔하여<br>
				작업을 시작하세요

			</h1>

			<div class="workerQrStage">

				<div class="qrCorner topLeft"></div>
				<div class="qrCorner topRight"></div>
				<div class="qrCorner bottomLeft"></div>
				<div class="qrCorner bottomRight"></div>

				<div class="workerQrWhiteBox">

					<!-- 화면 표시용 SVG QR 코드다. 실제 스캔용 QR은 추후 별도 생성한다. -->
					<svg class="realQrImg"
						viewBox="0 0 23 23"
						xmlns="http://www.w3.org/2000/svg"
						role="img"
						aria-label="QR 코드"
						shape-rendering="crispEdges"
						focusable="false">

						<rect x="0" y="0" width="23" height="23" fill="#ffffff" />

						<path fill="#000000"
							d="M1 1h7v1H1z M9 1h2v1H9z M12 1h1v1H12z M15 1h7v1H15z M1 2h1v1H1z M7 2h1v1H7z M9 2h3v1H9z M15 2h1v1H15z M21 2h1v1H21z M1 3h1v1H1z M3 3h3v1H3z M7 3h1v1H7z M10 3h2v1H10z M13 3h1v1H13z M15 3h1v1H15z M17 3h3v1H17z M21 3h1v1H21z M1 4h1v1H1z M3 4h3v1H3z M7 4h1v1H7z M9 4h1v1H9z M12 4h1v1H12z M15 4h1v1H15z M17 4h3v1H17z M21 4h1v1H21z M1 5h1v1H1z M3 5h3v1H3z M7 5h1v1H7z M10 5h2v1H10z M15 5h1v1H15z M17 5h3v1H17z M21 5h1v1H21z M1 6h1v1H1z M7 6h1v1H7z M10 6h2v1H10z M15 6h1v1H15z M21 6h1v1H21z M1 7h7v1H1z M9 7h1v1H9z M11 7h1v1H11z M13 7h1v1H13z M15 7h7v1H15z M9 8h1v1H9z M1 9h1v1H1z M3 9h2v1H3z M6 9h3v1H6z M11 9h1v1H11z M15 9h1v1H15z M18 9h1v1H18z M20 9h2v1H20z M3 10h3v1H3z M10 10h2v1H10z M13 10h1v1H13z M17 10h3v1H17z M21 10h1v1H21z M1 11h4v1H1z M7 11h2v1H7z M11 11h1v1H11z M13 11h1v1H13z M16 11h1v1H16z M20 11h2v1H20z M3 12h3v1H3z M8 12h2v1H8z M13 12h1v1H13z M16 12h1v1H16z M21 12h1v1H21z M1 13h1v1H1z M4 13h2v1H4z M7 13h1v1H7z M9 13h1v1H9z M12 13h1v1H12z M16 13h1v1H16z M20 13h2v1H20z M9 14h1v1H9z M11 14h1v1H11z M14 14h1v1H14z M16 14h1v1H16z M18 14h1v1H18z M21 14h1v1H21z M1 15h7v1H1z M9 15h3v1H9z M16 15h4v1H16z M21 15h1v1H21z M1 16h1v1H1z M7 16h1v1H7z M9 16h2v1H9z M12 16h2v1H12z M15 16h2v1H15z M19 16h1v1H19z M21 16h1v1H21z M1 17h1v1H1z M3 17h3v1H3z M7 17h1v1H7z M10 17h1v1H10z M12 17h1v1H12z M15 17h3v1H15z M20 17h2v1H20z M1 18h1v1H1z M3 18h3v1H3z M7 18h1v1H7z M9 18h2v1H9z M14 18h1v1H14z M20 18h1v1H20z M1 19h1v1H1z M3 19h3v1H3z M7 19h1v1H7z M9 19h4v1H9z M16 19h2v1H16z M1 20h1v1H1z M7 20h1v1H7z M12 20h2v1H12z M15 20h1v1H15z M17 20h3v1H17z M1 21h7v1H1z M9 21h1v1H9z M11 21h4v1H11z M18 21h3v1H18z" />

						<!-- QR 중앙 로고 배경이다. -->
						<rect x="8.3"
							y="8.5"
							width="6.4"
							height="5.7"
							rx="0.7"
							fill="#ffffff" />

						<!-- QR 중앙 새로이 로고다. -->
						<image href="${pageContext.request.contextPath}/resources/saeroi_logo.png"
							x="8.8"
							y="9.0"
							width="5.4"
							height="4.7"
							preserveAspectRatio="xMidYMid meet" />

					</svg>

				</div>

				<div class="scanLine"></div>

			</div>

			<button type="button"
				class="workerScanStartBtn"
				onclick="event.stopPropagation(); startWorkerQrScan();">

				<svg viewBox="0 0 24 24"
					class="workerScanBtnIcon">

					<path
						d="M4 4H9V6H6V9H4V4ZM15 4H20V9H18V6H15V4ZM4 15H6V18H9V20H4V15ZM18 15H20V20H15V18H18V15Z"
						fill="currentColor" />

				</svg>

				<span>
					QR 스캔 시작
				</span>

				<span class="workerScanBtnArrow">
					›
				</span>

			</button>

			<p class="workerScanHelpText">
				ⓘ 작업 지시, 자재, 제품 등의 QR을 스캔하세요.
			</p>

		</div>

		<!-- 오른쪽 작업 메뉴 영역이다. -->
		<div class="workerRightPanel">

			<div class="workerMenuList">

				<div class="workerMenuCard"
					onclick="location.href='${pageContext.request.contextPath}/production/workorder'">

					<div class="workerMenuIconCircle">

						<svg viewBox="0 0 24 24"
							class="menuSvgIcon">

							<path
								d="M7 2H17V4H21V22H3V4H7V2ZM5 6V20H19V6H5ZM8 9H16V11H8V9ZM8 13H16V15H8V13Z"
								fill="currentColor" />

						</svg>

					</div>

					<div class="workerMenuTextBox">

						<h3>
							작업지시 조회
						</h3>

						<p>
							진행 중인 작업지시를 확인합니다.
						</p>

					</div>

					<div class="workerMenuNo">
						01
					</div>

					<button type="button"
						class="workerMenuArrowBtn"
						onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/production/workorder'">

						›

					</button>

				</div>

				<div class="workerMenuCard"
					onclick="location.href='${pageContext.request.contextPath}/worker/productionresult'">

					<div class="workerMenuIconCircle">

						<svg viewBox="0 0 24 24"
							class="menuSvgIcon">

							<path
								d="M4 19H20V21H2V3H4V19ZM7 17V10H10V17H7ZM12 17V6H15V17H12ZM17 17V13H20V17H17Z"
								fill="currentColor" />

						</svg>

					</div>

					<div class="workerMenuTextBox">

						<h3>
							생산실적 등록
						</h3>

						<p>
							일별 생산 실적 및 현황을 등록합니다.
						</p>

					</div>

					<div class="workerMenuNo">
						02
					</div>

					<button type="button"
						class="workerMenuArrowBtn"
						onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/worker/productionresult'">

						›

					</button>

				</div>

				<div class="workerMenuCard"
					onclick="location.href='${pageContext.request.contextPath}/notice/list'">

					<div class="workerMenuIconCircle">

						<svg viewBox="0 0 24 24"
							class="menuSvgIcon">

							<path
								d="M12 22C13.1 22 14 21.1 14 20H10C10 21.1 10.9 22 12 22ZM18 16V11C18 7.93 16.36 5.36 13.5 4.68V4C13.5 3.17 12.83 2.5 12 2.5C11.17 2.5 10.5 3.17 10.5 4V4.68C7.63 5.36 6 7.92 6 11V16L4 18V19H20V18L18 16Z"
								fill="currentColor" />

						</svg>

					</div>

					<div class="workerMenuTextBox">

						<h3>
							공지사항 / 게시판 확인
						</h3>

						<p>
							공지사항 및 게시판 내용을 확인합니다.
						</p>

					</div>

					<div class="workerMenuNo">
						03
					</div>

					<button type="button"
						class="workerMenuArrowBtn"
						onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/notice/list'">

						›

					</button>

				</div>

			</div>

			<!-- 오늘 작업 현황 영역이다. -->
			<div class="workerTodayBox">

				<div class="workerTodayHeader">

					<h3>
						오늘 작업 현황
					</h3>

					<button type="button"
						class="workerTodayTimeBtn"
						onclick="updateTodayStandardTime()">

						<svg viewBox="0 0 24 24"
							class="workerTodayRefreshSvg"
							fill="none"
							xmlns="http://www.w3.org/2000/svg">

							<path
								d="M20 11C19.76 8.65 18.32 6.57 16.18 5.54C13.14 4.08 9.48 5.05 7.57 7.82"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round" />

							<path
								d="M7 4V8H11"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round" />

							<path
								d="M4 13C4.24 15.35 5.68 17.43 7.82 18.46C10.86 19.92 14.52 18.95 16.43 16.18"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round" />

							<path
								d="M17 20V16H13"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round" />

						</svg>

						<span id="workerTodayTime"></span>
						<span>기준</span>

					</button>

				</div>

				<div class="workerTodayGrid">

					<div class="workerTodayItem">

						<div class="workerTodayIcon">

							<svg viewBox="0 0 24 24"
								class="workerTodayItemSvg">

								<path
									d="M7 2H17V4H21V22H3V4H7V2ZM5 6V20H19V6H5ZM8 9H16V11H8V9ZM8 13H16V15H8V13Z"
									fill="currentColor" />

							</svg>

						</div>

						<p>
							오늘 작업지시
						</p>

						<strong>
							5 건
						</strong>

					</div>

					<div class="workerTodayItem">

						<div class="workerProgressCircle">

							<span>
								72%
							</span>

						</div>

						<p>
							진행 상태
						</p>

						<strong>
							진행 중
						</strong>

					</div>

					<div class="workerTodayItem">

						<div class="workerTodayIcon workerTodayAlertIcon">

							<svg viewBox="0 0 24 24"
								class="workerTodayItemSvg">

								<path
									d="M12 22C13.1 22 14 21.1 14 20H10C10 21.1 10.9 22 12 22ZM18 16V11C18 7.93 16.36 5.36 13.5 4.68V4C13.5 3.17 12.83 2.5 12 2.5C11.17 2.5 10.5 3.17 10.5 4V4.68C7.63 5.36 6 7.92 6 11V16L4 18V19H20V18L18 16Z"
									fill="currentColor" />

							</svg>

							<span class="workerAlertDot"></span>

						</div>

						<p>
							최근 알림
						</p>

						<strong>
							2 건
						</strong>

					</div>

				</div>

			</div>

		</div>

	</div>

	<!-- 작업자 하단 안전 안내 영역이다. -->
	<div class="workerSafetyNotice">

		<svg viewBox="0 0 24 24"
			class="workerSafetySvg">

			<path
				d="M12 2L20 5V11C20 16.2 16.6 20.8 12 22C7.4 20.8 4 16.2 4 11V5L12 2ZM12 4.2L6 6.45V11C6 15.15 8.55 18.85 12 19.9C15.45 18.85 18 15.15 18 11V6.45L12 4.2ZM15.65 8.7L16.95 10L11.25 15.7L8.05 12.5L9.35 11.2L11.25 13.1L15.65 8.7Z"
				fill="currentColor" />

		</svg>

		<span>
			안전 수칙을 준수하여 안전한 작업을 진행해 주세요.
		</span>

	</div>

</div>


<script>
	// 작업자 화면 브라우저 탭 제목과 파비콘을 기존 새로이 MES 기준으로 맞춘다.
	document.title = "SAEROI MES";

	(function () {

		var favicon = document.querySelector("link[rel='icon']");

		if (!favicon) {

			favicon = document.createElement("link");

			favicon.rel = "icon";

			document.head.appendChild(favicon);

		}

		// 기존 공통 layout.jsp와 동일하게 favicon.ico를 사용한다.
		favicon.type = "image/x-icon";

		favicon.href = "${pageContext.request.contextPath}/resources/favicon.ico?v=1";

	})();

	// 숫자가 한 자리일 때 앞에 0을 붙인다.
	function padTwo(value) {

		return String(value).padStart(2, '0');

	}

	// 현재 시간을 작업자 화면 상단에 출력한다.
	function updateClock() {

		var now = new Date();

		var year = now.getFullYear();

		var month = padTwo(now.getMonth() + 1);

		var date = padTwo(now.getDate());

		var hour = padTwo(now.getHours());

		var minute = padTwo(now.getMinutes());

		var second = padTwo(now.getSeconds());

		var currentTime = year + "-" + month + "-" + date + " " + hour + ":"
				+ minute + ":" + second;

		document.getElementById("workerClock").innerText = currentTime;
	}

	// 오늘 작업 현황 기준 시간을 컴퓨터 현재 시간으로 갱신한다.
	function updateTodayStandardTime() {

		var now = new Date();

		var hour = padTwo(now.getHours());

		var minute = padTwo(now.getMinutes());

		var second = padTwo(now.getSeconds());

		var todayTime = hour + ":" + minute + ":" + second + " ";

		document.getElementById("workerTodayTime").innerText = todayTime;
	}

	// QR 스캔 기능 연결 전까지 임시 안내를 출력한다.
	function startWorkerQrScan() {

		alert("QR 스캔 기능 연결 예정입니다.");

	}

	updateClock();

	updateTodayStandardTime();

	setInterval(updateClock, 1000);
</script>