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
		document.querySelector('#btn').
			addEventListener('click', async function(){
				let chat = document.querySelector('#chat');
				let prompt = document.querySelector('#prompt');
				let url = "gemini";
				let param = {
					prompt:prompt.value
				}
				let option = {
					method:"POST",
					headers:{
						'Content-Type':'application/json'
					},
					body:JSON.stringify(param)	
				}
				let response = await fetch(url,option);
				let data = await response.json()
				let aiResponse = data.candidates[0].content.parts[0].text;
				chat.innerHTML += aiResponse
				prompt.value='';
				
		})
			
		
	</script>
</body>
</html>