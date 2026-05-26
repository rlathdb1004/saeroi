package kr.or.saeroi.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.dto.ProductionDTO;
import kr.or.saeroi.service.ProductionService;

// =========================================================
// 작업자 메인 컨트롤러
// =========================================================
@Controller
public class WorkerController {

	// =====================================================
	// 생산관리 Service
	// =====================================================
	@Autowired
	private ProductionService productionService;

	// =====================================================
	// 작업자 메인 화면
	// =====================================================
	@RequestMapping("/worker/main")
	public String workerMain(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 사용자 정보 가져오기
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 작업자만 접근 가능
		// =================================================
		if (!"WORKER".equals(
				loginUser.getRole())) {

			return "redirect:/";
		}

		// =================================================
		// 작업자 정보 전달
		// =================================================
		model.addAttribute(
			"workerName",
			loginUser.getEname());

		model.addAttribute(
			"workerDept",
			loginUser.getDept());

		// =================================================
		// 작업자 메인 이동
		// =================================================
		return "worker/workerMain";
	}

	// =====================================================
	// 작업자 생산실적 조회
	// 로그인한 작업자 생산실적만 출력
	// =====================================================
	@RequestMapping("/worker/productionresult")
	public String workerProductionResult(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 사용자 정보
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 생산실적 전체 조회
		// =================================================
		List<ProductionDTO> allList =
			productionService
				.selectProductionResultList(
					new ProductionDTO());

		// =================================================
		// 로그인 작업자 데이터 저장 리스트
		// =================================================
		List<ProductionDTO> workerList =
			new ArrayList<>();

		// =================================================
		// 로그인 작업자 이름
		// =================================================
		String loginName =
			loginUser.getEname();

		// =================================================
		// null 방지
		// =================================================
		if (loginName != null) {

			loginName =
				loginName.trim();
		}

		// =================================================
		// 로그인한 작업자 데이터만 저장
		// =================================================
		for (ProductionDTO dto : allList) {

			// =============================================
			// DB 작업자 이름
			// =============================================
			String dbName =
				dto.getEname();

			// =============================================
			// null 체크
			// =============================================
			if (dbName == null) {

				continue;
			}

			// =============================================
			// 공백 제거
			// =============================================
			dbName =
				dbName.trim();

			// =============================================
			// 이름 비교
			// =============================================
			if (dbName.contains(loginName)) {

				workerList.add(dto);
			}
		}

		// =================================================
		// JSP 전달
		// =================================================
		model.addAttribute(
			"list",
			workerList);

		model.addAttribute(
			"workerName",
			loginUser.getEname());

		model.addAttribute(
			"workerDept",
			loginUser.getDept());

		// =================================================
		// 작업자 생산실적 화면 이동
		// =================================================
		return "worker/workerProductionResult";
	}

	// =====================================================
	// 작업자 작업지시 조회
	// 로그인한 작업자 작업지시만 출력
	// =====================================================
	@RequestMapping("/worker/workorder")
	public String workerWorkOrder(
			HttpSession session,
			Model model) {

		// =================================================
		// 로그인 사용자 정보
		// =================================================
		LoginDTO loginUser =
			(LoginDTO) session.getAttribute(
				"loginUser");

		// =================================================
		// 로그인 안했으면 로그인 이동
		// =================================================
		if (loginUser == null) {

			return "redirect:/login";
		}

		// =================================================
		// 추가
		// 로그인 작업자 이름 DTO 저장
		// =================================================
		ProductionDTO dto =
			new ProductionDTO();

		dto.setEname(
			loginUser.getEname());

		// =================================================
		// 추가
		// 로그인 작업자 작업지시만 조회
		// =================================================
		List<ProductionDTO> workerList =
			productionService
				.selectWorkOrderList(dto);

		// =================================================
		// JSP 전달
		// =================================================
		model.addAttribute(
			"list",
			workerList);

		model.addAttribute(
			"workerName",
			loginUser.getEname());

		model.addAttribute(
			"workerDept",
			loginUser.getDept());

		// =================================================
		// 작업자 작업지시 화면 이동
		// =================================================
		return "worker/workerWorkOrder";
	}
}