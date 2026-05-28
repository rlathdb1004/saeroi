<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%--
	파일명: workorderprint.jsp
	메뉴: 생산관리 > 작업지시 관리 > 작업지시서 인쇄

	기준:
	- URL: /production/workorder/print
	- Controller return: production/workorderprint.tiles
	- tiles.xml은 수정하지 않는다.
	- 작업지시 1건 = A4 세로 1장
	- QR 실시간 생성 URL 사용
	- 자재/BOM/LOT 확인 목록 최대 5건 출력
	- 라인/설비 확인 목록 최대 4건 출력
	- 초과 건수는 "외 N건"으로 표시
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<jsp:useBean id="now" class="java.util.Date" />

<div class="workorder_print_page">

	<div class="print_top no_print">

		<div>
			<h2 class="print_screen_title">작업지시서 인쇄</h2>
			<p class="print_screen_desc">
				작업지시 1건을 A4 세로 1장 작업자 배포용 양식으로 출력합니다.
			</p>
		</div>

		<div class="print_btn_area">
			<button type="button" class="print_btn_main" onclick="window.print();">
				인쇄
			</button>

			<button type="button" class="print_btn_line"
				onclick="location.href='${contextPath}/production/workorder'">
				목록
			</button>
		</div>

	</div>


	<div class="print_condition no_print">

		<span>검색조건</span>

		<c:if test="${not empty startDate}">
			<em>시작일: ${startDate}</em>
		</c:if>

		<c:if test="${not empty endDate}">
			<em>종료일: ${endDate}</em>
		</c:if>

		<c:if test="${not empty prodStatus}">
			<em>상태: ${prodStatus}</em>
		</c:if>

		<c:if test="${not empty keyword}">
			<em>검색어: ${keyword}</em>
		</c:if>

		<c:if test="${empty startDate and empty endDate and empty prodStatus and empty keyword}">
			<em>전체 또는 단건 인쇄</em>
		</c:if>

	</div>


	<c:choose>

		<c:when test="${not empty printList}">

			<c:forEach var="workOrder" items="${printList}" varStatus="status">

				<section class="workorder_print_sheet">

					<div class="print_sheet_header">

						<div>
							<div class="print_doc_label">SAEROI MES</div>
							<h1 class="print_doc_title">작업지시서</h1>
						</div>

						<div class="print_doc_meta">
							<div>
								<span>출력일</span>
								<strong>
									<fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm" />
								</strong>
							</div>

							<div>
								<span>페이지</span>
								<strong>${status.count} / ${fn:length(printList)}</strong>
							</div>
						</div>

					</div>


					<div class="print_main_area">

						<div class="print_info_area">

							<table class="print_info_table">
								<tbody>

									<tr>
										<th>작업지시번호</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.docNo}">
													${workOrder.docNo}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>작업지시일</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.orderDate}">
													${workOrder.orderDate}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>완제품 LOT</th>
										<td colspan="3" class="print_text_strong print_wrap_text">
											<c:choose>
												<c:when test="${not empty workOrder.productLot}">
													${workOrder.productLot}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>생산계획번호</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.prodPlanDocNo}">
													${workOrder.prodPlanDocNo}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>생산계획일</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.prodPlanDate}">
													${workOrder.prodPlanDate}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>품목코드</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.itemCode}">
													${workOrder.itemCode}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>품목구분</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.itemType}">
													${workOrder.itemType}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>품목명</th>
										<td colspan="3" class="print_wrap_text">
											<c:choose>
												<c:when test="${not empty workOrder.itemName}">
													${workOrder.itemName}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>계획수량</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.prodPlanQty}">
													<fmt:formatNumber value="${workOrder.prodPlanQty}"
														pattern="#,##0" />
													${workOrder.itemUnit}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>지시수량</th>
										<td class="print_text_strong">
											<c:choose>
												<c:when test="${not empty workOrder.orderQty}">
													<fmt:formatNumber value="${workOrder.orderQty}"
														pattern="#,##0" />
													${workOrder.itemUnit}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>라인</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.lineName}">
													${workOrder.lineName}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>담당자</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.ename}">
													${workOrder.ename}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>
									</tr>


									<tr>
										<th>납기일</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.dueDate}">
													${workOrder.dueDate}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</td>

										<th>상태</th>
										<td>
											<c:choose>
												<c:when test="${not empty workOrder.prodStatus}">
													${workOrder.prodStatus}
												</c:when>
												<c:otherwise>대기</c:otherwise>
											</c:choose>
										</td>
									</tr>

								</tbody>
							</table>

						</div>


						<div class="print_qr_area">

							<div class="print_qr_title">생산실적 등록 QR</div>

							<div class="print_qr_box">
								<c:choose>
									<c:when test="${not empty workOrder.orderId}">
										<img src="${contextPath}/production/workorder/qr?orderId=${workOrder.orderId}"
											alt="작업지시 QR 코드">
									</c:when>
									<c:otherwise>
										<div class="print_qr_empty">
											QR 없음
										</div>
									</c:otherwise>
								</c:choose>
							</div>

							<div class="print_qr_lot">
								LOT
								<strong>
									<c:choose>
										<c:when test="${not empty workOrder.productLot}">
											${workOrder.productLot}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</strong>
							</div>

							<div class="print_qr_desc">
								QR 스캔 시 생산실적 등록 모달이 자동 실행됩니다.
							</div>

						</div>

					</div>


					<div class="print_section">

						<div class="print_section_title">
							투입 자재 / BOM / LOT 확인
							<c:if test="${not empty workOrder.printMaterialExtraCount and workOrder.printMaterialExtraCount > 0}">
								<span>외 ${workOrder.printMaterialExtraCount}건</span>
							</c:if>
						</div>

						<table class="print_material_table">
							<thead>
								<tr>
									<th>자재코드</th>
									<th>자재명</th>
									<th>필요수량</th>
									<th>투입 LOT</th>
									<th>투입수량</th>
									<th>확인</th>
								</tr>
							</thead>

							<tbody>
								<c:choose>
									<c:when test="${not empty workOrder.printMaterialList}">
										<c:forEach var="material" items="${workOrder.printMaterialList}">
											<tr>
												<td title="${material.materialItemCode}">
													<c:choose>
														<c:when test="${not empty material.materialItemCode}">
															${material.materialItemCode}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td class="print_text_left" title="${material.materialItemName}">
													<c:choose>
														<c:when test="${not empty material.materialItemName}">
															${material.materialItemName}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty material.requiredQty}">
															<fmt:formatNumber value="${material.requiredQty}"
																pattern="#,##0.####" />
															${material.materialItemUnit}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td title="${material.materialLot}">
													<c:choose>
														<c:when test="${not empty material.materialLot}">
															${material.materialLot}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty material.inoutQty}">
															<fmt:formatNumber value="${material.inoutQty}"
																pattern="#,##0.####" />
															${material.materialItemUnit}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td class="print_check_cell"></td>
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="6">조회된 투입 자재 LOT 정보가 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>

					</div>


					<div class="print_section">

						<div class="print_section_title">
							라인 / 설비 확인
							<c:if test="${not empty workOrder.printEquipmentExtraCount and workOrder.printEquipmentExtraCount > 0}">
								<span>외 ${workOrder.printEquipmentExtraCount}건</span>
							</c:if>
						</div>

						<table class="print_equipment_table">
							<thead>
								<tr>
									<th>라인</th>
									<th>설비코드</th>
									<th>설비명</th>
									<th>설비상태</th>
									<th>위치</th>
									<th>확인</th>
								</tr>
							</thead>

							<tbody>
								<c:choose>
									<c:when test="${not empty workOrder.printEquipmentList}">
										<c:forEach var="equipment" items="${workOrder.printEquipmentList}">
											<tr>
												<td title="${equipment.lineName}">
													<c:choose>
														<c:when test="${not empty equipment.lineName}">
															${equipment.lineName}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td title="${equipment.equipCode}">
													<c:choose>
														<c:when test="${not empty equipment.equipCode}">
															${equipment.equipCode}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td class="print_text_left" title="${equipment.equipName}">
													<c:choose>
														<c:when test="${not empty equipment.equipName}">
															${equipment.equipName}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty equipment.equipStatus}">
															${equipment.equipStatus}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td title="${equipment.equipLoc}">
													<c:choose>
														<c:when test="${not empty equipment.equipLoc}">
															${equipment.equipLoc}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td class="print_check_cell"></td>
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="6">조회된 라인 설비 정보가 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>

					</div>


					<div class="print_bottom_area">

						<div class="print_work_check_area">

							<div class="print_section_title">작업 확인</div>

							<table class="print_work_check_table">
								<tbody>
									<tr>
										<th>자재 LOT 확인</th>
										<td></td>
										<th>설비 상태 확인</th>
										<td></td>
									</tr>

									<tr>
										<th>초품 확인</th>
										<td></td>
										<th>작업 완료 확인</th>
										<td></td>
									</tr>

									<tr>
										<th>특이사항</th>
										<td colspan="3">
											<c:choose>
												<c:when test="${not empty workOrder.remark}">
													${workOrder.remark}
												</c:when>
												<c:otherwise></c:otherwise>
											</c:choose>
										</td>
									</tr>
								</tbody>
							</table>

						</div>


						<div class="print_sign_area">

							<div class="print_sign_box">
								<span>작업자</span>
								<strong></strong>
							</div>

							<div class="print_sign_box">
								<span>검사자</span>
								<strong></strong>
							</div>

							<div class="print_sign_box">
								<span>관리자</span>
								<strong></strong>
							</div>

						</div>

					</div>

				</section>

			</c:forEach>

		</c:when>


		<c:otherwise>
			<div class="print_empty_box">
				조회된 작업지시가 없습니다.
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* =========================================================
   workorderprint.jsp 전용
   공통 헤더/사이드바/챗봇 숨김
   ========================================================= */
header,
nav,
aside,
.header,
.top_header,
.topHeader,
.main_header,
.mainHeader,
.layout_header,
.layoutHeader,
.sidebar,
.side_bar,
.sideBar,
.left_menu,
.leftMenu,
.gnb,
.lnb,
.snb,
.navbar,
.footer,
footer,
#header,
#topHeader,
#sidebar,
#sideBar,
#leftMenu,
#gnb,
#lnb,
#footer,
.chatbot,
.chatbot_wrap,
.chatbot_layer,
.chatbot_btn,
.chatbot_button,
.chatbot_bubble,
.chat_bubble,
.talk_bubble,
.floating_chat,
.float_chat,
#chatbot,
#chatbotWrap,
#chatbotLayer {
	display: none !important;
}

html,
body {
	width: 100%;
	min-width: 0;
	margin: 0;
	padding: 0;
	background: #fff;
}

body {
	overflow-x: hidden;
}

.layout,
.wrapper,
.wrap,
.container,
.content,
.contents,
.content_wrap,
.contentWrap,
.main,
.main_wrap,
.mainWrap,
.main_content,
.mainContent,
.page_content,
.pageContent,
.coPageWrap {
	width: 100% !important;
	max-width: 100% !important;
	min-width: 0 !important;
	margin-left: 0 !important;
	margin-right: 0 !important;
	padding-left: 0 !important;
	padding-right: 0 !important;
	box-sizing: border-box;
}

.workorder_print_page {
	width: 100%;
	max-width: 210mm;
	margin: 0 auto;
	padding: 8mm 0;
	box-sizing: border-box;
	background: #f4f6f8;
}

.print_top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
	width: 190mm;
	margin: 0 auto 8px;
	padding: 12px 14px;
	background: #fff;
	border: 1px solid #e5e8eb;
	border-radius: 12px;
	box-sizing: border-box;
}

.print_screen_title {
	margin: 0;
	font-size: 21px;
	font-weight: 800;
	color: #222;
}

.print_screen_desc {
	margin: 5px 0 0;
	font-size: 13px;
	color: #666;
}

.print_btn_area {
	display: flex;
	align-items: center;
	gap: 8px;
}

.print_btn_main,
.print_btn_line {
	height: 36px;
	padding: 0 15px;
	border-radius: 8px;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
	white-space: nowrap;
}

.print_btn_main {
	border: 1px solid #174c3c;
	background: #174c3c;
	color: #fff;
}

.print_btn_line {
	border: 1px solid #cfd6dc;
	background: #fff;
	color: #333;
}

.print_condition {
	width: 190mm;
	margin: 0 auto 10px;
	padding: 9px 13px;
	background: #fff;
	border: 1px solid #e5e8eb;
	border-radius: 10px;
	box-sizing: border-box;
	font-size: 13px;
	color: #444;
}

.print_condition span {
	font-weight: 800;
	margin-right: 10px;
	color: #222;
}

.print_condition em {
	display: inline-block;
	margin-right: 8px;
	font-style: normal;
	color: #555;
}

.workorder_print_sheet {
	width: 190mm;
	height: 277mm;
	margin: 0 auto 10mm;
	padding: 7mm;
	background: #fff;
	border: 1px solid #d9dee3;
	border-radius: 8px;
	box-sizing: border-box;
	overflow: hidden;
	page-break-after: always;
	break-after: page;
}

.workorder_print_sheet:last-child {
	page-break-after: auto;
	break-after: auto;
}

.print_sheet_header {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 16px;
	padding-bottom: 8px;
	border-bottom: 2px solid #111;
	margin-bottom: 9px;
}

.print_doc_label {
	font-size: 10px;
	font-weight: 800;
	letter-spacing: 2px;
	color: #555;
}

.print_doc_title {
	margin: 3px 0 0;
	font-size: 25px;
	font-weight: 900;
	color: #111;
}

.print_doc_meta {
	min-width: 160px;
	font-size: 10.5px;
	color: #444;
}

.print_doc_meta div {
	display: flex;
	justify-content: space-between;
	gap: 10px;
	margin-bottom: 4px;
}

.print_doc_meta span {
	color: #666;
}

.print_doc_meta strong {
	color: #111;
	font-weight: 800;
}

.print_main_area {
	display: flex;
	align-items: stretch;
	gap: 9px;
	margin-bottom: 8px;
}

.print_info_area {
	flex: 1;
	min-width: 0;
}

.print_info_table,
.print_material_table,
.print_equipment_table,
.print_work_check_table {
	width: 100%;
	border-collapse: collapse;
	table-layout: fixed;
}

.print_info_table th,
.print_info_table td,
.print_material_table th,
.print_material_table td,
.print_equipment_table th,
.print_equipment_table td,
.print_work_check_table th,
.print_work_check_table td {
	border: 1px solid #cfd6dc;
	color: #222;
	vertical-align: middle;
	box-sizing: border-box;
}

.print_info_table th,
.print_info_table td {
	padding: 4.5px 5px;
	font-size: 10.5px;
	line-height: 1.25;
}

.print_info_table th {
	width: 20%;
	background: #f4f6f8;
	font-weight: 800;
	text-align: center;
	color: #111;
	white-space: nowrap;
}

.print_info_table td {
	width: 30%;
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.print_text_strong {
	font-weight: 800;
	color: #111;
}

.print_wrap_text {
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.print_text_left {
	text-align: left !important;
}

.print_qr_area {
	flex: 0 0 42mm;
	border: 1px solid #cfd6dc;
	border-radius: 8px;
	padding: 7px;
	box-sizing: border-box;
	text-align: center;
}

.print_qr_title {
	font-size: 12px;
	font-weight: 900;
	color: #111;
	margin-bottom: 6px;
}

.print_qr_box {
	width: 31mm;
	height: 31mm;
	margin: 0 auto;
	border: 1px solid #e5e8eb;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #fff;
	box-sizing: border-box;
}

.print_qr_box img {
	width: 28mm;
	height: 28mm;
	object-fit: contain;
	display: block;
}

.print_qr_empty {
	font-size: 11px;
	color: #777;
}

.print_qr_lot {
	margin-top: 6px;
	font-size: 8.5px;
	color: #555;
	line-height: 1.25;
	word-break: break-all;
}

.print_qr_lot strong {
	display: block;
	margin-top: 3px;
	font-size: 9.5px;
	color: #111;
}

.print_qr_desc {
	margin-top: 6px;
	font-size: 8.5px;
	color: #666;
	line-height: 1.35;
	word-break: keep-all;
}

.print_section {
	margin-top: 7px;
}

.print_section_title {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 4px;
	font-size: 12px;
	font-weight: 900;
	color: #111;
}

.print_section_title span {
	font-size: 10px;
	font-weight: 700;
	color: #666;
}

.print_material_table th,
.print_material_table td,
.print_equipment_table th,
.print_equipment_table td {
	padding: 3.5px 4px;
	font-size: 9.3px;
	line-height: 1.2;
	text-align: center;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.print_material_table th,
.print_equipment_table th,
.print_work_check_table th {
	background: #f4f6f8;
	font-weight: 800;
	color: #111;
}

.print_material_table th:nth-child(1) {
	width: 18%;
}

.print_material_table th:nth-child(2) {
	width: 25%;
}

.print_material_table th:nth-child(3) {
	width: 15%;
}

.print_material_table th:nth-child(4) {
	width: 22%;
}

.print_material_table th:nth-child(5) {
	width: 14%;
}

.print_material_table th:nth-child(6) {
	width: 6%;
}

.print_equipment_table th:nth-child(1) {
	width: 18%;
}

.print_equipment_table th:nth-child(2) {
	width: 18%;
}

.print_equipment_table th:nth-child(3) {
	width: 25%;
}

.print_equipment_table th:nth-child(4) {
	width: 15%;
}

.print_equipment_table th:nth-child(5) {
	width: 18%;
}

.print_equipment_table th:nth-child(6) {
	width: 6%;
}

.print_check_cell {
	height: 18px;
}

.print_bottom_area {
	margin-top: 8px;
}

.print_work_check_table th,
.print_work_check_table td {
	padding: 4px 5px;
	font-size: 9.5px;
	line-height: 1.2;
}

.print_work_check_table th {
	width: 17%;
	text-align: center;
}

.print_work_check_table td {
	width: 33%;
	height: 22px;
}

.print_work_check_table td[colspan] {
	height: 24px;
	text-align: left;
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.print_sign_area {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	margin-top: 9px;
}

.print_sign_box {
	width: 30mm;
	border: 1px solid #cfd6dc;
	text-align: center;
	box-sizing: border-box;
}

.print_sign_box span {
	display: block;
	padding: 4px 0;
	background: #f4f6f8;
	border-bottom: 1px solid #cfd6dc;
	font-size: 10px;
	font-weight: 800;
	color: #111;
}

.print_sign_box strong {
	display: block;
	height: 24px;
}

.print_empty_box {
	width: 190mm;
	margin: 20mm auto;
	padding: 60px 20px;
	background: #fff;
	border: 1px solid #e5e8eb;
	border-radius: 12px;
	text-align: center;
	color: #666;
	font-size: 15px;
}

/* 인쇄 전용 */
@media print {
	@page {
		size: A4 portrait;
		margin: 8mm;
	}

	html,
	body {
		width: 100%;
		margin: 0;
		padding: 0;
		background: #fff;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}

	.no_print,
	header,
	nav,
	aside,
	.header,
	.top_header,
	.topHeader,
	.main_header,
	.mainHeader,
	.layout_header,
	.layoutHeader,
	.sidebar,
	.side_bar,
	.sideBar,
	.left_menu,
	.leftMenu,
	.gnb,
	.lnb,
	.snb,
	.navbar,
	.footer,
	footer,
	#header,
	#topHeader,
	#sidebar,
	#sideBar,
	#leftMenu,
	#gnb,
	#lnb,
	#footer,
	.chatbot,
	.chatbot_wrap,
	.chatbot_layer,
	.chatbot_btn,
	.chatbot_button,
	.chatbot_bubble,
	.chat_bubble,
	.talk_bubble,
	.floating_chat,
	.float_chat,
	#chatbot,
	#chatbotWrap,
	#chatbotLayer {
		display: none !important;
	}

	.layout,
	.wrapper,
	.wrap,
	.container,
	.content,
	.contents,
	.content_wrap,
	.contentWrap,
	.main,
	.main_wrap,
	.mainWrap,
	.main_content,
	.mainContent,
	.page_content,
	.pageContent,
	.coPageWrap {
		width: 100% !important;
		max-width: 100% !important;
		min-width: 0 !important;
		margin: 0 !important;
		padding: 0 !important;
		box-sizing: border-box;
	}

	.workorder_print_page {
		width: 100% !important;
		max-width: 100% !important;
		margin: 0 !important;
		padding: 0 !important;
		background: #fff;
	}

	.workorder_print_sheet {
		width: 194mm;
		height: 281mm;
		margin: 0 auto;
		padding: 7mm;
		background: #fff;
		border: none;
		border-radius: 0;
		box-shadow: none;
		box-sizing: border-box;
		overflow: hidden;
		page-break-after: always;
		break-after: page;
	}

	.workorder_print_sheet:last-child {
		page-break-after: auto;
		break-after: auto;
	}
}
</style>


<script>
	document.addEventListener("DOMContentLoaded", function() {

		isolateWorkOrderPrintPage();

		setTimeout(function() {
			window.print();
		}, 700);
	});


	// Tiles 공통 레이아웃, 사이드바, 헤더, 챗봇 말풍선을 제거하고
	// 작업지시서 인쇄 양식만 body에 남긴다.
	function isolateWorkOrderPrintPage() {

		var printPage = document.querySelector(".workorder_print_page");

		if (printPage == null) {
			return;
		}

		var printPageClone = printPage.cloneNode(true);

		var styleTags = document.querySelectorAll("style");
		var styleCloneList = [];

		for (var i = 0; i < styleTags.length; i++) {
			styleCloneList.push(styleTags[i].cloneNode(true));
		}

		document.body.innerHTML = "";

		for (var j = 0; j < styleCloneList.length; j++) {
			document.body.appendChild(styleCloneList[j]);
		}

		document.body.appendChild(printPageClone);

		document.documentElement.classList.add("workorder_print_only");
		document.body.classList.add("workorder_print_only");
	}
</script>