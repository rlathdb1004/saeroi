package kr.or.saeroi.controller;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.or.saeroi.Chart.ChartService;
import kr.or.saeroi.dto.BoradDTO;
import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.BoardService;
import kr.or.saeroi.service.ProductionService;
import kr.or.saeroi.service.QualityService;

@Controller
public class DashboardController {

	@Autowired
	private BoardService boardService;

	@Autowired
	private ProductionService productionService;

	@Autowired
	private QualityService qualityService;

	@Autowired
	private ChartService chartService;

	@GetMapping("/dashboard")
	public String main(Model model, HttpSession session) {
		// 첫 화면 대시보드에 필요한 데이터를 조회한다.
		setDashboardNotice(model, session);
		setDashboardWorkOrder(model);
		setDashboardDefectTop5(model);
		setDashboardProductionChart(model);
		setDashboardDefectChart(model);

		return "dashboard.tiles";
	}

	@GetMapping("/")
	public String dashboard(Model model, HttpSession session) {
		// 대시보드 메뉴 진입 시 필요한 데이터를 조회한다.
		setDashboardNotice(model, session);
		setDashboardWorkOrder(model);
		setDashboardDefectTop5(model);
		setDashboardProductionChart(model);
		setDashboardDefectChart(model);

		return "dashboard.tiles";
	}

	// 대시보드 공지사항 최근 5개를 조회한다.
	private void setDashboardNotice(Model model, HttpSession session) {
		LoginDTO loginUser = (LoginDTO) session.getAttribute("loginUser");
		String role = null;

		if (loginUser != null) {
			role = loginUser.getRole();
		}

		List<BoradDTO> dashNoticeList =
				boardService._ser_select_Notice(null, null, null, role);

		if (dashNoticeList != null && dashNoticeList.size() > 5) {
			dashNoticeList = dashNoticeList.subList(0, 5);
		}

		model.addAttribute("dashNoticeList", dashNoticeList);
	}

	// 대시보드 최근 작업지시 5개를 조회한다.
	private void setDashboardWorkOrder(Model model) {
		ProductionDTO productionDTO = new ProductionDTO();

		productionDTO.setStartRow(1);
		productionDTO.setEndRow(5);

		List<ProductionDTO> dashWorkOrderList =
				productionService.selectWorkOrderList(productionDTO);

		model.addAttribute("dashWorkOrderList", dashWorkOrderList);
	}

	// 대시보드 최근 7일 불량유형별 수량 TOP5를 조회한다.
	private void setDashboardDefectTop5(Model model) {
		List<DefectDTO> dashDefectTopList =
				qualityService._ser_select_Dashboard_DefectTop5();

		System.out.println("대시보드 불량 TOP5 건수 : " + dashDefectTopList.size());

		model.addAttribute("dashDefectTopList", dashDefectTopList);
	}

	// 대시보드 생산실적 추이 데이터를 조회한다.
	private void setDashboardProductionChart(Model model) {
		List<Map<String, Object>> dashProductionTrendList =
				chartService.dashboardProductionTrend();
		System.out.println("대시보드 생산실적 추이 데이터 : " + dashProductionTrendList);

		Map<String, Object> dashProductionSummary =
				chartService.dashboardProductionSummary();

		model.addAttribute("dashProductionTrendList", dashProductionTrendList);

		model.addAttribute("dashProdWeekResult",
				getNumberValue(dashProductionSummary, "CURRPRODQTY"));

		model.addAttribute("dashProdPlanRate",
				getNumberValue(dashProductionSummary, "PLANRATE"));

		BigDecimal weekCompareRate =
				getNumberValue(dashProductionSummary, "WEEKCOMPARERATE");

		model.addAttribute("dashProdWeekCompareRate", weekCompareRate.abs());

		String weekCompareType =
				String.valueOf(dashProductionSummary.get("WEEKCOMPARETYPE"));

		if ("down".equals(weekCompareType)) {
			model.addAttribute("dashProdWeekCompareArrow", "▼");
			model.addAttribute("dashProdWeekCompareClass", "dash-red-text");
		} else {
			model.addAttribute("dashProdWeekCompareArrow", "▲");
			model.addAttribute("dashProdWeekCompareClass", "dash-green-text");
		}
	}

	// 대시보드 불량 추이 데이터를 조회한다.
	private void setDashboardDefectChart(Model model) {
		List<Map<String, Object>> dashDefectTrendList =
				chartService.dashboardDefectTrend();

		Map<String, Object> dashDefectSummary =
				chartService.dashboardDefectSummary();

		model.addAttribute("dashDefectTrendList", dashDefectTrendList);

		model.addAttribute("dashDefectWeekRate",
				getNumberValue(dashDefectSummary, "CURRDEFECTRATE"));

		model.addAttribute("dashDefectWeekQty",
				getNumberValue(dashDefectSummary, "CURRDEFECTQTY"));

		BigDecimal weekCompareRate =
				getNumberValue(dashDefectSummary, "WEEKCOMPARERATE");

		model.addAttribute("dashDefectWeekCompareRate", weekCompareRate.abs());

		String weekCompareType =
				String.valueOf(dashDefectSummary.get("WEEKCOMPARETYPE"));

		if ("bad".equals(weekCompareType)) {
			model.addAttribute("dashDefectWeekCompareArrow", "▲");
			model.addAttribute("dashDefectWeekCompareClass", "dash-red-text");
		} else if ("good".equals(weekCompareType)) {
			model.addAttribute("dashDefectWeekCompareArrow", "▼");
			model.addAttribute("dashDefectWeekCompareClass", "dash-green-text");
		} else {
			model.addAttribute("dashDefectWeekCompareArrow", "-");
			model.addAttribute("dashDefectWeekCompareClass", "dash-neutral-text");
		}
	}
	
	// Map 숫자 값을 안전하게 BigDecimal로 변환한다.
	private BigDecimal getNumberValue(Map<String, Object> map, String key) {
		if (map == null || map.get(key) == null) {
			return BigDecimal.ZERO;
		}

		Object value = map.get(key);

		if (value instanceof BigDecimal) {
			return (BigDecimal) value;
		}

		if (value instanceof Number) {
			return new BigDecimal(String.valueOf(value));
		}

		return BigDecimal.ZERO;
	}
}