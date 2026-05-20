package kr.or.saeroi.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.saeroi.dao.BomDAO;
import kr.or.saeroi.dto.BomDTO;
import kr.or.saeroi.dto.BomDetailDTO;
import kr.or.saeroi.dto.ItemDTO;

/**
 * BOM 관리 Service
 *
 * 역할:
 * - Controller에서 요청한 BOM 관리 업무 로직을 처리한다.
 * - DAO를 통해 MyBatis Mapper SQL을 실행한다.
 * - 등록/수정 전 필수값, 중복값을 검증한다.
 *
 * 프로젝트 구조 기준:
 * - 품목관리 ItemService와 동일하게 ServiceImpl 없이 Service class 하나로 구성한다.
 */
@Service
public class BomService {

	@Autowired
	private BomDAO bomDAO;


	// =========================================================
	// 1. BOM 마스터 목록 / 건수 / 상세
	// =========================================================

	/**
	 * BOM 목록 조회
	 *
	 * @param bomDTO 검색조건 DTO
	 * @return BOM 목록
	 */
	public List<BomDTO> getBomList(BomDTO bomDTO) {

		List<BomDTO> bomList = bomDAO.selectBomList(bomDTO);

		if (bomList == null) {
			return Collections.emptyList();
		}

		return bomList;
	}


	/**
	 * BOM 총 건수 조회
	 *
	 * @param bomDTO 검색조건 DTO
	 * @return 검색조건에 맞는 BOM 건수
	 */
	public int getBomCount(BomDTO bomDTO) {
		return bomDAO.selectBomCount(bomDTO);
	}


	/**
	 * BOM 상세 조회
	 *
	 * @param bomId BOM ID
	 * @return BOM 마스터 상세 + BOM 상세 자재 목록
	 */
	public BomDTO getBomDetail(int bomId) {

		BomDTO bomDetail = bomDAO.selectBomDetail(bomId);

		if (bomDetail != null) {
			List<BomDetailDTO> bomDetailList = bomDAO.selectBomDetailList(bomId);
			bomDetail.setBomDetailList(bomDetailList);
		}

		return bomDetail;
	}


	/**
	 * BOM 상세 자재 목록 조회
	 *
	 * @param bomId BOM ID
	 * @return BOM 상세 자재 목록
	 */
	public List<BomDetailDTO> getBomDetailList(int bomId) {

		List<BomDetailDTO> bomDetailList = bomDAO.selectBomDetailList(bomId);

		if (bomDetailList == null) {
			return Collections.emptyList();
		}

		return bomDetailList;
	}


	// =========================================================
	// 2. BOM 마스터 등록 / 수정 / 선택삭제
	// =========================================================

	/**
	 * BOM 등록
	 *
	 * 반환값:
	 * - 1 이상: 등록 성공
	 * - 0: 등록 실패
	 * - -1: BOM코드 중복
	 * - -2: 필수값 누락
	 * - -3: 완제품 품목에 이미 BOM 존재
	 *
	 * @param bomDTO 등록할 BOM 정보
	 * @return 처리 결과
	 */
	public int addBom(BomDTO bomDTO) {

		if (bomDTO == null) {
			return -2;
		}

		if (isEmpty(bomDTO.getBomCode()) || bomDTO.getItemId() == null) {
			return -2;
		}

		if (bomDTO.getVersion() == null || bomDTO.getVersion() < 1) {
			bomDTO.setVersion(1);
		}

		if (isEmpty(bomDTO.getUseYn())) {
			bomDTO.setUseYn("Y");
		}

		// BOM코드 중복 검사
		int bomCodeCount = bomDAO.selectBomCodeCount(bomDTO);

		if (bomCodeCount > 0) {
			return -1;
		}

		// 완제품 1개당 BOM 1개 기준
		int bomItemCount = bomDAO.selectBomItemCount(bomDTO);

		if (bomItemCount > 0) {
			return -3;
		}

		return bomDAO.insertBom(bomDTO);
	}


	/**
	 * BOM 수정
	 *
	 * 반환값:
	 * - 1 이상: 수정 성공
	 * - 0: 수정 실패
	 * - -1: BOM코드 중복
	 * - -2: 필수값 누락
	 * - -3: 완제품 품목에 이미 다른 BOM 존재
	 *
	 * @param bomDTO 수정할 BOM 정보
	 * @return 처리 결과
	 */
	public int modifyBom(BomDTO bomDTO) {

		if (bomDTO == null) {
			return -2;
		}

		if (bomDTO.getBomId() == null || isEmpty(bomDTO.getBomCode()) || bomDTO.getItemId() == null) {
			return -2;
		}

		if (bomDTO.getVersion() == null || bomDTO.getVersion() < 1) {
			bomDTO.setVersion(1);
		}

		if (isEmpty(bomDTO.getUseYn())) {
			bomDTO.setUseYn("Y");
		}

		// 자기 자신을 제외한 BOM코드 중복 검사
		int bomCodeCount = bomDAO.selectBomCodeCount(bomDTO);

		if (bomCodeCount > 0) {
			return -1;
		}

		// 자기 자신을 제외한 완제품 BOM 중복 검사
		int bomItemCount = bomDAO.selectBomItemCount(bomDTO);

		if (bomItemCount > 0) {
			return -3;
		}

		return bomDAO.updateBom(bomDTO);
	}


	/**
	 * BOM 선택 삭제
	 *
	 * 처리 방식:
	 * - 실제 DELETE가 아니라 use_yn = 'N' 처리한다.
	 *
	 * @param bomIdList 선택된 BOM ID 목록
	 * @return 처리 건수
	 */
	public int removeBomList(List<Integer> bomIdList) {

		if (bomIdList == null || bomIdList.isEmpty()) {
			return 0;
		}

		return bomDAO.deleteBomList(bomIdList);
	}


	// =========================================================
	// 3. BOM 상세 자재 등록 / 수정 / 삭제
	// =========================================================

	/**
	 * BOM 상세 자재 1건 추가
	 *
	 * 반환값:
	 * - 1 이상: 등록 성공
	 * - 0: 등록 실패
	 * - -2: 필수값 누락
	 *
	 * @param bomDetailDTO 추가할 BOM 상세 자재 정보
	 * @return 처리 결과
	 */
	public int addBomDetail(BomDetailDTO bomDetailDTO) {

		if (bomDetailDTO == null) {
			return -2;
		}

		if (bomDetailDTO.getBomId() == null || bomDetailDTO.getItemId() == null || bomDetailDTO.getQty() == null) {
			return -2;
		}

		if (bomDetailDTO.getQty() <= 0) {
			return -2;
		}

		return bomDAO.insertBomDetail(bomDetailDTO);
	}


	/**
	 * BOM 상세 자재 1건 수정
	 *
	 * 반환값:
	 * - 1 이상: 수정 성공
	 * - 0: 수정 실패
	 * - -2: 필수값 누락
	 *
	 * @param bomDetailDTO 수정할 BOM 상세 자재 정보
	 * @return 처리 결과
	 */
	public int modifyBomDetail(BomDetailDTO bomDetailDTO) {

		if (bomDetailDTO == null) {
			return -2;
		}

		if (bomDetailDTO.getBomDetailId() == null || bomDetailDTO.getItemId() == null
				|| bomDetailDTO.getQty() == null) {
			return -2;
		}

		if (bomDetailDTO.getQty() <= 0) {
			return -2;
		}

		return bomDAO.updateBomDetail(bomDetailDTO);
	}


	/**
	 * BOM 상세 자재 1건 삭제
	 *
	 * @param bomDetailId BOM 상세 ID
	 * @return 처리 결과
	 */
	public int removeBomDetail(int bomDetailId) {

		if (bomDetailId < 1) {
			return 0;
		}

		return bomDAO.deleteBomDetail(bomDetailId);
	}


	/**
	 * BOM 상세 자재 전체 교체
	 *
	 * 사용 예:
	 * - BOM 수정 화면에서 기존 구성 자재를 전체 삭제하고 다시 등록할 때 사용한다.
	 *
	 * @param bomId BOM ID
	 * @param bomDetailList 새로 저장할 BOM 상세 자재 목록
	 * @return 처리 결과
	 */
	@Transactional
	public int replaceBomDetailList(int bomId, List<BomDetailDTO> bomDetailList) {

		if (bomId < 1) {
			return -2;
		}

		bomDAO.deleteBomDetailByBomId(bomId);

		if (bomDetailList == null || bomDetailList.isEmpty()) {
			return 0;
		}

		int resultCount = 0;

		for (BomDetailDTO bomDetailDTO : bomDetailList) {

			if (bomDetailDTO == null) {
				continue;
			}

			bomDetailDTO.setBomId(bomId);

			if (bomDetailDTO.getItemId() == null || bomDetailDTO.getQty() == null || bomDetailDTO.getQty() <= 0) {
				continue;
			}

			resultCount += bomDAO.insertBomDetail(bomDetailDTO);
		}

		return resultCount;
	}


	// =========================================================
	// 4. 자동완성 / 품목 선택
	// =========================================================

	/**
	 * BOM 등록용 완제품 자동완성
	 *
	 * @param keyword 검색어
	 * @return 완제품 품목 목록
	 */
	public List<ItemDTO> getProductItemAutoComplete(String keyword) {

		if (keyword == null) {
			keyword = "";
		}

		return bomDAO.selectProductItemAutoComplete(keyword);
	}


	/**
	 * BOM 상세 등록용 원자재/부자재 자동완성
	 *
	 * @param keyword 검색어
	 * @return 원자재/부자재 품목 목록
	 */
	public List<ItemDTO> getMaterialItemAutoComplete(String keyword) {

		if (keyword == null) {
			keyword = "";
		}

		return bomDAO.selectMaterialItemAutoComplete(keyword);
	}


	/**
	 * 품목 ID 기준 품목 1건 조회
	 *
	 * @param itemId 품목 ID
	 * @return 품목 정보
	 */
	public ItemDTO getItemById(int itemId) {

		if (itemId < 1) {
			return null;
		}

		return bomDAO.selectItemById(itemId);
	}


	// =========================================================
	// 5. 내부 공통 메서드
	// =========================================================

	/**
	 * 문자열 비어있는지 확인
	 *
	 * @param value 문자열
	 * @return null 또는 공백이면 true
	 */
	private boolean isEmpty(String value) {
		return value == null || value.trim().length() == 0;
	}
}