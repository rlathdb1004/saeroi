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
        // 요일 글자를 목로 저장한다.

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


function heShowTodayWeather() {
    // 오늘 온도와 날씨 아이콘을 WeatherController에서 가져오는 함수이다.

    var tempBox = document.getElementById("heTodayTemp");
    // 오늘 온도를 넣을 HTML 요소를 찾는다.

    var iconBox = document.getElementById("heWeatherIcon");
    // 날씨 아이콘을 넣을 img 요소를 찾는다.

    if (tempBox == null) {
        // 온도를 넣을 HTML 요소가 없으면 실행한다.

        return;
        // 더 이상 진행하지 않고 함수를 끝낸다.
    }
    // if문을 끝낸다.

    tempBox.innerHTML = "불러오는 중";
    // 온도 요청 전에는 불러오는 중이라고 표시한다.

    if (iconBox != null) {
        // 날씨 아이콘 요소가 있으면 실행한다.

        iconBox.style.display = "none";
        // API 결과를 받기 전까지는 아이콘을 숨긴다.
    }
    // if문을 끝낸다.

    fetch(contextPath + "/weather/current")
    // 우리 Spring WeatherController의 /weather/current 주소로 요청을 보낸다.
    // OpenWeatherMap에서 가져온 온도, 설명, 아이콘 주소를 JSON으로 받는 주소이다.

    .then(function(response) {
        // Controller에서 응답이 돌아오면 실행한다.

        return response.json();
        // 응답 내용을 JSON 형태로 받는다.
    })
    // 첫 번째 then을 끝낸다.

    .then(function(data) {
        // 응답으로 받은 날씨 데이터를 처리한다.

        if (data.temp == null) {
            // 온도 값이 없으면 실행한다.

            tempBox.innerHTML = "온도 확인 불가";
            // 화면에 온도 확인 불가 문구를 보여준다.

            return;
            // 더 이상 진행하지 않고 함수를 끝낸다.
        }
        // if문을 끝낸다.

        tempBox.innerHTML = data.temp + "&deg;C";
        // 온도 숫자 뒤에 섭씨 표시를 붙여서 화면에 보여준다.
        // &deg;는 HTML에서 ° 기호를 안전하게 표시하는 코드이다.

        if (iconBox != null && data.iconUrl != null) {
            // 날씨 아이콘 요소가 있고, 서버에서 아이콘 주소를 받았으면 실행한다.

            iconBox.src = data.iconUrl;
            // OpenWeatherMap 아이콘 이미지 주소를 img 태그에 넣는다.

            iconBox.alt = data.description;
            // 이미지 설명을 날씨 설명으로 넣는다.

            iconBox.title = data.description;
            // 마우스를 올렸을 때 날씨 설명이 보이게 한다.

            iconBox.style.display = "inline-block";
            // 숨겨두었던 날씨 아이콘을 화면에 보여준다.
        }
        // if문을 끝낸다.
    })
    // 두 번째 then을 끝낸다.

    .catch(function(error) {
        // 날씨 요청 중 문제가 생기면 실행한다.

        console.error(error);
        // 개발자 도구 콘솔에 에러 내용을 출력한다.

        tempBox.innerHTML = "온도 확인 불가";
        // 화면에는 온도를 가져오지 못했다고 표시한다.

        if (iconBox != null) {
            // 날씨 아이콘 요소가 있으면 실행한다.

            iconBox.style.display = "none";
            // 에러가 났을 때는 날씨 아이콘을 숨긴다.
        }
        // if문을 끝낸다.
    });
    // fetch 요청을 끝낸다.
}
// heShowTodayWeather 함수를 끝낸다.


heShowCurrentTime();
// 페이지가 열리자마자 현재시간을 한 번 보여준다.

setInterval(heShowCurrentTime, 1000);
// 1초마다 heShowCurrentTime 함수를 다시 실행해서 초까지 갱신한다.

heShowTodayWeather();
// 페이지가 열리자마자 오늘 온도와 날씨 아이콘을 한 번 가져온다.

// 모바일 햄버거 버튼으로 사이드바를 열고 닫는 기능이다.
document.addEventListener("DOMContentLoaded", function () {

    // 모바일 햄버거 버튼을 가져온다.
    const mobileMenuBtn = document.getElementById("heMobileMenuBtn");

    // 모바일에서 열고 닫을 사이드바를 가져온다.
    const sidebar = document.getElementById("siSidebar");

    // 햄버거 버튼이나 사이드바가 없으면 기능을 실행하지 않는다.
    if (!mobileMenuBtn || !sidebar) {
        return;
    }

    // 햄버거 버튼을 클릭하면 사이드바와 버튼의 열림 상태를 같이 바꾼다.
    mobileMenuBtn.addEventListener("click", function () {

        // 사이드바를 열거나 닫는다.
        sidebar.classList.toggle("is-open");

        // 햄버거 버튼을 X 모양으로 바꾸거나 다시 햄버거 모양으로 되돌린다.
        mobileMenuBtn.classList.toggle("is-open");

        // 현재 메뉴가 열려 있는지 확인한다.
        const isOpen = sidebar.classList.contains("is-open");

        // 접근성 문구를 현재 상태에 맞게 바꾼다.
        mobileMenuBtn.setAttribute("aria-label", isOpen ? "메뉴 닫기" : "메뉴 열기");
    });
});

heShowTodayWeather();
// 페이지가 열리자마자 오늘 온도와 날씨 아이콘을 한 번 가져온다.

setInterval(heShowTodayWeather, 30 * 60 * 1000);
// 30분마다 서버에 날씨를 다시 요청한다.
// 서버에서는 30분 캐시를 사용하기 때문에 AccuWeather API가 불필요하게 계속 호출되지 않는다.