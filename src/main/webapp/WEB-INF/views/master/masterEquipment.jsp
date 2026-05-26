<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
    파일명: masterEquipment.jsp
    메뉴: 기준정보관리 > 설비관리

    기준:
    - 사이드바 설비관리 업무 메뉴와 충돌 방지를 위해 masterEquipment 명칭 사용
    - 품목관리 item.jsp 구조 중심 적용
    - 설비구분은 고정값이 아니라 equip_code prefix 기준으로 관리
    - 기존 설비구분 선택 가능
    - 신규 설비구분 직접입력 가능
    - 설비코드는 prefix 기준 자동생성
    - 제조사는 자동완성 input으로 검색 후 hidden clientId에 저장
    - 공용 content.css / searchtable.css / modal.css / mobile.css 기준 사용
    - 선택 컬럼명 클릭 시 현재 목록 체크박스 전체선택/해제
    - 선택삭제는 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리

    화면 컬럼 기준:
    - PC 목록 테이블: 체크박스 포함 8개
    - 모바일 목록 테이블: 체크박스 포함 5개
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
         1. 검색 영역
         ========================================================= --%>
	<div class="search-box">
		<form class="search-form" method="get"
			action="${contextPath}/master/equipment">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="searchType" class="search-select">
						<option value="">선택</option>

						<option value="equipCodePrefix"
							<c:if test="${masterEquipmentDTO.searchType == 'equipCodePrefix'}">selected</c:if>>
							설비구분
						</option>

						<option value="equipCode"
							<c:if test="${masterEquipmentDTO.searchType == 'equipCode'}">selected</c:if>>
							설비코드
						</option>

						<option value="equipName"
							<c:if test="${masterEquipmentDTO.searchType == 'equipName'}">selected</c:if>>
							설비명
						</option>

						<option value="lineName"
							<c:if test="${masterEquipmentDTO.searchType == 'lineName'}">selected</c:if>>
							라인
						</option>

						<option value="clientName"
							<c:if test="${masterEquipmentDTO.searchType == 'clientName'}">selected</c:if>>
							제조사
						</option>

						<option value="equipStatus"
							<c:if test="${masterEquipmentDTO.searchType == 'equipStatus'}">selected</c:if>>
							설비상태
						</option>

						<option value="useYn"
							<c:if test="${masterEquipmentDTO.searchType == 'useYn'}">selected</c:if>>
							사용여부
						</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text" name="searchKeyword" class="search-input"
						value="${masterEquipmentDTO.searchKeyword}"
						placeholder="내용을 입력하세요." />
				</div>

				<div class="search-item">
					<label class="search-label">보기</label>

					<select name="size" class="search-select">
						<option value="5"
							<c:if test="${pageInfo.size == 5}">selected</c:if>>
							5개씩
						</option>
						<option value="10"
							<c:if test="${pageInfo.size == 10}">selected</c:if>>
							10개씩
						</option>
						<option value="20"
							<c:if test="${pageInfo.size == 20}">selected</c:if>>
							20개씩
						</option>
						<option value="30"
							<c:if test="${pageInfo.size == 30}">selected</c:if>>
							30개씩
						</option>
					</select>
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5"
								stroke="currentColor" stroke-width="2"></circle>
							<path d="M16 16L21 21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"></path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/master/equipment'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
							<path d="M18 4V7H21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round"></path>
						</svg>
						초기화
					</button>
				</div>

			</div>
		</form>
	</div>


	<%-- =========================================================
         2. 처리 메시지
         ========================================================= --%>
	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<%-- =========================================================
         3. 총 건수 / 등록 / 선택삭제 영역
         ========================================================= --%>
	<div class="search-table-top">

		<div class="search-total-area">
			총 <strong>${masterEquipmentCount}</strong>건
		</div>

		<div class="search-btn-right">

			<button type="button"
				class="search-btn search-btn-main modal_open_btn"
				data_modal_target="#masterEquipmentModal">
				<svg viewBox="0 0 24 24" fill="none">
					<path d="M12 5V19" stroke="currentColor"
						stroke-width="2" stroke-linecap="round"></path>
					<path d="M5 12H19" stroke="currentColor"
						stroke-width="2" stroke-linecap="round"></path>
				</svg>
				등록
			</button>

			<button type="button"
				class="search-btn search-btn-sub pc-only-delete-btn"
				onclick="submitMasterEquipmentDeleteForm();">
				<svg viewBox="0 0 24 24" fill="none">
					<path d="M4 7H20" stroke="currentColor"
						stroke-width="2" stroke-linecap="round"></path>
					<path d="M10 11V17" stroke="currentColor"
						stroke-width="2" stroke-linecap="round"></path>
					<path d="M14 11V17" stroke="currentColor"
						stroke-width="2" stroke-linecap="round"></path>
					<path d="M6 7L7 21H17L18 7" stroke="currentColor"
						stroke-width="2" stroke-linejoin="round"></path>
					<path d="M9 7V4H15V7" stroke="currentColor"
						stroke-width="2" stroke-linejoin="round"></path>
				</svg>
				선택 삭제
			</button>

		</div>
	</div>


	<%-- =========================================================
         4. 설비 목록 테이블

         PC 컬럼 8개:
         1 선택
         2 설비구분
         3 설비코드
         4 설비명
         5 라인
         6 제조사
         7 상태
         8 상세

         모바일 컬럼 5개:
         1 선택
         2 설비코드
         3 설비명
         4 상태
         5 상세
         ========================================================= --%>
	<form id="masterEquipmentDeleteForm" method="post"
		action="${contextPath}/master/equipment/delete">

		<div class="coTableWrap">
			<table class="coTable master-equipment-table"
				id="masterEquipmentListTable">

				<thead>
					<tr>
						<th class="mobile_show" onclick="toggleAllMasterEquipmentCheck();"
							title="전체 선택/해제">선택</th>

						<th class="mobile_hidden">설비구분</th>

						<th class="mobile_show">설비코드</th>

						<th class="mobile_show">설비명</th>

						<th class="mobile_hidden">라인</th>

						<th class="mobile_hidden">제조사</th>

						<th class="mobile_show">상태</th>

						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty masterEquipmentList}">
							<c:forEach var="masterEquipment"
								items="${masterEquipmentList}">

								<tr>
									<td class="mobile_show">
										<input type="checkbox" name="equipIdList"
											value="${masterEquipment.equipId}">
									</td>

									<td class="mobile_hidden"
										title="${masterEquipment.equipCodePrefix}">
										<c:choose>
											<c:when test="${not empty masterEquipment.equipCodePrefix}">
												${masterEquipment.equipCodePrefix}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show"
										title="${masterEquipment.equipCode}">
										${masterEquipment.equipCode}
									</td>

									<td class="mobile_show"
										title="${masterEquipment.equipName}">
										${masterEquipment.equipName}
									</td>

									<td class="mobile_hidden"
										title="${masterEquipment.lineName}">
										<c:choose>
											<c:when test="${not empty masterEquipment.lineName}">
												${masterEquipment.lineName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden"
										title="${masterEquipment.clientName}">
										<c:choose>
											<c:when test="${not empty masterEquipment.clientName}">
												${masterEquipment.clientName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show">
										<c:choose>
											<c:when test="${masterEquipment.equipStatus == '가동'}">
												<span class="coStatus coStatusUse">가동</span>
											</c:when>
											<c:otherwise>
												<span class="coStatus coStatusStop">
													${masterEquipment.equipStatus}
												</span>
											</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show">
										<a href="${contextPath}/master/equipment/detail?equipId=${masterEquipment.equipId}"
											class="coDetailBtn">보기</a>
									</td>
								</tr>

							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">
									조회된 설비 정보가 없습니다.
								</td>
							</tr>
						</c:otherwise>

					</c:choose>
				</tbody>

			</table>
		</div>
	</form>


	<%-- =========================================================
         5. 페이징 영역
         ========================================================= --%>
	<c:if test="${not empty pageInfo}">
		<c:set var="pageUrl" value="/master/equipment" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. 설비 등록 모달
     ============================================================= --%>
<div id="masterEquipmentModal" class="modal_wrap" aria-hidden="true">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">설비 등록</h3>
		</div>

		<form id="masterEquipmentAddForm" class="modal_form" method="post"
			action="${contextPath}/master/equipment/add"
			onsubmit="return validateMasterEquipmentAddForm();">

			<input type="hidden" name="equipCodePrefix" id="equipCodePrefix" />

			<div class="modal_body modal_body_2col">

				<div class="modal_item">
					<label class="modal_label">
						기존 설비구분
					</label>

					<select id="existingEquipCodePrefix" class="modal_select"
						onchange="selectExistingEquipCodePrefix();">
						<option value="">기존 구분 선택</option>

						<c:forEach var="equipCodePrefix" items="${equipCodePrefixList}">
							<option value="${equipCodePrefix}">
								${equipCodePrefix}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						신규 설비구분
					</label>

					<input type="text" id="newEquipCodePrefix"
						class="modal_input" maxlength="46"
						placeholder="예: DRY 또는 EQ-DRY"
						oninput="inputNewEquipCodePrefix();" />
				</div>

				<div class="modal_item modal_item_full">
					<div class="modal_help_text">
						기존 설비구분을 선택하거나 신규 설비구분을 입력한 뒤 자동생성을 누르세요.
						신규 입력 시 <strong>EQ-</strong>는 생략할 수 있습니다.
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						설비코드 <span class="modal_required">*</span>
					</label>

					<div class="equipment-code-generate-box">
						<input type="text" name="equipCode" id="equipCode"
							class="modal_input"
							placeholder="설비구분 선택/입력 후 자동생성"
							readonly required />

						<button type="button"
							class="search-btn search-btn-main equipment-code-btn"
							onclick="generateEquipCode();">
							자동생성
						</button>
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						설비명 <span class="modal_required">*</span>
					</label>

					<input type="text" name="equipName" id="equipName"
						class="modal_input" maxlength="100"
						placeholder="설비명을 입력하세요." required />
				</div>

				<div class="modal_item">
					<label class="modal_label">
						라인 <span class="modal_required">*</span>
					</label>

					<select name="lineId" id="lineId" class="modal_select" required>
						<option value="">선택</option>

						<c:forEach var="line" items="${lineList}">
							<option value="${line.line_id}">
								${line.line_name}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="modal_item autocomplete_wrap">
					<label class="modal_label">
						제조사 <span class="modal_required">*</span>
					</label>

					<input type="hidden" name="clientId" id="clientId" />

					<input type="text" id="clientNameInput"
						class="modal_input"
						placeholder="제조사명을 입력하세요."
						autocomplete="off"
						oninput="searchClientAutoComplete(true);"
						onfocus="openClientAutoCompleteIfKeyword();" />

					<div id="clientAutoCompleteList" class="autocomplete_list"></div>

					<div id="selectedClientInfo" class="modal_help_text">
						제조사를 선택하면 거래처 ID가 표시됩니다.
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						설비상태 <span class="modal_required">*</span>
					</label>

					<select name="equipStatus" id="equipStatus"
						class="modal_select" required>
						<option value="가동">가동</option>
						<option value="비가동">비가동</option>
						<option value="점검">점검</option>
						<option value="고장">고장</option>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">설치위치</label>

					<input type="text" name="equipLoc" id="equipLoc"
						class="modal_input" maxlength="100"
						placeholder="예: 1라인" />
				</div>

				<div class="modal_item">
					<label class="modal_label">설비금액</label>

					<input type="number" name="equipPrice" id="equipPrice"
						class="modal_input" min="0" placeholder="예: 55000000" />
				</div>

				<div class="modal_item">
					<label class="modal_label">구매일</label>

					<input type="date" name="buyDate" id="buyDate"
						class="modal_input" />
				</div>

				<div class="modal_item">
					<label class="modal_label">사용여부</label>

					<select name="useYn" id="useYn" class="modal_select">
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				</div>

				<div class="modal_item modal_item_full">
					<label class="modal_label">비고</label>

					<textarea name="remark" id="remark"
						class="modal_textarea" maxlength="500"
						placeholder="비고를 입력하세요."></textarea>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button"
					class="modal_btn modal_btn_cancel modal_close_btn">
					취소
				</button>

				<button type="submit" class="modal_btn modal_btn_submit">
					등록
				</button>
			</div>

		</form>
	</div>
</div>


<%-- =============================================================
     7. 설비관리 화면 전용 최소 스타일
     ============================================================= --%>
<style>
.equipment-code-generate-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.equipment-code-generate-box > input {
	flex: 1 1 auto;
	min-width: 0;
}

.equipment-code-btn {
	flex: 0 0 auto;
	white-space: nowrap;
}

.modal_help_text {
	font-size: 13px;
	color: #666;
	line-height: 1.5;
	padding: 6px 0;
}

.autocomplete_wrap {
	position: relative;
}

.autocomplete_list {
	display: none;
	position: absolute;
	left: 0;
	right: 0;
	top: 74px;
	z-index: 100;
	max-height: 180px;
	overflow-y: auto;
	background: #fff;
	border: 1px solid #ddd;
	border-radius: 6px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	box-sizing: border-box;
}

.autocomplete_item {
	padding: 9px 11px;
	font-size: 14px;
	cursor: pointer;
	border-bottom: 1px solid #f2f2f2;
	background: #fff;
}

.autocomplete_item:last-child {
	border-bottom: 0;
}

.autocomplete_item:hover {
	background: #f5f7fa;
}

.autocomplete_item_code {
	display: block;
	font-size: 12px;
	color: #777;
	margin-top: 2px;
}
</style>


<%-- =============================================================
     8. 설비관리 화면 전용 스크립트
     ============================================================= --%>
<script>
	var contextPath = "${contextPath}";


	/*
	 * 선택 컬럼명 클릭 시 현재 목록 체크박스 전체 선택/해제
	 */
	function toggleAllMasterEquipmentCheck() {

		var checkList = document.getElementsByName("equipIdList");

		if (checkList == null || checkList.length === 0) {
			return;
		}

		var allChecked = true;

		for (var i = 0; i < checkList.length; i++) {
			if (!checkList[i].checked) {
				allChecked = false;
				break;
			}
		}

		for (var j = 0; j < checkList.length; j++) {
			checkList[j].checked = !allChecked;
		}
	}


	/*
	 * 선택 삭제
	 * 실제 삭제가 아니라 서버에서 use_yn = 'N' 처리한다.
	 */
	function submitMasterEquipmentDeleteForm() {

		var checkList = document.getElementsByName("equipIdList");
		var checkedCount = 0;

		for (var i = 0; i < checkList.length; i++) {
			if (checkList[i].checked) {
				checkedCount++;
			}
		}

		if (checkedCount === 0) {
			alert("삭제 처리할 설비를 선택해 주세요.");
			return;
		}

		if (!confirm("선택한 설비를 미사용 처리하시겠습니까?")) {
			return;
		}

		document.getElementById("masterEquipmentDeleteForm").submit();
	}


	/*
	 * 기존 설비구분 선택
	 */
	function selectExistingEquipCodePrefix() {

		var existingPrefix = getTrimValue("existingEquipCodePrefix");

		if (existingPrefix !== "") {
			document.getElementById("newEquipCodePrefix").value = "";
			document.getElementById("equipCodePrefix").value = existingPrefix;
		} else {
			document.getElementById("equipCodePrefix").value = "";
		}

		clearGeneratedEquipCode();
	}


	/*
	 * 신규 설비구분 입력
	 */
	function inputNewEquipCodePrefix() {

		var newPrefix = getTrimValue("newEquipCodePrefix");

		if (newPrefix !== "") {
			document.getElementById("existingEquipCodePrefix").value = "";
			document.getElementById("equipCodePrefix").value = normalizeEquipCodePrefix(newPrefix);
		} else {
			document.getElementById("equipCodePrefix").value = "";
		}

		clearGeneratedEquipCode();
	}


	/*
	 * 설비코드 prefix 정규화
	 *
	 * CUT    -> EQ-CUT
	 * eq-dry -> EQ-DRY
	 * EQ-VIS -> EQ-VIS
	 */
	function normalizeEquipCodePrefix(prefix) {

		if (prefix == null) {
			return "";
		}

		prefix = prefix.trim().toUpperCase();

		if (prefix === "") {
			return "";
		}

		if (prefix.indexOf("EQ-") !== 0) {
			prefix = "EQ-" + prefix;
		}

		return prefix;
	}


	/*
	 * 설비코드 prefix 검증
	 */
	function isValidEquipCodePrefix(prefix) {

		var regex = /^EQ-[A-Z0-9]+(-[A-Z0-9]+)*$/;

		return regex.test(prefix);
	}


	/*
	 * 설비코드 자동생성
	 */
	function generateEquipCode() {

		var prefix = getCurrentEquipCodePrefix();

		if (prefix === "") {
			alert("기존 설비구분을 선택하거나 신규 설비구분을 입력해 주세요.");
			focusEquipCodePrefixInput();
			return;
		}

		if (!isValidEquipCodePrefix(prefix)) {
			alert("설비구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: EQ-CUT");
			focusEquipCodePrefixInput();
			return;
		}

		document.getElementById("equipCodePrefix").value = prefix;

		var xhr = new XMLHttpRequest();

		xhr.open("GET", contextPath
				+ "/master/equipment/nextCode?equipCodePrefix="
				+ encodeURIComponent(prefix), true);

		xhr.onreadystatechange = function() {

			if (xhr.readyState !== 4) {
				return;
			}

			if (xhr.status === 200) {

				var responseText = xhr.responseText;

				if (responseText.indexOf("EQ-") === 0) {
					document.getElementById("equipCode").value = responseText;
					return;
				}

				alert(responseText);
				return;
			}

			alert("설비코드 자동생성 중 오류가 발생했습니다.");
		};

		xhr.send();
	}


	/*
	 * 현재 설비구분 prefix 가져오기
	 */
	function getCurrentEquipCodePrefix() {

		var newPrefix = getTrimValue("newEquipCodePrefix");
		var existingPrefix = getTrimValue("existingEquipCodePrefix");

		if (newPrefix !== "") {
			return normalizeEquipCodePrefix(newPrefix);
		}

		if (existingPrefix !== "") {
			return normalizeEquipCodePrefix(existingPrefix);
		}

		return "";
	}


	/*
	 * prefix 입력 영역 포커스
	 */
	function focusEquipCodePrefixInput() {

		var existingPrefix = document.getElementById("existingEquipCodePrefix");
		var newPrefix = document.getElementById("newEquipCodePrefix");

		if (existingPrefix != null && existingPrefix.value === "") {
			existingPrefix.focus();
			return;
		}

		if (newPrefix != null) {
			newPrefix.focus();
		}
	}


	/*
	 * 설비구분 변경 시 기존 자동생성 코드 초기화
	 */
	function clearGeneratedEquipCode() {

		var equipCodeElement = document.getElementById("equipCode");

		if (equipCodeElement != null) {
			equipCodeElement.value = "";
		}
	}


	/*
	 * 제조사 자동완성 열기
	 */
	function openClientAutoCompleteIfKeyword() {

		var keyword = getTrimValue("clientNameInput");

		if (keyword.length < 1) {
			return;
		}

		searchClientAutoComplete(false);
	}


	/*
	 * 제조사 자동완성 조회
	 *
	 * resetSelected:
	 * - true  : 사용자가 직접 입력 중이므로 clientId 초기화
	 * - false : focus 등으로 목록만 다시 열 때 clientId 유지
	 */
	function searchClientAutoComplete(resetSelected) {

		var keyword = getTrimValue("clientNameInput");

		if (resetSelected) {
			document.getElementById("clientId").value = "";
			document.getElementById("selectedClientInfo").textContent =
				"제조사를 선택하면 거래처 ID가 표시됩니다.";
		}

		if (keyword.length < 1) {
			hideClientAutoComplete();
			return;
		}

		var xhr = new XMLHttpRequest();

		xhr.open("GET", contextPath
				+ "/master/equipment/clientAutoComplete?keyword="
				+ encodeURIComponent(keyword), true);

		xhr.onreadystatechange = function() {

			if (xhr.readyState !== 4) {
				return;
			}

			if (xhr.status !== 200) {
				hideClientAutoComplete();
				return;
			}

			try {
				var clientList = JSON.parse(xhr.responseText);
				renderClientAutoComplete(clientList);
			} catch (e) {
				hideClientAutoComplete();
			}
		};

		xhr.send();
	}


	/*
	 * 제조사 자동완성 목록 출력
	 */
	function renderClientAutoComplete(clientList) {

		var listBox = document.getElementById("clientAutoCompleteList");

		if (clientList == null || clientList.length === 0) {
			listBox.innerHTML =
				"<div class='autocomplete_item'>검색 결과가 없습니다.</div>";
			listBox.style.display = "block";
			return;
		}

		var html = "";

		for (var i = 0; i < clientList.length; i++) {

			var client = clientList[i];

			html += "<div class='autocomplete_item' "
					+ "onclick=\"selectClientAutoComplete('"
					+ escapeJs(client.clientId) + "', '"
					+ escapeJs(client.clientName) + "', '"
					+ escapeJs(client.clientCode) + "')\">"
					+ escapeHtml(client.clientName)
					+ "<span class='autocomplete_item_code'>"
					+ escapeHtml(client.clientCode)
					+ " / ID: "
					+ escapeHtml(client.clientId)
					+ "</span>"
					+ "</div>";
		}

		listBox.innerHTML = html;
		listBox.style.display = "block";
	}


	/*
	 * 제조사 자동완성 선택
	 */
	function selectClientAutoComplete(clientId, clientName, clientCode) {

		document.getElementById("clientId").value = clientId;
		document.getElementById("clientNameInput").value = clientName;

		document.getElementById("selectedClientInfo").textContent =
			"선택된 제조사 ID: " + clientId + " / 코드: " + clientCode;

		hideClientAutoComplete();
	}


	/*
	 * 제조사 자동완성 숨김
	 */
	function hideClientAutoComplete() {

		var listBox = document.getElementById("clientAutoCompleteList");

		if (listBox != null) {
			listBox.style.display = "none";
			listBox.innerHTML = "";
		}
	}


	/*
	 * 모달 외부 클릭 시 자동완성 닫기
	 */
	document.addEventListener("click", function(event) {

		var wrap = document.querySelector(".autocomplete_wrap");

		if (wrap != null && !wrap.contains(event.target)) {
			hideClientAutoComplete();
		}
	});


	/*
	 * 설비 등록 검증
	 */
	function validateMasterEquipmentAddForm() {

		var prefix = getCurrentEquipCodePrefix();
		var equipCode = getTrimValue("equipCode");
		var equipName = getTrimValue("equipName");
		var lineId = getTrimValue("lineId");
		var clientId = getTrimValue("clientId");
		var equipStatus = getTrimValue("equipStatus");
		var equipPrice = getTrimValue("equipPrice");

		if (prefix === "") {
			alert("기존 설비구분을 선택하거나 신규 설비구분을 입력해 주세요.");
			focusEquipCodePrefixInput();
			return false;
		}

		if (!isValidEquipCodePrefix(prefix)) {
			alert("설비구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: EQ-CUT");
			focusEquipCodePrefixInput();
			return false;
		}

		document.getElementById("equipCodePrefix").value = prefix;

		if (equipCode === "") {
			alert("설비코드를 자동생성해 주세요.");
			return false;
		}

		if (equipCode.indexOf(prefix + "-") !== 0) {
			alert("설비구분이 변경되었습니다. 설비코드를 다시 자동생성해 주세요.");
			return false;
		}

		if (equipName === "") {
			alert("설비명을 입력해 주세요.");
			document.getElementById("equipName").focus();
			return false;
		}

		if (lineId === "") {
			alert("라인을 선택해 주세요.");
			document.getElementById("lineId").focus();
			return false;
		}

		if (clientId === "") {
			alert("제조사를 자동완성 목록에서 선택해 주세요.");
			document.getElementById("clientNameInput").focus();
			return false;
		}

		if (equipStatus === "") {
			alert("설비상태를 선택해 주세요.");
			document.getElementById("equipStatus").focus();
			return false;
		}

		if (equipPrice !== "" && Number(equipPrice) < 0) {
			alert("설비금액은 0 이상으로 입력해 주세요.");
			document.getElementById("equipPrice").focus();
			return false;
		}

		return true;
	}


	function getTrimValue(elementId) {

		var element = document.getElementById(elementId);

		if (element == null || element.value == null) {
			return "";
		}

		return element.value.trim();
	}


	function escapeJs(value) {

		if (value == null) {
			return "";
		}

		return String(value)
			.replace(/\\/g, "\\\\")
			.replace(/'/g, "\\'")
			.replace(/"/g, "&quot;")
			.replace(/\n/g, "")
			.replace(/\r/g, "");
	}


	function escapeHtml(value) {

		if (value == null) {
			return "";
		}

		return String(value)
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;")
			.replace(/'/g, "&#039;");
	}
</script>