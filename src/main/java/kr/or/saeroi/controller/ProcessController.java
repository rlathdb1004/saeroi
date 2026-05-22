package kr.or.saeroi.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.saeroi.dto.ItemDTO;
import kr.or.saeroi.dto.ProcessDTO;
import kr.or.saeroi.dto.ProcessDetailDTO;
import kr.or.saeroi.service.ProcessService;

/**
 * 공정관리 Controller
 *
 * 역할:
 * - 기준정보관리 > 공정관리 화면의 요청을 처리한다.
 * - 공정 목록 조회, 상세 조회, 등록, 수정, 선택삭제를 담당한다.
 * - 공정상세 이미지/작업표준서 등록, 수정, 삭제를 담당한다.
 * - 완제품/설비 자동완성 Ajax 요청을 처리한다.
 *
 * 기준:
 * - 품목관리 ItemController 구조 기준
 * - BOM관리 BomController 구조 기준
 * - 상위 URL: /master
 * - ServiceImpl 사용 안 함
 */
@Controller
@RequestMapping("/master")
public class ProcessController {

    /**
     * 공정관리 Service
     */
    @Autowired
    private ProcessService processService;


    // =========================================================
    // 1. 공정 목록 / 상세
    // =========================================================

    /**
     * 공정관리 목록 화면
     *
     * 요청 주소:
     * - GET /master/process
     */
    @RequestMapping(value = "/process", method = RequestMethod.GET)
    public String processList(
            @ModelAttribute ProcessDTO processDTO,
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
         * 품목관리/BOM관리 기준:
         * 현재 Service/DAO는 page, size를 받지 않으므로
         * 전체 목록 조회 후 Controller에서 현재 페이지 목록만 잘라낸다.
         */
        List<ProcessDTO> allProcessList = processService.getProcessList(processDTO);

        if (allProcessList == null) {
            allProcessList = Collections.emptyList();
        }

        // 검색조건에 맞는 공정 총 건수 조회
        int processCount = processService.getProcessCount(processDTO);

        if (processCount < 0) {
            processCount = 0;
        }

        // 전체 페이지 수 계산
        int totalPage = (int) Math.ceil((double) processCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        // 마지막 페이지보다 큰 값이 들어오면 마지막 페이지로 보정
        if (page > totalPage) {
            page = totalPage;
        }

        // 현재 페이지에 보여줄 목록만 추출
        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allProcessList.size());

        List<ProcessDTO> processList = Collections.emptyList();

        if (fromIndex < allProcessList.size()) {
            processList = allProcessList.subList(fromIndex, toIndex);
        }

        // 페이지 번호 블록 계산
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        Map<String, Object> pageInfo = new HashMap<String, Object>();
        pageInfo.put("page", page);
        pageInfo.put("size", size);
        pageInfo.put("totalCount", processCount);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("hasPrev", page > 1);
        pageInfo.put("hasNext", page < totalPage);
        pageInfo.put("prevPage", page - 1);
        pageInfo.put("nextPage", page + 1);

        // 등록 모달에서 사용할 완제품/설비 후보 목록
        List<ItemDTO> productItemList = processService.getProductItemList();
        List<ProcessDTO> equipmentList = processService.getEquipmentList();

        if (productItemList == null) {
            productItemList = Collections.emptyList();
        }

        if (equipmentList == null) {
            equipmentList = Collections.emptyList();
        }

        // JSP 전달값
        model.addAttribute("processList", processList);
        model.addAttribute("processCount", processCount);
        model.addAttribute("processDTO", processDTO);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/master/process");

        model.addAttribute("productItemList", productItemList);
        model.addAttribute("equipmentList", equipmentList);

        return "master/process.tiles";
    }


    /**
     * 공정 상세보기 화면
     *
     * 요청 주소:
     * - GET /master/process/detail?procId=1
     */
    @RequestMapping(value = "/process/detail", method = RequestMethod.GET)
    public String processDetail(
            @RequestParam("procId") int procId,
            Model model,
            RedirectAttributes rttr) {

        ProcessDTO processDetail = processService.getProcessDetail(procId);

        if (processDetail == null) {
            rttr.addFlashAttribute("msg", "조회된 공정 정보가 없습니다.");
            return "redirect:/master/process";
        }

        List<ItemDTO> productItemList = processService.getProductItemList();
        List<ProcessDTO> equipmentList = processService.getEquipmentList();
        List<ProcessDetailDTO> processDetailList = processService.getProcessDetailList(procId);

        if (productItemList == null) {
            productItemList = Collections.emptyList();
        }

        if (equipmentList == null) {
            equipmentList = Collections.emptyList();
        }

        if (processDetailList == null) {
            processDetailList = Collections.emptyList();
        }

        model.addAttribute("processDetail", processDetail);
        model.addAttribute("productItemList", productItemList);
        model.addAttribute("equipmentList", equipmentList);
        model.addAttribute("processDetailList", processDetailList);

        return "master/processDetail.tiles";
    }


    // =========================================================
    // 2. 공정 등록 / 수정 / 선택삭제
    // =========================================================

    /**
     * 공정 등록 처리
     *
     * 요청 주소:
     * - POST /master/process/add
     */
    @RequestMapping(value = "/process/add", method = RequestMethod.POST)
    public String addProcess(
            @ModelAttribute ProcessDTO processDTO,
            RedirectAttributes rttr) {

        int result = processService.addProcess(processDTO);

        if (result == -2) {
            rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
        } else if (result == -1) {
            rttr.addFlashAttribute("msg", "이미 등록된 공정입니다.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "공정이 등록되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "공정 등록에 실패했습니다.");
        }

        return "redirect:/master/process";
    }


    /**
     * 공정 수정 처리
     *
     * 요청 주소:
     * - POST /master/process/modify
     */
    @RequestMapping(value = "/process/modify", method = RequestMethod.POST)
    public String modifyProcess(
            @ModelAttribute ProcessDTO processDTO,
            RedirectAttributes rttr) {

        int result = processService.modifyProcess(processDTO);

        if (result == -2) {
            rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
        } else if (result == -1) {
            rttr.addFlashAttribute("msg", "이미 등록된 공정입니다.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "공정 정보가 수정되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "공정 수정에 실패했습니다.");
        }

        if (processDTO.getProcId() == null) {
            return "redirect:/master/process";
        }

        return "redirect:/master/process/detail?procId=" + processDTO.getProcId();
    }


    /**
     * 공정 선택 삭제 처리
     *
     * 요청 주소:
     * - POST /master/process/delete
     *
     * 처리:
     * - process_detail 먼저 삭제
     * - process 삭제
     */
    @RequestMapping(value = "/process/delete", method = RequestMethod.POST)
    public String deleteProcessList(
            @RequestParam(value = "procIdList", required = false) List<Integer> procIdList,
            HttpServletRequest request,
            RedirectAttributes rttr) {

        if (procIdList == null || procIdList.isEmpty()) {
            rttr.addFlashAttribute("msg", "선택된 공정이 없습니다.");
            return "redirect:/master/process";
        }

        /*
         * 공정 삭제 전에 연결된 공정상세 이미지 파일 경로를 먼저 조회한다.
         * DB 삭제 성공 후 실제 이미지 파일을 삭제한다.
         */
        for (Integer procId : procIdList) {

            if (procId == null) {
                continue;
            }

            List<ProcessDetailDTO> detailList = processService.getProcessDetailList(procId);

            int result = processService.removeProcessList(Collections.singletonList(procId));

            if (result > 0 && detailList != null) {
                for (ProcessDetailDTO detail : detailList) {
                    deleteUploadFile(detail.getProcPicture(), request);
                }
            }
        }

        rttr.addFlashAttribute("msg", "선택한 공정이 삭제되었습니다.");

        return "redirect:/master/process";
    }


    // =========================================================
    // 3. 공정상세 이미지 / 작업표준서 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 공정상세 이미지/작업표준서 등록
     *
     * 요청 주소:
     * - POST /master/process/detail/add
     *
     * 처리:
     * - 이미지 파일 저장
     * - process_detail 등록
     */
    @RequestMapping(value = "/process/detail/add", method = RequestMethod.POST)
    public String addProcessDetail(
            @ModelAttribute ProcessDetailDTO processDetailDTO,
            @RequestParam(value = "procImageFile", required = false) MultipartFile procImageFile,
            HttpServletRequest request,
            RedirectAttributes rttr) {

        if (processDetailDTO == null || processDetailDTO.getProcId() == null) {
            rttr.addFlashAttribute("msg", "공정 정보가 없습니다.");
            return "redirect:/master/process";
        }

        String savedImagePath = null;

        try {
            savedImagePath = saveProcessImage(procImageFile, processDetailDTO.getProcId(), request);
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        } catch (IOException e) {
            rttr.addFlashAttribute("msg", "이미지 저장 중 오류가 발생했습니다.");
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        }

        processDetailDTO.setProcPicture(savedImagePath);

        int result = processService.addProcessDetail(processDetailDTO);

        if (result == -2) {
            // DB 등록 실패 시 방금 저장한 파일 제거
            deleteUploadFile(savedImagePath, request);
            rttr.addFlashAttribute("msg", "이미지, 설명, 비고 중 하나 이상 입력하세요.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "공정상세 정보가 등록되었습니다.");
        } else {
            // DB 등록 실패 시 방금 저장한 파일 제거
            deleteUploadFile(savedImagePath, request);
            rttr.addFlashAttribute("msg", "공정상세 등록에 실패했습니다.");
        }

        return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
    }


    /**
     * 공정상세 이미지/작업표준서 수정
     *
     * 요청 주소:
     * - POST /master/process/detail/modify
     *
     * 처리:
     * - 기존 공정상세 조회
     * - 새 이미지가 있으면 저장
     * - DB 수정 성공 시 기존 이미지 삭제
     * - DB 수정 실패 시 새 이미지 삭제
     */
    @RequestMapping(value = "/process/detail/modify", method = RequestMethod.POST)
    public String modifyProcessDetail(
            @ModelAttribute ProcessDetailDTO processDetailDTO,
            @RequestParam(value = "procImageFile", required = false) MultipartFile procImageFile,
            HttpServletRequest request,
            RedirectAttributes rttr) {

        if (processDetailDTO == null || processDetailDTO.getProcId() == null) {
            rttr.addFlashAttribute("msg", "공정 정보가 없습니다.");
            return "redirect:/master/process";
        }

        if (processDetailDTO.getProcDetailId() == null) {
            rttr.addFlashAttribute("msg", "수정할 공정상세 정보가 없습니다.");
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        }

        ProcessDetailDTO oldDetail =
                processService.getProcessDetailOne(processDetailDTO.getProcDetailId());

        if (oldDetail == null) {
            rttr.addFlashAttribute("msg", "기존 공정상세 정보를 찾을 수 없습니다.");
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        }

        String oldImagePath = oldDetail.getProcPicture();
        String newImagePath = null;

        try {
            newImagePath = saveProcessImage(procImageFile, processDetailDTO.getProcId(), request);
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("msg", e.getMessage());
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        } catch (IOException e) {
            rttr.addFlashAttribute("msg", "이미지 저장 중 오류가 발생했습니다.");
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        }

        /*
         * 새 이미지가 있으면 새 경로를 DTO에 담는다.
         * 새 이미지가 없으면 null 상태로 Mapper에 전달하여 기존 이미지를 유지한다.
         */
        processDetailDTO.setProcPicture(newImagePath);

        int result = processService.modifyProcessDetail(processDetailDTO);

        if (result == -2) {
            deleteUploadFile(newImagePath, request);
            rttr.addFlashAttribute("msg", "이미지, 설명, 비고 중 하나 이상 입력하세요.");
        } else if (result > 0) {

            /*
             * 새 이미지로 교체된 경우에만 기존 이미지 파일 삭제
             */
            if (newImagePath != null && !newImagePath.trim().isEmpty()) {
                deleteUploadFile(oldImagePath, request);
            }

            rttr.addFlashAttribute("msg", "공정상세 정보가 수정되었습니다.");

        } else {
            deleteUploadFile(newImagePath, request);
            rttr.addFlashAttribute("msg", "공정상세 수정에 실패했습니다.");
        }

        return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
    }


    /**
     * 공정상세 선택 삭제
     *
     * 요청 주소:
     * - POST /master/process/detail/delete
     */
    @RequestMapping(value = "/process/detail/delete", method = RequestMethod.POST)
    public String deleteProcessDetailList(
            @RequestParam("procId") int procId,
            @RequestParam(value = "procDetailIdList", required = false) List<Integer> procDetailIdList,
            HttpServletRequest request,
            RedirectAttributes rttr) {

        if (procDetailIdList == null || procDetailIdList.isEmpty()) {
            rttr.addFlashAttribute("msg", "삭제할 공정상세 정보를 선택하세요.");
            return "redirect:/master/process/detail?procId=" + procId;
        }

        /*
         * 삭제 전 파일 경로 확보
         */
        Map<Integer, String> imagePathMap = new HashMap<Integer, String>();

        for (Integer procDetailId : procDetailIdList) {

            if (procDetailId == null) {
                continue;
            }

            ProcessDetailDTO detail = processService.getProcessDetailOne(procDetailId);

            if (detail != null) {
                imagePathMap.put(procDetailId, detail.getProcPicture());
            }
        }

        int result = processService.removeProcessDetailList(procDetailIdList);

        if (result > 0) {

            for (String imagePath : imagePathMap.values()) {
                deleteUploadFile(imagePath, request);
            }

            rttr.addFlashAttribute("msg", "선택한 공정상세 정보가 삭제되었습니다.");

        } else {
            rttr.addFlashAttribute("msg", "공정상세 삭제에 실패했습니다.");
        }

        return "redirect:/master/process/detail?procId=" + procId;
    }


    // =========================================================
    // 4. Ajax / 자동완성
    // =========================================================

    /**
     * 완제품 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/process/productAutoComplete
     *
     * 대상:
     * - item_type = 'FG'
     */
    @ResponseBody
    @RequestMapping(value = "/process/productAutoComplete", method = RequestMethod.GET)
    public List<ItemDTO> productAutoComplete(
            @RequestParam("keyword") String keyword) {

        return processService.getProductItemAutoComplete(keyword);
    }


    /**
     * 설비 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/process/equipmentAutoComplete
     */
    @ResponseBody
    @RequestMapping(value = "/process/equipmentAutoComplete", method = RequestMethod.GET)
    public List<ProcessDTO> equipmentAutoComplete(
            @RequestParam("keyword") String keyword) {

        return processService.getEquipmentAutoComplete(keyword);
    }
    
    /**
     * 공정코드 자동완성 조회
     *
     * 요청 주소:
     * - GET /master/process/procCodeAutoComplete
     */
    @ResponseBody
    @RequestMapping(value = "/process/procCodeAutoComplete", method = RequestMethod.GET)
    public List<ProcessDTO> procCodeAutoComplete(
            @RequestParam("keyword") String keyword) {

        return processService.getProcCodeAutoComplete(keyword);
    }
    
    /**
     * 공정코드 중복 확인
     *
     * 요청 주소:
     * - GET /master/process/checkProcCodeDuplicate
     *
     * 파라미터:
     * - procCode
     * - procId: 수정 시 현재 공정 ID, 등록 시 생략 가능
     */
    @ResponseBody
    @RequestMapping(value = "/process/checkProcCodeDuplicate", method = RequestMethod.GET)
    public Map<String, Object> checkProcCodeDuplicate(
            @ModelAttribute ProcessDTO processDTO) {

        Map<String, Object> resultMap = new HashMap<String, Object>();

        boolean duplicate = processService.isDuplicateProcess(processDTO);

        resultMap.put("duplicate", duplicate);

        if (duplicate) {
            resultMap.put("message", "이미 존재하는 공정코드입니다.");
        } else {
            resultMap.put("message", "사용 가능한 공정코드입니다.");
        }

        return resultMap;
    }


    // =========================================================
    // 5. 파일 업로드 내부 메서드
    // =========================================================

    /**
     * 공정 이미지 저장
     *
     * 저장 위치:
     * - /resources/upload/process/
     *
     * DB 저장 경로:
     * - /resources/upload/process/파일명
     *
     * 허용 확장자:
     * - jpg, jpeg, png, gif, webp
     *
     * @param multipartFile 업로드 파일
     * @param procId 공정 ID
     * @param request HttpServletRequest
     * @return DB에 저장할 이미지 상대 경로. 파일이 없으면 null
     * @throws IOException 파일 저장 오류
     */
    private String saveProcessImage(
            MultipartFile multipartFile,
            Integer procId,
            HttpServletRequest request) throws IOException {

        if (multipartFile == null || multipartFile.isEmpty()) {
            return null;
        }

        String originalFilename = multipartFile.getOriginalFilename();

        if (originalFilename == null || originalFilename.trim().isEmpty()) {
            return null;
        }

        String extension = getFileExtension(originalFilename);

        if (!isAllowedImageExtension(extension)) {
            throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다. jpg, jpeg, png, gif, webp 파일을 사용하세요.");
        }

        String contentType = multipartFile.getContentType();

        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");
        }

        String uploadRelativePath = "/resources/upload/process/";
        String uploadRealPath = request.getServletContext().getRealPath(uploadRelativePath);

        File uploadDir = new File(uploadRealPath);

        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String timestamp = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());

        String savedFilename = "process_" + procId + "_" + timestamp + "." + extension;

        File savedFile = new File(uploadDir, savedFilename);

        multipartFile.transferTo(savedFile);

        return uploadRelativePath + savedFilename;
    }


    /**
     * 업로드 파일 삭제
     *
     * 설명:
     * - DB에 저장된 상대 경로를 실제 서버 경로로 변환해 파일을 삭제한다.
     * - 파일이 없어도 오류로 처리하지 않는다.
     *
     * @param filePath DB에 저장된 파일 경로
     * @param request HttpServletRequest
     */
    private void deleteUploadFile(String filePath, HttpServletRequest request) {

        if (filePath == null || filePath.trim().isEmpty()) {
            return;
        }

        String realPath = request.getServletContext().getRealPath(filePath);

        if (realPath == null || realPath.trim().isEmpty()) {
            return;
        }

        File file = new File(realPath);

        if (file.exists() && file.isFile()) {
            file.delete();
        }
    }


    /**
     * 파일 확장자 추출
     *
     * @param filename 원본 파일명
     * @return 소문자 확장자
     */
    private String getFileExtension(String filename) {

        int dotIndex = filename.lastIndexOf(".");

        if (dotIndex < 0 || dotIndex == filename.length() - 1) {
            return "";
        }

        return filename.substring(dotIndex + 1).toLowerCase();
    }


    /**
     * 허용 이미지 확장자 확인
     *
     * @param extension 확장자
     * @return 허용 여부
     */
    private boolean isAllowedImageExtension(String extension) {

        if (extension == null) {
            return false;
        }

        return "jpg".equals(extension)
                || "jpeg".equals(extension)
                || "png".equals(extension)
                || "gif".equals(extension)
                || "webp".equals(extension);
    }
}