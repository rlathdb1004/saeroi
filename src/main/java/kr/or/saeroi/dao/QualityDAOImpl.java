package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.DefectDTO;
import kr.or.saeroi.dto.InspectionDTO;

//DAO 인터페이스 기능들을 mybatis와 연결
@Repository
public class QualityDAOImpl implements QualityDAO {

	@Autowired
	SqlSession sqlSession;

	@Override
	public List<InspectionDTO> _dao_select_Inspection(String startDate, String endDate, String searchType,
			String keyword) {
		// mybatis에 시작일 종료일 보내기(DB 조회를 위해서)
		Map<String, String> param = new HashMap<String, String>();
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("searchType", searchType);// 구분
		param.put("keyword", keyword);// 입력 한 값

		// mybatis 도구 sqlSession, 여러줄 실행
		List<InspectionDTO> inspection_List = sqlSession.selectList("mapper.quality._select_Inspection", param);
		System.out.println("inspection_List 실행 건수: " + inspection_List.size());

		return inspection_List;
	}

	// 구분 옵션 기능 메서드(모달에서 목록 보여줄 때 쓰임으로 바뀜)
	public List<InspectionDTO> _dao_option_Inspection(String startDate, String endDate, String searchType,
			int optionPage, int optionSize) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		param.put("searchType", searchType);
		param.put("optionPage", optionPage);// 구분에 맞는 값의 페이징
		param.put("optionSize", optionSize);

		// 구분에 맞는 값 따로 DB에사 가져옴
		List<InspectionDTO> inspection_List_option = sqlSession.selectList("mapper.quality._select_Inspection_option",
				param);

		return inspection_List_option;

	}

	@Override
	// 등록에 필요한
	public int _dao_insert_Inspection(String insp_date, String prod_id, String emp_id, String insp_type, String result,
			String inspection_qty, String good_qty, String remark) {

		// DB에서 가져옴
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("insp_date", insp_date);
		param.put("prod_id", prod_id);
		param.put("emp_id", emp_id);
		param.put("insp_type", insp_type);
		param.put("result", result);
		param.put("inspection_qty", inspection_qty);
		param.put("good_qty", good_qty);
		param.put("remark", remark);

		int insert_list = sqlSession.insert("mapper.quality._insert_Inspection", param);

		return insert_list;
	}

	// 삭제에 필요한 구성
	@Override
	// 검사번호만 필요
	public int _dao_delete_Inspection(String[] insp_id) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("insp_id", insp_id);

		int delete_list = sqlSession.delete("mapper.quality._delete_Inspection", param);

		return delete_list;
	}

	// 검사 상세 목록
	@Override
	public InspectionDTO _dao_Insepection_detail(String insp_id, String insp_date, String prod_id, String emp_id,
			String insp_type, String result, String inspection_qty, String good_qty, String remark) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("insp_id", insp_id);
		param.put("insp_date", insp_date);
		param.put("prod_id", prod_id);
		param.put("emp_id", emp_id);
		param.put("insp_type", insp_type);
		param.put("result", result);
		param.put("inspection_qty", inspection_qty);
		param.put("good_qty", good_qty);
		param.put("remark", remark);
		// 1건씩만 read이므로 List 아님
		InspectionDTO inspection_detail = sqlSession.selectOne("mapper.quality._select_Inspection_detail", param);

		return inspection_detail;
	}

	// 검사 수정
	@Override
	public int _dao_update_Inspection(String insp_id, String insp_date, String insp_type, String result,
			String inspection_qty, String good_qty, String remark) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("insp_id", insp_id);
		param.put("insp_date", insp_date);
		param.put("insp_type", insp_type);
		param.put("result", result);
		param.put("inspection_qty", inspection_qty);
		param.put("good_qty", good_qty);
		param.put("remark", remark);

		int update_result = sqlSession.update("mapper.quality._update_Inspection", param);

		return update_result;
	}

	// 불량 목록
	@Override
	public List<DefectDTO> _dao_select_Defect(String startDate, String endDate, String searchType, String keyword) {

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("searchType", searchType);
		map.put("keyword", keyword);

		List<DefectDTO> defect_list = sqlSession.selectList("mapper.quality._select_Defect", map);

		System.out.println("defect_list 실행 건수: " + defect_list.size());

		return defect_list;
	}

	// 불량 등록
	@Override
	public int _dao_insert_defect(String defect_date, String insp_id, String defect_id, String defect_qty,
			String remark) {

		Map<String, Object> param = new HashMap<String, Object>();

		param.put("defect_date", defect_date);
		param.put("insp_id", insp_id);
		param.put("defect_id", defect_id);
		param.put("defect_qty", defect_qty);
		param.put("remark", remark);

		int insert_result = sqlSession.insert("mapper.quality._insert_defect", param);

		return insert_result;
	}

	// 불량 모달 옵션
	@Override
	public List<DefectDTO> _dao_select_Defect_option() {

		List<DefectDTO> defect_option_list = sqlSession.selectList("mapper.quality._select_Defect_option");

		return defect_option_list;
	}

	// 불량 삭제
	@Override
	public int _dao_delete_defect(String[] defect_list_id) {
		// 삭제도 2개 필요
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("defect_list_id", defect_list_id);

		int delete_result = sqlSession.delete("mapper.quality._delete_Defect", param);

		return delete_result;
	}

	// 불량 상세 목록
	@Override
	public DefectDTO _dao_select_Defect_detail(String defect_list_id) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("defect_list_id", defect_list_id);

		DefectDTO defect_detail = sqlSession.selectOne("mapper.quality._select_Defect_detail", param);

		return defect_detail;
	}

	// 불량 업데이트
	@Override
	public int _dao_update_Defect(String defect_list_id, String defect_date, String defect_id, String defect_qty,
			String remark) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("defect_list_id", defect_list_id);
		param.put("defect_date", defect_date);
		param.put("defect_id", defect_id);
		param.put("defect_qty", defect_qty);
		param.put("remark", remark);

		int update_result = sqlSession.update("mapper.quality._update_Defect", param);

		return update_result;
	}

	// 불량 조치 내역 조회
	@Override
	public List<DefectDTO> _dao_select_Defect_action(String defect_list_id) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("defect_list_id", defect_list_id);

		List<DefectDTO> defect_action_list = sqlSession.selectList("mapper.quality._select_Defect_action", param);

		System.out.println("defect_action_list 실행 건수: " + defect_action_list.size());

		return defect_action_list;
	}

	// 불량 조치 내역 등록
	@Override
	public int _dao_insert_Defect_action(String defect_list_id, String action_date, String emp_id,
			String action_content) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("defect_list_id", defect_list_id);
		param.put("action_date", action_date);
		param.put("emp_id", emp_id);
		param.put("action_content", action_content);

		int insert_result = sqlSession.insert("mapper.quality._insert_Defect_action", param);

		return insert_result;
	}
}
