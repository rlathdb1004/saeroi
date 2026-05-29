package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InoutDTO;

// Controller와 DAO 사이 연결
public interface InoutService {

	// 입출고 목록 조회
	public List<InoutDTO> getInoutList(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate);

	// 전체 개수 조회
	public int getInoutCount(
			String searchType,
			String inoutType,
			String keyword,
			String startDate,
			String endDate);

	public List<InoutDTO> getItemList();

	// =============================================================
	// 품목 선택 시 거래처명 / 담당자 / 현재재고 자동조회
	// =============================================================
	public InoutDTO getItemInfo(
			int itemId,
			String inoutType);

	// =============================================================
	// 품목별 창고위치 목록 조회
	// =============================================================
	public List<InoutDTO> getStockLocationList(
			int itemId);

	// =============================================================
	// 출고 선택 시 LOT 목록 조회
	// =============================================================
	public List<InoutDTO> getMaterialLotList(
			int itemId);

	public int addInout(InoutDTO dto);

	public InoutDTO getInoutDetail(int inoutId);

	public int removeInout(String[] inoutIds);

	public int modifyInout(InoutDTO dto);
}