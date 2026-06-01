package kr.or.saeroi.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
		setDashboardKpi(model);
		setDashboardNotice(model, session);
		setDashboardWorkOrder(model);
		setDashboardDefectTop5(model);
		setDashboardProductionChart(model);
		setDashboardDefectChart(model);
		setDashboardCostChart(model);
		setDashboardFacilityChart(model);
		setDashboardLotStatus(model);
		setDashboardIssueStatus(model);

		return "dashboard.tiles";
	}

	@GetMapping("/")
	public String dashboard(Model model, HttpSession session) {
		// 대시보드 메뉴 진입 시 필요한 데이터를 조회한다.
		setDashboardKpi(model);
		setDashboardNotice(model, session);
		setDashboardWorkOrder(model);
		setDashboardDefectTop5(model);
		setDashboardProductionChart(model);
		setDashboardDefectChart(model);
		setDashboardCostChart(model);
		setDashboardFacilityChart(model);
		setDashboardLotStatus(model);
		setDashboardIssueStatus(model);

		return "dashboard.tiles";
	}
	
	// KPI 상세 모달 주차별 데이터를 조회한다.
	@GetMapping("/dashboard/kpi/week-detail")
	@ResponseBody
	public Map<String, Object> dashboardKpiWeekDetail(
			@RequestParam(value = "kpiType", required = false) String kpiType,
			@RequestParam(value = "baseDate", required = false) String baseDate) {

		Map<String, Object> result = new HashMap<>();

		if (!isAllowedKpiType(kpiType)) {
			result.put("success", false);
			result.put("message", "허용되지 않은 KPI 유형입니다.");
			return result;
		}

		String searchBaseDate = baseDate;

		if (searchBaseDate == null || searchBaseDate.trim().isEmpty()) {
			searchBaseDate = LocalDate.now().toString();
		}

		Map<String, Object> param = new HashMap<>();
		param.put("kpiType", kpiType);
		param.put("baseDate", searchBaseDate);

		List<Map<String, Object>> kpiWeekList =
				chartService.dashboardKpiWeekDetail(param);

		result.put("success", true);
		result.put("kpiType", kpiType);
		result.put("baseDate", searchBaseDate);
		result.put("kpiWeekList", kpiWeekList);

		return result;
	}

	// KPI 상세 모달에서 허용된 KPI 유형인지 확인한다.
	private boolean isAllowedKpiType(String kpiType) {
		return "achievement".equals(kpiType)
				|| "production".equals(kpiType)
				|| "defect".equals(kpiType)
				|| "cost".equals(kpiType)
				|| "oee".equals(kpiType)
				|| "delay".equals(kpiType);
	}
	
	// 대시보드 KPI 핵심 6대 지표 데이터를 조회한다.
	private void setDashboardKpi(Model model) {
		Map<String, Object> dashKpiSummary = chartService.dashboardKpiSummary();

		BigDecimal prodTargetQty = getNumberValue(dashKpiSummary, "PRODTARGETQTY");
		BigDecimal prevProdTargetQty = getNumberValue(dashKpiSummary, "PREVPRODTARGETQTY");
		BigDecimal prodActualQty = getNumberValue(dashKpiSummary, "PRODACTUALQTY");
		BigDecimal achievementRate = getNumberValue(dashKpiSummary, "ACHIEVEMENTRATE");
		BigDecimal achievementComparePoint = getNumberValue(dashKpiSummary, "ACHIEVEMENTCOMPAREPOINT");

		model.addAttribute("dashKpiProdTargetQty", prodTargetQty);
		model.addAttribute("dashKpiPrevProdTargetQty", prevProdTargetQty);
		model.addAttribute("dashKpiProdActualQty", prodActualQty);
		model.addAttribute("dashKpiAchievementRate", achievementRate);
		model.addAttribute("dashKpiAchievementComparePoint", achievementComparePoint.abs());

		setCompareDisplay(model,
				achievementComparePoint,
				"dashKpiAchievementCompare",
				true,
				prevProdTargetQty.compareTo(BigDecimal.ZERO) > 0);

		BigDecimal todayProdQty = getNumberValue(dashKpiSummary, "TODAYPRODQTY");
		BigDecimal prevProdQty = getNumberValue(dashKpiSummary, "PREVPRODQTY");
		BigDecimal todayProdCompareQty = getNumberValue(dashKpiSummary, "TODAYPRODCOMPAREQTY");

		model.addAttribute("dashKpiTodayProdQty", todayProdQty);
		model.addAttribute("dashKpiPrevProdQty", prevProdQty);
		model.addAttribute("dashKpiTodayProdCompareQty", todayProdCompareQty.abs());

		setCompareDisplay(model,
				todayProdCompareQty,
				"dashKpiTodayProdCompare",
				true,
				prevProdQty.compareTo(BigDecimal.ZERO) > 0);

		BigDecimal defectRate = getNumberValue(dashKpiSummary, "DEFECTRATE");
		BigDecimal defectQty = getNumberValue(dashKpiSummary, "DEFECTQTY");
		BigDecimal inspectionQty = getNumberValue(dashKpiSummary, "INSPECTIONQTY");
		BigDecimal prevInspectionQty = getNumberValue(dashKpiSummary, "PREVINSPECTIONQTY");
		BigDecimal defectComparePoint = getNumberValue(dashKpiSummary, "DEFECTCOMPAREPOINT");

		model.addAttribute("dashKpiDefectRate", defectRate);
		model.addAttribute("dashKpiDefectQty", defectQty);
		model.addAttribute("dashKpiInspectionQty", inspectionQty);
		model.addAttribute("dashKpiPrevInspectionQty", prevInspectionQty);
		model.addAttribute("dashKpiDefectComparePoint", defectComparePoint.abs());

		setCompareDisplay(model,
				defectComparePoint,
				"dashKpiDefectCompare",
				false,
				prevInspectionQty.compareTo(BigDecimal.ZERO) > 0);
		
		BigDecimal costActual = getNumberValue(dashKpiSummary, "COSTACTUAL");
		BigDecimal costPrev = getNumberValue(dashKpiSummary, "COSTPREV");
		BigDecimal costTarget = getNumberValue(dashKpiSummary, "COSTTARGET");
		BigDecimal costCompareValue = getNumberValue(dashKpiSummary, "COSTCOMPAREVALUE");

		model.addAttribute("dashKpiCostActual", costActual);
		model.addAttribute("dashKpiCostPrev", costPrev);
		model.addAttribute("dashKpiCostTarget", costTarget);
		model.addAttribute("dashKpiCostCompareValue", costCompareValue.abs());

		setCompareDisplay(model,
				costCompareValue,
				"dashKpiCostCompare",
				false,
				costPrev.compareTo(BigDecimal.ZERO) > 0);

		BigDecimal oeeRate = getNumberValue(dashKpiSummary, "OEERATE");
		BigDecimal oeeRunTime = getNumberValue(dashKpiSummary, "OEERUNTIME");
		BigDecimal oeePlanTime = getNumberValue(dashKpiSummary, "OEEPLANTIME");
		BigDecimal prevOeePlanTime = getNumberValue(dashKpiSummary, "PREVOEEPLANTIME");
		BigDecimal oeeComparePoint = getNumberValue(dashKpiSummary, "OEECOMPAREPOINT");

		model.addAttribute("dashKpiOeeRate", oeeRate);
		model.addAttribute("dashKpiOeeRunTime", oeeRunTime);
		model.addAttribute("dashKpiOeePlanTime", oeePlanTime);
		model.addAttribute("dashKpiPrevOeePlanTime", prevOeePlanTime);
		model.addAttribute("dashKpiOeeComparePoint", oeeComparePoint.abs());

		setCompareDisplay(model,
				oeeComparePoint,
				"dashKpiOeeCompare",
				true,
				prevOeePlanTime.compareTo(BigDecimal.ZERO) > 0);

		BigDecimal delayOrderCount = getNumberValue(dashKpiSummary, "DELAYORDERCOUNT");
		BigDecimal delayQty = getNumberValue(dashKpiSummary, "DELAYQTY");
		BigDecimal delayCompareCount = getNumberValue(dashKpiSummary, "DELAYCOMPARECOUNT");

		model.addAttribute("dashKpiDelayOrderCount", delayOrderCount);
		model.addAttribute("dashKpiDelayQty", delayQty);
		model.addAttribute("dashKpiDelayCompareCount", delayCompareCount.abs());

		setCompareDisplay(model,
				delayCompareCount,
				"dashKpiDelayCompare",
				false,
				true);
	}

	// 전일 대비 표시 방향과 색상을 세팅한다.
	private void setCompareDisplay(Model model, BigDecimal compareValue, String prefix, boolean increaseGood, boolean hasPrevData) {
		String arrow = "";
		String className = "dash-neutral-text";

		if (!hasPrevData) {
			model.addAttribute(prefix + "Arrow", arrow);
			model.addAttribute(prefix + "Class", className);
			model.addAttribute(prefix + "NoPrevData", true);

			return;
		}

		if (compareValue.compareTo(BigDecimal.ZERO) > 0) {
			arrow = "▲";

			if (increaseGood) {
				className = "dash-green-text";
			} else {
				className = "dash-red-text";
			}
		} else if (compareValue.compareTo(BigDecimal.ZERO) < 0) {
			arrow = "▼";

			if (increaseGood) {
				className = "dash-red-text";
			} else {
				className = "dash-green-text";
			}
		}

		model.addAttribute(prefix + "Arrow", arrow);
		model.addAttribute(prefix + "Class", className);
		model.addAttribute(prefix + "NoPrevData", false);
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
	
	// 대시보드 생산원가 추이 데이터를 조회한다.
	private void setDashboardCostChart(Model model) {
		List<Map<String, Object>> dashCostTrendList =
				chartService.dashboardCostTrend();

		Map<String, Object> dashCostSummary =
				chartService.dashboardCostSummary();

		model.addAttribute("dashCostTrendList", dashCostTrendList);

		model.addAttribute("dashCostWeekAvg",
				getNumberValue(dashCostSummary, "CURRACTUALCOST"));

		BigDecimal targetCompareRate =
				getNumberValue(dashCostSummary, "TARGETCOMPARERATE");

		model.addAttribute("dashCostTargetCompareRate", targetCompareRate.abs());

		String targetCompareType =
				String.valueOf(dashCostSummary.get("TARGETCOMPARETYPE"));

		if ("bad".equals(targetCompareType)) {
			model.addAttribute("dashCostTargetCompareArrow", "▲");
			model.addAttribute("dashCostTargetCompareClass", "dash-red-text");
		} else if ("good".equals(targetCompareType)) {
			model.addAttribute("dashCostTargetCompareArrow", "▼");
			model.addAttribute("dashCostTargetCompareClass", "dash-green-text");
		} else {
			model.addAttribute("dashCostTargetCompareArrow", "-");
			model.addAttribute("dashCostTargetCompareClass", "dash-neutral-text");
		}

		BigDecimal weekCompareRate =
				getNumberValue(dashCostSummary, "WEEKCOMPARERATE");

		model.addAttribute("dashCostWeekCompareRate", weekCompareRate.abs());

		String weekCompareType =
				String.valueOf(dashCostSummary.get("WEEKCOMPARETYPE"));

		if ("bad".equals(weekCompareType)) {
			model.addAttribute("dashCostWeekCompareArrow", "▲");
			model.addAttribute("dashCostWeekCompareClass", "dash-red-text");
		} else if ("good".equals(weekCompareType)) {
			model.addAttribute("dashCostWeekCompareArrow", "▼");
			model.addAttribute("dashCostWeekCompareClass", "dash-green-text");
		} else {
			model.addAttribute("dashCostWeekCompareArrow", "-");
			model.addAttribute("dashCostWeekCompareClass", "dash-neutral-text");
		}
	}
	
	// 대시보드 설비 가동 현황 데이터를 조회한다.
	private void setDashboardFacilityChart(Model model) {
		Map<String, Object> dashFacilityStatus =
				chartService.dashboardFacilityStatus();

		model.addAttribute("dashFacilityTotalCount",
				getNumberValue(dashFacilityStatus, "TOTALCOUNT"));

		model.addAttribute("dashFacilityRunningCount",
				getNumberValue(dashFacilityStatus, "RUNNINGCOUNT"));

		model.addAttribute("dashFacilityCheckCount",
				getNumberValue(dashFacilityStatus, "CHECKCOUNT"));

		model.addAttribute("dashFacilityStopCount",
				getNumberValue(dashFacilityStatus, "STOPCOUNT"));

		model.addAttribute("dashFacilityNonRunningCount",
				getNumberValue(dashFacilityStatus, "NONRUNNINGCOUNT"));

		model.addAttribute("dashFacilityRunRate",
				getNumberValue(dashFacilityStatus, "RUNRATE"));

		model.addAttribute("dashFacilityNonRunRate",
				getNumberValue(dashFacilityStatus, "NONRUNRATE"));

		model.addAttribute("dashFacilityCheckRate",
				getNumberValue(dashFacilityStatus, "CHECKRATE"));

		model.addAttribute("dashFacilityStopRate",
				getNumberValue(dashFacilityStatus, "STOPRATE"));

		model.addAttribute("dashFacilityTargetRate",
				getNumberValue(dashFacilityStatus, "TARGETRATE"));

		BigDecimal targetGap =
				getNumberValue(dashFacilityStatus, "TARGETGAP");

		model.addAttribute("dashFacilityTargetGap", targetGap.abs());

		String targetType =
				String.valueOf(dashFacilityStatus.get("TARGETTYPE"));

		if ("good".equals(targetType)) {
			model.addAttribute("dashFacilityTargetArrow", "+");
			model.addAttribute("dashFacilityTargetClass", "dash-green-text");
		} else if ("bad".equals(targetType)) {
			model.addAttribute("dashFacilityTargetArrow", "-");
			model.addAttribute("dashFacilityTargetClass", "dash-red-text");
		} else {
			model.addAttribute("dashFacilityTargetArrow", "");
			model.addAttribute("dashFacilityTargetClass", "dash-neutral-text");
		}
	}
	
	// 대시보드 LOT 현황 데이터를 조회한다.
	private void setDashboardLotStatus(Model model) {
		Map<String, Object> dashLotStatus =
				chartService.dashboardLotStatus();

		model.addAttribute("dashDelayLotCount",
				getNumberValue(dashLotStatus, "DELAYLOTCOUNT"));

		model.addAttribute("dashInspectionWaitLotCount",
				getNumberValue(dashLotStatus, "INSPECTIONWAITLOTCOUNT"));

		model.addAttribute("dashFinishedShipWaitLotCount",
				getNumberValue(dashLotStatus, "FINISHEDSHIPWAITLOTCOUNT"));
	}
	
	
	// 대시보드 현장 이슈 데이터를 조회한다.
	private void setDashboardIssueStatus(Model model) {
		Map<String, Object> dashIssueStatus =
				chartService.dashboardIssueStatus();

		BigDecimal issueCount =
				getNumberValue(dashIssueStatus, "ISSUECOUNT");

		model.addAttribute("dashIssueTotalCount", issueCount);

		if (issueCount.compareTo(BigDecimal.ZERO) > 0) {
			model.addAttribute("dashIssueBoxClass", "dash-issue-danger");
		} else {
			model.addAttribute("dashIssueBoxClass", "dash-issue-normal");
		}

		model.addAttribute("dashDefectIssueYn",
				getStringValue(dashIssueStatus, "DEFECTISSUEYN"));

		model.addAttribute("dashDefectIssueRate",
				getNumberValue(dashIssueStatus, "DEFECTRATE"));

		model.addAttribute("dashDefectStandardRate",
				getNumberValue(dashIssueStatus, "DEFECTSTANDARDRATE"));

		model.addAttribute("dashDefectIssueTime",
				getStringValue(dashIssueStatus, "DEFECTISSUETIME"));

		model.addAttribute("dashTroubleIssueYn",
				getStringValue(dashIssueStatus, "TROUBLEISSUEYN"));

		model.addAttribute("dashTroubleCount",
				getNumberValue(dashIssueStatus, "TROUBLECOUNT"));

		model.addAttribute("dashTroubleIssueTime",
				getStringValue(dashIssueStatus, "TROUBLEISSUETIME"));

		model.addAttribute("dashTroubleMessage",
				getStringValue(dashIssueStatus, "TROUBLEMESSAGE"));

		model.addAttribute("dashDelayIssueYn",
				getStringValue(dashIssueStatus, "DELAYISSUEYN"));

		model.addAttribute("dashDelayOrderCount",
				getNumberValue(dashIssueStatus, "DELAYORDERCOUNT"));

		model.addAttribute("dashDelayIssueTime",
				getStringValue(dashIssueStatus, "DELAYISSUETIME"));
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
	
	// Map 문자 값을 안전하게 String으로 변환한다.
	private String getStringValue(Map<String, Object> map, String key) {
		if (map == null || map.get(key) == null) {
			return "";
		}

		return String.valueOf(map.get(key));
	}
	
	// 생산달성률 상세 모달 주차별 데이터를 조회한다.
	@GetMapping("/dashboard/kpi/achievement-week")
	@ResponseBody
	public Map<String, Object> dashboardAchievementWeek(
			@RequestParam(value = "baseDate", required = false) String baseDate) {

		String searchBaseDate = baseDate;

		if (searchBaseDate == null || searchBaseDate.trim().isEmpty()) {
			searchBaseDate = LocalDate.now().toString();
		}

		Map<String, Object> param = new HashMap<>();
		param.put("baseDate", searchBaseDate);

		List<Map<String, Object>> achievementWeekList =
				chartService.dashboardAchievementWeek(param);

		Map<String, Object> result = new HashMap<>();
		result.put("success", true);
		result.put("baseDate", searchBaseDate);
		result.put("achievementWeekList", achievementWeekList);

		return result;
	}
}