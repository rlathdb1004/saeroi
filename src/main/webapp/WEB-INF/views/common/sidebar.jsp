<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 이 JSP 파일에서 한글이 깨지지 않도록 UTF-8로 설정한다. --%>

<aside class="siSidebar">
	<%-- 사이드바 전체를 감싸는 영역이다. layout.jsp에서 Tiles로 불러와 모든 화면에 공통으로 표시된다. --%>

	<div class="siLogoBox">
		<%-- 사이드바 상단 로고와 시스템 설명 문구를 감싸는 영역이다. --%>

		<img
			src="${pageContext.request.contextPath}/resources/saeroi_logo.png"
			alt="SAEROI 로고" class="siLogo">
		<%-- contextPath를 붙여서 프로젝트명이 바뀌어도 로고 이미지 경로가 깨지지 않도록 한다. --%>

		<p class="siLogoText">EV용 배터리 절연 가스켓 제조 MES</p>
		<%-- 로고 아래에 프로젝트 시스템 설명 문구를 표시한다. --%>

	</div>
	<%-- 로고 영역을 끝낸다. --%>


	<div class="siUserBox">
		<%-- 로그인 사용자 정보를 보여주는 영역이다. 현재는 화면 확인용 임시 문구를 넣어둔다. --%>

		<div class="siUserProfileIcon">
			<%-- 사용자 프로필 사진이 들어가는 영역이다. --%>
			<%-- 현재는 테스트 이미지이고, 나중에는 DB에서 가져온 사용자 프로필 이미지 경로로 변경한다. --%>

			<img
				src="${pageContext.request.contextPath}/resources/kim.png"
				alt="사용자 프로필 사진">
			<%-- 
        현재 테스트용 프로필 이미지이다.
        실제 프로젝트에서는 로그인한 사용자의 DB 이미지 경로를 받아서 src에 넣어야 한다.
        예: ${loginUser.profileImg}
    --%>
		</div>

		<div class="siUserInfoText">
			<%-- 사용자 이름, 부서명, 직급을 세로로 보여주기 위한 글자 영역이다. --%>

			<p class="siUserName">
        		${not empty sessionScope.loginUser 
            	? sessionScope.loginUser.ename.concat(' 님') 
            	: '로그인 필요'}
    		</p>

			<p class="siUserRole">
        		${not empty sessionScope.loginUser 
           		? sessionScope.loginUser.dept.concat('  ').concat(sessionScope.loginUser.job) 
            	: ''}
    		</p>

		</div>
		
		<%-- 사용자 글자 영역을 끝낸다. --%>

		<button type="button" class="siNoticeBtn" aria-label="알림">
			<%-- 알림 아이콘 버튼이다. 아직 기능 연결 전이라 type을 button으로 둔다. --%>

			<svg class="siNoticeIcon" viewBox="0 0 24 24">
            <%-- 알림 종 모양을 SVG로 그리기 위한 영역이다. --%>

                <path
					d="M18 8A6 6 0 0 0 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8"></path>
                <%-- 종의 몸통 모양을 그리는 선이다. --%>

                <path d="M13.73 21A2 2 0 0 1 10.27 21"></path>
                <%-- 종 아래쪽 흔들리는 부분을 그리는 선이다. --%>

            </svg>
			<%-- 알림 SVG 영역을 끝낸다. --%>

		</button>
		<%-- 알림 버튼을 끝낸다. --%>

	</div>
	<%-- 사용자 정보 영역을 끝낸다. --%>


	<nav class="siMenu">
		<%-- 사이드바 메뉴 전체를 감싸는 영역이다. --%>


		<div class="siMenuGroup">
			<%-- 대시보드 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="대시보드">
				<%-- 대시보드 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">대시보드</span>
				<%-- 화면에 보이는 큰 메뉴명이다. --%>

				<span class="siMenuArrow"> <%-- 큰 메뉴 오른쪽에 표시되는 화살표 영역이다. --%>

					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- 화살표 모양을 SVG로 그리기 위한 영역이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 선을 그린다. --%>

                    </svg> <%-- 화살표 SVG를 끝낸다. --%>

				</span>
				<%-- 화살표 영역을 끝낸다. --%>

			</button>
			<%-- 대시보드 큰 메뉴 버튼을 끝낸다. --%>

			<div class="siSubMenu">
				<%-- 대시보드 하위 메뉴 영역이다. --%>

				<a href="${pageContext.request.contextPath}/dashboard"
					class="siSubMenuLink" data-main-menu="대시보드" data-sub-menu="메인">
					<%-- 메인을 클릭하면 대시보드 화면으로 이동한다. --%> 메인
				</a> <a href="${pageContext.request.contextPath}/board/notice"
					class="siSubMenuLink" data-main-menu="대시보드" data-sub-menu="공지사항">
					<%-- 공지사항을 클릭하면 공지사항 목록 화면으로 이동한다. --%> 공지사항
				</a> <a href="${pageContext.request.contextPath}/board/suggestion"
					class="siSubMenuLink" data-main-menu="대시보드" data-sub-menu="게시판">
					<%-- 게시판을 클릭하면 게시판 화면으로 이동한다. --%> 게시판
				</a>

			</div>
			<%-- 대시보드 하위 메뉴 영역을 끝낸다. --%>

		</div>
		<%-- 대시보드 메뉴 그룹을 끝낸다. --%>


		<div class="siMenuGroup">
			<%-- 자재/재고 관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="자재/재고 관리">
				<%-- 자재/재고 관리 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">자재/재고 관리</span> <span class="siMenuArrow">
					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                        <path d="M6 9L12 15L18 9"></path>
                    </svg>
				</span>

			</button>

			<div class="siSubMenu">
				<%-- 자재/재고 관리 하위 메뉴 영역이다. --%>

				<a href="${pageContext.request.contextPath}/inventory/materialIn"
					class="siSubMenuLink" data-main-menu="자재/재고 관리"
					data-sub-menu="자재(입)출고 관리"> <%-- 자재 입고와 출고를 한 화면에서 관리하는 메뉴이다. --%>
					자재(입)출고 관리
				</a> <a
					href="${pageContext.request.contextPath}/inventory/inventoryStatus"
					class="siSubMenuLink" data-main-menu="자재/재고 관리"
					data-sub-menu="재고조회 관리"> <%-- 현재 재고 수량과 재고 상태를 조회하는 메뉴이다. --%>
					재고조회 관리
				</a>

			</div>

		</div>
		<%-- 자재/재고 관리 메뉴 그룹을 끝낸다. --%>


		<div class="siMenuGroup">
			<%-- 생산관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="생산관리">
				<%-- 생산관리 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">생산관리</span> <span class="siMenuArrow">
					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                        <path d="M6 9L12 15L18 9"></path>
                    </svg>
				</span>

			</button>

			<div class="siSubMenu">
				<%-- 생산관리 하위 메뉴 영역이다. --%>

				<a
					href="${pageContext.request.contextPath}/production/productionplan"
					class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="생산계획 관리">
					<%-- 생산계획을 등록하고 관리하는 메뉴이다. --%> 생산계획 관리
				</a> <a href="${pageContext.request.contextPath}/production/workorder"
					class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="작업지시 관리">
					<%-- 생산계획을 기준으로 작업지시를 관리하는 메뉴이다. --%> 작업지시 관리
				</a> <a
					href="${pageContext.request.contextPath}/production/productionresult"
					class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="생산실적 등록">
					<%-- 작업 완료 수량과 생산 결과를 등록하는 메뉴이다. --%> 생산실적 등록
				</a> <a
					href="${pageContext.request.contextPath}/production/processprogress"
					class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="공정진행 현황">
					<%-- 공정별 진행 상태를 확인하는 메뉴이다. --%> 공정진행 현황
				</a>

			</div>

		</div>
		<%-- 생산관리 메뉴 그룹을 끝낸다. --%>


		<div class="siMenuGroup">
			<%-- 품질관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="품질관리">
				<%-- 품질관리 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">품질관리</span> <span class="siMenuArrow">
					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                        <path d="M6 9L12 15L18 9"></path>
                    </svg>
				</span>

			</button>

			<div class="siSubMenu">
				<%-- 품질관리 하위 메뉴 영역이다. --%>

				<a href="${pageContext.request.contextPath}/quality/inspection"
					class="siSubMenuLink" data-main-menu="품질관리" data-sub-menu="검사관리">
					<%-- 검사 정보를 등록하고 조회하는 메뉴이다. --%> 검사관리
				</a> <a href="${pageContext.request.contextPath}/quality/defect"
					class="siSubMenuLink" data-main-menu="품질관리" data-sub-menu="불량관리">
					<%-- 불량 정보를 등록하고 관리하는 메뉴이다. --%> 불량관리
				</a>

			</div>

		</div>
		<%-- 품질관리 메뉴 그룹을 끝낸다. --%>


		<div class="siMenuGroup">
			<%-- 설비관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="설비관리">
				<%-- 설비관리 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">설비관리</span> <span class="siMenuArrow">
					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                        <path d="M6 9L12 15L18 9"></path>
                    </svg>
				</span>

			</button>

			<div class="siSubMenu">
				<%-- 설비관리 하위 메뉴 영역이다. --%>

				<a href="${pageContext.request.contextPath}/equipment/equipment"
					class="siSubMenuLink" data-main-menu="설비관리" data-sub-menu="설비관리">
					<%-- 설비 정보를 운영 관점에서 관리하는 메뉴이다. --%> 설비관리
				</a> <a
					href="${pageContext.request.contextPath}/equipment/equipmentstatus"
					class="siSubMenuLink" data-main-menu="설비관리"
					data-sub-menu="설비 가동 현황"> <%-- 설비가 가동 중인지 비가동 중인지 확인하는 메뉴이다. --%>
					설비 가동 현황
				</a>

			</div>

		</div>
		<%-- 설비관리 메뉴 그룹을 끝낸다. --%>


		<div class="siMenuGroup">
			<%-- 리포트 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="리포트">
				<%-- 리포트 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">리포트</span> <span class="siMenuArrow">
					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                        <path d="M6 9L12 15L18 9"></path>
                    </svg>
				</span>

			</button>

			<div class="siSubMenu">
				<%-- 리포트 하위 메뉴 영역이다. --%>

				<a href="${pageContext.request.contextPath}/report/productionreport"
					class="siSubMenuLink" data-main-menu="리포트" data-sub-menu="생산 리포트">
					<%-- 생산 결과를 리포트 형태로 확인하는 메뉴이다. --%> 생산 리포트
				</a> <a href="${pageContext.request.contextPath}/report/qualityreport"
					class="siSubMenuLink" data-main-menu="리포트" data-sub-menu="품질 리포트">
					<%-- 품질 결과를 리포트 형태로 확인하는 메뉴이다. --%> 품질 리포트
				</a>

			</div>

		</div>
		<%-- 리포트 메뉴 그룹을 끝낸다. --%>


		<div class="siMenuGroup">
			<%-- 기준정보관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

			<button type="button" class="siMenuTitle" data-main-menu="기준정보관리">
				<%-- 기준정보관리 하위 메뉴를 열고 닫는 버튼이다. --%>

				<span class="siMenuName">기준정보관리</span> <span class="siMenuArrow">
					<svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                        <path d="M6 9L12 15L18 9"></path>
                    </svg>
				</span>

			</button>

			<div class="siSubMenu">
				<%-- 기준정보관리 하위 메뉴 영역이다. --%>

				<a href="${pageContext.request.contextPath}/master/item"
					class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="품목관리">
					<%-- 제품과 자재 품목의 기준정보를 관리하는 메뉴이다. --%> 품목관리
				</a> <a href="${pageContext.request.contextPath}/master/bom"
					class="siSubMenuLink" data-main-menu="기준정보관리"
					data-sub-menu="BOM 관리"> <%-- 제품을 만들 때 필요한 자재 구성 정보를 관리하는 메뉴이다. --%>
					BOM 관리
				</a> <a href="${pageContext.request.contextPath}/master/process"
					class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="공정관리">
					<%-- 생산 공정의 기준정보를 관리하는 메뉴이다. --%> 공정관리
				</a> <a href="${pageContext.request.contextPath}/master/equipment"
					class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="설비관리">
					<%-- 설비명, 설비코드 같은 설비 기준정보를 관리하는 메뉴이다. --%> 설비관리
				</a> <a href="${pageContext.request.contextPath}/master/client"
					class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="거래처관리">
					<%-- 거래처 기준정보를 관리하는 메뉴이다. --%> 거래처관리
				</a> <a href="${pageContext.request.contextPath}/master/defectcode"
					class="siSubMenuLink" data-main-menu="기준정보관리"
					data-sub-menu="불량코드 관리"> <%-- 불량 유형을 코드로 관리하기 위한 메뉴이다. --%>
					불량코드 관리
				</a> <a href="${pageContext.request.contextPath}/system/userauth"
					class="siSubMenuLink" data-main-menu="기준정보관리"
					data-sub-menu="사용자/권한 관리"> <%-- 사용자 계정과 권한 정보를 관리하는 메뉴이다. 기존 시스템 관리 대메뉴 대신 기준정보관리 안에 배치한다. --%>
					사용자/권한 관리
				</a>

			</div>

		</div>
		<%-- 기준정보관리 메뉴 그룹을 끝낸다. --%>

	</nav>
	<%-- 메뉴 전체 영역을 끝낸다. --%>


	<div class="siLogoutBox">
		<%-- 로그아웃 버튼이 들어가는 영역이다. --%>

		<a href="${pageContext.request.contextPath}/logout" class="siLogoutBtn">로그아웃</a>
		<%-- 현재는 로그인 화면으로 이동한다. 실제 로그아웃 기능이 생기면 /logout 주소로 바꾸면 된다. --%>

	</div>
	<%-- 로그아웃 영역을 끝낸다. --%>

</aside>