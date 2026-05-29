package kr.or.saeroi.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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
	QualityService qualityService;

	@GetMapping("/dashboard")
	public String main(Model model, HttpSession session) {
		// 첫 화면 대시보드에 공지사항과 작업지시 최근 5개를 조회한다.
		setDashboardNotice(model, session);
		setDashboardWorkOrder(model);
		setDashboardDefectTop5(model);

		return "dashboard.tiles";
	}

	@GetMapping("/")
	public String dashboard(Model model, HttpSession session) {
		// 대시보드 메뉴 진입 시 공지사항과 작업지시 최근 5개를 조회한다.
		setDashboardNotice(model, session);
		setDashboardWorkOrder(model);
		setDashboardDefectTop5(model);

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
}