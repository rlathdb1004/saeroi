<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
    파일명: masterClient.jsp
    메뉴: 기준정보관리 > 거래처관리

    기준:
    - 기존 ClientDTO / ClientDAO와 충돌 방지를 위해 MasterClient 명칭 사용
    - 품목관리 item.jsp 구조 중심 적용
    - 거래처구분은 client_code prefix 기준으로 관리
    - 기존 거래처구분 선택 가능
    - 신규 거래처구분 직접입력 가능
    - 거래처코드는 prefix 기준 자동생성
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
			action="${contextPath}/master/client">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label> <select name="searchType"
						class="search-select">
						<option value="">선택</option>

						<option value="clientCodePrefix"
							<c:if test="${masterClientDTO.searchType == 'clientCodePrefix'}">selected</c:if>>
							거래처구분</option>

						<option value="clientCode"
							<c:if test="${masterClientDTO.searchType == 'clientCode'}">selected</c:if>>
							거래처코드</option>

						<option value="clientName"
							<c:if test="${masterClientDTO.searchType == 'clientName'}">selected</c:if>>
							거래처명</option>

						<option value="clientType"
							<c:if test="${masterClientDTO.searchType == 'clientType'}">selected</c:if>>
							구분값</option>

						<option value="clientMan"
							<c:if test="${masterClientDTO.searchType == 'clientMan'}">selected</c:if>>
							담당자</option>

						<option value="clientTel"
							<c:if test="${masterClientDTO.searchType == 'clientTel'}">selected</c:if>>
							전화번호</option>

						<option value="useYn"
							<c:if test="${masterClientDTO.searchType == 'useYn'}">selected</c:if>>
							사용여부</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="searchKeyword" class="search-input"
						value="${masterClientDTO.searchKeyword}" placeholder="내용을 입력하세요." />
				</div>

				<div class="search-item">
					<label class="search-label">보기</label> <select name="size"
						class="search-select">
						<option value="5"
							<c:if test="${pageInfo.size == 5}">selected</c:if>>5개씩</option>
						<option value="10"
							<c:if test="${pageInfo.size == 10}">selected</c:if>>
							10개씩</option>
						<option value="20"
							<c:if test="${pageInfo.size == 20}">selected</c:if>>
							20개씩</option>
						<option value="30"
							<c:if test="${pageInfo.size == 30}">selected</c:if>>
							30개씩</option>
					</select>
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor"
								stroke-width="2"></circle>
							<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/master/client'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"></path>
							<path d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round"></path>
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
			총 <strong>${masterClientCount}</strong>건
		</div>

		<div class="search-btn-right">

			<button type="button"
				class="search-btn search-btn-main modal_open_btn"
				data_modal_target="#masterClientModal">
				<svg viewBox="0 0 24 24" fill="none">
					<path d="M12 5V19" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
					<path d="M5 12H19" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
				</svg>
				등록
			</button>

			<button type="button"
				class="search-btn search-btn-sub pc-only-delete-btn"
				onclick="submitMasterClientDeleteForm();">
				<svg viewBox="0 0 24 24" fill="none">
					<path d="M4 7H20" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
					<path d="M10 11V17" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
					<path d="M14 11V17" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
					<path d="M6 7L7 21H17L18 7" stroke="currentColor" stroke-width="2"
						stroke-linejoin="round"></path>
					<path d="M9 7V4H15V7" stroke="currentColor" stroke-width="2"
						stroke-linejoin="round"></path>
				</svg>
				선택 삭제
			</button>

		</div>
	</div>


	<%-- =========================================================
         4. 거래처 목록 테이블

         PC 컬럼 8개:
         1 선택
         2 거래처코드
         3 거래처명
         4 구분
         5 담당자
         6 전화번호
         7 사용여부
         8 상세

         모바일 컬럼 5개:
         1 선택
         2 거래처명
         3 구분
         4 전화번호
         5 상세
         ========================================================= --%>
	<form id="masterClientDeleteForm" method="post"
		action="${contextPath}/master/client/delete">

		<div class="coTableWrap">
			<table class="coTable master-client-table" id="masterClientListTable">

				<thead>
					<tr>
						<th class="mobile_show" onclick="toggleAllMasterClientCheck();"
							title="전체 선택/해제">선택</th>

						<th class="mobile_hidden">거래처코드</th>

						<th class="mobile_show">거래처명</th>

						<th class="mobile_show">구분</th>

						<th class="mobile_hidden">담당자</th>

						<th class="mobile_show">전화번호</th>

						<th class="mobile_hidden">사용여부</th>

						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty masterClientList}">
							<c:forEach var="masterClient" items="${masterClientList}">

								<tr>
									<td class="mobile_show"><input type="checkbox"
										name="clientIdList" value="${masterClient.clientId}"></td>

									<td class="mobile_hidden" title="${masterClient.clientCode}">
										${masterClient.clientCode}</td>

									<td class="mobile_show" title="${masterClient.clientName}">
										${masterClient.clientName}</td>

									<td class="mobile_show"><c:choose>
											<c:when test="${not empty masterClient.clientTypeName}">
												${masterClient.clientTypeName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose></td>

									<td class="mobile_hidden" title="${masterClient.clientMan}">
										<c:choose>
											<c:when test="${not empty masterClient.clientMan}">
												${masterClient.clientMan}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show" title="${masterClient.clientTel}">
										<c:choose>
											<c:when test="${not empty masterClient.clientTel}">
												${masterClient.clientTel}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden"><c:choose>
											<c:when test="${masterClient.useYn == 'Y'}">
												<span class="coStatus coStatusUse">사용</span>
											</c:when>
											<c:otherwise>
												<span class="coStatus coStatusStop">미사용</span>
											</c:otherwise>
										</c:choose></td>

									<td class="mobile_show"><a
										href="${contextPath}/master/client/detail?clientId=${masterClient.clientId}"
										class="coDetailBtn">보기</a></td>
								</tr>

							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">조회된 거래처 정보가
									없습니다.</td>
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
		<c:set var="pageUrl" value="/master/client" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. 거래처 등록 모달
     ============================================================= --%>
<div id="masterClientModal" class="modal_wrap" aria-hidden="true">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">거래처 등록</h3>
		</div>

		<form id="masterClientAddForm" class="modal_form" method="post"
			action="${contextPath}/master/client/add"
			onsubmit="return validateMasterClientAddForm();">

			<input type="hidden" name="clientCodePrefix" id="clientCodePrefix" />
			<input type="hidden" name="clientType" id="clientType" />

			<div class="modal_body modal_body_2col">

				<div class="modal_item">
					<label class="modal_label"> 기존 거래처구분 </label> <select
						id="existingClientCodePrefix" class="modal_select"
						onchange="selectExistingClientCodePrefix();">
						<option value="">기존 구분 선택</option>

						<c:forEach var="clientCodePrefix" items="${clientCodePrefixList}">
							<option value="${clientCodePrefix}">
								<c:choose>
									<c:when test="${clientCodePrefix == 'BP-SUP'}">
										BP-SUP(공급처)
									</c:when>
									<c:when test="${clientCodePrefix == 'BP-CUS'}">
										BP-CUS(납품처)
									</c:when>
									<c:otherwise>
										${clientCodePrefix}
									</c:otherwise>
								</c:choose>
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label"> 신규 거래처구분 </label> <input type="text"
						id="newClientCodePrefix" class="modal_input" maxlength="46"
						placeholder="예: SUP 또는 BP-SUP"
						oninput="inputNewClientCodePrefix();" />
				</div>

				<div class="modal_item modal_item_full">
					<div class="modal_help_text">
						기존 거래처구분을 선택하거나 신규 거래처구분을 입력한 뒤 자동생성을 누르세요. 신규 입력 시 <strong>BP-</strong>는
						생략할 수 있습니다.
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label"> 거래처코드 <span
						class="modal_required">*</span>
					</label>

					<div class="client-code-generate-box">
						<input type="text" name="clientCode" id="clientCode"
							class="modal_input" placeholder="거래처구분 선택/입력 후 자동생성" readonly
							required />

						<button type="button"
							class="search-btn search-btn-main client-code-btn"
							onclick="generateClientCode();">자동생성</button>
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label"> 거래처명 <span
						class="modal_required">*</span>
					</label> <input type="text" name="clientName" id="clientName"
						class="modal_input" maxlength="100" placeholder="거래처명을 입력하세요."
						required />
				</div>

				<div class="modal_item">
					<label class="modal_label">담당자</label> <input type="text"
						name="clientMan" id="clientMan" class="modal_input" maxlength="50"
						placeholder="담당자명을 입력하세요." />
				</div>

				<div class="modal_item">
					<label class="modal_label">전화번호</label> <input type="text"
						name="clientTel" id="clientTel" class="modal_input" maxlength="30"
						placeholder="예: 041-550-1001" />
				</div>

				<div class="modal_item">
					<label class="modal_label">담당부서</label> <input type="text"
						name="clientDept" id="clientDept" class="modal_input"
						maxlength="50" placeholder="예: 영업1팀" />
				</div>

				<div class="modal_item">
					<label class="modal_label">사용여부</label> <select name="useYn"
						id="useYn" class="modal_select">
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				</div>

				<div class="modal_item modal_item_full">
					<label class="modal_label">주소</label> <input type="text"
						name="clientAdress" id="clientAdress" class="modal_input"
						maxlength="200" placeholder="주소를 입력하세요." />
				</div>

				<div class="modal_item modal_item_full">
					<label class="modal_label">비고</label>

					<textarea name="remark" id="remark" class="modal_textarea"
						maxlength="500" placeholder="비고를 입력하세요."></textarea>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button"
					class="modal_btn modal_btn_cancel modal_close_btn">취소</button>

				<button type="submit" class="modal_btn modal_btn_submit">
					등록</button>
			</div>

		</form>
	</div>
</div>


<%-- =============================================================
     7. 거래처관리 화면 전용 최소 스타일
     ============================================================= --%>
<style>
.client-code-generate-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.client-code-generate-box>input {
	flex: 1 1 auto;
	min-width: 0;
}

.client-code-btn {
	flex: 0 0 auto;
	white-space: nowrap;
}

.modal_help_text {
	font-size: 13px;
	color: #666;
	line-height: 1.5;
	padding: 6px 0;
}
</style>


<%-- =============================================================
     8. 거래처관리 화면 전용 스크립트
     ============================================================= --%>
<script>
	var contextPath = "${contextPath}";

	/*
	 * 선택 컬럼명 클릭 시 현재 목록 체크박스 전체 선택/해제
	 */
	function toggleAllMasterClientCheck() {

		var checkList = document.getElementsByName("clientIdList");

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
	function submitMasterClientDeleteForm() {

		var checkList = document.getElementsByName("clientIdList");
		var checkedCount = 0;

		for (var i = 0; i < checkList.length; i++) {
			if (checkList[i].checked) {
				checkedCount++;
			}
		}

		if (checkedCount === 0) {
			alert("삭제 처리할 거래처를 선택해 주세요.");
			return;
		}

		if (!confirm("선택한 거래처를 미사용 처리하시겠습니까?")) {
			return;
		}

		document.getElementById("masterClientDeleteForm").submit();
	}

	/*
	 * 기존 거래처구분 선택
	 */
	function selectExistingClientCodePrefix() {

		var existingPrefix = getTrimValue("existingClientCodePrefix");

		if (existingPrefix !== "") {
			document.getElementById("newClientCodePrefix").value = "";
			document.getElementById("clientCodePrefix").value = existingPrefix;
			document.getElementById("clientType").value = extractClientType(existingPrefix);
		} else {
			document.getElementById("clientCodePrefix").value = "";
			document.getElementById("clientType").value = "";
		}

		clearGeneratedClientCode();
	}

	/*
	 * 신규 거래처구분 입력
	 */
	function inputNewClientCodePrefix() {

		var newPrefix = getTrimValue("newClientCodePrefix");

		if (newPrefix !== "") {
			var normalizedPrefix = normalizeClientCodePrefix(newPrefix);

			document.getElementById("existingClientCodePrefix").value = "";
			document.getElementById("clientCodePrefix").value = normalizedPrefix;
			document.getElementById("clientType").value = extractClientType(normalizedPrefix);
		} else {
			document.getElementById("clientCodePrefix").value = "";
			document.getElementById("clientType").value = "";
		}

		clearGeneratedClientCode();
	}

	/*
	 * 거래처코드 prefix 정규화
	 *
	 * SUP    -> BP-SUP
	 * bp-cus -> BP-CUS
	 * BP-CUS -> BP-CUS
	 */
	function normalizeClientCodePrefix(prefix) {

		if (prefix == null) {
			return "";
		}

		prefix = prefix.trim().toUpperCase();

		if (prefix === "") {
			return "";
		}

		if (prefix.indexOf("BP-") !== 0) {
			prefix = "BP-" + prefix;
		}

		return prefix;
	}

	/*
	 * prefix에서 clientType 추출
	 *
	 * BP-SUP -> SUP
	 * BP-CUS -> CUS
	 * BP-MAN-A -> MAN-A
	 */
	function extractClientType(prefix) {

		prefix = normalizeClientCodePrefix(prefix);

		if (prefix.indexOf("BP-") === 0) {
			return prefix.substring(3);
		}

		return prefix;
	}

	/*
	 * 거래처코드 prefix 검증
	 */
	function isValidClientCodePrefix(prefix) {

		var regex = /^BP-[A-Z0-9]+(-[A-Z0-9]+)*$/;

		return regex.test(prefix);
	}

	/*
	 * 거래처코드 자동생성
	 */
	function generateClientCode() {

		var prefix = getCurrentClientCodePrefix();

		if (prefix === "") {
			alert("기존 거래처구분을 선택하거나 신규 거래처구분을 입력해 주세요.");
			focusClientCodePrefixInput();
			return;
		}

		if (!isValidClientCodePrefix(prefix)) {
			alert("거래처구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: BP-SUP");
			focusClientCodePrefixInput();
			return;
		}

		document.getElementById("clientCodePrefix").value = prefix;
		document.getElementById("clientType").value = extractClientType(prefix);

		var xhr = new XMLHttpRequest();

		xhr.open("GET", contextPath
				+ "/master/client/nextCode?clientCodePrefix="
				+ encodeURIComponent(prefix), true);

		xhr.onreadystatechange = function() {

			if (xhr.readyState !== 4) {
				return;
			}

			if (xhr.status === 200) {

				var responseText = xhr.responseText;

				if (responseText.indexOf("BP-") === 0) {
					document.getElementById("clientCode").value = responseText;
					return;
				}

				alert(responseText);
				return;
			}

			alert("거래처코드 자동생성 중 오류가 발생했습니다.");
		};

		xhr.send();
	}

	/*
	 * 현재 거래처구분 prefix 가져오기
	 */
	function getCurrentClientCodePrefix() {

		var newPrefix = getTrimValue("newClientCodePrefix");
		var existingPrefix = getTrimValue("existingClientCodePrefix");

		if (newPrefix !== "") {
			return normalizeClientCodePrefix(newPrefix);
		}

		if (existingPrefix !== "") {
			return normalizeClientCodePrefix(existingPrefix);
		}

		return "";
	}

	/*
	 * prefix 입력 영역 포커스
	 */
	function focusClientCodePrefixInput() {

		var existingPrefix = document
				.getElementById("existingClientCodePrefix");
		var newPrefix = document.getElementById("newClientCodePrefix");

		if (existingPrefix != null && existingPrefix.value === "") {
			existingPrefix.focus();
			return;
		}

		if (newPrefix != null) {
			newPrefix.focus();
		}
	}

	/*
	 * 거래처구분 변경 시 기존 자동생성 코드 초기화
	 */
	function clearGeneratedClientCode() {

		var clientCodeElement = document.getElementById("clientCode");

		if (clientCodeElement != null) {
			clientCodeElement.value = "";
		}
	}

	/*
	 * 거래처 등록 검증
	 */
	function validateMasterClientAddForm() {

		var prefix = getCurrentClientCodePrefix();
		var clientCode = getTrimValue("clientCode");
		var clientName = getTrimValue("clientName");

		if (prefix === "") {
			alert("기존 거래처구분을 선택하거나 신규 거래처구분을 입력해 주세요.");
			focusClientCodePrefixInput();
			return false;
		}

		if (!isValidClientCodePrefix(prefix)) {
			alert("거래처구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: BP-SUP");
			focusClientCodePrefixInput();
			return false;
		}

		document.getElementById("clientCodePrefix").value = prefix;
		document.getElementById("clientType").value = extractClientType(prefix);

		if (clientCode === "") {
			alert("거래처코드를 자동생성해 주세요.");
			return false;
		}

		if (clientCode.indexOf(prefix + "-") !== 0) {
			alert("거래처구분이 변경되었습니다. 거래처코드를 다시 자동생성해 주세요.");
			return false;
		}

		if (clientName === "") {
			alert("거래처명을 입력해 주세요.");
			document.getElementById("clientName").focus();
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
</script>