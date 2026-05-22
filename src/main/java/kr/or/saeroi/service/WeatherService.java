package kr.or.saeroi.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Locale;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

@Service
// AccuWeather API 호출과 30분 캐시 처리를 담당하는 Service이다.
public class WeatherService {

    private static final String API_KEY = "zpka_00804de33ec54b85a0947feaae49b196_f27063a4";
    // AccuWeather에서 발급받은 API Key를 넣는다.

    private static final String LOCATION_KEY = "226081";
    // 서울 AccuWeather locationKey이다.
    // AccuWeather 서울 주소에도 226081 값이 사용된다.

    private static final long CACHE_TIME = 30 * 60 * 1000;
    // 30분을 밀리초로 계산한 값이다.
    // 30분 안에는 AccuWeather를 다시 호출하지 않고 저장된 값을 반환한다.

    private String cachedTemp;
    // 마지막으로 저장한 온도이다.

    private String cachedDescription;
    // 마지막으로 저장한 날씨 설명이다.

    private String cachedIconUrl;
    // 마지막으로 저장한 날씨 아이콘 주소이다.

    private long lastApiCallTime = 0;
    // 마지막으로 AccuWeather API를 호출한 시간이다.

    public synchronized JSONObject getCurrentWeather() {
        // 현재 날씨 정보를 JSON 형태로 반환하는 메소드이다.
        // synchronized는 여러 사용자가 동시에 요청해도 캐시 값이 꼬이지 않게 하기 위해 사용한다.

        long now = System.currentTimeMillis();
        // 현재 시간을 밀리초로 가져온다.

        if (cachedTemp != null && now - lastApiCallTime < CACHE_TIME) {
            // 저장된 온도가 있고, 마지막 API 호출 후 30분이 지나지 않았으면 실행한다.

            return makeWeatherResult(cachedTemp, cachedDescription, cachedIconUrl, "cache");
            // AccuWeather를 다시 호출하지 않고 저장된 값을 그대로 반환한다.
        }

        return callAccuWeather(now);
        // 저장된 값이 없거나 30분이 지났으면 AccuWeather를 다시 호출한다.
    }

    public String getTodayTemperature() {
        // 온도 숫자만 필요한 기존 기능을 유지하기 위한 메소드이다.

        JSONObject weather = getCurrentWeather();
        // 현재 날씨 JSON을 가져온다.

        Object temp = weather.get("temp");
        // JSON에서 온도 값만 꺼낸다.

        if (temp == null) {
            // 온도 값이 없으면 실행한다.

            return "온도 확인 불가";
            // 화면에 보여줄 실패 문구를 반환한다.
        }

        return temp.toString();
        // 온도 숫자만 문자열로 반환한다.
    }

    private JSONObject callAccuWeather(long now) {
        // AccuWeather API를 실제로 호출하는 메소드이다.

        HttpURLConnection conn = null;
        // API 연결 객체이다.

        BufferedReader br = null;
        // API 응답을 읽기 위한 객체이다.

        try {
            String apiUrl = "https://dataservice.accuweather.com/currentconditions/v1/"
                    + LOCATION_KEY
                    + "?language=ko-kr&details=false";
            // AccuWeather 현재 날씨 API 주소이다.
            // language=ko-kr은 날씨 설명을 한국어로 받기 위한 설정이다.
            // details=false는 기본 정보만 받기 위한 설정이다.

            URL url = new URL(apiUrl);
            // 문자열 주소를 URL 객체로 바꾼다.

            conn = (HttpURLConnection) url.openConnection();
            // AccuWeather 서버에 연결한다.

            conn.setRequestMethod("GET");
            // GET 방식으로 요청한다.

            conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
            // AccuWeather 공식 방식에 맞게 API Key를 Authorization 헤더에 넣는다.

            conn.setRequestProperty("Accept", "application/json");
            // JSON 응답을 받겠다고 요청한다.

            conn.setConnectTimeout(5000);
            // 서버 연결 대기 시간을 5초로 설정한다.

            conn.setReadTimeout(5000);
            // 서버 응답 대기 시간을 5초로 설정한다.

            int responseCode = conn.getResponseCode();
            // API 응답 코드를 가져온다.

            System.out.println("AccuWeather 응답 코드 : " + responseCode);
            // 콘솔에서 응답 코드를 확인하기 위해 출력한다.

            if (responseCode != 200) {
                // 응답 코드가 200이 아니면 정상 응답이 아니다.

                if (cachedTemp != null) {
                    // API 호출은 실패했지만 기존에 저장된 날씨가 있으면 실행한다.

                    return makeWeatherResult(cachedTemp, cachedDescription, cachedIconUrl,
                            "AccuWeather 응답 실패, 기존 캐시 사용 : " + responseCode);
                    // 화면에는 기존 캐시 값을 보여준다.
                }

                return makeWeatherResult(null, "날씨 확인 불가", null,
                        "AccuWeather 응답 코드 : " + responseCode);
                // 저장된 값도 없으면 실패 결과를 반환한다.
            }

            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            // API 응답 내용을 UTF-8로 읽는다.

            StringBuilder sb = new StringBuilder();
            // API 응답 JSON 문자열을 누적할 공간이다.

            String line = "";
            // 한 줄씩 읽은 내용을 담는 변수이다.

            while ((line = br.readLine()) != null) {
                // 더 이상 읽을 줄이 없을 때까지 반복한다.

                sb.append(line);
                // 읽은 내용을 누적한다.
            }

            JSONObject result = parseAccuWeatherJson(sb.toString());
            // AccuWeather 응답 JSON에서 화면에 필요한 값만 꺼낸다.

            if (result.get("temp") != null) {
                // 온도 값이 정상적으로 있으면 실행한다.

                cachedTemp = result.get("temp").toString();
                // 온도를 캐시에 저장한다.

                cachedDescription = result.get("description").toString();
                // 날씨 설명을 캐시에 저장한다.

                cachedIconUrl = result.get("iconUrl").toString();
                // 아이콘 주소를 캐시에 저장한다.

                lastApiCallTime = now;
                // 마지막 API 호출 시간을 현재 시간으로 저장한다.
            }

            return result;
            // 새로 가져온 날씨 결과를 반환한다.

        } catch (Exception e) {
            // API 호출이나 JSON 처리 중 에러가 나면 실행된다.

            e.printStackTrace();
            // 콘솔에 실제 에러 내용을 출력한다.

            if (cachedTemp != null) {
                // 에러가 났지만 기존에 저장된 날씨가 있으면 실행한다.

                return makeWeatherResult(cachedTemp, cachedDescription, cachedIconUrl,
                        "AccuWeather 호출 실패, 기존 캐시 사용");
                // 화면에는 기존 캐시 값을 보여준다.
            }

            return makeWeatherResult(null, "날씨 확인 불가", null, e.getMessage());
            // 저장된 값도 없으면 실패 결과를 반환한다.

        } finally {
            // 성공하든 실패하든 마지막에 실행된다.

            try {
                if (br != null) {
                    // BufferedReader가 만들어져 있으면 실행한다.

                    br.close();
                    // 응답 읽기를 종료한다.
                }
            } catch (Exception e) {
                e.printStackTrace();
                // BufferedReader를 닫는 중 에러가 나면 콘솔에 출력한다.
            }

            if (conn != null) {
                // API 연결 객체가 있으면 실행한다.

                conn.disconnect();
                // AccuWeather 서버 연결을 종료한다.
            }
        }
    }

    private JSONObject parseAccuWeatherJson(String json) throws Exception {
        // AccuWeather 응답 JSON에서 온도, 설명, 아이콘 주소만 꺼내는 메소드이다.

        JSONParser parser = new JSONParser();
        // JSON 문자열을 Java 객체로 바꾸기 위한 parser이다.

        JSONArray weatherArray = (JSONArray) parser.parse(json);
        // AccuWeather 현재 날씨 응답은 배열 형태로 온다.

        if (weatherArray == null || weatherArray.isEmpty()) {
            // 응답 배열이 비어 있으면 실행한다.

            return makeWeatherResult(null, "날씨 확인 불가", null, "AccuWeather 응답 없음");
            // 실패 결과를 반환한다.
        }

        JSONObject weatherObject = (JSONObject) weatherArray.get(0);
        // 배열의 첫 번째 날씨 정보를 꺼낸다.

        String description = String.valueOf(weatherObject.get("WeatherText"));
        // 날씨 설명을 꺼낸다.
        // 예: 맑음, 대체로 맑음, 흐림

        Object weatherIcon = weatherObject.get("WeatherIcon");
        // AccuWeather 날씨 아이콘 번호를 꺼낸다.

        JSONObject temperature = (JSONObject) weatherObject.get("Temperature");
        // 온도 정보 영역을 꺼낸다.

        JSONObject metric = (JSONObject) temperature.get("Metric");
        // 섭씨 온도 정보 영역을 꺼낸다.

        Object tempValueObject = metric.get("Value");
        // 실제 섭씨 온도 숫자를 꺼낸다.

        double tempValue = Double.parseDouble(tempValueObject.toString());
        // 온도 값을 double 타입으로 바꾼다.

        String temp = String.format(Locale.US, "%.1f", tempValue);
        // 온도를 소수점 1자리로 정리한다.
        // 예: 25.9

        String iconUrl = makeAccuWeatherIconUrl(weatherIcon);
        // AccuWeather 아이콘 번호로 아이콘 이미지 주소를 만든다.

        return makeWeatherResult(temp, description, iconUrl, "success");
        // 화면에 보낼 결과 JSON을 만든다.
    }

    @SuppressWarnings("unchecked")
    private JSONObject makeWeatherResult(String temp, String description, String iconUrl, String message) {
        // header.js가 사용하기 쉬운 형태로 JSON을 만드는 메소드이다.

        JSONObject result = new JSONObject();
        // 결과 JSON 객체를 만든다.

        result.put("temp", temp);
        // 온도 값을 담는다.
        // header.js에서 data.temp로 사용한다.

        result.put("description", description);
        // 날씨 설명을 담는다.
        // header.js에서 data.description으로 사용한다.

        result.put("iconUrl", iconUrl);
        // 날씨 아이콘 주소를 담는다.
        // header.js에서 data.iconUrl로 사용한다.

        result.put("message", message);
        // 성공, 캐시, 실패 여부를 확인하기 위한 메시지이다.

        return result;
        // 완성된 JSON을 반환한다.
    }

    private String makeAccuWeatherIconUrl(Object weatherIcon) {
        // AccuWeather 아이콘 번호를 이미지 주소로 바꾸는 메소드이다.

        if (weatherIcon == null) {
            // 아이콘 번호가 없으면 실행한다.

            return null;
            // 아이콘 주소를 비워둔다.
        }

        int iconNumber = Integer.parseInt(weatherIcon.toString());
        // 아이콘 번호를 숫자로 바꾼다.

        return "https://www.accuweather.com/images/weathericons/" + iconNumber + ".svg";
        // AccuWeather 날씨 아이콘 SVG 주소이다.
        // 예: https://www.accuweather.com/images/weathericons/1.svg
    }
}