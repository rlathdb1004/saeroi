package kr.or.saeroi.AiChatbot;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import dev.langchain4j.agent.tool.Tool;
import kr.or.saeroi.Chart.ChartDAO;
import kr.or.saeroi.dao.EquipmentDAO;
import kr.or.saeroi.dao.EquipmentStatusDAO;
import kr.or.saeroi.dao.InoutDAO;
import kr.or.saeroi.dao.InventoryDAO;
import kr.or.saeroi.dao.LoginDAO;
import kr.or.saeroi.dao.ProductionDAO;
import kr.or.saeroi.dao.QualityDAO;
import kr.or.saeroi.dto.EquipmentDTO;
import kr.or.saeroi.dto.EquipmentStatusDTO;
import kr.or.saeroi.dto.InoutDTO;
import kr.or.saeroi.dto.InspectionDTO;
import kr.or.saeroi.dto.InventoryDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.dto.ProductionDTO;

@Component
public class DbTool {

	@Autowired
	private javax.sql.DataSource dataSource;

	@Autowired // 사원
	private LoginDAO loginDAO;

	@Autowired // 검사관리
	private QualityDAO qualityDAO;

	@Autowired // 입출고
	private InoutDAO inoutDAO;

	@Autowired // 차트통계
	private ChartDAO chartDAO;

	@Autowired // 재고조회
	private InventoryDAO inventoryDAO;

	@Autowired // 재고조회 //작업지시
	private ProductionDAO productionDAO;
	
	@Autowired // 설비
	private EquipmentDAO equipmentDAO;

	@Autowired // 설비가동현황
	private EquipmentStatusDAO statusDAO;
	

	@Tool("설비 가동 현황을 조회합니다."
		+ "1.설비코드(equip_code), 설비이름(equip_name), 가동일자(operation_date), 비가동이유(down_reason), 비가동시간(downtime_min), 가동시간(runtime_min)등으로 구분"
		+ "2.가동시간 비가동시간 비가동 사유를 물어보면 작동시켜"	
			)
	public String getstatus(String equip_code, String equip_name, String down_reason) {
		try {
			
			EquipmentStatusDTO statusDTO = new EquipmentStatusDTO();
			
			equip_code = cleanParam(equip_code);
			equip_name = cleanParam(equip_name);
			down_reason = cleanParam(down_reason);
			
			// 💡 정제된 값이 빈 문자열("")이 아닐 때만 DTO에 안전하게 세팅합니다.
			if (!equip_code.isEmpty()) statusDTO.setEquip_code(equip_code);
			if (!equip_name.isEmpty()) statusDTO.setEquip_name(equip_name);
			if (!down_reason.isEmpty()) statusDTO.setDown_reason(down_reason);
			
			
			List<EquipmentStatusDTO> list= statusDAO.eqp_status_list();
			System.out.println("ai" + list);
			if(list == null || list.isEmpty()) {
				return "공정진행현황 조회 결과가 없습니다.";
			}
			
			// 주소값 깨짐 방지 및 AI 가독성을 위해 ObjectMapper 권장 (선택사항)
			com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();
			return objectMapper.writeValueAsString(list);
		} catch (Exception e) {
			return "설비관리조회 중 오류: " + e.getMessage();
		}
	}
	
	@Tool("설비관리를 조회합니다."
		+ "1.설비코드(equip_code), 설비명(equip_name), 설비상태(equip_status), 제조사(client_name), 설치 위치(equip_loc)등으로 구분"
		+ "2.설비코드,설비명,설비상태,제조사등은 keyword에 넣고 itemType(구분)은 '설비코드', '설비명', '설비상태', '설비위치', '제조사' 등으로 지정할 수 있습니다."	
		)
	public String geteuipment(String equip_code, String equip_name, String equip_status, String client_name, String equip_loc) {
		try {
			
			EquipmentDTO equipmentDTO = new EquipmentDTO();
			
			equip_loc = cleanParam(equip_loc);
			equip_code = cleanParam(equip_code);
			equip_name = cleanParam(equip_name);
			equip_status = cleanParam(equip_status);
			client_name = cleanParam(client_name);
			
			// 💡 정제된 값이 빈 문자열("")이 아닐 때만 DTO에 안전하게 세팅합니다.
			if (!equip_loc.isEmpty()) equipmentDTO.setEquip_loc(equip_loc);
			if (!equip_code.isEmpty()) equipmentDTO.setEquip_code(equip_code);
			if (!equip_name.isEmpty()) equipmentDTO.setEquip_name(equip_name);
			if (!equip_status.isEmpty()) equipmentDTO.setEquip_status(equip_status);
			if (!client_name.isEmpty()) equipmentDTO.setClient_name(client_name);
			
			
			List<EquipmentDTO> list= equipmentDAO.eqp_list();
			System.out.println("ai" + list);
			if(list == null || list.isEmpty()) {
				return "공정진행현황 조회 결과가 없습니다.";
			}
			
			// 주소값 깨짐 방지 및 AI 가독성을 위해 ObjectMapper 권장 (선택사항)
			com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();
			return objectMapper.writeValueAsString(list);
		} catch (Exception e) {
			return "설비관리조회 중 오류: " + e.getMessage();
		}
	}
	
	@Tool("공정진행현황을 조회합니다."
			+ "1.만약 사용자가 날짜를 조회했다면 startDate와 endDate에 YYYY-MM-DD 형식을 지켜서 넘겨주고, 언급하지 않았다면 반드시 빈 문자열(\"\")로 넘겨주어야 합니다. "
			+ "2.사용자가 특정 품목 구분이나 검색어를 언급하면 keyword에 넣고, itemType(진행상태)은 '전체', '대기', '완료', '진행중', 등으로 지정할 수 있습니다."
			)
	public String getselectProcessProgressList(String startDate, String endDate, String itemType, String keyword) {
		try {
			
			ProductionDTO productionDTO = new ProductionDTO();
			
			startDate = cleanParam(startDate);
            endDate = cleanParam(endDate);
            itemType = cleanParam(itemType);
            keyword = cleanParam(keyword);
            
            // 💡 정제된 값이 빈 문자열("")이 아닐 때만 DTO에 안전하게 세팅합니다.
            if (!startDate.isEmpty()) productionDTO.setStartDate(startDate);
            if (!endDate.isEmpty()) productionDTO.setEndDate(endDate);
            if (!itemType.isEmpty()) productionDTO.setItemType(itemType);
            if (!keyword.isEmpty()) productionDTO.setKeyword(keyword);
			
            // 필요 시 페이징 안전장치 추가
			productionDTO.setStartRow(1);
			productionDTO.setEndRow(50);

			List<ProductionDTO> list = productionDAO.selectProcessProgressList(productionDTO);
			System.out.println("ai" + list);
			if(list == null || list.isEmpty()) {
				return "공정진행현황 조회 결과가 없습니다.";
			}
			
			// 주소값 깨짐 방지 및 AI 가독성을 위해 ObjectMapper 권장 (선택사항)
			com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();
			return objectMapper.writeValueAsString(list);
		} catch (Exception e) {
			return "공정진행현황조회 중 오류: " + e.getMessage();
		}
	}

	@Tool("생산실적을 조회합니다."
			+ "1.만약 사용자가 날짜를 조회했다면 startDate와 endDate에 YYYY-MM-DD 형식을 지켜서 넘겨주고, 언급하지 않았다면 반드시 빈 문자열(\"\")로 넘겨주어야 합니다. "
			+ "2.사용자가 특정 품목 구분이나 검색어를 언급하면 keyword에 넣고, itemType(품목구분)은 '전체', '대기', '완료', '보류', 등으로 지정할 수 있습니다."
			+ "3.")
	public String getselectProductionResultList(String startDate, String endDate, String itemType, String keyword) {
		try {
			// 메서드 내부에서 직접 DTO를 생성하고 바인딩합니다.
			ProductionDTO productionDTO = new ProductionDTO();
			
			startDate = cleanParam(startDate);
            endDate = cleanParam(endDate);
            itemType = cleanParam(itemType);
            keyword = cleanParam(keyword);
            
            // 💡 정제된 값이 빈 문자열("")이 아닐 때만 DTO에 안전하게 세팅합니다.
            if (!startDate.isEmpty()) productionDTO.setStartDate(startDate);
            if (!endDate.isEmpty()) productionDTO.setEndDate(endDate);
            if (!itemType.isEmpty()) productionDTO.setItemType(itemType);
            if (!keyword.isEmpty()) productionDTO.setKeyword(keyword);
			
            productionDTO.setStartRow(1);
			productionDTO.setEndRow(50);

			List<ProductionDTO> list = productionDAO.selectProductionResultList(productionDTO);
			System.out.println("ai" + list);
			if(list == null || list.isEmpty()) {
				return "해당 조건으로 조회된 생산실적 조회 결과가 없습니다.";
			}
			
			com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();
			return objectMapper.writeValueAsString(list);
		} catch (Exception e) {
			return "생산실적조회 중 오류: " + e.getMessage();
		}
	}

//	@Tool("특정 작업지시서의 상세 정보를 조회합니다."
//			+ "1.만약 사용자가 날짜를 조회했다면 startDate와 endDate에 YYYY-MM-DD 형식을 지켜서 넘겨주고, 언급하지 않았다면 반드시 빈 문자열(\"\")로 넘겨주어야 합니다. "
//			+ "2.사용자가 특정 품목 구분이나 검색어를 언급하면 keyword에 넣고, itemType(품목구분)은 '전체', '대기', '완료', '보류', 등으로 지정할 수 있습니다."
//			+ "3.사용자가 '1번 작업지시서', '작업지시 ID 5'와 같이 요청하면 문맥에서 순수한 숫자 ID만 추출해야 합니다. "
//		    + "4.절대 '1번', 'ID 5'와 같이 텍스트를 포함해서 넘기지 말고 오직 정수 숫자만 추출하세요.")
//	public String getWorkOrderDetail(Integer orderId, String ename, String empno) {
//		try {
//			
//			ProductionDTO list = productionDAO.selectWorkOrderDetail(orderId);
//			System.out.println("ai" + list);
//			if(list == null) {
//				return "해당 조건으로 조회된 생산계획 관리 조회 결과가 없습니다.";
//			}
//			return  list.toString();
//		} catch (Exception e) {
//			return "생산계획관리조회 중 오류: " + e.getMessage();
//		}
//	}
	
	@Tool("작업지시 목록을 모두 조회하거나 특정 담당자(사원)의 작업지시서를 검색합니다. "
			+ "1. 사용자가 '박민호 관리자', '내가 맡은' 등 특정 사원 이름이나 대상자를 언급하면 ename 매개변수에 해당 이름을 넣어주세요. "
			+ "2. 이번 주, 오늘 등 기간 조건이 파악되면 startDate와 endDate에 YYYY-MM-DD 형식을 채우고, 언급이 없으면 빈 문자열(\"\")로 넘겨줍니다. "
			+ "3. 사용자가 특정 품목이나 검색어를 언급하면 keyword에 넣고, itemType(품목구분)은 '전체', '대기' 등으로 지정할 수 있습니다."
			+ "4. 조건과 일치하는 데이터가 없다면 데이터를 임의로 조작하지 말고 반드시 '해당 조건으로 조회된 결과가 없습니다'를 반환하세요."
			+ "5. 검색어에 이름과 품목명이 같이 있다면 이름을 우선하세요" 
			+ "6. 날짜를 반드시 질문과 잘 대조해봐"
			)
	public String getworkorder(String ename, String startDate, String endDate, String itemType, String keyword) {
		try {
			System.out.println("ai작업지시실행");
			ProductionDTO productionDTO = new ProductionDTO();
			
			ename = cleanParam(ename);
			startDate = cleanParam(startDate);
            endDate = cleanParam(endDate);
            itemType = cleanParam(itemType);
            keyword = cleanParam(keyword);
            
            // 💡 정제된 값이 빈 문자열("")이 아닐 때만 DTO에 안전하게 세팅합니다.
            if (!ename.isEmpty()) productionDTO.setEname(ename);
            if (!startDate.isEmpty()) productionDTO.setStartDate(startDate);
            if (!endDate.isEmpty()) productionDTO.setEndDate(endDate);
            if (!itemType.isEmpty()) productionDTO.setItemType(itemType);
            if (!keyword.isEmpty()) productionDTO.setKeyword(keyword);
			
			// 페이징 필수 데이터 안전장치
			productionDTO.setStartRow(1);
			productionDTO.setEndRow(50);
			
			List<ProductionDTO> list = productionDAO.selectWorkOrderList(productionDTO);
			
			
			if (list == null || list.isEmpty()) {
				return "해당 조건으로 조회된 작업지시 관리 조회 결과가 없습니다.";
			}
			
			if (!startDate.isEmpty()) {
			    final String targetDate = startDate; // YYYY-MM-DD 형식
			    list = list.stream()
			               .filter(dto -> dto.getOrderDate() != null && dto.getOrderDate().equals(targetDate))
			               .collect(java.util.stream.Collectors.toList());
			}
			
			// 💡 데이터 주소값 깨짐 방지 및 AI 인지율 상승을 위해 JSON 오브젝트 포맷 데이터로 리턴합니다.
			com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();
			return objectMapper.writeValueAsString(list);
			
		} catch (Exception e) {
			return "작업지시 조회 중 오류: " + e.getMessage();
		}
	}
	
	@Tool("생산계획 조회를합니다"
			+ "만약 사용자가 날짜를 조회했다면 startDate와 endDate에 YYYY-MM-DD 형식을 지켜서 넘겨주고, 언급하지 않았다면 반드시 빈 문자열(\"\")로 넘겨주어야 합니다. "
			+ "사용자가 특정 품목 구분이나 검색어를 언급하면 keyword에 넣고, itemType(품목구분)은 'FG' 등으로 지정할 수 있습니다.")
	public String getproduction(String startDate, String endDate, String itemType, String keyword) {
		try {

			ProductionDTO productionDTO = new ProductionDTO();

			startDate = cleanParam(startDate);
            endDate = cleanParam(endDate);
            itemType = cleanParam(itemType);
            keyword = cleanParam(keyword);
            
            // 💡 정제된 값이 빈 문자열("")이 아닐 때만 DTO에 안전하게 세팅합니다.
            if (!startDate.isEmpty()) productionDTO.setStartDate(startDate);
            if (!endDate.isEmpty()) productionDTO.setEndDate(endDate);
            if (!itemType.isEmpty()) productionDTO.setItemType(itemType);
            if (!keyword.isEmpty()) productionDTO.setKeyword(keyword);

			productionDTO.setStartRow(1);
			productionDTO.setEndRow(50);
			
			List<ProductionDTO> list = productionDAO.selectProductionPlanList(productionDTO);
			System.out.println("ai" + list);
			return list.isEmpty() ? "해당 조건으로 조회된 생산계획 관리 조회 결과가 없습니다." : list.toString();
		} catch (Exception e) {
			return "생산계획관리조회 중 오류: " + e.getMessage();
		}
	}

	@Tool("재고를 조회합니다. 사용자가 특정 품목이나 검색어를 언급하면 keyword에 넣고, searchType은 'itemCode', 'itemName' 등으로 지정합니다. " +
		      "만약 날짜를 조회했다면 YYYY-MM-DD의 형식을 지켜줘. " +
		      "만약 날짜(startDate, endDate)를 언급하지 않았다면, 무리하게 채우지 말고 반드시 빈 문자열(\"\")로 넘겨주어야 합니다.")
	public String getinventory(String searchType, String keyword, String startDate, String endDate) {
		try {
			String type = (searchType != null && !searchType.isEmpty()) ? searchType : null;
			String key = (keyword != null && !keyword.isEmpty()) ? keyword : null;

			List<InventoryDTO> list = inventoryDAO.selectInventoryList(type, key, startDate, endDate);
			System.out.println("ai" + list);
			return list.isEmpty() ? "해당 조건으로 조회된 재고조회 결과가 없습니다." : list.toString();
		} catch (Exception e) {
			return "재고조회 중 오류: " + e.getMessage();
		}
	}

	@Tool("사원 번호로 상세 정보를 조회합니다")
	public String getemp(String empNo) {
		try (Connection conn = dataSource.getConnection()) {
			LoginDTO data = loginDAO.find_empno(empNo);
//			return (data !=null) ? "해당 조회내용은 없습니다" : data.toString();
			return (data == null) ? "해당 조회내용은 없습니다" : data.toString();
		} catch (Exception e) {
			return "DB 조회 중 오류: " + e.getMessage();
		}
	}

	@Tool("품질 검사 내역 목록을 조회합니다. 사용자가 특정 품목이나 검색어를 언급하면 keyword에 넣고, searchType은 '품목명' 등으로 지정합니다. "
			+ "만약 날짜를 조회했다면 YYYY-MM-DD의 형식을 지켜줘"
			+ "만약 조회 시작일(startDate)과 종료일(endDate)을 언급하지 않았다면, 무리하게 채우지 말고 반드시 빈 문자열(\"\")로 넘겨주어야 합니다. "
			+ "출력 개수 제한(limit)이나 정렬 방식(orderBy)에 대한 요구사항이 있다면 해당 매개변수에 값을 채워줍니다.")
	public String getQualitySelect(String startDate, String endDate, String searchType, String keyword) {
		try {
			String type = (searchType != null && !searchType.isEmpty()) ? searchType : null;
			String key = (keyword != null && !keyword.isEmpty()) ? keyword : null;

			List<InspectionDTO> list = qualityDAO._dao_select_Inspection(startDate, endDate, type, key);
			return list.isEmpty() ? "해당 조건으로 조회된 품질 검사 결과가 없습니다." : list.toString();
		} catch (Exception e) {
			return "퀄리티 조회중 오류: " + e.getMessage();
		}
	}

	@Tool("입출고 기록을 조회합니다. " + "만약 조회 시작일(startDate)과 종료일(endDate)을 언급하지 않았다면, 무리하게 채우지 말고 반드시 빈 문자열(\"\")로 넘겨주어야 합니다."
			+ "만약 날짜를 조회했다면 YYYY-MM-DD의 형식을 지켜줘" + "사용자가 특정 품목이나 검색어를 언급하면 keyword에 넣고, searchType은 '품목명' 등으로 지정합니다."
			+ "사용자가 '출고 기록' 혹은 '입고 기록'을 요청하면 keyword에 넣지 말고, 반드시 searchType에 '구분'을 넣고 keyword에는 '출고' 또는 '입고'를 넣으세요.")
	public String getInOut(String searchType, String keyword, String startDate, String endDate) {
		String type = (searchType != null && !searchType.isEmpty()) ? searchType : null;
		String key = (keyword != null && !keyword.isEmpty()) ? keyword : null;

		List<InoutDTO> list = inoutDAO.selectInoutList(type, key, startDate, endDate);
		return list.isEmpty() ? "해당 조건으로 조회된 입출고 기록이 없습니다." : list.toString();
	}

	@Tool("일일, 주별, 월별, 년간 계획일자에 따른 생산계획수량, 불량수량, 작업량 통계(차트) 데이터를 조회합니다. "
			+ "1. 이용자가 '어제', '오늘' 혹은 '특정 날짜 하루'를 언급하면, 분석된 날짜를 startDate와 endDate 매개변수 양쪽에 동일하게 YYYY-MM-DD 형식으로 넣어주어야 합니다. "
			+ "2. 이용자가 '25년 1월부터 26년 1월'처럼 특정 기간이나 범위를 지정하여 물어본다면, 시작 날짜는 startDate 매개변수에 (예: 2025-01-01), 종료 날짜는 endDate 매개변수에 (예: 2026-01-31) YYYY-MM-DD 형식으로 반드시 나누어 채워주어야 합니다. "
			+ "3. 일수까지 물어본다면 searchType을 'day'로, 년도만 물어보면 'year'로 지정하며, 합을 물어보면 'year_sum', 평균을 물어보면 'year_avg'를 넣고 기본값은 'year_sum'입니다."
			+ "4. 특정기간을 범위가 아닌 '25년1월1일 데이터 보여줘'처럼 단일된 날짜를 물어보면 동일하게 startDate와 endDate를 채워줍니다"
			+ "5. '차트 보여줘'같은 조회를 하고싶어하면 단순하게 정리해서 링크를 띄어주고 통계를 원하면 자세하게 말해줘")
	public String getChart(String searchType, String startDate, String endDate, String searchItem) {
		try {
			startDate = cleanParam(startDate);
			endDate = cleanParam(endDate);
			
			List<Map<String, Object>> list = chartDAO.chartday(searchType, searchItem, startDate, endDate);
			return list.isEmpty() ? "해당 조건으로 조회된 통계 데이터가 없습니다." : list.toString();
		}	 catch (Exception e) {
			return "퀄리티 조회중 오류: " + e.getMessage();
		}
		
	}
	
	
	private String cleanParam(String param) {
        if (param == null) return "";
        
        String trimmed = param.trim();
        
        // AI가 문자열 "null"이나 "undefined"를 보냈거나 실제로 비어있다면, 자바에서 다루기 쉽게 완전히 빈 문자열("")로 통일시킵니다.
        if (trimmed.equalsIgnoreCase("null") || trimmed.equalsIgnoreCase("undefined") || trimmed.isEmpty()) {
            return "";
        }
        return trimmed;
    }

}
