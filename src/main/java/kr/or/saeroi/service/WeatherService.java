package kr.or.saeroi.service;
// 이 파일이 kr.or.saeroi.service 패키지 안에 있다는 뜻이다.

import java.io.BufferedReader;
// 외부 API 응답을 한 줄씩 읽기 위해 사용하는 클래스이다.

import java.io.InputStreamReader;
// API 응답 바이트 데이터를 글자로 바꾸기 위해 사용하는 클래스이다.

import java.net.HttpURLConnection;
// 외부 API 주소에 HTTP 방식으로 연결하기 위해 사용하는 클래스이다.

import java.net.URL;
// 외부 API 주소 문자열을 URL 객체로 바꾸기 위해 사용하는 클래스이다.

import org.springframework.stereotype.Service;
// 이 클래스를 Spring Service로 등록하기 위해 사용하는 import이다.

@Service
// 이 클래스가 Service 역할을 한다고 Spring에게 알려준다.
public class WeatherService {
    // WeatherService 클래스의 시작이다.

    public String getTodayTemperature() {
        // 오늘 온도를 가져오는 메소드이다.

        String resultTemp = "온도 확인 불가";
        // API 호출에 실패했을 때 기본으로 보여줄 문구이다.

        BufferedReader br = null;
        // API 응답을 읽기 위한 변수를 미리 만든다.

        HttpURLConnection conn = null;
        // API 연결을 담당할 변수를 미리 만든다.

        try {
            // 외부 API 연결 중 에러가 날 수 있어서 try문으로 감싼다.

            String apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=37.5665&longitude=126.9780&current=temperature_2m&timezone=Asia%2FSeoul";
            // 서울 기준 현재 온도를 가져오는 Open-Meteo API 주소이다.

            URL url = new URL(apiUrl);
            // 문자열로 된 API 주소를 URL 객체로 바꾼다.

            conn = (HttpURLConnection) url.openConnection();
            // API 주소로 연결을 연다.

            conn.setRequestMethod("GET");
            // API 요청 방식을 GET으로 설정한다.

            conn.setConnectTimeout(5000);
            // API 서버 연결을 최대 5초까지만 기다리게 설정한다.

            conn.setReadTimeout(5000);
            // API 응답 읽기를 최대 5초까지만 기다리게 설정한다.

            int responseCode = conn.getResponseCode();
            // API 서버의 응답 상태 코드를 가져온다.

            if (responseCode == 200) {
                // 응답 코드가 200이면 정상 응답이라는 뜻이다.

                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                // API 응답 내용을 UTF-8 글자로 읽을 준비를 한다.

                String line = "";
                // API 응답을 한 줄씩 담을 변수이다.

                StringBuffer sb = new StringBuffer();
                // API 응답 전체를 누적해서 담을 변수이다.

                while ((line = br.readLine()) != null) {
                    // API 응답을 한 줄씩 읽고, 더 이상 읽을 줄이 없을 때까지 반복한다.

                    sb.append(line);
                    // 읽은 내용을 StringBuffer에 추가한다.
                }
                // while 반복문을 끝낸다.

                String json = sb.toString();
                // 누적된 API 응답 내용을 문자열로 바꾼다.

                resultTemp = parseTemperature(json);
                // JSON 문자열에서 온도 값만 뽑아서 결과에 저장한다.
            }
            // 응답 코드 확인 if문을 끝낸다.

        } catch (Exception e) {
            // API 연결이나 데이터 처리 중 에러가 나면 실행된다.

            e.printStackTrace();
            // 콘솔에 에러 내용을 출력한다.

            resultTemp = "온도 확인 불가";
            // 에러가 났을 때 화면에 보여줄 문구를 저장한다.

        } finally {
            // try 성공 여부와 상관없이 마지막에 실행되는 영역이다.

            try {
                // BufferedReader를 닫는 과정에서도 에러가 날 수 있어서 try문으로 감싼다.

                if (br != null) {
                    // BufferedReader가 만들어져 있는지 확인한다.

                    br.close();
                    // API 응답을 읽는 데 사용한 BufferedReader를 닫는다.
                }
                // if문을 끝낸다.

            } catch (Exception e) {
                // BufferedReader를 닫는 중 에러가 나면 실행된다.

                e.printStackTrace();
                // 콘솔에 에러 내용을 출력한다.
            }
            // BufferedReader 닫기 try문을 끝낸다.

            if (conn != null) {
                // API 연결 객체가 만들어져 있는지 확인한다.

                conn.disconnect();
                // API 연결을 종료한다.
            }
            // if문을 끝낸다.
        }
        // finally문을 끝낸다.

        return resultTemp;
        // 최종 온도 결과를 Controller로 돌려준다.
    }
    // getTodayTemperature 메소드의 끝이다.

    private String parseTemperature(String json) {
        // API 응답 JSON 문자열에서 온도 값만 잘라내는 메소드이다.

        String result = "온도 확인 불가";
        // 온도 값을 찾지 못했을 때 사용할 기본 문구이다.

        try {
            // 문자열을 자르는 중 에러가 날 수 있어서 try문으로 감싼다.

            int currentIndex = json.indexOf("\"current\":");
            // JSON 문자열에서 current라는 글자가 시작되는 위치를 찾는다.

            int tempIndex = json.indexOf("\"temperature_2m\":", currentIndex);
            // current 뒤쪽에서 temperature_2m 값이 시작되는 위치를 찾는다.

            if (currentIndex == -1 || tempIndex == -1) {
                // current 또는 temperature_2m 값을 찾지 못했는지 확인한다.

                return result;
                // 값을 찾지 못하면 온도 확인 불가를 반환한다.
            }
            // if문을 끝낸다.

            int startIndex = tempIndex + "\"temperature_2m\":".length();
            // 실제 온도 숫자가 시작되는 위치를 계산한다.

            int endIndex = json.indexOf(",", startIndex);
            // 온도 숫자가 끝나는 위치를 콤마 기준으로 찾는다.

            if (endIndex == -1) {
                // 콤마를 찾지 못했는지 확인한다.

                endIndex = json.indexOf("}", startIndex);
                // 콤마가 없으면 중괄호 기준으로 끝 위치를 찾는다.
            }
            // if문을 끝낸다.

            String temp = json.substring(startIndex, endIndex).trim();
            // 온도 숫자 부분만 잘라내고 앞뒤 공백을 제거한다.

            result = temp;
            // Java에서는 온도 숫자만 반환한다.
            // ℃ 같은 특수문자는 인코딩 문제로 깨질 수 있어서 화면 JS에서 붙인다.

        } catch (Exception e) {
            // 온도 값을 자르는 중 에러가 나면 실행된다.

            e.printStackTrace();
            // 콘솔에 에러 내용을 출력한다.

            result = "온도 확인 불가";
            // 에러가 나면 온도 확인 불가를 결과로 저장한다.
        }
        // try-catch문을 끝낸다.

        return result;
        // 온도 결과를 반환한다.
    }
    // parseTemperature 메소드의 끝이다.
}
// WeatherService 클래스의 끝이다.