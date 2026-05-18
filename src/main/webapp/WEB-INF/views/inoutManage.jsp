<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	/* 테이블 너비 고정 */
	.coTable {
		table-layout: fixed;
		width: 100%;
	}

	/* 테이블 글자 줄임 */
	.coTable th,
	.coTable td {
		font-size: 12px;
		padding: 9px 6px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		text-align: center;
	}

	/* 모달 배경 */
	.inoutModalBg {
		display: none;
		position: fixed;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.55);
		z-index: 1000;
	}

	/* 모달 박스 */
	.inoutModalBox {
		width: 720px;
		background-color: white;
		margin: 70px auto;
		border-radius: 18px;
		overflow: hidden;
	}

	/* 모달 제목 */
	.inoutModalTitle {
		background-color: #1F2933;
		color: white;
		padding: 20px;
		font-size: 22px;
		font-weight: bold;
		display: flex;
		justify-content: space-between;
	}

	/* 모달 내용 */
	.inoutModalContent {
		padding: 25px;
	}

	/* 모달 입력 줄 */
	.inoutFormGrid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 15px;
	}

	/* 모달 label */
	.inoutFormBox label {
		font-weight: bold;
		display: block;
		margin-bottom: 8px;
	}

	/* 모달 input, select */
	.inoutFormBox input,
	.inoutFormBox select {
		width: 100%;
		height: 42px;
		border: 1px solid #cbd5df;
		border-radius: 10px;
		padding: 0 12px;
		box-sizing: border-box;
	}

	/* 비고 */
	.inoutRemark {
		margin-top: 15px;
	}

	.inoutRemark textarea {
		width: 100%;
		height: 85px;
		border: 1px solid #cbd5df;
		border-radius: 10px;
		padding: 12px;
		box-sizing: border-box;
		resize: none;
	}

	/* 저장 버튼 영역 */
	.inoutSaveArea {
		text-align: right;
		margin-top: 20px;
	}
</style>

<div class="coPageWrap">

	<!-- 검색 영역 -->
	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">

			<div class="search-row">

				<!-- 구분 -->
				<div class="search-item">

					<label class="search-label">
						구분
					</label>

					<select name="searchType"
						class="search-select">

						<option value="">
							선택
						</option>

						<option value="itemCode"
							<c:if test="${searchType eq 'itemCode'}">selected</c:if>>
							품목코드
						</option>

						<option value="itemName"
							<c:if test="${searchType eq 'itemName'}">selected</c:if>>
							품목명
						</option>

					</select>

				</div>

				<!-- 시작일 -->
				<div class="search-item">

					<label class="search-label">
						시작일
					</label>

					<input type="date"
						name="startDate"
						class="search-date"
						value="${startDate}">

				</div>

				<!-- 종료일 -->
				<div class="search-item">

					<label class="search-label">
						종료일
					</label>

					<input type="date"
						name="endDate"
						class="search-date"
						value="${endDate}">

				</div>

				<!-- 검색어 -->
				<div class="search-item">

					<label class="search-label">
						검색어
					</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">

				</div>

				<!-- 검색 / 초기화 버튼 -->
				<div class="search-btn-wrap">

					<button type="submit"
						class="search-btn search-btn-main">

						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5"
								cy="10.5"
								r="7.5"
								stroke="currentColor"
								stroke-width="2"></circle>

							<path d="M16 16L21 21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>
						</svg>

						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">

						<svg viewBox="0 0 24 24" fill="none">
							<path d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>

							<path d="M18 4V7H21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round"></path>
						</svg>

						초기화
					</button>

				</div>

			</div>

		</div>

	</form>

	<!-- 삭제용 form -->
	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/materialIn/delete">

		<!-- 총 건수 / 등록 버튼 / 선택 삭제 버튼 -->
		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<!-- 팀장님 공통 버튼 위치 -->
			<div class="search-btn-right">

				<button type="button"
					class="search-btn search-btn-main"
					onclick="openInoutModal()">
					등록
				</button>

				<button type="button"
					class="search-btn search-btn-sub"
					onclick="deleteCheck()">
					선택 삭제
				</button>

			</div>

		</div>

		<!-- 테이블 -->
		<div class="coTableWrap">

			<table class="coTable">

				<thead>

					<tr>
						<th>
							<input type="checkbox"
								id="checkAll">
						</th>

						<th>NO</th>
						<th>입출고번호</th>
						<th>입출고구분</th>
						<th>품목코드</th>
						<th>품목유형</th>
						<th>품목명</th>
						<th>입출고량</th>
						<th>단위</th>
						<th>일자</th>
						<th>보기</th>
					</tr>

				</thead>

				<tbody>

					<c:forEach var="inout"
						items="${list}"
						varStatus="status">

						<tr>
							<td>
								<input type="checkbox"
									name="inoutIds"
									value="${inout.inoutId}">
							</td>

							<td>${status.count}</td>

							<td title="${inout.docNo}">
								${inout.docNo}
							</td>

							<td>
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">
										입고
									</c:when>

									<c:when test="${inout.inoutType eq 'MO-PROD'}">
										출고
									</c:when>

									<c:otherwise>
										${inout.inoutType}
									</c:otherwise>
								</c:choose>
							</td>

							<td title="${inout.itemCode}">
								${inout.itemCode}
							</td>

							<td>
								<c:choose>
									<c:when test="${inout.itemType eq 'FG'}">
										완제품
									</c:when>

									<c:when test="${inout.itemType eq 'RM'}">
										원자재
									</c:when>

									<c:when test="${inout.itemType eq 'SM'}">
										부자재
									</c:when>

									<c:otherwise>
										${inout.itemType}
									</c:otherwise>
								</c:choose>
							</td>

							<td title="${inout.itemName}">
								${inout.itemName}
							</td>

							<td>${inout.inoutQty}</td>
							<td>${inout.itemUnit}</td>
							<td>${inout.inoutDate}</td>

							<td>
								<button type="button"
									class="search-btn search-btn-sub"
									onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}'">
									보기
								</button>
							</td>

						</tr>

					</c:forEach>

				</tbody>

			</table>

		</div>

	</form>

	<!-- 공통 페이징 -->
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>