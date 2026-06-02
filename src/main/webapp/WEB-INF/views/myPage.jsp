<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<c:set var="user" value="${sessionScope.loginUser}" />

<style>
/* 프로필 카드 */
.mypage_profile_card {
	display: flex;
	align-items: center;
	gap: 18px;
	padding: 18px 24px;
	margin-bottom: 12px;
	background-color: #ffffff;
	border: 1px solid #dfe7e2;
	border-radius: 10px;
}

/* 프로필 이미지 */
.mypage_profile_image {
	width: 88px;
	height: 88px;
	border-radius: 50%;
	object-fit: cover;
	border: 3px solid #eef5f1;
	background-color: #f3f4f6;
}

/* 프로필 정보 */
.mypage_profile_info h3 {
	margin: 0 0 4px;
	font-size: 20px;
	font-weight: 700;
	color: #1f3d34;
}

.mypage_profile_info p {
	margin: 0 0 10px;
	font-size: 14px;
	color: #6b7280;
}


.pw {
    padding-right: 42px !important;
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
}

.pwShow:hover {
	color: #2f7d62;
}
input[type="password"]::-ms-reveal,
input[type="password"]::-ms-clear {
    display: none;
}

input[type="password"]::-webkit-credentials-auto-fill-button,
input[type="password"]::-webkit-password-toggle-button,
input[type="password"]::-webkit-password-reveal-button {
    display: none !important;
    visibility: hidden;
    pointer-events: none;
}

/* 모바일 */
@media screen and (max-width: 768px) {
	.mypage_profile_card {
		flex-direction: column;
		text-align: center;
	}
	.mypage_profile_image {
		width: 96px;
		height: 96px;
	}
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

				수정</button>

			<button type="submit" form="myPageForm" class="detail_btn_green"
				id="saveBtn" style="display: none;">저장</button>

			<button type="button" class="detail_btn_line" id="cancelBtn"
				style="display: none;">취소</button>

		</div>

	</div>

	<form action="${pageContext.request.contextPath}/mypage/update"
		method="post" enctype="multipart/form-data" id="myPageForm">

		<div class="mypage_profile_card">

			<div>

				<img
					src="${empty user.profile_img
						? pageContext.request.contextPath.concat('/resources/upload/profile/default_profile.png')
						: pageContext.request.contextPath.concat('/resources/upload/profile/').concat(user.profile_img)}"
					alt="프로필 이미지" class="mypage_profile_image" id="profilePreview">

			</div>

			<div class="mypage_profile_info">

				<h3>${user.ename}</h3>

				<p>${user.dept}· ${user.job}</p>

				<button type="button" class="detail_btn_line" id="profileEditBtn"
					style="display: none;">사진 변경</button>

				<input type="file" name="profile_img" id="profileFile"
					accept="image/*" style="display: none;">

			</div>

		</div>

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

						<td><c:choose>

								<c:when test="${not empty user.hire_date}">

									<fmt:formatDate value="${user.hire_date}" pattern="yyyy-MM-dd" />

								</c:when>

								<c:otherwise>-</c:otherwise>

							</c:choose></td>

					</tr>

					<tr>

						<th>수정일시</th>

						<td><c:choose>
								<c:when test="${not empty user.updated_date}">

									<fmt:formatDate value="${user.updated_date}"
										pattern="yyyy-MM-dd HH:mm:ss" />

								</c:when>

								<c:otherwise>-</c:otherwise>

							</c:choose></td>

						<th>이메일</th>

						<td><input type="text" name="email"
							class="detail_input editable_field" value="${user.email}"
							readonly></td>

						<th>전화번호</th>

						<td><input type="text" name="emp_tel"
							class="detail_input editable_field" value="${user.emp_tel}"
							readonly></td>

					</tr>

					<tr>

						<th>현재 비밀번호</th>

						<td>

							<div class="pw-box">

								<input type="password" name="emp_pw"
									class="pw detail_input editable_field" readonly>

								<button type="button" class="pwShow">

									<i class="fa-regular fa-eye"></i>

								</button>

							</div>

						</td>

						<th>새 비밀번호</th>

						<td>

							<div class="pw-box">

								<input type="password" name="emp_pw_new"
									class="pw detail_input editable_field" readonly>

								<button type="button" class="pwShow">

									<i class="fa-regular fa-eye"></i>

								</button>

							</div>

						</td>

						<th>비밀번호 확인</th>

						<td>

							<div class="pw-box">

								<input type="password" name="emp_pw_confirm"
									class="pw detail_input editable_field" readonly>

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
		<div style="color: #b91c1c; font-size: 14px;">${errorMsg}</div>
	</c:if>

	<c:if test="${not empty successMsg}">
		<div style="color: #166534; font-size: 14px;">${successMsg}</div>
	</c:if>

</div>

<script>

				(function () {

					const editBtn = document.getElementById('editBtn');
					const saveBtn = document.getElementById('saveBtn');
					const cancelBtn = document.getElementById('cancelBtn');

					const profileEditBtn = document.getElementById('profileEditBtn');
					const profileFile = document.getElementById('profileFile');
					const profilePreview = document.getElementById('profilePreview');

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

							field.style.backgroundColor =
								editing ? '#ffffff' : '#f9fafb';

						});

						profileEditBtn.style.display =
							editing ? 'inline-flex' : 'none';

						editBtn.style.display =
							editing ? 'none' : 'inline-flex';

						saveBtn.style.display =
							editing ? 'inline-flex' : 'none';

						cancelBtn.style.display =
							editing ? 'inline-flex' : 'none';
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

							btn.style.display =
								input.value.length > 0 ? 'block' : 'none';

						});

						btn.addEventListener('click', () => {

							if (input.type === 'password') {

								input.type = 'text';

								icon.classList.replace(
									'fa-eye',
									'fa-eye-slash'
								);

							} else {

								input.type = 'password';

								icon.classList.replace(
									'fa-eye-slash',
									'fa-eye'
								);
							}
						});
					});

					profileEditBtn.addEventListener('click', function () {
						profileFile.click();
					});

					profileFile.addEventListener('change', function (e) {
						const file = e.target.files[0];
						if (!file) return;
						const reader = new FileReader();
						reader.onload = function (event) {
							profilePreview.src = event.target.result;
						};
						reader.readAsDataURL(file);
					});

				})();

			</script>