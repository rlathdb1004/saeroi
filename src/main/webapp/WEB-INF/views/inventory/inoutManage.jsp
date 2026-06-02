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

<style>

	.input_error_text {
		margin-top: 6px;
		font-size: 12px;
		color: #e53935;
		font-weight: 500;
		display: none;
	}

	.input_error {
		border: 1px solid #e53935 !important;
	}

	/* =====================================================
		자재입출고 목록 테이블 초기 폭 조정
		공통 CSS / 공통 JSP는 절대 수정하지 않고 이 JSP 안에서만 보정한다.
		목표:
		- 드래그 리사이즈 기능은 유지
		- 처음 페이지 진입 시 입출고번호가 넓게 보이도록 설정
		- 입출고구분 / 수량 / 단위 / 상세 컬럼은 줄여서 공간 확보
		- 가로 스크롤바 추가 없음
		- 긴 품목명이 셀 선을 넘어가지 않도록 현재 JSP에서만 표시를 보정한다.
		- 공통 CSS / 공통 JSP는 수정하지 않는다.
	===================================================== */
	.coTableWrap {
		width: 100%;
		overflow-x: hidden;
	}

	.coTable {
		width: 100%;
		table-layout: fixed;
	}

	.coTable th,
	.coTable td {
		font-size: 12px;
		white-space: nowrap;
		word-break: keep-all;
		vertical-align: middle;
		text-align: center;
		padding-left: 4px;
		padding-right: 4px;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	/* 선택: 체크박스만 들어가므로 가장 작게 둔다. */
	.coTable th:nth-child(1),
	.coTable td:nth-child(1) {
		width: 48px;
	}

	/* 입출고번호: 가장 길게 보이는 컬럼이라 넓힌다. */
	.coTable th:nth-child(2),
	.coTable td:nth-child(2) {
		width: 190px;
		font-size: 12px;
		letter-spacing: -0.4px;
	}

	/* 입출고구분: 입고 / 출고만 표시되므로 줄인다. */
	.coTable th:nth-child(3),
	.coTable td:nth-child(3) {
		width: 70px;
	}

	/* 품목명: 한 줄로 보이도록 기존보다 여유 있게 둔다. */
	.coTable th:nth-child(4),
	.coTable td:nth-child(4) {
		width: 220px;
		font-size: 12px;
		letter-spacing: -0.4px;
	}

	/* 입출고량 */
	.coTable th:nth-child(5),
	.coTable td:nth-child(5) {
		width: 80px;
	}

	/* 단위: EA / M / KG 정도만 표시되므로 줄인다. */
	.coTable th:nth-child(6),
	.coTable td:nth-child(6) {
		width: 55px;
	}

	/* 일자 */
	.coTable th:nth-child(7),
	.coTable td:nth-child(7) {
		width: 110px;
	}

	/* 상세 */
	.coTable th:nth-child(8),
	.coTable td:nth-child(8) {
		width: 55px;
	}


	/* =====================================================
		모바일 테이블 컬럼 보정
		팀 공통 규칙에 맞게 mobile_show / mobile_hidden 만 사용한다.
		공통 CSS 파일은 수정하지 않고, 이 JSP 안에서만 모바일 표시를 보정한다.
		모바일 노출 컬럼:
		선택 / 입출고구분 / 품목명 / 일자 / 상세
		상세 컬럼은 반드시 mobile_show로 유지한다.
	===================================================== */
	@media screen and (max-width: 768px) {

		.coTable col.mobile_hidden,
		.coTable th.mobile_hidden,
		.coTable td.mobile_hidden {
			display: none !important;
		}

		.coTable th.mobile_show,
		.coTable td.mobile_show {
			display: table-cell !important;
		}

		.coTable {
			width: 100%;
			table-layout: fixed;
		}

		.coTable th,
		.coTable td {
			font-size: 11px;
			padding: 10px 4px;
			letter-spacing: -0.5px;
		}

		.coTable th:nth-child(1),
		.coTable td:nth-child(1) {
			width: 48px;
		}

		.coTable th:nth-child(3),
		.coTable td:nth-child(3) {
			width: 70px;
		}

		.coTable th:nth-child(4),
		.coTable td:nth-child(4) {
			width: auto;
		}

		.coTable th:nth-child(7),
		.coTable td:nth-child(7) {
			width: 92px;
		}

		.coTable th:nth-child(8),
		.coTable td:nth-child(8) {
			width: 58px;
		}

		.coDetailBtn {
			min-width: 38px;
			padding: 6px 8px;
			font-size: 11px;
		}
	}

</style>

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label>
					<input type="date" name="startDate" id="inoutStartDate" class="search-date" value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label>
					<input type="date" name="endDate" id="inoutEndDate" class="search-date" min="${startDate}" value="${endDate}">
				</div>

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="inoutType" class="search-select">
						<option value="">전체</option>
						<option value="MI" <c:if test="${inoutType eq 'MI'}">selected</c:if>>입고</option>
						<option value="MO-PROD" <c:if test="${inoutType eq 'MO-PROD'}">selected</c:if>>출고</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>
					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">
				</div>

				<div class="search-btn-wrap">

					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5"
								stroke="currentColor" stroke-width="2"></circle>
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

	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/materialIn/delete">

		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<c:if test="${isAdmin}">

				<div class="search-btn-right">

					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">

						<svg viewBox="0 0 24 24" fill="none">
							<path d="M12 5V19"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M5 12H19"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>
						</svg>

						등록
					</button>

					<button type="button"
						class="search-btn search-btn-sub"
						onclick="deleteCheck()">

						<svg viewBox="0 0 24 24" fill="none">
							<path d="M4 7H20"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M10 11V17"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M14 11V17"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M6 7L7 21H17L18 7"
								stroke="currentColor"
								stroke-width="2"
								stroke-linejoin="round"></path>
							<path d="M9 7V4H15V7"
								stroke="currentColor"
								stroke-width="2"
								stroke-linejoin="round"></path>
						</svg>

						선택 삭제
					</button>

				</div>

			</c:if>

		</div>

		<div class="coTableWrap">

			<%-- =====================================================
				자재입출고관리 목록 모바일 컬럼 규칙 최종 반영
				mobile_show   : 모바일에서도 보여줄 컬럼
				mobile_hidden : 모바일에서 숨길 컬럼
				모바일 노출 컬럼은 선택 / 입출고구분 / 품목명 / 일자 / 상세 총 5개이다.
				상세 컬럼은 팀 공통 규칙상 반드시 mobile_show로 유지한다.
				공통 JSP / 공통 CSS는 수정하지 않는다.
			===================================================== --%>
			<table class="coTable">

				<%-- =====================================================
					초기 컬럼 폭 지정
					공통 테이블 리사이즈 기능은 유지하고, 처음 진입 시 기본 폭만 맞춘다.
				===================================================== --%>
				<colgroup>
					<%-- 모바일 표시: 선택 --%>
					<col class="mobile_show" style="width:48px;">

					<%-- 모바일 숨김: 입출고번호 --%>
					<col class="mobile_hidden" style="width:190px;">

					<%-- 모바일 표시: 입출고구분 --%>
					<col class="mobile_show" style="width:80px;">

					<%-- 모바일 표시: 품목명 --%>
					<col class="mobile_show" style="width:200px;">

					<%-- 모바일 숨김: 입출고량 --%>
					<col class="mobile_hidden" style="width:80px;">

					<%-- 모바일 숨김: 단위 --%>
					<col class="mobile_hidden" style="width:55px;">

					<%-- 모바일 표시: 일자 --%>
					<col class="mobile_show" style="width:110px;">

					<%-- 모바일 표시: 상세 --%>
					<col class="mobile_show" style="width:55px;">
				</colgroup>

				<thead>
					<tr>
						<th class="mobile_show">
							<label id="checkAllLabel">선택</label>
							<input type="checkbox" id="checkAll" style="display:none;">
						</th>

						<th class="mobile_hidden">입출고번호</th>
						<th class="mobile_show">입출고구분</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_hidden">입출고량</th>
						<th class="mobile_hidden">단위</th>
						<th class="mobile_show">일자</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="inout"
						items="${list}"
						varStatus="status">

						<tr>

							<td class="mobile_show">
								<input type="checkbox"
									name="inoutIds"
									value="${inout.inoutId}">
							</td>

							<%-- =====================================================
								입출고번호 출력
								공통 JSP / 공통 CSS는 건드리지 않고 현재 JSP에서만 출력값을 변경한다.

								기존에는 ${inout.docNo}만 출력해서,
								DB의 기존 데이터 중 DOC_NO가 비어 있는 행은 입출고번호 칸이 빈칸으로 보였다.

								InoutDTO.getDisplayDocNo()에서
								1) DOC_NO가 있으면 DOC_NO 출력
								2) DOC_NO가 비어 있으면 입출고구분 + 일자 + INOUT_ID로 표시용 번호 생성
								하도록 처리했기 때문에 여기서는 displayDocNo만 출력한다.
							===================================================== --%>
							<td class="mobile_hidden" title="${inout.displayDocNo}">
								${inout.displayDocNo}
							</td>

							<td class="mobile_show">
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
									<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
									<c:otherwise>${inout.inoutType}</c:otherwise>
								</c:choose>
							</td>

							<td class="mobile_show" title="${inout.itemName}">
								${inout.itemName}
							</td>

							<td class="mobile_hidden">
								${inout.inoutQty}
							</td>

							<td class="mobile_hidden">
								${inout.itemUnit}
							</td>

							<td class="mobile_show">
								${inout.inoutDate}
							</td>

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
		공통 영역은 건드리지 않고 등록 모달 내부만 팀장님 요구사항 기준으로 수정
		- 사원번호는 로그인 사용자 정보로 자동 표시
		- 담당자 / 거래처명 / 현재재고는 품목 선택 시 자동 표시
		- 창고위치는 품목 선택 시 select 박스로 자동 표시
		- LOT번호는 입고 선택 시 자동 생성, 출고 선택 시 기존 LOT select 박스 표시
		- 작업지시번호 / 문서번호 / 문서순번 입력칸 제거
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

			<form id="inoutInsertForm"
				class="modal_form"
				method="post"
				action="${pageContext.request.contextPath}/inventory/materialIn/insert"
				autocomplete="off"
				novalidate
				onsubmit="return checkInoutInsert();">

				<%-- =====================================================
					사용여부
					화면에는 표시하지 않지만 DB 저장 시 기본값 Y가 필요해서 hidden으로 보낸다.
				===================================================== --%>
				<input type="hidden"
					name="useYn"
					value="Y">

				<div class="modal_body modal_body_2col">

					<%-- =====================================================
						사원번호
						화면에는 DB 저장용 EMP_ID 숫자값이 아니라
						EMP 테이블의 사번 EMPNO를 보여준다.

						예)
						화면 표시 : E2026004
						DB 저장   : EMP_ID = 4

						주의:
						이 input에는 name을 넣지 않는다.
						실제 저장은 Controller에서 session 로그인 정보로
						getLoginEmpId(session)을 호출해서 처리한다.
						그래서 화면에는 E2026004가 보여도
						MATERIAL_INOUT.EMP_ID에는 4가 저장된다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							사원번호
							<span class="modal_required">*</span>
						</label>

						<input type="text"
							id="insertEmpNo"
							class="modal_input"
							value="${loginEmpNo}"
							readonly>

					</div>

					<%-- =====================================================
						입출고구분
						입고 선택 시 LOT번호 자동 생성
						출고 선택 시 LOT번호 select 박스 목록 조회
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							입출고구분
							<span class="modal_required">*</span>
						</label>

						<select name="inoutType"
							id="insertInoutType"
							class="modal_select">

							<option value="">선택</option>
							<option value="MI">입고</option>
							<option value="MO-PROD">출고</option>

						</select>

						<div id="inoutTypeError"
							class="input_error_text">
							입출고구분을 선택해주세요.
						</div>

					</div>

					<%-- =====================================================
						품목명
						품목 선택 시 AJAX로 거래처명 / 담당자 / 현재재고 / 창고위치 / LOT 목록을 가져온다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							품목명
							<span class="modal_required">*</span>
						</label>

						<select name="itemId"
							id="insertItemId"
							class="modal_select">

							<option value="">선택</option>

							<c:forEach var="item"
								items="${itemList}">

								<option value="${item.itemId}">
									${item.itemName}
								</option>

							</c:forEach>

						</select>

						<div id="itemError"
							class="input_error_text">
							품목명을 선택해주세요.
						</div>

					</div>

					<%-- =====================================================
						거래처명
						품목 + 입출고구분 기준으로 자동 표시한다.
						입고는 공급처, 출고는 납품처 기준으로 DAO에서 조회한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							거래처명
						</label>

						<input type="text"
							id="insertClientName"
							class="modal_input"
							readonly>

					</div>

					<%-- =====================================================
						담당자
						현재 로그인한 사람 이름을 자동 표시한다. DB 저장은 Controller에서 로그인 세션 EMP_ID로 처리한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							담당자
						</label>

						<input type="text"
							id="insertClientManager"
							class="modal_input"
							value="${loginEmpName}"
							readonly>

					</div>

					<%-- =====================================================
						창고위치
						품목 선택 시 INVENTORY 기준 창고위치를 select 박스로 출력한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							창고위치
						</label>

						<select name="stockLocation"
							id="insertStockLocation"
							class="modal_select">

							<option value="">창고위치 선택</option>

						</select>

					</div>

					<%-- =====================================================
						현재재고
						품목 선택 시 전체 현재재고를 표시하고,
						창고위치 선택 시 해당 창고의 현재재고로 표시한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							현재재고
						</label>

						<input type="text"
							id="insertInventoryStock"
							class="modal_input"
							readonly>

					</div>

					<%-- =====================================================
						LOT번호
						실제 저장용 hidden input은 항상 materialLot 이름을 가진다.
						입고: 자동 생성된 LOT번호를 input으로 보여준다.
						출고: 기존 LOT 목록을 select 박스로 보여주고 선택값을 hidden에 복사한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							LOT번호
							<span class="modal_required">*</span>
						</label>

						<input type="hidden"
							name="materialLot"
							id="insertMaterialLot">

						<input type="text"
							id="insertMaterialLotInput"
							class="modal_input"
							readonly>

						<select id="insertMaterialLotSelect"
							class="modal_select"
							style="display:none;">

							<option value="">LOT번호 선택</option>

						</select>

					</div>

					<%-- =====================================================
						입출고수량
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							입출고수량
							<span class="modal_required">*</span>
						</label>

						<input type="number"
							name="inoutQty"
							id="insertInoutQty"
							class="modal_input"
							min="1">

						<div id="qtyError"
							class="input_error_text">
							입출고수량은 1 이상 입력해주세요.
						</div>

					</div>

					<%-- =====================================================
						입출고일자
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							입출고일자
							<span class="modal_required">*</span>
						</label>

						<input type="date"
							name="inoutDate"
							id="insertInoutDate"
							class="modal_input modal_today">

						<div id="dateError"
							class="input_error_text">
							입출고일자를 선택해주세요.
						</div>

					</div>

					<%-- =====================================================
						상태
						텍스트 입력이 아니라 select 박스로 선택한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							상태
						</label>

						<select name="status"
							class="modal_select">

							<option value="완료">완료</option>
							<option value="진행">진행</option>
							<option value="보류">보류</option>

						</select>

					</div>

					<%-- =====================================================
						비고
					===================================================== --%>
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

					<%-- =================================================
						등록 버튼
						type="submit"으로 직접 submit 되게 한다.
						공통 모달 / 공통 JS는 건드리지 않고
						현재 form의 onsubmit="return checkInoutInsert();" 검증을 통과하면
						Controller(/inventory/materialIn/insert)로 정상 전송된다.
					================================================= --%>
					<button type="button"
						class="modal_btn modal_btn_submit"
						onclick="submitInoutInsertDirect();">

						등록

					</button>

				</div>

			</form>

		</div>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script>

	// =========================================================
	// 등록 모달 필수값 방어코딩
	// 공통 JS는 건드리지 않고 현재 JSP 안에서만 검증한다.
	// 입고(MI)일 때 LOT번호가 비어 있으면 등록 직전에 한 번 더 자동 생성한다.
	// 출고(MO-PROD)일 때는 select 박스에서 고른 LOT번호를 hidden 값에 복사한다.
	// =========================================================
	function checkInoutInsert() {

		var inoutType =
			document.getElementById("insertInoutType");

		var itemId =
			document.getElementById("insertItemId");

		var inoutQty =
			document.getElementById("insertInoutQty");

		var inoutDate =
			document.getElementById("insertInoutDate");

		var materialLot =
			document.getElementById("insertMaterialLot");

		var materialLotInput =
			document.getElementById("insertMaterialLotInput");

		var materialLotSelect =
			document.getElementById("insertMaterialLotSelect");

		var inoutTypeError =
			document.getElementById("inoutTypeError");

		var itemError =
			document.getElementById("itemError");

		var qtyError =
			document.getElementById("qtyError");

		var dateError =
			document.getElementById("dateError");

		inoutType.classList.remove("input_error");
		itemId.classList.remove("input_error");
		inoutQty.classList.remove("input_error");
		inoutDate.classList.remove("input_error");

		inoutTypeError.style.display = "none";
		itemError.style.display = "none";
		qtyError.style.display = "none";
		dateError.style.display = "none";

		var isValid = true;

		if (inoutType.value == "") {

			inoutType.classList.add("input_error");
			inoutTypeError.style.display = "block";
			isValid = false;
		}

		if (itemId.value == "") {

			itemId.classList.add("input_error");
			itemError.style.display = "block";
			isValid = false;
		}

		if (inoutQty.value == ""
			|| Number(inoutQty.value) <= 0) {

			inoutQty.classList.add("input_error");
			qtyError.style.display = "block";
			isValid = false;
		}

		if (inoutDate.value == "") {

			inoutDate.classList.add("input_error");
			dateError.style.display = "block";
			isValid = false;
		}

		// =====================================================
		// LOT번호 최종 방어코딩
		// 이벤트가 꼬여도 입고는 등록 직전에 자동 생성되게 한다.
		// =====================================================
		if (materialLot != null
			&& inoutType.value == "MI"
			&& materialLot.value == "") {

			var lotNo =
				createInsertMaterialLot();

			materialLot.value =
				lotNo;

			if (materialLotInput != null) {

				materialLotInput.value =
					lotNo;

				materialLotInput.style.display =
					"";
			}

			if (materialLotSelect != null) {

				materialLotSelect.style.display =
					"none";
			}
		}

		// =====================================================
		// 출고는 select 박스 선택값을 hidden materialLot에 복사한다.
		// =====================================================
		if (materialLot != null
			&& inoutType.value == "MO-PROD") {

			if (materialLotSelect != null) {

				materialLot.value =
					materialLotSelect.value;
			}
		}

		if (materialLot != null
			&& materialLot.value == "") {

			alert("LOT번호를 확인해주세요.");
			isValid = false;
		}

		return isValid;
	}

	// =========================================================
	// 선택 삭제
	// =========================================================
	function deleteCheck() {

		var checkedList =
			document.querySelectorAll("input[name='inoutIds']:checked");

		if (checkedList.length == 0) {

			alert("삭제할 항목을 선택해주세요.");

			return;
		}

		if (confirm("선택한 항목을 삭제하시겠습니까?")) {

			document.getElementById("deleteForm").submit();
		}
	}

	// =========================================================
	// 날짜를 yyyy-MM-dd 형식으로 만든다.
	// =========================================================
	function formatDateForInput(date) {

		var year =
			date.getFullYear();

		var month =
			String(date.getMonth() + 1).padStart(2, "0");

		var day =
			String(date.getDate()).padStart(2, "0");

		return year + "-" + month + "-" + day;
	}

	// =========================================================
	// 입고 LOT번호 자동 생성
	// DB 저장 전 서버에서도 한 번 더 방어 생성하지만 화면에도 즉시 표시한다.
	// =========================================================
	function createInsertMaterialLot() {

		var dateInput =
			document.getElementById("insertInoutDate");

		var dateText =
			"";

		if (dateInput != null
			&& dateInput.value != "") {

			dateText =
				dateInput.value.split("-").join("");

		} else {

			dateText =
				formatDateForInput(new Date()).split("-").join("");
		}

		var randomNo =
			String(new Date().getTime()).slice(-4);

		return "RMLOT-" + dateText + "-" + randomNo;
	}

	// =========================================================
	// JSON 요청 공통 함수
	// =========================================================
	function fetchJson(url, callback) {

		fetch(url)
			.then(function(response) {

				return response.json();
			})
			.then(function(data) {

				callback(data);
			})
			.catch(function(error) {

				console.error(error);
			});
	}

	window.addEventListener("load", function() {

		var dateInput =
			document.getElementById("insertInoutDate");

		if (dateInput != null
			&& dateInput.value == "") {

			dateInput.value =
				formatDateForInput(new Date());
		}

		var checkAllLabel =
			document.getElementById("checkAllLabel");

		if (checkAllLabel != null) {

			checkAllLabel.addEventListener("click", function() {

				var checks =
					document.querySelectorAll("input[name='inoutIds']");

				var allChecked = true;

				for (var i = 0; i < checks.length; i++) {

					if (!checks[i].checked) {

						allChecked = false;
					}
				}

				for (var i = 0; i < checks.length; i++) {

					checks[i].checked =
						!allChecked;
				}
			});
		}

		var insertInoutType =
			document.getElementById("insertInoutType");

		var insertItemId =
			document.getElementById("insertItemId");

		var insertClientName =
			document.getElementById("insertClientName");

		var insertClientManager =
			document.getElementById("insertClientManager");

		var insertStockLocation =
			document.getElementById("insertStockLocation");

		var insertInventoryStock =
			document.getElementById("insertInventoryStock");

		var insertMaterialLot =
			document.getElementById("insertMaterialLot");

		var insertMaterialLotInput =
			document.getElementById("insertMaterialLotInput");

		var insertMaterialLotSelect =
			document.getElementById("insertMaterialLotSelect");

		// =====================================================
		// 품목 / 구분 변경 시 거래처명, 담당자, 현재재고 자동 표시
		// =====================================================
		function loadItemInfo() {

			if (insertItemId == null
				|| insertItemId.value == "") {

				if (insertClientName != null) {
					insertClientName.value = "";
				}

				if (insertClientManager != null) {
					// =====================================================
					// 품목을 선택하지 않아도 담당자는 로그인 사용자 이름으로 유지한다.
					// =====================================================
					insertClientManager.value = "${loginEmpName}";
				}

				if (insertInventoryStock != null) {
					insertInventoryStock.value = "";
				}

				return;
			}

			var inoutTypeValue =
				"";

			if (insertInoutType != null) {

				inoutTypeValue =
					insertInoutType.value;
			}

			var url =
				"${pageContext.request.contextPath}/inventory/materialIn/itemInfo"
				+ "?itemId=" + encodeURIComponent(insertItemId.value)
				+ "&inoutType=" + encodeURIComponent(inoutTypeValue);

			fetchJson(url, function(data) {

				if (insertClientName != null) {

					insertClientName.value =
						data.clientName || "";
				}

				if (insertClientManager != null) {

					// =====================================================
					// 팀 피드백 반영
					// 품목을 바꿔도 담당자는 거래처 담당자가 아니라
					// 현재 로그인한 사람 이름만 표시한다.
					// =====================================================
					insertClientManager.value =
						"${loginEmpName}";
				}

				if (insertInventoryStock != null) {

					insertInventoryStock.value =
						data.inventoryStock == null ? "" : data.inventoryStock;
				}
			});
		}

		// =====================================================
		// 품목 선택 시 창고위치 select 박스 자동 구성
		// =====================================================
		function loadStockLocations() {

			if (insertStockLocation == null) {

				return;
			}

			insertStockLocation.innerHTML =
				"<option value=''>창고위치 선택</option>";

			if (insertItemId == null
				|| insertItemId.value == "") {

				return;
			}

			var url =
				"${pageContext.request.contextPath}/inventory/materialIn/stockLocations"
				+ "?itemId=" + encodeURIComponent(insertItemId.value);

			fetchJson(url, function(list) {

				for (var i = 0; i < list.length; i++) {

					var option =
						document.createElement("option");

					option.value =
						list[i].stockLocation || "";

					option.text =
						list[i].stockLocation || "";

					option.setAttribute(
						"data-inventory-stock",
						list[i].inventoryStock == null ? "" : list[i].inventoryStock);

					insertStockLocation.appendChild(option);
				}

				if (list.length == 1) {

					insertStockLocation.selectedIndex = 1;
					setStockLocationInventory();
				}
			});
		}

		// =====================================================
		// 창고위치 선택 시 해당 창고 현재재고 표시
		// =====================================================
		function setStockLocationInventory() {

			if (insertStockLocation == null
				|| insertInventoryStock == null) {

				return;
			}

			var option =
				insertStockLocation.options[insertStockLocation.selectedIndex];

			if (option == null) {

				return;
			}

			var stock =
				option.getAttribute("data-inventory-stock");

			if (stock != null
				&& stock != "") {

				insertInventoryStock.value =
					stock;
			}
		}

		// =====================================================
		// 입출고구분에 따라 LOT번호 입력 방식을 바꾼다.
		// 입고: 자동 생성 input
		// 출고: 기존 LOT 목록 select
		// =====================================================
		function refreshMaterialLotArea() {

			if (insertMaterialLot == null
				|| insertMaterialLotInput == null
				|| insertMaterialLotSelect == null) {

				return;
			}

			var inoutTypeValue =
				insertInoutType == null ? "" : insertInoutType.value;

			if (inoutTypeValue == "MI") {

				var lotNo =
					createInsertMaterialLot();

				insertMaterialLot.value =
					lotNo;

				insertMaterialLotInput.value =
					lotNo;

				insertMaterialLotInput.style.display =
					"";

				insertMaterialLotSelect.style.display =
					"none";

				return;
			}

			if (inoutTypeValue == "MO-PROD") {

				insertMaterialLot.value =
					"";

				insertMaterialLotInput.value =
					"";

				insertMaterialLotInput.style.display =
					"none";

				insertMaterialLotSelect.style.display =
					"";

				loadMaterialLotList();

				return;
			}

			insertMaterialLot.value =
				"";

			insertMaterialLotInput.value =
				"";

			insertMaterialLotInput.style.display =
				"";

			insertMaterialLotSelect.style.display =
				"none";
		}

		// =====================================================
		// 출고용 LOT 목록 조회
		// =====================================================
		function loadMaterialLotList() {

			if (insertMaterialLotSelect == null) {

				return;
			}

			insertMaterialLotSelect.innerHTML =
				"<option value=''>LOT번호 선택</option>";

			if (insertItemId == null
				|| insertItemId.value == "") {

				return;
			}

			var url =
				"${pageContext.request.contextPath}/inventory/materialIn/lotList"
				+ "?itemId=" + encodeURIComponent(insertItemId.value);

			fetchJson(url, function(list) {

				for (var i = 0; i < list.length; i++) {

					var option =
						document.createElement("option");

					option.value =
						list[i].materialLot || "";

					option.text =
						(list[i].materialLot || "")
						+ " / 잔량 "
						+ (list[i].remainQty == null ? 0 : list[i].remainQty);

					insertMaterialLotSelect.appendChild(option);
				}

				// =================================================
				// 출고 가능한 LOT가 1개뿐이면 자동 선택해서 hidden 값까지 넣어준다.
				// =================================================
				if (list.length == 1) {

					insertMaterialLotSelect.selectedIndex = 1;

					if (insertMaterialLot != null) {

						insertMaterialLot.value =
							insertMaterialLotSelect.value;
					}
				}
			});
		}

		if (insertInoutType != null) {

			insertInoutType.addEventListener("change", function() {

				loadItemInfo();
				refreshMaterialLotArea();
			});
		}

		if (insertItemId != null) {

			insertItemId.addEventListener("change", function() {

				loadItemInfo();
				loadStockLocations();
				refreshMaterialLotArea();
			});
		}

		if (insertStockLocation != null) {

			insertStockLocation.addEventListener("change", setStockLocationInventory);
		}

		if (insertMaterialLotSelect != null) {

			insertMaterialLotSelect.addEventListener("change", function() {

				if (insertMaterialLot != null) {

					insertMaterialLot.value =
						insertMaterialLotSelect.value;
				}
			});
		}

		if (dateInput != null) {

			dateInput.addEventListener("change", function() {

				if (insertInoutType != null
					&& insertInoutType.value == "MI") {

					refreshMaterialLotArea();
				}
			});
		}


		// =====================================================
		// 모달을 다시 열 때도 현재 선택값 기준으로 LOT 영역을 다시 맞춘다.
		// 공통 모달 스크립트는 건드리지 않고 이 JSP 안에서만 보완한다.
		// =====================================================
		var modalOpenBtns =
			document.querySelectorAll(".modal_open_btn[data_modal_target='#modal_insert']");

		for (var i = 0; i < modalOpenBtns.length; i++) {

			modalOpenBtns[i].addEventListener("click", function() {

				setTimeout(function() {

					loadItemInfo();
					loadStockLocations();
					refreshMaterialLotArea();

				}, 0);
			});
		}
	});


	// =========================================================
	// 입출고 등록 버튼 직접 제출
	// 공통 모달 스크립트는 건드리지 않고, 현재 JSP에서만 등록 버튼 submit을 보장한다.
	// 기존 checkInoutInsert() 검증을 통과한 경우에만 실제 form submit을 실행한다.
	// =========================================================
	function submitInoutInsertForm() {

		var form =
			document.getElementById("inoutInsertForm");

		if (form == null) {
			alert("입출고 등록 폼을 찾을 수 없습니다.");
			return;
		}

		if (checkInoutInsert()) {
			form.submit();
		}
	}

</script>

<script>
// =============================================================
// 자재입출고 검색 날짜 제어
// 공통 파일은 수정하지 않고 현재 JSP 안에서만 종료일 min 값을 맞춘다.
// 종료일은 시작일보다 이전 날짜를 선택하지 못하게 한다.
// =============================================================
(function() {

	var startDate = document.getElementById("inoutStartDate");
	var endDate = document.getElementById("inoutEndDate");

	if (startDate == null || endDate == null) {
		return;
	}

	function syncEndDateMin() {

		if (startDate.value != "") {
			endDate.min = startDate.value;

			if (endDate.value != "" && endDate.value < startDate.value) {
				endDate.value = startDate.value;
			}
		}
	}

	syncEndDateMin();
	startDate.addEventListener("change", syncEndDateMin);

})();
</script>


<script>
/* =============================================================
	자재입출고 등록 submit 복구
	공통 JS / 공통 JSP는 건드리지 않고 현재 JSP 안에서만 처리한다.

	등록 모달은 정상으로 뜨는데 저장이 안 되는 경우는
	공통 모달 스크립트가 .modal_btn_submit 클릭을 잡아먹거나,
	type="submit" 이벤트가 꼬이는 경우가 있다.

	그래서 등록 버튼 클릭 시
	1) 기존 checkInoutInsert() 검증을 먼저 실행하고
	2) 통과하면 현재 form을 직접 submit 한다.
============================================================= */
function submitInoutInsertDirect() {

	var form =
		document.getElementById("inoutInsertForm");

	if (form == null) {
		alert("입출고 등록 form을 찾을 수 없습니다.");
		return;
	}

	if (typeof checkInoutInsert == "function") {

		if (!checkInoutInsert()) {
			return;
		}
	}

	// =========================================================
	// HTMLFormElement 기본 submit을 직접 호출한다.
	// 공통 JS에서 버튼 click 이벤트를 막아도 Controller로 전송되게 한다.
	// =========================================================
	HTMLFormElement.prototype.submit.call(form);
}
</script>
