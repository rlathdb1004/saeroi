package kr.or.saeroi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.saeroi.dto.BomDTO;
import kr.or.saeroi.dto.BomDetailDTO;
import kr.or.saeroi.dto.ItemDTO;

/**
 * BOM 관리 DAO
 *
 * 역할:
 * - Service에서 요청한 BOM 관리 DB 작업을 MyBatis Mapper로 전달한다.
 * - 실제 SQL은 BomMapper.xml에 작성한다.
 *
 * 연결 Mapper:
 * - namespace: bom
 * - 파일명: BomMapper.xml
 */
@Repository
public class BomDAO {

	@Autowired
	private SqlSession sqlSession;

	// =========================================================
	// 1. BOM 마스터 목록 / 건수 / 상세
	// =========================================================

	public List<BomDTO> selectBomList(BomDTO bomDTO) {
		return sqlSession.selectList("bom.selectBomList", bomDTO);
	}

	public int selectBomCount(BomDTO bomDTO) {
		return sqlSession.selectOne("bom.selectBomCount", bomDTO);
	}

	public BomDTO selectBomDetail(int bomId) {
		return sqlSession.selectOne("bom.selectBomDetail", bomId);
	}

	// =========================================================
	// 2. BOM 상세 목록
	// =========================================================

	public List<BomDetailDTO> selectBomDetailList(int bomId) {
		return sqlSession.selectList("bom.selectBomDetailList", bomId);
	}

	// =========================================================
	// 3. BOM 마스터 등록 / 수정 / 삭제
	// =========================================================

	public int insertBom(BomDTO bomDTO) {
		return sqlSession.insert("bom.insertBom", bomDTO);
	}

	public int updateBom(BomDTO bomDTO) {
		return sqlSession.update("bom.updateBom", bomDTO);
	}

	public int deleteBomList(List<Integer> bomIdList) {
		return sqlSession.update("bom.deleteBomList", bomIdList);
	}

	// =========================================================
	// 4. BOM 상세 등록 / 수정 / 삭제
	// =========================================================

	public int insertBomDetail(BomDetailDTO bomDetailDTO) {
		return sqlSession.insert("bom.insertBomDetail", bomDetailDTO);
	}

	public int updateBomDetail(BomDetailDTO bomDetailDTO) {
		return sqlSession.update("bom.updateBomDetail", bomDetailDTO);
	}

	public int deleteBomDetail(int bomDetailId) {
		return sqlSession.delete("bom.deleteBomDetail", bomDetailId);
	}

	public int deleteBomDetailByBomId(int bomId) {
		return sqlSession.delete("bom.deleteBomDetailByBomId", bomId);
	}

	// =========================================================
	// 5. 중복 체크
	// =========================================================

	public int selectBomCodeCount(BomDTO bomDTO) {
		return sqlSession.selectOne("bom.selectBomCodeCount", bomDTO);
	}

	public int selectBomItemCount(BomDTO bomDTO) {
		return sqlSession.selectOne("bom.selectBomItemCount", bomDTO);
	}

	// =========================================================
	// 6. 자동완성 / 품목 선택
	// =========================================================

	public List<ItemDTO> selectProductItemAutoComplete(String keyword) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("keyword", keyword);

		return sqlSession.selectList("bom.selectProductItemAutoComplete", paramMap);
	}

	public List<ItemDTO> selectMaterialItemAutoComplete(String keyword) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("keyword", keyword);

		return sqlSession.selectList("bom.selectMaterialItemAutoComplete", paramMap);
	}

	public ItemDTO selectItemById(int itemId) {
		return sqlSession.selectOne("bom.selectItemById", itemId);
	}
}