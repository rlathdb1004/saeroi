<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%-- =========================================================
	관리자 / 매니저 권한 체크
========================================================= --%>
<c:set var="isAdmin"
	value="${sessionScope.member.role eq 'ADMIN'
		or sessionScope.member.role eq 'MANAGER'
		or sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'
		or sessionScope.member.job eq '관리자'
		or sessionScope.loginUser.job eq '관리자'}" />

<div class="coPageWrap">

	<%-- =========================================================
		검색 영역
	========================================================= --%>
	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">

			<div class="search-row">

				<%-- 시작일 --%>
				<div class="search-item">

					<label class="search-label">
						시작일
					</label>

					<input type="date"
						name="startDate"
						class="search-date"
						value="${startDate}">

				</div>

				<%-- 종료일 --%>
				<div class="search-item">

					<label class="search-label">
						종료일
					</label>

					<input type="date"
						name="endDate"
						class="search-date"
						value="${endDate}">

				</div>

				<%-- 구분 --%>
				<div class="search-item">

					<label class="search-label">
						구분
					</label>

					<select name="inoutType"
						class="search-select">

						<option value="">
							전체
						</option>

						<option value="MI"
							<c:if test="${inoutType eq 'MI'}">selected</c:if>>

							입고

						</option>

						<option value="MO-PROD"
							<c:if test="${inoutType eq 'MO-PROD'}">selected</c:if>>

							출고

						</option>

					</select>

				</div>

				<%-- 검색어 --%>
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

				<%-- 검색 버튼 영역 --%>
				<div class="search-btn-wrap">

					<%-- =====================================================
						검색 버튼
					===================================================== --%>
					<button type="submit"
						class="search-btn search-btn-main">

						<svg viewBox="0 0 24 24"
							fill="none">

							<circle cx="10.5"
								cy="10.5"
								r="7.5"
								stroke="currentColor"
								stroke-width="2">
							</circle>

							<path d="M16 16L21 21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

						</svg>

						검색

					</button>

					<%-- =====================================================
						초기화 버튼
					===================================================== --%>
					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">

						<svg viewBox="0 0 24 24"
							fill="none">

							<path d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M18 4V7H21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"
								stroke-linejoin="round">
							</path>

						</svg>

						초기화

					</button>

				</div>

			</div>

		</div>

	</form>

	<%-- =========================================================
		삭제 form
	========================================================= --%>
	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/materialIn/delete">

		<div class="coTableTop">

			<%-- 총 건수 --%>
			<p class="coTotalCount">

				총 ${pageInfo.totalCount}건

			</p>

			<%-- 관리자 / 매니저만 출력 --%>
			<c:if test="${isAdmin}">

				<div class="search-btn-right">

					<%-- =====================================================
						등록 버튼
						플러스 SVG 추가
						기존 공통 클래스 유지
					===================================================== --%>
					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">

						<svg viewBox="0 0 24 24"
							fill="none">

							<path d="M12 5V19"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M5 12H19"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

						</svg>

						등록

					</button>

					<%-- =====================================================
						선택 삭제 버튼
						휴지통 SVG 추가
						기존 공통 클래스 유지
					===================================================== --%>
					<button type="button"
						class="search-btn search-btn-sub"
						onclick="deleteCheck()">

						<svg viewBox="0 0 24 24"
							fill="none">

							<path d="M4 7H20"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M10 11V17"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M14 11V17"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

							<path d="M6 7L7 21H17L18 7"
								stroke="currentColor"
								stroke-width="2"
								stroke-linejoin="round">
							</path>

							<path d="M9 7V4H15V7"
								stroke="currentColor"
								stroke-width="2"
								stroke-linejoin="round">
							</path>

						</svg>

						선택 삭제

					</button>

				</div>

			</c:if>

		</div>

		<%-- =========================================================
			입출고 목록 테이블
		========================================================= --%>
		<div class="coTableWrap">

			<table class="coTable">

				<thead>

					<tr>

						<th class="mobile_show">

							<label id="checkAllLabel">
								선택
							</label>

							<input type="checkbox"
								id="checkAll"
								style="display:none;">

						</th>

						<th class="mobile_hidden">
							입출고번호
						</th>

						<th class="mobile_hidden">
							입출고구분
						</th>

						<th class="mobile_show">
							품목명
						</th>

						<th class="mobile_hidden">
							입출고량
						</th>

						<th class="mobile_hidden">
							단위
						</th>

						<th class="mobile_show">
							일자
						</th>

						<th class="mobile_show">
							상세
						</th>

					</tr>

				</thead>

				<tbody>

					<c:forEach var="inout"
						items="${list}">

						<tr>

							<%-- 체크박스 --%>
							<td class="mobile_show">

								<input type="checkbox"
									name="inoutIds"
									value="${inout.inoutId}">

							</td>

							<%-- 입출고번호 --%>
							<td class="mobile_hidden">
								${inout.docNo}
							</td>

							<%-- 입출고구분 --%>
							<td class="mobile_hidden">

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

							<%-- 품목명 --%>
							<td class="mobile_show">
								${inout.itemName}
							</td>

							<%-- 입출고량 --%>
							<td class="mobile_hidden">
								${inout.inoutQty}
							</td>

							<%-- 단위 --%>
							<td class="mobile_hidden">
								${inout.itemUnit}
							</td>

							<%-- 일자 --%>
							<td class="mobile_show">
								${inout.inoutDate}
							</td>

							<%-- =================================================
								상세 버튼
								공통 클래스 유지
							================================================= --%>
							<td class="mobile_show">

								<button type="button"
									class="coDetailBtn"
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

	<%-- =========================================================
		등록 모달
	========================================================= --%>
	<div id="modal_insert"
		class="modal_wrap"
		aria-hidden="true">

		<div class="modal_box"
			role="dialog"
			aria-modal="true">

			<div class="modal_header">

				<h3 class="modal_title">
					자재 입출고 등록
				</h3>

			</div>

			<form class="modal_form"
				method="post"
				action="${pageContext.request.contextPath}/inventory/materialIn/insert"
				onsubmit="return checkInoutInsert();">

				<div class="modal_body modal_body_2col">

					<div class="modal_item">

						<label class="modal_label">
							입출고구분
							<span class="modal_required">*</span>
						</label>

						<select name="inoutType"
							id="insertInoutType"
							class="modal_select"
							required>

							<option value="">선택</option>
							<option value="MI">입고</option>
							<option value="MO-PROD">출고</option>

						</select>

					</div>

					<div class="modal_item">

						<label class="modal_label">
							품목명
							<span class="modal_required">*</span>
						</label>

						<select name="itemId"
							id="insertItemId"
							class="modal_select"
							required>

							<option value="">선택</option>

							<c:forEach var="item"
								items="${itemList}">

								<option value="${item.itemId}">
									${item.itemName}
								</option>

							</c:forEach>

						</select>

					</div>

					<div class="modal_item">

						<label class="modal_label">
							입출고수량
							<span class="modal_required">*</span>
						</label>

						<input type="number"
							name="inoutQty"
							id="insertInoutQty"
							class="modal_input"
							min="1"
							required>

					</div>

					<div class="modal_item">

						<label class="modal_label">
							입출고일자
							<span class="modal_required">*</span>
						</label>

						<input type="date"
							name="inoutDate"
							id="insertInoutDate"
							class="modal_input modal_today"
							required>

					</div>

					<div class="modal_item">

						<label class="modal_label">
							비고
						</label>

						<input type="text"
							name="remark"
							class="modal_input">

					</div>

				</div>

				<div class="modal_footer">

					<button type="button"
						class="modal_btn modal_btn_cancel modal_close_btn">

						취소

					</button>

					<button type="submit"
						class="modal_btn modal_btn_submit">

						등록

					</button>

				</div>

			</form>

		</div>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>