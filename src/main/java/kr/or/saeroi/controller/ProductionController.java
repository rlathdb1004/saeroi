package kr.or.saeroi.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.ProductionService;

// 생산관리 화면 요청을 처리하는 Controller이다.
@Controller
public class ProductionController {

	// 생산관리 Service를 주입받는다.
	@Autowired
	private ProductionService productionService;


	// =========================================================
	// 1. 생산계획 관리
	// =========================================================

	// 생산계획관리 목록 화면이다.
	@RequestMapping("/production/productionplan")
	public String productionPlan(ProductionDTO productionDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		int totalCount = productionService.selectProductionPlanCount(productionDTO);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		List<ProductionDTO> list = productionService.selectProductionPlanList(productionDTO);
		List<String> itemTypeList = productionService.selectItemTypeList();
		List<ProductionDTO> itemList = productionService.selectItemList();

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/production/productionplan");

		model.addAttribute("itemTypeList", itemTypeList);
		model.addAttribute("itemList", itemList);

		model.addAttribute("itemType", productionDTO.getItemType());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산계획 관리");

		return "production/productionplan.tiles";
	}


	// 생산계획 상세 화면이다.
	@RequestMapping("/production/productionplan/detail")
	public String productionPlanDetail(
			@RequestParam("prodPlanId") Integer prodPlanId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		ProductionDTO production = productionService.selectProductionPlanDetail(prodPlanId);

		model.addAttribute("production", production);
		model.addAttribute("mode", mode);

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산계획 상세");

		return "production/productionplandetail.tiles";
	}


	// 생산계획을 등록한다.
	@RequestMapping(value = "/production/productionplan/insert", method = RequestMethod.POST)
	public String insertProductionPlan(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.insertProductionPlan(productionDTO);
			rttr.addFlashAttribute("msg", "생산계획이 등록되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산계획 등록 중 오류가 발생했습니다.");
		}

		return "redirect:/production/productionplan";
	}


	// 생산계획 상세 수정 처리이다.
	@RequestMapping(value = "/production/productionplan/update", method = RequestMethod.POST)
	public String updateProductionPlan(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.updateProductionPlan(productionDTO);
			rttr.addFlashAttribute("msg", "생산계획이 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산계획 수정 중 오류가 발생했습니다.");
		}

		return "redirect:/production/productionplan/detail?prodPlanId="
				+ productionDTO.getProdPlanId();
	}


	// =========================================================
	// 2. 작업지시 관리
	// =========================================================

	// 작업지시 관리 목록 화면이다.
	@RequestMapping("/production/workorder")
	public String workOrder(
			ProductionDTO productionDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		int totalCount = productionService.selectWorkOrderCount(productionDTO);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		List<ProductionDTO> list = productionService.selectWorkOrderList(productionDTO);
		List<String> workOrderStatusList = productionService.selectWorkOrderStatusList();

		// 작업지시 등록 모달 생산계획 목록이다.
		// includePastPlan = Y이면 지난 생산계획도 포함한다.
		List<ProductionDTO> workOrderPlanList =
				productionService.selectWorkOrderPlanList(productionDTO);

		List<ProductionDTO> lineList = productionService.selectLineList();
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/production/workorder");

		model.addAttribute("workOrderStatusList", workOrderStatusList);
		model.addAttribute("workOrderPlanList", workOrderPlanList);
		model.addAttribute("lineList", lineList);
		model.addAttribute("empList", empList);

		model.addAttribute("prodStatus", productionDTO.getProdStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		// 작업지시 등록 모달의 지난 생산계획 보기 체크박스 유지용 값이다.
		model.addAttribute("includePastPlan", productionDTO.getIncludePastPlan());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "작업지시 관리");

		return "production/workorder.tiles";
	}


	// 작업지시 인쇄 화면이다.
	// orderId가 있으면 단건 작업지시서를 인쇄하고,
	// orderId가 없으면 검색조건에 맞는 전체 작업지시서를 인쇄한다.
	@RequestMapping("/production/workorder/print")
	public String workOrderPrint(
			ProductionDTO productionDTO,
			Model model) {

		List<ProductionDTO> printList =
				productionService.selectWorkOrderPrintDetailList(productionDTO);

		model.addAttribute("printList", printList);

		model.addAttribute("prodStatus", productionDTO.getProdStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "작업지시 인쇄");

		return "production/workorderprint.tiles";
	}


	// 작업지시 QR 이미지를 실시간으로 생성해서 PNG로 응답한다.
	@RequestMapping(value = "/production/workorder/qr", method = RequestMethod.GET)
	public void workOrderQr(
			@RequestParam("orderId") Integer orderId,
			HttpServletResponse response) throws IOException {

		try {
			byte[] qrImageBytes =
					productionService.createWorkOrderQrImageBytes(orderId);

			response.setContentType("image/png");
			response.setContentLength(qrImageBytes.length);
			response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
			response.setHeader("Pragma", "no-cache");

			response.getOutputStream().write(qrImageBytes);
			response.getOutputStream().flush();

		} catch (IllegalArgumentException e) {
			response.sendError(
					HttpServletResponse.SC_BAD_REQUEST,
					e.getMessage());

		} catch (Exception e) {
			response.sendError(
					HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					"작업지시 QR 코드 생성 중 오류가 발생했습니다.");
		}
	}


	// 작업지시를 등록한다.
	@RequestMapping(value = "/production/workorder/insert", method = RequestMethod.POST)
	public String insertWorkOrder(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			/*
			 * Service 처리 흐름:
			 * 1. WORK_ORDER 등록
			 * 2. 생성된 orderId 확보
			 * 3. 생성된 작업지시 상세 재조회
			 * 4. LOT 기반 QR URL/이미지 생성
			 * 5. work_order.qr_url, qr_image_path 저장
			 * 6. BOM 기준 MATERIAL_INOUT 자동 생성
			 */
			productionService.insertWorkOrder(productionDTO);

			rttr.addFlashAttribute("msg",
					"작업지시가 등록되었고 QR코드와 BOM 기준 원자재 투입 이력이 생성되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "작업지시 등록 중 오류가 발생했습니다.");
		}

		return "redirect:/production/workorder";
	}


	// 작업지시 상세 화면이다.
	@RequestMapping("/production/workorder/detail")
	public String workOrderDetail(
			@RequestParam("orderId") Integer orderId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		ProductionDTO workOrder = productionService.selectWorkOrderDetail(orderId);

		List<ProductionDTO> lineList = productionService.selectLineList();
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		ProductionDTO appliedBom = null;
		List<ProductionDTO> bomMaterialList = Collections.emptyList();
		List<ProductionDTO> materialInoutList = Collections.emptyList();

		try {
			appliedBom = productionService.selectWorkOrderAppliedBom(orderId);

			List<ProductionDTO> tempBomMaterialList =
					productionService.selectWorkOrderBomMaterialList(orderId);

			if (tempBomMaterialList != null) {
				bomMaterialList = tempBomMaterialList;
			}

			List<ProductionDTO> tempMaterialInoutList =
					productionService.selectWorkOrderMaterialInoutList(orderId);

			if (tempMaterialInoutList != null) {
				materialInoutList = tempMaterialInoutList;
			}

		} catch (Exception e) {
			appliedBom = null;
			bomMaterialList = Collections.emptyList();
			materialInoutList = Collections.emptyList();
		}

		model.addAttribute("workOrder", workOrder);
		model.addAttribute("mode", mode);

		model.addAttribute("lineList", lineList);
		model.addAttribute("empList", empList);

		model.addAttribute("appliedBom", appliedBom);
		model.addAttribute("bomMaterialList", bomMaterialList);
		model.addAttribute("materialInoutList", materialInoutList);

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "작업지시 상세");

		return "production/workorderdetail.tiles";
	}


	// 작업지시 상세 수정 처리이다.
	@RequestMapping(value = "/production/workorder/update", method = RequestMethod.POST)
	public String updateWorkOrder(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.updateWorkOrder(productionDTO);
			rttr.addFlashAttribute("msg", "작업지시 정보가 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "작업지시 수정 중 오류가 발생했습니다.");
		}

		return "redirect:/production/workorder/detail?orderId="
				+ productionDTO.getOrderId();
	}


	// =========================================================
	// 3. 생산실적 등록
	// =========================================================

	// 생산실적 등록 목록 화면이다.
	@RequestMapping("/production/productionresult")
	public String productionResult(
			ProductionDTO productionDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		int totalCount = productionService.selectProductionResultCount(productionDTO);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		List<ProductionDTO> list =
				productionService.selectProductionResultList(productionDTO);

		List<String> productionResultStatusList =
				productionService.selectProductionResultStatusList();

		List<ProductionDTO> productionResultOrderList =
				productionService.selectProductionResultOrderList();

		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// QR 스캔으로 진입한 경우 자동입력할 작업지시 정보이다.
		ProductionDTO qrOrder = null;

		if ("Y".equals(productionDTO.getOpenModal())
				&& productionDTO.getOrderId() != null) {

			try {
				qrOrder = productionService.selectProductionResultOrderByQr(productionDTO);

			} catch (Exception e) {
				qrOrder = null;
			}
		}

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/production/productionresult");

		model.addAttribute("productionResultStatusList", productionResultStatusList);
		model.addAttribute("productionResultOrderList", productionResultOrderList);
		model.addAttribute("empList", empList);

		model.addAttribute("prodStatus", productionDTO.getProdStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		// QR 진입 모달 자동 오픈용 값이다.
		model.addAttribute("openModal", productionDTO.getOpenModal());
		model.addAttribute("qrOrder", qrOrder);
		model.addAttribute("qrOrderId", productionDTO.getOrderId());
		model.addAttribute("qrProductLot", productionDTO.getProductLot());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산실적 등록");

		return "production/productionresult.tiles";
	}


	// 생산실적을 등록한다.
	@RequestMapping(value = "/production/productionresult/insert", method = RequestMethod.POST)
	public String insertProductionResult(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.insertProductionResult(productionDTO);
			rttr.addFlashAttribute("msg", "생산실적이 등록되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산실적 등록 중 오류가 발생했습니다.");
		}

		return "redirect:/production/productionresult";
	}


	// 생산실적 상세 화면이다.
	@RequestMapping("/production/productionresult/detail")
	public String productionResultDetail(
			@RequestParam("prodId") Integer prodId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		ProductionDTO result = productionService.selectProductionResultDetail(prodId);
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		model.addAttribute("result", result);
		model.addAttribute("mode", mode);
		model.addAttribute("empList", empList);

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "생산실적 상세");

		return "production/productionresultdetail.tiles";
	}


	// 생산실적 상세 수정 처리이다.
	@RequestMapping(value = "/production/productionresult/update", method = RequestMethod.POST)
	public String updateProductionResult(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.updateProductionResult(productionDTO);
			rttr.addFlashAttribute("msg", "생산실적 정보가 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산실적 수정 중 오류가 발생했습니다.");
		}

		return "redirect:/production/productionresult/detail?prodId="
				+ productionDTO.getProdId();
	}


	// =========================================================
	// 4. 공정진행 현황
	// =========================================================

	// 공정진행 현황 목록 화면이다.
	@RequestMapping("/production/processprogress")
	public String processProgress(
			ProductionDTO productionDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		int totalCount = productionService.selectProcessProgressCount(productionDTO);

		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		int startRow = (page - 1) * size + 1;
		int endRow = page * size;

		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		List<ProductionDTO> list =
				productionService.selectProcessProgressList(productionDTO);

		List<String> processProgressStatusList =
				productionService.selectProcessProgressStatusList();

		List<ProductionDTO> processProgressOrderList =
				productionService.selectProductionResultOrderList();

		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/production/processprogress");

		model.addAttribute("processProgressStatusList", processProgressStatusList);
		model.addAttribute("processProgressOrderList", processProgressOrderList);
		model.addAttribute("empList", empList);

		model.addAttribute("progressStatus", productionDTO.getProgressStatus());
		model.addAttribute("prodStatus", productionDTO.getProdStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "공정진행 현황");

		return "production/processprogress.tiles";
	}


	// 공정진행을 등록한다.
	@RequestMapping(value = "/production/processprogress/insert", method = RequestMethod.POST)
	public String insertProcessProgress(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.insertProductionResult(productionDTO);
			rttr.addFlashAttribute("msg", "공정진행 정보가 등록되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "공정진행 등록 중 오류가 발생했습니다.");
		}

		return "redirect:/production/processprogress";
	}


	// 공정진행 상세 화면이다.
	@RequestMapping("/production/processprogress/detail")
	public String processProgressDetail(
			@RequestParam("orderId") Integer orderId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		ProductionDTO progress = productionService.selectProcessProgressDetail(orderId);
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		model.addAttribute("progress", progress);
		model.addAttribute("mode", mode);
		model.addAttribute("empList", empList);

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "공정진행 상세");

		return "production/processprogressdetail.tiles";
	}


	// 공정진행 상세 수정 처리이다.
	@RequestMapping(value = "/production/processprogress/update", method = RequestMethod.POST)
	public String updateProcessProgress(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			productionService.updateProductionResult(productionDTO);
			rttr.addFlashAttribute("msg", "공정진행 정보가 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "공정진행 수정 중 오류가 발생했습니다.");
		}

		return "redirect:/production/processprogress/detail?orderId="
				+ productionDTO.getOrderId();
	}
}