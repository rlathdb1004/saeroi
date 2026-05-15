<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<input id="prompt" type="text" name="prompt">
	<button id="btn" type="button" > 전송 </button>
	<div id="chat"></div>
	<script>
	let param = [];
	
		document.querySelector('#btn').
			addEventListener('click', async function(){
				let chat = document.querySelector('#chat');
				let prompt = document.querySelector('#prompt');
				let url = "gemini";
				
				param.push({ role:"user",text:prompt.value });
				
				let option = {
					method:"POST",
					headers:{
						'Content-Type':'application/json'
					},
					body:JSON.stringify(param)	
				}
				let response = await fetch(url,option);
				let text = await response.text()
				let data = JSON.parse(text)
				let aiResponse = data.candidates[0].content.parts[0].text;
				chat.innerHTML += "유저: " + prompt.value + `<br>`
				chat.innerHTML += "ai: " + aiResponse + `<br>`
				prompt.value='';
				
		})
			
		
	</script>
</body>
</html>