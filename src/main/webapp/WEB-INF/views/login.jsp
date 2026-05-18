<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>로그인</title>

<style>
body {
	margin: 0;
	background: #f5f6f8;
}

.login_area {
	width: 100vw;
	height: 100vh;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	gap: 14px;
}

.login_area img {
	width: 180px;
	margin-bottom: 25px;
}

form {
	width: 340px;
	background: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
}

.field {
	display: flex;
	align-items: center;
	margin-bottom: 14px;
}

.field label {
	width: 90px;
	font-size: 14px;
	color: #333;
}

.field input, .pw-box input {
	width: 100%;
	height: 38px;
	font-size: 16px;
	padding: 4px 8px;
	border: 1px solid #ccc;
	border-radius: 4px;
	box-sizing: border-box;
}

.field input, .pw-box {
	flex: 1;
}

.pw-box {
	position: relative;
}

/* 브라우저 기본 눈 사용 막기 */
input[type="password"]::-ms-reveal {
	display: none;
}
input[type="password"]::-ms-clear {
	display: none;
}
input[type="password"]::-webkit-password-reveal-button {
	display: none;
}

.pwShow {
	position: absolute;
	right: 8px;
	top: 50%;
	transform: translateY(-50%);
	border: none;
	background: none;
	cursor: pointer;
	font-size: 12px;
	color: #007bff;
	display: none;
}

.auto-login {
	font-size: 13px;
	margin: 10px 0;
}

.btn {
	width: 100%;
	padding: 10px;
	margin-top: 8px;
	border: 1px solid #ccc;
	background: #fff;
	cursor: pointer;
	border-radius: 4px;
}

.btn.primary-btn {
	background: #2f6fed;
	color: #fff;
	border: none;
}

.error {
	color: #d93025;
	font-size: 13px;
	margin-bottom: 10px;
}

.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	background: rgba(0, 0, 0, 0.4);
	justify-content: center;
	align-items: center;
}

.modal-box {
	width: 400px;
	background: #fff;
	border-radius: 8px;
	overflow: hidden;
}

.modal-header, .modal-footer {
	padding: 12px;
	border-bottom: 1px solid #eee;
}

.modal-footer {
	border-top: 1px solid #eee;
	border-bottom: none;
	display: flex;
	justify-content: flex-end;
	gap: 8px;
}

.modal-body {
	padding: 15px;
}

.form-row {
	display: flex;
	margin-bottom: 10px;
}

.form-row label {
	width: 80px;
	font-size: 13px;
}

.form-row input {
	flex: 1;
	height: 34px;
	border: 1px solid #ccc;
	border-radius: 4px;
	padding: 4px;
}

.modal-msg {
	font-size: 12px;
	color: #2f6fed;
}
</style>

</head>

<body>
	<div class="login_area">

		<img
			src="${pageContext.request.contextPath}/resources/saeroi_logo.png">

		<form action="${pageContext.request.contextPath}/login" method="post">

			<div class="field">
				<label>사원번호</label> <input type="text" name="empno"
					placeholder="사원번호" required>
			</div>

			<div class="field">
				<label>비밀번호</label>

				<div class="pw-box">
					<input type="password" class="pw" name="pw" placeholder="비밀번호">
					<button type="button" class="pwShow" onclick="togglePassword()">보기</button>
				</div>
			</div>

			<c:if test="${not empty errorMsg}">
				<div class="error">${errorMsg}</div>
			</c:if>

			<div class="auto-login">
				<input type="checkbox" name="autoLogin" value="Y"> 자동 로그인
			</div>

			<button class="btn primary-btn" type="submit">로그인</button>
			<button class="btn" type="button" onclick="openModal()">비밀번호
				찾기</button>

		</form>

		<!-- modal -->
		<div class="modal-overlay" id="pwModal">
			<div class="modal-box">
				<div class="modal-header">
					<h3>비밀번호 찾기</h3>
				</div>

				<div class="modal-body">
					<div class="form-row">
						<label>사원번호</label> <input type="text" id="find_empno"
							name="empno">
					</div>

					<div class="form-row">
						<label>이메일</label> <input type="email" id="find_email"
							name="email">
					</div>

					<div class="modal-msg" id="modalMsg"></div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn" onclick="closeModal()">취소</button>
					<button type="button" class="btn primary" onclick="findPassword()">발송</button>
				</div>

			</div>
		</div>
	</div>

	<script>

				const pw = document.querySelector(".pw");
				const show = document.querySelector(".pwShow");

				pw.addEventListener("input", () => {
					show.style.display = pw.value.length > 0 ? "block" : "none";
				});

				function togglePassword() {
					if (pw.type === "password") {
						pw.type = "text";
						show.textContent = "숨기기";
					} else {
						pw.type = "password";
						show.textContent = "보기";
					}
				}

				function openModal() {
					document.getElementById("pwModal").style.display = "flex"
				}

				function closeModal() {
					document.getElementById("pwModal").style.display = "none"
					document.getElementById("find_empno").value = ""
					document.getElementById("find_email").value = ""
					document.getElementById("modalMsg").textContent = ""
				}

				function findPassword() {
					const empno = document.getElementById("find_empno").value
					const email = document.getElementById("find_email").value
					const msg = document.getElementById("modalMsg")

					if (!empno || !email) {
						msg.style.color = "#d93025";
						msg.textContent = "사원번호와 이메일을 입력하세요.";
						return;
					}
					fetch("${pageContext.request.contextPath}/find_pw", {
						method: "POST",
						headers: {
							"Content-Type": "application/json"
						},
						body: JSON.stringify({
							empno: empno,
							email: email
						})
					})
						.then(res => res.json())
						.then(data => {

							msg.style.color = data.success ? "#2f6fed" : "red";
							msg.textContent = data.message;
						})
						.catch(() => {
							msg.style.color = "red";
							msg.textContent = "서버 오류가 발생했습니다.";
						});
				}
			</script>
</body>

</html>