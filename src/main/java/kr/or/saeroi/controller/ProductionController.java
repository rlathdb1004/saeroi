package kr.or.saeroi.controller;

import java.util.Collections;
import java.util.List;

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

		// 검색 조건을 포함한 전체 건수를 DB에서 조회한다.
		int totalCount = productionService.selectProductionPlanCount(productionDTO);

		// 공통 페이징 객체를 생성한다.
		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		// Oracle ROWNUM 페이징 시작 행 번호이다.
		int startRow = (page - 1) * size + 1;

		// Oracle ROWNUM 페이징 마지막 행 번호이다.
		int endRow = page * size;

		// Mapper에서 페이징 조건으로 사용할 값을 DTO에 담는다.
		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		// 현재 페이지에 보여줄 생산계획 목록을 DB에서 조회한다.
		List<ProductionDTO> list = productionService.selectProductionPlanList(productionDTO);

		// 검색 조건 select box에 보여줄 품목 구분 목록을 DB에서 조회한다.
		List<String> itemTypeList = productionService.selectItemTypeList();

		// 등록 모달에서 사용할 품목 목록을 DB에서 조회한다.
		List<ProductionDTO> itemList = productionService.selectItemList();

		// 기존 공통 JSP 구조에 맞춘 목록 변수명이다.
		model.addAttribute("list", list);

		// 기존 공통 JSP 구조에 맞춘 페이징 정보이다.
		model.addAttribute("pageInfo", pageInfo);

		// 기존 공통 paging.jsp에서 사용할 URL이다.
		model.addAttribute("pageUrl", "/production/productionplan");

		// 검색 조건 select box 목록이다.
		model.addAttribute("itemTypeList", itemTypeList);

		// 등록 모달 품목 목록이다.
		model.addAttribute("itemList", itemList);

		// 검색 조건 유지용 값이다.
		model.addAttribute("itemType", productionDTO.getItemType());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "생산계획 관리");

		// Tiles가 /WEB-INF/views/production/productionplan.jsp를 찾도록 반환한다.
		return "production/productionplan.tiles";
	}


	// 생산계획 상세 화면이다.
	@RequestMapping("/production/productionplan/detail")
	public String productionPlanDetail(
			@RequestParam("prodPlanId") Integer prodPlanId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		// 생산계획 ID 기준으로 상세 정보를 DB에서 조회한다.
		ProductionDTO production = productionService.selectProductionPlanDetail(prodPlanId);

		// 상세 JSP에서 사용할 생산계획 데이터이다.
		model.addAttribute("production", production);

		// 수정 모드 여부를 JSP로 전달한다.
		model.addAttribute("mode", mode);

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "생산계획 상세");

		// Tiles가 /WEB-INF/views/production/productionplandetail.jsp를 찾도록 반환한다.
		return "production/productionplandetail.tiles";
	}


	// 생산계획을 등록한다.
	@RequestMapping(value = "/production/productionplan/insert", method = RequestMethod.POST)
	public String insertProductionPlan(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// 등록 모달에서 입력한 값으로 생산계획을 등록한다.
			productionService.insertProductionPlan(productionDTO);

			rttr.addFlashAttribute("msg", "생산계획이 등록되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산계획 등록 중 오류가 발생했습니다.");
		}

		// 등록 후 생산계획 목록으로 이동한다.
		return "redirect:/production/productionplan";
	}


	// 생산계획 상세 수정 처리이다.
	@RequestMapping(value = "/production/productionplan/update", method = RequestMethod.POST)
	public String updateProductionPlan(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// 생산계획 정보를 수정한다.
			productionService.updateProductionPlan(productionDTO);

			rttr.addFlashAttribute("msg", "생산계획이 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산계획 수정 중 오류가 발생했습니다.");
		}

		// 수정 후 다시 상세 화면으로 이동한다.
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

		// 검색 조건을 포함한 작업지시 전체 건수를 DB에서 조회한다.
		int totalCount = productionService.selectWorkOrderCount(productionDTO);

		// 공통 페이징 객체를 생성한다.
		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		// Oracle ROWNUM 페이징 시작 행 번호이다.
		int startRow = (page - 1) * size + 1;

		// Oracle ROWNUM 페이징 마지막 행 번호이다.
		int endRow = page * size;

		// Mapper에서 페이징 조건으로 사용할 값을 DTO에 담는다.
		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		// 현재 페이지에 보여줄 작업지시 목록을 DB에서 조회한다.
		List<ProductionDTO> list = productionService.selectWorkOrderList(productionDTO);

		// 검색 조건 select box에 보여줄 작업상태 목록을 DB에서 조회한다.
		List<String> workOrderStatusList = productionService.selectWorkOrderStatusList();

		// 등록 모달에서 사용할 생산계획 목록을 DB에서 조회한다.
		List<ProductionDTO> workOrderPlanList = productionService.selectWorkOrderPlanList();

		// 등록 모달에서 사용할 라인 목록을 DB에서 조회한다.
		List<ProductionDTO> lineList = productionService.selectLineList();

		// 등록 모달에서 사용할 담당자 목록을 DB에서 조회한다.
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// 기존 공통 JSP 구조에 맞춘 목록 변수명이다.
		model.addAttribute("list", list);

		// 기존 공통 JSP 구조에 맞춘 페이징 정보이다.
		model.addAttribute("pageInfo", pageInfo);

		// 기존 공통 paging.jsp에서 사용할 URL이다.
		model.addAttribute("pageUrl", "/production/workorder");

		// 작업지시 화면에서 사용할 목록이다.
		model.addAttribute("workOrderStatusList", workOrderStatusList);
		model.addAttribute("workOrderPlanList", workOrderPlanList);
		model.addAttribute("lineList", lineList);
		model.addAttribute("empList", empList);

		// 검색 조건 유지용 값이다.
		model.addAttribute("prodStatus", productionDTO.getProdStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "작업지시 관리");

		// Tiles가 /WEB-INF/views/production/workorder.jsp를 찾도록 반환한다.
		return "production/workorder.tiles";
	}


	// 작업지시를 등록한다.
	@RequestMapping(value = "/production/workorder/insert", method = RequestMethod.POST)
	public String insertWorkOrder(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			/*
			 * 작업지시 등록 처리이다.
			 *
			 * Service에서 처리하는 흐름:
			 * 1. WORK_ORDER 등록
			 * 2. 생성된 orderId 확보
			 * 3. 생산계획의 완제품 기준 사용 BOM 조회
			 * 4. BOM_DETAIL 기준 원자재 필요수량 계산
			 * 5. MATERIAL_INOUT에 MO-PROD 원자재 투입 이력 자동 생성
			 */
			productionService.insertWorkOrder(productionDTO);

			rttr.addFlashAttribute("msg", "작업지시가 등록되었고 BOM 기준 원자재 투입 이력이 생성되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "작업지시 등록 중 오류가 발생했습니다.");
		}

		// 등록 후 작업지시 목록으로 이동한다.
		return "redirect:/production/workorder";
	}


	// 작업지시 상세 화면이다.
	@RequestMapping("/production/workorder/detail")
	public String workOrderDetail(
			@RequestParam("orderId") Integer orderId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		// 작업지시 ID 기준으로 상세 정보를 DB에서 조회한다.
		ProductionDTO workOrder = productionService.selectWorkOrderDetail(orderId);

		// 수정 모드에서 사용할 라인 목록이다.
		List<ProductionDTO> lineList = productionService.selectLineList();

		// 수정 모드에서 사용할 담당자 목록이다.
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// 작업지시에 적용된 BOM 마스터 정보이다.
		ProductionDTO appliedBom = null;

		// 작업지시 기준 BOM 상세 원자재 목록이다.
		List<ProductionDTO> bomMaterialList = Collections.emptyList();

		// 작업지시 등록 시 자동 생성된 원자재 투입 이력 목록이다.
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
			/*
			 * 기존 작업지시 중 BOM/자재투입 이력이 없는 데이터가 있을 수 있으므로
			 * 상세 화면 자체는 깨지지 않도록 빈 값으로 전달한다.
			 */
			appliedBom = null;
			bomMaterialList = Collections.emptyList();
			materialInoutList = Collections.emptyList();
		}

		// 상세 JSP에서 사용할 작업지시 데이터이다.
		model.addAttribute("workOrder", workOrder);

		// 수정 모드 여부를 JSP로 전달한다.
		model.addAttribute("mode", mode);

		// 수정 select box에서 사용할 목록이다.
		model.addAttribute("lineList", lineList);
		model.addAttribute("empList", empList);

		// BOM/원자재 투입 표시용 데이터이다.
		model.addAttribute("appliedBom", appliedBom);
		model.addAttribute("bomMaterialList", bomMaterialList);
		model.addAttribute("materialInoutList", materialInoutList);

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "작업지시 상세");

		// Tiles가 /WEB-INF/views/production/workorderdetail.jsp를 찾도록 반환한다.
		return "production/workorderdetail.tiles";
	}


	// 작업지시 상세 수정 처리이다.
	@RequestMapping(value = "/production/workorder/update", method = RequestMethod.POST)
	public String updateWorkOrder(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// LOT번호와 작업지시번호는 수정하지 않고 기본 작업지시 정보만 수정한다.
			productionService.updateWorkOrder(productionDTO);

			rttr.addFlashAttribute("msg", "작업지시 정보가 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "작업지시 수정 중 오류가 발생했습니다.");
		}

		// 수정 후 다시 상세 화면으로 이동한다.
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

		// 검색 조건을 포함한 생산실적 전체 건수를 DB에서 조회한다.
		int totalCount = productionService.selectProductionResultCount(productionDTO);

		// 공통 페이징 객체를 생성한다.
		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		// Oracle ROWNUM 페이징 시작 행 번호이다.
		int startRow = (page - 1) * size + 1;

		// Oracle ROWNUM 페이징 마지막 행 번호이다.
		int endRow = page * size;

		// Mapper에서 페이징 조건으로 사용할 값을 DTO에 담는다.
		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		// 현재 페이지에 보여줄 생산실적 목록을 DB에서 조회한다.
		List<ProductionDTO> list = productionService.selectProductionResultList(productionDTO);

		// 검색 조건 select box에 보여줄 생산상태 목록을 DB에서 조회한다.
		List<String> productionResultStatusList = productionService.selectProductionResultStatusList();

		// 등록 모달에서 사용할 작업지시 목록을 DB에서 조회한다.
		List<ProductionDTO> productionResultOrderList = productionService.selectProductionResultOrderList();

		// 등록 모달에서 사용할 담당자 목록이다.
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// 기존 공통 JSP 구조에 맞춘 목록 변수명이다.
		model.addAttribute("list", list);

		// 기존 공통 JSP 구조에 맞춘 페이징 정보이다.
		model.addAttribute("pageInfo", pageInfo);

		// 기존 공통 paging.jsp에서 사용할 URL이다.
		model.addAttribute("pageUrl", "/production/productionresult");

		// 생산실적 화면에서 사용할 목록이다.
		model.addAttribute("productionResultStatusList", productionResultStatusList);
		model.addAttribute("productionResultOrderList", productionResultOrderList);
		model.addAttribute("empList", empList);

		// 검색 조건 유지용 값이다.
		model.addAttribute("prodStatus", productionDTO.getProdStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "생산실적 등록");

		// Tiles가 /WEB-INF/views/production/productionresult.jsp를 찾도록 반환한다.
		return "production/productionresult.tiles";
	}


	// 생산실적을 등록한다.
	@RequestMapping(value = "/production/productionresult/insert", method = RequestMethod.POST)
	public String insertProductionResult(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// 생산실적은 기존 작업지시 LOT번호를 기준으로 PRODUCTION 테이블에 등록한다.
			productionService.insertProductionResult(productionDTO);

			rttr.addFlashAttribute("msg", "생산실적이 등록되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산실적 등록 중 오류가 발생했습니다.");
		}

		// 등록 후 생산실적 목록으로 이동한다.
		return "redirect:/production/productionresult";
	}


	// 생산실적 상세 화면이다.
	@RequestMapping("/production/productionresult/detail")
	public String productionResultDetail(
			@RequestParam("prodId") Integer prodId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		// 생산실적 ID 기준으로 상세 정보를 DB에서 조회한다.
		ProductionDTO result = productionService.selectProductionResultDetail(prodId);

		// 수정 모드에서 사용할 담당자 목록이다.
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// 상세 JSP에서 사용할 생산실적 데이터이다.
		model.addAttribute("result", result);

		// 수정 모드 여부를 JSP로 전달한다.
		model.addAttribute("mode", mode);

		// 수정 select box에서 사용할 담당자 목록이다.
		model.addAttribute("empList", empList);

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "생산실적 상세");

		// Tiles가 /WEB-INF/views/production/productionresultdetail.jsp를 찾도록 반환한다.
		return "production/productionresultdetail.tiles";
	}


	// 생산실적 상세 수정 처리이다.
	@RequestMapping(value = "/production/productionresult/update", method = RequestMethod.POST)
	public String updateProductionResult(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// LOT번호와 실적번호는 수정하지 않고 기본 생산실적 정보만 수정한다.
			productionService.updateProductionResult(productionDTO);

			rttr.addFlashAttribute("msg", "생산실적 정보가 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "생산실적 수정 중 오류가 발생했습니다.");
		}

		// 수정 후 다시 생산실적 상세 화면으로 이동한다.
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

		// 검색 조건을 포함한 공정진행 현황 전체 건수를 DB에서 조회한다.
		int totalCount = productionService.selectProcessProgressCount(productionDTO);

		// 공통 페이징 객체를 생성한다.
		PageDTO pageInfo = new PageDTO(page, size, totalCount);

		// Oracle ROWNUM 페이징 시작 행 번호이다.
		int startRow = (page - 1) * size + 1;

		// Oracle ROWNUM 페이징 마지막 행 번호이다.
		int endRow = page * size;

		// Mapper에서 페이징 조건으로 사용할 값을 DTO에 담는다.
		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		// 현재 페이지에 보여줄 공정진행 현황 목록을 DB에서 조회한다.
		List<ProductionDTO> list = productionService.selectProcessProgressList(productionDTO);

		// 검색 조건 select box에 보여줄 진행상태 목록을 DB에서 조회한다.
		List<String> processProgressStatusList = productionService.selectProcessProgressStatusList();

		// 공정진행 등록 모달에서 사용할 작업지시 목록이다.
		List<ProductionDTO> processProgressOrderList = productionService.selectProductionResultOrderList();

		// 공정진행 등록 모달에서 사용할 담당자 목록이다.
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// 기존 공통 JSP 구조에 맞춘 목록 변수명이다.
		model.addAttribute("list", list);

		// 기존 공통 JSP 구조에 맞춘 페이징 정보이다.
		model.addAttribute("pageInfo", pageInfo);

		// 기존 공통 paging.jsp에서 사용할 URL이다.
		model.addAttribute("pageUrl", "/production/processprogress");

		// 공정진행 현황 검색 select box 목록이다.
		model.addAttribute("processProgressStatusList", processProgressStatusList);

		// 공정진행 등록 모달에서 사용할 목록이다.
		model.addAttribute("processProgressOrderList", processProgressOrderList);
		model.addAttribute("empList", empList);

		// 검색 조건 유지용 값이다.
		model.addAttribute("progressStatus", productionDTO.getProgressStatus());
		model.addAttribute("keyword", productionDTO.getKeyword());
		model.addAttribute("startDate", productionDTO.getStartDate());
		model.addAttribute("endDate", productionDTO.getEndDate());

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "공정진행 현황");

		// Tiles가 /WEB-INF/views/production/processprogress.jsp를 찾도록 반환한다.
		return "production/processprogress.tiles";
	}


	// 공정진행을 등록한다.
	@RequestMapping(value = "/production/processprogress/insert", method = RequestMethod.POST)
	public String insertProcessProgress(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// 공정진행 등록은 PRODUCTION 테이블에 생산실적을 등록하는 구조이다.
			productionService.insertProductionResult(productionDTO);

			rttr.addFlashAttribute("msg", "공정진행 정보가 등록되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "공정진행 등록 중 오류가 발생했습니다.");
		}

		// 등록 후 공정진행 현황으로 이동한다.
		return "redirect:/production/processprogress";
	}


	// 공정진행 상세 화면이다.
	@RequestMapping("/production/processprogress/detail")
	public String processProgressDetail(
			@RequestParam("orderId") Integer orderId,
			@RequestParam(value = "mode", required = false) String mode,
			Model model) {

		// 작업지시 ID 기준으로 공정진행 상세 정보를 조회한다.
		ProductionDTO progress = productionService.selectProcessProgressDetail(orderId);

		// 수정 모드에서 사용할 담당자 목록이다.
		List<ProductionDTO> empList = productionService.selectWorkOrderEmpList();

		// 상세 JSP에서 사용할 공정진행 데이터이다.
		model.addAttribute("progress", progress);

		// 수정 모드 여부를 JSP로 전달한다.
		model.addAttribute("mode", mode);

		// 수정 select box에서 사용할 담당자 목록이다.
		model.addAttribute("empList", empList);

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "공정진행 상세");

		// Tiles가 /WEB-INF/views/production/processprogressdetail.jsp를 찾도록 반환한다.
		return "production/processprogressdetail.tiles";
	}


	// 공정진행 상세 수정 처리이다.
	@RequestMapping(value = "/production/processprogress/update", method = RequestMethod.POST)
	public String updateProcessProgress(
			ProductionDTO productionDTO,
			RedirectAttributes rttr) {

		try {
			// 공정진행 수정은 최신 생산실적 정보를 수정하는 구조이다.
			productionService.updateProductionResult(productionDTO);

			rttr.addFlashAttribute("msg", "공정진행 정보가 수정되었습니다.");

		} catch (IllegalArgumentException e) {
			rttr.addFlashAttribute("msg", e.getMessage());

		} catch (Exception e) {
			rttr.addFlashAttribute("msg", "공정진행 수정 중 오류가 발생했습니다.");
		}

		// 수정 후 다시 공정진행 상세 화면으로 이동한다.
		return "redirect:/production/processprogress/detail?orderId="
				+ productionDTO.getOrderId();
	}
}