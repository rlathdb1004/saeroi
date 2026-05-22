package kr.or.saeroi.controller;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.saeroi.service.WeatherService;

@Controller
// 날씨 요청을 처리하는 Controller이다.
public class WeatherController {

    private final WeatherService weatherService;
    // 실제 AccuWeather API 호출과 30분 캐시 처리는 Service에서 담당한다.

    @Autowired
    public WeatherController(WeatherService weatherService) {
        // WeatherService를 Controller에서 사용할 수 있게 주입받는다.

        this.weatherService = weatherService;
    }

    @ResponseBody
    @RequestMapping(value = "/weather/current", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public String getCurrentWeather() {
        // header.js에서 호출하는 기존 주소이다.
        // 화면에서는 temp, description, iconUrl 값을 사용한다.

        JSONObject weather = weatherService.getCurrentWeather();
        // Service에서 현재 날씨 JSON을 가져온다.

        return weather.toJSONString();
        // JSON 문자열로 변환해서 화면에 응답한다.
    }

    @ResponseBody
    @RequestMapping(value = "/weather/today", method = RequestMethod.GET, produces = "text/plain; charset=UTF-8")
    public String getTodayTemp() {
        // 기존에 온도 숫자만 필요할 때 사용하던 주소도 유지한다.

        return weatherService.getTodayTemperature();
        // 현재 온도만 문자열로 반환한다.
    }
}