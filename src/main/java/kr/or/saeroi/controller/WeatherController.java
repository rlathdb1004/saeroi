package kr.or.saeroi.controller;
// 네 WeatherController.java가 들어있는 실제 패키지명으로 수정해야 한다.

import java.io.BufferedReader;
// API 응답 내용을 한 줄씩 읽기 위해 사용하는 클래스이다.
import java.io.InputStreamReader;
// API 응답을 UTF-8 문자로 읽기 위해 사용하는 클래스이다.
import java.net.HttpURLConnection;
// OpenWeatherMap 서버와 연결하기 위해 사용하는 클래스이다.
import java.net.URL;
// 문자열 주소를 실제 URL 객체로 바꾸기 위해 사용하는 클래스이다.

import org.json.simple.JSONArray;
// OpenWeatherMap 응답 JSON에서 weather 배열을 꺼내기 위해 사용하는 클래스이다.
import org.json.simple.JSONObject;
// JSON 데이터를 객체처럼 다루기 위해 사용하는 클래스이다.
import org.json.simple.parser.JSONParser;
// JSON 문자열을 Java 객체로 바꾸기 위해 사용하는 클래스이다.
import org.springframework.stereotype.Controller;
// 이 클래스가 Spring MVC Controller라는 것을 알려주는 어노테이션이다.
import org.springframework.web.bind.annotation.RequestMapping;
// 요청 주소와 메서드를 연결하기 위해 사용하는 어노테이션이다.
import org.springframework.web.bind.annotation.RequestMethod;
// GET, POST 같은 요청 방식을 지정하기 위해 사용하는 클래스이다.
import org.springframework.web.bind.annotation.ResponseBody;
// JSP 페이지 이동이 아니라 데이터를 그대로 응답하기 위해 사용하는 어노테이션이다.


@Controller
// 이 클래스가 Controller 역할을 한다는 뜻이다.
public class WeatherController {
    // 날씨 API 요청을 처리하는 Controller 클래스이다.

    private static final String API_KEY = "545daa2317f767401f9fcdbf11338152";
    // OpenWeatherMap에서 발급받은 API 키를 넣는 자리이다.

    private static final String LAT = "37.5665";
    // 날씨를 가져올 지역의 위도이다. 현재는 서울 기준이다.

    private static final String LON = "126.9780";
    // 날씨를 가져올 지역의 경도이다. 현재는 서울 기준이다.


    @ResponseBody
    // JSP 페이지 이름을 반환하는 것이 아니라 JSON 데이터를 그대로 응답한다.

    @RequestMapping(value = "/weather/current", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    // /weather/current 주소로 GET 요청이 오면 이 메서드를 실행한다.
    public String getCurrentWeather() {
        // 현재 온도, 날씨 설명, 날씨 아이콘 주소를 JSON 문자열로 반환하는 메서드이다.

        JSONObject result = new JSONObject();
        // 화면으로 보낼 결과 데이터를 담을 JSON 객체를 만든다.

        HttpURLConnection conn = null;
        // OpenWeatherMap 서버 연결 객체를 담을 변수이다.

        BufferedReader br = null;
        // API 응답 내용을 읽기 위한 변수이다.

        try {
            // API 호출 중 에러가 날 수 있으므로 try-catch로 감싼다.

            String apiUrl = "https://api.openweathermap.org/data/2.5/weather"
                    + "?lat=" + LAT
                    + "&lon=" + LON
                    + "&appid=" + API_KEY
                    + "&units=metric"
                    + "&lang=kr";
            // OpenWeatherMap 현재 날씨 API 요청 주소를 만든다.
            // units=metric은 온도를 섭씨로 받기 위한 설정이다.
            // lang=kr은 날씨 설명을 한국어로 받기 위한 설정이다.

            URL url = new URL(apiUrl);
            // 문자열로 만든 API 주소를 실제 URL 객체로 바꾼다.

            conn = (HttpURLConnection) url.openConnection();
            // OpenWeatherMap 서버에 연결한다.

            conn.setRequestMethod("GET");
            // GET 방식으로 요청한다.

            conn.setConnectTimeout(5000);
            // 서버 연결 대기 시간을 5초로 설정한다.

            conn.setReadTimeout(5000);
            // 서버 응답 대기 시간을 5초로 설정한다.

            int responseCode = conn.getResponseCode();
            // OpenWeatherMap 서버의 응답 상태 코드를 가져온다.

            System.out.println("OpenWeatherMap 응답 코드 : " + responseCode);
            // 콘솔에서 실제 응답 코드를 확인하기 위해 출력한다.

            if (responseCode != 200) {
                // 응답 코드가 200이 아니면 정상 응답이 아니다.
                // 예: 401은 API KEY 문제일 가능성이 크다.

                result.put("temp", null);
                // 온도 값을 비워둔다.

                result.put("description", "날씨 확인 불가");
                // 날씨 설명에 실패 문구를 넣는다.

                result.put("iconUrl", null);
                // 아이콘 주소를 비워둔다.

                result.put("message", "OpenWeatherMap 응답 코드 : " + responseCode);
                // 실패 원인을 확인할 수 있도록 응답 코드를 같이 담는다.

                return result.toJSONString();
                // 실패 결과를 JSON 문자열로 반환한다.
            }

            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            // OpenWeatherMap 응답 내용을 UTF-8로 읽는다.

            StringBuilder sb = new StringBuilder();
            // API 응답 JSON 문자열을 누적해서 담을 공간이다.

            String line = "";
            // 한 줄씩 읽은 내용을 임시로 담는 변수이다.

            while ((line = br.readLine()) != null) {
                // 더 이상 읽을 줄이 없을 때까지 반복한다.

                sb.append(line);
                // 읽은 한 줄을 StringBuilder에 추가한다.
            }

            JSONParser parser = new JSONParser();
            // JSON 문자열을 Java 객체로 바꾸기 위한 parser를 만든다.

            JSONObject data = (JSONObject) parser.parse(sb.toString());
            // OpenWeatherMap에서 받은 JSON 문자열을 JSONObject로 바꾼다.

            JSONObject main = (JSONObject) data.get("main");
            // JSON에서 main 영역을 꺼낸다.
            // main 안에는 temp 같은 온도 정보가 들어있다.

            Object tempObject = main.get("temp");
            // main 영역에서 현재 온도를 꺼낸다.

            double temp = Double.parseDouble(tempObject.toString());
            // 온도 값을 double 타입으로 바꾼다.

            JSONArray weather = (JSONArray) data.get("weather");
            // JSON에서 weather 배열을 꺼낸다.
            // weather 안에는 날씨 상태, 설명, 아이콘 코드가 들어있다.

            JSONObject weatherInfo = (JSONObject) weather.get(0);
            // weather 배열의 첫 번째 값을 꺼낸다.

            String description = (String) weatherInfo.get("description");
            // 날씨 설명을 꺼낸다.
            // 예: 맑음, 흐림, 비

            String icon = (String) weatherInfo.get("icon");
            // 날씨 아이콘 코드를 꺼낸다.
            // 예: 01d, 02d, 04d, 10d

            String iconUrl = "https://openweathermap.org/img/wn/" + icon + "@2x.png";
            // OpenWeatherMap 아이콘 이미지 주소를 만든다.

            result.put("temp", String.format("%.1f", temp));
            // 온도를 소수점 1자리로 정리해서 담는다.
            // 예: 25.9

            result.put("description", description);
            // 날씨 설명을 담는다.

            result.put("iconUrl", iconUrl);
            // 날씨 아이콘 이미지 주소를 담는다.

            result.put("message", "success");
            // 정상 처리 여부를 확인하기 위한 문구를 담는다.

        } catch (Exception e) {
            // API 호출이나 JSON 처리 중 에러가 나면 실행된다.

            e.printStackTrace();
            // 콘솔에 실제 에러 내용을 출력한다.

            result.put("temp", null);
            // 온도 값을 비워둔다.

            result.put("description", "날씨 확인 불가");
            // 날씨 설명에 실패 문구를 넣는다.

            result.put("iconUrl", null);
            // 아이콘 주소를 비워둔다.

            result.put("message", e.getMessage());
            // 실제 에러 메시지를 담는다.

        } finally {
            // 성공하든 실패하든 마지막에 실행되는 영역이다.

            try {
                // BufferedReader를 닫을 때 에러가 날 수 있으므로 try-catch로 감싼다.

                if (br != null) {
                    // BufferedReader가 만들어져 있으면 실행한다.

                    br.close();
                    // 응답 읽기를 종료한다.
                }

            } catch (Exception e) {
                // BufferedReader를 닫는 중 에러가 나면 실행된다.

                e.printStackTrace();
                // 콘솔에 에러 내용을 출력한다.
            }

            if (conn != null) {
                // 서버 연결 객체가 있으면 실행한다.

                conn.disconnect();
                // OpenWeatherMap 서버 연결을 종료한다.
            }
        }

        return result.toJSONString();
        // 온도, 날씨 설명, 아이콘 주소를 JSON 문자열로 반환한다.
    }
    // getCurrentWeather 메서드를 끝낸다.


    @ResponseBody
    // JSP 페이지 이름이 아니라 글자 데이터를 그대로 응답한다.

    @RequestMapping(value = "/weather/today", method = RequestMethod.GET, produces = "text/plain; charset=UTF-8")
    // 기존 JS에서 사용하던 /weather/today 주소도 남겨둔다.
    public String getTodayTemp() {
        // 기존 방식처럼 온도만 글자로 반환하는 메서드이다.

        try {
            // JSON 파싱 중 에러가 날 수 있으므로 try-catch로 감싼다.

            String weatherJson = getCurrentWeather();
            // 위에서 만든 getCurrentWeather 메서드를 사용해서 날씨 JSON을 가져온다.

            JSONParser parser = new JSONParser();
            // JSON 문자열을 Java 객체로 바꾸기 위한 parser를 만든다.

            JSONObject weatherObject = (JSONObject) parser.parse(weatherJson);
            // 날씨 JSON 문자열을 JSONObject로 바꾼다.

            Object temp = weatherObject.get("temp");
            // JSON에서 온도 값만 꺼낸다.

            if (temp == null) {
                // 온도 값이 없으면 실행한다.

                return "온도 확인 불가";
                // 기존 JS가 이해할 수 있는 실패 문구를 반환한다.
            }

            return temp.toString();
            // 온도 숫자만 글자로 반환한다.

        } catch (Exception e) {
            // 처리 중 에러가 나면 실행된다.

            e.printStackTrace();
            // 콘솔에 에러 내용을 출력한다.

            return "온도 확인 불가";
            // 화면에 보여줄 실패 문구를 반환한다.
        }
    }
    // getTodayTemp 메서드를 끝낸다.

}
// WeatherController 클래스를 끝낸다.