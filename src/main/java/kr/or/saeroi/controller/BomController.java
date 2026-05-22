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

import kr.or.saeroi.dto.BomDTO;
import kr.or.saeroi.dto.BomDetailDTO;
import kr.or.saeroi.dto.ItemDTO;
import kr.or.saeroi.service.BomService;

/**
 * BOM관리 Controller
 *
 * 역할:
 * - 기준정보관리 > BOM관리 화면의 요청을 처리한다.
 * - 목록 조회, 상세 조회, 등록, 수정, 선택삭제를 담당한다.
 * - 완제품/자재 자동완성 Ajax 요청을 처리한다.
 * - BOM코드와 BOM버전 자동생성 Ajax 요청을 처리한다.
 *
 * 기준:
 * - 품목관리 ItemController 구조 기준
 * - 상위 URL: /master
 * - ServiceImpl 사용 안 함
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
     * BOM관리 목록 화면
     *
     * 요청 주소:
     * - GET /master/bom
     */
    @RequestMapping(value = "/bom", method = RequestMethod.GET)
    public String bomList(
            @ModelAttribute BomDTO bomDTO,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size,
            Model model) {

        // 허용하지 않는 size 값이 들어오면 기본값으로 보정
        if (size != 5 && size != 10 && size != 20 && size != 30) {
            size = 5;
        }

        // 1보다 작은 페이지가 들어오면 1페이지로 보정
        if (page < 1) {
            page = 1;
        }

        /*
         * 품목관리 기준:
         * 현재 Service/DAO는 page, size를 받지 않으므로
         * 전체 목록 조회 후 Controller에서 현재 페이지 목록만 잘라낸다.
         */
        List<BomDTO> allBomList = bomService.getBomList(bomDTO);

        if (allBomList == null) {
            allBomList = Collections.emptyList();
        }

        // 검색조건에 맞는 BOM 총 건수 조회
        int bomCount = bomService.getBomCount(bomDTO);

        if (bomCount < 0) {
            bomCount = 0;
        }

        // 전체 페이지 수 계산
        int totalPage = (int) Math.ceil((double) bomCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        // 마지막 페이지보다 큰 값이 들어오면 마지막 페이지로 보정
        if (page > totalPage) {
            page = totalPage;
        }

        // 현재 페이지에 보여줄 목록만 추출
        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allBomList.size());

        List<BomDTO> bomList = Collections.emptyList();

        if (fromIndex < allBomList.size()) {
            bomList = allBomList.subList(fromIndex, toIndex);
        }

        // 페이지 번호 블록 계산
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

        // 등록 모달에서 사용할 완제품/자재 후보 목록
        List<ItemDTO> productItemList = bomService.getProductItemList();
        List<ItemDTO> materialItemList = bomService.getMaterialItemList();

        // JSP 전달값
        model.addAttribute("bomList", bomList);
        model.addAttribute("bomCount", bomCount);
        model.addAttribute("bomDTO", bomDTO);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/master/bom");

        model.addAttribute("productItemList", productItemList);
        model.addAttribute("materialItemList", materialItemList);

        return "master/bom.tiles";
    }


    /**
     * BOM 상세보기 화면
     *
     * 요청 주소:
     * - GET /master/bom/detail?bomId=1
     */
    @RequestMapping(value = "/bom/detail", method = RequestMethod.GET)
    public String bomDetail(
            @RequestParam("bomId") int bomId,
            Model model,
            RedirectAttributes rttr) {

        BomDTO bomDetail = bomService.getBomDetailWithItems(bomId);

        if (bomDetail == null) {
            rttr.addFlashAttribute("msg", "조회된 BOM 정보가 없습니다.");
            return "redirect:/master/bom";
        }

        List<BomDetailDTO> bomDetailList = bomDetail.getBomDetailList();

        if (bomDetailList == null) {
            bomDetailList = Collections.emptyList();
        }

        List<ItemDTO> materialItemList = bomService.getMaterialItemList();

        model.addAttribute("bomDetail", bomDetail);
        model.addAttribute("bomDetailList", bomDetailList);
        model.addAttribute("materialItemList", materialItemList);

        return "master/bomDetail.tiles";
    }


    // =========================================================
    // 2. BOM 등록 / 수정 / 선택삭제
    // =========================================================

    /**
     * BOM 등록 처리
     *
     * 요청 주소:
     * - POST /master/bom/add
     *
     * 처리:
     * - BOM 마스터 1건 등록
     * - BOM 상세 구성품 N건 등록
     *
     * JSP input name 기준:
     * - detailItemIds
     * - detailQtys
     * - detailRemarks
     */
    @RequestMapping(value = "/bom/add", method = RequestMethod.POST)
    public String addBom(
            @ModelAttribute BomDTO bomDTO,
            @RequestParam(value = "detailItemIds", required = false) Integer[] detailItemIds,
            @RequestParam(value = "detailQtys", required = false) Double[] detailQtys,
            @RequestParam(value = "detailRemarks", required = false) String[] detailRemarks,
            RedirectAttributes rttr) {

        List<BomDetailDTO> bomDetailList = bomService.makeBomDetailList(
                detailItemIds,
                detailQtys,
                detailRemarks
        );

        int result = bomService.addBom(bomDTO, bomDetailList);

        if (result == -2) {
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
     * BOM 기본정보 수정 처리
     *
     * 요청 주소:
     * - POST /master/bom/modify
     *
     * 사용 위치:
     * - 상세 화면에서 BOM 마스터 기본정보만 수정할 때
     */
    @RequestMapping(value = "/bom/modify", method = RequestMethod.POST)
    public String modifyBom(
            @ModelAttribute BomDTO bomDTO,
            RedirectAttributes rttr) {

        int result = bomService.modifyBom(bomDTO);

        if (result == -2) {
            rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
        } else if (result == -1) {
            rttr.addFlashAttribute("msg", "이미 등록된 BOM코드입니다.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "BOM 정보가 수정되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "BOM 수정에 실패했습니다.");
        }

        return "redirect:/master/bom/detail?bomId=" + bomDTO.getBomId();
    }


    /**
     * BOM 기본정보 + 구성품 전체 수정 처리
     *
     * 요청 주소:
     * - POST /master/bom/detail/modify
     *
     * 처리:
     * - BOM 마스터 수정
     * - 기존 BOM 상세 구성품 전체 삭제
     * - 화면에서 넘어온 구성품 N건 재등록
     *
     * JSP input name 기준:
     * - detailItemIds
     * - detailQtys
     * - detailRemarks
     */
    @RequestMapping(value = "/bom/detail/modify", method = RequestMethod.POST)
    public String modifyBomWithDetails(
            @ModelAttribute BomDTO bomDTO,
            @RequestParam(value = "detailItemIds", required = false) Integer[] detailItemIds,
            @RequestParam(value = "detailQtys", required = false) Double[] detailQtys,
            @RequestParam(value = "detailRemarks", required = false) String[] detailRemarks,
            RedirectAttributes rttr) {

        List<BomDetailDTO> bomDetailList = bomService.makeBomDetailList(
                detailItemIds,
                detailQtys,
                detailRemarks
        );

        int result = bomService.modifyBom(bomDTO, bomDetailList);

        if (result == -2) {
            rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
        } else if (result == -1) {
            rttr.addFlashAttribute("msg", "이미 등록된 BOM코드입니다.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "BOM 정보가 수정되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "BOM 수정에 실패했습니다.");
        }

        return "redirect:/master/bom/detail?bomId=" + bomDTO.getBomId();
    }


    /**
     * BOM 선택 삭제 처리
     *
     * 요청 주소:
     * - POST /master/bom/delete
     *
     * 처리:
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
    // 3. BOM 상세 구성품 등록 / 수정 / 선택삭제
    // =========================================================

    /**
     * BOM 상세 구성품 추가 처리
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
            rttr.addFlashAttribute("msg", "구성품 필수 입력값을 확인하세요.");
        } else if (result == -1) {
            rttr.addFlashAttribute("msg", "이미 등록된 구성품입니다.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "BOM 구성품이 추가되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "BOM 구성품 추가에 실패했습니다.");
        }

        return "redirect:/master/bom/detail?bomId=" + bomDetailDTO.getBomId();
    }


    /**
     * BOM 상세 구성품 단건 수정 처리
     *
     * 요청 주소:
     * - POST /master/bom/detail/item/modify
     */
    @RequestMapping(value = "/bom/detail/item/modify", method = RequestMethod.POST)
    public String modifyBomDetailItem(
            @ModelAttribute BomDetailDTO bomDetailDTO,
            RedirectAttributes rttr) {

        int result = bomService.modifyBomDetail(bomDetailDTO);

        if (result == -2) {
            rttr.addFlashAttribute("msg", "구성품 필수 입력값을 확인하세요.");
        } else if (result == -1) {
            rttr.addFlashAttribute("msg", "이미 등록된 구성품입니다.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "BOM 구성품이 수정되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "BOM 구성품 수정에 실패했습니다.");
        }

        return "redirect:/master/bom/detail?bomId=" + bomDetailDTO.getBomId();
    }


    /**
     * BOM 상세 구성품 선택 삭제 처리
     *
     * 요청 주소:
     * - POST /master/bom/detail/delete
     *
     * 처리:
     * - bom_detail 테이블에는 use_yn 컬럼이 없으므로 물리 DELETE 처리
     */
    @RequestMapping(value = "/bom/detail/delete", method = RequestMethod.POST)
    public String deleteBomDetailList(
            @RequestParam("bomId") int bomId,
            @RequestParam(value = "bomDetailIdList", required = false) List<Integer> bomDetailIdList,
            RedirectAttributes rttr) {

        int result = bomService.removeBomDetailList(bomDetailIdList);

        if (result > 0) {
            rttr.addFlashAttribute("msg", "선택한 구성품이 삭제되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "선택된 구성품이 없습니다.");
        }

        return "redirect:/master/bom/detail?bomId=" + bomId;
    }


    // =========================================================
    // 4. Ajax / 자동완성 / 자동생성
    // =========================================================

    /**
     * 완제품 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/bom/productAutoComplete
     *
     * 대상:
     * - item_type = 'FG'
     */
    @ResponseBody
    @RequestMapping(value = "/bom/productAutoComplete", method = RequestMethod.GET)
    public List<ItemDTO> productAutoComplete(
            @RequestParam("keyword") String keyword) {

        return bomService.getProductItemAutoComplete(keyword);
    }


    /**
     * 자재/부자재 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/bom/materialAutoComplete
     *
     * 대상:
     * - item_type IN ('RM', 'SM')
     */
    @ResponseBody
    @RequestMapping(value = "/bom/materialAutoComplete", method = RequestMethod.GET)
    public List<ItemDTO> materialAutoComplete(
            @RequestParam("keyword") String keyword) {

        return bomService.getMaterialItemAutoComplete(keyword);
    }


    /**
     * 다음 BOM코드 자동생성
     *
     * 요청 주소:
     * - GET /master/bom/nextCode?itemId=1001
     *
     * 예:
     * - BOM-FG-GSK-ION5-EPDM-001
     */
    @ResponseBody
    @RequestMapping(value = "/bom/nextCode", method = RequestMethod.GET)
    public String nextBomCode(
            @RequestParam("itemId") Integer itemId) {

        return bomService.getNextBomCode(itemId);
    }


    /**
     * 다음 BOM버전 자동조회
     *
     * 요청 주소:
     * - GET /master/bom/nextVersion?itemId=1001
     */
    @ResponseBody
    @RequestMapping(value = "/bom/nextVersion", method = RequestMethod.GET)
    public int nextBomVersion(
            @RequestParam("itemId") Integer itemId) {

        return bomService.getNextBomVersion(itemId);
    }
}