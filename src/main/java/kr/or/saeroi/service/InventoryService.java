package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dto.InventoryDTO;

// Controller와 Service 연결
public interface InventoryService {

	// 재고 목록 조회
	public List<InventoryDTO> getInventoryList(
			String searchType,
			String keyword,
			String startDate,
			String endDate);

	// 품목 목록 조회
	public List<InventoryDTO> getItemList();

	// 재고 등록
	public int addInventory(InventoryDTO dto);

	// 재고 상세조회
	public InventoryDTO getInventoryDetail(int inventoryId);

	// 재고 선택 삭제
	public int removeInventory(String[] inventoryIds);

	// 재고 수정
	public int modifyInventory(InventoryDTO dto);
}