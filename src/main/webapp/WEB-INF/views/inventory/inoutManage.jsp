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

</style>

<div class="coPageWrap">

	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/materialIn">

		<div class="search-box">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">시작일</label>
					<input type="date" name="startDate" class="search-date" value="${startDate}">
				</div>

				<div class="search-item">
					<label class="search-label">종료일</label>
					<input type="date" name="endDate" class="search-date" value="${endDate}">
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

			<table class="coTable">

				<thead>
					<tr>
						<th>
							<label id="checkAllLabel">선택</label>
							<input type="checkbox" id="checkAll" style="display:none;">
						</th>

						<th>입출고번호</th>
						<th>입출고구분</th>
						<th>품목명</th>
						<th>입출고량</th>
						<th>단위</th>
						<th>일자</th>
						<th>상세</th>
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

							<%-- =====================================================
								입출고번호 출력
								팀장님 요청 기준으로 숫자 INOUT_ID 대체 출력은 하지 않는다.
								DOC_NO는 등록 시 DB에 반드시 저장되어야 한다.
							===================================================== --%>
							<td>
								${inout.docNo}
							</td>

							<td>
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
									<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
									<c:otherwise>${inout.inoutType}</c:otherwise>
								</c:choose>
							</td>

							<td>
								${inout.itemName}
							</td>

							<td>
								${inout.inoutQty}
							</td>

							<td>
								${inout.itemUnit}
							</td>

							<td>
								${inout.inoutDate}
							</td>

							<td>
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

			<form class="modal_form"
				method="post"
				action="${pageContext.request.contextPath}/inventory/materialIn/insert"
				autocomplete="off"
				novalidate
				onsubmit="return checkInoutInsert();">

				<%-- =====================================================
					화면에서 제거한 DB 저장용 값
					사용여부 / 작업지시번호 / 문서번호 / 문서순번은 화면에는 보이지 않게 유지한다.
					Controller가 해당 값을 받더라도 등록이 깨지지 않도록 hidden 기본값만 전송한다.
				===================================================== --%>
				<input type="hidden" name="useYn" value="Y">
				<input type="hidden" name="orderId" value="0">
				<input type="hidden" name="docNo" value="">
				<input type="hidden" name="docSeq" value="0">

				<div class="modal_body modal_body_2col">

					<%-- =====================================================
						사원번호
						화면에서는 로그인 사용자 사원번호를 자동 표시한다.
						실제 저장은 Controller에서 session 로그인 정보 기준으로 한 번 더 처리한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							사원번호
							<span class="modal_required">*</span>
						</label>

						<input type="number"
							name="empId"
							id="insertEmpId"
							class="modal_input"
							value="${loginEmpId}"
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
						CLIENT.CLIENT_MAN 값을 자동 표시한다.
					===================================================== --%>
					<div class="modal_item">

						<label class="modal_label">
							담당자
						</label>

						<input type="text"
							id="insertClientManager"
							class="modal_input"
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

<script>

	// =========================================================
	// 등록 모달 필수값 방어코딩
	// 공통 JS는 건드리지 않고 현재 JSP 안에서만 검증한다.
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
				dateInput.value.replaceAll("-", "");

		} else {

			dateText =
				formatDateForInput(new Date()).replaceAll("-", "");
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
					insertClientManager.value = "";
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

					insertClientManager.value =
						data.clientManager || "";
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

					var remainQty =
						0;

					if (list[i].remainQty != null) {

						remainQty =
							list[i].remainQty;

					} else if (list[i].inoutQty != null) {

						remainQty =
							list[i].inoutQty;
					}

					option.text =
						(list[i].materialLot || "")
						+ " / 잔량 "
						+ remainQty;

					insertMaterialLotSelect.appendChild(option);
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
	});

</script>
