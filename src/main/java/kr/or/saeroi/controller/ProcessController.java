package kr.or.saeroi.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
 * - 기준정보관리 > 공정관리 화면 요청을 처리한다.
 * - 공정 목록 조회, 상세 조회, 등록, 수정, 선택삭제를 처리한다.
 * - 공정코드 자동완성, 공정코드 중복확인 Ajax 요청을 처리한다.
 * - 공정 이미지 등록, 조회, 삭제를 처리한다.
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

        if (size != 5 && size != 10 && size != 20 && size != 30) {
            size = 5;
        }

        if (page < 1) {
            page = 1;
        }

        List<ProcessDTO> allProcessList = processService.getProcessList(processDTO);

        if (allProcessList == null) {
            allProcessList = Collections.emptyList();
        }

        int processCount = processService.getProcessCount(processDTO);

        if (processCount < 0) {
            processCount = 0;
        }

        int totalPage = (int) Math.ceil((double) processCount / size);

        if (totalPage < 1) {
            totalPage = 1;
        }

        if (page > totalPage) {
            page = totalPage;
        }

        int fromIndex = (page - 1) * size;
        int toIndex = Math.min(fromIndex + size, allProcessList.size());

        List<ProcessDTO> processList = Collections.emptyList();

        if (fromIndex < allProcessList.size()) {
            processList = allProcessList.subList(fromIndex, toIndex);
        }

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

        List<ItemDTO> productItemList = processService.getProductItemList();
        List<ProcessDTO> equipmentList = processService.getEquipmentList();

        if (productItemList == null) {
            productItemList = Collections.emptyList();
        }

        if (equipmentList == null) {
            equipmentList = Collections.emptyList();
        }

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
            rttr.addFlashAttribute("msg", "이미 존재하는 공정코드입니다.");
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
            rttr.addFlashAttribute("msg", "이미 존재하는 공정코드입니다.");
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
     * - 연결된 공정 이미지 경로를 먼저 조회한다.
     * - process_detail 삭제 후 process 삭제한다.
     * - DB 삭제 성공 후 실제 이미지 파일을 삭제한다.
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

        List<String> imagePathList = new ArrayList<String>();

        for (Integer procId : procIdList) {

            if (procId == null) {
                continue;
            }

            List<ProcessDetailDTO> detailList = processService.getProcessDetailList(procId);

            if (detailList == null) {
                continue;
            }

            for (ProcessDetailDTO detail : detailList) {
                if (detail != null && detail.getProcPicture() != null) {
                    imagePathList.add(detail.getProcPicture());
                }
            }
        }

        int result = processService.removeProcessList(procIdList);

        if (result > 0) {

            for (String imagePath : imagePathList) {
                deleteUploadFile(imagePath, request);
            }

            rttr.addFlashAttribute("msg", "선택한 공정이 삭제되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "공정 삭제에 실패했습니다.");
        }

        return "redirect:/master/process";
    }


    // =========================================================
    // 3. 공정 이미지 / 공정상세 등록 / 수정 / 삭제
    // =========================================================

    /**
     * 공정 이미지 등록
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
            deleteUploadFile(savedImagePath, request);
            rttr.addFlashAttribute("msg", "이미지, 설명, 비고 중 하나 이상 입력하세요.");
        } else if (result > 0) {
            rttr.addFlashAttribute("msg", "공정 이미지가 등록되었습니다.");
        } else {
            deleteUploadFile(savedImagePath, request);
            rttr.addFlashAttribute("msg", "공정 이미지 등록에 실패했습니다.");
        }

        return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
    }


    /**
     * 공정 이미지 수정
     *
     * 요청 주소:
     * - POST /master/process/detail/modify
     *
     * 현재 화면에서는 아직 사용하지 않아도 되지만,
     * 공정 이미지 교체 기능 확장을 위해 준비해둔다.
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
            rttr.addFlashAttribute("msg", "수정할 공정 이미지 정보가 없습니다.");
            return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
        }

        ProcessDetailDTO oldDetail =
                processService.getProcessDetailOne(processDetailDTO.getProcDetailId());

        if (oldDetail == null) {
            rttr.addFlashAttribute("msg", "기존 공정 이미지 정보를 찾을 수 없습니다.");
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

        processDetailDTO.setProcPicture(newImagePath);

        int result = processService.modifyProcessDetail(processDetailDTO);

        if (result == -2) {
            deleteUploadFile(newImagePath, request);
            rttr.addFlashAttribute("msg", "이미지, 설명, 비고 중 하나 이상 입력하세요.");
        } else if (result > 0) {

            if (newImagePath != null && !newImagePath.trim().isEmpty()) {
                deleteUploadFile(oldImagePath, request);
            }

            rttr.addFlashAttribute("msg", "공정 이미지 정보가 수정되었습니다.");
        } else {
            deleteUploadFile(newImagePath, request);
            rttr.addFlashAttribute("msg", "공정 이미지 수정에 실패했습니다.");
        }

        return "redirect:/master/process/detail?procId=" + processDetailDTO.getProcId();
    }


    /**
     * 공정 이미지 선택 삭제
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
            rttr.addFlashAttribute("msg", "삭제할 공정 이미지를 선택하세요.");
            return "redirect:/master/process/detail?procId=" + procId;
        }

        List<String> imagePathList = new ArrayList<String>();

        for (Integer procDetailId : procDetailIdList) {

            if (procDetailId == null) {
                continue;
            }

            ProcessDetailDTO detail = processService.getProcessDetailOne(procDetailId);

            if (detail != null && detail.getProcPicture() != null) {
                imagePathList.add(detail.getProcPicture());
            }
        }

        int result = processService.removeProcessDetailList(procDetailIdList);

        if (result > 0) {

            for (String imagePath : imagePathList) {
                deleteUploadFile(imagePath, request);
            }

            rttr.addFlashAttribute("msg", "선택한 공정 이미지가 삭제되었습니다.");
        } else {
            rttr.addFlashAttribute("msg", "공정 이미지 삭제에 실패했습니다.");
        }

        return "redirect:/master/process/detail?procId=" + procId;
    }


    // =========================================================
    // 4. Ajax
    // =========================================================

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


    /**
     * 완제품 자동완성 조회
     *
     * 현재 화면에서는 완제품을 selectbox로 사용한다.
     * 추후 자동완성 전환 시 사용할 수 있도록 유지한다.
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
     * 현재 화면에서는 설비를 selectbox로 사용한다.
     * 추후 자동완성 전환 시 사용할 수 있도록 유지한다.
     */
    @ResponseBody
    @RequestMapping(value = "/process/equipmentAutoComplete", method = RequestMethod.GET)
    public List<ProcessDTO> equipmentAutoComplete(
            @RequestParam("keyword") String keyword) {

        return processService.getEquipmentAutoComplete(keyword);
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

        if (multipartFile.getSize() > 10 * 1024 * 1024) {
            throw new IllegalArgumentException("이미지 파일은 10MB 이하만 업로드할 수 있습니다.");
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

        if (uploadRealPath == null || uploadRealPath.trim().isEmpty()) {
            throw new IOException("업로드 경로를 찾을 수 없습니다.");
        }

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