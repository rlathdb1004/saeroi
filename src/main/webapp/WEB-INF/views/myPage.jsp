<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/detail.css">

			<c:set var="user" value="${sessionScope.loginUser}" />

			<style>
				.mypage_input {
					width: 100%;
					height: 38px;
					padding: 0 12px;
					border: 1px solid #d1d5db;
					border-radius: 6px;
					box-sizing: border-box;
					font-size: 14px;
					background-color: #f9fafb;
				}

				.mypage_input:focus {
					outline: none;
					border-color: #2f7d62;
					background-color: #ffffff;
				}

				.mypage_input[readonly] {
					background-color: #f9fafb;
					color: #4b5563;
					cursor: default;
				}

				.pw-box {
					position: relative;
					width: 100%;
				}

				.pwShow {
					position: absolute;
					right: 12px;
					top: 50%;
					transform: translateY(-50%);
					border: none;
					background: transparent;
					cursor: pointer;
					color: #94a3b8;
					font-size: 15px;
					padding: 4px;
					display: none;
					transition: color 0.2s;
				}

				.pwShow:hover {
					color: #2f7d62;
				}

				input[type="password"]::-ms-reveal,
				input[type="password"]::-ms-clear,
				input[type="password"]::-webkit-password-reveal-button {
					display: none;
				}
			</style>

			<div class="detail_page">
				<div class="detail_header">

					<div>
						<h2 class="detail_title">마이페이지</h2>

						<div class="detail_path">마이페이지 &gt; 내 정보 조회</div>
					</div>

					<div class="detail_btn_area">

						<button type="button" class="detail_btn_green" id="editBtn">
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
								<path d="M12 20h9"></path>
								<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
							</svg>
							수정
						</button>

						<button type="submit" form="myPageForm" class="detail_btn_green" id="saveBtn"
							style="display: none;">
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
								<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
								<path d="M17 21v-8H7v8"></path>
								<path d="M7 3v5h8"></path>
							</svg>
							저장
						</button>

						<button type="button" class="detail_btn_line" id="cancelBtn" style="display: none;">
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
								<path d="M18 6L6 18"></path>
								<path d="M6 6l12 12"></path>
							</svg>
							취소
						</button>

					</div>

				</div>


				<form action="${pageContext.request.contextPath}/mypage/update" method="post" id="myPageForm">

					<div class="detail_card">
						<table class="detail_info_table">
							<colgroup>
								<col style="width: 12%;">
								<col style="width: 21%;">
								<col style="width: 12%;">
								<col style="width: 21%;">
								<col style="width: 12%;">
								<col style="width: 22%;">
							</colgroup>

							<tbody>

								<tr>
									<th>사번</th>
									<td>${user.empno}</td>

									<th>이름</th>
									<td>${user.ename}</td>

									<th>부서</th>
									<td>${user.dept}</td>
								</tr>

								<tr>
									<th>직급</th>
									<td>${user.job}</td>

									<th>상태</th>
									<td><span class="detail_status_badge detail_status_pass">
											${user.status} </span></td>

									<th>입사일자</th>
									<td>
										<c:choose>
											<c:when test="${not empty user.hire_date}">
												<fmt:formatDate value="${user.hire_date}" pattern="yyyy-MM-dd" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<tr>
									<th>수정일시</th>
									<td>
										<c:choose>
											<c:when test="${not empty user.updated_date}">
												<fmt:formatDate value="${user.updated_date}"
													pattern="yyyy-MM-dd HH:mm:ss" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<th>이메일</th>
									<td><input type="text" name="email" class="mypage_input editable_field"
											value="${user.email}" readonly></td>

									<th>전화번호</th>
									<td><input type="text" name="emp_tel" class="mypage_input editable_field"
											value="${user.emp_tel}" readonly></td>
								</tr>

								<tr>
									<th>현재 비밀번호</th>
									<td>
										<div class="pw-box">
											<input type="password" name="emp_pw" class="pw mypage_input editable_field"
												readonly>

											<button type="button" class="pwShow">
												<i class="fa-regular fa-eye"></i>
											</button>
										</div>
									</td>

									<th>새 비밀번호</th>
									<td>
										<div class="pw-box">
											<input type="password" name="emp_pw_new"
												class="pw mypage_input editable_field" readonly>

											<button type="button" class="pwShow">
												<i class="fa-regular fa-eye"></i>
											</button>
										</div>
									</td>

									<th>비밀번호 확인</th>
									<td>
										<div class="pw-box">
											<input type="password" name="emp_pw_confirm"
												class="pw mypage_input editable_field" readonly>

											<button type="button" class="pwShow">
												<i class="fa-regular fa-eye"></i>
											</button>
										</div>
									</td>
								</tr>

							</tbody>
						</table>

					</div>

				</form>
				<c:if test="${not empty errorMsg}">
					<div style="color: #b91c1c; font-size: 14px;">
						${errorMsg}</div>
				</c:if>

				<c:if test="${not empty successMsg}">
					<div style="color: #166534; font-size: 14px;">
						${successMsg}</div>
				</c:if>

			</div>

			<script>
				(function () {

					const editBtn = document.getElementById('editBtn');
					const saveBtn = document.getElementById('saveBtn');
					const cancelBtn = document.getElementById('cancelBtn');

					const editableFields = document.querySelectorAll('.editable_field');

					const originalValues = {};

					function saveOriginalValues() {

						editableFields.forEach(function (field) {
							originalValues[field.name] = field.value;
						});
					}

					function setEditMode(editing) {

						editableFields.forEach(function (field) {

							field.readOnly = !editing;

							if (editing) {
								field.style.backgroundColor = '#ffffff';
							} else {
								field.style.backgroundColor = '#f9fafb';
							}
						});

						editBtn.style.display = editing ? 'none' : 'inline-flex';
						saveBtn.style.display = editing ? 'inline-flex' : 'none';
						cancelBtn.style.display = editing ? 'inline-flex' : 'none';
					}

					function restoreValues() {

						editableFields.forEach(function (field) {
							field.value = originalValues[field.name];
						});
					}

					editBtn.addEventListener('click', function () {

						setEditMode(true);

						if (editableFields.length > 0) {
							editableFields[0].focus();
						}
					});

					cancelBtn.addEventListener('click', function () {

						restoreValues();

						document.querySelectorAll('.pw-box').forEach(box => {

							const input = box.querySelector('input');
							const btn = box.querySelector('.pwShow');
							const icon = btn.querySelector('i');

							input.type = 'password';

							btn.style.display = 'none';

							icon.classList.remove('fa-eye-slash');
							icon.classList.add('fa-eye');
						});
						setEditMode(false);
					});

					saveOriginalValues();
					setEditMode(false);

					document.querySelectorAll('.pw-box').forEach(box => {

						const input = box.querySelector('input');
						const btn = box.querySelector('.pwShow');
						const icon = btn.querySelector('i');

						input.addEventListener('input', () => {
							btn.style.display = input.value.length > 0 ? 'block' : 'none';
						});

						btn.addEventListener('click', () => {

							if (input.type === 'password') {

								input.type = 'text';
								icon.classList.replace('fa-eye', 'fa-eye-slash');

							} else {

								input.type = 'password';
								icon.classList.replace('fa-eye-slash', 'fa-eye');
							}
						});
					});

				})();
			</script>