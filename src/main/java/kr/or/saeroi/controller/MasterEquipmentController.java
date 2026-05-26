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
import kr.or.saeroi.dto.LineDTO;
import kr.or.saeroi.dto.MasterEquipmentDTO;
import kr.or.saeroi.service.MasterEquipmentService;

/**
 * 기준관리 > 설비관리 Controller
 *
 * 기준:
 * - 사이드바의 다른 설비관리 업무 메뉴와 충돌하지 않도록 MasterEquipment 명칭 사용
 * - URL은 기준관리 메뉴 기준으로 /master/equipment 사용
 * - 품목관리 ItemController 구조 중심 적용
 * - ServiceImpl 사용 안 함
 * - 목록 기본 5개씩 보기
 * - PC 컬럼: 체크박스 포함 8개
 * - 모바일 컬럼: 체크박스 포함 5개
 * - 설비구분은 고정값이 아니므로 기존 prefix 선택 + 신규 prefix 직접입력 가능
 */
@Controller
@RequestMapping("/master")
public class MasterEquipmentController {

    @Autowired
    private MasterEquipmentService masterEquipmentService;


    // =========================================================
    // 1. 설비 목록 / 상세
    // =========================================================

    /**
     * 기준관리 > 설비관리 목록 화면
     *
     * 요청 주소:
     * - GET /master/equipment
     */
    @RequestMapping(value = "/equipment", method = RequestMethod.GET)
    public String masterEquipmentList(
            @ModelAttribute MasterEquipmentDTO masterEquipmentDTO,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size,
            Model model) {

        // 목록 개수 기준 보정
        if (size != 5 && size != 10 && size != 20 && size != 30) {
            size = 5;
        }

        // 페이지 번호 보정
        if (page < 1) {
            page = 1;
        }

        /*
         * 품목관리 기준:
         * - Service/DAO는 검색조건에 맞는 전체 목록 조회
         * - Controller에서 현재 페이지에 보여줄 목록만 잘라냄
         */
        List<MasterEquipmentDTO> allMasterEquipmentList =
                masterEquipmentService.getMasterEquipmentList(masterEquipmentDTO);

        if (allMasterEquipmentList == null) {
            allMasterEquipmentList = Collections.emptyList();
        }

        int masterEquipmentCount =
                masterEquipmentService.getMasterEquipmentCount(masterEquipmentDTO);

        if (masterEquipmentCount < 0) {
            masterEquipmentCount = 0;
        }

        // 전체 페이지 수
        int totalPage = (int) Math.ceil((double) masterEquipmentCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        // 요청 page가 마지막 페이지보다 크면 마지막 페이지로 보정
        if (page > totalPage) {
            page = totalPage;
        }

        // 현재 페이지 목록 추출
        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allMasterEquipmentList.size());

        List<MasterEquipmentDTO> masterEquipmentList = Collections.emptyList();

        if (fromIndex < allMasterEquipmentList.size()) {
            masterEquipmentList = allMasterEquipmentList.subList(fromIndex, toIndex);
        }

        // 페이지 블록 계산
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        Map<String, Object> pageInfo = new HashMap<String, Object>();
        pageInfo.put("page", page);
        pageInfo.put("size", size);
        pageInfo.put("totalCount", masterEquipmentCount);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("hasPrev", page > 1);
        pageInfo.put("hasNext", page < totalPage);
        pageInfo.put("prevPage", page - 1);
        pageInfo.put("nextPage", page + 1);

        // 등록 모달용 기준 데이터
        List<LineDTO> lineList = masterEquipmentService.getLineList();
        List<ClientDTO> clientList = masterEquipmentService.getClientList();
        List<String> equipCodePrefixList = masterEquipmentService.getEquipCodePrefixList();

        if (lineList == null) {
            lineList = Collections.emptyList();
        }

        if (clientList == null) {
            clientList = Collections.emptyList();
        }

        if (equipCodePrefixList == null) {
            equipCodePrefixList = Collections.emptyList();
        }

        // JSP 전달값
        model.addAttribute("masterEquipmentList", masterEquipmentList);
        model.addAttribute("masterEquipmentCount", masterEquipmentCount);
        model.addAttribute("masterEquipmentDTO", masterEquipmentDTO);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/master/equipment");

        model.addAttribute("lineList", lineList);
        model.addAttribute("clientList", clientList);
        model.addAttribute("equipCodePrefixList", equipCodePrefixList);

        return "master/masterEquipment.tiles";
    }


    /**
     * 기준관리 > 설비관리 상세 화면
     *
     * 요청 주소:
     * - GET /master/equipment/detail?equipId=1
     */
    @RequestMapping(value = "/equipment/detail", method = RequestMethod.GET)
    public String masterEquipmentDetail(
            @RequestParam("equipId") Integer equipId,
            Model model,
            RedirectAttributes rttr) {

        try {
            MasterEquipmentDTO masterEquipmentDetail =
                    masterEquipmentService.getMasterEquipmentDetail(equipId);

            List<LineDTO> lineList = masterEquipmentService.getLineList();
            List<ClientDTO> clientList = masterEquipmentService.getClientList();
            List<String> equipCodePrefixList = masterEquipmentService.getEquipCodePrefixList();

            if (lineList == null) {
                lineList = Collections.emptyList();
            }

            if (clientList == null) {
                clientList = Collections.emptyList();
            }

            if (equipCodePrefixList == null) {
                equipCodePrefixList = Collections.emptyList();
            }

            model.addAttribute("masterEquipmentDetail", masterEquipmentDetail);
            model.addAttribute("lineList", lineList);
            model.addAttribute("clientList", clientList);
            model.addAttribute("equipCodePrefixList", equipCodePrefixList);

            return "master/masterEquipmentDetail.tiles";

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/master/equipment";
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "설비 상세 조회 중 오류가 발생했습니다.");
            return "redirect:/master/equipment";
        }
    }


    // =========================================================
    // 2. 설비 등록 / 수정 / 선택삭제
    // =========================================================

    /**
     * 설비 등록 처리
     *
     * 요청 주소:
     * - POST /master/equipment/add
     */
    @RequestMapping(value = "/equipment/add", method = RequestMethod.POST)
    public String addMasterEquipment(
            @ModelAttribute MasterEquipmentDTO masterEquipmentDTO,
            RedirectAttributes rttr) {

        try {
            int result = masterEquipmentService.addMasterEquipment(masterEquipmentDTO);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "설비가 등록되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "설비 등록에 실패했습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "설비 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/master/equipment";
    }


    /**
     * 설비 수정 처리
     *
     * 요청 주소:
     * - POST /master/equipment/modify
     */
    @RequestMapping(value = "/equipment/modify", method = RequestMethod.POST)
    public String modifyMasterEquipment(
            @ModelAttribute MasterEquipmentDTO masterEquipmentDTO,
            RedirectAttributes rttr) {

        Integer equipId = masterEquipmentDTO.getEquipId();

        try {
            int result = masterEquipmentService.modifyMasterEquipment(masterEquipmentDTO);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "설비 정보가 수정되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "설비 수정에 실패했습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "설비 수정 중 오류가 발생했습니다.");
        }

        if (equipId == null || equipId <= 0) {
            return "redirect:/master/equipment";
        }

        return "redirect:/master/equipment/detail?equipId=" + equipId;
    }


    /**
     * 설비 선택 삭제 처리
     *
     * 요청 주소:
     * - POST /master/equipment/delete
     *
     * 처리:
     * - 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리
     */
    @RequestMapping(value = "/equipment/delete", method = RequestMethod.POST)
    public String deleteMasterEquipmentList(
            @RequestParam(value = "equipIdList", required = false) List<Integer> equipIdList,
            RedirectAttributes rttr) {

        try {
            int result = masterEquipmentService.deleteMasterEquipmentList(equipIdList);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "선택한 설비가 미사용 처리되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "선택된 설비가 없습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "설비 삭제 처리 중 오류가 발생했습니다.");
        }

        return "redirect:/master/equipment";
    }


    // =========================================================
    // 3. Ajax / 자동완성 / 자동생성
    // =========================================================

    /**
     * 거래처 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/equipment/clientAutoComplete?keyword=검색어
     */
    @ResponseBody
    @RequestMapping(value = "/equipment/clientAutoComplete", method = RequestMethod.GET)
    public List<ClientDTO> clientAutoComplete(
            @RequestParam(value = "keyword", defaultValue = "") String keyword) {

        return masterEquipmentService.getClientAutoComplete(keyword);
    }


    /**
     * 라인 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/equipment/lineAutoComplete?keyword=검색어
     */
    @ResponseBody
    @RequestMapping(value = "/equipment/lineAutoComplete", method = RequestMethod.GET)
    public List<LineDTO> lineAutoComplete(
            @RequestParam(value = "keyword", defaultValue = "") String keyword) {

        return masterEquipmentService.getLineAutoComplete(keyword);
    }


    /**
     * 다음 설비코드 자동생성
     *
     * 요청 주소:
     * - GET /master/equipment/nextCode?equipCodePrefix=EQ-CUT
     *
     * 신규 설비구분도 가능:
     * - GET /master/equipment/nextCode?equipCodePrefix=EQ-DRY
     * - GET /master/equipment/nextCode?equipCodePrefix=DRY
     */
    @ResponseBody
    @RequestMapping(value = "/equipment/nextCode", method = RequestMethod.GET)
    public String nextEquipCode(
            @RequestParam("equipCodePrefix") String equipCodePrefix) {

        try {
            return masterEquipmentService.getNextEquipCode(equipCodePrefix);
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        } catch (Exception e) {
            return "설비코드 자동생성 중 오류가 발생했습니다.";
        }
    }
}