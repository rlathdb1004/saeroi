package kr.or.saeroi.controller;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
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
 * - 목록 조회, 상세 조회, 등록, 수정, 선택삭제를 담당한다.
 * - 공정코드 자동완성/중복확인 Ajax 요청을 처리한다.
 * - 공정 이미지 등록/삭제를 처리한다.
 *
 * 기준:
 * - 품목관리 ItemController 구조 기준
 * - BOM관리 BomController 구조 기준
 * - 상위 URL: /master
 * - 목록 URL: /master/process
 * - 상세 URL: /master/process/detail
 * - 화면 반환은 .tiles 사용
 * - redirect 반환에는 .tiles 사용하지 않음
 * - 공용 paging.jsp 사용을 위해 pageInfo, pageUrl 전달
 * - 기본 보기 개수 size=5
 * - ServiceImpl 사용 안 함
 */
@Controller
@RequestMapping("/master")
public class ProcessController {

	@Autowired
	private ProcessService processService;

	@Autowired
	private ServletContext servletContext;


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

		List<ProcessDetailDTO> processDetailList = processService.getProcessDetailList(procId);

		if (processDetailList == null) {
			processDetailList = Collections.emptyList();
		}

		List<ItemDTO> productItemList = processService.getProductItemList();
		List<ProcessDTO> equipmentList = processService.getEquipmentList();

		model.addAttribute("processDetail", processDetail);
		model.addAttribute("processDetailList", processDetailList);
		model.addAttribute("productItemList", productItemList);
		model.addAttribute("equipmentList", equipmentList);

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
			rttr.addFlashAttribute("msg", "같은 완제품에 이미 존재하는 공정코드입니다.");
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

		if (processDTO == null || processDTO.getProcId() == null) {
			rttr.addFlashAttribute("msg", "잘못된 공정 정보입니다.");
			return "redirect:/master/process";
		}

		int result = processService.modifyProcess(processDTO);

		if (result == -2) {
			rttr.addFlashAttribute("msg", "필수 입력값을 확인하세요.");
		} else if (result == -1) {
			rttr.addFlashAttribute("msg", "같은 완제품에 이미 존재하는 공정코드입니다.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "공정 정보가 수정되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "공정 수정에 실패했습니다.");
		}

		return "redirect:/master/process/detail?procId=" + processDTO.getProcId();
	}


	/**
	 * 공정 선택 삭제 처리
	 *
	 * 요청 주소:
	 * - POST /master/process/delete
	 */
	@RequestMapping(value = "/process/delete", method = RequestMethod.POST)
	public String deleteProcessList(
			@RequestParam(value = "procIdList", required = false) List<Integer> procIdList,
			RedirectAttributes rttr) {

		int result = processService.removeProcessList(procIdList);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "선택한 공정이 삭제되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "선택된 공정이 없습니다.");
		}

		return "redirect:/master/process";
	}


	// =========================================================
	// 3. 공정 이미지 / 공정상세 등록 / 선택삭제
	// =========================================================

	/**
	 * 공정 이미지/상세설명 등록 처리
	 *
	 * 요청 주소:
	 * - POST /master/process/detail/add
	 */
	@RequestMapping(value = "/process/detail/add", method = RequestMethod.POST)
	public String addProcessDetail(
			@RequestParam("procId") int procId,
			@RequestParam(value = "procImageFile", required = false) MultipartFile procImageFile,
			@RequestParam(value = "procContent", required = false) String procContent,
			@RequestParam(value = "remark", required = false) String remark,
			RedirectAttributes rttr) {

		String procPicture = null;

		if (procImageFile != null && !procImageFile.isEmpty()) {
			try {
				procPicture = saveProcessImageFile(procImageFile);
			} catch (IllegalArgumentException e) {
				rttr.addFlashAttribute("msg", e.getMessage());
				return "redirect:/master/process/detail?procId=" + procId;
			} catch (IOException e) {
				rttr.addFlashAttribute("msg", "공정 이미지 저장 중 오류가 발생했습니다.");
				return "redirect:/master/process/detail?procId=" + procId;
			}
		}

		ProcessDetailDTO processDetailDTO = new ProcessDetailDTO();
		processDetailDTO.setProcId(procId);
		processDetailDTO.setProcPicture(procPicture);
		processDetailDTO.setProcContent(procContent);
		processDetailDTO.setRemark(remark);

		int result = processService.addProcessDetail(processDetailDTO);

		if (result == -2) {
			rttr.addFlashAttribute("msg", "이미지, 상세설명, 비고 중 하나 이상 입력하세요.");
		} else if (result > 0) {
			rttr.addFlashAttribute("msg", "공정 이미지 정보가 등록되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "공정 이미지 정보 등록에 실패했습니다.");
		}

		return "redirect:/master/process/detail?procId=" + procId;
	}


	/**
	 * 공정 이미지/상세설명 선택 삭제 처리
	 *
	 * 요청 주소:
	 * - POST /master/process/detail/delete
	 */
	@RequestMapping(value = "/process/detail/delete", method = RequestMethod.POST)
	public String deleteProcessDetailList(
			@RequestParam("procId") int procId,
			@RequestParam(value = "procDetailIdList", required = false) List<Integer> procDetailIdList,
			RedirectAttributes rttr) {

		int result = processService.removeProcessDetailList(procDetailIdList);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "선택한 공정 이미지가 삭제되었습니다.");
		} else {
			rttr.addFlashAttribute("msg", "선택된 공정 이미지가 없습니다.");
		}

		return "redirect:/master/process/detail?procId=" + procId;
	}


	// =========================================================
	// 4. Ajax / 자동완성 / 중복확인
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
	 * 공정코드 중복확인
	 *
	 * 요청 주소:
	 * - GET /master/process/checkProcCodeDuplicate
	 *
	 * 기준:
	 * - item_id + proc_code 조합
	 */
	@ResponseBody
	@RequestMapping(value = "/process/checkProcCodeDuplicate", method = RequestMethod.GET)
	public ProcessDuplicateResponse checkProcCodeDuplicate(
			@RequestParam(value = "itemId", required = false) Integer itemId,
			@RequestParam(value = "procCode", required = false) String procCode,
			@RequestParam(value = "procId", required = false) Integer procId) {

		ProcessDuplicateResponse response = new ProcessDuplicateResponse();

		if (itemId == null || itemId <= 0) {
			response.setDuplicate(false);
			response.setMessage("완제품을 먼저 선택하세요.");
			return response;
		}

		if (procCode == null || procCode.trim().isEmpty()) {
			response.setDuplicate(false);
			response.setMessage("공정코드를 입력하세요.");
			return response;
		}

		ProcessDTO processDTO = new ProcessDTO();
		processDTO.setItemId(itemId);
		processDTO.setProcCode(procCode.trim());
		processDTO.setProcId(procId);

		boolean duplicate = processService.isDuplicateProcess(processDTO);

		response.setDuplicate(duplicate);

		if (duplicate) {
			response.setMessage("같은 완제품에 이미 존재하는 공정코드입니다.");
		} else {
			response.setMessage("");
		}

		return response;
	}


	/**
	 * 완제품 자동완성 조회
	 *
	 * 요청 주소:
	 * - GET /master/process/productItemAutoComplete
	 */
	@ResponseBody
	@RequestMapping(value = "/process/productItemAutoComplete", method = RequestMethod.GET)
	public List<ItemDTO> productItemAutoComplete(
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


	// =========================================================
	// 5. 내부 파일 저장 메서드
	// =========================================================

	/**
	 * 공정 이미지 파일 저장
	 *
	 * 저장 위치:
	 * - 실제 파일: /resources/upload/process/
	 * - DB 저장 경로: /resources/upload/process/파일명
	 */
	private String saveProcessImageFile(MultipartFile multipartFile) throws IOException {

		if (multipartFile == null || multipartFile.isEmpty()) {
			return null;
		}

		String originalFilename = multipartFile.getOriginalFilename();

		if (originalFilename == null || originalFilename.trim().isEmpty()) {
			throw new IllegalArgumentException("파일명이 올바르지 않습니다.");
		}

		String extension = getFileExtension(originalFilename);

		if (!isAllowedImageExtension(extension)) {
			throw new IllegalArgumentException("이미지 파일만 업로드할 수 있습니다.");
		}

		String uploadRelativePath = "/resources/upload/process/";
		String uploadRealPath = servletContext.getRealPath(uploadRelativePath);

		if (uploadRealPath == null) {
			throw new IOException("업로드 경로를 찾을 수 없습니다.");
		}

		File uploadDir = new File(uploadRealPath);

		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		String savedFileName = "process_" + UUID.randomUUID().toString().replace("-", "") + extension;
		File saveFile = new File(uploadDir, savedFileName);

		multipartFile.transferTo(saveFile);

		return uploadRelativePath + savedFileName;
	}


	/**
	 * 파일 확장자 추출
	 */
	private String getFileExtension(String fileName) {

		if (fileName == null) {
			return "";
		}

		String cleanFileName = StringUtils.cleanPath(fileName);
		int dotIndex = cleanFileName.lastIndexOf(".");

		if (dotIndex < 0) {
			return "";
		}

		return cleanFileName.substring(dotIndex).toLowerCase();
	}


	/**
	 * 허용 이미지 확장자 확인
	 */
	private boolean isAllowedImageExtension(String extension) {

		if (extension == null) {
			return false;
		}

		return ".jpg".equals(extension)
				|| ".jpeg".equals(extension)
				|| ".png".equals(extension)
				|| ".gif".equals(extension)
				|| ".webp".equals(extension);
	}


	// =========================================================
	// 6. Ajax 응답 DTO
	// =========================================================

	/**
	 * 공정코드 중복확인 Ajax 응답 DTO
	 */
	public static class ProcessDuplicateResponse {

		private boolean duplicate;
		private String message;

		public boolean isDuplicate() {
			return duplicate;
		}

		public void setDuplicate(boolean duplicate) {
			this.duplicate = duplicate;
		}

		public String getMessage() {
			return message;
		}

		public void setMessage(String message) {
			this.message = message;
		}
	}
}