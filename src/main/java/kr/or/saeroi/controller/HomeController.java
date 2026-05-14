//package kr.or.saeroi.controller;
//
//import java.text.DateFormat;
//import java.util.Date;
//import java.util.Locale;
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestMethod;
//
///**
// * Handles requests for the application home page.
// */
//@Controller
//public class HomeController {
//	
//	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
//	
//	/**
//	 * Simply selects the home view to render by returning its name.
//	 */
//	@RequestMapping(value = "/", method = RequestMethod.GET)
//	// 사용자가 기본 주소로 접속했을 때 실행된다.
//	public String home(Locale locale, Model model) {
//	    // home 메소드의 시작이다.
//
//	    model.addAttribute("contentPage", "/WEB-INF/views/home.jsp");
//	    // layout.jsp 안에 들어갈 실제 본문 페이지를 home.jsp로 지정한다.
//
//	    model.addAttribute("headerTitle", "대시보드");
//	    // 헤더의 큰 제목으로 대시보드를 보낸다.
//
//	    model.addAttribute("headerSubTitle", "메인");
//	    // 헤더의 현재 선택 메뉴로 메인을 보낸다.
//
//	    return "layout";
//	    // home.jsp를 바로 여는 것이 아니라 layout.jsp를 먼저 열도록 한다.
//	}
//	
//}

package kr.or.saeroi.controller;
// 컨트롤러 파일이 들어있는 패키지이다.

import java.util.ArrayList;
// 테스트용 목록을 만들기 위해 ArrayList를 사용한다.

import java.util.HashMap;
// 테스트용 데이터 한 줄을 Map 형태로 만들기 위해 HashMap을 사용한다.

import java.util.List;
// 여러 개의 데이터를 목록으로 담기 위해 List를 사용한다.

import java.util.Map;
// 한 줄 데이터를 key, value 형태로 담기 위해 Map을 사용한다.

import org.springframework.stereotype.Controller;
// 이 클래스가 Controller 역할을 한다는 것을 Spring에게 알려준다.

import org.springframework.ui.Model;
// Controller에서 JSP로 데이터를 보내기 위해 사용한다.

import org.springframework.web.bind.annotation.RequestMapping;
// 주소 요청을 연결하기 위해 사용한다.

import org.springframework.web.bind.annotation.RequestMethod;
// GET, POST 방식을 지정하기 위해 사용한다.

import org.springframework.web.bind.annotation.RequestParam;
// 주소 뒤에 붙는 page, size 값을 받기 위해 사용한다.

import kr.or.saeroi.common.PageDTO;
// 우리가 만든 공통 페이징 계산 클래스를 사용한다.

@Controller
// 이 클래스가 Spring Controller라는 뜻이다.
public class HomeController {
    // 홈 화면 요청을 처리하는 컨트롤러이다.

    @RequestMapping(value = "/", method = RequestMethod.GET)
    // localhost:8080/saeroi/ 주소로 GET 요청이 들어오면 이 메소드가 실행된다.
    public String home(
            @RequestParam(value = "page", defaultValue = "1") int page,
            // 주소에 page 값이 있으면 받고, 없으면 기본값 1을 사용한다.

            @RequestParam(value = "size", defaultValue = "10") int size,
            // 주소에 size 값이 있으면 받고, 없으면 기본값 10을 사용한다.

            Model model) {
            // JSP로 데이터를 보내기 위해 Model을 사용한다.

        int totalCount = 36;
        // 테스트용 전체 데이터 개수이다. 나중에는 DB에서 count(*)로 가져올 값이다.

        PageDTO pageInfo = new PageDTO(page, size, totalCount);
        // 현재 페이지, 보기 개수, 전체 개수를 넣어서 페이징 정보를 만든다.

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        // 화면 테이블에 보여줄 테스트용 목록을 만든다.

        int startNo = (pageInfo.getPage() - 1) * pageInfo.getSize() + 1;
        // 현재 페이지에서 시작할 번호를 계산한다.

        int endNo = startNo + pageInfo.getSize() - 1;
        // 현재 페이지에서 끝날 번호를 계산한다.

        if (endNo > totalCount) {
            // 끝 번호가 전체 개수보다 크면 안 된다.
            endNo = totalCount;
            // 끝 번호를 전체 개수로 맞춘다.
        }

        for (int i = startNo; i <= endNo; i++) {
            // 현재 페이지에 보여줄 개수만큼 반복한다.

            Map<String, Object> dto = new HashMap<String, Object>();
            // 테이블 한 줄에 들어갈 데이터를 만든다.

            dto.put("no", i);
            // 번호를 넣는다.

            dto.put("itemCode", "P-" + (100 + i));
            // 테스트용 상위품목 코드를 넣는다.

            dto.put("itemName", "배터리 부품 " + i);
            // 테스트용 상위품목명을 넣는다.

            dto.put("bomVersion", "1." + (i % 3));
            // 테스트용 BOM 버전을 넣는다.

            dto.put("versionName", "테스트 버전 " + i);
            // 테스트용 버전명을 넣는다.

            dto.put("materialCount", 10 + i);
            // 테스트용 총 자재 수를 넣는다.

            if (i % 7 == 0) {
                // 번호가 7의 배수이면 미사용으로 보여준다.
                dto.put("useYn", "미사용");
                // 테스트용 사용여부 값을 넣는다.
            } else {
                // 번호가 7의 배수가 아니면 사용으로 보여준다.
                dto.put("useYn", "사용");
                // 테스트용 사용여부 값을 넣는다.
            }

            dto.put("startDate", "2026-05-01");
            // 테스트용 시작일을 넣는다.

            dto.put("endDate", "-");
            // 테스트용 종료일을 넣는다.

            list.add(dto);
            // 만든 한 줄 데이터를 목록에 추가한다.
        }

        model.addAttribute("list", list);
        // JSP에서 테이블에 출력할 목록을 보낸다.

        model.addAttribute("pageInfo", pageInfo);
        // JSP에서 사용할 페이징 정보를 보낸다.

        model.addAttribute("pageUrl", "/");
        // 페이징 버튼을 눌렀을 때 다시 이동할 주소를 보낸다.

        model.addAttribute("contentPage", "/WEB-INF/views/home.jsp");
        // layout.jsp 안에 home.jsp가 들어가도록 설정한다.

        return "layout";
        // layout.jsp 화면을 보여준다.
    }
}
