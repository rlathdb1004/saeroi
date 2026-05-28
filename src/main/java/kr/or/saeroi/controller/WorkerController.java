package kr.or.saeroi.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dao.WorkerDAO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.ProductionService;

// =========================================================
// 작업자 컨트롤러
// 작업자 메인 / 작업지시 조회 / 생산실적 조회 처리
// =========================================================
@Controller
public class WorkerController {

	@Autowired
	private ProductionService productionService;

	@Autowired
	private WorkerDAO workerDAO;

	@RequestMapping("/worker/main")
	public String workerMain(
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		model.addAttribute("workerName", loginUser.getEname());
		model.addAttribute("workerDept", loginUser.getDept());

		return "worker/workerMain";
	}

	@RequestMapping("/worker/workorder")
	public String workerWorkOrder(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "size", defaultValue = "5") int size,
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		String empno = "";

		if (loginUser.getEmpno() != null) {

			empno =
				loginUser.getEmpno().trim();
		}

		String ename = "";

		if (loginUser.getEname() != null) {

			ename =
				loginUser.getEname().trim();
		}

		List<ProductionDTO> myAllList =
			workerDAO.selectMyWorkOrderList(
				empno,
				ename);

		if (myAllList == null) {

			myAllList =
				new ArrayList<ProductionDTO>();
		}

		int totalCount =
			myAllList.size();

		PageDTO pageInfo =
			new PageDTO(page, size, totalCount);

		int startIndex =
			(page - 1) * size;

		int endIndex =
			page * size;

		if (startIndex < 0) {

			startIndex = 0;
		}

		if (endIndex > totalCount) {

			endIndex = totalCount;
		}

		List<ProductionDTO> list =
			new ArrayList<ProductionDTO>();

		if (startIndex <= endIndex
				&& startIndex < totalCount) {

			list =
				myAllList.subList(startIndex, endIndex);
		}

		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("pageUrl", "/worker/workorder");

		model.addAttribute("prodStatus", "");
		model.addAttribute("keyword", "");
		model.addAttribute("startDate", "");
		model.addAttribute("endDate", "");

		model.addAttribute("workOrderStatusList",
			productionService.selectWorkOrderStatusList());

		model.addAttribute("workOrderPlanList",
			productionService.selectWorkOrderPlanList());

		model.addAttribute("lineList",
			productionService.selectLineList());

		model.addAttribute("empList",
			productionService.selectWorkOrderEmpList());

		model.addAttribute("workerName", loginUser.getEname());
		model.addAttribute("workerDept", loginUser.getDept());

		model.addAttribute("headerTitle", "생산관리");
		model.addAttribute("headerSubTitle", "작업지시 관리");

		return "production/workorder.tiles";
	}

	// =====================================================
	// 생산실적 조회
	// 로그인한 작업자 본인 생산실적만 조회
	// =====================================================
	@RequestMapping("/worker/productionresult")
	public String workerProductionResult(
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		String empno = "";

		if (loginUser.getEmpno() != null) {

			empno =
				loginUser.getEmpno().trim();
		}

		String ename = "";

		if (loginUser.getEname() != null) {

			ename =
				loginUser.getEname().trim();
		}

		List<ProductionDTO> list =
			workerDAO.selectMyProductionResultList(
				empno,
				ename);

		if (list == null) {

			list =
				new ArrayList<ProductionDTO>();
		}

		model.addAttribute("list", list);
		model.addAttribute("workerName", loginUser.getEname());
		model.addAttribute("workerDept", loginUser.getDept());

		return "worker/workerProductionResult";
	}

	@RequestMapping("/worker/notice")
	public String workerNotice(
			HttpSession session,
			Model model) {

		LoginDTO loginUser =
			(LoginDTO) session.getAttribute("loginUser");

		if (loginUser == null) {

			return "redirect:/login";
		}

		return "redirect:/board/notice";
	}

	@RequestMapping("/notice/list")
	public String noticeListRedirect() {

		return "redirect:/board/notice";
	}
}