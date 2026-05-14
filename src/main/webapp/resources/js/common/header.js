function heAddZero(number) {
    // 숫자가 10보다 작을 때 앞에 0을 붙여주는 함수이다.

    if (number < 10) {
        // 숫자가 10보다 작은지 확인한다.

        return "0" + number;
        // 10보다 작으면 앞에 0을 붙여서 반환한다.

    }
    // if문을 끝낸다.

    return number;
    // 10 이상이면 숫자를 그대로 반환한다.
}
// heAddZero 함수를 끝낸다.


function heShowCurrentTime() {
    // 현재 컴퓨터 시간을 화면에 보여주는 함수이다.

    var now = new Date();
    // 현재 내 컴퓨터 시간을 가져온다.

    var year = now.getFullYear();
    // 현재 연도를 가져온다.

    var month = heAddZero(now.getMonth() + 1);
    // 현재 월을 가져온다. getMonth는 0부터 시작해서 1을 더한다.

    var date = heAddZero(now.getDate());
    // 현재 일을 가져온다.

    var dayNumber = now.getDay();
    // 현재 요일 번호를 가져온다. 일요일은 0, 월요일은 1이다.

    var dayText = "";
    // 화면에 보여줄 요일 글자를 담을 변수를 만든다.

    if (dayNumber == 0) {
        // 요일 번호가 0이면 일요일이다.

        dayText = "일";
        // 요일 글자를 일로 저장한다.

    } else if (dayNumber == 1) {
        // 요일 번호가 1이면 월요일이다.

        dayText = "월";
        // 요일 글자를 월로 저장한다.

    } else if (dayNumber == 2) {
        // 요일 번호가 2이면 화요일이다.

        dayText = "화";
        // 요일 글자를 화로 저장한다.

    } else if (dayNumber == 3) {
        // 요일 번호가 3이면 수요일이다.

        dayText = "수";
        // 요일 글자를 수로 저장한다.

    } else if (dayNumber == 4) {
        // 요일 번호가 4이면 목요일이다.

        dayText = "목";
        // 요일 글자를 목으로 저장한다.

    } else if (dayNumber == 5) {
        // 요일 번호가 5이면 금요일이다.

        dayText = "금";
        // 요일 글자를 금으로 저장한다.

    } else if (dayNumber == 6) {
        // 요일 번호가 6이면 토요일이다.

        dayText = "토";
        // 요일 글자를 토로 저장한다.
    }
    // 요일 조건문을 끝낸다.

    var hour = heAddZero(now.getHours());
    // 현재 시간을 가져온다.

    var minute = heAddZero(now.getMinutes());
    // 현재 분을 가져온다.

    var second = heAddZero(now.getSeconds());
    // 현재 초를 가져온다.

    var currentTimeText = year + "-" + month + "-" + date + " (" + dayText + ") " + hour + ":" + minute + ":" + second;
    // 화면에 보여줄 현재시간 문자열을 만든다.

    var timeBox = document.getElementById("heCurrentTime");
    // 현재시간을 넣을 HTML 요소를 찾는다.

    if (timeBox != null) {
        // 현재시간을 넣을 HTML 요소가 있는지 확인한다.

        timeBox.innerHTML = currentTimeText;
        // 현재시간을 화면에 넣는다.
    }
    // if문을 끝낸다.
}
// heShowCurrentTime 함수를 끝낸다.


function heShowTodayTemp() {
    // 오늘 온도를 WeatherController에서 가져오는 함수이다.

    var tempBox = document.getElementById("heTodayTemp");
    // 오늘 온도를 넣을 HTML 요소를 찾는다.

    if (tempBox == null) {
        // 온도를 넣을 HTML 요소가 없으면 실행한다.

        return;
        // 더 이상 진행하지 않고 함수를 끝낸다.
    }
    // if문을 끝낸다.

    tempBox.innerHTML = "불러오는 중";
    // 온도 요청 전에는 불러오는 중이라고 표시한다.

    fetch(contextPath + "/weather/today")
    // 우리 Spring WeatherController의 /weather/today 주소로 요청을 보낸다.

    .then(function(response) {
        // Controller에서 응답이 돌아오면 실행한다.

        return response.text();
        // 응답 내용을 글자 형태로 받는다.
    })
    // 첫 번째 then을 끝낸다.

    .then(function(data) {
        // 응답으로 받은 온도 데이터를 처리한다.

        if (data == "온도 확인 불가") {
    // 서버에서 온도 확인 불가 문구가 오면 실행한다.

    tempBox.innerHTML = data;
    // 에러 문구는 그대로 화면에 보여준다.

} else {
    // 서버에서 정상 온도 숫자가 오면 실행한다.

    tempBox.innerHTML = data + "&deg;C";
    // 온도 숫자 뒤에 섭씨 표시를 붙여서 화면에 보여준다.
    // &deg;는 HTML에서 ° 기호를 안전하게 표시하는 코드이다.
}
    })
    // 두 번째 then을 끝낸다.

    .catch(function(error) {
        // 온도 요청 중 문제가 생기면 실행한다.

        console.error(error);
        // 개발자 도구 콘솔에 에러 내용을 출력한다.

        tempBox.innerHTML = "온도 확인 불가";
        // 화면에는 온도를 가져오지 못했다고 표시한다.
    });
    // fetch 요청을 끝낸다.
}
// heShowTodayTemp 함수를 끝낸다.


heShowCurrentTime();
// 페이지가 열리자마자 현재시간을 한 번 보여준다.

setInterval(heShowCurrentTime, 1000);
// 1초마다 heShowCurrentTime 함수를 다시 실행해서 초까지 갱신한다.

heShowTodayTemp();
// 페이지가 열리자마자 오늘 온도를 한 번 가져온다.