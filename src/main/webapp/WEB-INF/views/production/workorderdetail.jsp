<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: workorderdetail.jsp
	메뉴: 생산관리 > 작업지시 관리 > 작업지시 상세

	기준:
	- URL: /production/workorder/detail?orderId=...
	- Controller return: production/workorderdetail.tiles
	- 2번째 팀원 상세페이지 기준으로 detail.css 공통 클래스 사용
	- 버튼 기준:
	  조회모드: [수정] [목록]
	  수정모드: [저장] [취소] [목록]
	- 수정 가능 항목:
	  라인, 담당자, 지시수량, 작업지시일, 비고
	- 수정 불가 항목:
	  작업지시번호, 완제품 LOT, 작업상태, 생산계획, 품목, QR, BOM/자재투입 정보
	- QR은 DB 저장값이 아니라 /production/workorder/qr?orderId=... 실시간 생성 기준
	- 현장 작업자가 스크롤 없이 QR을 스캔할 수 있도록 QR 정보는 작업지시 기본 정보 바로 아래 배치
	- QR 영역은 표 내부가 아니라 전용 박스 구조로 구성하여 짤림 방지
	- 진행중은 완료와 같은 정상 스타일로 표시
	- 누락 컬럼 방지:
	  작업지시 ID, 작업지시번호, 완제품 LOT, 작업상태, 지시수량, 작업지시일, 등록일, 수정일,
	  생산계획 ID, 생산계획번호, 계획수량, 계획일자, 납기일,
	  품목 ID, 품목코드, 품목명, 품목구분, 단위,
	  라인 ID, 라인코드, 라인명, 라인상태,
	  담당자 ID, 담당자, 사원번호, 부서, 직무, 권한,
	  QR 코드, BOM ID, BOM 코드, BOM 버전, BOM 사용여부,
	  BOM 자재 정보, 자재투입 이력, 비고 전부 표시
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<div class="detail_header">

		<div>
			<h2 class="detail_title">작업지시 상세</h2>
			<div class="detail_path">생산관리 &gt; 작업지시 관리 &gt; 작업지시 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty workOrder}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeWorkOrderEditMode(true);">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
						</path>
					</svg>

					수정
				</button>


				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="workOrderDetailForm" style="display: none;">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
						</path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>

					저장
				</button>


				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="changeWorkOrderEditMode(false);" style="display: none;">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>

					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line detail_print_btn"
				onclick="window.open('${contextPath}/production/workorder/print?orderId=${workOrder.orderId}', '_blank');">

				<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
		<path d="M7 8V4H17V8"></path>
		<path
						d="M7 17H5C3.9 17 3 16.1 3 15V10C3 8.9 3.9 8 5 8H19C20.1 8 21 8.9 21 10V15C21 16.1 20.1 17 19 17H17"></path>
		<path d="M7 14H17V21H7V14Z"></path>
	</svg>

				인쇄
			</button>


			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/workorder'">

				<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
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


	<c:choose>

		<c:when test="${not empty workOrder}">

			<form id="workOrderDetailForm" method="post"
				action="${contextPath}/production/workorder/update"
				onsubmit="return checkWorkOrderUpdate();">

				<input type="hidden" name="orderId" value="${workOrder.orderId}">
				<input type="hidden" name="prodPlanId"
					value="${workOrder.prodPlanId}">


				<div class="detail_card">

					<div class="detail_card_title">작업지시 기본 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 22%;">
						</colgroup>

						<tbody>
							<tr>
								<th>작업지시 ID</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.orderId}">
											${workOrder.orderId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>작업지시번호</th>
								<td title="${workOrder.docNo}"><c:choose>
										<c:when test="${not empty workOrder.docNo}">
											${workOrder.docNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>작업상태</th>
								<td><c:choose>
										<c:when
											test="${workOrder.prodStatus eq '완료' or workOrder.prodStatus eq '진행중'}">
											<span class="detail_status_badge detail_status_pass">
												${workOrder.prodStatus} </span>
										</c:when>

										<c:when
											test="${workOrder.prodStatus eq '취소' or workOrder.prodStatus eq '보류'}">
											<span class="detail_status_badge detail_status_fail">
												${workOrder.prodStatus} </span>
										</c:when>

										<c:otherwise>
											<span class="detail_status_badge"> <c:choose>
													<c:when test="${not empty workOrder.prodStatus}">
														${workOrder.prodStatus}
													</c:when>
													<c:otherwise>대기</c:otherwise>
												</c:choose>
											</span>
										</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>완제품 LOT</th>
								<td colspan="3" title="${workOrder.productLot}"><c:choose>
										<c:when test="${not empty workOrder.productLot}">
											${workOrder.productLot}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>문서순번</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.docSeq}">
											${workOrder.docSeq}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>지시수량 <span class="modal_required">*</span></th>
								<td><span class="viewMode"> <c:choose>
											<c:when test="${not empty workOrder.orderQty}">
												<fmt:formatNumber value="${workOrder.orderQty}"
													pattern="#,##0" />
												${workOrder.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div class="editMode workorder_input_wrap"
										style="display: none;">
										<input type="number" name="orderQty" id="orderQty"
											class="detailInput" value="${workOrder.orderQty}" min="1"
											oninput="setOrderQtyPreview();" disabled required> <span
											class="workorder_unit_text"> ${workOrder.itemUnit} </span> <span
											id="orderQtyPreviewText" class="detail_help_text"> 현재
											수량: <fmt:formatNumber value="${workOrder.orderQty}"
												pattern="#,##0" /> ${workOrder.itemUnit}
										</span>
									</div></td>

								<th>작업지시일 <span class="modal_required">*</span></th>
								<td><span class="viewMode"> <c:choose>
											<c:when test="${not empty workOrder.orderDate}">
												${workOrder.orderDate}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span> <input type="date" name="orderDate" id="orderDate"
									class="detailInput editMode" value="${workOrder.orderDate}"
									style="display: none;" disabled required></td>

								<th>등록일</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.createdDate}">
											${workOrder.createdDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>수정일</th>
								<td colspan="5"><c:choose>
										<c:when test="${not empty workOrder.updatedDate}">
											${workOrder.updatedDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card workorder_qr_card">

					<div class="detail_card_title">QR 정보</div>

					<div class="workorder_qr_content">

						<div class="workorder_qr_image_box">
							<img class="workorder_qr_image"
								src="${contextPath}/production/workorder/qr?orderId=${workOrder.orderId}"
								alt="작업지시 QR">
						</div>

						<div class="workorder_qr_info">

							<div class="workorder_qr_info_row">
								<span class="workorder_qr_label">QR 용도</span> <span
									class="workorder_qr_value"> 생산실적 등록 이동 </span>
							</div>

							<div class="workorder_qr_info_row">
								<span class="workorder_qr_label">스캔 동작</span> <span
									class="workorder_qr_value"> QR을 스캔하면 생산실적 등록 화면으로 이동하고
									작업지시/LOT 정보가 자동 입력됩니다. </span>
							</div>

							<div class="workorder_qr_info_row">
								<span class="workorder_qr_label">이동 URL</span> <span
									class="workorder_qr_value workorder_qr_url">
									/production/workorder/qr?orderId=${workOrder.orderId} </span>
							</div>

						</div>

					</div>

					<div class="detail_help_text">현장 작업자는 이 QR을 리더기로 스캔하여 생산실적 등록
						화면으로 바로 이동합니다.</div>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">생산계획 / 품목 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 22%;">
						</colgroup>

						<tbody>
							<tr>
								<th>생산계획 ID</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.prodPlanId}">
											${workOrder.prodPlanId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>생산계획번호</th>
								<td title="${workOrder.prodPlanDocNo}"><c:choose>
										<c:when test="${not empty workOrder.prodPlanDocNo}">
											${workOrder.prodPlanDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>계획수량</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.prodPlanQty}">
											<fmt:formatNumber value="${workOrder.prodPlanQty}"
												pattern="#,##0" />
											${workOrder.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>계획일자</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.prodPlanDate}">
											${workOrder.prodPlanDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>납기일</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.dueDate}">
											${workOrder.dueDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>품목 ID</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.itemId}">
											${workOrder.itemId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>품목코드</th>
								<td title="${workOrder.itemCode}"><c:choose>
										<c:when test="${not empty workOrder.itemCode}">
											${workOrder.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>품목명</th>
								<td title="${workOrder.itemName}"><c:choose>
										<c:when test="${not empty workOrder.itemName}">
											${workOrder.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>품목구분</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.itemType}">
											${workOrder.itemType}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>단위</th>
								<td colspan="5"><c:choose>
										<c:when test="${not empty workOrder.itemUnit}">
											${workOrder.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">라인 / 담당자 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 22%;">
						</colgroup>

						<tbody>
							<tr>
								<th>라인 ID</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.lineId}">
											${workOrder.lineId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>라인 <span class="modal_required">*</span></th>
								<td><span class="viewMode"> <c:choose>
											<c:when test="${not empty workOrder.lineName}">
												${workOrder.lineName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span> <select name="lineId" id="lineId" class="detailInput editMode"
									style="display: none;" disabled required>
										<option value="">선택</option>

										<c:forEach var="line" items="${lineList}">
											<option value="${line.lineId}"
												<c:if test="${workOrder.lineId eq line.lineId}">selected</c:if>>
												${line.lineName}</option>
										</c:forEach>
								</select></td>

								<th>라인코드</th>
								<td title="${workOrder.lineCode}"><c:choose>
										<c:when test="${not empty workOrder.lineCode}">
											${workOrder.lineCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>라인상태</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.lineStatus}">
											${workOrder.lineStatus}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>담당자 ID</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.empId}">
											${workOrder.empId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>담당자 <span class="modal_required">*</span></th>
								<td><span class="viewMode"> <c:choose>
											<c:when test="${not empty workOrder.ename}">
												${workOrder.ename}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span> <select name="empId" id="empId" class="detailInput editMode"
									style="display: none;" disabled required>
										<option value="">선택</option>

										<c:forEach var="emp" items="${workOrderEmpList}">
											<option value="${emp.empId}"
												<c:if test="${workOrder.empId eq emp.empId}">selected</c:if>>
												${emp.ename} / ${emp.dept}</option>
										</c:forEach>
								</select></td>
							</tr>

							<tr>
								<th>사원번호</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.empno}">
											${workOrder.empno}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>부서</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.dept}">
											${workOrder.dept}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>직무</th>
								<td><c:choose>
										<c:when test="${not empty workOrder.job}">
											${workOrder.job}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>권한</th>
								<td colspan="5"><c:choose>
										<c:when test="${not empty workOrder.role}">
											${workOrder.role}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">적용 BOM 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 21%;">
							<col style="width: 12%;">
							<col style="width: 22%;">
						</colgroup>

						<tbody>
							<tr>
								<th>BOM ID</th>
								<td><c:choose>
										<c:when
											test="${not empty appliedBom and not empty appliedBom.bomId}">
											${appliedBom.bomId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>BOM 코드</th>
								<td title="${appliedBom.bomCode}"><c:choose>
										<c:when
											test="${not empty appliedBom and not empty appliedBom.bomCode}">
											${appliedBom.bomCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>BOM 버전</th>
								<td><c:choose>
										<c:when
											test="${not empty appliedBom and not empty appliedBom.bomVersion}">
											v${appliedBom.bomVersion}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>BOM 사용여부</th>
								<td colspan="5"><c:choose>
										<c:when
											test="${not empty appliedBom and not empty appliedBom.bomUseYn}">
											${appliedBom.bomUseYn}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>

					<div class="detail_help_text">작업지시 등록 시 생산계획의 완제품 기준으로 사용중
						BOM이 자동 적용됩니다.</div>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">BOM 자재 정보 / 자재투입 이력</div>

					<div class="workorder_material_table_wrap">
						<table class="detail_info_table workorder_material_table">
							<thead>
								<tr>
									<th>자재코드</th>
									<th>자재명</th>
									<th>소요량</th>
									<th>필요수량</th>
									<th>자재 LOT</th>
									<th>투입수량</th>
									<th>투입일자</th>
									<th>투입상태</th>
								</tr>
							</thead>

							<tbody>
								<c:choose>
									<c:when test="${not empty bomMaterialList}">
										<c:forEach var="material" items="${bomMaterialList}">
											<tr>
												<td title="${material.materialItemCode}"><c:choose>
														<c:when test="${not empty material.materialItemCode}">
															${material.materialItemCode}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td class="workorder_material_name"
													title="${material.materialItemName}"><c:choose>
														<c:when test="${not empty material.materialItemName}">
															${material.materialItemName}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td><c:choose>
														<c:when test="${not empty material.bomQty}">
															<fmt:formatNumber value="${material.bomQty}"
																pattern="#,##0.####" />
															${material.materialItemUnit}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td><c:choose>
														<c:when test="${not empty material.requiredQty}">
															<fmt:formatNumber value="${material.requiredQty}"
																pattern="#,##0.####" />
															${material.materialItemUnit}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td title="${material.materialLot}"><c:choose>
														<c:when test="${not empty material.materialLot}">
															${material.materialLot}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td><c:choose>
														<c:when test="${not empty material.inoutQty}">
															<fmt:formatNumber value="${material.inoutQty}"
																pattern="#,##0.####" />
															${material.materialItemUnit}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td><c:choose>
														<c:when test="${not empty material.inoutDate}">
															${material.inoutDate}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td><c:choose>
														<c:when test="${not empty material.inoutStatus}">
															${material.inoutStatus}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="8">조회된 BOM 자재 정보가 없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>

					<div class="workorder_material_mobile_wrap">
						<c:choose>
							<c:when test="${not empty bomMaterialList}">
								<c:forEach var="material" items="${bomMaterialList}">
									<div class="workorder_material_mobile_card">
										<div class="workorder_material_mobile_row">
											<span>자재코드</span> <strong>${material.materialItemCode}</strong>
										</div>

										<div class="workorder_material_mobile_row">
											<span>자재명</span> <strong>${material.materialItemName}</strong>
										</div>

										<div class="workorder_material_mobile_row">
											<span>필요수량</span> <strong> <fmt:formatNumber
													value="${material.requiredQty}" pattern="#,##0.####" />
												${material.materialItemUnit}
											</strong>
										</div>

										<div class="workorder_material_mobile_row">
											<span>자재 LOT</span> <strong> <c:choose>
													<c:when test="${not empty material.materialLot}">
														${material.materialLot}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</strong>
										</div>

										<div class="workorder_material_mobile_row">
											<span>투입수량</span> <strong> <c:choose>
													<c:when test="${not empty material.inoutQty}">
														<fmt:formatNumber value="${material.inoutQty}"
															pattern="#,##0.####" />
														${material.materialItemUnit}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</strong>
										</div>

										<div class="workorder_material_mobile_row">
											<span>투입상태</span> <strong> <c:choose>
													<c:when test="${not empty material.inoutStatus}">
														${material.inoutStatus}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</strong>
										</div>
									</div>
								</c:forEach>
							</c:when>

							<c:otherwise>
								<div class="workorder_material_mobile_empty">조회된 BOM 자재
									정보가 없습니다.</div>
							</c:otherwise>
						</c:choose>
					</div>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">비고</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 88%;">
						</colgroup>

						<tbody>
							<tr>
								<th>비고</th>
								<td><span class="viewMode"> <c:choose>
											<c:when test="${not empty workOrder.remark}">
												${workOrder.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span> <textarea name="remark" id="remark"
										class="detailInput editMode workorder_remark" maxlength="500"
										placeholder="작업지시 관련 메모를 입력하세요." style="display: none;"
										disabled>${workOrder.remark}</textarea></td>
							</tr>
						</tbody>
					</table>

					<div class="detail_help_text">지시수량 또는 작업지시일을 수정해도 이미 생성된 자재투입
						이력은 자동 재계산되지 않습니다. 필요 시 자재투입 이력은 별도 기준에 따라 확인해야 합니다.</div>

				</div>

			</form>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">조회된 작업지시 정보가 없습니다.</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* 작업지시 상세 전용 최소 보정: 공통 detail.css 스타일을 유지하면서 QR/자재표만 보조한다. */
.workorder_input_wrap {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.workorder_input_wrap .detailInput {
	flex: 0 1 190px;
	width: 190px !important;
}

.workorder_unit_text {
	flex: 0 0 auto;
	color: #374151;
	font-size: 14px;
	white-space: nowrap;
}

.workorder_input_wrap .detail_help_text {
	margin-top: 0 !important;
	white-space: normal;
}

.workorder_remark {
	min-height: 90px;
}

/* QR 정보 영역 */
.workorder_qr_card {
	padding-bottom: 18px;
}

.workorder_qr_content {
	display: flex;
	align-items: stretch;
	gap: 18px;
	width: 100%;
	box-sizing: border-box;
}

.workorder_qr_image_box {
	flex: 0 0 150px;
	display: flex;
	align-items: center;
	justify-content: center;
	border: 1px solid #e5e8eb;
	border-radius: 10px;
	background: #fff;
	padding: 12px;
	box-sizing: border-box;
}

.workorder_qr_image {
	width: 126px;
	height: 126px;
	object-fit: contain;
	display: block;
}

.workorder_qr_info {
	flex: 1 1 auto;
	min-width: 0;
	border-top: 1px solid #e5e8eb;
	border-left: 1px solid #e5e8eb;
	box-sizing: border-box;
}

.workorder_qr_info_row {
	display: grid;
	grid-template-columns: 110px minmax(0, 1fr);
	min-height: 42px;
	border-right: 1px solid #e5e8eb;
	border-bottom: 1px solid #e5e8eb;
	box-sizing: border-box;
}

.workorder_qr_label {
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 9px 10px;
	background: #f3f7f5;
	font-size: 14px;
	font-weight: 700;
	color: #1f2937;
	text-align: center;
	box-sizing: border-box;
}

.workorder_qr_value {
	display: flex;
	align-items: center;
	min-width: 0;
	padding: 9px 12px;
	font-size: 14px;
	color: #1f2937;
	line-height: 1.5;
	word-break: keep-all;
	overflow-wrap: anywhere;
	box-sizing: border-box;
}

.workorder_qr_url {
	font-size: 13px;
	color: #2563eb;
	word-break: break-all;
}

/* BOM 자재 정보 */
.workorder_material_table_wrap {
	width: 100%;
	overflow-x: auto;
}

.workorder_material_table {
	min-width: 920px;
}

.workorder_material_table th, .workorder_material_table td {
	white-space: nowrap;
	text-align: center;
}

.workorder_material_table .workorder_material_name {
	text-align: left;
}

.workorder_material_mobile_wrap {
	display: none;
}

.workorder_material_mobile_card {
	border: 1px solid #e5e8eb;
	border-radius: 10px;
	background: #fff;
	padding: 10px 12px;
	margin-bottom: 10px;
}

.workorder_material_mobile_row {
	display: flex;
	justify-content: space-between;
	gap: 10px;
	padding: 6px 0;
	font-size: 13px;
	border-bottom: 1px solid #f0f2f5;
}

.workorder_material_mobile_row:last-child {
	border-bottom: 0;
}

.workorder_material_mobile_row span {
	flex: 0 0 78px;
	color: #666;
}

.workorder_material_mobile_row strong {
	flex: 1 1 auto;
	min-width: 0;
	color: #222;
	font-weight: 600;
	text-align: right;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.workorder_material_mobile_empty {
	border: 1px solid #e5e8eb;
	border-radius: 10px;
	background: #fff;
	padding: 18px;
	text-align: center;
	color: #666;
	font-size: 13px;
}

@media screen and (max-width: 768px) {
	.workorder_input_wrap {
		align-items: stretch;
		flex-direction: column;
		gap: 6px;
	}
	.workorder_input_wrap .detailInput {
		width: 100% !important;
		flex-basis: auto;
	}
	.workorder_input_wrap .detail_help_text {
		margin-top: 4px !important;
	}
	.workorder_qr_content {
		flex-direction: column;
		gap: 12px;
	}
	.workorder_qr_image_box {
		flex-basis: auto;
		width: 100%;
	}
	.workorder_qr_info_row {
		grid-template-columns: 92px minmax(0, 1fr);
	}
	.workorder_qr_label, .workorder_qr_value {
		font-size: 13px;
		padding: 8px 9px;
	}
	.workorder_material_table_wrap {
		display: none;
	}
	.workorder_material_mobile_wrap {
		display: block;
	}
}
</style>


<script>
	function changeWorkOrderEditMode(isEdit) {

		const viewModes = document.querySelectorAll(".viewMode");
		const editModes = document.querySelectorAll(".editMode");
		const editControls = document
				.querySelectorAll(".editMode input, .editMode select, .editMode textarea, input.editMode, select.editMode, textarea.editMode");

		const editBtn = document.getElementById("editBtn");
		const saveBtn = document.getElementById("saveBtn");
		const cancelBtn = document.getElementById("cancelBtn");
		const form = document.getElementById("workOrderDetailForm");

		viewModes.forEach(function(el) {
			el.style.display = isEdit ? "none" : "";
		});

		editModes.forEach(function(el) {
			el.style.display = isEdit ? "" : "none";
		});

		editControls.forEach(function(el) {
			el.disabled = !isEdit;
		});

		if (editBtn) {
			editBtn.style.display = isEdit ? "none" : "inline-flex";
		}

		if (saveBtn) {
			saveBtn.style.display = isEdit ? "inline-flex" : "none";
		}

		if (cancelBtn) {
			cancelBtn.style.display = isEdit ? "inline-flex" : "none";
		}

		if (!isEdit && form) {
			form.reset();
		}

		if (isEdit) {
			setOrderQtyPreview();
		}
	}

	function setOrderQtyPreview() {

		const qtyElement = document.getElementById("orderQty");
		const previewElement = document.getElementById("orderQtyPreviewText");

		if (qtyElement == null || previewElement == null) {
			return;
		}

		const qty = qtyElement.value;
		const unit = "${workOrder.itemUnit}";

		if (qty == null || qty === "") {
			previewElement.innerHTML = "지시수량을 입력하세요.";
			return;
		}

		if (Number(qty) <= 0) {
			previewElement.innerHTML = "지시수량은 1 이상 입력해야 합니다.";
			return;
		}

		previewElement.innerHTML = "입력수량: " + formatNumber(qty) + " "
				+ (unit || "");
	}

	function checkWorkOrderUpdate() {

		const orderQty = document.getElementById("orderQty").value;
		const orderDate = document.getElementById("orderDate").value;
		const lineId = document.getElementById("lineId").value;
		const empId = document.getElementById("empId").value;

		if (orderQty === "" || Number(orderQty) <= 0) {
			alert("지시수량은 1 이상 입력해주세요.");
			document.getElementById("orderQty").focus();
			return false;
		}

		if (orderDate === "") {
			alert("작업지시일을 선택해주세요.");
			document.getElementById("orderDate").focus();
			return false;
		}

		if (lineId === "") {
			alert("라인을 선택해주세요.");
			document.getElementById("lineId").focus();
			return false;
		}

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("empId").focus();
			return false;
		}

		if (!confirm("작업지시 정보를 수정하시겠습니까?\n이미 생성된 자재투입 이력은 자동 재계산되지 않습니다.")) {
			return false;
		}

		return true;
	}

	function formatNumber(value) {

		if (value == null || value === "") {
			return "";
		}

		const numberValue = Number(value);

		if (isNaN(numberValue)) {
			return value;
		}

		return numberValue.toLocaleString();
	}

	<c:if test="${mode eq 'edit'}">
	changeWorkOrderEditMode(true);
	</c:if>
</script>