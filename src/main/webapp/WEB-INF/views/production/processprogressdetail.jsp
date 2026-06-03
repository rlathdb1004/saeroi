<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: processprogressdetail.jsp
	메뉴: 생산관리 > 공정진행 현황 > 공정진행 상세

	기준:
	- URL: /production/processprogress/detail?orderId=...
	- Controller return: production/processprogressdetail.tiles
	- detail.css 공통 클래스 최대 사용
	- 공정진행 현황은 작업지시와 생산실적 기준 자동 조회 화면
	- 별도 등록/수정/삭제 기능 없음
	- 버튼 기준:
	  최근 생산실적이 있으면 [실적상세] [목록]
	  최근 생산실적이 없으면 [목록]
	- 버튼 텍스트는 모바일에서도 1줄 유지
	- 진행률은 생산누계 + LOSS누계 기준으로 계산
	- 진행상태는 Mapper에서 계산
	  대기 / 진행중 / 완료 / 보류 / 취소
	- 진행중은 완료와 같은 정상 스타일로 표시
	- 모바일 상세 테이블은 왼쪽 제목 컬럼 88px 기준으로 보정
	- 처리 기준 안내는 긴 문장 줄바꿈되도록 별도 보정
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<c:set var="progressRateValue" value="0" />
<c:if test="${not empty progress and not empty progress.progressRate}">
	<c:set var="progressRateValue" value="${progress.progressRate}" />
</c:if>

<c:set var="progressRateBarValue" value="${progressRateValue}" />
<c:if test="${progressRateValue gt 100}">
	<c:set var="progressRateBarValue" value="100" />
</c:if>

<div class="detail_page process_progress_detail_page">

	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<div class="detail_header">

		<div>
			<h2 class="detail_title">공정진행 상세</h2>
			<div class="detail_path">생산관리 &gt; 공정진행 현황 &gt; 공정진행 상세</div>
		</div>

		<div class="detail_btn_area process_detail_btn_area">

			<c:if test="${not empty progress and not empty progress.prodId}">
				<button type="button"
					class="detail_btn_green process_detail_action_btn"
					onclick="location.href='${contextPath}/production/productionresult/detail?prodId=${progress.prodId}'">

					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M9 18l6-6-6-6"></path>
					</svg>

					<span>실적상세</span>
				</button>
			</c:if>


			<button type="button"
				class="detail_btn_line process_detail_list_btn"
				onclick="location.href='${contextPath}/production/processprogress'">

				<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
					<path d="M8 6h13"></path>
					<path d="M8 12h13"></path>
					<path d="M8 18h13"></path>
					<path d="M3 6h.01"></path>
					<path d="M3 12h.01"></path>
					<path d="M3 18h.01"></path>
				</svg>

				<span>목록</span>
			</button>

		</div>

	</div>


	<c:choose>

		<c:when test="${not empty progress}">

			<div class="detail_card">

				<div class="detail_card_title">공정진행 요약</div>

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
							<th>진행상태</th>
							<td>
								<c:choose>
									<c:when test="${progress.progressStatus eq '완료' or progress.progressStatus eq '진행중'}">
										<span class="detail_status_badge detail_status_pass">
											${progress.progressStatus}
										</span>
									</c:when>

									<c:when test="${progress.progressStatus eq '취소' or progress.progressStatus eq '보류'}">
										<span class="detail_status_badge detail_status_fail">
											${progress.progressStatus}
										</span>
									</c:when>

									<c:otherwise>
										<span class="detail_status_badge">
											<c:choose>
												<c:when test="${not empty progress.progressStatus}">
													${progress.progressStatus}
												</c:when>
												<c:otherwise>대기</c:otherwise>
											</c:choose>
										</span>
									</c:otherwise>
								</c:choose>
							</td>

							<th>진행률</th>
							<td>
								<div class="process_progress_rate_box">

									<div class="process_progress_rate_text">
										<fmt:formatNumber value="${progressRateValue}"
											pattern="#,##0" />%
									</div>

									<div class="process_progress_rate_bar">
										<div class="process_progress_rate_fill"
											style="width: ${progressRateBarValue}%;">
										</div>
									</div>

								</div>
							</td>

							<th>지시수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.orderQty}">
										<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>

						<tr>
							<th>생산누계</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.totalProdQty}">
										<fmt:formatNumber value="${progress.totalProdQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>
										0 ${progress.itemUnit}
									</c:otherwise>
								</c:choose>
							</td>

							<th>LOSS누계</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.totalLossQty}">
										<fmt:formatNumber value="${progress.totalLossQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>
										0 ${progress.itemUnit}
									</c:otherwise>
								</c:choose>
							</td>

							<th>진행합계</th>
							<td>
								<fmt:formatNumber value="${progress.totalProdQty + progress.totalLossQty}"
									pattern="#,##0" />
								${progress.itemUnit}
							</td>
						</tr>
					</tbody>
				</table>

				<div class="detail_help_text">
					진행률은 생산누계와 LOSS누계를 합산하여 작업지시 수량 대비 비율로 표시합니다.
				</div>

			</div>


			<div class="detail_card">

				<div class="detail_card_title">작업지시 정보</div>

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
									<c:when test="${not empty progress.orderId}">
										${progress.orderId}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>작업지시번호</th>
							<td title="${progress.workOrderDocNo}">
								<c:choose>
									<c:when test="${not empty progress.workOrderDocNo}">
										${progress.workOrderDocNo}
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
							<th>완제품 LOT</th>
							<td colspan="3" title="${progress.productLot}">
								<c:choose>
									<c:when test="${not empty progress.productLot}">
										${progress.productLot}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>작업지시 수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.orderQty}">
										<fmt:formatNumber value="${progress.orderQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</tbody>
				</table>

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
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodPlanId}">
										${progress.prodPlanId}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>생산계획번호</th>
							<td title="${progress.prodPlanDocNo}">
								<c:choose>
									<c:when test="${not empty progress.prodPlanDocNo}">
										${progress.prodPlanDocNo}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

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
						</tr>

						<tr>
							<th>계획일자</th>
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

							<th>품목 ID</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.itemId}">
										${progress.itemId}
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

							<th>품목구분</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.itemType}">
										${progress.itemType}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>

						<tr>
							<th>단위</th>
							<td colspan="5">
								<c:choose>
									<c:when test="${not empty progress.itemUnit}">
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
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
							<td>
								<c:choose>
									<c:when test="${not empty progress.lineId}">
										${progress.lineId}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>라인코드</th>
							<td title="${progress.lineCode}">
								<c:choose>
									<c:when test="${not empty progress.lineCode}">
										${progress.lineCode}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>라인명</th>
							<td title="${progress.lineName}">
								<c:choose>
									<c:when test="${not empty progress.lineName}">
										${progress.lineName}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>

						<tr>
							<th>라인상태</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.lineStatus}">
										${progress.lineStatus}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>담당자 ID</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.empId}">
										${progress.empId}
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
						</tr>

						<tr>
							<th>사원번호</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.empno}">
										${progress.empno}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>부서</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.dept}">
										${progress.dept}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>직무</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.job}">
										${progress.job}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>

						<tr>
							<th>권한</th>
							<td colspan="5">
								<c:choose>
									<c:when test="${not empty progress.role}">
										${progress.role}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</tbody>
				</table>

			</div>


			<div class="detail_card">

				<div class="detail_card_title">최근 생산실적 정보</div>

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
							<th>최근 실적 ID</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodId}">
										${progress.prodId}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>최근 생산일자</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodDate}">
										${progress.prodDate}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>최근 생산상태</th>
							<td>
								<c:choose>
									<c:when test="${empty progress.prodId}">
										<span class="detail_status_badge">-</span>
									</c:when>

									<c:when test="${progress.prodStatus eq '완료' or progress.prodStatus eq '진행중'}">
										<span class="detail_status_badge detail_status_pass">
											${progress.prodStatus}
										</span>
									</c:when>

									<c:when test="${progress.prodStatus eq '취소' or progress.prodStatus eq '보류'}">
										<span class="detail_status_badge detail_status_fail">
											${progress.prodStatus}
										</span>
									</c:when>

									<c:otherwise>
										<span class="detail_status_badge">
											<c:choose>
												<c:when test="${not empty progress.prodStatus}">
													${progress.prodStatus}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>

						<tr>
							<th>최근 생산수량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodId}">
										<fmt:formatNumber value="${progress.prodQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>최근 LOSS량</th>
							<td>
								<c:choose>
									<c:when test="${not empty progress.prodId}">
										<fmt:formatNumber value="${progress.lossQty}" pattern="#,##0" />
										${progress.itemUnit}
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>

							<th>품질검사 상태</th>
							<td>
								<c:choose>
									<c:when test="${empty progress.prodId}">
										<span class="detail_status_badge">-</span>
									</c:when>

									<c:when test="${progress.inspectionStatus eq '검사 완료'}">
										<span class="detail_status_badge detail_status_pass">
											${progress.inspectionStatus}
										</span>
									</c:when>

									<c:otherwise>
										<span class="detail_status_badge">
											<c:choose>
												<c:when test="${not empty progress.inspectionStatus}">
													${progress.inspectionStatus}
												</c:when>
												<c:otherwise>검사 예정</c:otherwise>
											</c:choose>
										</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="detail_help_text">
					최근 생산실적은 해당 작업지시에 연결된 생산실적 중 가장 최근 등록된 건을 기준으로 표시합니다.
				</div>

			</div>


			<div class="detail_card">

				<div class="detail_card_title">처리 기준 안내</div>

				<table class="detail_info_table process_detail_guide_table">
					<colgroup>
						<col style="width: 88px;">
						<col>
					</colgroup>

					<tbody>
						<tr>
							<th>처리 기준</th>
							<td>
								공정진행 현황은 작업지시와 생산실적을 기준으로 자동 계산됩니다.
								생산수량 변경은 생산실적 상세에서 처리하고,
								작업지시 수량 변경은 작업지시 상세에서 처리합니다.
								진행률은 생산누계와 LOSS누계를 합산하여 작업지시 수량 대비 비율로 표시합니다.
							</td>
						</tr>
					</tbody>
				</table>

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
/* 공정진행 상세 전용 최소 보정: 공통 detail.css를 유지하면서 진행률/버튼/모바일 컬럼폭만 보조한다. */

/* 버튼 한 줄 유지 */
.process_detail_btn_area {
	display: flex;
	align-items: center;
	gap: 8px;
	flex-wrap: nowrap;
}

.process_detail_action_btn,
.process_detail_list_btn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	white-space: nowrap;
	word-break: keep-all;
	flex-shrink: 0;
}

.process_detail_action_btn span,
.process_detail_list_btn span {
	display: inline-block;
	white-space: nowrap;
	word-break: keep-all;
	line-height: 1;
}

.process_detail_action_btn {
	min-width: 96px;
}

.process_detail_list_btn {
	min-width: 82px;
}


/* 진행률 */
.process_progress_rate_box {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
	box-sizing: border-box;
}

.process_progress_rate_text {
	flex: 0 0 auto;
	min-width: 42px;
	font-weight: 700;
	color: #374151;
	white-space: nowrap;
}

.process_progress_rate_bar {
	flex: 1 1 auto;
	max-width: 180px;
	height: 8px;
	border-radius: 999px;
	background: #e5e7eb;
	overflow: hidden;
}

.process_progress_rate_fill {
	height: 100%;
	border-radius: 999px;
	background: currentColor;
	color: #16a34a;
}


/* 공정진행 상세 테이블 컬럼폭/줄바꿈 보정 */
.process_progress_detail_page .detail_info_table {
	width: 100%;
	table-layout: fixed;
}

.process_progress_detail_page .detail_info_table th {
	box-sizing: border-box;
	word-break: keep-all;
	white-space: normal;
}

.process_progress_detail_page .detail_info_table td {
	min-width: 0;
	box-sizing: border-box;
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
}

/* 처리 기준 안내 긴 문장 줄바꿈 보정 */
.process_detail_guide_table td {
	line-height: 1.6;
	vertical-align: top;
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
}


@media screen and (max-width: 768px) {
	.process_detail_btn_area {
		flex-wrap: nowrap;
		gap: 8px;
	}

	.process_detail_action_btn {
		min-width: 96px;
		padding-left: 13px;
		padding-right: 13px;
	}

	.process_detail_list_btn {
		min-width: 82px;
		padding-left: 13px;
		padding-right: 13px;
	}

	.process_progress_rate_box {
		align-items: stretch;
		flex-direction: column;
		gap: 6px;
	}

	.process_progress_rate_bar {
		max-width: 100%;
		width: 100%;
	}

	.process_progress_detail_page .detail_info_table colgroup {
		display: none;
	}

	.process_progress_detail_page .detail_info_table th {
		width: 88px;
		min-width: 88px;
		padding-left: 10px;
		padding-right: 10px;
	}

	.process_progress_detail_page .detail_info_table td {
		width: auto;
		min-width: 0;
		padding-left: 12px;
		padding-right: 12px;
		white-space: normal;
		word-break: keep-all;
		overflow-wrap: anywhere;
	}

	.process_detail_guide_table th {
		width: 88px;
		min-width: 88px;
	}

	.process_detail_guide_table td {
		white-space: normal;
		word-break: keep-all;
		overflow-wrap: anywhere;
		line-height: 1.6;
	}
}
</style>