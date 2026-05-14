<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 이 JSP 파일에서 한글이 깨지지 않도록 UTF-8로 설정한다. --%>

<aside class="siSidebar">
<%-- 사이드바 전체 영역이다. --%>

    <div class="siLogoBox">
    <%-- 로고와 로고 아래 설명 문구를 감싸는 영역이다. --%>

        <img src="${pageContext.request.contextPath}/resources/saeroi_logo.png" alt="SAEROI 로고" class="siLogo">
        <%-- resources 폴더에 있는 SAEROI 로고 이미지를 화면에 보여준다. --%>

        <p class="siLogoText">EV용 배터리 절연 가스켓 제조 MES</p>
        <%-- 로고 아래에 들어가는 시스템 설명 문구이다. --%>

    </div>
    <%-- 로고 영역을 끝낸다. --%>


    <div class="siUserBox">
    <%-- 로그인한 사용자 정보를 보여주는 영역이다. --%>

        <p class="siUserName">관리자</p>
        <%-- 현재는 임시로 관리자라고 표시한다. 나중에 로그인 정보와 연결하면 된다. --%>

        <p class="siUserRole">SAEROI MES</p>
        <%-- 현재 사용자의 역할 또는 시스템명을 표시하는 영역이다. --%>

    </div>
    <%-- 사용자 정보 영역을 끝낸다. --%>


    <nav class="siMenu">
    <%-- 사이드바 메뉴 전체를 감싸는 영역이다. --%>


        <a href="${pageContext.request.contextPath}/dashboard" class="siMenuSingle" data-main-menu="대시보드" data-sub-menu="">
        <%-- 대시보드를 클릭하면 /dashboard 주소로 이동한다. --%>
        <%-- data-main-menu는 헤더에 표시할 대메뉴 이름이다. --%>
        <%-- data-sub-menu는 하위 메뉴가 없어서 비워둔다. --%>

            대시보드
            <%-- 화면에 보여질 메뉴 이름이다. --%>

        </a>
        <%-- 대시보드 메뉴를 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 기준정보관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="기준정보관리">
            <%-- 기준정보관리 하위 메뉴를 열고 닫는 버튼이다. --%>
            <%-- data-main-menu는 클릭했을 때 헤더에 표시할 대메뉴 이름이다. --%>

                <span class="siMenuName">기준정보관리</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 기준정보관리 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 기준정보관리 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/master/item" class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="품목관리">품목관리</a>
                <%-- 품목관리를 클릭하면 /master/item 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/master/bom" class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="BOM관리">BOM관리</a>
                <%-- BOM관리를 클릭하면 /master/bom 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/master/process" class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="공정관리">공정관리</a>
                <%-- 공정관리를 클릭하면 /master/process 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/master/equipment" class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="설비관리">설비관리</a>
                <%-- 설비관리를 클릭하면 /master/equipment 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/master/client" class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="거래처관리">거래처관리</a>
                <%-- 거래처관리를 클릭하면 /master/client 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/master/defectCode" class="siSubMenuLink" data-main-menu="기준정보관리" data-sub-menu="불량코드 관리">불량코드 관리</a>
                <%-- 불량코드 관리를 클릭하면 /master/defectCode 주소로 이동한다. --%>

            </div>
            <%-- 기준정보관리 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 기준정보관리 메뉴 그룹을 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 자재/재고 관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="자재/재고 관리">
            <%-- 자재/재고 관리 하위 메뉴를 열고 닫는 버튼이다. --%>

                <span class="siMenuName">자재/재고 관리</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 자재/재고 관리 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 자재/재고 관리 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/inventory/materialIn" class="siSubMenuLink" data-main-menu="자재/재고 관리" data-sub-menu="자재입고 관리">자재입고 관리</a>
                <%-- 자재입고 관리를 클릭하면 /inventory/materialIn 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/inventory/materialOut" class="siSubMenuLink" data-main-menu="자재/재고 관리" data-sub-menu="자재출고 관리">자재출고 관리</a>
                <%-- 자재출고 관리를 클릭하면 /inventory/materialOut 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/inventory/inventoryStatus" class="siSubMenuLink" data-main-menu="자재/재고 관리" data-sub-menu="재고조회">재고조회</a>
                <%-- 재고조회를 클릭하면 /inventory/inventoryStatus 주소로 이동한다. --%>

            </div>
            <%-- 자재/재고 관리 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 자재/재고 관리 메뉴 그룹을 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 생산관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="생산관리">
            <%-- 생산관리 하위 메뉴를 열고 닫는 버튼이다. --%>

                <span class="siMenuName">생산관리</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 생산관리 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 생산관리 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/production/productionPlan" class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="생산계획관리">생산계획관리</a>
                <%-- 생산계획관리를 클릭하면 /production/productionPlan 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/production/workOrder" class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="작업지시 관리">작업지시 관리</a>
                <%-- 작업지시 관리를 클릭하면 /production/workOrder 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/production/productionResult" class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="생산실적 등록">생산실적 등록</a>
                <%-- 생산실적 등록을 클릭하면 /production/productionResult 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/production/processProgress" class="siSubMenuLink" data-main-menu="생산관리" data-sub-menu="공정진행 현황">공정진행 현황</a>
                <%-- 공정진행 현황을 클릭하면 /production/processProgress 주소로 이동한다. --%>

            </div>
            <%-- 생산관리 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 생산관리 메뉴 그룹을 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 품질관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="품질관리">
            <%-- 품질관리 하위 메뉴를 열고 닫는 버튼이다. --%>

                <span class="siMenuName">품질관리</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 품질관리 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 품질관리 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/quality/inspection" class="siSubMenuLink" data-main-menu="품질관리" data-sub-menu="검사관리">검사관리</a>
                <%-- 검사관리를 클릭하면 /quality/inspection 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/quality/defect" class="siSubMenuLink" data-main-menu="품질관리" data-sub-menu="불량관리">불량관리</a>
                <%-- 불량관리를 클릭하면 /quality/defect 주소로 이동한다. --%>

            </div>
            <%-- 품질관리 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 품질관리 메뉴 그룹을 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 리포트 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="리포트">
            <%-- 리포트 하위 메뉴를 열고 닫는 버튼이다. --%>

                <span class="siMenuName">리포트</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 리포트 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 리포트 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/report/productionReport" class="siSubMenuLink" data-main-menu="리포트" data-sub-menu="생산 리포트">생산 리포트</a>
                <%-- 생산 리포트를 클릭하면 /report/productionReport 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/report/qualityReport" class="siSubMenuLink" data-main-menu="리포트" data-sub-menu="품질 리포트">품질 리포트</a>
                <%-- 품질 리포트를 클릭하면 /report/qualityReport 주소로 이동한다. --%>

            </div>
            <%-- 리포트 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 리포트 메뉴 그룹을 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 공지사항/게시판 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="공지사항/게시판">
            <%-- 공지사항/게시판 하위 메뉴를 열고 닫는 버튼이다. --%>

                <span class="siMenuName">공지사항/게시판</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 공지사항/게시판 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 공지사항/게시판 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/board/notice" class="siSubMenuLink" data-main-menu="공지사항/게시판" data-sub-menu="공지사항">공지사항</a>
                <%-- 공지사항을 클릭하면 /board/notice 주소로 이동한다. --%>

                <a href="${pageContext.request.contextPath}/board/suggestion" class="siSubMenuLink" data-main-menu="공지사항/게시판" data-sub-menu="게시판">게시판</a>
                <%-- 게시판을 클릭하면 /board/suggestion 주소로 이동한다. --%>

            </div>
            <%-- 공지사항/게시판 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 공지사항/게시판 메뉴 그룹을 끝낸다. --%>


        <div class="siMenuGroup">
        <%-- 시스템 관리 큰 메뉴와 하위 메뉴를 묶는 영역이다. --%>

            <button type="button" class="siMenuTitle" data-main-menu="시스템 관리">
            <%-- 시스템 관리 하위 메뉴를 열고 닫는 버튼이다. --%>

                <span class="siMenuName">시스템 관리</span>
                <%-- 큰 메뉴 이름이다. --%>

                <span class="siMenuArrow">
                <%-- 큰 메뉴 오른쪽에 들어가는 SVG 화살표 영역이다. --%>

                    <svg class="siMenuArrowSvg" viewBox="0 0 24 24">
                    <%-- SVG 화살표 이미지를 그리기 위한 태그이다. --%>

                        <path d="M6 9L12 15L18 9"></path>
                        <%-- 아래 방향 화살표 모양을 그리는 선이다. --%>

                    </svg>
                    <%-- SVG 화살표 태그를 끝낸다. --%>

                </span>
                <%-- SVG 화살표 영역을 끝낸다. --%>

            </button>
            <%-- 시스템 관리 버튼을 끝낸다. --%>

            <div class="siSubMenu">
            <%-- 시스템 관리 하위 메뉴 영역이다. --%>

                <a href="${pageContext.request.contextPath}/system/userAuth" class="siSubMenuLink" data-main-menu="시스템 관리" data-sub-menu="사용자 / 권한 관리">사용자 / 권한 관리</a>
                <%-- 사용자 / 권한 관리를 클릭하면 /system/userAuth 주소로 이동한다. --%>

            </div>
            <%-- 시스템 관리 하위 메뉴 영역을 끝낸다. --%>

        </div>
        <%-- 시스템 관리 메뉴 그룹을 끝낸다. --%>

    </nav>
    <%-- 메뉴 전체 영역을 끝낸다. --%>


    <div class="siLogoutBox">
    <%-- 로그아웃 버튼이 들어가는 영역이다. --%>

        <a href="${pageContext.request.contextPath}/logout" class="siLogoutBtn">로그아웃</a>
        <%-- 로그아웃 버튼을 클릭하면 /logout 주소로 이동한다. --%>

    </div>
    <%-- 로그아웃 영역을 끝낸다. --%>

</aside>
<%-- 사이드바 전체 영역을 끝낸다. --%>