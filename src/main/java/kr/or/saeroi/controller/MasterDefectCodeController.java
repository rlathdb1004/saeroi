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

import kr.or.saeroi.dto.MasterDefectCodeDTO;
import kr.or.saeroi.service.MasterDefectCodeService;

/**
 * 기준관리 > 불량코드관리 Controller
 *
 * 기준:
 * - 기존 DefectDTO / 품질관리 불량관리 기능과 충돌 방지를 위해 MasterDefectCode 명칭 사용
 * - URL은 사이드바 기준으로 /master/defectcode 사용
 * - 품목관리 기준관리 구조 중심 적용
 * - ServiceImpl 사용 안 함
 * - 목록 기본 5개씩 보기
 * - PC 컬럼: 체크박스 포함 8개
 * - 모바일 컬럼: 체크박스 포함 5개
 * - 실제 DELETE 대신 use_yn = 'N' 미사용 처리
 */
@Controller
@RequestMapping("/master")
public class MasterDefectCodeController {

    @Autowired
    private MasterDefectCodeService masterDefectCodeService;


    // =========================================================
    // 1. 불량코드 목록 / 상세
    // =========================================================

    /**
     * 기준관리 > 불량코드관리 목록 화면
     *
     * 요청 주소:
     * - GET /master/defectcode
     */
    @RequestMapping(value = "/defectcode", method = RequestMethod.GET)
    public String masterDefectCodeList(
            @ModelAttribute MasterDefectCodeDTO masterDefectCodeDTO,
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
        List<MasterDefectCodeDTO> allMasterDefectCodeList =
                masterDefectCodeService.selectMasterDefectCodeList(masterDefectCodeDTO);

        if (allMasterDefectCodeList == null) {
            allMasterDefectCodeList = Collections.emptyList();
        }

        int masterDefectCodeCount =
                masterDefectCodeService.selectMasterDefectCodeCount(masterDefectCodeDTO);

        if (masterDefectCodeCount < 0) {
            masterDefectCodeCount = 0;
        }

        int totalPage = (int) Math.ceil((double) masterDefectCodeCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        if (page > totalPage) {
            page = totalPage;
        }

        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allMasterDefectCodeList.size());

        List<MasterDefectCodeDTO> masterDefectCodeList = Collections.emptyList();

        if (fromIndex < allMasterDefectCodeList.size()) {
            masterDefectCodeList = allMasterDefectCodeList.subList(fromIndex, toIndex);
        }

        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        Map<String, Object> pageInfo = new HashMap<String, Object>();
        pageInfo.put("page", page);
        pageInfo.put("size", size);
        pageInfo.put("totalCount", masterDefectCodeCount);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("hasPrev", page > 1);
        pageInfo.put("hasNext", page < totalPage);
        pageInfo.put("prevPage", page - 1);
        pageInfo.put("nextPage", page + 1);

        List<String> defectCodePrefixList =
                masterDefectCodeService.selectDefectCodePrefixList();

        if (defectCodePrefixList == null) {
            defectCodePrefixList = Collections.emptyList();
        }

        model.addAttribute("masterDefectCodeList", masterDefectCodeList);
        model.addAttribute("masterDefectCodeCount", masterDefectCodeCount);
        model.addAttribute("masterDefectCodeDTO", masterDefectCodeDTO);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/master/defectcode");

        model.addAttribute("defectCodePrefixList", defectCodePrefixList);

        return "master/masterDefectCode.tiles";
    }


    /**
     * 기준관리 > 불량코드관리 상세 화면
     *
     * 요청 주소:
     * - GET /master/defectcode/detail?defectId=1
     */
    @RequestMapping(value = "/defectcode/detail", method = RequestMethod.GET)
    public String masterDefectCodeDetail(
            @RequestParam("defectId") Integer defectId,
            Model model,
            RedirectAttributes rttr) {

        try {
            MasterDefectCodeDTO masterDefectCodeDetail =
                    masterDefectCodeService.selectMasterDefectCodeDetail(defectId);

            List<String> defectCodePrefixList =
                    masterDefectCodeService.selectDefectCodePrefixList();

            if (defectCodePrefixList == null) {
                defectCodePrefixList = Collections.emptyList();
            }

            model.addAttribute("masterDefectCodeDetail", masterDefectCodeDetail);
            model.addAttribute("defectCodePrefixList", defectCodePrefixList);

            return "master/masterDefectCodeDetail.tiles";

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/master/defectcode";
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "불량코드 상세 조회 중 오류가 발생했습니다.");
            return "redirect:/master/defectcode";
        }
    }


    // =========================================================
    // 2. 불량코드 등록 / 수정 / 선택삭제
    // =========================================================

    /**
     * 불량코드 등록 처리
     *
     * 요청 주소:
     * - POST /master/defectcode/add
     */
    @RequestMapping(value = "/defectcode/add", method = RequestMethod.POST)
    public String addMasterDefectCode(
            @ModelAttribute MasterDefectCodeDTO masterDefectCodeDTO,
            RedirectAttributes rttr) {

        try {
            int result = masterDefectCodeService.insertMasterDefectCode(masterDefectCodeDTO);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "불량코드가 등록되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "불량코드 등록에 실패했습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "불량코드 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/master/defectcode";
    }


    /**
     * 불량코드 수정 처리
     *
     * 요청 주소:
     * - POST /master/defectcode/modify
     */
    @RequestMapping(value = "/defectcode/modify", method = RequestMethod.POST)
    public String modifyMasterDefectCode(
            @ModelAttribute MasterDefectCodeDTO masterDefectCodeDTO,
            RedirectAttributes rttr) {

        Integer defectId = masterDefectCodeDTO.getDefectId();

        try {
            int result = masterDefectCodeService.updateMasterDefectCode(masterDefectCodeDTO);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "불량코드 정보가 수정되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "불량코드 수정에 실패했습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "불량코드 수정 중 오류가 발생했습니다.");
        }

        if (defectId == null || defectId <= 0) {
            return "redirect:/master/defectcode";
        }

        return "redirect:/master/defectcode/detail?defectId=" + defectId;
    }


    /**
     * 불량코드 선택 삭제 처리
     *
     * 요청 주소:
     * - POST /master/defectcode/delete
     *
     * 처리:
     * - 실제 DELETE가 아니라 use_yn = 'N' 미사용 처리
     */
    @RequestMapping(value = "/defectcode/delete", method = RequestMethod.POST)
    public String deleteMasterDefectCodeList(
            @RequestParam(value = "defectIdList", required = false) List<Integer> defectIdList,
            RedirectAttributes rttr) {

        try {
            int result = masterDefectCodeService.deleteMasterDefectCodeList(defectIdList);

            if (result > 0) {
                rttr.addFlashAttribute("msg", "선택한 불량코드가 미사용 처리되었습니다.");
            } else {
                rttr.addFlashAttribute("msg", "선택된 불량코드가 없습니다.");
            }

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "불량코드 삭제 처리 중 오류가 발생했습니다.");
        }

        return "redirect:/master/defectcode";
    }


    // =========================================================
    // 3. Ajax / 자동생성
    // =========================================================

    /**
     * 다음 불량코드 자동생성
     *
     * 요청 주소:
     * - GET /master/defectcode/nextCode?defectCodePrefix=DCD-DIM
     *
     * 신규 불량코드구분도 가능:
     * - GET /master/defectcode/nextCode?defectCodePrefix=DCD-PIN
     * - GET /master/defectcode/nextCode?defectCodePrefix=DEF-BAR
     */
    @ResponseBody
    @RequestMapping(value = "/defectcode/nextCode", method = RequestMethod.GET)
    public String nextDefectCode(
            @RequestParam("defectCodePrefix") String defectCodePrefix) {

        try {
            return masterDefectCodeService.selectNextDefectCode(defectCodePrefix);
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        } catch (Exception e) {
            return "불량코드 자동생성 중 오류가 발생했습니다.";
        }
    }
}