package kr.or.saeroi.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.saeroi.dto.ClientDTO;
import kr.or.saeroi.dto.ItemDTO;
import kr.or.saeroi.service.ItemService;

/**
 * 품목관리 Controller
 *
 * 역할:
 * - 기준정보관리 > 품목관리 화면의 요청을 처리한다.
 * - 목록 조회, 상세 조회, 등록, 수정, 선택삭제를 담당한다.
 * - 공급처/납품처 자동완성 Ajax 요청을 처리한다.
 * - 품목코드 자동생성 Ajax 요청을 처리한다.
 */
@Controller
@RequestMapping("/master")
public class ItemController {

	@Autowired
	private ItemService itemService;

	// =========================================================
	// 1. 품목 목록 / 상세
	// =========================================================

	/**
	 * 품목관리 목록 화면
	 *
	 * 요청 주소:
	 * - GET /master/item
	 */
	@RequestMapping(value = "/item", method = RequestMethod.GET)
	public String itemList(
			@ModelAttribute ItemDTO itemDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "10") int size,
			Model model) {

		// 허용하지 않는 size 값이 들어오면 기본값으로 보정
		if (size != 5 && size != 10 && size != 20 && size != 30) {
			size = 10;
		}

		// 1보다 작은 페이지가 들어오면 1페이지로 보정
		if (page < 1) {
			page = 1;
		}

		// 현재 Service/DAO는 page, size를 받지 않으므로 전체 목록 조회 후 Controller에서 잘라낸다.
		List<ItemDTO> allItemList = itemService.getItemList(itemDTO);

		if (allItemList == null) {
			allItemList = Collections.emptyList();
		}

		// 검색조건에 맞는 품목 총 건수 조회
		int itemCount = itemService.getItemCount(itemDTO);

		if (itemCount < 0) {
			itemCount = 0;
		}

		// 전체 페이지 수 계산
		int totalPage = (int) Math.ceil((double) itemCount / size);

		if (totalPage < 1) {
			totalPage = 1;
		}

		// 마지막 페이지보다 큰 값이 들어오면 마지막 페이지로 보정
		if (page > totalPage) {
			page = totalPage;
		}

		// 현재 페이지에 보여줄 목록만 추출
		int fromIndex = (page - 1) * size;
		int toIndex = Math.min(fromIndex + size, allItemList.size());

		List<ItemDTO> itemList = Collections.emptyList();

		if (fromIndex < allItemList.size()) {
			itemList = allItemList.subList(fromIndex, toIndex);
		}

		// 페이지 번호 블록 계산
		int blockSize = 5;
		int startPage = ((page - 1) / blockSize) * blockSize + 1;
		int endPage = Math.min(startPage + blockSize - 1, totalPage);

		Map<String, Object> pageInfo = new HashMap<String, Object>();
		pageInfo.put("page", page);
		pageInfo.put("size", size);
		pageInfo.put("totalCount", itemCount);
		pageInfo.put("totalPage", totalPage);
		pageInfo.put("startPage", startPage);
		pageInfo.put("endPage", endPage);
		pageInfo.put("hasPrev", page > 1);
		pageInfo.put("hasNext", page < totalPage);
		pageInfo.put("prevPage", page - 1);
		pageInfo.put("nextPage", page + 1);

		// JSP 전달값
		model.addAttribute("itemList", itemList);
		model.addAttribute("itemCount", itemCount);
		model.addAttribute("itemDTO", itemDTO);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/master/item");

		return "master/item.tiles";
	}

	/**
	 * 품목 상세보기 화면
	 *
	 * 요청 주소:
	 * - GET /master/item/detail?itemId=1001
	 */
	@RequestMapping(value = "/item/detail", method = RequestMethod.GET)
	public String itemDetail(@RequestParam("itemId") int itemId, Model model) {

		ItemDTO itemDetail = itemService.getItemDetail(itemId);

		model.addAttribute("itemDetail", itemDetail);

		return "master/itemDetail.tiles";
	}

	// =========================================================
	// 2. 품목 등록 / 수정 / 선택삭제
	// =========================================================

	/**
	 * 품목 등록 처리
	 *
	 * 요청 주소:
	 * - POST /master/item/add
	 */
	@RequestMapping(value = "/item/add", method = RequestMethod.POST)
	public String addItem(@ModelAttribute ItemDTO itemDTO, RedirectAttributes rttr) {

		int result = itemService.addItem(itemDTO);

		if (result == -2) {
			rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
		} else if (result == -1) {
			rttr.addFlashAttribute("msg", "이미 등록된 품목코드입니다.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "품목이 등록되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "품목 등록에 실패했습니다.");
		}

		return "redirect:/master/item";
	}

	/**
	 * 품목 수정 처리
	 *
	 * 요청 주소:
	 * - POST /master/item/modify
	 */
	@RequestMapping(value = "/item/modify", method = RequestMethod.POST)
	public String modifyItem(@ModelAttribute ItemDTO itemDTO, RedirectAttributes rttr) {

		int result = itemService.modifyItem(itemDTO);

		if (result == -2) {
			rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
		} else if (result == -1) {
			rttr.addFlashAttribute("msg", "이미 등록된 품목코드입니다.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "품목이 수정되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "품목 수정에 실패했습니다.");
		}

		return "redirect:/master/item";
	}

	/**
	 * 품목 선택 삭제 처리
	 *
	 * 요청 주소:
	 * - POST /master/item/delete
	 */
	@RequestMapping(value = "/item/delete", method = RequestMethod.POST)
	public String deleteItemList(
			@RequestParam(value = "itemIdList", required = false) List<Integer> itemIdList,
			RedirectAttributes rttr) {

		int result = itemService.removeItemList(itemIdList);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "선택한 품목이 미사용 처리되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "선택된 품목이 없습니다.");
		}

		return "redirect:/master/item";
	}

	// =========================================================
	// 3. Ajax / 자동완성 / 자동생성
	// =========================================================

	/**
	 * 거래처 자동완성 조회
	 *
	 * 요청 주소:
	 * - GET /master/item/clientAutoComplete
	 */
	@ResponseBody
	@RequestMapping(value = "/item/clientAutoComplete", method = RequestMethod.GET)
	public List<ClientDTO> clientAutoComplete(
			@RequestParam("clientType") String clientType,
			@RequestParam("keyword") String keyword) {

		return itemService.getClientAutoComplete(clientType, keyword);
	}

	/**
	 * 다음 품목코드 자동생성
	 *
	 * 요청 주소:
	 * - GET /master/item/nextCode
	 */
	@ResponseBody
	@RequestMapping(value = "/item/nextCode", method = RequestMethod.GET)
	public String nextItemCode(@RequestParam("itemCodePrefix") String itemCodePrefix) {

		return itemService.getNextItemCode(itemCodePrefix);
	}
}