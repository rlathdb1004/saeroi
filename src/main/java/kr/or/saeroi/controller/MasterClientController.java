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

import kr.or.saeroi.dto.MasterClientDTO;
import kr.or.saeroi.service.MasterClientService;

/**
 * 기준관리 > 거래처관리 Controller
 *
 * 기준:
 * - 기존 ClientDTO / ClientDAO와 충돌 방지를 위해 MasterClient 명칭 사용
 * - URL은 기준관리 메뉴 기준으로 /master/client 사용
 * - 품목관리 ItemController 구조 중심 적용
 * - ServiceImpl 사용 안 함
 * - 목록 기본 5개씩 보기
 * - PC 컬럼: 체크박스 포함 8개
 * - 모바일 컬럼: 체크박스 포함 5개
 * - 실제 DELETE 대신 use_yn = 'N' 미사용 처리
 * - 거래처구분은 client_code prefix 기준으로 관리
 */
@Controller
@RequestMapping("/master")
public class MasterClientController {

    @Autowired
    private MasterClientService masterClientService;


    // =========================================================
    // 1. 거래처 목록 / 상세
    // =========================================================

    /**
     * 기준관리 > 거래처관리 목록 화면
     *
     * 요청 주소:
     * - GET /master/client
     */
    @RequestMapping(value = "/client", method = RequestMethod.GET)
    public String masterClientList(
            @ModelAttribute MasterClientDTO masterClientDTO,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size,
            Model model) {

        if (size != 5 && size != 10 && size != 20 && size != 30) {
            size = 5;
        }

        if (page < 1) {
            page = 1;
        }

        /*
         * 품목관리 기준:
         * - Service/DAO는 검색조건에 맞는 전체 목록 조회
         * - Controller에서 현재 페이지에 보여줄 목록만 잘라냄
         */
        List<MasterClientDTO> allMasterClientList =
                masterClientService.getMasterClientList(masterClientDTO);

        if (allMasterClientList == null) {
            allMasterClientList = Collections.emptyList();
        }

        int masterClientCount =
                masterClientService.getMasterClientCount(masterClientDTO);

        if (masterClientCount < 0) {
            masterClientCount = 0;
        }

        int totalPage = (int) Math.ceil((double) masterClientCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        if (page > totalPage) {
            page = totalPage;
        }

        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allMasterClientList.size());

        List<MasterClientDTO> masterClientList = Collections.emptyList();

        if (fromIndex < allMasterClientList.size()) {
            masterClientList = allMasterClientList.subList(fromIndex, toIndex);
        }

        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        Map<String, Object> pageInfo = new HashMap<String, Object>();
        pageInfo.put("page", page);
        pageInfo.put("size", size);
        pageInfo.put("totalCount", masterClientCount);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("hasPrev", page > 1);
        pageInfo.put("hasNext", page < totalPage);
        pageInfo.put("prevPage", page - 1);
        pageInfo.put("nextPage", page + 1);

        List<String> clientCodePrefixList =
                masterClientService.getClientCodePrefixList();

        if (clientCodePrefixList == null) {
            clientCodePrefixList = Collections.emptyList();
        }

        model.addAttribute("masterClientList", masterClientList);
        model.addAttribute("masterClientCount", masterClientCount);
        model.addAttribute("masterClientDTO", masterClientDTO);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/master/client");

        model.addAttribute("clientCodePrefixList", clientCodePrefixList);

        return "master/masterClient.tiles";
    }


    /**
     * 기준관리 > 거래처관리 상세 화면
     *
     * 요청 주소:
     * - GET /master/client/detail?clientId=1
     */
    @RequestMapping(value = "/client/detail", method = RequestMethod.GET)
    public String masterClientDetail(
            @RequestParam("clientId") Integer clientId,
            Model model,
            RedirectAttributes rttr) {

        try {
            MasterClientDTO masterClientDetail =
                    masterClientService.getMasterClientDetail(clientId);

            model.addAttribute("masterClientDetail", masterClientDetail);
            System.out.println("masterClientDetail"+masterClientDetail);
            return "master/masterClientDetail.tiles";

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/master/client";
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "거래처 상세 조회 중 오류가 발생했습니다.");
            return "redirect:/master/client";
        }
    }


    // =========================================================
    // 2. 거래처 등록 / 수정 / 선택삭제
    // =========================================================

    /**
     * 거래처 등록 처리
     *
     * 요청 주소:
     * - POST /master/client/add
     */
    @RequestMapping(value = "/client/add", method = RequestMethod.POST)
    public String addMasterClient(
            @ModelAttribute MasterClientDTO masterClientDTO,
            RedirectAttributes rttr) {

        try {
            int result = masterClientService.addMasterClient(masterClientDTO);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "거래처가 등록되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "거래처 등록에 실패했습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "거래처 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/master/client";
    }


    /**
     * 거래처 수정 처리
     *
     * 요청 주소:
     * - POST /master/client/modify
     */
    @RequestMapping(value = "/client/modify", method = RequestMethod.POST)
    public String modifyMasterClient(
            @ModelAttribute MasterClientDTO masterClientDTO,
            RedirectAttributes rttr) {

        Integer clientId = masterClientDTO.getClientId();

        try {
            int result = masterClientService.modifyMasterClient(masterClientDTO);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "거래처 정보가 수정되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "거래처 수정에 실패했습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "거래처 수정 중 오류가 발생했습니다.");
        }

        if (clientId == null || clientId <= 0) {
            return "redirect:/master/client";
        }

        return "redirect:/master/client/detail?clientId=" + clientId;
    }


    /**
     * 거래처 선택 삭제 처리
     *
     * 요청 주소:
     * - POST /master/client/delete
     *
     * 처리:
     * - 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리
     */
    @RequestMapping(value = "/client/delete", method = RequestMethod.POST)
    public String deleteMasterClientList(
            @RequestParam(value = "clientIdList", required = false) List<Integer> clientIdList,
            RedirectAttributes rttr) {

        try {
            int result = masterClientService.deleteMasterClientList(clientIdList);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "선택한 거래처가 미사용 처리되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "선택된 거래처가 없습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "거래처 삭제 처리 중 오류가 발생했습니다.");
        }

        return "redirect:/master/client";
    }


    // =========================================================
    // 3. Ajax / 자동생성
    // =========================================================

    /**
     * 다음 거래처코드 자동생성
     *
     * 요청 주소:
     * - GET /master/client/nextCode?clientCodePrefix=BP-SUP
     *
     * 신규 거래처구분도 가능:
     * - GET /master/client/nextCode?clientCodePrefix=MAN
     * - GET /master/client/nextCode?clientCodePrefix=BP-MAN
     */
    @ResponseBody
    @RequestMapping(value = "/client/nextCode", method = RequestMethod.GET)
    public String nextClientCode(
            @RequestParam("clientCodePrefix") String clientCodePrefix) {

        try {
            return masterClientService.getNextClientCode(clientCodePrefix);
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        } catch (Exception e) {
            return "거래처코드 자동생성 중 오류가 발생했습니다.";
        }
    }
}