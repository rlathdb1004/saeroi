<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: processprogressdetail.jsp
	메뉴: 생산관리 > 공정진행 현황 > 공정진행 상세

	기준:
	- URL: /production/processprogress/detail
	- Controller return: production/processprogressdetail.tiles
	- 공정진행 상세는 조회 전용이다.
	- 별도 등록/수정하지 않고 생산실적 등록(PRODUCTION) 데이터를 작업지시 기준으로 누적 집계한다.
	- 진행률 = 누적생산수량 / 작업지시수량
	- LOSS_QTY는 불량수량이 아니라 LOSS량 / 손실수량이다.
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>
			<h2 class="detail_title">공정진행 상세</h2>
			<div class="detail_path">생산관리 &gt; 공정진행 현황 &gt; 공정진행 상세</div>
		</div>

		<div class="detail_btn_area">

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/production/processprogress'">
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


	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<c:choose>

		<c:when test="${not empty progress}">

			<div class="detail_notice_box">
				공정진행 현황은 생산실적 등록 데이터를 기준으로 자동 집계됩니다.
				이 화면에서는 별도 등록이나 수정 없이 현재 진행상태만 조회합니다.
			</div>


			<div class="detail_card">

				<div class="detail_card_title">작업지시 기준 정보</div>

				<table class="detail_info_table progress_detail_table">
					<tbody>

						<tr>
							<th>작업지시번호</th>
							<td title="${progress.workOrderDocNo}">
								<c:choose>
									<c:when test="${not empty progress.workOrderDocNo}">
										${progress.workOrderDocNo}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>완제품 LOT</th>
							<td title="${progress.productLot}">
								<c:choose>
									<c:when test="${not empty progress.productLot}">
										${progress.productLot}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>작업지시일</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.orderDate}">
										${progress.orderDate}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>


						<tr>
							<th>생산계획번호</th>
							<td title="${progress.prodPlanDocNo}">
								<c:choose>
									<c:when test="${not empty progress.prodPlanDocNo}">
										${progress.prodPlanDocNo}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>생산계획일</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodPlanDate}">
										${progress.prodPlanDate}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>납기일</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.dueDate}">
										${progress.dueDate}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>


						<tr>
							<th>품목코드</th>
							<td title="${progress.itemCode}">
								<c:choose>
									<c:when test="${not empty progress.itemCode}">
										${progress.itemCode}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>품목명</th>
							<td title="${progress.itemName}">
								<c:choose>
									<c:when test="${not empty progress.itemName}">
										${progress.itemName}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>단위</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.itemUnit}">
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>


						<tr>
							<th>라인</th>
							<td title="${progress.lineName}">
								<c:choose>
									<c:when test="${not empty progress.lineName}">
										${progress.lineName}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>담당자</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.ename}">
										${progress.ename}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>담당부서</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.dept}">
										${progress.dept}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>

					</tbody>
				</table>

			</div>


			<div class="detail_card">

				<div class="detail_card_title">진행 수량 정보</div>

				<table class="detail_info_table progress_detail_table">
					<tbody>

						<tr>
							<th>계획수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodPlanQty}">
										<fmt:formatNumber value="${progress.prodPlanQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>작업지시수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.orderQty}">
										<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>누적생산수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.totalProdQty}">
										<fmt:formatNumber value="${progress.totalProdQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
								</c:choose>
							</td>
						</tr>


						<tr>
							<th>잔여수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.orderQty}">
										<fmt:formatNumber
											value="${progress.orderQty - progress.totalProdQty - progress.totalLossQty}"
											pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>누적 LOSS량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.totalLossQty}">
										<fmt:formatNumber value="${progress.totalLossQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
								</c:choose>
							</td>

							<th>진행상태</th>
							<td>
								<c:choose>
									<c:when test="${progress.progressStatus eq '완료'}">
										<span class="detail_status_badge detail_status_pass">
											완료
										</span>
									</c:when>

									<c:when test="${progress.progressStatus eq '보류' or progress.progressStatus eq '취소'}">
										<span class="detail_status_badge detail_status_fail">
											${progress.progressStatus}
										</span>
									</c:when>

									<c:otherwise>
										<span class="detail_status_badge">
											${progress.progressStatus}
										</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>


						<tr>
							<th>진행률</th>
							<td colspan="5">
								<div class="progress_detail_bar_wrap">

									<div class="progress_detail_bar">
										<div class="progress_detail_bar_fill"
											style="width:${empty progress.progressRate ? 0 : progress.progressRate}%;">
										</div>
									</div>

									<span class="progress_detail_rate">
										<fmt:formatNumber value="${empty progress.progressRate ? 0 : progress.progressRate}"
											pattern="#,##0" />%
									</span>

								</div>
							</td>
						</tr>

					</tbody>
				</table>

			</div>


			<div class="detail_card">

				<div class="detail_card_title">최근 생산실적 정보</div>

				<table class="detail_info_table progress_detail_table">
					<tbody>

						<tr>
							<th>최근 실적번호</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodId}">
										${progress.prodId}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>최근 생산일</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodDate}">
										${progress.prodDate}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>최근 상태</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodStatus}">
										${progress.prodStatus}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>


						<tr>
							<th>최근 생산수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodQty}">
										<fmt:formatNumber value="${progress.prodQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
								</c:choose>
							</td>

							<th>최근 LOSS량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.lossQty}">
										<fmt:formatNumber value="${progress.lossQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>0 ${progress.itemUnit}</c:otherwise>
								</c:choose>
							</td>

							<th>집계기준</th>
							<td>
								생산실적 누적
							</td>
						</tr>

					</tbody>
				</table>

				<div class="detail_help_text">
					최근 생산실적은 해당 작업지시에 연결된 PRODUCTION 데이터 중 가장 마지막 실적 기준입니다.
					누적생산수량과 누적 LOSS량은 같은 작업지시의 전체 생산실적 합계입니다.
				</div>

			</div>

		</c:when>


		<c:otherwise>

			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 공정진행 정보가 없습니다.
				</div>
			</div>

		</c:otherwise>

	</c:choose>

</div>


<style>
.detail_notice_box {
	margin-bottom: 14px;
	padding: 11px 14px;
	border-radius: 8px;
	background: #f7f9fb;
	border: 1px solid #e5e8eb;
	color: #444;
	font-size: 13px;
	line-height: 1.5;
	word-break: keep-all;
}

.progress_detail_table {
	width: 100%;
	table-layout: fixed;
}

.progress_detail_table th {
	width: 12%;
	min-width: 0;
	padding-left: 12px;
	padding-right: 8px;
	white-space: nowrap;
	word-break: keep-all;
	overflow: hidden;
	text-overflow: clip;
	box-sizing: border-box;
	font-size: 13px;
}

.progress_detail_table td {
	width: 21.333%;
	min-width: 0;
	padding-left: 14px;
	padding-right: 10px;
	vertical-align: middle;
	white-space: nowrap;
	word-break: keep-all;
	overflow: hidden;
	text-overflow: ellipsis;
	box-sizing: border-box;
	font-size: 14px;
}

.progress_detail_table td[colspan] {
	width: auto;
}

.progress_detail_bar_wrap {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
}

.progress_detail_bar {
	flex: 1;
	height: 9px;
	background: #e9edf0;
	border-radius: 99px;
	overflow: hidden;
}

.progress_detail_bar_fill {
	height: 100%;
	background: #174c3c;
	border-radius: 99px;
}

.progress_detail_rate {
	flex: 0 0 auto;
	font-size: 13px;
	font-weight: 700;
	color: #333;
}

.detail_help_text {
	margin-top: 10px;
	font-size: 13px;
	color: #666;
	line-height: 1.5;
	word-break: keep-all;
}

@media (max-width: 768px) {

	.detail_notice_box {
		font-size: 12px;
		padding: 10px 12px;
	}

	.progress_detail_table th,
	.progress_detail_table td {
		font-size: 12px;
		padding-left: 8px;
		padding-right: 6px;
	}

	.progress_detail_bar_wrap {
		gap: 6px;
	}

	.progress_detail_rate {
		font-size: 12px;
	}
}
</style>