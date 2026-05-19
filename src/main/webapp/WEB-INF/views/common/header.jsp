<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 이 JSP 파일에서 한글이 깨지지 않도록 UTF-8로 설정한다. --%>

<header class="heHeader">
	<%-- 화면 상단 헤더 전체 영역이다. --%>

	<div class="heLeftBox">
		<%-- 헤더 왼쪽 영역이다. 모바일 햄버거 버튼과 현재 선택된 메뉴명이 들어간다. --%>

		<button type="button" id="heMobileMenuBtn" class="heMobileMenuBtn" aria-label="메뉴 열기">
			<%-- 모바일 화면에서 사이드바 메뉴를 여는 햄버거 버튼이다. --%>

			<span></span>
			<span></span>
			<span></span>
		</button>
		<%-- 모바일 햄버거 버튼을 끝낸다. --%>

		<h1 id="hePageTitle" class="hePageTitle">대시보드</h1>
		<%-- 사이드바에서 클릭한 대메뉴명이 들어갈 자리이다. 처음에는 대시보드로 보여준다. --%>

		<span class="heTitleDivider"></span>
		<%-- 대메뉴와 하위 메뉴 사이에 들어가는 세로 구분선이다. --%>

		<div id="heCurrentMenuBox" class="heCurrentMenuBox">
			<%-- 현재 선택된 하위 메뉴가 들어가는 영역이다. --%>

			<a href="#" id="heCurrentMenu" class="heCurrentMenu active">메인</a>
			<%-- 사이드바에서 클릭한 하위 메뉴명이 들어갈 자리이다. 처음에는 메인으로 보여준다. --%>

		</div>
		<%-- 현재 하위 메뉴 영역을 끝낸다. --%>

	</div>
	<%-- 헤더 왼쪽 영역을 끝낸다. --%>

	<div class="heRightBox">
		<%-- 헤더 오른쪽 영역이다. 현재시간과 오늘 온도가 들어간다. --%>

		<div class="heInfoBox">
			<%-- 현재시간과 온도 정보를 가로로 감싸는 박스이다. --%>

			<div class="heInfoItem">
				<%-- 오늘 온도 영역이다. --%>

				<p class="heInfoLabel">오늘 온도</p>
				<%-- 오늘 온도라는 작은 제목이다. --%>

				<div class="heWeatherBox">
					<%-- 온도와 날씨 아이콘을 가로로 묶는 영역이다. --%>

					<p id="heTodayTemp" class="heInfoText">불러오는 중</p>
					<%-- header.js에서 날씨 API 결과를 넣어줄 영역이다. --%>

					<img id="heWeatherIcon" class="heWeatherIcon" src="" alt="날씨 아이콘">
					<%-- OpenWeatherMap API에서 받은 날씨 아이콘이 들어갈 영역이다. --%>

				</div>
				<%-- 온도와 날씨 아이콘 영역을 끝낸다. --%>

			</div>
			<%-- 오늘 온도 영역을 끝낸다. --%>

			<div class="heInfoItem">
				<%-- 현재시간 영역이다. --%>

				<p class="heInfoLabel">현재 시간</p>
				<%-- 현재 시간이라는 작은 제목이다. --%>

				<p id="heCurrentTime" class="heInfoText">0000-00-00 (월) 00:00:00</p>
				<%-- header.js에서 컴퓨터 시간을 초 단위로 넣어줄 영역이다. --%>

			</div>
			<%-- 현재시간 영역을 끝낸다. --%>

		</div>
		<%-- 현재시간과 온도 정보 박스를 끝낸다. --%>

	</div>
	<%-- 헤더 오른쪽 영역을 끝낸다. --%>

</header>
<%-- 화면 상단 헤더 전체 영역을 끝낸다. --%>