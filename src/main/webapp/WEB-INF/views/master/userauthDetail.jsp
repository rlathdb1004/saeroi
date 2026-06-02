<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: userauthDetail.jsp
	메뉴: 기준정보관리 > 사용자/권한관리 > 사용자 상세

	기준:
	- URL: /system/userauth/detail
	- Controller return: master/userauthDetail.tiles
	- JSP 위치: /WEB-INF/views/master/userauthDetail.jsp
	- emp 테이블 기준
	- 로그인 ID는 emp.empno 사번 사용
	- email은 로그인 ID가 아니라 연락용 이메일
	- 권한은 emp.role 그대로 사용
	- 숫자 role_level 사용 안 함
	- 기본 상태: 읽기 전용
	- 수정 클릭 후: 저장 / 취소 / 목록
	- 임시비밀번호 발급 기능 제공
	- 실제 DELETE 없음
	- 계정 사용 여부는 status로 관리: 재직, 휴직, 퇴사, 잠금
	- 전화번호는 입력은 유연하게 받고 저장 전 010-1111-1111 형식으로 정리
	- 공용 detail.css 클래스명 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${not empty userAuthDetail.hireDate}">
	<fmt:formatDate var="hireDateValue"
		value="${userAuthDetail.hireDate}" pattern="yyyy-MM-dd" />
</c:if>

<c:if test="${not empty userAuthDetail.createdDate}">
	<fmt:formatDate var="createdDateValue"
		value="${userAuthDetail.createdDate}" pattern="yyyy-MM-dd" />
</c:if>

<c:if test="${not empty userAuthDetail.updatedDate}">
	<fmt:formatDate var="updatedDateValue"
		value="${userAuthDetail.updatedDate}" pattern="yyyy-MM-dd" />
</c:if>

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">사용자/권한 상세</h2>
			<div class="detail_path">기준정보관리 &gt; 사용자/권한관리 &gt; 사용자 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty userAuthDetail}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="userAuthModifyForm" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>
					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="location.reload();" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

<!-- 				<button type="submit" -->
<!-- 					class="detail_btn_line user-auth-reset-pw-btn" -->
<!-- 					form="resetPwForm" -->
<!-- 					onclick="return confirmResetPassword();"> -->
<!-- 					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true"> -->
<!-- 						<path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.78 7.78 5.5 5.5 0 0 1 7.78-7.78z"></path> -->
<!-- 						<path d="M15 7l3 3"></path> -->
<!-- 						<path d="M9 15h.01"></path> -->
<!-- 					</svg> -->
<!-- 					임시비밀번호 발급 -->
<!-- 				</button> -->

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/system/userauth'">
				<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
					<path d="M8 6h13"></path>
					<path d="M8 12h13"></path>
					<path d="M8 18h13"></path>
					<path d="M3 6h.01"></path>
					<path d="M3 12h.01"></path>
					<path d="M3 18h.01"></path>
				</svg>
				목록
			</button>

		</div>
	</div>


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


	<c:choose>

		<c:when test="${not empty userAuthDetail}">

			<form id="userAuthModifyForm"
				action="${contextPath}/system/userauth/modify" method="post"
				accept-charset="UTF-8"
				onsubmit="return validateUserAuthModifyForm();">

				<input type="hidden" name="empId" value="${userAuthDetail.empId}" />

				<div class="detail_card">

					<div class="detail_card_title">계정 기본 정보</div>

					<table class="detail_info_table userauth_detail_table">
						<tbody>

							<tr>
								<th>사원 ID</th>
								<td>${userAuthDetail.empId}</td>

								<th>로그인 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty userAuthDetail.empno}">
											${userAuthDetail.empno}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>이름</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty userAuthDetail.ename}">
												${userAuthDetail.ename}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="ename" id="ename"
											class="detail_input"
											value="${userAuthDetail.ename}"
											maxlength="50"
											data-edit-control disabled required />
									</div>
								</td>
							</tr>


							<tr>
								<th>부서</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty userAuthDetail.dept}">
												${userAuthDetail.dept}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="dept" id="dept" class="detail_select"
											data-edit-control disabled>
											<option value="관리자"
												<c:if test="${userAuthDetail.dept == '관리자'}">selected</c:if>>
												관리자
											</option>
											<option value="생산관리"
												<c:if test="${userAuthDetail.dept == '생산관리'}">selected</c:if>>
												생산관리
											</option>
											<option value="품질관리"
												<c:if test="${userAuthDetail.dept == '품질관리'}">selected</c:if>>
												품질관리
											</option>
											<option value="설비관리"
												<c:if test="${userAuthDetail.dept == '설비관리'}">selected</c:if>>
												설비관리
											</option>
											<option value="작업자"
												<c:if test="${userAuthDetail.dept == '작업자'}">selected</c:if>>
												작업자
											</option>
										</select>
									</div>
								</td>

								<th>직무</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty userAuthDetail.job}">
												${userAuthDetail.job}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="job" id="job"
											class="detail_input"
											value="${userAuthDetail.job}"
											maxlength="50"
											data-edit-control disabled />
									</div>
								</td>

								<th>입사일</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty hireDateValue}">
												${hireDateValue}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="date" name="hireDate" id="hireDate"
											class="detail_input"
											value="${hireDateValue}"
											data-edit-control disabled />
									</div>
								</td>
							</tr>


							<tr>
								<th>전화번호</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty userAuthDetail.empTel}">
												${userAuthDetail.empTel}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="empTel" id="empTel"
											class="detail_input"
											value="${userAuthDetail.empTel}"
											maxlength="30"
											placeholder="010-1111-1111"
											onblur="formatPhoneInput('empTel');"
											data-edit-control disabled />

										<div class="detail_help_text">
											01011111111, 010.1111.1111, 010-1111-1111 입력 가능
										</div>
									</div>
								</td>

								<th>이메일</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty userAuthDetail.email}">
												${userAuthDetail.email}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="email" name="email" id="email"
											class="detail_input"
											value="${userAuthDetail.email}"
											maxlength="100"
											placeholder="user@saeroi.co.kr"
											data-edit-control disabled />

										<div class="detail_help_text">
											로그인 ID가 아니라 연락용 이메일입니다.
										</div>
									</div>
								</td>

								<th>상태</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${userAuthDetail.status == '재직'}">
												<span class="detail_status_badge detail_status_pass">재직</span>
											</c:when>
											<c:when test="${userAuthDetail.status == '잠금'}">
												<span class="detail_status_badge detail_status_fail">잠금</span>
											</c:when>
											<c:otherwise>
												${userAuthDetail.status}
											</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="status" id="status" class="detail_select"
											data-edit-control disabled>
											<option value="재직"
												<c:if test="${userAuthDetail.status == '재직'}">selected</c:if>>
												재직
											</option>
											<option value="휴직"
												<c:if test="${userAuthDetail.status == '휴직'}">selected</c:if>>
												휴직
											</option>
											<option value="퇴사"
												<c:if test="${userAuthDetail.status == '퇴사'}">selected</c:if>>
												퇴사
											</option>
											<option value="잠금"
												<c:if test="${userAuthDetail.status == '잠금'}">selected</c:if>>
												잠금
											</option>
										</select>
									</div>
								</td>
							</tr>


							<tr>
								<th>권한</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty userAuthDetail.roleName}">
												${userAuthDetail.roleName}
											</c:when>
											<c:otherwise>
												${userAuthDetail.role}
											</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="role" id="role" class="detail_select"
											data-edit-control disabled required>
											<option value="WORKER"
												<c:if test="${userAuthDetail.role == 'WORKER'}">selected</c:if>>
												WORKER(작업자)
											</option>
											<option value="MANAGER"
												<c:if test="${userAuthDetail.role == 'MANAGER'}">selected</c:if>>
												MANAGER(생산관리)
											</option>
											<option value="QC"
												<c:if test="${userAuthDetail.role == 'QC'}">selected</c:if>>
												QC(품질관리)
											</option>
											<option value="MAINT"
												<c:if test="${userAuthDetail.role == 'MAINT'}">selected</c:if>>
												MAINT(설비관리)
											</option>
											<option value="ADMIN"
												<c:if test="${userAuthDetail.role == 'ADMIN'}">selected</c:if>>
												ADMIN(관리자)
											</option>
										</select>
									</div>
								</td>

								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty createdDateValue}">
											${createdDateValue}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty updatedDateValue}">
											${updatedDateValue}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="detail_help_text">
						로그인 ID는 사번입니다. 비밀번호는 직접 조회하거나 수정하지 않고, 필요 시 임시비밀번호를 발급하세요.
					</div>

				</div>

			</form>


			<form id="resetPwForm"
				action="${contextPath}/system/userauth/resetPw"
				method="post">
				<input type="hidden" name="empId" value="${userAuthDetail.empId}" />
			</form>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 사용자 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
.user-auth-reset-pw-btn {
	min-width: 160px;
	white-space: nowrap;
	justify-content: center;
}

/* 사용자/권한 상세 전용: 3쌍(th+td) 테이블 폭 넘침 방지 */
.userauth_detail_table {
	width: 100%;
	table-layout: fixed;
}

.userauth_detail_table th {
	width: 9%;
	white-space: nowrap;
}

.userauth_detail_table td {
	width: 24.3%;
	min-width: 0;
	vertical-align: middle;
	word-break: break-all;
}

.userauth_detail_table .detail_input,
.userauth_detail_table .detail_select,
.userauth_detail_table input,
.userauth_detail_table select {
	width: 100%;
	max-width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.userauth_detail_table .detail_help_text {
	margin-top: 6px;
	white-space: normal;
	word-break: keep-all;
	line-height: 1.4;
}
</style>


<script>
	/*
	 * 상세 수정 모드 전환
	 */
	function changeEditMode(isEdit) {

		var viewValueList = document.querySelectorAll("[data-view-value]");
		var editBoxList = document.querySelectorAll("[data-edit-box]");
		var editControlList = document.querySelectorAll("[data-edit-control]");

		for (var i = 0; i < viewValueList.length; i++) {
			viewValueList[i].style.display = isEdit ? "none" : "";
		}

		for (var j = 0; j < editBoxList.length; j++) {
			editBoxList[j].style.display = isEdit ? "block" : "none";
		}

		for (var k = 0; k < editControlList.length; k++) {
			editControlList[k].disabled = !isEdit;
		}

		document.getElementById("editBtn").style.display =
			isEdit ? "none" : "inline-flex";

		document.getElementById("saveBtn").style.display =
			isEdit ? "inline-flex" : "none";

		document.getElementById("cancelBtn").style.display =
			isEdit ? "inline-flex" : "none";
	}


	/*
	 * 임시비밀번호 발급 확인
	 */
	function confirmResetPassword() {

		return confirm("임시비밀번호를 발급하시겠습니까?\n기존 비밀번호는 더 이상 사용할 수 없습니다.");
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
	 * 수정 검증
	 */
	function validateUserAuthModifyForm() {

		var ename = document.getElementById("ename").value.trim();
		var role = document.getElementById("role").value.trim();
		var status = document.getElementById("status").value.trim();

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

		if (!confirm("사용자 정보를 수정하시겠습니까?")) {
			return false;
		}

		return true;
	}
</script>