<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- =========================================================
	상세페이지 공통 CSS
	공통 파일은 건드리지 않고 기존 detail.css 그대로 사용
========================================================= --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<%-- =========================================================
	입출고 상세페이지 전용 보정 CSS
	공통 CSS 파일은 절대 수정하지 않고, 이 JSP 안에서만 내역서 테이블 폭을 맞춘다.
========================================================= --%>
<style>
	.inout-report-table {
		table-layout: fixed;
		width: 100%;
	}

	.inout-report-table th,
	.inout-report-table td {
		white-space: normal;
		word-break: keep-all;
		overflow-wrap: anywhere;
	}

	/* =====================================================
		LOT 이력추적으로 이동하는 링크 표시
		공통 CSS는 수정하지 않고 현재 JSP 안에서만 적용한다.
	===================================================== */
	.inout-lot-link {
		color: #0b7a5a;
		font-weight: 700;
		text-decoration: none;
		border-bottom: 1px dotted #0b7a5a;
		white-space: nowrap;
	}

	.inout-lot-link::after {
		content: " ↗";
		font-size: 12px;
	}

	.inout-lot-link:hover {
		color: #075f46;
	}
</style>

<div class="detail_page">

	<%-- =========================================================
		상세페이지 상단 영역
	========================================================= --%>
	<div class="detail_header">

		<div>

			<h2 class="detail_title">
				자재 입출고 상세
			</h2>

			<div class="detail_path">
				자재/재고관리 > 자재 입출고관리 > 자재 입출고 상세
			</div>

		</div>

		<%-- =====================================================
			버튼 영역
			기존 공통 버튼 클래스 그대로 유지
		===================================================== --%>
		<div class="detail_btn_area">

			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<c:if test="${mode ne 'edit'}">

					<button type="button"
						class="detail_btn_green"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}&mode=edit'">

						<svg width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">

							<path d="M12 20h9"></path>

							<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z">
							</path>

						</svg>

						수정

					</button>

				</c:if>

				<c:if test="${mode eq 'edit'}">

					<button type="submit"
						id="saveBtn"
						class="detail_btn_green"
						form="updateForm">

						<svg width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">

							<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
							</path>

							<path d="M17 21v-8H7v8"></path>

							<path d="M7 3v5h8"></path>

						</svg>

						저장

					</button>

					<button type="button"
						id="cancelBtn"
						class="detail_btn_line"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}'">

						<svg width="16"
							height="16"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							style="vertical-align: -3px; margin-right: 6px;"
							aria-hidden="true">

							<path d="M18 6L6 18"></path>

							<path d="M6 6l12 12"></path>

						</svg>

						취소

					</button>

				</c:if>

			</c:if>

			<button type="button"
				class="detail_btn_line"
				onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">

				<svg width="16"
					height="16"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
					style="vertical-align: -3px; margin-right: 6px;"
					aria-hidden="true">

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

	<%-- =========================================================
		수정모드 / 조회모드 분기
	========================================================= --%>
	<c:choose>

		<%-- =====================================================
			수정모드
			거래처 정보와 창고 정보는 별도 카드로 빼지 않고
			기본 정보 테이블 안에 같이 출력한다.
		===================================================== --%>
		<c:when test="${mode eq 'edit'}">

			<form id="updateForm"
				method="post"
				action="${pageContext.request.contextPath}/inventory/materialIn/update">

				<input type="hidden"
					name="inoutId"
					value="${inout.inoutId}">

				<input type="hidden"
					name="empId"
					value="${inout.empId}">

				<input type="hidden"
					name="itemId"
					value="${inout.itemId}">

				<input type="hidden"
					name="orderId"
					value="${inout.orderId}">

				<input type="hidden"
					name="docNo"
					value="<%-- =====================================================
						DOC_NO가 비어있는 기존 데이터도 상세페이지에서 입출고번호가 보이도록
						DTO의 화면 표시용 getter(displayDocNo)를 사용한다.
					===================================================== --%>
					${inout.displayDocNo}">

				<input type="hidden"
					name="docSeq"
					value="${inout.docSeq}">

				<input type="hidden"
					name="useYn"
					value="${inout.useYn}">

				<input type="hidden"
					name="status"
					value="${inout.status}">

				<div class="detail_card">

					<div class="detail_card_title">
						기본 정보
					</div>

					<table class="detail_info_table">

						<tbody>

							<tr>

								<th>입출고번호</th>
								<td>${inout.displayDocNo}</td>

								<th>입출고일자</th>

								<td>

									<input type="date"
										name="inoutDate"
										class="search-date"
										value="${inout.inoutDate}">

								</td>

								<th>품목명</th>
								<td>${inout.itemName}</td>

							</tr>

							<tr>

								<th>자재 LOT번호</th>

								<td>

									<input type="text"
										name="materialLot"
										class="search-input"
										value="${inout.materialLot}">

								</td>

								<th>입출고구분</th>

								<td>

									<select name="inoutType"
										class="search-select">

										<option value="MI"
											<c:if test="${inout.inoutType eq 'MI'}">selected</c:if>>
											입고
										</option>

										<option value="MO-PROD"
											<c:if test="${inout.inoutType eq 'MO-PROD'}">selected</c:if>>
											출고
										</option>

									</select>

								</td>

								<th>품목코드</th>
								<td>${inout.itemCode}</td>

							</tr>

							<tr>

								<th>품목유형</th>

								<td>

									<c:choose>

										<c:when test="${inout.itemType eq 'FG'}">
											완제품
										</c:when>

										<c:when test="${inout.itemType eq 'RM'}">
											원자재
										</c:when>

										<c:when test="${inout.itemType eq 'SM'}">
											부자재
										</c:when>

										<c:otherwise>
											${inout.itemType}
										</c:otherwise>

									</c:choose>

								</td>

								<th>입출고수량</th>

								<td>

									<input type="number"
										name="inoutQty"
										class="search-input"
										value="${inout.inoutQty}">

								</td>

								<th>단위</th>
								<td>${inout.itemUnit}</td>

							</tr>

							<%-- =====================================================
								거래처 정보
								입고는 공급처, 출고는 납품처 기준으로 DAO에서 조회한다.
							===================================================== --%>
							<tr>

								<th>거래처명</th>
								<td>${inout.clientName}</td>

								<th>담당자</th>
								<td>${inout.clientManager}</td>

								<th>사원번호</th>
								<td>${inout.empId}</td>

							</tr>

							<%-- =====================================================
								창고 정보
								창고위치와 현재재고도 기본 정보 안에 같이 출력한다.
							===================================================== --%>
							<tr>

								<th>창고위치</th>
								<td>${inout.stockLocation}</td>

								<th>현재재고/단위</th>
								<td><fmt:formatNumber value="${inout.inventoryStock}" pattern="#,###" /> ${inout.itemUnit}</td>

								<th>상태</th>
								<td>${inout.status}</td>

							</tr>

							<tr>

								<th>비고</th>

								<td colspan="5">

									<input type="text"
										name="remark"
										class="search-input"
										value="${inout.remark}">

								</td>

							</tr>

						</tbody>

					</table>

				</div>

			</form>

			<%-- =====================================================
				입출고 내역서
			===================================================== --%>
			<div class="detail_card">

				<div class="detail_card_title">
					입출고 내역서
				</div>

				<table class="detail_info_table inout-report-table">

					<tbody>

						<%-- =====================================================
							팀장님 피드백 반영
							입출고번호, 특정 날짜, 창고정보가 한눈에 보이도록
							내역서 형태로 다시 정리한다.
							문서순번과 사용여부는 화면에서 제외한다.
						===================================================== --%>
						<tr>

							<th>입출고번호</th>
							<td>${inout.displayDocNo}</td>

							<th>입출고일자</th>
							<td>${inout.inoutDate}</td>

							<th>상태</th>
							<td>${inout.status}</td>

						</tr>

						<tr>

							<th>입출고구분</th>
							<td>
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
									<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
									<c:otherwise>${inout.inoutType}</c:otherwise>
								</c:choose>
							</td>

							<th>창고위치</th>
							<td>${inout.stockLocation}</td>

							<th>LOT번호</th>
							<td>
								<a class="inout-lot-link"
									href="${pageContext.request.contextPath}/lot/lothistory?searchType=lotNo&keyword=${inout.materialLot}">
									${inout.materialLot}
								</a>
							</td>

						</tr>

						<tr>

							<th>품목명</th>
							<td>${inout.itemName}</td>

							<th>입출고수량/단위</th>
							<td><fmt:formatNumber value="${inout.inoutQty}" pattern="#,###" /> ${inout.itemUnit}</td>

							<th>현재재고/단위</th>
							<td><fmt:formatNumber value="${inout.inventoryStock}" pattern="#,###" /> ${inout.itemUnit}</td>

						</tr>

						<tr>

							<th>거래처명</th>
							<td>${inout.clientName}</td>

							<th>담당자</th>
							<td>${inout.clientManager}</td>

							<th>사원번호</th>
							<td>${inout.empId}</td>

						</tr>

						<tr>

							<th>등록일</th>
							<td>${inout.createdDate}</td>

							<th>수정일</th>
							<td>${inout.updatedDate}</td>

							<th>비고</th>
							<td>${inout.remark}</td>

						</tr>

					</tbody>

				</table>

			</div>

		</c:when>

		<%-- =====================================================
			조회모드
			거래처 정보와 창고 정보는 별도 카드로 빼지 않고
			기본 정보 테이블 안에 같이 출력한다.
		===================================================== --%>
		<c:otherwise>

			<div class="detail_card">

				<div class="detail_card_title">
					기본 정보
				</div>

				<table class="detail_info_table">

					<tbody>

						<tr>

							<th>입출고번호</th>
							<td>${inout.displayDocNo}</td>

							<th>입출고일자</th>
							<td>${inout.inoutDate}</td>

							<th>품목명</th>
							<td>${inout.itemName}</td>

						</tr>

						<tr>

							<th>자재 LOT번호</th>
							<td>
								<a class="inout-lot-link"
									href="${pageContext.request.contextPath}/lot/lothistory?searchType=lotNo&keyword=${inout.materialLot}">
									${inout.materialLot}
								</a>
							</td>

							<th>입출고구분</th>

							<td>

								<c:choose>

									<c:when test="${inout.inoutType eq 'MI'}">
										입고
									</c:when>

									<c:when test="${inout.inoutType eq 'MO-PROD'}">
										출고
									</c:when>

									<c:otherwise>
										${inout.inoutType}
									</c:otherwise>

								</c:choose>

							</td>

							<th>품목코드</th>
							<td>${inout.itemCode}</td>

						</tr>

						<tr>

							<th>품목유형</th>

							<td>

								<c:choose>

									<c:when test="${inout.itemType eq 'FG'}">
										완제품
									</c:when>

									<c:when test="${inout.itemType eq 'RM'}">
										원자재
									</c:when>

									<c:when test="${inout.itemType eq 'SM'}">
										부자재
									</c:when>

									<c:otherwise>
										${inout.itemType}
									</c:otherwise>

								</c:choose>

							</td>

							<th>입출고수량</th>
							<td><fmt:formatNumber value="${inout.inoutQty}" pattern="#,###" /> ${inout.itemUnit}</td>

							<th>단위</th>
							<td>${inout.itemUnit}</td>

						</tr>

						<%-- =====================================================
							거래처 정보
							입고는 공급처, 출고는 납품처 기준으로 DAO에서 조회한다.
						===================================================== --%>
						<tr>

							<th>거래처명</th>
							<td>${inout.clientName}</td>

							<th>담당자</th>
							<td>${inout.clientManager}</td>

							<th>사원번호</th>
							<td>${inout.empId}</td>

						</tr>

						<%-- =====================================================
							창고 정보
							창고위치와 현재재고도 기본 정보 안에 같이 출력한다.
						===================================================== --%>
						<tr>

							<th>창고위치</th>
							<td>${inout.stockLocation}</td>

							<th>현재재고/단위</th>
							<td><fmt:formatNumber value="${inout.inventoryStock}" pattern="#,###" /> ${inout.itemUnit}</td>

								<th>상태</th>
								<td>${inout.status}</td>

						</tr>

						<tr>

							<th>비고</th>

							<td colspan="5">
								${inout.remark}
							</td>

						</tr>

					</tbody>

				</table>

			</div>

			<%-- =====================================================
				입출고 내역서
			===================================================== --%>
			<div class="detail_card">

				<div class="detail_card_title">
					입출고 내역서
				</div>

				<table class="detail_info_table inout-report-table">

					<tbody>

						<%-- =====================================================
							팀장님 피드백 반영
							입출고번호, 특정 날짜, 창고정보가 한눈에 보이도록
							내역서 형태로 다시 정리한다.
							문서순번과 사용여부는 화면에서 제외한다.
						===================================================== --%>
						<tr>

							<th>입출고번호</th>
							<td>${inout.displayDocNo}</td>

							<th>입출고일자</th>
							<td>${inout.inoutDate}</td>

							<th>상태</th>
							<td>${inout.status}</td>

						</tr>

						<tr>

							<th>입출고구분</th>
							<td>
								<c:choose>
									<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
									<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
									<c:otherwise>${inout.inoutType}</c:otherwise>
								</c:choose>
							</td>

							<th>창고위치</th>
							<td>${inout.stockLocation}</td>

							<th>LOT번호</th>
							<td>
								<a class="inout-lot-link"
									href="${pageContext.request.contextPath}/lot/lothistory?searchType=lotNo&keyword=${inout.materialLot}">
									${inout.materialLot}
								</a>
							</td>

						</tr>

						<tr>

							<th>품목명</th>
							<td>${inout.itemName}</td>

							<th>입출고수량/단위</th>
							<td><fmt:formatNumber value="${inout.inoutQty}" pattern="#,###" /> ${inout.itemUnit}</td>

							<th>현재재고/단위</th>
							<td><fmt:formatNumber value="${inout.inventoryStock}" pattern="#,###" /> ${inout.itemUnit}</td>

						</tr>

						<tr>

							<th>거래처명</th>
							<td>${inout.clientName}</td>

							<th>담당자</th>
							<td>${inout.clientManager}</td>

							<th>사원번호</th>
							<td>${inout.empId}</td>

						</tr>

						<tr>

							<th>등록일</th>
							<td>${inout.createdDate}</td>

							<th>수정일</th>
							<td>${inout.updatedDate}</td>

							<th>비고</th>
							<td>${inout.remark}</td>

						</tr>

					</tbody>

				</table>

			</div>

		</c:otherwise>

	</c:choose>

</div>
