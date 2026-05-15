<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/inspection.css">

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
					<span>~</span> <input type="date" name="endDate"
						class="coInput coDate">
				</div>
			</div>

			<div class="coSearchItem qiTypeItem">
				<%-- 검사구분 선택 영역이다. --%>

				<label class="coLabel">구분</label> <select name="inspectionType"
					class="coSelect">
					<option value="">선택</option>
					<option value="1">검사번호</option>
					<option value="2">품목명</option>
					<option value="3">검사결과</option>
				</select>
			</div>

			<div class="coSearchItem qiKeywordItem">
				<%-- 검색어 입력 영역이다. --%>

				<label class="coLabel">검색어</label>

				<div class="qiKeywordBox">
					<input type="text" name="keyword" class="coInput"
						placeholder="검사구분을 입력하세요.">
					<button type="button" class="coBtn coBtnSearch qiSmallSearchBtn">조회</button>

				</div>
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

		<div class="qiTableTopBtnBox">
			<button type="button" class="coBtn coBtnReset">엑셀 다운로드</button>
			<button type="button" class="coBtn coBtnPrimary">등록</button>
		</div>

	</div>
	<%-- 테이블 상단 영역을 끝낸다. --%>


	<div class="coTableWrap">
		<%-- 테이블을 감싸는 영역이다. --%>

		<table class="coTable">
			<%-- 공통 테이블 디자인을 사용하는 테이블이다. --%>

			<thead>
				<tr>
					<th style="width: 120px;">검사번호</th>
					<th style="width: 130px;">검사일시</th>
					<th style="width: 130px;">품목명</th>
					<th style="width: 120px;">검사결과</th>
				</tr>
			</thead>

			<tbody>
				<c:forEach var="inspection" items="${list}">
					<%-- Controller에서 보낸 검사 목록을 한 줄씩 반복한다. --%>

					<tr>
						<td>${inspection.inspId}</td>
						<td>${inspection.inspDate}</td>
						<td class="coTextLeft">${inspection.item_name}</td>
						<td><span class="coStatus coStatusUse">${inspection.result}</span>
						</td>
					</tr>
				</c:forEach>

				<c:if test="${empty list}">
					<%-- 조회된 검사 목록이 없을 때 보여주는 줄이다. --%>

					<tr>
						<td colspan="4">조회된 검사 내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>

		</table>
		<%-- 공통 테이블을 끝낸다. --%>

	</div>
	<%-- 테이블 감싸는 영역을 끝낸다. --%>

	<div class="qiLookupModal" id="lookupModal">

		<div class="qiLookupModalBox">

			<div class="qiLookupModalHeader">

				<div>
					<p class="qiLookupModalSubTitle">선택 목록</p>
					<h3 class="qiLookupModalTitle" id="lookupModalTitle">목록 선택</h3>
				</div>

				<button type="button" class="qiLookupModalClose"
					id="closeLookupModal">×</button>
			</div>

			<div class="qiLookupModalBody">

				<div class="qiLookupModalList" id="lookupModalList">

					<button type="button" class="qiLookupModalItem">IN-1000</button>

					<button type="button" class="qiLookupModalItem">IN-1001</button>

					<button type="button" class="qiLookupModalItem">IN-1002</button>
				</div>
			</div>

			<div class="qiLookupModalFooter">

				<button type="button" class="coBtn coBtnReset"
					id="cancelLookupModal">취소</button>
			</div>

		</div>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/common/inspection.js"></script>
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	<%-- 공통 페이징 화면을 불러온다. --%>

</div>
<%-- 본문 전체 영역을 끝낸다. --%>
