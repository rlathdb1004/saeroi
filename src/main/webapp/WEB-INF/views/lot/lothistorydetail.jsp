<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<style>
.lot_detail_page .detail_card {
	overflow: visible;
}

.lot_detail_page .detail_info_table {
	width: 100%;
	min-width: 0;
}

.lot_qr_box {
	display: grid;
	grid-template-columns: 170px 1fr;
	gap: 18px;
	align-items: stretch;
}

.lot_qr_img_box {
	min-height: 160px;
	border: 1px solid #E5E7EB;
	border-radius: 14px;
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: #F9FAFB;
}

.lot_qr_img {
	width: 140px;
	height: 140px;
	object-fit: contain;
}

.lot_qr_empty {
	font-size: 13px;
	color: #6B7280;
	text-align: center;
	line-height: 1.4;
}

.lot_qr_info_grid {
	display: grid;
	grid-template-columns: 120px 1fr;
	border-top: 1px solid #E5E7EB;
	border-left: 1px solid #E5E7EB;
}

.lot_qr_label, .lot_qr_value {
	padding: 14px 16px;
	border-right: 1px solid #E5E7EB;
	border-bottom: 1px solid #E5E7EB;
	font-size: 14px;
	line-height: 1.45;
}

.lot_qr_label {
	font-weight: 700;
	color: #111827;
	background-color: #F3F8F5;
	white-space: nowrap;
}

.lot_qr_value {
	color: #111827;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.lot_flow_box {
	display: grid;
	grid-template-columns: repeat(6, minmax(0, 1fr));
	gap: 10px;
}

.lot_flow_step {
	border: 1px solid #E5E7EB;
	border-radius: 13px;
	padding: 13px 10px;
	background-color: #FFFFFF;
	text-align: center;
}

.lot_flow_step strong {
	display: block;
	font-size: 14px;
	color: #111827;
	margin-bottom: 5px;
}

.lot_flow_step span {
	display: block;
	font-size: 12px;
	color: #6B7280;
	line-height: 1.35;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.lot_code_text {
	display: inline-block;
	max-width: 100%;
	color: #111827;
	font-weight: 700;
	font-size: 12px;
	line-height: 1.35;
	text-decoration: none;
	white-space: nowrap;
	word-break: keep-all;
	overflow-wrap: normal;
}

.lot_detail_link .lot_code_text {
	color: #047857;
}

.lot_detail_link {
	color: #047857;
	font-weight: 700;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	max-width: 100%;
	padding: 2px 4px;
	border-radius: 5px;
	border-bottom: 1px dotted rgba(47, 125, 98, 0.55);
	white-space: nowrap;
	transition: color 0.15s ease, background-color 0.15s ease, border-color 0.15s ease;
}

.lot_detail_link::after {
	content: "";
	width: 13px;
	height: 13px;
	flex: 0 0 13px;
	background-repeat: no-repeat;
	background-position: center;
	background-size: 13px 13px;
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='13' height='13' viewBox='0 0 24 24' fill='none' stroke='%232F7D62' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M7 17L17 7'/%3E%3Cpath d='M9 7H17V15'/%3E%3C/svg%3E");
}

.lot_detail_link:hover {
	color: #145C43;
	background-color: #EAF6F1;
	border-bottom-color: transparent;
}

.lot_detail_link:hover::after {
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='13' height='13' viewBox='0 0 24 24' fill='none' stroke='%23145C43' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M7 17L17 7'/%3E%3Cpath d='M9 7H17V15'/%3E%3C/svg%3E");
}

.lot_no_data_box {
	padding: 26px 10px;
	border: 1px solid #E5E7EB;
	border-radius: 10px;
	background-color: #FFFFFF;
	text-align: center;
	font-size: 13px;
	color: #6B7280;
}

.lot_history_card_list {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.lot_history_card {
	border: 1px solid #E5E7EB;
	border-radius: 14px;
	background-color: #FFFFFF;
	overflow: hidden;
}

.lot_history_card_head {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	padding: 13px 16px;
	border-bottom: 1px solid #EEF2F0;
	background-color: #F9FAFB;
	flex-wrap: wrap;
}

.lot_history_doc_area {
	display: flex;
	align-items: center;
	gap: 8px;
	min-width: 0;
}

.lot_history_no {
	font-size: 12px;
	color: #6B7280;
	font-weight: 700;
	white-space: nowrap;
}

.lot_history_doc_label {
	font-size: 12px;
	color: #6B7280;
	font-weight: 700;
	white-space: nowrap;
}

.lot_history_card_body {
	display: grid;
	grid-template-columns: repeat(4, minmax(0, 1fr));
	gap: 0;
}

.lot_history_item {
	padding: 11px 14px;
	border-right: 1px solid #EEF2F0;
	border-bottom: 1px solid #EEF2F0;
	min-width: 0;
}

.lot_history_item:nth-child(4n) {
	border-right: 0;
}

.lot_history_label {
	display: block;
	margin-bottom: 5px;
	font-size: 12px;
	font-weight: 700;
	color: #047857;
	white-space: nowrap;
}

.lot_history_value {
	display: block;
	font-size: 13px;
	font-weight: 600;
	color: #111827;
	line-height: 1.4;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.lot_history_remark {
	grid-column: 1 / -1;
	border-right: 0;
}

.lot_status_badge {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	min-width: 46px;
	height: 24px;
	padding: 0 10px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 700;
	white-space: nowrap;
}

.lot_status_green {
	color: #047857;
	background-color: #EAF6F1;
}

.lot_status_orange {
	color: #B45309;
	background-color: #FFF7ED;
}

.lot_status_red {
	color: #B91C1C;
	background-color: #FEE2E2;
}

.lot_status_gray {
	color: #374151;
	background-color: #F3F4F6;
}

@media (max-width: 900px) {
	.lot_qr_box {
		grid-template-columns: 1fr;
	}

	.lot_qr_info_grid {
		grid-template-columns: 96px 1fr;
	}

	.lot_flow_box {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}

	.lot_history_card_body {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}

	.lot_history_item:nth-child(4n) {
		border-right: 1px solid #EEF2F0;
	}

	.lot_history_item:nth-child(2n) {
		border-right: 0;
	}
}

@media (max-width: 640px) {
	.lot_qr_img_box {
		min-height: 140px;
	}

	.lot_qr_img {
		width: 120px;
		height: 120px;
	}

	.lot_qr_label,
	.lot_qr_value {
		padding: 11px 10px;
		font-size: 12px;
	}

	.lot_flow_box {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 8px;
	}

	.lot_flow_step {
		padding: 10px 6px;
		border-radius: 10px;
	}

	.lot_flow_step strong {
		font-size: 12px;
		margin-bottom: 4px;
	}

	.lot_flow_step span {
		font-size: 10px;
		line-height: 1.3;
	}

	.lot_history_card_head {
		align-items: flex-start;
		padding: 12px;
	}

	.lot_history_card_body {
		grid-template-columns: 1fr;
	}

	.lot_history_item,
	.lot_history_item:nth-child(2n),
	.lot_history_item:nth-child(4n) {
		border-right: 0;
	}

	.lot_history_label {
		font-size: 12px;
	}

	.lot_history_value {
		font-size: 12px;
	}

	.lot_code_text {
		font-size: 12px;
	}
}
</style>

<div class="detail_page lot_detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">LOT 이력추적 상세</h2>
			<div class="detail_path">LOT 이력추적 &gt; LOT 상세</div>
		</div>

		<div class="detail_btn_area">
			<button type="button" class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/lot/lothistory'">
				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
					<path d="M8 6h13"></path>
					<path d="M8 12h13"></path>
					<path d="M8 18h13"></path>
					<path d="M3 6h.01"></path>
					<path d="M3 12h.01"></path>
					<path d="M3 18h.01"></path>
				</svg>
				목록
			</button>
		</div>

	</div>

	<div class="detail_card">
		<div class="detail_card_title">작업지시 QR 정보</div>

		<div class="lot_qr_box">
			<div class="lot_qr_img_box">
				<c:choose>
					<c:when test="${not empty lot.orderId}">
						<img class="lot_qr_img"
							src="${pageContext.request.contextPath}/production/workorder/qr?orderId=${lot.orderId}"
							alt="작업지시 QR 코드">
					</c:when>
					<c:otherwise>
						<div class="lot_qr_empty">QR코드 정보가 없습니다.</div>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="lot_qr_info_grid">
				<div class="lot_qr_label">QR 대상 LOT</div>
				<div class="lot_qr_value">${empty lot.productLot ? '-' : lot.productLot}</div>

				<div class="lot_qr_label">QR 이동 URL</div>
				<div class="lot_qr_value">
					<c:choose>
						<c:when test="${not empty lot.qrUrl}">
							${lot.qrUrl}
						</c:when>
						<c:otherwise>
							${pageContext.request.contextPath}/production/productionresult?orderId=${lot.orderId}&amp;productLot=${lot.productLot}&amp;openModal=Y
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">LOT 전체 흐름</div>

		<div class="lot_flow_box">
			<div class="lot_flow_step">
				<strong>1. 생산계획</strong> <span>${empty lot.prodPlanDocNo ? '-' : lot.prodPlanDocNo}</span>
			</div>

			<div class="lot_flow_step">
				<strong>2. 작업지시</strong> <span>${empty lot.workOrderDocNo ? '-' : lot.workOrderDocNo}</span>
			</div>

			<div class="lot_flow_step">
				<strong>3. 자재투입</strong> <span>원자재 LOT 연결</span>
			</div>

			<div class="lot_flow_step">
				<strong>4. 생산실적</strong> <span>${empty lot.prodQty ? 0 : lot.prodQty} EA 생산</span>
			</div>

			<div class="lot_flow_step">
				<strong>5. 품질검사</strong> <span>${empty lot.inspResult ? '-' : lot.inspResult}</span>
			</div>

			<div class="lot_flow_step">
				<strong>6. 완제품 입출고</strong> <span>검사 후 재고 반영</span>
			</div>
		</div>
	</div>


	<div class="detail_card">
		<div class="detail_card_title">완제품 LOT 종합 정보</div>

		<div class="lot_history_card_list">
			<div class="lot_history_card">
				<div class="lot_history_card_head">
					<div class="lot_history_doc_area">
						<span class="lot_history_doc_label">완제품 LOT</span>

						<c:choose>
							<c:when test="${not empty lot.productLot and not empty lot.orderId}">
								<a href="${pageContext.request.contextPath}/lot/lothistory/detail?orderId=${lot.orderId}"
									class="lot_detail_link">
									<span class="lot_code_text">${lot.productLot}</span>
								</a>
							</c:when>
							<c:otherwise>
								<span class="lot_code_text">${empty lot.productLot ? '-' : lot.productLot}</span>
							</c:otherwise>
						</c:choose>
					</div>

					<span class="lot_status_badge lot_status_green">
						잔량 ${empty lot.productRemainQty ? 0 : lot.productRemainQty}
					</span>
				</div>

				<div class="lot_history_card_body">
					<div class="lot_history_item">
						<span class="lot_history_label">품목코드</span>
						<span class="lot_history_value">
							<c:choose>
								<c:when test="${not empty lot.itemCode and not empty lot.itemId}">
									<a href="${pageContext.request.contextPath}/master/item/detail?itemId=${lot.itemId}"
										class="lot_detail_link">
										<span class="lot_code_text">${lot.itemCode}</span>
									</a>
								</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose>
						</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">품목명</span>
						<span class="lot_history_value">${empty lot.itemName ? '-' : lot.itemName}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">품목구분</span>
						<span class="lot_history_value">${empty lot.itemType ? '-' : lot.itemType}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">단위</span>
						<span class="lot_history_value">${empty lot.itemUnit ? '-' : lot.itemUnit}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">안전재고</span>
						<span class="lot_history_value">${empty lot.safetyStock ? 0 : lot.safetyStock}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">생산계획수량</span>
						<span class="lot_history_value">${empty lot.prodPlanQty ? 0 : lot.prodPlanQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">작업지시수량</span>
						<span class="lot_history_value">${empty lot.orderQty ? 0 : lot.orderQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">생산수량</span>
						<span class="lot_history_value">${empty lot.prodQty ? 0 : lot.prodQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">양품수량</span>
						<span class="lot_history_value">${empty lot.goodQty ? 0 : lot.goodQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">불량수량</span>
						<span class="lot_history_value">${empty lot.lossQty ? 0 : lot.lossQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">검사수량</span>
						<span class="lot_history_value">${empty lot.inspectionQty ? 0 : lot.inspectionQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">검사결과</span>
						<span class="lot_history_value">${empty lot.inspResult ? '-' : lot.inspResult}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">입고누계</span>
						<span class="lot_history_value">${empty lot.productInQtyTotal ? 0 : lot.productInQtyTotal}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">출고누계</span>
						<span class="lot_history_value">${empty lot.productOutQtyTotal ? 0 : lot.productOutQtyTotal}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">LOT 잔량</span>
						<span class="lot_history_value">${empty lot.productRemainQty ? 0 : lot.productRemainQty}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">품목 현재재고</span>
						<span class="lot_history_value">${empty lot.inventoryStock ? 0 : lot.inventoryStock}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">재고위치</span>
						<span class="lot_history_value">${empty lot.stockLocation ? '-' : lot.stockLocation}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">납품거래처</span>
						<span class="lot_history_value">${empty lot.clientName ? '-' : lot.clientName}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">거래처코드</span>
						<span class="lot_history_value">${empty lot.clientCode ? '-' : lot.clientCode}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">사업자번호</span>
						<span class="lot_history_value">${empty lot.clientBusinessNo ? '-' : lot.clientBusinessNo}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">거래처담당자</span>
						<span class="lot_history_value">${empty lot.clientManager ? '-' : lot.clientManager}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">거래처연락처</span>
						<span class="lot_history_value">${empty lot.clientTel ? '-' : lot.clientTel}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">거래처주소</span>
						<span class="lot_history_value">${empty lot.clientAddress ? '-' : lot.clientAddress}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">납기일</span>
						<span class="lot_history_value">${empty lot.dueDate ? '-' : lot.dueDate}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">작업지시일</span>
						<span class="lot_history_value">${empty lot.orderDate ? '-' : lot.orderDate}</span>
					</div>

					<div class="lot_history_item">
						<span class="lot_history_label">작업지시 담당자</span>
						<span class="lot_history_value">${empty lot.workOrderEmpName ? '-' : lot.workOrderEmpName}</span>
					</div>

					<div class="lot_history_item lot_history_remark">
						<span class="lot_history_label">비고</span>
						<span class="lot_history_value">${empty lot.remark ? '-' : lot.remark}</span>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">자재 투입 이력</div>

		<c:choose>
			<c:when test="${not empty materialHistoryList}">
				<div class="lot_history_card_list">
					<c:forEach var="mat" items="${materialHistoryList}" varStatus="status">
						<div class="lot_history_card">
							<div class="lot_history_card_head">
								<div class="lot_history_doc_area">
									<span class="lot_history_no">#${status.count}</span>
									<span class="lot_history_doc_label">문서번호</span>

									<c:choose>
										<c:when test="${not empty mat.materialDocNo and not empty mat.inoutId}">
											<a href="${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${mat.inoutId}"
												class="lot_detail_link">
												<span class="lot_code_text">${mat.materialDocNo}</span>
											</a>
										</c:when>
										<c:otherwise>
											<span class="lot_code_text">${empty mat.materialDocNo ? '-' : mat.materialDocNo}</span>
										</c:otherwise>
									</c:choose>
								</div>

								<span class="lot_status_badge lot_status_green">
									${empty mat.inoutTypeName ? '투입' : mat.inoutTypeName}
								</span>
							</div>

							<div class="lot_history_card_body">
								<div class="lot_history_item">
									<span class="lot_history_label">자재 LOT</span>
									<span class="lot_history_value">${empty mat.materialLot ? '-' : mat.materialLot}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">자재코드</span>
									<span class="lot_history_value">${empty mat.materialItemCode ? '-' : mat.materialItemCode}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">자재명</span>
									<span class="lot_history_value">${empty mat.materialItemName ? '-' : mat.materialItemName}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">자재구분</span>
									<span class="lot_history_value">${empty mat.materialItemType ? '-' : mat.materialItemType}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">입출고구분</span>
									<span class="lot_history_value">${empty mat.inoutTypeName ? '-' : mat.inoutTypeName}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">투입수량</span>
									<span class="lot_history_value">${empty mat.inoutQty ? 0 : mat.inoutQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">투입일자</span>
									<span class="lot_history_value">${empty mat.inoutDate ? '-' : mat.inoutDate}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">상태</span>
									<span class="lot_history_value">${empty mat.inoutStatus ? '-' : mat.inoutStatus}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">담당자</span>
									<span class="lot_history_value">${empty mat.inoutEmpName ? '-' : mat.inoutEmpName}</span>
								</div>

								<div class="lot_history_item lot_history_remark">
									<span class="lot_history_label">비고</span>
									<span class="lot_history_value">${empty mat.materialRemark ? '-' : mat.materialRemark}</span>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>

			<c:otherwise>
				<div class="lot_no_data_box">자재 투입 이력이 없습니다.</div>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">생산실적 이력</div>

		<c:choose>
			<c:when test="${not empty productionHistoryList}">
				<div class="lot_history_card_list">
					<c:forEach var="prod" items="${productionHistoryList}" varStatus="status">
						<div class="lot_history_card">
							<div class="lot_history_card_head">
								<div class="lot_history_doc_area">
									<span class="lot_history_no">#${status.count}</span>
									<span class="lot_history_doc_label">실적번호</span>
									<c:choose>
										<c:when test="${not empty prod.prodDocNo and not empty prod.prodId}">
											<a href="${pageContext.request.contextPath}/production/productionresult/detail?prodId=${prod.prodId}"
												class="lot_detail_link">
												<span class="lot_code_text">${prod.prodDocNo}</span>
											</a>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</div>

								<span class="lot_status_badge lot_status_green">
									${empty prod.prodStatus ? '생산' : prod.prodStatus}
								</span>
							</div>

							<div class="lot_history_card_body">
								<div class="lot_history_item">
									<span class="lot_history_label">생산일자</span>
									<span class="lot_history_value">${empty prod.prodDate ? '-' : prod.prodDate}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">생산수량</span>
									<span class="lot_history_value">${empty prod.prodQty ? 0 : prod.prodQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">양품수량</span>
									<span class="lot_history_value">${empty prod.goodQty ? 0 : prod.goodQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">불량수량</span>
									<span class="lot_history_value">${empty prod.lossQty ? 0 : prod.lossQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">검사상태</span>
									<span class="lot_history_value">${empty prod.inspectionStatus ? '-' : prod.inspectionStatus}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">담당자</span>
									<span class="lot_history_value">${empty prod.prodEmpName ? '-' : prod.prodEmpName}</span>
								</div>

								<div class="lot_history_item lot_history_remark">
									<span class="lot_history_label">비고</span>
									<span class="lot_history_value">${empty prod.prodRemark ? '-' : prod.prodRemark}</span>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>

			<c:otherwise>
				<div class="lot_no_data_box">생산실적 이력이 없습니다.</div>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">품질검사 이력</div>

		<c:choose>
			<c:when test="${not empty inspectionHistoryList}">
				<div class="lot_history_card_list">
					<c:forEach var="insp" items="${inspectionHistoryList}" varStatus="status">
						<div class="lot_history_card">
							<div class="lot_history_card_head">
								<div class="lot_history_doc_area">
									<span class="lot_history_no">#${status.count}</span>
									<span class="lot_history_doc_label">검사번호</span>
									<c:choose>
										<c:when test="${not empty insp.inspDocNo and not empty insp.inspId}">
											<a href="${pageContext.request.contextPath}/quality/inspection_detail?insp_id=${insp.inspId}"
												class="lot_detail_link">
												<span class="lot_code_text">${insp.inspDocNo}</span>
											</a>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</div>

								<c:choose>
									<c:when test="${insp.inspResult eq '합격'}">
										<span class="lot_status_badge lot_status_green">합격</span>
									</c:when>
									<c:when test="${insp.inspResult eq '불합격'}">
										<span class="lot_status_badge lot_status_red">불합격</span>
									</c:when>
									<c:otherwise>
										<span class="lot_status_badge lot_status_orange">${empty insp.inspResult ? '-' : insp.inspResult}</span>
									</c:otherwise>
								</c:choose>
							</div>

							<div class="lot_history_card_body">
								<div class="lot_history_item">
									<span class="lot_history_label">검사유형</span>
									<span class="lot_history_value">${empty insp.inspType ? '-' : insp.inspType}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">검사상태</span>
									<span class="lot_history_value">${empty insp.inspStatus ? '-' : insp.inspStatus}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">검사일자</span>
									<span class="lot_history_value">${empty insp.inspDate ? '-' : insp.inspDate}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">검사수량</span>
									<span class="lot_history_value">${empty insp.inspectionQty ? 0 : insp.inspectionQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">양품수량</span>
									<span class="lot_history_value">${empty insp.inspectionGoodQty ? 0 : insp.inspectionGoodQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">불량수량</span>
									<span class="lot_history_value">${empty insp.inspectionBadQty ? 0 : insp.inspectionBadQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">담당자</span>
									<span class="lot_history_value">${empty insp.inspEmpName ? '-' : insp.inspEmpName}</span>
								</div>

								<div class="lot_history_item lot_history_remark">
									<span class="lot_history_label">비고</span>
									<span class="lot_history_value">${empty insp.inspRemark ? '-' : insp.inspRemark}</span>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>

			<c:otherwise>
				<div class="lot_no_data_box">품질검사 이력이 없습니다.</div>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">불량 이력</div>

		<c:choose>
			<c:when test="${not empty defectHistoryList}">
				<div class="lot_history_card_list">
					<c:forEach var="def" items="${defectHistoryList}" varStatus="status">
						<div class="lot_history_card">
							<div class="lot_history_card_head">
								<div class="lot_history_doc_area">
									<span class="lot_history_no">#${status.count}</span>
									<span class="lot_history_doc_label">불량번호</span>
									<c:choose>
										<c:when test="${not empty def.defectDocNo and not empty def.defectListId}">
											<a href="${pageContext.request.contextPath}/quality/defect_detail?defect_list_id=${def.defectListId}"
												class="lot_detail_link">
												<span class="lot_code_text">${def.defectDocNo}</span>
											</a>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</div>

								<span class="lot_status_badge lot_status_red">
									${empty def.defectType ? '불량' : def.defectType}
								</span>
							</div>

							<div class="lot_history_card_body">
								<div class="lot_history_item">
									<span class="lot_history_label">불량코드</span>
									<span class="lot_history_value">${empty def.defectCode ? '-' : def.defectCode}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">불량명</span>
									<span class="lot_history_value">${empty def.defectName ? '-' : def.defectName}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">불량유형</span>
									<span class="lot_history_value">${empty def.defectType ? '-' : def.defectType}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">불량수량</span>
									<span class="lot_history_value">${empty def.defectQty ? 0 : def.defectQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">불량일자</span>
									<span class="lot_history_value">${empty def.defectDate ? '-' : def.defectDate}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">조치건수</span>
									<span class="lot_history_value">${empty def.actionCount ? 0 : def.actionCount}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">조치일자</span>
									<span class="lot_history_value">${empty def.actionDate ? '-' : def.actionDate}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">조치내용</span>
									<span class="lot_history_value">${empty def.actionContent ? '-' : def.actionContent}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">사진경로</span>
									<span class="lot_history_value">${empty def.defectPhoto ? '-' : def.defectPhoto}</span>
								</div>

								<div class="lot_history_item lot_history_remark">
									<span class="lot_history_label">비고</span>
									<span class="lot_history_value">${empty def.defectRemark ? '-' : def.defectRemark}</span>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>

			<c:otherwise>
				<div class="lot_no_data_box">불량 이력이 없습니다.</div>
			</c:otherwise>
		</c:choose>
	</div>

	<div class="detail_card">
		<div class="detail_card_title">완제품 입출고 이력</div>

		<c:choose>
			<c:when test="${not empty productInoutHistoryList}">
				<div class="lot_history_card_list">
					<c:forEach var="pio" items="${productInoutHistoryList}" varStatus="status">
						<div class="lot_history_card">
							<div class="lot_history_card_head">
								<div class="lot_history_doc_area">
									<span class="lot_history_no">#${status.count}</span>
									<span class="lot_history_doc_label">문서번호</span>

									<c:choose>
										<c:when test="${not empty pio.productInoutDocNo and not empty pio.productInoutId}">
											<a href="${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${pio.productInoutId}"
												class="lot_detail_link">
												<span class="lot_code_text">${pio.productInoutDocNo}</span>
											</a>
										</c:when>
										<c:otherwise>
											<span class="lot_code_text">${empty pio.productInoutDocNo ? '-' : pio.productInoutDocNo}</span>
										</c:otherwise>
									</c:choose>
								</div>

								<c:choose>
									<c:when test="${pio.productInoutTypeName eq '입고'}">
										<span class="lot_status_badge lot_status_green">입고</span>
									</c:when>
									<c:when test="${pio.productInoutTypeName eq '출고'}">
										<span class="lot_status_badge lot_status_orange">출고</span>
									</c:when>
									<c:otherwise>
										<span class="lot_status_badge lot_status_gray">${empty pio.productInoutTypeName ? '-' : pio.productInoutTypeName}</span>
									</c:otherwise>
								</c:choose>
							</div>

							<div class="lot_history_card_body">
								<div class="lot_history_item">
									<span class="lot_history_label">완제품 LOT</span>
									<span class="lot_history_value">
										<c:choose>
											<c:when test="${not empty pio.productInoutProductLot and not empty pio.orderId}">
												<a href="${pageContext.request.contextPath}/lot/lothistory/detail?orderId=${pio.orderId}"
													class="lot_detail_link">
													<span class="lot_code_text">${pio.productInoutProductLot}</span>
												</a>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">품목코드</span>
									<span class="lot_history_value">
										<c:choose>
											<c:when test="${not empty pio.productInoutItemCode and not empty pio.itemId}">
												<a href="${pageContext.request.contextPath}/master/item/detail?itemId=${pio.itemId}"
													class="lot_detail_link">
													<span class="lot_code_text">${pio.productInoutItemCode}</span>
												</a>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">품목명</span>
									<span class="lot_history_value">${empty pio.productInoutItemName ? '-' : pio.productInoutItemName}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">품목구분</span>
									<span class="lot_history_value">${empty pio.productInoutItemType ? '-' : pio.productInoutItemType}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">수량</span>
									<span class="lot_history_value">${empty pio.productInoutQty ? 0 : pio.productInoutQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">단위</span>
									<span class="lot_history_value">${empty pio.productInoutItemUnit ? '-' : pio.productInoutItemUnit}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">안전재고</span>
									<span class="lot_history_value">${empty pio.productInoutSafetyStock ? 0 : pio.productInoutSafetyStock}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">입출고일자</span>
									<span class="lot_history_value">${empty pio.productInoutDate ? '-' : pio.productInoutDate}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">검사번호</span>
									<span class="lot_history_value">
										<c:choose>
											<c:when test="${not empty pio.productInoutInspDocNo and not empty pio.inspId}">
												<a href="${pageContext.request.contextPath}/quality/inspection_detail?insp_id=${pio.inspId}"
													class="lot_detail_link">
													<span class="lot_code_text">${pio.productInoutInspDocNo}</span>
												</a>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">상태</span>
									<span class="lot_history_value">${empty pio.productInoutStatus ? '-' : pio.productInoutStatus}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">담당자</span>
									<span class="lot_history_value">${empty pio.productInoutEmpName ? '-' : pio.productInoutEmpName}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">납품거래처</span>
									<span class="lot_history_value">${empty pio.productInoutClientName ? '-' : pio.productInoutClientName}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">거래처코드</span>
									<span class="lot_history_value">${empty pio.productInoutClientCode ? '-' : pio.productInoutClientCode}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">사업자번호</span>
									<span class="lot_history_value">${empty pio.productInoutClientBusinessNo ? '-' : pio.productInoutClientBusinessNo}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">거래처담당자</span>
									<span class="lot_history_value">${empty pio.productInoutClientManager ? '-' : pio.productInoutClientManager}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">거래처연락처</span>
									<span class="lot_history_value">${empty pio.productInoutClientTel ? '-' : pio.productInoutClientTel}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">거래처주소</span>
									<span class="lot_history_value">${empty pio.productInoutClientAddress ? '-' : pio.productInoutClientAddress}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">재고위치</span>
									<span class="lot_history_value">${empty pio.productInoutStockLocation ? '-' : pio.productInoutStockLocation}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">품목 현재재고</span>
									<span class="lot_history_value">${empty pio.productInoutInventoryStock ? 0 : pio.productInoutInventoryStock}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">LOT 입고누계</span>
									<span class="lot_history_value">${empty pio.productInoutLotInQty ? 0 : pio.productInoutLotInQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">LOT 출고누계</span>
									<span class="lot_history_value">${empty pio.productInoutLotOutQty ? 0 : pio.productInoutLotOutQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">LOT 잔량</span>
									<span class="lot_history_value">${empty pio.productInoutLotRemainQty ? 0 : pio.productInoutLotRemainQty}</span>
								</div>

								<div class="lot_history_item">
									<span class="lot_history_label">재고비고</span>
									<span class="lot_history_value">${empty pio.productInoutInventoryRemark ? '-' : pio.productInoutInventoryRemark}</span>
								</div>

								<div class="lot_history_item lot_history_remark">
									<span class="lot_history_label">비고</span>
									<span class="lot_history_value">${empty pio.productInoutRemark ? '-' : pio.productInoutRemark}</span>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>

			<c:otherwise>
				<div class="lot_no_data_box">완제품 입출고 이력이 없습니다.</div>
			</c:otherwise>
		</c:choose>
	</div>

</div>