package kr.or.saeroi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.LotDTO;
import kr.or.saeroi.service.LotService;

// LOT 이력추적 화면 요청을 처리하는 Controller이다.
@Controller
public class LotController {

	// LOT 이력추적 Service를 주입받는다.
	@Autowired
	private LotService lotService;

	// LOT 이력추적 목록 화면이다.
	@RequestMapping("/lot/lothistory")
	public String lotHistory(
			LotDTO lotDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		// 검색 조건을 포함한 LOT 이력 전체 건수를 DB에서 조회한다.
		int totalCount = lotService.selectLotHistoryCount(lotDTO);

		// 공통 페이징 객체를 생성한다.
		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		// Oracle ROWNUM 페이징 시작 행 번호이다.
		int startRow = (page - 1) * size + 1;

		// Oracle ROWNUM 페이징 마지막 행 번호이다.
		int endRow = page * size;

		// Mapper에서 페이징 조건으로 사용할 값을 DTO에 담는다.
		lotDTO.setStartRow(startRow);
		lotDTO.setEndRow(endRow);

		// 현재 페이지에 보여줄 LOT 이력 목록을 DB에서 조회한다.
		List<LotDTO> list = lotService.selectLotHistoryList(lotDTO);

		// 기존 공통 JSP 구조에 맞춘 목록 변수명이다.
		model.addAttribute("list", list);

		// 기존 공통 JSP 구조에 맞춘 페이징 정보이다.
		model.addAttribute("pageInfo", pageInfo);

		// 기존 공통 paging.jsp에서 사용할 URL이다.
		model.addAttribute("pageUrl", "/lot/lothistory");

		// 검색 조건 유지용 값이다.
		model.addAttribute("progressStatus", lotDTO.getProgressStatus());
		model.addAttribute("searchType", lotDTO.getSearchType());
		model.addAttribute("keyword", lotDTO.getKeyword());
		model.addAttribute("startDate", lotDTO.getStartDate());
		model.addAttribute("endDate", lotDTO.getEndDate());

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "LOT 이력추적");

		// LOT 이력추적은 단독 메뉴라서 부제목은 비워둔다.
		model.addAttribute("headerSubTitle", "");

		// Tiles가 /WEB-INF/views/lot/lothistory.jsp를 찾도록 반환한다.
		return "lot/lothistory.tiles";
	}

	// LOT 이력추적 상세 화면이다.
	@RequestMapping("/lot/lothistory/detail")
	public String lotHistoryDetail(
			@RequestParam("orderId") Integer orderId,
			Model model) {

		// 작업지시 ID 기준으로 LOT 전체 이력을 조회한다.
		LotDTO lot = lotService.selectLotHistoryDetail(orderId);

		// 상세 JSP에서 사용할 LOT 이력 데이터이다.
		model.addAttribute("lot", lot);

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "LOT 이력추적");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "상세");

		// Tiles가 /WEB-INF/views/lot/lothistorydetail.jsp를 찾도록 반환한다.
		return "lot/lothistorydetail.tiles";
	}
}