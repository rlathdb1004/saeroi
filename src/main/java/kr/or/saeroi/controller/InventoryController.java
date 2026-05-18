package kr.or.saeroi.controller;

import java.sql.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.InoutDTO;
import kr.or.saeroi.service.InoutService;
import kr.or.saeroi.service.InoutServiceImpl;

// 자재/재고 Controller
@Controller
public class InventoryController {

	private InoutService service = new InoutServiceImpl();

	// 자재입고관리 클릭 시 입출고관리 화면
	@RequestMapping("/inventory/materialIn")
	public String materialIn(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "searchType", defaultValue = "all") String searchType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			Model model) {

		int size = 10;

		// 전체 개수 조회
		int totalCount = service.getInoutCount(
				searchType,
				keyword,
				startDate,
				endDate);

		// 페이징 정보 만들기
		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		// 시작 번호
		int startRow = (page - 1) * size + 1;

		// 끝 번호
		int endRow = page * size;

		// 목록 조회
		List<InoutDTO> list = service.getInoutList(
				startRow,
				endRow,
				searchType,
				keyword,
				startDate,
				endDate);

		// 등록 모달 품목 목록
		List<InoutDTO> itemList = service.getItemList();

		// JSP로 보낼 값
		model.addAttribute("list", list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		// 검색값 유지
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		// Tiles 주소
		return "inoutManage.tiles";
	}

	// 입출고 등록
	@RequestMapping("/inventory/materialIn/insert")
	public String insertInout(
			@RequestParam("itemId") int itemId,
			@RequestParam("inoutType") String inoutType,
			@RequestParam("inoutQty") int inoutQty,
			@RequestParam("inoutDate") String inoutDate,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InoutDTO dto = new InoutDTO();

		// 입력값 DTO에 담기
		dto.setItemId(itemId);
		dto.setInoutType(inoutType);
		dto.setInoutQty(inoutQty);
		dto.setInoutDate(Date.valueOf(inoutDate));
		dto.setRemark(remark);

		// DB 저장
		service.addInout(dto);

		// 저장 후 목록으로 이동
		return "redirect:/inventory/materialIn";
	}

	// 상세보기 페이지
	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			Model model) {

		// 상세 조회
		InoutDTO inout = service.getInoutDetail(inoutId);

		// JSP로 보낼 값
		model.addAttribute("inout", inout);

		// Tiles 주소
		return "inoutDetail.tiles";
	}
}