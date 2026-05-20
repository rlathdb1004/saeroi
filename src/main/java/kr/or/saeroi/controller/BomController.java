package kr.or.saeroi.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.saeroi.dto.BomDTO;
import kr.or.saeroi.dto.BomDetailDTO;
import kr.or.saeroi.dto.ItemDTO;
import kr.or.saeroi.service.BomService;

/**
 * BOM 관리 Controller
 *
 * 역할:
 * - 기준정보관리 > BOM관리 화면 요청을 처리한다.
 * - BOM 목록 조회, 상세 조회, 등록, 수정, 선택삭제를 담당한다.
 * - BOM 상세 구성자재 등록/수정/삭제를 담당한다.
 * - 완제품/자재 자동완성 Ajax 요청을 처리한다.
 *
 * 프로젝트 기준:
 * - 품목관리 Controller 구조와 동일하게 작성한다.
 * - 공용 paging.jsp는 수정하지 않고 pageInfo/pageUrl을 전달한다.
 */
@Controller
@RequestMapping("/master")
public class BomController {

	@Autowired
	private BomService bomService;


	// =========================================================
	// 1. BOM 목록 / 상세
	// =========================================================

	/**
	 * BOM 목록 화면
	 *
	 * 요청 주소:
	 * - GET /master/bom
	 *
	 * 화면 기준:
	 * - 검색조건 유지
	 * - 공용 paging.jsp 사용
	 * - Controller에서 pageInfo 생성
	 */
	@RequestMapping(value = "/bom", method = RequestMethod.GET)
	public String bomList(
			@ModelAttribute BomDTO bomDTO,
			@RequestParam(value = "page", required = false) Integer pageParam,
			@RequestParam(value = "size", required = false) Integer sizeParam,
			HttpSession session,
			Model model) {

		// =========================================================
		// 1. page / size 기본값 보정
		// =========================================================

		int page = 1;
		int size = 10;

		if (pageParam != null) {
			page = pageParam;
		}

		if (sizeParam != null) {
			size = sizeParam;
		}

		if (page < 1) {
			page = 1;
		}

		if (size != 5 && size != 10 && size != 20 && size != 30) {
			size = 10;
		}


		// =========================================================
		// 2. 검색조건 유지 처리
		// 공용 paging.jsp는 page, size만 넘기므로 검색조건을 session에 보관한다.
		// =========================================================

		String searchType = bomDTO.getSearchType();
		String searchKeyword = bomDTO.getSearchKeyword();

		boolean hasSearchType = searchType != null && searchType.trim().length() > 0;
		boolean hasSearchKeyword = searchKeyword != null && searchKeyword.trim().length() > 0;
		boolean hasSearchCondition = hasSearchType || hasSearchKeyword;

		boolean isPagingMove = pageParam != null;

		if (hasSearchCondition) {
			// 검색 버튼을 누른 경우 검색조건 저장
			session.setAttribute("bomSearchType", searchType);
			session.setAttribute("bomSearchKeyword", searchKeyword);

		} else if (isPagingMove) {
			// 페이징 이동 시 기존 검색조건 복원
			String savedSearchType = (String) session.getAttribute("bomSearchType");
			String savedSearchKeyword = (String) session.getAttribute("bomSearchKeyword");

			bomDTO.setSearchType(savedSearchType);
			bomDTO.setSearchKeyword(savedSearchKeyword);

		} else {
			// /master/bom 으로 새로 진입한 경우 검색조건 초기화
			session.removeAttribute("bomSearchType");
			session.removeAttribute("bomSearchKeyword");
		}


		// =========================================================
		// 3. 목록 조회
		// 현재 품목관리와 동일하게 전체 조회 후 Controller에서 잘라낸다.
		// =========================================================

		List<BomDTO> allBomList = bomService.getBomList(bomDTO);

		if (allBomList == null) {
			allBomList = Collections.emptyList();
		}

		int bomCount = allBomList.size();


		// =========================================================
		// 4. 페이징 계산
		// 공용 paging.jsp가 사용하는 pageInfo 필드명에 맞춘다.
		// =========================================================

		int totalPage = (int) Math.ceil((double) bomCount / size);

		if (totalPage < 1) {
			totalPage = 1;
		}

		if (page > totalPage) {
			page = totalPage;
		}

		int fromIndex = (page - 1) * size;
		int toIndex = Math.min(fromIndex + size, bomCount);

		List<BomDTO> bomList = Collections.emptyList();

		if (fromIndex < bomCount) {
			bomList = allBomList.subList(fromIndex, toIndex);
		}

		int blockSize = 5;
		int startPage = ((page - 1) / blockSize) * blockSize + 1;
		int endPage = Math.min(startPage + blockSize - 1, totalPage);

		Map<String, Object> pageInfo = new HashMap<String, Object>();

		pageInfo.put("page", page);
		pageInfo.put("size", size);
		pageInfo.put("totalCount", bomCount);
		pageInfo.put("totalPage", totalPage);
		pageInfo.put("startPage", startPage);
		pageInfo.put("endPage", endPage);
		pageInfo.put("hasPrev", page > 1);
		pageInfo.put("hasNext", page < totalPage);
		pageInfo.put("prevPage", page - 1);
		pageInfo.put("nextPage", page + 1);


		// =========================================================
		// 5. JSP 전달
		// =========================================================

		model.addAttribute("bomList", bomList);
		model.addAttribute("bomCount", bomCount);
		model.addAttribute("bomDTO", bomDTO);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/master/bom");

		return "master/bom.tiles";
	}


	/**
	 * BOM 상세 화면
	 *
	 * 요청 주소:
	 * - GET /master/bom/detail?bomId=1
	 */
	@RequestMapping(value = "/bom/detail", method = RequestMethod.GET)
	public String bomDetail(
			@RequestParam("bomId") int bomId,
			Model model) {

		BomDTO bomDetail = bomService.getBomDetail(bomId);

		model.addAttribute("bomDetail", bomDetail);

		return "master/bomDetail.tiles";
	}


	// =========================================================
	// 2. BOM 마스터 등록 / 수정 / 선택삭제
	// =========================================================

	/**
	 * BOM 등록 처리
	 *
	 * 요청 주소:
	 * - POST /master/bom/add
	 */
	@RequestMapping(value = "/bom/add", method = RequestMethod.POST)
	public String addBom(
			@ModelAttribute BomDTO bomDTO,
			RedirectAttributes rttr) {

		int result = bomService.addBom(bomDTO);

		if (result == -3) {
			rttr.addFlashAttribute("msg", "이미 해당 완제품에 등록된 BOM이 있습니다.");
		} else if (result == -2) {
			rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
		} else if (result == -1) {
			rttr.addFlashAttribute("msg", "이미 등록된 BOM코드입니다.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "BOM이 등록되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "BOM 등록에 실패했습니다.");
		}

		return "redirect:/master/bom";
	}


	/**
	 * BOM 수정 처리
	 *
	 * 요청 주소:
	 * - POST /master/bom/modify
	 */
	@RequestMapping(value = "/bom/modify", method = RequestMethod.POST)
	public String modifyBom(
			@ModelAttribute BomDTO bomDTO,
			RedirectAttributes rttr) {

		int result = bomService.modifyBom(bomDTO);

		if (result == -3) {
			rttr.addFlashAttribute("msg", "이미 해당 완제품에 등록된 다른 BOM이 있습니다.");
		} else if (result == -2) {
			rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
		} else if (result == -1) {
			rttr.addFlashAttribute("msg", "이미 등록된 BOM코드입니다.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "BOM이 수정되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "BOM 수정에 실패했습니다.");
		}

		if (bomDTO.getBomId() != null) {
			return "redirect:/master/bom/detail?bomId=" + bomDTO.getBomId();
		}

		return "redirect:/master/bom";
	}


	/**
	 * BOM 선택 삭제 처리
	 *
	 * 요청 주소:
	 * - POST /master/bom/delete
	 *
	 * 처리 방식:
	 * - 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리
	 */
	@RequestMapping(value = "/bom/delete", method = RequestMethod.POST)
	public String deleteBomList(
			@RequestParam(value = "bomIdList", required = false) List<Integer> bomIdList,
			RedirectAttributes rttr) {

		int result = bomService.removeBomList(bomIdList);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "선택한 BOM이 미사용 처리되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "선택된 BOM이 없습니다.");
		}

		return "redirect:/master/bom";
	}


	// =========================================================
	// 3. BOM 상세 구성자재 등록 / 수정 / 삭제
	// =========================================================

	/**
	 * BOM 상세 구성자재 추가
	 *
	 * 요청 주소:
	 * - POST /master/bom/detail/add
	 */
	@RequestMapping(value = "/bom/detail/add", method = RequestMethod.POST)
	public String addBomDetail(
			@ModelAttribute BomDetailDTO bomDetailDTO,
			RedirectAttributes rttr) {

		int result = bomService.addBomDetail(bomDetailDTO);

		if (result == -2) {
			rttr.addFlashAttribute("msg", "구성자재 필수 입력값을 확인하세요.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "구성자재가 추가되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "구성자재 추가에 실패했습니다.");
		}

		if (bomDetailDTO.getBomId() != null) {
			return "redirect:/master/bom/detail?bomId=" + bomDetailDTO.getBomId();
		}

		return "redirect:/master/bom";
	}


	/**
	 * BOM 상세 구성자재 수정
	 *
	 * 요청 주소:
	 * - POST /master/bom/detail/modify
	 */
	@RequestMapping(value = "/bom/detail/modify", method = RequestMethod.POST)
	public String modifyBomDetail(
			@ModelAttribute BomDetailDTO bomDetailDTO,
			RedirectAttributes rttr) {

		int result = bomService.modifyBomDetail(bomDetailDTO);

		if (result == -2) {
			rttr.addFlashAttribute("msg", "구성자재 필수 입력값을 확인하세요.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "구성자재가 수정되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "구성자재 수정에 실패했습니다.");
		}

		if (bomDetailDTO.getBomId() != null) {
			return "redirect:/master/bom/detail?bomId=" + bomDetailDTO.getBomId();
		}

		return "redirect:/master/bom";
	}


	/**
	 * BOM 상세 구성자재 삭제
	 *
	 * 요청 주소:
	 * - POST /master/bom/detail/delete
	 */
	@RequestMapping(value = "/bom/detail/delete", method = RequestMethod.POST)
	public String deleteBomDetail(
			@RequestParam("bomId") int bomId,
			@RequestParam("bomDetailId") int bomDetailId,
			RedirectAttributes rttr) {

		int result = bomService.removeBomDetail(bomDetailId);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "구성자재가 삭제되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "구성자재 삭제에 실패했습니다.");
		}

		return "redirect:/master/bom/detail?bomId=" + bomId;
	}


	// =========================================================
	// 4. Ajax / 자동완성
	// =========================================================

	/**
	 * BOM 등록용 완제품 자동완성
	 *
	 * 요청 주소:
	 * - GET /master/bom/productAutoComplete?keyword=아이오닉
	 */
	@ResponseBody
	@RequestMapping(value = "/bom/productAutoComplete", method = RequestMethod.GET)
	public List<ItemDTO> productItemAutoComplete(
			@RequestParam(value = "keyword", required = false) String keyword) {

		return bomService.getProductItemAutoComplete(keyword);
	}


	/**
	 * BOM 상세 구성자재 자동완성
	 *
	 * 요청 주소:
	 * - GET /master/bom/materialAutoComplete?keyword=EPDM
	 */
	@ResponseBody
	@RequestMapping(value = "/bom/materialAutoComplete", method = RequestMethod.GET)
	public List<ItemDTO> materialItemAutoComplete(
			@RequestParam(value = "keyword", required = false) String keyword) {

		return bomService.getMaterialItemAutoComplete(keyword);
	}


	/**
	 * 품목 ID 기준 품목 조회
	 *
	 * 요청 주소:
	 * - GET /master/bom/item?itemId=1001
	 */
	@ResponseBody
	@RequestMapping(value = "/bom/item", method = RequestMethod.GET)
	public ItemDTO getItemById(
			@RequestParam("itemId") int itemId) {

		return bomService.getItemById(itemId);
	}
}