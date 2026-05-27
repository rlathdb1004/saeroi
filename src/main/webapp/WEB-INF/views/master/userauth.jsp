<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: userauth.jsp
	메뉴: 기준정보관리 > 사용자/권한관리

	기준:
	- URL: /system/userauth
	- Controller return: master/userauth.tiles
	- JSP 위치: /WEB-INF/views/master/userauth.jsp
	- emp 테이블 기준
	- 로그인 ID는 emp.empno 사번 사용
	- email은 로그인 ID가 아니라 연락용 이메일
	- 권한은 emp.role 그대로 사용
	- role 값: ADMIN, MANAGER, QC, MAINT, WORKER
	- 숫자 role_level 사용 안 함
	- 실제 DELETE 없음
	- 계정 사용 여부는 status로 관리: 재직, 휴직, 퇴사, 잠금
	- 신규계정 생성 시 임시비밀번호 자동 발급
	- 전화번호는 입력은 유연하게 받고 저장 전 010-1111-1111 형식으로 정리
	- 공용 content.css / searchtable.css / modal.css / mobile.css 우선 사용
	- 선택 컬럼명 클릭 시 현재 목록 체크박스 전체선택/해제

	목록 컬럼 기준:
	- PC: 체크박스 포함 8개
	- 모바일: 체크박스 포함 5개
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
	     1. 검색 영역
	     ========================================================= --%>
	<div class="search-box">
		<form class="search-form" method="get"
			action="${contextPath}/system/userauth">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="searchType" class="search-select">
						<option value="">선택</option>

						<option value="empno"
							<c:if test="${systemUserAuthDTO.searchType == 'empno'}">selected</c:if>>
							로그인 ID/사번
						</option>

						<option value="ename"
							<c:if test="${systemUserAuthDTO.searchType == 'ename'}">selected</c:if>>
							이름
						</option>

						<option value="dept"
							<c:if test="${systemUserAuthDTO.searchType == 'dept'}">selected</c:if>>
							부서
						</option>

						<option value="job"
							<c:if test="${systemUserAuthDTO.searchType == 'job'}">selected</c:if>>
							직무
						</option>

						<option value="role"
							<c:if test="${systemUserAuthDTO.searchType == 'role'}">selected</c:if>>
							권한
						</option>

						<option value="status"
							<c:if test="${systemUserAuthDTO.searchType == 'status'}">selected</c:if>>
							상태
						</option>

						<option value="email"
							<c:if test="${systemUserAuthDTO.searchType == 'email'}">selected</c:if>>
							연락 이메일
						</option>

						<option value="empTel"
							<c:if test="${systemUserAuthDTO.searchType == 'empTel'}">selected</c:if>>
							전화번호
						</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text" name="searchKeyword" class="search-input"
						value="${systemUserAuthDTO.searchKeyword}"
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
						onclick="location.href='${contextPath}/system/userauth'">
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
	     2. 처리 메시지 / 임시비밀번호 1회 표시
	     ========================================================= --%>
	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>

	<c:if test="${not empty tempPassword}">
		<script>
			alert(
				"임시비밀번호가 발급되었습니다.\n\n"
				+ "로그인 ID/사번: ${tempPasswordEmpno}\n"
				+ "이름: ${tempPasswordEname}\n"
				+ "임시비밀번호: ${tempPassword}\n\n"
				+ "해당 비밀번호는 지금 화면에서만 확인할 수 있습니다."
			);
		</script>
	</c:if>


	<%-- =========================================================
	     3. 총 건수 / 등록 / 상태 변경 영역
	     ========================================================= --%>
	<div class="search-table-top">

		<div class="search-total-area">
			총 <strong>${userAuthCount}</strong>건
		</div>

		<div class="search-btn-right">

			<button type="button"
				class="search-btn search-btn-main modal_open_btn"
				data_modal_target="#userAuthAddModal">
				<svg viewBox="0 0 24 24" fill="none">
					<path d="M12 5V19" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
					<path d="M5 12H19" stroke="currentColor" stroke-width="2"
						stroke-linecap="round"></path>
				</svg>
				신규계정 생성
			</button>

			<button type="button" class="search-btn search-btn-sub"
				onclick="submitUserAuthStatusForm('잠금');">
				선택 잠금
			</button>

			<button type="button" class="search-btn search-btn-sub"
				onclick="submitUserAuthStatusForm('재직');">
				선택 재직
			</button>

		</div>
	</div>


	<%-- =========================================================
	     4. 사용자/권한 목록 테이블

	     PC 8컬럼:
	     1 선택
	     2 로그인 ID/사번
	     3 이름
	     4 부서
	     5 직무
	     6 권한
	     7 상태
	     8 상세

	     모바일 5컬럼:
	     1 선택
	     2 로그인 ID/사번
	     3 이름
	     4 권한
	     5 상세
	     ========================================================= --%>
	<form id="userAuthStatusForm" method="post"
		action="${contextPath}/system/userauth/status">

		<input type="hidden" name="status" id="statusChangeValue" />

		<div class="coTableWrap">
			<table class="coTable user-auth-table" id="userAuthListTable">

				<thead>
					<tr>
						<th class="mobile_show"
							onclick="toggleAllUserAuthCheck();"
							title="전체 선택/해제">선택</th>

						<th class="mobile_show">로그인 ID/사번</th>

						<th class="mobile_show">이름</th>

						<th class="mobile_hidden">부서</th>

						<th class="mobile_hidden">직무</th>

						<th class="mobile_show">권한</th>

						<th class="mobile_hidden">상태</th>

						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty userAuthList}">
							<c:forEach var="userAuth" items="${userAuthList}">

								<tr>
									<td class="mobile_show">
										<input type="checkbox" name="empIdList"
											value="${userAuth.empId}">
									</td>

									<td class="mobile_show" title="${userAuth.empno}">
										${userAuth.empno}
									</td>

									<td class="mobile_show" title="${userAuth.ename}">
										<c:choose>
											<c:when test="${not empty userAuth.ename}">
												${userAuth.ename}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden" title="${userAuth.dept}">
										<c:choose>
											<c:when test="${not empty userAuth.dept}">
												${userAuth.dept}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden" title="${userAuth.job}">
										<c:choose>
											<c:when test="${not empty userAuth.job}">
												${userAuth.job}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show" title="${userAuth.roleName}">
										<c:choose>
											<c:when test="${not empty userAuth.roleName}">
												${userAuth.roleName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden">
										<c:choose>
											<c:when test="${userAuth.status == '재직'}">
												<span class="coStatus coStatusUse">재직</span>
											</c:when>
											<c:when test="${userAuth.status == '잠금'}">
												<span class="coStatus coStatusStop">잠금</span>
											</c:when>
											<c:otherwise>
												<span class="user-auth-status-text">
													${userAuth.status}
												</span>
											</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show">
										<a
											href="${contextPath}/system/userauth/detail?empId=${userAuth.empId}"
											class="coDetailBtn">보기</a>
									</td>
								</tr>

							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">
									조회된 사용자 정보가 없습니다.
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
		<c:set var="pageUrl" value="/system/userauth" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. 신규계정 생성 모달
     ============================================================= --%>
<div id="userAuthAddModal" class="modal_wrap" aria-hidden="true">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">신규계정 생성</h3>
		</div>

		<form id="userAuthAddForm" class="modal_form" method="post"
			action="${contextPath}/system/userauth/add"
			onsubmit="return validateUserAuthAddForm();">

			<div class="modal_body modal_body_2col">

				<div class="modal_item">
					<label class="modal_label">로그인 ID/사번</label>

					<div class="user-auth-empno-box">
						<input type="text" name="empno" id="empno"
							class="modal_input" maxlength="30"
							placeholder="예: E2026013 / 미입력 시 자동생성"
							onblur="checkEmpnoDuplicate();" />

						<button type="button"
							class="search-btn search-btn-main user-auth-small-btn"
							onclick="generateNextEmpno();">
							자동생성
						</button>
					</div>

					<div id="empnoCheckText" class="modal_help_text">
						로그인 ID로 사용할 사번입니다. 미입력 시 서버에서 자동생성합니다.
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						이름 <span class="modal_required">*</span>
					</label>

					<input type="text" name="ename" id="ename"
						class="modal_input" maxlength="50"
						placeholder="이름을 입력하세요." required />
				</div>

				<div class="modal_item">
					<label class="modal_label">부서</label>

					<select name="dept" id="dept" class="modal_select">
						<option value="관리자">관리자</option>
						<option value="생산관리">생산관리</option>
						<option value="품질관리">품질관리</option>
						<option value="설비관리">설비관리</option>
						<option value="작업자">작업자</option>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">직무</label>

					<input type="text" name="job" id="job"
						class="modal_input" maxlength="50"
						placeholder="직무를 입력하세요." />
				</div>

				<div class="modal_item">
					<label class="modal_label">입사일</label>

					<input type="date" name="hireDate" id="hireDate"
						class="modal_input" />
				</div>

				<div class="modal_item">
					<label class="modal_label">전화번호</label>

					<input type="text" name="empTel" id="empTel"
						class="modal_input" maxlength="30"
						placeholder="010-1111-1111"
						onblur="formatPhoneInput('empTel');" />

					<div class="modal_help_text">
						01011111111, 010.1111.1111, 010-1111-1111 입력 가능
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">연락 이메일</label>

					<input type="email" name="email" id="email"
						class="modal_input" maxlength="100"
						placeholder="user@saeroi.co.kr" />

					<div id="emailCheckText" class="modal_help_text">
						로그인 ID가 아니라 연락용 이메일입니다.
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						권한 <span class="modal_required">*</span>
					</label>

					<select name="role" id="role" class="modal_select" required>
						<option value="WORKER">WORKER(작업자)</option>
						<option value="MANAGER">MANAGER(생산관리)</option>
						<option value="QC">QC(품질관리)</option>
						<option value="MAINT">MAINT(설비관리)</option>
						<option value="ADMIN">ADMIN(관리자)</option>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						상태 <span class="modal_required">*</span>
					</label>

					<select name="status" id="status" class="modal_select" required>
						<option value="재직">재직</option>
						<option value="휴직">휴직</option>
						<option value="퇴사">퇴사</option>
						<option value="잠금">잠금</option>
					</select>
				</div>

				<div class="modal_item modal_item_full">
					<div class="modal_help_text">
						신규계정 생성 시 임시비밀번호가 자동 발급됩니다.
						비밀번호는 화면에서 1회만 표시됩니다.
					</div>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button"
					class="modal_btn modal_btn_cancel modal_close_btn">취소</button>

				<button type="submit" class="modal_btn modal_btn_submit">
					생성
				</button>
			</div>

		</form>
	</div>
</div>


<%-- =============================================================
     7. 페이지 전용 최소 스타일
     ============================================================= --%>
<style>
.user-auth-empno-box {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.user-auth-empno-box>input {
	flex: 1 1 auto;
	min-width: 0;
}

.user-auth-small-btn {
	flex: 0 0 auto;
	white-space: nowrap;
}

.modal_help_text {
	margin-top: 6px;
	font-size: 13px;
	color: #666;
	line-height: 1.5;
}

.user-auth-status-text {
	font-size: 13px;
	color: #555;
}
</style>


<%-- =============================================================
     8. 페이지 전용 최소 스크립트
     ============================================================= --%>
<script>
	var contextPath = "${contextPath}";
	var empnoAvailable = true;


	/*
	 * 선택 컬럼명 클릭 시 현재 목록 체크박스 전체 선택/해제
	 */
	function toggleAllUserAuthCheck() {

		var checkList = document.getElementsByName("empIdList");

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
	 * 계정 상태 일괄 변경
	 */
	function submitUserAuthStatusForm(status) {

		var checkList = document.getElementsByName("empIdList");
		var checkedCount = 0;

		for (var i = 0; i < checkList.length; i++) {
			if (checkList[i].checked) {
				checkedCount++;
			}
		}

		if (checkedCount === 0) {
			alert("상태를 변경할 계정을 선택해 주세요.");
			return;
		}

		if (!confirm("선택한 계정을 [" + status + "] 상태로 변경하시겠습니까?")) {
			return;
		}

		document.getElementById("statusChangeValue").value = status;
		document.getElementById("userAuthStatusForm").submit();
	}


	/*
	 * 다음 사번 자동생성
	 */
	function generateNextEmpno() {

		var xhr = new XMLHttpRequest();

		xhr.open("GET", contextPath + "/system/userauth/nextEmpno", true);

		xhr.onreadystatechange = function() {

			if (xhr.readyState !== 4) {
				return;
			}

			if (xhr.status === 200) {

				var nextEmpno = xhr.responseText;

				if (nextEmpno == null || nextEmpno.trim() === "") {
					alert("사번 자동생성 중 오류가 발생했습니다.");
					return;
				}

				document.getElementById("empno").value = nextEmpno.trim();
				empnoAvailable = true;

				document.getElementById("empnoCheckText").innerHTML =
					"자동생성된 로그인 ID/사번입니다.";

				return;
			}

			alert("사번 자동생성 중 오류가 발생했습니다.");
		};

		xhr.send();
	}


	/*
	 * 사번 중복 체크
	 * 로그인 ID는 email이 아니라 empno이다.
	 */
	function checkEmpnoDuplicate() {

		var empnoElement = document.getElementById("empno");
		var empno = empnoElement.value.trim().toUpperCase();

		empnoElement.value = empno;

		if (empno === "") {
			empnoAvailable = true;
			document.getElementById("empnoCheckText").innerHTML =
				"로그인 ID로 사용할 사번입니다. 미입력 시 서버에서 자동생성합니다.";
			return;
		}

		if (!isValidEmpno(empno)) {
			empnoAvailable = false;
			document.getElementById("empnoCheckText").innerHTML =
				"사번 형식이 올바르지 않습니다. 예: E2026013";
			return;
		}

		var xhr = new XMLHttpRequest();

		xhr.open("GET", contextPath
				+ "/system/userauth/checkEmpno?empno="
				+ encodeURIComponent(empno), true);

		xhr.onreadystatechange = function() {

			if (xhr.readyState !== 4) {
				return;
			}

			if (xhr.status === 200) {

				try {
					var result = JSON.parse(xhr.responseText);

					empnoAvailable = result.available;

					document.getElementById("empnoCheckText").innerHTML =
						result.message;

				} catch (e) {
					empnoAvailable = false;
					document.getElementById("empnoCheckText").innerHTML =
						"사번 중복 체크 중 오류가 발생했습니다.";
				}

				return;
			}

			empnoAvailable = false;
			document.getElementById("empnoCheckText").innerHTML =
				"사번 중복 체크 중 오류가 발생했습니다.";
		};

		xhr.send();
	}


	/*
	 * 전화번호 입력값 정리
	 *
	 * 허용:
	 * - 01011111111
	 * - 010.1111.1111
	 * - 010-1111-1111
	 * - 010 1111 1111
	 *
	 * 저장 전 화면 값:
	 * - 010-1111-1111
	 */
	function formatPhoneInput(elementId) {

		var element = document.getElementById(elementId);

		if (element == null || element.value == null) {
			return true;
		}

		var value = element.value.trim();

		if (value === "") {
			return true;
		}

		var onlyNumber = value.replace(/[^0-9]/g, "");

		if (onlyNumber.length === 11) {
			element.value = onlyNumber.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
			return true;
		}

		if (onlyNumber.length === 10) {
			element.value = onlyNumber.replace(/(\d{2,3})(\d{3,4})(\d{4})/, "$1-$2-$3");
			return true;
		}

		alert("전화번호 형식이 올바르지 않습니다. 예: 010-1111-1111");
		element.focus();
		return false;
	}


	/*
	 * 신규계정 생성 검증
	 */
	function validateUserAuthAddForm() {

		var empno = getTrimValue("empno").toUpperCase();
		var ename = getTrimValue("ename");
		var role = getTrimValue("role");
		var status = getTrimValue("status");

		if (empno !== "" && !isValidEmpno(empno)) {
			alert("사번 형식이 올바르지 않습니다. 예: E2026013");
			document.getElementById("empno").focus();
			return false;
		}

		if (empno !== "" && !empnoAvailable) {
			alert("이미 등록된 사번이거나 사번 확인 중 오류가 발생했습니다.");
			document.getElementById("empno").focus();
			return false;
		}

		if (ename === "") {
			alert("이름을 입력해 주세요.");
			document.getElementById("ename").focus();
			return false;
		}

		if (role === "") {
			alert("권한을 선택해 주세요.");
			document.getElementById("role").focus();
			return false;
		}

		if (status === "") {
			alert("상태를 선택해 주세요.");
			document.getElementById("status").focus();
			return false;
		}

		if (!formatPhoneInput("empTel")) {
			return false;
		}

		if (!confirm("신규계정을 생성하시겠습니까?")) {
			return false;
		}

		return true;
	}


	/*
	 * 사번 형식 검증
	 *
	 * 예:
	 * E2026001
	 * E2026013
	 */
	function isValidEmpno(empno) {

		var regex = /^E[0-9]{7}$/;

		return regex.test(empno);
	}


	function getTrimValue(elementId) {

		var element = document.getElementById(elementId);

		if (element == null || element.value == null) {
			return "";
		}

		return element.value.trim();
	}
</script>