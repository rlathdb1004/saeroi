<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
    href="${pageContext.request.contextPath}/resources/css/inspection.css">

<div class="coPageWrap qiPage">

    <form class="coSearchBox qiSearchBox" method="get"
        action="${pageContext.request.contextPath}/quality/inspection">

        <div class="coSearchRow qiSearchRow">

            <div class="coSearchItem qiDateItem">
                <label class="coLabel">검사일자</label>

                <div class="qiDateBox">
                    <input type="date" name="startDate" class="coInput coDate">
                    <span class="qiDateDash">~</span>
                    <input type="date" name="endDate" class="coInput coDate">
                </div>
            </div>

            <div class="coSearchItem qiTypeItem">
                <label class="coLabel">구분</label>

                <select name="searchType" class="coSelect">
                    <option value="">선택</option>
                    <option value="inspId">품목명</option>
                    <option value="itemName">LOT번호</option>
                    <option value="result">검사자</option>
                    <option value="result">검사결과</option>
                </select>
            </div>

            <div class="coSearchItem qiKeywordItem">
                <label class="coLabel">&nbsp;</label>

                <input type="text" name="keyword" class="coInput"
                    placeholder="내용을 입력하세요.">
            </div>

            <div class="coSearchBtnBox qiSearchBtnBox">
                <button type="submit" class="coBtn coBtnSearch">검색</button>
                <button type="reset" class="coBtn coBtnReset">초기화</button>
            </div>

        </div>

    </form>

    <div class="coTableTop">
        <p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

        <button type="button" class="coBtn coBtnPrimary">+ 등록</button>
    </div>

    <div class="coTableWrap">
        <table class="coTable">
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
                    <tr>
                        <td>
                            <input type="checkbox" name="insp_id"
                                value="${inspection.insp_id}" class="qiCheck">
                        </td>
                        <td>${inspection.insp_id}</td>
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
                    <tr>
                        <td colspan="8">조회된 검사 내역이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>
