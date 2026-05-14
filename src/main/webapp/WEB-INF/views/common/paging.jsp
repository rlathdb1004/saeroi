<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 이 JSP 파일에서 한글이 깨지지 않도록 UTF-8로 설정한다. --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- c:if, c:forEach, c:choose 같은 JSTL 문법을 사용하기 위해 추가한다. --%>

<c:if test="${not empty pageInfo}">
<%-- pageInfo가 있을 때만 페이징을 보여준다. --%>

    <div class="coTableBottom">
    <%-- 페이징과 몇 개씩 보기가 들어가는 하단 영역이다. --%>

        <div class="coPaging">
        <%-- 페이지 버튼들을 감싸는 영역이다. --%>

            <c:choose>
            <%-- 첫 페이지 버튼을 눌렀을 때 이동 가능 여부를 나눈다. --%>

                <c:when test="${pageInfo.hasPrev}">
                <%-- 현재 페이지가 1보다 크면 첫 페이지로 이동할 수 있다. --%>

                    <a href="${pageContext.request.contextPath}${pageUrl}?page=1&size=${pageInfo.size}" class="coPageMoveBtn">
                    <%-- 첫 페이지로 이동하는 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                        <%-- SVG 아이콘을 그리기 위한 태그이다. --%>

                            <path d="M11 18L5 12L11 6"></path>
                            <%-- 첫 번째 왼쪽 화살표 선이다. --%>

                            <path d="M19 18L13 12L19 6"></path>
                            <%-- 두 번째 왼쪽 화살표 선이다. --%>

                        </svg>
                        <%-- SVG 아이콘을 끝낸다. --%>

                    </a>
                    <%-- 첫 페이지 이동 버튼을 끝낸다. --%>

                </c:when>
                <%-- 첫 페이지로 이동할 수 있는 경우를 끝낸다. --%>

                <c:otherwise>
                <%-- 현재 페이지가 1페이지면 첫 페이지로 이동할 필요가 없다. --%>

                    <span class="coPageMoveBtn disabled">
                    <%-- 비활성화된 첫 페이지 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                            <path d="M11 18L5 12L11 6"></path>
                            <path d="M19 18L13 12L19 6"></path>
                        </svg>
                        <%-- 비활성화된 첫 페이지 SVG 아이콘이다. --%>

                    </span>
                    <%-- 비활성화된 첫 페이지 버튼을 끝낸다. --%>

                </c:otherwise>
                <%-- 첫 페이지로 이동할 수 없는 경우를 끝낸다. --%>

            </c:choose>
            <%-- 첫 페이지 버튼 조건을 끝낸다. --%>


            <c:choose>
            <%-- 이전 페이지 버튼을 눌렀을 때 이동 가능 여부를 나눈다. --%>

                <c:when test="${pageInfo.hasPrev}">
                <%-- 현재 페이지가 1보다 크면 이전 페이지로 이동할 수 있다. --%>

                    <a href="${pageContext.request.contextPath}${pageUrl}?page=${pageInfo.prevPage}&size=${pageInfo.size}" class="coPageMoveBtn">
                    <%-- 이전 페이지로 이동하는 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                        <%-- SVG 아이콘을 그리기 위한 태그이다. --%>

                            <path d="M15 18L9 12L15 6"></path>
                            <%-- 왼쪽 화살표 선이다. --%>

                        </svg>
                        <%-- SVG 아이콘을 끝낸다. --%>

                    </a>
                    <%-- 이전 페이지 이동 버튼을 끝낸다. --%>

                </c:when>
                <%-- 이전 페이지로 이동할 수 있는 경우를 끝낸다. --%>

                <c:otherwise>
                <%-- 현재 페이지가 1페이지면 이전 페이지로 이동할 수 없다. --%>

                    <span class="coPageMoveBtn disabled">
                    <%-- 비활성화된 이전 페이지 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                            <path d="M15 18L9 12L15 6"></path>
                        </svg>
                        <%-- 비활성화된 이전 페이지 SVG 아이콘이다. --%>

                    </span>
                    <%-- 비활성화된 이전 페이지 버튼을 끝낸다. --%>

                </c:otherwise>
                <%-- 이전 페이지로 이동할 수 없는 경우를 끝낸다. --%>

            </c:choose>
            <%-- 이전 페이지 버튼 조건을 끝낸다. --%>


            <c:forEach var="num" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
            <%-- 시작 페이지부터 끝 페이지까지 페이지 번호를 반복해서 만든다. --%>

                <c:choose>
                <%-- 현재 페이지인지 아닌지 나눈다. --%>

                    <c:when test="${num == pageInfo.page}">
                    <%-- 현재 보고 있는 페이지 번호이다. --%>

                        <span class="coPageBtn active">${num}</span>
                        <%-- 현재 페이지라서 초록색 active 디자인을 적용한다. --%>

                    </c:when>
                    <%-- 현재 페이지인 경우를 끝낸다. --%>

                    <c:otherwise>
                    <%-- 현재 페이지가 아닌 번호이다. --%>

                        <a href="${pageContext.request.contextPath}${pageUrl}?page=${num}&size=${pageInfo.size}" class="coPageBtn">${num}</a>
                        <%-- 해당 번호 페이지로 이동하는 버튼이다. --%>

                    </c:otherwise>
                    <%-- 현재 페이지가 아닌 경우를 끝낸다. --%>

                </c:choose>
                <%-- 현재 페이지 조건을 끝낸다. --%>

            </c:forEach>
            <%-- 페이지 번호 반복을 끝낸다. --%>


            <c:choose>
            <%-- 다음 페이지 버튼을 눌렀을 때 이동 가능 여부를 나눈다. --%>

                <c:when test="${pageInfo.hasNext}">
                <%-- 현재 페이지가 마지막 페이지보다 작으면 다음 페이지로 이동할 수 있다. --%>

                    <a href="${pageContext.request.contextPath}${pageUrl}?page=${pageInfo.nextPage}&size=${pageInfo.size}" class="coPageMoveBtn">
                    <%-- 다음 페이지로 이동하는 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                        <%-- SVG 아이콘을 그리기 위한 태그이다. --%>

                            <path d="M9 18L15 12L9 6"></path>
                            <%-- 오른쪽 화살표 선이다. --%>

                        </svg>
                        <%-- SVG 아이콘을 끝낸다. --%>

                    </a>
                    <%-- 다음 페이지 이동 버튼을 끝낸다. --%>

                </c:when>
                <%-- 다음 페이지로 이동할 수 있는 경우를 끝낸다. --%>

                <c:otherwise>
                <%-- 현재 페이지가 마지막 페이지면 다음 페이지로 이동할 수 없다. --%>

                    <span class="coPageMoveBtn disabled">
                    <%-- 비활성화된 다음 페이지 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                            <path d="M9 18L15 12L9 6"></path>
                        </svg>
                        <%-- 비활성화된 다음 페이지 SVG 아이콘이다. --%>

                    </span>
                    <%-- 비활성화된 다음 페이지 버튼을 끝낸다. --%>

                </c:otherwise>
                <%-- 다음 페이지로 이동할 수 없는 경우를 끝낸다. --%>

            </c:choose>
            <%-- 다음 페이지 버튼 조건을 끝낸다. --%>


            <c:choose>
            <%-- 마지막 페이지 버튼을 눌렀을 때 이동 가능 여부를 나눈다. --%>

                <c:when test="${pageInfo.hasNext}">
                <%-- 현재 페이지가 마지막 페이지가 아니면 마지막 페이지로 이동할 수 있다. --%>

                    <a href="${pageContext.request.contextPath}${pageUrl}?page=${pageInfo.totalPage}&size=${pageInfo.size}" class="coPageMoveBtn">
                    <%-- 마지막 페이지로 이동하는 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                        <%-- SVG 아이콘을 그리기 위한 태그이다. --%>

                            <path d="M5 18L11 12L5 6"></path>
                            <%-- 첫 번째 오른쪽 화살표 선이다. --%>

                            <path d="M13 18L19 12L13 6"></path>
                            <%-- 두 번째 오른쪽 화살표 선이다. --%>

                        </svg>
                        <%-- SVG 아이콘을 끝낸다. --%>

                    </a>
                    <%-- 마지막 페이지 이동 버튼을 끝낸다. --%>

                </c:when>
                <%-- 마지막 페이지로 이동할 수 있는 경우를 끝낸다. --%>

                <c:otherwise>
                <%-- 현재 페이지가 마지막 페이지면 마지막 페이지로 이동할 필요가 없다. --%>

                    <span class="coPageMoveBtn disabled">
                    <%-- 비활성화된 마지막 페이지 버튼이다. --%>

                        <svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">
                            <path d="M5 18L11 12L5 6"></path>
                            <path d="M13 18L19 12L13 6"></path>
                        </svg>
                        <%-- 비활성화된 마지막 페이지 SVG 아이콘이다. --%>

                    </span>
                    <%-- 비활성화된 마지막 페이지 버튼을 끝낸다. --%>

                </c:otherwise>
                <%-- 마지막 페이지로 이동할 수 없는 경우를 끝낸다. --%>

            </c:choose>
            <%-- 마지막 페이지 버튼 조건을 끝낸다. --%>

        </div>
        <%-- 페이지 버튼 영역을 끝낸다. --%>


        <div class="coPageSizeBox">
        <%-- 몇 개씩 볼지 선택하는 영역이다. --%>

            <select class="coPageSizeSelect" onchange="location.href='${pageContext.request.contextPath}${pageUrl}?page=1&size=' + this.value;">
            <%-- 선택한 개수만큼 다시 조회하기 위해 page=1로 이동한다. --%>

                <option value="5" <c:if test="${pageInfo.size == 5}">selected</c:if>>5개씩 보기</option>
                <%-- 한 페이지에 5개씩 보는 옵션이다. --%>

                <option value="10" <c:if test="${pageInfo.size == 10}">selected</c:if>>10개씩 보기</option>
                <%-- 한 페이지에 10개씩 보는 옵션이다. --%>

                <option value="30" <c:if test="${pageInfo.size == 30}">selected</c:if>>30개씩 보기</option>
                <%-- 한 페이지에 30개씩 보는 옵션이다. --%>

            </select>
            <%-- 보기 개수 선택박스를 끝낸다. --%>

        </div>
        <%-- 보기 개수 선택 영역을 끝낸다. --%>

    </div>
    <%-- 페이징 하단 영역을 끝낸다. --%>

</c:if>
<%-- pageInfo가 있을 때만 보여주는 조건을 끝낸다. --%>