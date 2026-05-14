<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<%-- <%@ page session="false" %> --%>
<!-- <html> -->
<!-- <head> -->
<!-- 	<title>Home</title> -->
<!-- </head> -->
<!-- <body> -->
<!-- <h1> -->
<!-- 	Hello world!   -->
<!-- </h1> -->

<%-- <P>  The time on the server is ${serverTime}. </P> --%>
<!-- </body> -->
<!-- </html> -->

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 이 JSP 파일에서 한글이 깨지지 않도록 UTF-8로 설정한다. --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- c:forEach, c:choose, c:when, c:otherwise를 사용하기 위해 JSTL을 추가한다. --%>

<div class="coPageWrap">
<%-- 본문 전체를 감싸는 공통 영역이다. --%>

    <div class="coTableTop">
    <%-- 총 건수와 등록 버튼이 들어가는 테이블 상단 영역이다. --%>

        <p class="coTotalCount">총 ${pageInfo.totalCount}건</p>
        <%-- PageDTO에 들어있는 전체 데이터 개수를 보여준다. --%>

        <a href="javascript:void(0);" class="coBtn coBtnPrimary">
        <%-- 아직 등록 페이지가 없기 때문에 이동하지 않는 임시 등록 버튼이다. --%>

            <svg class="coBtnIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
            <%-- 등록 버튼 앞에 들어가는 플러스 SVG 아이콘이다. --%>

                <path d="M12 5V19"></path>
                <%-- 플러스 아이콘의 세로 선이다. --%>

                <path d="M5 12H19"></path>
                <%-- 플러스 아이콘의 가로 선이다. --%>

            </svg>
            <%-- SVG 아이콘을 끝낸다. --%>

            BOM 등록
            <%-- 등록 버튼에 보여지는 글자이다. --%>

        </a>
        <%-- 등록 버튼을 끝낸다. --%>

    </div>
    <%-- 테이블 상단 영역을 끝낸다. --%>


    <div class="coTableWrap">
    <%-- 테이블을 감싸는 공통 영역이다. --%>

        <table class="coTable">
        <%-- 공통 테이블 디자인을 사용하는 테이블이다. --%>

            <thead>
            <%-- 테이블 제목 영역이다. --%>

                <tr>
                <%-- 테이블 제목 한 줄이다. --%>

                    <th style="width: 70px;">NO</th>
                    <%-- 번호 컬럼이다. --%>

                    <th style="width: 130px;">상위품목 코드</th>
                    <%-- 상위품목 코드 컬럼이다. --%>

                    <th style="width: 150px;">상위품목명</th>
                    <%-- 상위품목명 컬럼이다. --%>

                    <th style="width: 110px;">BOM 버전</th>
                    <%-- BOM 버전 컬럼이다. --%>

                    <th style="width: 190px;">버전명</th>
                    <%-- 버전명 컬럼이다. --%>

                    <th style="width: 100px;">총 자재 수</th>
                    <%-- 총 자재 수 컬럼이다. --%>

                    <th style="width: 100px;">사용여부</th>
                    <%-- 사용여부 컬럼이다. --%>

                    <th style="width: 120px;">시작일</th>
                    <%-- 시작일 컬럼이다. --%>

                    <th style="width: 120px;">종료일</th>
                    <%-- 종료일 컬럼이다. --%>

                    <th style="width: 100px;">상세보기</th>
                    <%-- 상세보기 버튼 컬럼이다. --%>

                </tr>
                <%-- 테이블 제목 한 줄을 끝낸다. --%>

            </thead>
            <%-- 테이블 제목 영역을 끝낸다. --%>


            <tbody>
            <%-- 테이블 내용 영역이다. --%>

                <c:forEach var="dto" items="${list}">
                <%-- Controller에서 보낸 list를 한 줄씩 반복한다. --%>

                    <tr>
                    <%-- 테이블 데이터 한 줄이다. --%>

                        <td>${dto.no}</td>
                        <%-- 번호를 출력한다. --%>

                        <td>${dto.itemCode}</td>
                        <%-- 상위품목 코드를 출력한다. --%>

                        <td class="coTextLeft">${dto.itemName}</td>
                        <%-- 상위품목명을 왼쪽 정렬로 출력한다. --%>

                        <td>${dto.bomVersion}</td>
                        <%-- BOM 버전을 출력한다. --%>

                        <td class="coTextLeft">${dto.versionName}</td>
                        <%-- 버전명을 왼쪽 정렬로 출력한다. --%>

                        <td>${dto.materialCount}</td>
                        <%-- 총 자재 수를 출력한다. --%>

                        <td>
                        <%-- 사용여부 칩이 들어가는 칸이다. --%>

                            <c:choose>
                            <%-- 사용인지 미사용인지 조건을 나눈다. --%>

                                <c:when test="${dto.useYn == '사용'}">
                                <%-- 사용 상태일 때 실행된다. --%>

                                    <span class="coStatus coStatusUse">사용</span>
                                    <%-- 사용 상태 초록색 칩을 보여준다. --%>

                                </c:when>
                                <%-- 사용 상태 조건을 끝낸다. --%>

                                <c:otherwise>
                                <%-- 사용이 아닌 경우 실행된다. --%>

                                    <span class="coStatus coStatusStop">미사용</span>
                                    <%-- 미사용 상태 빨간색 칩을 보여준다. --%>

                                </c:otherwise>
                                <%-- 미사용 상태 조건을 끝낸다. --%>

                            </c:choose>
                            <%-- 사용여부 조건을 끝낸다. --%>

                        </td>
                        <%-- 사용여부 칸을 끝낸다. --%>

                        <td>${dto.startDate}</td>
                        <%-- 시작일을 출력한다. --%>

                        <td>${dto.endDate}</td>
                        <%-- 종료일을 출력한다. --%>

                        <td>
                        <%-- 상세보기 버튼이 들어가는 칸이다. --%>

                            <button type="button" class="coDetailBtn">보기</button>
                            <%-- 상세보기 버튼이다. --%>

                        </td>
                        <%-- 상세보기 칸을 끝낸다. --%>

                    </tr>
                    <%-- 테이블 데이터 한 줄을 끝낸다. --%>

                </c:forEach>
                <%-- list 반복을 끝낸다. --%>

            </tbody>
            <%-- 테이블 내용 영역을 끝낸다. --%>

        </table>
        <%-- 공통 테이블을 끝낸다. --%>

    </div>
    <%-- 테이블 감싸는 영역을 끝낸다. --%>


    <jsp:include page="/WEB-INF/views/common/paging.jsp" />
    <%-- 공통 페이징 화면을 불러온다. --%>

</div>
<%-- 본문 전체 영역을 끝낸다. --%>