package kr.or.saeroi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.ProductionService;

// 생산관리 화면 요청을 처리하는 Controller이다.
@Controller
public class ProductionController {

	// 생산관리 Service를 주입받는다.
	@Autowired
	private ProductionService productionService;

	// 생산계획관리 목록 화면이다.
	@RequestMapping("/production/productionplan")
	public String productionPlan(
			ProductionDTO productionDTO,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			Model model) {

		// 검색 조건을 포함한 전체 건수를 DB에서 조회한다.
		int totalCount =
				productionService.selectProductionPlanCount(productionDTO);

		// 공통 페이징 객체를 생성한다.
		// 기존 paging.jsp에서 pageInfo를 사용하므로 반드시 model에 담아야 한다.
		PageDTO pageInfo =
				new PageDTO(page, size, totalCount);

		// Oracle ROWNUM 페이징 시작 행 번호이다.
		int startRow =
				(page - 1) * size + 1;

		// Oracle ROWNUM 페이징 마지막 행 번호이다.
		int endRow =
				page * size;

		// Mapper에서 페이징 조건으로 사용할 값을 DTO에 담는다.
		productionDTO.setStartRow(startRow);
		productionDTO.setEndRow(endRow);

		// 현재 페이지에 보여줄 생산계획 목록을 DB에서 조회한다.
		List<ProductionDTO> list =
				productionService.selectProductionPlanList(productionDTO);

		// 검색 조건 select box에 보여줄 품목 구분 목록을 DB에서 조회한다.
		List<String> itemTypeList =
				productionService.selectItemTypeList();

		// 기존 공통 JSP 구조에 맞춘 목록 변수명이다.
		model.addAttribute("list", list);

		// 기존 공통 JSP 구조에 맞춘 페이징 정보이다.
		model.addAttribute("pageInfo", pageInfo);

		// 기존 공통 paging.jsp에서 사용할 URL이다.
		model.addAttribute("pageUrl", "/production/productionplan");

		// 검색 조건 select box 목록이다.
		model.addAttribute("itemTypeList", itemTypeList);

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
		ProductionDTO production =
				productionService.selectProductionPlanDetail(prodPlanId);

		// 상세 JSP에서 사용할 생산계획 데이터이다.
		model.addAttribute("production", production);

		// 수정 모드 여부를 JSP로 전달한다.
		model.addAttribute("mode", mode);

		// 공통 header.jsp에서 사용할 상단 제목이다.
		model.addAttribute("headerTitle", "생산관리");

		// 공통 header.jsp에서 사용할 상단 부제목이다.
		model.addAttribute("headerSubTitle", "생산계획 상세");

		return "production/productionplandetail.tiles";
	}


	// 생산계획 상세 수정 처리이다.
	@RequestMapping(value = "/production/productionplan/update", method = RequestMethod.POST)
	public String updateProductionPlan(ProductionDTO productionDTO) {

		// 생산계획 정보를 수정한다.
		productionService.updateProductionPlan(productionDTO);

		return "redirect:/production/productionplan/detail?prodPlanId="
				+ productionDTO.getProdPlanId();
	}
}