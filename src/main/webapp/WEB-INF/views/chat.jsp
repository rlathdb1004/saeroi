<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
/* 1. 챗봇 플로팅 버튼 (화면 우측 하단 고정) */
#chatbot-launcher {
	position: fixed;
	bottom: 30px;
	left: 30px;
	width: 60px;
	height: 60px;
	background-color: #2f7d62;
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 26px;
	cursor: pointer;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
	transition: transform 0.3s ease, background-color 0.3s ease;
	z-index: 1000;
}

#chatbot-launcher:hover {
	transform: scale(1.1);
	background-color: #357ABD;
}

/* 2. 챗봇 채팅창 전체 컨테이너 */
#chatbot-container {
	position: fixed;
	bottom: 100px;
	right: 30px;
	width: 96%;
	height: 88%;
	background-color: #2f7d62;
	border-radius: 16px;
	box-shadow: 0 5px 25px rgba(0, 0, 0, 0.15);
	display: flex;
	flex-direction: column;
	overflow: hidden;
	z-index: 1000;
	/* 시작할 때 숨김 및 올라오는 애니메이션 설정 */
	opacity: 0;
	transform: translateY(20px) scale(0.95);
	pointer-events: none;
	transition: all 0.3s ease;
}

/* 활성화 되었을 때 클래스 */
#chatbot-container.active {
	opacity: 1;
	transform: translateY(0) scale(1);
	pointer-events: auto;
}

/* 3. 챗봇 헤더 */
.chatbot-header {
	background-color: #2f7d62;
	color: white;
	padding: 15px 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-weight: bold;
	font-size: 16px;
}

.chatbot-header .close-btn {
	cursor: pointer;
	font-size: 18px;
	opacity: 0.8;
	transition: opacity 0.2s;
}

.chatbot-header .close-btn:hover {
	opacity: 1;
}

/* 4. 대화창 내용 영역 */
#chat-content {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
	background-color: #f5f7fb;
	display: flex;
	flex-direction: column;
	gap: 12px;
}

/* 말풍선 공통 스타일 */
.message-bubble {
	max-width: 75%;
	padding: 10px 14px;
	border-radius: 14px;
	font-size: 14px;
	line-height: 1.5;
	word-break: break-all;
	white-space: pre-line;
}
/* 유저 말풍선 */
.message-bubble.user {
	background-color: #ffffff;
	color: #333333;
	align-self: flex-end;
	border-bottom-right-radius: 2px;
}
/* AI 말풍선 */
.message-bubble.ai {
	background-color: #ffffff;
	color: #333333;
	align-self: flex-start;
	border-bottom-left-radius: 2px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

/* 5. 하단 입력창 영역 */
.chatbot-footer {
	display: flex;
	padding: 15px;
	background-color: #ffffff;
	border-top: 1px solid #eeeeee;
	gap: 8px;
}

#prompt {
	flex: 1;
	border: 1px solid #dddddd;
	border-radius: 20px;
	padding: 10px 15px;
	outline: none;
	font-size: 14px;
	transition: border-color 0.2s;
}

#prompt:focus {
	border-color: #2f7d62;
}

#btn {
	background-color: #2f7d62;
	color: white;
	border: none;
	border-radius: 50%;
	width: 38px;
	height: 38px;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 16px;
	transition: background-color 0.2s;
}

#btn:hover {
	background-color: #357ABD;
}
</style>



<div id="chatbot-launcher" id="open-chatbot">
	<i class="fa-solid fa-comments"></i>
</div>

<div id="chatbot-container">
	<div class="chatbot-header">
		<span><i class="fa-solid fa-robot"></i> 새로이봇</span>
		<div class="close-btn" id="close-chatbot">
			<i class="fa-solid fa-xmark"></i>
		</div>
	</div>

	<div id="chat-content">
		<div class="message-bubble ai">안녕하세요! 새로이봇입니다. 무엇을 도와드릴까요?</div>
	</div>

	<div class="chatbot-footer">
		<input id="prompt" type="text" name="prompt"
			placeholder="메시지를 입력하세요..." autocomplete="off">
		<button id="btn" type="button">
			<i class="fa-solid fa-paper-plane"></i>
		</button>
	</div>
</div>
<script>
	
	const btn500 = document.querySelector('#btn500');
	const launcher = document.querySelector('#chatbot-launcher');
    const container = document.querySelector('#chatbot-container');
    const closeBtn = document.querySelector('#close-chatbot');
    const promptInput = document.querySelector('#prompt');
    const chat = document.querySelector('#chat-content');

    launcher.addEventListener('click', () => {
        container.classList.add('active');
        launcher.style.display = 'none'; // 창이 열리면 아이콘은 잠시 숨김
        promptInput.focus();
    });

    closeBtn.addEventListener('click', () => {
        container.classList.remove('active');
        launcher.style.display = 'flex'; // 창이 닫히면 아이콘 다시 표시
    });
	let param = [];
	
		
		 async function message(){
				let prompt = document.querySelector('#prompt');
				let url = contextPath + "/gemini";
				
				let promptValue = prompt.value.trim();
				if (!promptValue) return
				console.log(promptValue)
				
				chat.innerHTML +="<div class='message-bubble user'>" + promptValue + "</div>";
				chat.scrollTop = chat.scrollHeight;
				
				
				param.push({ role:"user",text:promptValue});
				prompt.value='';
				
				let option = {
					method:"POST",
					headers:{
						'Content-Type':'application/json'
					},
					body:JSON.stringify(param)	
				}
				let response = await fetch(url,option);
				let data = await response.text()
// 				let data = JSON.parse(text)
// 				let aiResponse = data.candidates[0].content.parts[0].text;
				
				chat.innerHTML += "<div class='message-bubble ai'>" + data + "</div>";;
				chat.scrollTop = chat.scrollHeight;
				
				
		}
		
		document.querySelector('#btn').addEventListener('click', message);
		
		document.querySelector('#prompt').addEventListener('keyup',function(e){
			if (e.isComposing) return;
			
			if(e.key === 'Enter'){
				message();
			}
		})
			
		
	</script>