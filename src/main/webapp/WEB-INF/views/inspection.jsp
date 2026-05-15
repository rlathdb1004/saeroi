<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
    href="${pageContext.request.contextPath}/resources/css/inspection.css">

<div class="coPageWrap qiPage">
    <%-- 본문 전체를 감싸는 영역이다. --%>

    <form class="coSearchBox qiSearchBox" method="get"
        action="${pageContext.request.contextPath}/quality/inspection">
        <%-- 검색 조건들이 들어가는 영역이다. --%>

        <div class="coSearchRow qiSearchRow">

            <div class="coSearchItem qiDateItem">
                <%-- 검사일자 검색 영역이다. --%>

                <label class="coLabel">검사일자</label>

                <div class="qiDateBox">
                    <input type="date" name="startDate" class="coInput coDate">
                    <span class="qiDateDash">~</span>
                    <input type="date" name="endDate" class="coInput coDate">
                </div>
            </div>

            <div class="coSearchItem qiTypeItem">
                <%-- 검색 구분 선택 영역이다. --%>

                <label class="coLabel">구분</label>

                <select name="searchType" class="coSelect">
                    <option value="">선택</option>
                    <option value="itemName">품목명</option>
                    <option value="productLot">LOT번호</option>
                    <option value="ename">검사자</option>
                    <option value="result">검사결과</option>
                </select>
            </div>

            <div class="coSearchItem qiKeywordItem">
                <%-- 검색어 입력 영역이다. --%>

                <label class="coLabel">&nbsp;</label>

                <input type="text" name="keyword" class="coInput"
                    placeholder="내용을 입력하세요.">
            </div>

            <div class="coSearchBtnBox qiSearchBtnBox">
                <%-- 검색 버튼과 초기화 버튼 영역이다. --%>

                <button type="submit" class="coBtn coBtnSearch">검색</button>
                <button type="reset" class="coBtn coBtnReset">초기화</button>
            </div>

        </div>

    </form>
    <%-- 검색 영역을 끝낸다. --%>


    <div class="coTableTop">
        <%-- 총 건수와 등록 버튼이 들어가는 영역이다. --%>

        <p class="coTotalCount">총 ${pageInfo.totalCount}건</p>
        <%-- DB에서 조회한 전체 데이터 개수를 보여준다. --%>

        <button type="button" class="coBtn coBtnPrimary">+ 등록</button>

    </div>
    <%-- 테이블 상단 영역을 끝낸다. --%>


    <div class="coTableWrap">
        <%-- 테이블을 감싸는 영역이다. --%>

        <table class="coTable">
            <%-- 공통 테이블 디자인을 사용하는 테이블이다. --%>

            <thead>
                <tr>
                    <th style="width: 80px;">선택</th>
                    <th style="width: 130px;">검사번호</th>
                    <th style="width: 130px;">검사일시</th>
                    <th style="width: 180px;">품목명</th>
                    <th style="width: 130px;">LOT번호</th>
                    <th style="width: 130px;">검사자</th>
                    <th style="width: 130px;">검사결과</th>
                    <th style="width: 130px;">상세</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="inspection" items="${list}">
                    <%-- Controller에서 보낸 검사 목록을 한 줄씩 반복한다. --%>

                    <tr>
                        <td>
                            <input type="checkbox" name="insp_id"
                                value="${inspection.insp_id}" class="qiCheck">
                        </td>
                        <td>${inspection.doc_no}</td>
                        <td>${inspection.insp_date}</td>
                        <td class="coTextLeft">${inspection.item_name}</td>
                        <td>${inspection.product_lot}</td>
                        <td>${inspection.ename}</td>
                        <td>
                            <span class="coStatus coStatusUse">${inspection.result}</span>
                        </td>
                        <td>
                            <button type="button" class="coDetailBtn">보기</button>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty list}">
                    <%-- 조회된 검사 목록이 없을 때 보여주는 줄이다. --%>

                    <tr>
                        <td colspan="8">조회된 검사 내역이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>

        </table>
        <%-- 공통 테이블을 끝낸다. --%>

    </div>
    <%-- 테이블 감싸는 영역을 끝낸다. --%>


    <jsp:include page="/WEB-INF/views/common/paging.jsp" />
    <%-- 공통 페이징 화면을 불러온다. --%>

</div>
<%-- 본문 전체 영역을 끝낸다. --%>

<script src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>
