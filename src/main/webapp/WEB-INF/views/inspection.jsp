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
					<input type="date" name="startDate" class="coInput coDate"
						value="${startDate}"> <span class="qiDateDash">~</span> <input
						type="date" name="endDate" class="coInput coDate"
						value="${endDate}">
				</div>
			</div>

			<div class="coSearchItem qiTypeItem">
				<%-- 검색 구분 선택 영역이다. --%>

				<label class="coLabel">구분</label> <select name="searchType"
					class="coSelect">
					<option value="">선택</option>
					<option value="insp_id"
						<c:if test="${searchType == 'insp_id'}">selected</c:if>>검사번호</option>
					<option value="itemName"
						<c:if test="${searchType == 'itemName'}">selected</c:if>>품목명</option>
					<option value="productLot"
						<c:if test="${searchType == 'productLot'}">selected</c:if>>LOT번호</option>
					<option value="ename"
						<c:if test="${searchType == 'ename'}">selected</c:if>>검사자</option>
					<option value="result"
						<c:if test="${searchType == 'result'}">selected</c:if>>검사결과</option>
				</select>

			</div>

			<div class="coSearchItem qiKeywordItem">
				<%-- 검색어 입력 영역이다. --%>

				<label class="coLabel">&nbsp;</label> <input type="text"
					name="keyword" class="coInput" placeholder="내용을 입력하세요."
					value="${keyword}">

			</div>

			<div class="coSearchBtnBox qiSearchBtnBox">
				<%-- 검색 버튼과 초기화 버튼 영역이다. --%>

				<button type="submit" class="coBtn coBtnSearch">검색</button>
				<!-- 기본 주소/특정주소 -->
				<a href="${pageContext.request.contextPath}/quality/inspection"
					class="coBtn coBtnReset">초기화</a>

			</div>

		</div>

	</form>
	<%-- 검색 영역을 끝낸다. --%>


	<div class="coTableTop">
		<%-- 총 건수와 등록 버튼이 들어가는 영역이다. --%>
    
		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>
		<%-- DB에서 조회한 전체 데이터 개수를 보여준다. --%>

		<button type="button" class="coBtn coBtnPrimary qiRegisterOpenBtn">등록</button>


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
						<td><input type="checkbox" name="insp_id"
							value="${inspection.insp_id}" class="qiCheck"></td>
						<td>${inspection.doc_no}</td>
						<td>${inspection.insp_date}</td>
						<td class="coTextLeft">${inspection.item_name}</td>
						<td>${inspection.product_lot}</td>
						<td>${inspection.ename}</td>
						<td><span class="coStatus coStatusUse">${inspection.result}</span>
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

<!-- 검사 등록 모달 -->
<div class="qiModal qiRegisterModal">
	<%-- 등록 버튼을 눌렀을 때 열리는 모달 배경 --%>

	<div class="qiModalBox qiRegisterModalBox">
		<%-- 실제 모달 내용 영역 --%>

		<div class="qiModalHeader">
			<%-- 모달 제목과 닫기 버튼 영역 --%>

			<h3 class="qiModalTitle">검사 등록</h3>

			<button type="button" class="qiModalCloseBtn">×</button>
		</div>

		<form class="qiModalForm" method="post"
			action="${pageContext.request.contextPath}/quality/inspection/add">
			<%-- 검사 등록 정보를 입력하는 영역 --%>

			<div class="qiModalBody qiRegisterModalBody">

				<div class="qiFormRow">
					<label class="qiFormLabel">검사일시</label> <input type="date"
						name="insp_date" class="coInput qiFormInput">
				</div>

				<div class="qiFormRow">
					<label class="qiFormLabel">품목명</label> <select name="prod_id"
						class="coSelect qiFormInput">
						<option value="">선택</option>
					</select>
				</div>


				<div class="qiFormRow">
					<label class="qiFormLabel">검사자</label> <select name="emp_id"
						class="coSelect qiFormInput">
						<option value="">선택</option>
					</select>
				</div>

				<div class="qiFormRow">
					<label class="qiFormLabel">검사구분</label> <select name="insp_type"
						class="coSelect qiFormInput">
						<option value="">선택</option>
						<option value="외관검사">외관검사</option>
						<option value="치수검사">치수검사</option>
						<option value="품질판정">품질판정</option>
						<option value="재검사">재검사</option>
					</select>
				</div>

				<div class="qiFormRow">
					<label class="qiFormLabel">검사결과</label> <select name="result"
						class="coSelect qiFormInput">
						<option value="">선택</option>
					</select>
				</div>

				<div class="qiFormRow">
					<label class="qiFormLabel">검사수량</label> <input type="number"
						name="inspection_qty" class="coInput qiFormInput" min="0">
				</div>

				<div class="qiFormRow">
					<label class="qiFormLabel">양품수량</label> <input type="number"
						name="good_qty" class="coInput qiFormInput" min="0">
				</div>

				<div class="qiFormRow">
					<label class="qiFormLabel">검사 상세</label> <select name="remark"
						class="coSelect qiFormInput">
						<option value="">선택</option>
					</select>
				</div>

			</div>

			<div class="qiModalFooter">
				<%-- 등록/취소 버튼 영역 --%>

				<button type="button" class="coBtn coBtnReset qiModalCancelBtn">취소</button>
				<button type="submit" class="coBtn coBtnPrimary">등록</button>
			</div>

		</form>
	</div>
</div>


<script
	src="${pageContext.request.contextPath}/resources/js/inspection.js"></script>
