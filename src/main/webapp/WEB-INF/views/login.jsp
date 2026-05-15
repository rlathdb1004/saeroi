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
}

.login_area {
	width: 100vw;
	height: 100vh;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	font-size: 24px;
}

.field {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 15px;
}

label {
	width: 120px;
	text-align: right;
}

input {
	height: 32px;
	font-size: 18px;
	padding: 4px 8px;
}

button {
	margin-top: 20px;
	font-size: 20px;
	padding: 8px 16px;
	cursor: pointer;
}
.pw-wrap {
    position: relative;
    width: 300px;
}

.pw-wrap input {
    width: 100%;
    height: 40px;
    padding-right: 40px; 
    font-size: 16px;
}

.pwShow {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    cursor: pointer;
    font-size: 16px;
}
</style>

</head>
<body>
	<div class="login_area">
		<img
			src="${pageContext.request.contextPath}/resources/saeroi_logo.png">

		<c:if test="${not empty errorMsg}">
			<div class="error">${errorMsg}</div>
		</c:if>
		<form action="${pageContext.request.contextPath}/login" method="post">
			<div class="field">
				<label>사원번호</label> <input type="text" name="emp_no"
					placeholder="사원번호" required>
			</div>
			<div class="field pw-wrap">
				<input type="password" class="pw" name="pw" placeholder="비밀번호">
				<button type="button" class="pwShow" onclick="togglePassword()">👁</button>
			</div>

			<div>
				<input type="checkbox"> 자동 로그인
			</div>

			<button class="btn primary-btn" type="submit">로그인</button>
			<button class="btn" type="button">비밀번호 찾기</button>

		</form>
	</div>

	<script>
		function togglePassword() {
			const pw = document.querySelector(".pw")
			const show = document.querySelector(".pwShow")

			if (pw.type === "password") {
				pw.type = "text"				
			} else {
				pw.type = "password"				
			}
		}
	</script>
</body>
</html>
