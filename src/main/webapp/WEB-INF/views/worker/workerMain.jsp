<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<div class="workerPage">

	<!-- =====================================================
		헤더
	===================================================== -->
	<div class="workerHeader">

		<!-- =================================================
			좌측 로고
		================================================= -->
		<div class="workerLogoBox">

			<div class="workerLogoIcon">

				<img src="${pageContext.request.contextPath}/resources/saeroi_logo.png"
					class="headerLogoImg"
					alt="로고">

			</div>

			<div class="workerLogoText"> 

				MES 작업자 화면

			</div>

		</div>

		<!-- =================================================
			우측 정보
		================================================= -->
		<div class="workerHeaderRight">

			<!-- =============================================
				프로필 클릭 시 마이페이지 이동
			============================================= -->
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

				↻ 로그아웃

			</button>

		</div>

	</div>

	<!-- =====================================================
		컨텐츠
	===================================================== -->
	<div class="workerContent">

		<!-- =================================================
			타이틀
		================================================= -->
		<div class="workerTitleArea">

			<div class="workerTitleBar"></div>

			<div>

				<h2 class="workerMainTitle">

					작업자 메인

				</h2>

				<p class="workerSubTitle">

					QR 스캔 및 작업 메뉴

				</p>

			</div>

		</div>

		<!-- =================================================
			QR 영역
		================================================= -->
		<div class="workerQrSection">

			<div class="workerQrLeft">

				<div class="qrCodeBox">

					<div class="qrCorner topLeft"></div>
					<div class="qrCorner topRight"></div>
					<div class="qrCorner bottomLeft"></div>
					<div class="qrCorner bottomRight"></div>

					<!-- =========================================
						실제 QR 이미지
					========================================= -->
					<img src="${pageContext.request.contextPath}/resources/real-qr.png"
						class="realQrImg"
						alt="QR">

					<div class="scanLine"></div>

				</div>

			</div>

			<div class="workerQrCenterLine"></div>

			<div class="workerQrRight">

				<h3 class="qrTitle">

					QR을 스캔하세요

				</h3>

				<p class="qrDesc">

					작업 지시, 자재, 제품 등의 QR을 스캔하여
					작업을 시작합니다.

				</p>

				<button type="button"
					class="workerQrBtn">

					<svg viewBox="0 0 24 24"
						class="qrScanSvg">

						<path
							d="M4 4H9V6H6V9H4V4ZM15 4H20V9H18V6H15V4ZM4 15H6V18H9V20H4V15ZM18 15H20V20H15V18H18V15Z"
							fill="white"/>

					</svg>

					<span>
						QR 스캔
					</span>

				</button>

			</div>

		</div>

		<!-- =================================================
			카드 영역
		================================================= -->
		<div class="workerCardWrap">

			<!-- =============================================
				작업지시 조회 카드
			============================================= -->
			<div class="workerCard"
				onclick="location.href='${pageContext.request.contextPath}/production/workorder'"
				style="cursor:pointer;">

				<div class="workerIconCircle">

					<svg viewBox="0 0 24 24"
						class="menuSvgIcon">

						<path
							d="M7 2H17V4H21V22H3V4H7V2ZM5 6V20H19V6H5ZM8 9H16V11H8V9ZM8 13H16V15H8V13Z"
							fill="#2f7d62"/>

					</svg>

				</div>

				<h3 class="workerCardTitle">

					작업지시 조회

				</h3>

				<p class="workerCardDesc">

					진행 중인 작업지시를 확인합니다.

				</p>

				<button type="button"
					class="workerMoveBtn"
					onclick="location.href='${pageContext.request.contextPath}/production/workorder'">

					→

				</button>

			</div>

			<!-- =============================================
				생산실적 등록 카드
				작업자 전용 생산실적 페이지 이동
			============================================= -->
			<div class="workerCard"
				onclick="location.href='${pageContext.request.contextPath}/worker/productionresult'"
				style="cursor:pointer;">

				<div class="workerIconCircle">

					<svg viewBox="0 0 24 24"
						class="menuSvgIcon">

						<path
							d="M4 19H20V21H2V3H4V19ZM7 17V10H10V17H7ZM12 17V6H15V17H12ZM17 17V13H20V17H17Z"
							fill="#2f7d62"/>

					</svg>

				</div>

				<h3 class="workerCardTitle">

					생산실적 등록

				</h3>

				<p class="workerCardDesc">

					일별 생산 실적 및 현황을 등록합니다.

				</p>

				<!-- =========================================
					버튼 클릭 시 작업자 생산실적 이동
				========================================= -->
				<button type="button"
					class="workerMoveBtn"
					onclick="location.href='${pageContext.request.contextPath}/worker/productionresult'">

					→

				</button>

			</div>

			<!-- =============================================
				공지사항 / 게시판 카드
				현재 공지사항 페이지로 이동
			============================================= -->
			<div class="workerCard"
				onclick="location.href='${pageContext.request.contextPath}/notice/list'"
				style="cursor:pointer;">

				<div class="workerIconCircle">

					<svg viewBox="0 0 24 24"
						class="menuSvgIcon">

						<path
							d="M12 22C13.1 22 14 21.1 14 20H10C10 21.1 10.9 22 12 22ZM18 16V11C18 7.93 16.36 5.36 13.5 4.68V4C13.5 3.17 12.83 2.5 12 2.5C11.17 2.5 10.5 3.17 10.5 4V4.68C7.63 5.36 6 7.92 6 11V16L4 18V19H20V18L18 16Z"
							fill="#2f7d62"/>

					</svg>

				</div>

				<h3 class="workerCardTitle">

					공지사항 / 게시판 확인

				</h3>

				<p class="workerCardDesc">

					공지사항 및 게시판 내용을 확인합니다.

				</p>

				<button type="button"
					class="workerMoveBtn"
					onclick="location.href='${pageContext.request.contextPath}/notice/list'">

					→

				</button>

			</div>

		</div>

	</div>

</div>

<style>

	:root {

		--mainColor: #2f7d62;
		--mainHover: #256851;
		--lightGreen: #eef7f2;
	}

	* {

		box-sizing: border-box;
		margin: 0;
		padding: 0;
	}

	body {

		background: #f7f8f9;
		font-family: 'Pretendard';
	}

	.workerPage {

		width: 100%;
		min-height: 100vh;
	}

	/* =====================================================
		헤더
	===================================================== */
	.workerHeader {

		height: 72px;

		padding: 0 28px;

		display: flex;
		align-items: center;
		justify-content: space-between;

		background: #fff;

		border-bottom: 2px solid var(--mainColor);
	}

	.workerLogoBox {

		display: flex;
		align-items: center;

		gap: 14px;
	}

	.headerLogoImg {

		width: 34px;
		height: 34px;

		object-fit: contain;
		display: block;
	}

	.workerLogoText {

		font-size: 18px;
		font-weight: 700;
	}

	.workerHeaderRight {

		display: flex;
		align-items: center;

		gap: 14px;
	}

	/* =====================================================
		프로필
	===================================================== */
	.workerProfileBox {

		display: flex;
		align-items: center;

		gap: 8px;

		font-size: 14px;
		font-weight: 600;

		cursor: pointer;
	}

	.workerProfileImg {

		width: 30px;
		height: 30px;

		border-radius: 50%;

		object-fit: cover;
		display: block;
	}

	.workerInfoItem {

		font-size: 14px;
		color: #222;
	}

	.workerInfoBar {

		width: 1px;
		height: 16px;

		background: #ddd;
	}

	.workerLogoutBtn {

		border: none;
		background: transparent;

		font-size: 14px;
		font-weight: 700;

		cursor: pointer;

		color: #111;
	}

	.workerLogoutBtn:hover {

		color: var(--mainColor);
	}

	/* =====================================================
		컨텐츠
	===================================================== */
	.workerContent {

		padding: 34px 32px;
	}

	/* =====================================================
		타이틀
	===================================================== */
	.workerTitleArea {

		display: flex;
		align-items: flex-start;

		gap: 18px;

		margin-bottom: 30px;
	}

	.workerTitleBar {

		width: 7px;
		height: 50px;

		border-radius: 10px;

		background: var(--mainColor);
	}

	.workerMainTitle {

		font-size: 34px;
		font-weight: 800;

		margin-bottom: 10px;
	}

	.workerSubTitle {

		font-size: 18px;
		color: #666;
	}

	/* =====================================================
		QR 영역
	===================================================== */
	.workerQrSection {

		display: flex;
		align-items: center;
		justify-content: space-between;

		padding: 34px 40px;

		background: #fff;

		border: 2px solid var(--mainColor);
		border-radius: 22px;

		margin-bottom: 28px;
	}

	.workerQrLeft {

		width: 38%;

		display: flex;
		justify-content: center;
	}

	.workerQrCenterLine {

		width: 1px;
		height: 230px;

		background: #ddd;
	}

	.workerQrRight {

		width: 48%;
	}

	.qrCodeBox {

		position: relative;

		width: 280px;
		height: 280px;

		display: flex;
		align-items: center;
		justify-content: center;
	}

	/* =====================================================
		실제 QR 이미지
	===================================================== */
	.realQrImg {

		width: 170px;
		height: 170px;

		object-fit: contain;

		display: block;

		position: relative;
		z-index: 1;
	}

	.scanLine {

		position: absolute;

		width: 190px;
		height: 6px;

		top: 50%;

		background: rgba(47,125,98,0.35);

		box-shadow: 0 0 18px #57ff9f;

		animation: scanMove 2s linear infinite;

		z-index: 2;
	}

	@keyframes scanMove {

		0% {

			transform: translateY(-70px);
		}

		100% {

			transform: translateY(70px);
		}
	}

	.qrCorner {

		position: absolute;

		width: 34px;
		height: 34px;

		border-color: var(--mainColor);
		border-style: solid;

		z-index: 3;
	}

	.topLeft {

		top: 22px;
		left: 22px;

		border-width: 5px 0 0 5px;
	}

	.topRight {

		top: 22px;
		right: 22px;

		border-width: 5px 5px 0 0;
	}

	.bottomLeft {

		bottom: 22px;
		left: 22px;

		border-width: 0 0 5px 5px;
	}

	.bottomRight {

		bottom: 22px;
		right: 22px;

		border-width: 0 5px 5px 0;
	}

	.qrTitle {

		font-size: 38px;
		font-weight: 800;

		color: var(--mainColor);

		margin-bottom: 20px;
	}

	.qrDesc {

		font-size: 20px;
		line-height: 1.7;

		color: #444;

		margin-bottom: 28px;
	}

	/* =====================================================
		QR 버튼
	===================================================== */
	.workerQrBtn {

		width: 100%;
		height: 88px;

		border: none;
		border-radius: 14px;

		background: var(--mainColor);

		display: flex;
		align-items: center;
		justify-content: center;

		gap: 18px;

		cursor: pointer;
	}

	.workerQrBtn:hover {

		background: var(--mainHover);
	}

	.qrScanSvg {

		width: 52px;
		height: 52px;
	}

	.workerQrBtn span {

		font-size: 38px;
		font-weight: 800;

		color: #fff;
	}

	/* =====================================================
		카드
	===================================================== */
	.workerCardWrap {

		display: flex;
		gap: 24px;
	}

	.workerCard {

		flex: 1;

		background: #fff;

		border-radius: 18px;

		padding: 34px 26px;

		text-align: center;

		position: relative;

		box-shadow: 0 2px 12px rgba(0,0,0,0.08);
	}

	.workerIconCircle {

		width: 100px;
		height: 100px;

		margin: 0 auto 22px;

		border-radius: 50%;

		background: var(--lightGreen);

		display: flex;
		align-items: center;
		justify-content: center;
	}

	.menuSvgIcon {

		width: 58px;
		height: 58px;
	}

	.workerCardTitle {

		font-size: 22px;
		font-weight: 800;

		margin-bottom: 12px;
	}

	.workerCardDesc {

		font-size: 15px;
		line-height: 1.6;

		color: #666;
	}

	.workerMoveBtn {

		position: absolute;

		right: 22px;
		bottom: 22px;

		width: 48px;
		height: 48px;

		border: none;
		border-radius: 50%;

		background: var(--mainColor);
		color: #fff;

		font-size: 22px;
		font-weight: bold;

		cursor: pointer;
	}

	.workerMoveBtn:hover {

		background: var(--mainHover);
	}

</style>

<script>

	// =====================================================
	// 현재 시간 출력
	// =====================================================
	function updateClock() {

		var now =
			new Date();

		var year =
			now.getFullYear();

		var month =
			String(now.getMonth() + 1)
				.padStart(2, '0');

		var date =
			String(now.getDate())
				.padStart(2, '0');

		var hour =
			String(now.getHours())
				.padStart(2, '0');

		var minute =
			String(now.getMinutes())
				.padStart(2, '0');

		var second =
			String(now.getSeconds())
				.padStart(2, '0');

		var currentTime =
			year + "-"
			+ month + "-"
			+ date + " "
			+ hour + ":"
			+ minute + ":"
			+ second;

		document.getElementById(
			"workerClock").innerText =
				currentTime;
	}

	updateClock();

	setInterval(updateClock, 1000);

</script>