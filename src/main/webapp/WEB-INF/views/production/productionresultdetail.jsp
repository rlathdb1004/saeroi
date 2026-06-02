<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: productionresultdetail.jsp
	메뉴: 생산관리 > 생산실적 등록 > 생산실적 상세

	기준:
	- URL: /production/productionresult/detail?prodId=...
	- Controller return: production/productionresultdetail.tiles
	- detail.css 공통 클래스 최대 사용
	- 버튼 기준:
	  조회모드: [수정] [목록]
	  수정모드: [저장] [취소] [목록]
	- 수정 가능 항목:
	  담당자, 생산수량, LOSS량, 등록구분, 비고
	- 수정 불가 항목:
	  생산일자, 작업지시, LOT, 품목, 품질검사 상태, 수량검증
	- 생산상태는 Mapper에서 누적수량 기준으로 자동 재계산
	  정상수정 → 진행중 또는 완료 자동 계산
	  보류 선택 → 보류
	  취소 선택 → 취소
	- 품질검사 상태 반영 수량검증:
	  검사 예정 → 검사 대기
	  검사 완료 → 생산수량 = 양품수량 + 불량수량 + LOSS량 검증
	- 진행중은 완료와 같은 정상 스타일로 표시
	- 모바일 수정모드에서 select/input/help text가 한 줄로 눌리지 않도록 editMode는 wrapper div에 적용
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
			<h2 class="detail_title">생산실적 상세</h2>
			<div class="detail_path">생산관리 &gt; 생산실적 등록 &gt; 생산실적 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty result}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeProductionResultEditMode(true);">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path
							d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
						</path>
					</svg>

					수정
				</button>


				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="productionResultDetailForm"
					style="display: none;">

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
					onclick="changeProductionResultEditMode(false);"
					style="display: none;">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>

					취소
				</button>

			</c:if>


			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/productionresult'">

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

		<c:when test="${not empty result}">

			<form id="productionResultDetailForm" method="post"
				action="${contextPath}/production/productionresult/update"
				onsubmit="return checkProductionResultUpdate();">

				<input type="hidden" name="prodId" value="${result.prodId}">
				<input type="hidden" name="orderId" value="${result.orderId}">
				<input type="hidden" name="orderQty" value="${result.orderQty}">


				<div class="detail_card">

					<div class="detail_card_title">생산실적 기본 정보</div>

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
								<th>생산실적 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.prodId}">
											${result.prodId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>실적번호</th>
								<td title="${result.docNo}">
									<c:choose>
										<c:when test="${not empty result.docNo}">
											${result.docNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>문서순번</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.docSeq}">
											${result.docSeq}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>생산일자</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.prodDate}">
											${result.prodDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산상태</th>
								<td>
									<c:choose>
										<c:when test="${result.prodStatus eq '완료' or result.prodStatus eq '진행중'}">
											<span class="detail_status_badge detail_status_pass">
												${result.prodStatus}
											</span>
										</c:when>

										<c:when test="${result.prodStatus eq '취소' or result.prodStatus eq '보류'}">
											<span class="detail_status_badge detail_status_fail">
												${result.prodStatus}
											</span>
										</c:when>

										<c:otherwise>
											<span class="detail_status_badge">
												<c:choose>
													<c:when test="${not empty result.prodStatus}">
														${result.prodStatus}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</span>
										</c:otherwise>
									</c:choose>
								</td>

								<th>등록구분 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${result.prodStatus eq '완료' or result.prodStatus eq '진행중'}">
												정상등록
											</c:when>
											<c:when test="${not empty result.prodStatus}">
												${result.prodStatus}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div class="editMode production_result_edit_block"
										style="display: none;">
										<select name="prodStatus" id="prodStatus"
											class="detailInput"
											disabled required>

											<option value="진행중"
												<c:if test="${result.prodStatus eq '진행중' or result.prodStatus eq '완료'}">selected</c:if>>
												정상수정
											</option>

											<option value="보류"
												<c:if test="${result.prodStatus eq '보류'}">selected</c:if>>
												보류
											</option>

											<option value="취소"
												<c:if test="${result.prodStatus eq '취소'}">selected</c:if>>
												취소
											</option>

										</select>

										<div class="detail_help_text">
											정상수정은 누적수량 기준으로 진행중/완료가 자동 계산됩니다.
										</div>
									</div>
								</td>
							</tr>

							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.createdDate}">
											${result.createdDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td colspan="3">
									<c:choose>
										<c:when test="${not empty result.updatedDate}">
											${result.updatedDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">작업지시 / 생산계획 정보</div>

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
								<td>
									<c:choose>
										<c:when test="${not empty result.orderId}">
											${result.orderId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>작업지시번호</th>
								<td title="${result.workOrderDocNo}">
									<c:choose>
										<c:when test="${not empty result.workOrderDocNo}">
											${result.workOrderDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>작업지시일</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.orderDate}">
											${result.orderDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>완제품 LOT</th>
								<td colspan="3" title="${result.productLot}">
									<c:choose>
										<c:when test="${not empty result.productLot}">
											${result.productLot}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산계획 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.prodPlanId}">
											${result.prodPlanId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>생산계획번호</th>
								<td title="${result.prodPlanDocNo}">
									<c:choose>
										<c:when test="${not empty result.prodPlanDocNo}">
											${result.prodPlanDocNo}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>납기일</th>
								<td colspan="3">
									<c:choose>
										<c:when test="${not empty result.dueDate}">
											${result.dueDate}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">품목 정보</div>

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
								<th>품목 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.itemId}">
											${result.itemId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목코드</th>
								<td title="${result.itemCode}">
									<c:choose>
										<c:when test="${not empty result.itemCode}">
											${result.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.itemType}">
											${result.itemType}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>품목명</th>
								<td colspan="3" title="${result.itemName}">
									<c:choose>
										<c:when test="${not empty result.itemName}">
											${result.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>단위</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.itemUnit}">
											${result.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">수량 정보</div>

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
								<th>지시수량</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.orderQty}">
											<fmt:formatNumber value="${result.orderQty}"
												pattern="#,##0" />
											${result.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>생산수량 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty result.prodQty}">
												<fmt:formatNumber value="${result.prodQty}"
													pattern="#,##0" />
												${result.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div class="editMode production_result_edit_block"
										style="display: none;">
										<div class="production_result_qty_line">
											<input type="number" name="prodQty"
												id="prodQty"
												class="detailInput"
												value="${result.prodQty}"
												min="1"
												oninput="setResultQtyPreview();"
												disabled required>

											<span class="production_result_unit_text">
												${result.itemUnit}
											</span>
										</div>
									</div>
								</td>

								<th>LOSS량 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty result.lossQty}">
												<fmt:formatNumber value="${result.lossQty}"
													pattern="#,##0" />
												${result.itemUnit}
											</c:when>
											<c:otherwise>
												0 ${result.itemUnit}
											</c:otherwise>
										</c:choose>
									</span>

									<div class="editMode production_result_edit_block"
										style="display: none;">
										<div class="production_result_qty_line">
											<input type="number" name="lossQty"
												id="lossQty"
												class="detailInput"
												value="${result.lossQty}"
												min="0"
												oninput="setResultQtyPreview();"
												disabled required>

											<span class="production_result_unit_text">
												${result.itemUnit}
											</span>
										</div>

										<div id="resultQtyPreviewText" class="detail_help_text">
											생산수량과 LOSS량을 입력하세요.
										</div>
									</div>
								</td>
							</tr>

							<tr>
								<th>생산 + LOSS</th>
								<td colspan="5">
									<fmt:formatNumber value="${result.prodQty + result.lossQty}"
										pattern="#,##0" />
									${result.itemUnit}
								</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">품질검사 / 수량검증</div>

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
								<th>품질검사 상태</th>
								<td>
									<c:choose>
										<c:when test="${result.inspectionStatus eq '검사 완료'}">
											<span class="detail_status_badge detail_status_pass">
												${result.inspectionStatus}
											</span>
										</c:when>

										<c:otherwise>
											<span class="detail_status_badge">
												<c:choose>
													<c:when test="${not empty result.inspectionStatus}">
														${result.inspectionStatus}
													</c:when>
													<c:otherwise>검사 예정</c:otherwise>
												</c:choose>
											</span>
										</c:otherwise>
									</c:choose>
								</td>

								<th>수량검증</th>
								<td>
									<c:choose>
										<c:when test="${result.qtyCheckYn eq '대기'}">
											<span class="detail_status_badge">
												검사 대기
											</span>
										</c:when>

										<c:when test="${result.qtyCheckYn eq 'Y'}">
											<span class="detail_status_badge detail_status_pass">
												정상
											</span>
										</c:when>

										<c:when test="${result.qtyCheckYn eq 'N'}">
											<span class="detail_status_badge detail_status_fail">
												차이 발생
											</span>
										</c:when>

										<c:otherwise>
											<span class="detail_status_badge">-</span>
										</c:otherwise>
									</c:choose>
								</td>

								<th>수량차이</th>
								<td>
									<c:choose>
										<c:when test="${result.inspectionStatus eq '검사 완료'}">
											<fmt:formatNumber value="${result.qtyDiff}"
												pattern="#,##0" />
											${result.itemUnit}
										</c:when>
										<c:otherwise>
											0 ${result.itemUnit}
										</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>양품수량</th>
								<td>
									<c:choose>
										<c:when test="${result.inspectionStatus eq '검사 완료'}">
											<fmt:formatNumber value="${result.goodQty}"
												pattern="#,##0" />
											${result.itemUnit}
										</c:when>
										<c:otherwise>검사 대기</c:otherwise>
									</c:choose>
								</td>

								<th>불량수량</th>
								<td>
									<c:choose>
										<c:when test="${result.inspectionStatus eq '검사 완료'}">
											<fmt:formatNumber value="${result.defectQty}"
												pattern="#,##0" />
											${result.itemUnit}
										</c:when>
										<c:otherwise>검사 대기</c:otherwise>
									</c:choose>
								</td>

								<th>검증식</th>
								<td>
									<c:choose>
										<c:when test="${result.inspectionStatus eq '검사 완료'}">
											생산수량 = 양품수량 + 불량수량 + LOSS량
										</c:when>
										<c:otherwise>
											검사 완료 후 검증
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="detail_help_text">
						품질검사 상태가 검사 예정이면 수량검증은 검사 대기로 표시됩니다.
						검사 완료 후에만 양품수량, 불량수량, LOSS량 기준으로 수량을 검증합니다.
					</div>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">담당자 정보</div>

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
								<th>담당자 ID</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.empId}">
											${result.empId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>담당자 <span class="modal_required">*</span></th>
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty result.ename}">
												${result.ename}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div class="editMode production_result_edit_block"
										style="display: none;">
										<select name="empId" id="empId"
											class="detailInput"
											disabled required>

											<option value="">선택</option>

											<c:forEach var="emp" items="${productionResultEmpList}">
												<option value="${emp.empId}"
													<c:if test="${result.empId eq emp.empId}">selected</c:if>>
													${emp.ename} / ${emp.dept}
												</option>
											</c:forEach>

										</select>

										<div class="detail_help_text">
											생산실적 담당자는 작업자 / 작업자 / WORKER 기준으로 표시됩니다.
										</div>
									</div>
								</td>

								<th>사원번호</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.empno}">
											${result.empno}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>부서</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.dept}">
											${result.dept}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>직무</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.job}">
											${result.job}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>권한</th>
								<td>
									<c:choose>
										<c:when test="${not empty result.role}">
											${result.role}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

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
								<td>
									<span class="viewMode">
										<c:choose>
											<c:when test="${not empty result.remark}">
												${result.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div class="editMode production_result_edit_block"
										style="display: none;">
										<textarea name="remark"
											id="remark"
											class="detailInput production_result_remark"
											maxlength="500"
											placeholder="생산실적 관련 메모를 입력하세요."
											disabled>${result.remark}</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>

				</div>

			</form>

		</c:when>


		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 생산실적 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
/* 생산실적 상세 전용 최소 보정: 공통 detail.css 입력 스타일을 유지하면서 모바일 수정모드 깨짐 방지 */
.production_result_edit_block {
	display: block;
	width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.production_result_edit_block .detailInput {
	display: block;
	width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.production_result_qty_line {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.production_result_qty_line .detailInput {
	flex: 1 1 auto;
	width: 100%;
	min-width: 0;
}

.production_result_unit_text {
	flex: 0 0 auto;
	color: #374151;
	font-size: 14px;
	white-space: nowrap;
}

.production_result_edit_block .detail_help_text {
	display: block;
	width: 100%;
	margin-top: 6px !important;
	line-height: 1.5;
	clear: both;
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

.production_result_remark {
	min-height: 90px;
	resize: vertical;
}

@media screen and (max-width: 768px) {
	.production_result_edit_block {
		width: 100%;
	}

	.production_result_edit_block .detailInput {
		width: 100% !important;
		min-width: 0;
	}

	.production_result_qty_line {
		align-items: stretch;
		flex-direction: column;
		gap: 5px;
	}

	.production_result_unit_text {
		padding-left: 2px;
		font-size: 13px;
	}

	.production_result_edit_block .detail_help_text {
		margin-top: 5px !important;
		font-size: 12px;
	}
}
</style>


<script>
	function changeProductionResultEditMode(isEdit) {

		const viewModes = document.querySelectorAll(".viewMode");
		const editModes = document.querySelectorAll(".editMode");
		const editControls = document.querySelectorAll(".editMode input, .editMode select, .editMode textarea");

		const editBtn = document.getElementById("editBtn");
		const saveBtn = document.getElementById("saveBtn");
		const cancelBtn = document.getElementById("cancelBtn");
		const form = document.getElementById("productionResultDetailForm");

		viewModes.forEach(function(el) {
			el.style.display = isEdit ? "none" : "";
		});

		editModes.forEach(function(el) {
			el.style.display = isEdit ? "block" : "none";
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
			setResultQtyPreview();
		}
	}


	function setResultQtyPreview() {

		const prodQtyElement = document.getElementById("prodQty");
		const lossQtyElement = document.getElementById("lossQty");
		const previewElement = document.getElementById("resultQtyPreviewText");

		if (prodQtyElement == null
				|| lossQtyElement == null
				|| previewElement == null) {
			return;
		}

		const prodQty = Number(prodQtyElement.value || 0);
		const lossQty = Number(lossQtyElement.value || 0);
		const unit = "${result.itemUnit}";

		if (prodQty <= 0) {
			previewElement.innerHTML = "생산수량은 1 이상 입력해야 합니다.";
			return;
		}

		if (lossQty < 0) {
			previewElement.innerHTML = "LOSS량은 0 이상 입력해야 합니다.";
			return;
		}

		if (lossQty > prodQty) {
			previewElement.innerHTML = "LOSS량은 생산수량보다 클 수 없습니다.";
			return;
		}

		previewElement.innerHTML =
			"입력합계: 생산 "
			+ formatNumber(prodQty)
			+ " + LOSS "
			+ formatNumber(lossQty)
			+ " = "
			+ formatNumber(prodQty + lossQty)
			+ " " + (unit || "");
	}


	function checkProductionResultUpdate() {

		const empId = document.getElementById("empId").value;
		const prodQty = Number(document.getElementById("prodQty").value || 0);
		const lossQty = Number(document.getElementById("lossQty").value || 0);
		const prodStatus = document.getElementById("prodStatus").value;

		if (empId === "") {
			alert("담당자를 선택해주세요.");
			document.getElementById("empId").focus();
			return false;
		}

		if (prodQty <= 0) {
			alert("생산수량은 1 이상 입력해주세요.");
			document.getElementById("prodQty").focus();
			return false;
		}

		if (lossQty < 0) {
			alert("LOSS량은 0 이상 입력해주세요.");
			document.getElementById("lossQty").focus();
			return false;
		}

		if (lossQty > prodQty) {
			alert("LOSS량은 생산수량보다 클 수 없습니다.");
			document.getElementById("lossQty").focus();
			return false;
		}

		if (prodStatus === "취소") {
			if (!confirm("생산실적을 취소 처리하시겠습니까?\n취소된 실적은 누적 생산수량 계산에서 제외됩니다.")) {
				return false;
			}

			return true;
		}

		if (!confirm("생산실적 정보를 수정하시겠습니까?\n수정 후 생산상태는 누적수량 기준으로 다시 계산됩니다.")) {
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
		changeProductionResultEditMode(true);
	</c:if>
</script>