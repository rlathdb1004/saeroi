package kr.or.saeroi.controller;
// 이 파일이 kr.or.saeroi.controller 패키지 안에 있다는 뜻이다.

import org.springframework.beans.factory.annotation.Autowired;
// Service 객체를 자동으로 연결하기 위해 Autowired를 가져온다.
import org.springframework.stereotype.Controller;
// 이 클래스를 Spring Controller로 사용하기 위해 Controller를 가져온다.
import org.springframework.web.bind.annotation.RequestMapping;
// 주소와 메소드를 연결하기 위해 RequestMapping을 가져온다.
import org.springframework.web.bind.annotation.RequestMethod;
// GET 방식인지 POST 방식인지 구분하기 위해 RequestMethod를 가져온다.
import org.springframework.web.bind.annotation.ResponseBody;
// JSP 화면 이름이 아니라 글자 데이터를 그대로 응답하기 위해 ResponseBody를 가져온다.

import kr.or.saeroi.service.WeatherService;
// 날씨 API 처리를 담당하는 WeatherService를 가져온다.

@Controller
// 이 클래스가 Controller 역할을 한다고 Spring에게 알려준다.
public class WeatherController {
    // WeatherController 클래스의 시작이다.

    @Autowired
    // WeatherService 객체를 Spring이 자동으로 넣어주게 한다.
    private WeatherService weatherService;
    // 날씨 API 기능을 사용하기 위한 Service 변수이다.

    @RequestMapping(value = "/weather/today", method = RequestMethod.GET)
    // header.js에서 /weather/today 주소로 요청하면 이 메소드가 실행된다.
    @ResponseBody
    // return 값을 JSP 파일명이 아니라 화면에 보낼 글자 데이터로 사용한다.
    public String todayWeather() {
        // 오늘 온도를 가져오는 메소드의 시작이다.

        String todayTemp = weatherService.getTodayTemperature();
        // WeatherService에서 오늘 온도 값을 가져온다.

        return todayTemp;
        // 가져온 온도 값을 header.js로 보낸다.
    }
    // todayWeather 메소드의 끝이다.
}
// WeatherController 클래스의 끝이다.