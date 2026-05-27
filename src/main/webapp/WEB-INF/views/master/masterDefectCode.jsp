<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
    파일명: masterDefectCode.jsp
    메뉴: 기준정보관리 > 불량코드관리

    기준:
    - 기존 DefectDTO / 품질관리 불량관리 기능과 충돌 방지를 위해 MasterDefectCode 명칭 사용
    - 품목관리 item.jsp 구조 중심 적용
    - 불량코드는 defect_code prefix 기준으로 관리
    - 기존 불량코드구분 선택 가능
    - 신규 불량코드구분 직접입력 가능
    - 불량코드는 prefix 기준 자동생성
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
			action="${contextPath}/master/defectcode">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label> <select name="searchType"
						class="search-select">
						<option value="">선택</option>

						<option value="defectCodePrefix"
							<c:if test="${masterDefectCodeDTO.searchType == 'defectCodePrefix'}">selected</c:if>>
							불량코드구분</option>

						<option value="defectCode"
							<c:if test="${masterDefectCodeDTO.searchType == 'defectCode'}">selected</c:if>>
							불량코드</option>

						<option value="defectType"
							<c:if test="${masterDefectCodeDTO.searchType == 'defectType'}">selected</c:if>>
							불량유형</option>

						<option value="defectName"
							<c:if test="${masterDefectCodeDTO.searchType == 'defectName'}">selected</c:if>>
							불량명</option>

						<option value="remark"
							<c:if test="${masterDefectCodeDTO.searchType == 'remark'}">selected</c:if>>
							비고</option>

						<option value="useYn"
							<c:if test="${masterDefectCodeDTO.searchType == 'useYn'}">selected</c:if>>
							사용여부</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="searchKeyword" class="search-input"
						value="${masterDefectCodeDTO.searchKeyword}"
						placeholder="내용을 입력하세요." />
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
						onclick="location.href='${contextPath}/master/defectcode'">
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
			총 <strong>${masterDefectCodeCount}</strong>건
		</div>

		<div class="search-btn-right">

			<button type="button"
				class="search-btn search-btn-main modal_open_btn"
				data_modal_target="#masterDefectCodeModal">
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
				onclick="submitMasterDefectCodeDeleteForm();">
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
         4. 불량코드 목록 테이블

         PC 컬럼 8개:
         1 선택
         2 불량코드
         3 불량유형
         4 불량명
         5 비고
         6 등록일
         7 사용여부
         8 상세

         모바일 컬럼 5개:
         1 선택
         2 불량코드
         3 불량유형
         4 불량명
         5 상세
         ========================================================= --%>
	<form id="masterDefectCodeDeleteForm" method="post"
		action="${contextPath}/master/defectcode/delete">

		<div class="coTableWrap">
			<table class="coTable master-defect-code-table"
				id="masterDefectCodeListTable">

				<thead>
					<tr>
						<th class="mobile_show"
							onclick="toggleAllMasterDefectCodeCheck();" title="전체 선택/해제">선택</th>

						<th class="mobile_show">불량코드</th>

						<th class="mobile_show">불량유형</th>

						<th class="mobile_show">불량명</th>

						<th class="mobile_hidden">비고</th>

						<th class="mobile_hidden">등록일</th>

						<th class="mobile_hidden">사용여부</th>

						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty masterDefectCodeList}">
							<c:forEach var="masterDefectCode" items="${masterDefectCodeList}">

								<tr>
									<td class="mobile_show"><input type="checkbox"
										name="defectIdList" value="${masterDefectCode.defectId}">
									</td>

									<td class="mobile_show" title="${masterDefectCode.defectCode}">
										${masterDefectCode.defectCode}</td>

									<td class="mobile_show" title="${masterDefectCode.defectType}">
										<c:choose>
											<c:when test="${not empty masterDefectCode.defectType}">
												${masterDefectCode.defectType}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show" title="${masterDefectCode.defectName}">
										<c:choose>
											<c:when test="${not empty masterDefectCode.defectName}">
												${masterDefectCode.defectName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden" title="${masterDefectCode.remark}">
										<c:choose>
											<c:when test="${not empty masterDefectCode.remark}">
												${masterDefectCode.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden"><c:choose>
											<c:when test="${not empty masterDefectCode.createdDate}">
												<fmt:formatDate value="${masterDefectCode.createdDate}"
													pattern="yyyy-MM-dd" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose></td>

									<td class="mobile_hidden"><c:choose>
											<c:when test="${masterDefectCode.useYn == 'Y'}">
												<span class="coStatus coStatusUse">사용</span>
											</c:when>
											<c:otherwise>
												<span class="coStatus coStatusStop">미사용</span>
											</c:otherwise>
										</c:choose></td>

									<td class="mobile_show"><a
										href="${contextPath}/master/defectcode/detail?defectId=${masterDefectCode.defectId}"
										class="coDetailBtn">보기</a></td>
								</tr>

							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">조회된 불량코드 정보가
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
		<c:set var="pageUrl" value="/master/defectcode" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. 불량코드 등록 모달
     ============================================================= --%>
<div id="masterDefectCodeModal" class="modal_wrap" aria-hidden="true">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">불량코드 등록</h3>
		</div>

		<form id="masterDefectCodeAddForm" class="modal_form" method="post"
			action="${contextPath}/master/defectcode/add"
			onsubmit="return validateMasterDefectCodeAddForm();">

			<input type="hidden" name="defectCodePrefix" id="defectCodePrefix" />

			<div class="modal_body modal_body_2col">

				<div class="modal_item">
					<label class="modal_label">기존 불량코드구분</label> <select
						id="existingDefectCodePrefix" class="modal_select"
						onchange="selectExistingDefectCodePrefix();">
						<option value="">기존 구분 선택</option>

						<c:forEach var="defectCodePrefix" items="${defectCodePrefixList}">
							<option value="${defectCodePrefix}">${defectCodePrefix}
								<c:choose>
									<c:when test="${defectCodePrefix == 'DCD-DIM'}">(치수)</c:when>
									<c:when test="${defectCodePrefix == 'DCD-CUT'}">(재단)</c:when>
									<c:when test="${defectCodePrefix == 'DCD-ADH'}">(접착)</c:when>
									<c:when test="${defectCodePrefix == 'DCD-CONT'}">(오염)</c:when>
									<c:when test="${defectCodePrefix == 'DCD-CRK'}">(크랙)</c:when>
									<c:when test="${defectCodePrefix == 'DEF-BAR'}">(바코드)</c:when>
								</c:choose>
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">신규 불량코드구분</label> <input type="text"
						id="newDefectCodePrefix" class="modal_input" maxlength="46"
						placeholder="예: DCD-DIM 또는 DEF-BAR"
						oninput="inputNewDefectCodePrefix();" />
				</div>

				<div class="modal_item modal_item_full">
					<div class="modal_help_text">
						기존 불량코드구분을 선택하거나 신규 불량코드구분을 입력한 뒤 자동생성을 누르세요. 예: <strong>DCD-DIM</strong>,
						<strong>DCD-CUT</strong>, <strong>DEF-BAR</strong>
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label"> 불량코드 <span
						class="modal_required">*</span>
					</label>

					<div class="defect-code-generate-box">
						<input type="text" name="defectCode" id="defectCode"
							class="modal_input" placeholder="불량코드구분 선택/입력 후 자동생성" readonly
							required />

						<button type="button"
							class="search-btn search-btn-main defect-code-btn"
							onclick="generateDefectCode();">자동생성</button>
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label"> 불량유형 <span
						class="modal_required">*</span>
					</label> <input type="text" name="defectType" id="defectType"
						class="modal_input" maxlength="30"
						placeholder="예: 치수, 재단, 접착, 외관, 라벨" required />
				</div>

				<div class="modal_item">
					<label class="modal_label"> 불량명 <span
						class="modal_required">*</span>
					</label> <input type="text" name="defectName" id="defectName"
						class="modal_input" maxlength="100" placeholder="불량명을 입력하세요."
						required />
				</div>

				<div class="modal_item">
					<label class="modal_label">사용여부</label> <select name="useYn"
						id="useYn" class="modal_select">
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
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
     7. 불량코드관리 화면 전용 최소 스타일
     ============================================================= --%>
<style>
.defect-code-generate-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.defect-code-generate-box>input {
	flex: 1 1 auto;
	min-width: 0;
}

.defect-code-btn {
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
     8. 불량코드관리 화면 전용 스크립트
     ============================================================= --%>
<script>
	var contextPath = "${contextPath}";

	/*
	 * 선택 컬럼명 클릭 시 현재 목록 체크박스 전체 선택/해제
	 */
	function toggleAllMasterDefectCodeCheck() {

		var checkList = document.getElementsByName("defectIdList");

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
	function submitMasterDefectCodeDeleteForm() {

		var checkList = document.getElementsByName("defectIdList");
		var checkedCount = 0;

		for (var i = 0; i < checkList.length; i++) {
			if (checkList[i].checked) {
				checkedCount++;
			}
		}

		if (checkedCount === 0) {
			alert("삭제 처리할 불량코드를 선택해 주세요.");
			return;
		}

		if (!confirm("선택한 불량코드를 미사용 처리하시겠습니까?")) {
			return;
		}

		document.getElementById("masterDefectCodeDeleteForm").submit();
	}

	/*
	 * 기존 불량코드구분 선택
	 */
	function selectExistingDefectCodePrefix() {

		var existingPrefix = getTrimValue("existingDefectCodePrefix");

		if (existingPrefix !== "") {
			document.getElementById("newDefectCodePrefix").value = "";
			document.getElementById("defectCodePrefix").value = existingPrefix;
		} else {
			document.getElementById("defectCodePrefix").value = "";
		}

		clearGeneratedDefectCode();
	}

	/*
	 * 신규 불량코드구분 입력
	 */
	function inputNewDefectCodePrefix() {

		var newPrefix = getTrimValue("newDefectCodePrefix");

		if (newPrefix !== "") {
			var normalizedPrefix = normalizeDefectCodePrefix(newPrefix);

			document.getElementById("existingDefectCodePrefix").value = "";
			document.getElementById("defectCodePrefix").value = normalizedPrefix;
		} else {
			document.getElementById("defectCodePrefix").value = "";
		}

		clearGeneratedDefectCode();
	}

	/*
	 * 불량코드 prefix 정규화
	 *
	 * dcd-dim      -> DCD-DIM
	 * DCD-DIM-001  -> DCD-DIM
	 * def-bar      -> DEF-BAR
	 */
	function normalizeDefectCodePrefix(prefix) {

		if (prefix == null) {
			return "";
		}

		prefix = prefix.trim().toUpperCase();
		prefix = prefix.replace(/\s+/g, "");

		if (prefix === "") {
			return "";
		}

		// 사용자가 전체 코드(DCD-DIM-001)를 입력한 경우 prefix만 남긴다.
		prefix = prefix.replace(/-[0-9]{3}$/, "");

		return prefix;
	}

	/*
	 * 불량코드 prefix 검증
	 */
	function isValidDefectCodePrefix(prefix) {

		var regex = /^[A-Z0-9]+(-[A-Z0-9]+)*$/;

		return regex.test(prefix);
	}

	/*
	 * 불량코드 전체 형식 검증
	 */
	function isValidDefectCode(code) {

		var regex = /^[A-Z0-9]+(-[A-Z0-9]+)*-[0-9]{3}$/;

		return regex.test(code);
	}

	/*
	 * 불량코드 자동생성
	 */
	function generateDefectCode() {

		var prefix = getCurrentDefectCodePrefix();

		if (prefix === "") {
			alert("기존 불량코드구분을 선택하거나 신규 불량코드구분을 입력해 주세요.");
			focusDefectCodePrefixInput();
			return;
		}

		if (!isValidDefectCodePrefix(prefix)) {
			alert("불량코드구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: DCD-DIM");
			focusDefectCodePrefixInput();
			return;
		}

		document.getElementById("defectCodePrefix").value = prefix;

		var xhr = new XMLHttpRequest();

		xhr.open("GET", contextPath
				+ "/master/defectcode/nextCode?defectCodePrefix="
				+ encodeURIComponent(prefix), true);

		xhr.onreadystatechange = function() {

			if (xhr.readyState !== 4) {
				return;
			}

			if (xhr.status === 200) {

				var responseText = xhr.responseText;

				if (isValidDefectCode(responseText)
						&& responseText.indexOf(prefix + "-") === 0) {
					document.getElementById("defectCode").value = responseText;
					return;
				}

				alert(responseText);
				return;
			}

			alert("불량코드 자동생성 중 오류가 발생했습니다.");
		};

		xhr.send();
	}

	/*
	 * 현재 불량코드구분 prefix 가져오기
	 */
	function getCurrentDefectCodePrefix() {

		var newPrefix = getTrimValue("newDefectCodePrefix");
		var existingPrefix = getTrimValue("existingDefectCodePrefix");

		if (newPrefix !== "") {
			return normalizeDefectCodePrefix(newPrefix);
		}

		if (existingPrefix !== "") {
			return normalizeDefectCodePrefix(existingPrefix);
		}

		return "";
	}

	/*
	 * prefix 입력 영역 포커스
	 */
	function focusDefectCodePrefixInput() {

		var existingPrefix = document
				.getElementById("existingDefectCodePrefix");
		var newPrefix = document.getElementById("newDefectCodePrefix");

		if (existingPrefix != null && existingPrefix.value === "") {
			existingPrefix.focus();
			return;
		}

		if (newPrefix != null) {
			newPrefix.focus();
		}
	}

	/*
	 * 불량코드구분 변경 시 기존 자동생성 코드 초기화
	 */
	function clearGeneratedDefectCode() {

		var defectCodeElement = document.getElementById("defectCode");

		if (defectCodeElement != null) {
			defectCodeElement.value = "";
		}
	}

	/*
	 * 불량코드 등록 검증
	 */
	function validateMasterDefectCodeAddForm() {

		var prefix = getCurrentDefectCodePrefix();
		var defectCode = getTrimValue("defectCode");
		var defectType = getTrimValue("defectType");
		var defectName = getTrimValue("defectName");

		if (prefix === "") {
			alert("기존 불량코드구분을 선택하거나 신규 불량코드구분을 입력해 주세요.");
			focusDefectCodePrefixInput();
			return false;
		}

		if (!isValidDefectCodePrefix(prefix)) {
			alert("불량코드구분은 영문, 숫자, 하이픈만 입력할 수 있습니다. 예: DCD-DIM");
			focusDefectCodePrefixInput();
			return false;
		}

		document.getElementById("defectCodePrefix").value = prefix;

		if (defectCode === "") {
			alert("불량코드를 자동생성해 주세요.");
			return false;
		}

		if (!isValidDefectCode(defectCode)) {
			alert("불량코드 형식이 올바르지 않습니다. 예: DCD-DIM-001");
			return false;
		}

		if (defectCode.indexOf(prefix + "-") !== 0) {
			alert("불량코드구분이 변경되었습니다. 불량코드를 다시 자동생성해 주세요.");
			return false;
		}

		if (defectType === "") {
			alert("불량유형을 입력해 주세요.");
			document.getElementById("defectType").focus();
			return false;
		}

		if (defectName === "") {
			alert("불량명을 입력해 주세요.");
			document.getElementById("defectName").focus();
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