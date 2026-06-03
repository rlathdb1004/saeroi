<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/worker.css">


<%-- =========================================================
	QR 카메라 스캔 화면
	공통 worker.css는 건드리지 않고, 작업자 메인 JSP 안에서만 적용한다.
	네이버 QR 스캔처럼 전체화면 카메라 + 중앙 스캔 프레임 + 스캔 라인으로 구성한다.
========================================================= --%>
<style>

	/* =====================================================
		QR 카메라 모달 전체 영역
	===================================================== */
	.workerQrCameraModal {

		display: none;
		position: fixed;
		inset: 0;
		z-index: 99999;
		background: #020806;
		overflow: hidden;
	}

	/* =====================================================
		카메라 영상
	===================================================== */
	.workerQrCameraVideo {

		width: 100%;
		height: 100%;
		object-fit: cover;
		background: #020806;
	}

	/* =====================================================
		카메라 위 어두운 오버레이
	===================================================== */
	.workerQrCameraDim {

		position: absolute;
		inset: 0;
		background: rgba(0, 0, 0, 0.28);
		pointer-events: none;
	}

	/* =====================================================
		상단 안내 영역
	===================================================== */
	.workerQrCameraTop {

		position: absolute;
		top: 26px;
		left: 24px;
		right: 24px;
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 14px;
		z-index: 2;
	}

	.workerQrCameraTitleBox {

		color: #ffffff;
		text-shadow: 0 2px 12px rgba(0, 0, 0, 0.55);
	}

	.workerQrCameraTitle {

		font-size: 26px;
		font-weight: 800;
		letter-spacing: -0.5px;
	}

	.workerQrCameraSubTitle {

		margin-top: 6px;
		font-size: 14px;
		font-weight: 600;
		opacity: 0.9;
	}

	/* =====================================================
		닫기 버튼
	===================================================== */
	.workerQrCameraCloseBtn {

		width: 48px;
		height: 48px;
		border: 1px solid rgba(255, 255, 255, 0.45);
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.18);
		color: #ffffff;
		font-size: 30px;
		line-height: 1;
		cursor: pointer;
		backdrop-filter: blur(8px);
	}

	/* =====================================================
		중앙 스캔 프레임
	===================================================== */
	.workerQrCameraFrame {

		position: absolute;
		top: 50%;
		left: 50%;
		width: 310px;
		height: 310px;
		transform: translate(-50%, -50%);
		border-radius: 28px;
		z-index: 2;
	}

	/* =====================================================
		스캔 프레임 모서리
	===================================================== */
	.workerQrCameraCorner {

		position: absolute;
		width: 58px;
		height: 58px;
		border-color: #65f0a5;
		border-style: solid;
		filter: drop-shadow(0 0 10px rgba(101, 240, 165, 0.85));
	}

	.workerQrCameraCorner.leftTop {

		top: 0;
		left: 0;
		border-width: 6px 0 0 6px;
		border-top-left-radius: 24px;
	}

	.workerQrCameraCorner.rightTop {

		top: 0;
		right: 0;
		border-width: 6px 6px 0 0;
		border-top-right-radius: 24px;
	}

	.workerQrCameraCorner.leftBottom {

		left: 0;
		bottom: 0;
		border-width: 0 0 6px 6px;
		border-bottom-left-radius: 24px;
	}

	.workerQrCameraCorner.rightBottom {

		right: 0;
		bottom: 0;
		border-width: 0 6px 6px 0;
		border-bottom-right-radius: 24px;
	}

	/* =====================================================
		움직이는 스캔 라인
	===================================================== */
	.workerQrCameraScanLine {

		position: absolute;
		left: 18px;
		right: 18px;
		top: 22px;
		height: 4px;
		border-radius: 999px;
		background: linear-gradient(
			90deg,
			rgba(101, 240, 165, 0),
			rgba(101, 240, 165, 1),
			rgba(101, 240, 165, 0)
		);
		box-shadow: 0 0 18px rgba(101, 240, 165, 0.95);
		animation: workerQrCameraScanMove 2s linear infinite;
	}

	@keyframes workerQrCameraScanMove {

		0% {
			top: 22px;
		}

		100% {
			top: 284px;
		}
	}

	/* =====================================================
		하단 상태 메시지
	===================================================== */
	.workerQrCameraGuide {

		position: absolute;
		left: 24px;
		right: 24px;
		bottom: 34px;
		z-index: 2;
		text-align: center;
		color: #ffffff;
	}

	.workerQrCameraGuideMain {

		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-height: 48px;
		padding: 0 22px;
		border-radius: 999px;
		background: rgba(0, 0, 0, 0.42);
		font-size: 16px;
		font-weight: 800;
		backdrop-filter: blur(8px);
	}

	.workerQrCameraGuideSub {

		margin-top: 12px;
		font-size: 13px;
		font-weight: 600;
		opacity: 0.9;
		text-shadow: 0 2px 8px rgba(0, 0, 0, 0.55);
	}

	/* =====================================================
		카메라 권한 / 오류 안내 박스
	===================================================== */
	.workerQrCameraMessageBox {

		display: none;
		position: absolute;
		left: 50%;
		top: 50%;
		width: min(420px, calc(100% - 48px));
		transform: translate(-50%, -50%);
		padding: 28px 24px;
		border-radius: 24px;
		background: #ffffff;
		color: #0b1f1a;
		text-align: center;
		z-index: 3;
		box-shadow: 0 18px 50px rgba(0, 0, 0, 0.34);
	}

	.workerQrCameraMessageTitle {

		font-size: 22px;
		font-weight: 900;
	}

	.workerQrCameraMessageText {

		margin-top: 12px;
		font-size: 14px;
		font-weight: 600;
		line-height: 1.6;
		color: #53635f;
	}

	.workerQrCameraMessageBtn {

		margin-top: 20px;
		width: 100%;
		height: 46px;
		border: none;
		border-radius: 12px;
		background: #2f876b;
		color: #ffffff;
		font-size: 15px;
		font-weight: 800;
		cursor: pointer;
	}


	/* =====================================================
		같은 PC 화면에서 QR을 테스트하기 위한 버튼
		PC 웹캠은 현재 모니터 화면을 직접 볼 수 없기 때문에,
		시연/개발 중에는 이 버튼으로 현재 화면 QR 동작을 바로 확인한다.
		공통 CSS는 건드리지 않고 workerMain.jsp 안에서만 적용한다.
	===================================================== */
	.workerQrCameraTestBtn {

		margin-top: 14px;
		min-width: 260px;
		height: 48px;
		border: 1px solid rgba(255, 255, 255, 0.5);
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.16);
		color: #ffffff;
		font-size: 14px;
		font-weight: 900;
		cursor: pointer;
		backdrop-filter: blur(8px);
		box-shadow: 0 10px 26px rgba(0, 0, 0, 0.22);
	}

	.workerQrCameraTestBtn:hover {

		background: rgba(255, 255, 255, 0.26);
	}

</style>


<div class="workerPage workerKioskPage">


<!-- 작업자 화면 상단 헤더다. -->
<div class="workerHeader">

	<!-- 왼쪽 브랜드 영역이다. -->
	<div class="workerLogoBox">

		<img src="${pageContext.request.contextPath}/resources/saeroi_logo.png"
			class="headerLogoImg"
			alt="SAEROI 로고">

		<div class="workerLogoDivider"></div>

		<div class="workerLogoTextBox">

			<div class="workerLogoText">
				작업자
			</div>

		</div>

	</div>

	<!-- 오른쪽 작업자 정보 영역이다. -->
	<div class="workerHeaderRight">

		<div class="workerHeaderChip workerProfileChip"
			onclick="location.href='${pageContext.request.contextPath}/mypage'">

			<img src="${pageContext.request.contextPath}/resources/kim.png"
				class="workerProfileImg"
				alt="프로필">

			<div class="workerChipTextBox">

				<span class="workerChipLabel">
					작업자
				</span>

				<strong>
					${workerName} 작업자
				</strong>

			</div>

			<span class="workerOnlineDot"></span>

			<span class="workerOnlineText">
				온라인
			</span>

		</div>

		<div class="workerHeaderChip">

			<svg viewBox="0 0 24 24"
				class="workerHeaderSvg"
				fill="none"
				xmlns="http://www.w3.org/2000/svg">

				<path
					d="M12 21C12 21 5 14.7 5 9.5C5 5.9 8.1 3 12 3C15.9 3 19 5.9 19 9.5C19 14.7 12 21 12 21Z"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round" />

				<path
					d="M12 12C13.4 12 14.5 10.9 14.5 9.5C14.5 8.1 13.4 7 12 7C10.6 7 9.5 8.1 9.5 9.5C9.5 10.9 10.6 12 12 12Z"
					stroke="currentColor"
					stroke-width="2" />

			</svg>

			<div class="workerChipTextBox">

				<span class="workerChipLabel">
					현장
				</span>

				<strong>
					${workerDept}
				</strong>

			</div>

		</div>

		<div class="workerHeaderChip">

			<svg viewBox="0 0 24 24"
				class="workerHeaderSvg"
				fill="none"
				xmlns="http://www.w3.org/2000/svg">

				<path
					d="M14 14.8V5C14 3.3 12.7 2 11 2C9.3 2 8 3.3 8 5V14.8C6.8 15.7 6 17.1 6 18.7C6 21.1 8.1 23 11 23C13.9 23 16 21.1 16 18.7C16 17.1 15.2 15.7 14 14.8Z"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round" />

				<path
					d="M11 17V8"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round" />

			</svg>

			<div class="workerChipTextBox">

				<span class="workerChipLabel">
					온도
				</span>

				<strong id="workerTodayTemp">
				    불러오는 중
				</strong>

			</div>

		</div>

		<div class="workerHeaderChip workerTimeChip">

			<svg viewBox="0 0 24 24"
				class="workerHeaderSvg"
				fill="none"
				xmlns="http://www.w3.org/2000/svg">

				<path
					d="M12 22C17.5 22 22 17.5 22 12C22 6.5 17.5 2 12 2C6.5 2 2 6.5 2 12C2 17.5 6.5 22 12 22Z"
					stroke="currentColor"
					stroke-width="2" />

				<path
					d="M12 6.5V12L15.5 14"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round" />

			</svg>

			<div class="workerChipTextBox">

				<span class="workerChipLabel">
					시간
				</span>

				<strong id="workerClock"></strong>

			</div>

		</div>

		<button type="button"
			class="workerLogoutBtn"
			onclick="location.href='${pageContext.request.contextPath}/logout'">

			<svg viewBox="0 0 24 24"
				class="workerLogoutSvg"
				fill="none"
				xmlns="http://www.w3.org/2000/svg">

				<path
					d="M14 7V5C14 3.9 13.1 3 12 3H6C4.9 3 4 3.9 4 5V19C4 20.1 4.9 21 6 21H12C13.1 21 14 20.1 14 19V17"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round" />

				<path
					d="M9 12H20"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round" />

				<path
					d="M17 8L21 12L17 16"
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
	
	<!-- 작업자 메인 컨텐츠다. -->
	<div class="workerKioskContent">

		<div class="workerScanPanel"
			onclick="startWorkerQrScan()">

			<div class="workerScanTopGuide">
			
<svg viewBox="0 0 24 24"
	class="workerGuideSvg"
	xmlns="http://www.w3.org/2000/svg"
	aria-hidden="true">

	<circle cx="7.5" cy="4.5" r="1.1" fill="currentColor" />
	<circle cx="11.5" cy="3.5" r="1.2" fill="currentColor" />
	<circle cx="15.5" cy="4.8" r="1.1" fill="currentColor" />

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

				<div class="workerQrWhiteBox"
					onclick="event.stopPropagation(); moveWorkerCurrentQrTest();">

					<%-- =====================================================
						실제 작업지시 QR 표시
						-----------------------------------------------------
						기존에는 고정 SVG QR 이미지를 보여줬지만,
						이제는 로그인한 작업자의 오늘 작업지시 ORDER_ID를 기준으로
						팀원이 만든 QR 생성 URL을 그대로 사용한다.

						팀원 코드 수정 없음:
						/production/workorder/qr?orderId=...
					===================================================== --%>
					<%-- =====================================================
						작업지시 유무와 상관없이 실제 QR 이미지 출력
						-----------------------------------------------------
						Controller에서 오늘 작업지시가 없을 경우에도
						로그인한 작업자의 기존 작업지시 중 1건을 QR 표시용으로 내려준다.
						따라서 여기서는 SVG 기본 이미지를 사용하지 않고,
						팀원이 만든 QR 생성 URL을 그대로 사용한다.

						QR 이미지 URL:
						/production/workorder/qr?orderId=작업지시번호
					===================================================== --%>
					<c:if test="${workerQrOrderId gt 0}">

						<img class="realQrImg"
							src="${pageContext.request.contextPath}/production/workorder/qr?orderId=${workerQrOrderId}"
							alt="작업지시 QR 코드">

					</c:if>

					<%-- =====================================================
						정말로 작업지시 데이터가 1건도 없는 경우 안내문 표시
						-----------------------------------------------------
						실제 QR은 ORDER_ID가 있어야 생성되므로,
						DB에 작업지시가 단 한 건도 없으면 QR 생성 자체가 불가능하다.
						이 경우에만 안내 문구를 보여준다.
					===================================================== --%>
					<c:if test="${workerQrOrderId le 0}">

						<div class="workerQrNoOrderText">
							QR을 표시할 작업지시가 없습니다.
						</div>

					</c:if>


					<%-- =====================================================
						QR 중앙 로고
						별도 QR 이미지 파일을 만들지 않고,
						팀원이 만든 실제 QR 이미지 위에 기존 SAEROI 로고를 겹쳐서 표시한다.
						공통 파일은 수정하지 않고 worker.css에서만 위치를 잡는다.
					===================================================== --%>
					<%-- =====================================================
						QR 중앙 SAEROI 로고
						-----------------------------------------------------
						작업지시가 있을 때뿐만 아니라 작업지시가 없을 때도
						항상 QR 중앙에 로고가 보이도록 조건문을 제거했다.
					===================================================== --%>
					<div class="workerQrLogoBox">
						<img src="${pageContext.request.contextPath}/resources/saeroi_logo.png"
							alt="SAEROI 로고">
					</div>

					<%-- =====================================================
						현재 화면 QR 테스트 / QR 이미지 클릭 이동용 URL
						- 실제 QR URL이 있으면 해당 URL로 이동
						- QR URL이 없으면 오늘 작업지시 조회 화면으로 이동
					===================================================== --%>
					<%-- =====================================================
						QR 클릭 / 테스트 실행 이동 URL
						-----------------------------------------------------
						작업지시가 있으면 Controller에서 내려준 workerQrMoveUrl로 이동한다.
						작업지시가 없으면 빈 값이 들어올 수 있으므로 작업지시 조회 화면을 기본값으로 사용한다.
					===================================================== --%>
					<c:set var="workerCurrentQrMoveUrl"
						value="${empty workerQrMoveUrl ? '/worker/workorder?todayOnly=Y' : workerQrMoveUrl}" />

					<input type="hidden"
						id="workerCurrentQrMoveUrl"
						value="<c:choose><c:when test="${workerCurrentQrMoveUrl.indexOf('http://') == 0 || workerCurrentQrMoveUrl.indexOf('https://') == 0}">${workerCurrentQrMoveUrl}</c:when><c:otherwise>${pageContext.request.contextPath}${workerCurrentQrMoveUrl}</c:otherwise></c:choose>">

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

		<div class="workerRightPanel">

			<div class="workerMenuList">

				<div class="workerMenuCard"
					onclick="location.href='${pageContext.request.contextPath}/worker/workorder'">

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
						onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/worker/workorder'">

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


				<%-- =====================================================
					품질관리 카드 추가
					팀원 품질관리 Controller는 수정하지 않고 URL만 연결한다.

					검사관리: /quality/inspection
					불량관리: /quality/defect
				===================================================== --%>
				<div class="workerMenuCard workerQualityMenuCard"
					onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">

					<div class="workerMenuIconCircle">

						<svg viewBox="0 0 24 24"
							class="menuSvgIcon">

							<path
								d="M9 11L11 13L15 8.5L16.5 10L11.1 16L7.5 12.4L9 11ZM5 3H19C20.1 3 21 3.9 21 5V19C21 20.1 20.1 21 19 21H5C3.9 21 3 20.1 3 19V5C3 3.9 3.9 3 5 3ZM5 5V19H19V5H5Z"
								fill="currentColor" />

						</svg>

					</div>

					<div class="workerMenuTextBox">

						<h3>
							품질관리
						</h3>

						<p>
							검사관리 현황을 확인합니다.
						</p>

						
        <%-- =====================================================
            작업자 화면에서는 품질관리 클릭 시 검사관리로 바로 이동한다.
            검사관리 / 불량관리 빠른 버튼은 표시하지 않는다.
        ===================================================== --%>

    </div>


					<div class="workerMenuNo">
						03
					</div>

					<button type="button"
						class="workerMenuArrowBtn"
						onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/quality/inspection'">

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
						04
					</div>

					<button type="button"
						class="workerMenuArrowBtn"
						onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/notice/list'">

						›

					</button>

				</div>

			</div>

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

					<div class="workerTodayItem"
						onclick="location.href='${pageContext.request.contextPath}/worker/workorder?todayOnly=Y'">

						<%-- =====================================================
							오늘 작업지시 카드
							로그인 작업자 + 오늘 날짜 기준 작업지시 목록으로 이동한다.
							공통 파일은 건드리지 않고 현재 JSP 클릭 경로만 연결한다.
						===================================================== --%>
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
							${workerTodayWorkOrderCount} 건
						</strong>

					</div>

					<div class="workerTodayItem"
						onclick="location.href='${pageContext.request.contextPath}/worker/workorder?todayOnly=Y&status=progress'">

						<%-- =====================================================
							진행 상태 카드
							오늘 작업 중 완료되지 않은 건만 작업지시조회에서 확인한다.
						===================================================== --%>
						<div class="workerProgressCircle">

							<span>
								${workerTodayProgressRate}%
							</span>

						</div>

						<p>
							진행 상태
						</p>

						<strong>
							${workerTodayProgressText}
						</strong>

					</div>

					<div class="workerTodayItem"
						onclick="location.href='${pageContext.request.contextPath}/notice/list'">

						<%-- =====================================================
							최근 알림 카드
							별도 알림 테이블은 건드리지 않고 공지사항/게시판으로 이동한다.
						===================================================== --%>
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
							${workerRecentAlertCount} 건
						</strong>

					</div>

				</div>

			</div>

		</div>

	</div>

</div>



<%-- =========================================================
	QR 카메라 스캔 모달
	작업자 메인에서만 사용하는 화면이므로 공통 JSP / 공통 CSS는 수정하지 않는다.
========================================================= --%>
<div id="workerQrCameraModal"
	class="workerQrCameraModal"
	aria-hidden="true">

	<video id="workerQrCameraVideo"
		class="workerQrCameraVideo"
		autoplay
		playsinline
		muted>
	</video>

	<div class="workerQrCameraDim"></div>

	<div class="workerQrCameraTop">

		<div class="workerQrCameraTitleBox">

			<div class="workerQrCameraTitle">
				QR 스캔
			</div>

			<div class="workerQrCameraSubTitle">
				작업지시 QR을 카메라 중앙에 맞춰주세요.
			</div>

		</div>

		<button type="button"
			class="workerQrCameraCloseBtn"
			onclick="closeWorkerQrScan()"
			aria-label="QR 스캔 닫기">

			×

		</button>

	</div>

	<div class="workerQrCameraFrame">

		<div class="workerQrCameraCorner leftTop"></div>
		<div class="workerQrCameraCorner rightTop"></div>
		<div class="workerQrCameraCorner leftBottom"></div>
		<div class="workerQrCameraCorner rightBottom"></div>

		<div class="workerQrCameraScanLine"></div>

	</div>

	<div class="workerQrCameraGuide">

		<div id="workerQrCameraStatus"
			class="workerQrCameraGuideMain">

			카메라를 준비하고 있습니다.

		</div>

		<div class="workerQrCameraGuideSub">
			QR 인식 후 작업지시 또는 생산실적 화면으로 자동 이동합니다.
		</div>

		<%-- =====================================================
			같은 PC에서 현재 화면 QR 동작을 확인하는 테스트 버튼
			PC 웹캠은 모니터 속 QR을 직접 볼 수 없어서,
			시연/개발 중에는 이 버튼으로 작업지시 조회 흐름을 바로 확인한다.
			실제 현장에서는 카메라로 QR을 스캔하면 된다.
		===================================================== --%>
		<button type="button"
			class="workerQrCameraTestBtn"
			onclick="moveWorkerCurrentQrTest();">

			현재 화면 QR 테스트 실행

		</button>

	</div>

	<div id="workerQrCameraMessageBox"
		class="workerQrCameraMessageBox">

		<div id="workerQrCameraMessageTitle"
			class="workerQrCameraMessageTitle">

			카메라를 사용할 수 없습니다.

		</div>

		<div id="workerQrCameraMessageText"
			class="workerQrCameraMessageText">

			카메라 권한을 허용한 뒤 다시 시도해주세요.

		</div>

		<button type="button"
			class="workerQrCameraMessageBtn"
			onclick="closeWorkerQrScan()">

			확인

		</button>

	</div>

</div>


<%-- =========================================================
	QR 인식 라이브러리
	BarcodeDetector는 브라우저마다 지원 차이가 있어서 사용하지 않는다.
	jsQR은 canvas 이미지 분석 방식이라 Chrome / Edge / Safari 등에서 더 안정적으로 동작한다.
	공통 파일은 건드리지 않고 작업자 메인 JSP에서만 로드한다.
========================================================= --%>
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.js"></script>

<script>
	document.title = "SAEROI MES";

	(function () {

		var favicon = document.querySelector("link[rel='icon']");

		if (!favicon) {

			favicon = document.createElement("link");

			favicon.rel = "icon";

			document.head.appendChild(favicon);

		}

		favicon.type = "image/x-icon";

		favicon.href = "${pageContext.request.contextPath}/resources/favicon.ico?v=1";

	})();

	function padTwo(value) {

		return String(value).padStart(2, '0');

	}

	function updateClock() {

		var now = new Date();

		var year = now.getFullYear();

		var month = padTwo(now.getMonth() + 1);

		var date = padTwo(now.getDate());

		var dayNumber = now.getDay();

		var dayText = "";

		if (dayNumber == 0) {

			dayText = "일";

		} else if (dayNumber == 1) {

			dayText = "월";

		} else if (dayNumber == 2) {

			dayText = "화";

		} else if (dayNumber == 3) {

			dayText = "수";

		} else if (dayNumber == 4) {

			dayText = "목";

		} else if (dayNumber == 5) {

			dayText = "금";

		} else if (dayNumber == 6) {

			dayText = "토";

		}

		var hour = padTwo(now.getHours());

		var minute = padTwo(now.getMinutes());

		var second = padTwo(now.getSeconds());

		var currentTime = year + "-" + month + "-" + date + " (" + dayText + ") "
				+ hour + ":" + minute + ":" + second;

		document.getElementById("workerClock").innerText = currentTime;
	}

	function updateTodayStandardTime() {

		var now = new Date();

		var hour = padTwo(now.getHours());

		var minute = padTwo(now.getMinutes());

		var second = padTwo(now.getSeconds());

		var todayTime = hour + ":" + minute + ":" + second + " ";

		document.getElementById("workerTodayTime").innerText = todayTime;
	}

	// =====================================================
	// 날씨 기능
	// 기존 공통 weather/current API 그대로 사용
	// =====================================================
	function updateWorkerWeather() {

	    var tempBox = document.getElementById("workerTodayTemp");

	    if (tempBox == null) {

	        return;
	    }

	    tempBox.innerHTML = "불러오는 중";

	    fetch("${pageContext.request.contextPath}/weather/current")
	        .then(function(response) {

	            return response.json();
	        })
	        .then(function(data) {

	            if (data.temp == null) {

	                tempBox.innerHTML = "온도 확인 불가";

	                return;
	            }

	            tempBox.innerHTML = data.temp + "&deg;C";
	        })
	        .catch(function(error) {

	            console.error(error);

	            tempBox.innerHTML = "온도 확인 불가";
	        });
	}

	// =====================================================
	// QR 카메라 스캔 관련 전역 변수
	// 공통 JS는 건드리지 않고 workerMain.jsp 안에서만 사용한다.
	// =====================================================
	// =====================================================
	// 카메라 스트림 / 반복 스캔 타이머
	// BarcodeDetector는 브라우저별 지원 차이가 있어서 제거하고,
	// jsQR + canvas 방식으로 QR을 인식한다.
	// =====================================================
	var workerQrStream = null;
	var workerQrScanTimer = null;
	var workerQrScanning = false;
	var workerQrCanvas = document.createElement("canvas");
	var workerQrCanvasContext = workerQrCanvas.getContext("2d");

	// =====================================================
	// QR 스캔 시작
	// -----------------------------------------------------
	// 1. 전체화면 카메라 모달을 연다.
	// 2. 브라우저 기본 BarcodeDetector로 QR 인식을 준비한다.
	// 3. 카메라 권한을 요청한다.
	// 4. QR 인식 성공 시 QR 안의 URL 또는 값으로 이동한다.
	//
	// 주의:
	// getUserMedia는 일반적으로 HTTPS 또는 localhost에서 동작한다.
	// 학교/시연 환경에서 http IP 접속이면 브라우저 보안 정책 때문에
	// 카메라가 막힐 수 있으므로 안내 메시지를 보여준다.
	// =====================================================
	async function startWorkerQrScan() {

		var modal =
			document.getElementById("workerQrCameraModal");

		var video =
			document.getElementById("workerQrCameraVideo");

		var status =
			document.getElementById("workerQrCameraStatus");

		var messageBox =
			document.getElementById("workerQrCameraMessageBox");

		if (modal == null
				|| video == null) {

			alert("QR 스캔 화면을 찾을 수 없습니다.");
			return;
		}

		modal.style.display = "block";
		modal.setAttribute("aria-hidden", "false");

		if (messageBox != null) {

			messageBox.style.display = "none";
		}

		if (status != null) {

			status.innerText = "카메라 권한을 확인하고 있습니다.";
		}

		// =================================================
		// 모바일 카메라는 HTTPS / localhost 같은 보안 환경에서만 동작한다.
		// http://IP주소 로 접속하면 브라우저 정책상 getUserMedia가 막힌다.
		// =================================================
		if (window.isSecureContext === false
				&& location.hostname !== "localhost"
				&& location.hostname !== "127.0.0.1") {

			showWorkerQrMessage(
				"보안 연결이 아닙니다.",
				"모바일 카메라는 HTTPS 주소에서만 실행됩니다. 현재 주소가 http:// 로 시작하면 https:// 주소로 접속해주세요."
			);

			return;
		}

		// =================================================
		// 카메라 API 지원 여부 확인
		// =================================================
		if (navigator.mediaDevices == null
				|| navigator.mediaDevices.getUserMedia == null) {

			showWorkerQrMessage(
				"카메라를 사용할 수 없습니다.",
				"브라우저에서 카메라 기능을 지원하지 않거나 보안 연결이 아닙니다. Chrome 또는 Safari에서 HTTPS 주소로 접속해주세요."
			);

			return;
		}

		try {

			// =================================================
			// 기존 코드 문제:
			// jsQR CDN 확인을 카메라 실행보다 먼저 해서,
			// 모바일에서 CDN이 늦게 로드되거나 차단되면 카메라가 아예 안 켜졌다.
			//
			// 수정:
			// 1. 카메라를 먼저 실행한다.
			// 2. 지원되면 BarcodeDetector를 사용한다.
			// 3. 아니면 jsQR을 사용한다.
			// 4. 둘 다 없으면 카메라는 켜진 상태에서 안내 메시지를 보여준다.
			// =================================================

			try {

				workerQrStream =
					await navigator.mediaDevices.getUserMedia({
						video: {
							facingMode: {
								exact: "environment"
							}
						},
						audio: false
					});

			} catch (environmentError) {

				// =================================================
				// 일부 기기는 exact environment를 지원하지 않는다.
				// 이 경우 ideal environment로 다시 시도한다.
				// =================================================
				try {

					workerQrStream =
						await navigator.mediaDevices.getUserMedia({
							video: {
								facingMode: {
									ideal: "environment"
								}
							},
							audio: false
						});

				} catch (idealError) {

					// =================================================
					// 그래도 실패하면 기본 카메라로 마지막 시도한다.
					// =================================================
					workerQrStream =
						await navigator.mediaDevices.getUserMedia({
							video: true,
							audio: false
						});
				}
			}

			video.srcObject =
				workerQrStream;

			await video.play();

			// =================================================
			// BarcodeDetector 지원 브라우저면 우선 사용한다.
			// Android Chrome에서는 이 방식이 CDN 의존이 없어 더 안정적이다.
			// =================================================
			workerQrDetector = null;

			if ("BarcodeDetector" in window) {

				try {

					workerQrDetector =
						new BarcodeDetector({
							formats: ["qr_code"]
						});

				} catch (detectorError) {

					workerQrDetector = null;
				}
			}

			workerQrScanning =
				true;

			if (status != null) {

				if (workerQrDetector != null) {

					status.innerText = "QR 코드를 스캔 영역 안에 맞춰주세요.";

				} else if (typeof jsQR !== "undefined") {

					status.innerText = "QR 코드를 스캔 영역 안에 맞춰주세요.";

				} else {

					status.innerText = "카메라는 켜졌지만 QR 인식 스크립트를 확인 중입니다.";
				}
			}

			scanWorkerQrCode();

		} catch (error) {

			console.error(error);

			var errorText =
				"카메라 권한을 허용했는지 확인해주세요. 모바일에서는 HTTPS 주소에서 접속해야 카메라가 동작합니다.";

			if (error != null
					&& error.name != null) {

				if (error.name == "NotAllowedError") {

					errorText =
						"카메라 권한이 거부되었습니다. 브라우저 주소창의 권한 설정에서 카메라를 허용해주세요.";

				} else if (error.name == "NotFoundError") {

					errorText =
						"사용 가능한 카메라를 찾지 못했습니다. 다른 브라우저 또는 기기 카메라 권한을 확인해주세요.";

				} else if (error.name == "NotReadableError") {

					errorText =
						"다른 앱이 카메라를 사용 중일 수 있습니다. 카메라 앱을 종료한 뒤 다시 시도해주세요.";
				}
			}

			showWorkerQrMessage(
				"카메라 실행에 실패했습니다.",
				errorText
			);
		}
	}
	// =====================================================
	// QR 반복 인식
	// -----------------------------------------------------
	// BarcodeDetector는 브라우저 지원 차이가 있어서 사용하지 않는다.
	// video 화면을 canvas에 그린 뒤 jsQR로 QR 코드를 분석한다.
	// 이렇게 하면 Chrome / Edge / Safari 계열에서 더 안정적으로 동작한다.
	// =====================================================
	async function scanWorkerQrCode() {

		if (!workerQrScanning) {

			return;
		}

		var video =
			document.getElementById("workerQrCameraVideo");

		var status =
			document.getElementById("workerQrCameraStatus");

		if (video == null) {

			workerQrScanTimer =
				setTimeout(scanWorkerQrCode, 350);

			return;
		}

		try {

			if (video.readyState >= 2
					&& video.videoWidth > 0
					&& video.videoHeight > 0) {

				// =================================================
				// 1순위: 브라우저 기본 BarcodeDetector
				// CDN 없이 동작하므로 모바일에서 더 안정적이다.
				// =================================================
				if (workerQrDetector != null) {

					var barcodes =
						await workerQrDetector.detect(video);

					if (barcodes != null
							&& barcodes.length > 0
							&& barcodes[0].rawValue != null
							&& barcodes[0].rawValue.trim() != "") {

						workerQrScanning =
							false;

						if (status != null) {

							status.innerText = "QR 인식 완료. 화면을 이동합니다.";
						}

						moveWorkerQrResult(
							barcodes[0].rawValue.trim());

						return;
					}
				}

				// =================================================
				// 2순위: jsQR
				// BarcodeDetector 미지원 브라우저에서는 canvas + jsQR로 인식한다.
				// =================================================
				if (typeof jsQR !== "undefined"
						&& workerQrCanvasContext != null) {

					workerQrCanvas.width =
						video.videoWidth;

					workerQrCanvas.height =
						video.videoHeight;

					workerQrCanvasContext.drawImage(
						video,
						0,
						0,
						workerQrCanvas.width,
						workerQrCanvas.height);

					var imageData =
						workerQrCanvasContext.getImageData(
							0,
							0,
							workerQrCanvas.width,
							workerQrCanvas.height);

					var qrCode =
						jsQR(
							imageData.data,
							imageData.width,
							imageData.height,
							{
								inversionAttempts: "attemptBoth"
							});

					if (qrCode != null
							&& qrCode.data != null
							&& qrCode.data.trim() != "") {

						workerQrScanning =
							false;

						if (status != null) {

							status.innerText = "QR 인식 완료. 화면을 이동합니다.";
						}

						moveWorkerQrResult(
							qrCode.data.trim());

						return;
					}
				}

				// =================================================
				// 둘 다 없으면 카메라는 켜져 있지만 QR 분석을 못 하는 상태다.
				// 이 경우 계속 무한 반복하지 않고 안내한다.
				// =================================================
				if (workerQrDetector == null
						&& typeof jsQR === "undefined") {

					workerQrScanning =
						false;

					showWorkerQrMessage(
						"QR 인식 스크립트를 불러오지 못했습니다.",
						"카메라는 켜졌지만 QR 분석 기능을 사용할 수 없습니다. 인터넷 연결 또는 jsQR 스크립트 로드 상태를 확인해주세요."
					);

					return;
				}
			}

		} catch (error) {

			console.error(error);
		}

		workerQrScanTimer =
			setTimeout(scanWorkerQrCode, 250);
	}


	// =====================================================
	// 현재 화면 QR 테스트 실행
	// -----------------------------------------------------
	// 같은 PC에서 웹캠으로 현재 모니터 안의 QR을 직접 찍는 것은
	// 물리적으로 어렵다. 그래서 개발/시연용으로 현재 화면 QR을
	// 눌렀을 때와 같은 흐름을 바로 실행한다.
	// 팀원 작업지시 코드는 건드리지 않고 작업자 전용 경로만 사용한다.
	// =====================================================
	function moveWorkerCurrentQrTest() {

		// =================================================
		// 현재 화면 QR 테스트 실행
		// -------------------------------------------------
		// 같은 PC에서는 카메라가 모니터 속 QR을 직접 볼 수 없기 때문에
		// 현재 화면 QR을 클릭하거나 테스트 버튼을 누르면
		// 실제 QR 이동 URL로 바로 이동하게 한다.
		// =================================================
		var qrMoveUrl =
			document.getElementById("workerCurrentQrMoveUrl");

		if (qrMoveUrl != null
				&& qrMoveUrl.value != null
				&& qrMoveUrl.value.trim() != "") {

			location.href =
				qrMoveUrl.value.trim();

			return;
		}

		moveWorkerQrResult(
			"${pageContext.request.contextPath}/worker/workorder?todayOnly=Y");
	}

	// =====================================================
	// QR 인식 결과 이동 처리
	// -----------------------------------------------------
	// 팀원이 만든 작업지시 QR은 생산실적 URL을 담고 있으므로
	// QR 값이 URL이면 그대로 이동한다.
	//
	// 혹시 QR 값이 숫자 작업지시번호만 들어오는 경우도 대비해서
	// 생산실적 등록 화면으로 이동하도록 보완한다.
	// =====================================================
	function moveWorkerQrResult(qrValue) {

		closeWorkerQrScan();

		if (qrValue.indexOf("http://") == 0
				|| qrValue.indexOf("https://") == 0
				|| qrValue.indexOf("/") == 0) {

			location.href =
				qrValue;

			return;
		}

		if (/^[0-9]+$/.test(qrValue)) {

			location.href =
				"${pageContext.request.contextPath}/production/productionresult?orderId="
				+ encodeURIComponent(qrValue)
				+ "&openModal=Y";

			return;
		}

		// =================================================
		// QR 값이 예상 형식이 아닐 때는 작업지시조회로 이동한다.
		// 이후 작업지시조회에서 검색어로 활용할 수 있도록 keyword에 담는다.
		// =================================================
		location.href =
			"${pageContext.request.contextPath}/worker/workorder?keyword="
			+ encodeURIComponent(qrValue);
	}

	// =====================================================
	// QR 스캔 닫기
	// 카메라 스트림을 반드시 종료해서 브라우저 카메라 점유를 해제한다.
	// =====================================================
	function closeWorkerQrScan() {

		workerQrScanning =
			false;

		if (workerQrScanTimer != null) {

			clearTimeout(workerQrScanTimer);
			workerQrScanTimer = null;
		}

		if (workerQrStream != null) {

			workerQrStream.getTracks().forEach(function(track) {

				track.stop();
			});

			workerQrStream = null;
		}

		var video =
			document.getElementById("workerQrCameraVideo");

		if (video != null) {

			video.pause();
			video.srcObject = null;
		}

		var modal =
			document.getElementById("workerQrCameraModal");

		if (modal != null) {

			modal.style.display = "none";
			modal.setAttribute("aria-hidden", "true");
		}
	}

	// =====================================================
	// QR 카메라 안내 메시지 출력
	// 카메라 권한 실패 / 브라우저 미지원 / 보안 연결 문제를 화면에 보여준다.
	// =====================================================
	function showWorkerQrMessage(title, text) {

		var status =
			document.getElementById("workerQrCameraStatus");

		var messageBox =
			document.getElementById("workerQrCameraMessageBox");

		var messageTitle =
			document.getElementById("workerQrCameraMessageTitle");

		var messageText =
			document.getElementById("workerQrCameraMessageText");

		if (status != null) {

			status.innerText = "QR 스캔을 시작할 수 없습니다.";
		}

		if (messageTitle != null) {

			messageTitle.innerText = title;
		}

		if (messageText != null) {

			messageText.innerText = text;
		}

		if (messageBox != null) {

			messageBox.style.display = "block";
		}
	}

	updateClock();

	updateTodayStandardTime();

	updateWorkerWeather();

	setInterval(updateClock, 1000);

	setInterval(updateWorkerWeather, 30 * 60 * 1000);
</script>