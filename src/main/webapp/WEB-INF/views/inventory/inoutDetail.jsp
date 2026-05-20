<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">

		<div>

			<h2 class="detail_title">
				자재 입출고 상세
			</h2>

			<div class="detail_path">
				자재/재고관리 &gt; 자재 입출고관리 &gt; 자재 입출고 상세
			</div>

		</div>

		<div class="detail_btn_area">

			<%-- 관리자 / 매니저만 수정 버튼 보임 --%>
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
							<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>

						</svg>

						수정

					</button>

				</c:if>

				<c:if test="${mode eq 'edit'}">

					<button type="submit"
						form="updateForm"
						class="detail_btn_green">

						수정완료

					</button>

					<button type="button"
						class="detail_btn_line"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}'">

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

	<c:choose>

		<c:when test="${mode eq 'edit'}">

			<form id="updateForm"
				method="post"
				action="${pageContext.request.contextPath}/inventory/materialIn/update">

				<input type="hidden"
					name="inoutId"
					value="${inout.inoutId}">

				<div class="detail_card">

					<div class="detail_card_title">
						기본 정보
					</div>

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

								<th>입출고번호</th>
								<td>${inout.docNo}</td>

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

								<th>LOT번호</th>
								<td>${inout.materialLot}</td>

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

		</c:when>

		<c:otherwise>

			<div class="detail_card">

				<div class="detail_card_title">
					기본 정보
				</div>

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

							<th>입출고번호</th>
							<td>${inout.docNo}</td>

							<th>입출고일자</th>
							<td>${inout.inoutDate}</td>

							<th>품목명</th>
							<td>${inout.itemName}</td>

						</tr>

						<tr>

							<th>LOT번호</th>
							<td>${inout.materialLot}</td>

							<th>입출고구분</th>

							<td>

								<c:choose>

									<c:when test="${inout.inoutType eq 'MI'}">

										<span class="detail_status_badge detail_status_pass">
											입고
										</span>

									</c:when>

									<c:when test="${inout.inoutType eq 'MO-PROD'}">

										<span class="detail_status_badge detail_status_wait">
											출고
										</span>

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
							<td>${inout.inoutQty}</td>

							<th>단위</th>
							<td>${inout.itemUnit}</td>

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

		</c:otherwise>

	</c:choose>

</div>