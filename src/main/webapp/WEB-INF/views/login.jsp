<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>SAEROI - 로그인</title>

    <style>
        /* 대시보드 기반 폰트 및 스타일 초기화 */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        body {
            /* 대시보드 배경과 유사한 은은한 연회색/민트 톤 배경 */
            background: #f4f7f6;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login_area {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }

        .login_area img {
            width: 150px;
            height: auto;
            margin-bottom: 8px;
            object-fit: contain;
        }

        form {
            width: 100%;
            background: #ffffff;
            padding: 40px 30px;
            /* 대시보드 카드의 둥글기 반영 */
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }

        .field {
            margin-bottom: 20px;
        }

        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 8px;
        }

        .field input,
        .pw-box input {
            width: 100%;
            height: 44px;
            font-size: 15px;
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            background-color: #fff;
            color: #1e293b;
            transition: all 0.2s ease;
        }

        /* 대시보드 포인트 컬러(그린)로 포커스 효과 변경 */
        .field input:focus,
        .pw-box input:focus {
            outline: none;
            border-color: #1e6e53;
            box-shadow: 0 0 0 3px rgba(30, 110, 83, 0.12);
        }

        .pw-box {
            position: relative;
            width: 100%;
        }

        input[type="password"]::-ms-reveal,
        input[type="password"]::-ms-clear,
        input[type="password"]::-webkit-password-reveal-button {
            display: none;
        }

        .pwShow {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            cursor: pointer;
            color: #94a3b8;
            font-size: 16px;
            padding: 4px;
            display: none;
            transition: color 0.2s;
        }

        .pwShow:hover {
            color: #1e6e53;
        }

        .auto-login {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            color: #64748b;
            margin: 16px 0 24px 0;
            cursor: pointer;
        }

        .auto-login input[type="checkbox"] {
            cursor: pointer;
            width: 16px;
            height: 16px;
            /* 체크박스 기본 포인트를 브랜드 그린으로 변경 */
            accent-color: #1e6e53;
        }

        /* 대시보드 '로그아웃' 버튼의 묵직한 그린 컬러 수용 */
        .btn {
            width: 100%;
            height: 44px;
            font-size: 15px;
            font-weight: 600;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: #475569;
            cursor: pointer;
            border-radius: 6px;
            transition: all 0.2s ease-in-out;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .btn:hover {
            background: #f8fafc;
            border-color: #94a3b8;
        }

        /* 메인 로그인 버튼 스타일 (#1e6e53) */
        .btn.primary-btn {
            background: #1e6e53;
            color: #ffffff;
            border: none;
            margin-bottom: 10px;
        }

        .btn.primary-btn:hover {
            background: #16533f;
        }

        /* 에러 메시지 스타일 부드럽게 조정 */
        .error {
            color: #df473c;
            background: #fff5f5;
            border: 1px solid #fecaca;
            padding: 11px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
        }

        /* 모달 스타일 메인 톤 일치화 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.3);
            backdrop-filter: blur(4px);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-box {
            width: 90%;
            max-width: 400px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
            border: 1px solid #e2e8f0;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
        }

        .modal-header h3 {
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
        }

        .modal-body {
            padding: 24px;
        }

        .form-row {
            margin-bottom: 16px;
        }

        .form-row label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 8px;
        }

        .form-row input {
            width: 100%;
            height: 40px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 14px;
        }

        .form-row input:focus {
            outline: none;
            border-color: #1e6e53;
            box-shadow: 0 0 0 3px rgba(30, 110, 83, 0.12);
        }

        .modal-msg {
            font-size: 13px;
            margin-top: 10px;
            min-height: 18px;
        }

        .modal-footer {
            padding: 16px 24px;
            background: #f8fafc;
            border-top: 1px solid #f1f5f9;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        .modal-footer .btn {
            width: auto;
            min-width: 80px;
            height: 38px;
            font-size: 14px;
            padding: 0 16px;
        }
        
        .modal-footer .btn.primary {
            background: #1e6e53;
            color: #fff;
            border: none;
        }
        .modal-footer .btn.primary:hover {
            background: #16533f;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>
    <div class="login_area">
        <img src="${pageContext.request.contextPath}/resources/saeroi_logo.png" alt="SAEROI Logo">
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="field">
                <label>사원번호</label> 
                <input type="text" name="empno" placeholder="사원번호를 입력하세요" required>
            </div>

            <div class="field">
                <label>비밀번호</label>
                <div class="pw-box">
                    <input type="password" class="pw" name="pw" placeholder="비밀번호를 입력하세요" required>
                    <button type="button" class="pwShow" onclick="togglePassword()">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>
            </div>

            <c:if test="${not empty errorMsg}">
                <div class="error">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right: 8px;"></i>
                    ${errorMsg}
                </div>
            </c:if>

            <label class="auto-login">
                <input type="checkbox" name="autoLogin" value="Y"> 자동 로그인
            </label>

            <button class="btn primary-btn" type="submit">로그인</button>
            <button class="btn" type="button" onclick="openModal()">비밀번호 찾기</button>
        </form>

        <div class="modal-overlay" id="pwModal">
            <div class="modal-box">
                <div class="modal-header">
                    <h3>비밀번호 찾기</h3>
                </div>

                <div class="modal-body">
                    <div class="form-row">
                        <label>사원번호</label> 
                        <input type="text" id="find_empno" name="empno" placeholder="사원번호 입력">
                    </div>

                    <div class="form-row">
                        <label>이메일</label> 
                        <input type="email" id="find_email" name="email" placeholder="이메일 주소 입력">
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
            const icon = show.querySelector("i");
            if (pw.type === "password") {
                pw.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                pw.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        function openModal() {
            document.getElementById("pwModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("pwModal").style.display = "none";
            document.getElementById("find_empno").value = "";
            document.getElementById("find_email").value = "";
            document.getElementById("modalMsg").textContent = "";
        }

        function findPassword() {
            const empno = document.getElementById("find_empno").value;
            const email = document.getElementById("find_email").value;
            const msg = document.getElementById("modalMsg");

            if (!empno || !email) {
                msg.style.color = "#df473c";
                msg.innerHTML = "<i class='fa-solid fa-circle-exclamation'></i> 사원번호와 이메일을 입력하세요.";
                return;
            }
            
            fetch("${pageContext.request.contextPath}/find_pw", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ empno: empno, email: email })
            })
            .then(res => res.json())
            .then(data => {
                msg.style.color = data.success ? "#1e6e53" : "#df473c";
                msg.textContent = data.message;
            })
            .catch(() => {
                msg.style.color = "#df473c";
                msg.textContent = "서버 오류가 발생했습니다.";
            });
        }
    </script>
</body>

</html>