package kr.or.saeroi.service;

import java.util.List;

import kr.or.saeroi.dao.InventoryDAO;
import kr.or.saeroi.dao.InventoryDAOImpl;
import kr.or.saeroi.dto.InventoryDTO;

// Service 실제 내용
public class InventoryServiceImpl implements InventoryService {

	private InventoryDAO dao = new InventoryDAOImpl();

	// 재고 목록 조회
	@Override
	public List<InventoryDTO> getInventoryList(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		return dao.selectInventoryList(
				searchType,
				keyword,
				startDate,
				endDate);
	}

	// 품목 목록 조회
	@Override
	public List<InventoryDTO> getItemList() {
		return dao.selectItemList();
	}

	// 재고 등록
	@Override
	public int addInventory(InventoryDTO dto) {
		return dao.insertInventory(dto);
	}

	// 재고 상세조회
	@Override
	public InventoryDTO getInventoryDetail(int inventoryId) {
		return dao.selectInventoryDetail(inventoryId);
	}

	// 재고 선택 삭제
	@Override
	public int removeInventory(String[] inventoryIds) {
		return dao.deleteInventory(inventoryIds);
	}

	// 재고 수정
	@Override
	public int modifyInventory(InventoryDTO dto) {
		return dao.updateInventory(dto);
	}
}