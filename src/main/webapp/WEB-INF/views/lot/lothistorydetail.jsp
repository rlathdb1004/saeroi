<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<style>
.lot_detail_page .detail_card {
	/* LOT 상세 카드 안에서 내용이 자연스럽게 보이도록 한다. */
	overflow: visible;
}

.lot_detail_page .detail_info_table {
	/* LOT 상세 테이블은 카드 너비에 맞춘다. */
	width: 100%;
	/* 공통 CSS의 최소 너비 영향을 줄인다. */
	min-width: 0;
}

.lot_detail_page .lot_basic_table {
	/* LOT 기본 정보 테이블은 PC에서 한 줄에 2개씩 보이도록 고정 레이아웃을 사용한다. */
	table-layout: fixed;
}

.lot_detail_page .lot_basic_table th {
	/* LOT 기본 정보 제목 칸 너비이다. */
	width: 120px;
	/* 제목은 한 줄로 유지한다. */
	white-space: nowrap;
}

.lot_detail_page .lot_basic_table td {
	/* 값이 길어도 칸 밖으로 잘리지 않게 한다. */
	overflow: visible;
	/* 말줄임표를 사용하지 않는다. */
	text-overflow: clip;
	/* 값이 길면 줄바꿈되도록 한다. */
	white-space: normal;
	/* 한글은 단어 기준으로 자연스럽게 줄바꿈한다. */
	word-break: keep-all;
	/* 코드처럼 긴 영문, 숫자, 하이픈 조합도 칸 안에서 줄바꿈되게 한다. */
	overflow-wrap: anywhere;
	/* 여러 줄이 되어도 보기 좋게 줄 높이를 맞춘다. */
	line-height: 1.45;
}

.lot_detail_page .lot_progress_table {
	/* LOT 진행 이력 테이블은 공통 CSS 흐름을 최대한 그대로 사용한다. */
	width: 100%;
	/* 컬럼 너비를 강제로 나누지 않고 브라우저와 공통 CSS 흐름에 맡긴다. */
	table-layout: auto;
	/* 이전에 줄어든 최대 너비 제한을 사용하지 않는다. */
	max-width: none;
}

.lot_detail_page .lot_progress_table th, .lot_detail_page .lot_progress_table td
	{
	/* 모바일 공통 CSS가 테이블을 세로형으로 바꿀 때 깨지지 않도록 강제 nowrap을 사용하지 않는다. */
	white-space: normal;
	/* 긴 문서번호도 칸 안에서 줄바꿈되게 한다. */
	overflow-wrap: anywhere;
	/* 한글은 최대한 자연스럽게 줄바꿈한다. */
	word-break: keep-all;
	/* 진행 이력 테이블 높이가 너무 답답하지 않도록 한다. */
	line-height: 1.4;
}

.lot_detail_link {
	/* 클릭 가능한 값처럼 보이게 초록색으로 강조한다. */
	color: #1F7A5C;
	/* 일반 텍스트보다 눈에 띄도록 굵게 만든다. */
	font-weight: 700;
	/* 기본 밑줄은 제거한다. */
	text-decoration: none;
	/* 링크 크기와 hover 효과를 안정적으로 적용하기 위해 inline-block으로 만든다. */
	display: inline-block;
	/* hover 때 배경이 생겨도 테이블 크기가 흔들리지 않게 기본 여백을 미리 준다. */
	padding: 2px 5px;
	/* hover 배경이 둥글게 보이도록 기본 상태에도 둔다. */
	border-radius: 5px;
	/* 기본 상태에서는 배경을 투명하게 둔다. */
	background-color: transparent;
	/* 링크 아래에 은은한 점선 느낌을 준다. */
	border-bottom: 1px dotted rgba(47, 125, 98, 0.55);
	/* 긴 링크도 줄바꿈될 수 있게 한다. */
	white-space: normal;
	/* 긴 코드값도 칸 안에서 자연스럽게 줄바꿈되게 한다. */
	overflow-wrap: anywhere;
	/* 글씨가 커질 때 왼쪽 기준으로 커지게 한다. */
	transform-origin: left center;
	/* hover 변화가 부드럽게 보이도록 한다. */
	transition: transform 0.15s ease, color 0.15s ease, background-color
		0.15s ease, border-color 0.15s ease;
}

.lot_detail_link::after {
	/* 이동 가능한 링크라는 느낌을 주는 작은 아이콘이다. */
	content: "";
	/* 아이콘 크기이다. */
	width: 14px;
	height: 14px;
	/* 아이콘을 글자 뒤에 붙인다. */
	display: inline-block;
	/* 글자와 아이콘 사이 간격이다. */
	margin-left: 5px;
	/* 아이콘 세로 위치를 맞춘다. */
	vertical-align: -2px;
	/* SVG 아이콘을 배경으로 넣는다. */
	background-repeat: no-repeat;
	background-position: center;
	background-size: 14px 14px;
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%232F7D62' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M7 17L17 7'/%3E%3Cpath d='M9 7H17V15'/%3E%3C/svg%3E");
}

.lot_detail_link:hover {
	/* 마우스를 올리면 글씨만 살짝 커지게 한다. */
	transform: scale(1.05);
	/* hover 때 더 진한 초록색으로 바꾼다. */
	color: #145C43;
	/* 글씨 뒤에 연한 초록 배경을 넣는다. */
	background-color: #EAF6F1;
	/* hover 때는 점선보다 배경이 잘 보이도록 점선을 숨긴다. */
	border-bottom-color: transparent;
}

.lot_detail_link:hover::after {
	/* hover 때 아이콘 색도 진하게 변경한다. */
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%23145C43' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M7 17L17 7'/%3E%3Cpath d='M9 7H17V15'/%3E%3C/svg%3E");
}

.lot_detail_link:active {
	/* 클릭하는 순간에는 배경을 조금 더 진하게 보여준다. */
	background-color: #DCEFE7;
}

.lot_detail_link_empty {
	/* 링크가 없는 값은 일반 텍스트처럼 보이게 한다. */
	color: #111827;
	font-weight: 500;
	text-decoration: none;
	cursor: default;
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

		<div class="detail_card_title">LOT 기본 정보</div>

		<table class="detail_info_table lot_basic_table">

			<tbody>
				<tr>
					<th>LOT번호</th>
					<td><c:choose>
							<c:when test="${not empty lot.productLot}">
								${lot.productLot}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>작업지시번호</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.workOrderDocNo and not empty lot.orderId}">
								<a
									href="${pageContext.request.contextPath}/production/workorder/detail?orderId=${lot.orderId}"
									class="lot_detail_link"> ${lot.workOrderDocNo} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>생산계획번호</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.prodPlanDocNo and not empty lot.prodPlanId}">
								<a
									href="${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${lot.prodPlanId}"
									class="lot_detail_link"> ${lot.prodPlanDocNo} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>품목코드</th>
					<td><c:choose>
							<c:when test="${not empty lot.itemCode and not empty lot.itemId}">
								<a
									href="${pageContext.request.contextPath}/master/item/detail?itemId=${lot.itemId}"
									class="lot_detail_link"> ${lot.itemCode} </a>
							</c:when>

							<c:when test="${not empty lot.itemCode}">
								${lot.itemCode}
							</c:when>

							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>품목명</th>
					<td><c:choose>
							<c:when test="${not empty lot.itemName}">
								${lot.itemName}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>작업지시수량</th>
					<td><c:choose>
							<c:when test="${not empty lot.orderQty}">
								${lot.orderQty}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>생산수량</th>
					<td><c:choose>
							<c:when test="${not empty lot.prodQty}">
								${lot.prodQty}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>불량수량</th>
					<td><c:choose>
							<c:when test="${not empty lot.lossQty}">
								${lot.lossQty}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>양품수량</th>
					<td><c:choose>
							<c:when test="${not empty lot.goodQty}">
								${lot.goodQty}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>현재공정</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.currentProcess and not empty lot.orderId}">
								<a
									href="${pageContext.request.contextPath}/production/processprogress/detail?orderId=${lot.orderId}"
									class="lot_detail_link"> ${lot.currentProcess} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>진행상태</th>
					<td><c:choose>
							<c:when test="${lot.progressStatus eq '완료'}">
								<span class="detail_status_badge detail_status_pass">
									${lot.progressStatus} </span>
							</c:when>

							<c:when test="${lot.progressStatus eq '보류'}">
								<span class="detail_status_badge detail_status_fail">
									${lot.progressStatus} </span>
							</c:when>

							<c:otherwise>
								<span class="detail_status_badge detail_status_conditional">
									${empty lot.progressStatus ? '-' : lot.progressStatus} </span>
							</c:otherwise>
						</c:choose></td>

					<th>검사결과</th>
					<td><c:choose>
							<c:when test="${lot.inspResult eq '합격'}">
								<span class="detail_status_badge detail_status_pass">
									${lot.inspResult} </span>
							</c:when>

							<c:when test="${lot.inspResult eq '불합격'}">
								<span class="detail_status_badge detail_status_fail">
									${lot.inspResult} </span>
							</c:when>

							<c:when test="${lot.inspResult eq '조건부 합격'}">
								<span class="detail_status_badge detail_status_conditional">
									${lot.inspResult} </span>
							</c:when>

							<c:otherwise>
								<span class="detail_status_badge detail_status_conditional">
									${empty lot.inspResult ? '-' : lot.inspResult} </span>
							</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>작업지시일</th>
					<td><c:choose>
							<c:when test="${not empty lot.orderDate}">
								${lot.orderDate}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>생산일자</th>
					<td><c:choose>
							<c:when test="${not empty lot.prodDate}">
								${lot.prodDate}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>검사일자</th>
					<td><c:choose>
							<c:when test="${not empty lot.inspDate}">
								${lot.inspDate}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>담당자</th>
					<td><c:choose>
							<c:when test="${not empty lot.ename}">
								${lot.ename}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>
			</tbody>

		</table>

	</div>


	<div class="detail_card">

		<div class="detail_card_title">LOT 진행 이력</div>

		<table class="detail_info_table lot_progress_table">

			<tbody>
				<tr>
					<th>1단계</th>
					<td>생산계획</td>

					<th>문서번호</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.prodPlanDocNo and not empty lot.prodPlanId}">
								<a
									href="${pageContext.request.contextPath}/production/productionplan/detail?prodPlanId=${lot.prodPlanId}"
									class="lot_detail_link"> ${lot.prodPlanDocNo} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>상태</th>
					<td>계획 생성</td>
				</tr>

				<tr>
					<th>2단계</th>
					<td>작업지시</td>

					<th>문서번호</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.workOrderDocNo and not empty lot.orderId}">
								<a
									href="${pageContext.request.contextPath}/production/workorder/detail?orderId=${lot.orderId}"
									class="lot_detail_link"> ${lot.workOrderDocNo} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>상태</th>
					<td>LOT 생성</td>
				</tr>

				<tr>
					<th>3단계</th>
					<td>공정진행</td>

					<th>현재공정</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.currentProcess and not empty lot.orderId}">
								<a
									href="${pageContext.request.contextPath}/production/processprogress/detail?orderId=${lot.orderId}"
									class="lot_detail_link"> ${lot.currentProcess} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>상태</th>
					<td><c:choose>
							<c:when test="${not empty lot.progressStatus}">
								${lot.progressStatus}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>4단계</th>
					<td>생산실적</td>

					<th>실적번호</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.prodDocNo and not empty lot.prodId}">
								<a
									href="${pageContext.request.contextPath}/production/productionresult/detail?prodId=${lot.prodId}"
									class="lot_detail_link"> ${lot.prodDocNo} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>상태</th>
					<td><c:choose>
							<c:when test="${not empty lot.progressStatus}">
								${lot.progressStatus}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>

				<tr>
					<th>5단계</th>
					<td>품질검사</td>

					<th>검사번호</th>
					<td><c:choose>
							<c:when
								test="${not empty lot.inspDocNo and not empty lot.inspId}">
								<a
									href="${pageContext.request.contextPath}/quality/inspection_detail?insp_id=${lot.inspId}"
									class="lot_detail_link"> ${lot.inspDocNo} </a>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>

					<th>결과</th>
					<td><c:choose>
							<c:when test="${not empty lot.inspResult}">
								${lot.inspResult}
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>
			</tbody>

		</table>

	</div>

</div>