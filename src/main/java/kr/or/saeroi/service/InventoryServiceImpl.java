
package kr.or.saeroi.service;

import java.util.List;
import java.util.Collections;
import java.util.Comparator;

import kr.or.saeroi.dao.InventoryDAO;
import kr.or.saeroi.dao.InventoryDAOImpl;
import kr.or.saeroi.dto.InventoryDTO;

// Service 실제 내용
public class InventoryServiceImpl implements InventoryService {

	// =========================================================================
	// DAO 객체 생성
	// =========================================================================
	private InventoryDAO dao =
		new InventoryDAOImpl();

	// =========================================================================
	// 재고 목록 조회
	// =========================================================================
	@Override
	public List<InventoryDTO> getInventoryList(
			String searchType,
			String keyword,
			String startDate,
			String endDate) {

		// =============================================================
		// 재고 목록 조회
		// 등록 / 입출고 반영 후 UPDATED_DATE가 최신인 재고가
		// 1페이지 첫 줄에 보이도록 Service에서도 한 번 더 정렬한다.
		// 날짜가 같으면 INVENTORY_ID DESC 기준으로 정렬한다.
		// =============================================================
		List<InventoryDTO> list =
			dao.selectInventoryList(
				searchType,
				keyword,
				startDate,
				endDate);

		Collections.sort(
			list,
			new Comparator<InventoryDTO>() {

				@Override
				public int compare(
						InventoryDTO a,
						InventoryDTO b) {

					if (a.getUpdatedDate() != null
							&& b.getUpdatedDate() != null
							&& !a.getUpdatedDate().equals(b.getUpdatedDate())) {

						return b.getUpdatedDate().compareTo(a.getUpdatedDate());
					}

					if (a.getCreatedDate() != null
							&& b.getCreatedDate() != null
							&& !a.getCreatedDate().equals(b.getCreatedDate())) {

						return b.getCreatedDate().compareTo(a.getCreatedDate());
					}

					return b.getInventoryId() - a.getInventoryId();
				}
			});

		return list;
	}

	// =========================================================================
	// 품목 목록 조회
	// - 등록 모달 select 출력용
	// - 품목 선택 시 창고위치 자동입력용
	// =========================================================================
	@Override
	public List<InventoryDTO> getItemList() {

		return dao.selectItemList();
	}

	// =========================================================================
	// 품목 선택 시 창고위치 조회
	// =========================================================================
	@Override
	public String getStockLocationByItemId(
			int itemId) {

		return dao.getStockLocationByItemId(
				itemId);
	}

	// =========================================================================
	// 재고 등록
	// =========================================================================
	@Override
	public int addInventory(
			InventoryDTO dto) {

		return dao.insertInventory(dto);
	}

	// =========================================================================
	// 재고 상세조회
	// =========================================================================
	@Override
	public InventoryDTO getInventoryDetail(
			int inventoryId) {

		return dao.selectInventoryDetail(
				inventoryId);
	}

	// =========================================================================
	// 재고 선택 삭제
	// =========================================================================
	@Override
	public int removeInventory(
			String[] inventoryIds) {

		return dao.deleteInventory(
				inventoryIds);
	}

	// =========================================================================
	// 재고 상세페이지 입출고 내역 조회
	// Controller에서 재고번호를 넘기면 DAO에서 MATERIAL_INOUT 이력을 조회한다.
	// =========================================================================
	@Override
	public List<InventoryDTO> getInventoryInoutHistoryList(
			int inventoryId) {

		return dao.selectInventoryInoutHistoryList(
				inventoryId);
	}

	// =========================================================================
	// 재고 수정
	// =========================================================================
	@Override
	public int modifyInventory(
			InventoryDTO dto) {

		return dao.updateInventory(dto);
	}
}