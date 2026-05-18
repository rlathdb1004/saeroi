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
			@RequestParam(value = "size", defaultValue = "10") int size,
			@RequestParam(value = "searchType", defaultValue = "") String searchType,
			@RequestParam(value = "inoutType", defaultValue = "") String inoutType,
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate,
			Model model) {

		// 입출고 전체 목록 조회
		List<InoutDTO> list = service.getInoutList(
				searchType,
				inoutType,
				keyword,
				startDate,
				endDate);

		// 페이징 기능
		int totalCount = list.size();

		int startIndex = (page - 1) * size;

		int endIndex = startIndex + size;

		if (endIndex > totalCount) {
			endIndex = totalCount;
		}

		// 현재 페이지 목록
		List<InoutDTO> page_list =
				list.subList(startIndex, endIndex);

		// 페이징 정보
		PageDTO pageInfo =
				new PageDTO(page, size, totalCount);

		// 등록 모달 품목 목록
		List<InoutDTO> itemList =
				service.getItemList();

		// JSP로 보낼 값
		model.addAttribute("list", page_list);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/inventory/materialIn");

		// 검색값 유지
		model.addAttribute("searchType", searchType);
		model.addAttribute("inoutType", inoutType);
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

	// 선택 삭제
	@RequestMapping("/inventory/materialIn/delete")
	public String deleteInout(
			@RequestParam(value = "inoutIds", required = false) String[] inoutIds) {

		// 선택한 값이 있을 때만 삭제
		if (inoutIds != null) {
			service.removeInout(inoutIds);
		}

		// 삭제 후 목록으로 이동
		return "redirect:/inventory/materialIn";
	}

	// 상세보기 페이지
	@RequestMapping("/inventory/materialIn/detail")
	public String inoutDetail(
			@RequestParam("inoutId") int inoutId,
			@RequestParam(value = "mode", defaultValue = "view") String mode,
			Model model) {

		// 상세 조회
		InoutDTO inout =
				service.getInoutDetail(inoutId);

		// JSP로 보낼 값
		model.addAttribute("inout", inout);

		// view면 조회 화면, edit면 수정 화면
		model.addAttribute("mode", mode);

		// Tiles 주소
		return "inoutDetail.tiles";
	}

	// 입출고 수정
	@RequestMapping("/inventory/materialIn/update")
	public String updateInout(
			@RequestParam("inoutId") int inoutId,
			@RequestParam("inoutType") String inoutType,
			@RequestParam("inoutQty") int inoutQty,
			@RequestParam("inoutDate") String inoutDate,
			@RequestParam(value = "remark", defaultValue = "") String remark) {

		InoutDTO dto = new InoutDTO();

		// 수정할 값 담기
		dto.setInoutId(inoutId);
		dto.setInoutType(inoutType);
		dto.setInoutQty(inoutQty);
		dto.setInoutDate(Date.valueOf(inoutDate));
		dto.setRemark(remark);

		// DB 수정
		service.modifyInout(dto);

		// 수정 후 상세보기로 이동
		return "redirect:/inventory/materialIn/detail?inoutId=" + inoutId;
	}
}