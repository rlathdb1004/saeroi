<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명 : bomDetail.jsp
	메뉴   : 기준정보관리 > BOM관리 > BOM 상세

	기준:
	- 품목관리 itemDetail.jsp 구조 기준
	- 공용 detail.css 사용
	- 보기/수정 전환 방식
	- 수정모드의 BOM 구성 자재는 등록모달과 같은 카드형 row 사용
	- 소요량 input은 천단위 콤마 표시
	- 서버 전송용 소요량은 hidden detailQtys로 숫자만 전송
	- 자재 선택 시 소요량 옆 단위 자동 변경
	- 모바일 대응 CSS는 공통 CSS 기준 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">BOM 상세</h2>
			<div class="detail_path">기준정보관리 &gt; BOM관리 &gt; BOM 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty bomDetail}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="bomDetailModifyForm" style="display: none;">
					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>
					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="changeEditMode(false);" style="display: none;">
					<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round"
						style="vertical-align: -3px; margin-right: 6px;"
						aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/master/bom'">
				<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2" stroke-linecap="round"
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


	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<c:choose>

		<c:when test="${not empty bomDetail}">

			<form id="bomDetailModifyForm"
				action="${contextPath}/master/bom/detail/modify"
				method="post"
				accept-charset="UTF-8"
				onsubmit="return submitBomDetailModifyForm();">

				<input type="hidden" name="bomId" value="${bomDetail.bomId}" />
				<input type="hidden" name="itemId" value="${bomDetail.itemId}" />

				<%-- =====================================================
				     1. BOM 기본 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">BOM 기본 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 22%;">
							<col style="width: 12%;">
							<col style="width: 22%;">
							<col style="width: 12%;">
							<col style="width: 20%;">
						</colgroup>

						<tbody>
							<tr>
								<th>BOM ID</th>
								<td>${bomDetail.bomId}</td>

								<th>BOM코드</th>
								<td>
									<span data-view-value title="${bomDetail.bomCode}">
										${bomDetail.bomCode}
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="bomCode"
											value="${bomDetail.bomCode}" readonly
											style="width: 100%; box-sizing: border-box;" />
									</div>
								</td>

								<th>버전</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty bomDetail.version}">
												V${bomDetail.version}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="version" id="version"
											value="${bomDetail.version}" min="1" required
											style="width: 100%; box-sizing: border-box;" />
									</div>
								</td>
							</tr>

							<tr>
								<th>완제품코드</th>
								<td>
									<c:choose>
										<c:when test="${not empty bomDetail.itemCode}">
											${bomDetail.itemCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>완제품명</th>
								<td title="${bomDetail.itemName}">
									<c:choose>
										<c:when test="${not empty bomDetail.itemName}">
											${bomDetail.itemName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>사용여부</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${bomDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">사용</span>
											</c:when>
											<c:otherwise>
												<span class="detail_status_badge detail_status_fail">미사용</span>
											</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="useYn" data-edit-select-control disabled
											style="width: 100%; box-sizing: border-box;">
											<option value="Y"
												<c:if test="${bomDetail.useYn == 'Y'}">selected</c:if>>
												사용
											</option>
											<option value="N"
												<c:if test="${bomDetail.useYn == 'N'}">selected</c:if>>
												미사용
											</option>
										</select>
									</div>
								</td>
							</tr>

							<tr>
								<th>비고</th>
								<td colspan="5">
									<span data-view-value title="${bomDetail.remark}">
										<c:choose>
											<c:when test="${not empty bomDetail.remark}">
												${bomDetail.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="remark"
											value="${bomDetail.remark}" maxlength="30"
											style="width: 100%; box-sizing: border-box;" />
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>


				<%-- =====================================================
				     2. BOM 구성 자재
				     ===================================================== --%>
				<div class="detail_card">

					<div class="bom-detail-title-row">
						<div class="detail_card_title">BOM 구성 자재</div>

						<div data-edit-box style="display: none;">
							<button type="button" class="detail_btn_green"
								onclick="addBomDetailRow();">
								구성 자재 추가
							</button>
						</div>
					</div>

					<%-- 보기 모드 --%>
					<div data-view-value>
						<table class="detail_info_table" id="bomDetailMaterialTable">
							<thead>
								<tr>
									<th>상세ID</th>
									<th>자재코드</th>
									<th>자재명</th>
									<th>소요량</th>
									<th>비고</th>
								</tr>
							</thead>

							<tbody>
								<c:choose>
									<c:when test="${not empty bomDetailList}">
										<c:forEach var="detail" items="${bomDetailList}">
											<tr>
												<td>${detail.bomDetailId}</td>

												<td title="${detail.itemCode}">
													<c:choose>
														<c:when test="${not empty detail.itemCode}">
															${detail.itemCode}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td title="${detail.itemName}">
													<c:choose>
														<c:when test="${not empty detail.itemName}">
															${detail.itemName}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty detail.qty}">
															<fmt:formatNumber value="${detail.qty}" pattern="#,##0.###" />
															<c:if test="${not empty detail.itemUnit}">
																&nbsp;${detail.itemUnit}
															</c:if>
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td title="${detail.remark}">
													<c:choose>
														<c:when test="${not empty detail.remark}">
															${detail.remark}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="5" style="text-align: center;">
												조회된 BOM 구성 자재가 없습니다.
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>

					<%-- 수정 모드 --%>
					<div data-edit-box style="display: none;">
						<div id="bomDetailRowArea" class="bom-detail-row-area">

							<c:forEach var="detail" items="${bomDetailList}">

								<fmt:formatNumber var="formattedQty"
									value="${detail.qty}"
									pattern="#,##0.###" />

								<div class="bom-detail-row">
									<div class="bom-detail-row-grid">

										<div class="autocomplete-wrap">
											<input type="text"
												class="modal_input materialNameInput"
												value="${detail.itemName} (${detail.itemCode})"
												placeholder="자재/부자재명 또는 코드를 입력하세요."
												autocomplete="off"
												oninput="searchMaterialAutoComplete(this);"
												required />

											<input type="hidden" name="detailItemIds"
												class="materialItemIdInput"
												value="${detail.itemId}" />

											<div class="autocomplete-list materialAutoCompleteBox"></div>
										</div>

										<div class="bom-detail-qty-box">
											<input type="text"
												class="modal_input qtyDisplayInput"
												value="${formattedQty}"
												placeholder="소요량"
												inputmode="decimal"
												autocomplete="off"
												oninput="handleQtyInput(this);"
												required />

											<input type="hidden"
												name="detailQtys"
												class="qtyValueInput"
												value="${detail.qty}" />

											<span class="bom-detail-unit-text">
												<c:choose>
													<c:when test="${not empty detail.itemUnit}">
														${detail.itemUnit}
													</c:when>
													<c:otherwise>단위</c:otherwise>
												</c:choose>
											</span>
										</div>

										<div>
											<input type="text" name="detailRemarks"
												class="modal_input"
												value="${detail.remark}"
												placeholder="비고 30자 이내"
												maxlength="30" />
										</div>

										<div>
											<button type="button"
												class="search-btn search-btn-sub bom-detail-remove-btn"
												onclick="removeBomDetailRow(this);">
												삭제
											</button>
										</div>

									</div>
								</div>
							</c:forEach>

						</div>
					</div>

				</div>


				<%-- =====================================================
				     3. 관리 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">관리 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 12%;">
							<col style="width: 22%;">
							<col style="width: 12%;">
							<col style="width: 22%;">
							<col style="width: 12%;">
							<col style="width: 20%;">
						</colgroup>

						<tbody>
							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty bomDetail.createdDate}">
											<fmt:formatDate value="${bomDetail.createdDate}" pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty bomDetail.updatedDate}">
											<fmt:formatDate value="${bomDetail.updatedDate}" pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>상태</th>
								<td>
									<c:choose>
										<c:when test="${bomDetail.useYn == 'Y'}">
											<span class="detail_status_badge detail_status_pass">정상</span>
										</c:when>
										<c:otherwise>
											<span class="detail_status_badge detail_status_fail">중지</span>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>

				</div>

			</form>

		</c:when>

		<c:otherwise>
			<div class="detail_card">
				<div class="detail_card_title">조회 결과</div>
				<div class="detail_content_area">
					<div class="detail_empty_box">조회된 BOM 상세정보가 없습니다.</div>
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<style>
.bom-detail-title-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-bottom: 12px;
	white-space: nowrap;
}

.bom-detail-title-row .detail_card_title {
	margin-bottom: 0;
	white-space: nowrap;
	flex: 0 0 auto;
}

.bom-detail-title-row [data-edit-box] {
	flex: 0 0 auto;
	margin: 0;
}

#bomDetailMaterialTable thead th {
	text-align: center;
}

#bomDetailMaterialTable th,
#bomDetailMaterialTable td {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	vertical-align: middle;
}

.autocomplete-wrap {
	position: relative;
	min-width: 0;
}

.autocomplete-list {
	display: none;
	position: absolute;
	left: 0;
	right: 0;
	top: 100%;
	z-index: 3000;
	max-height: 180px;
	overflow-y: auto;
	margin-top: 4px;
	border: 1px solid #D6DEE0;
	border-radius: 8px;
	background-color: #FFFFFF;
	box-shadow: 0 8px 18px rgba(15, 23, 42, 0.12);
	box-sizing: border-box;
}

.autocomplete-item {
	padding: 9px 12px;
	color: #1F2933;
	font-size: 13px;
	font-weight: 500;
	line-height: 1.4;
	cursor: pointer;
	border-bottom: 1px solid #EEF2F0;
	box-sizing: border-box;
}

.autocomplete-item:last-child {
	border-bottom: none;
}

.autocomplete-item:hover {
	background-color: #F7F9F8;
	color: #2F7D62;
}

.bom-detail-row-area {
	display: flex;
	flex-direction: column;
	gap: 8px;
	width: 100%;
	box-sizing: border-box;
}

.bom-detail-row {
	width: 100%;
	padding: 10px;
	border: 1px solid #E5E7EB;
	border-radius: 10px;
	background-color: #F9FAFB;
	box-sizing: border-box;
}

.bom-detail-row-grid {
	display: grid;
	grid-template-columns: minmax(0, 2fr) 160px minmax(0, 1.5fr) 92px;
	gap: 8px;
	align-items: start;
	width: 100%;
	box-sizing: border-box;
}

.bom-detail-row-grid > div {
	min-width: 0;
	box-sizing: border-box;
}

.bom-detail-row-grid input {
	width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.bom-detail-qty-box {
	display: flex;
	align-items: center;
	gap: 6px;
	width: 100%;
	min-width: 0;
	box-sizing: border-box;
}

.bom-detail-qty-box .qtyDisplayInput {
	flex: 1 1 auto;
	min-width: 0;
}

.bom-detail-unit-text {
	flex: 0 0 auto;
	min-width: 28px;
	color: #4B5563;
	font-size: 13px;
	font-weight: 700;
	white-space: nowrap;
}

.bom-detail-remove-btn {
	width: 100%;
	min-width: 0;
	padding-left: 0;
	padding-right: 0;
	box-sizing: border-box;
	white-space: nowrap;
}
</style>


<script>
	var materialItemList = [
		<c:forEach var="item" items="${materialItemList}" varStatus="status">
			{
				itemId: "${item.itemId}",
				itemCode: "${item.itemCode}",
				itemName: "${item.itemName}",
				itemUnit: "${item.itemUnit}",
				itemType: "${item.itemType}"
			}<c:if test="${!status.last}">,</c:if>
		</c:forEach>
	];


	function changeEditMode(isEdit) {
		var editBtn = document.getElementById("editBtn");
		var saveBtn = document.getElementById("saveBtn");
		var cancelBtn = document.getElementById("cancelBtn");

		var viewValueList = document.querySelectorAll("[data-view-value]");
		var editBoxList = document.querySelectorAll("[data-edit-box]");
		var selectList = document.querySelectorAll("[data-edit-select-control]");

		if (isEdit) {
			if (editBtn != null) {
				editBtn.style.display = "none";
			}

			if (saveBtn != null) {
				saveBtn.style.display = "inline-flex";
			}

			if (cancelBtn != null) {
				cancelBtn.style.display = "inline-flex";
			}

			for (var i = 0; i < viewValueList.length; i++) {
				viewValueList[i].style.display = "none";
			}

			for (var j = 0; j < editBoxList.length; j++) {
				editBoxList[j].style.display = "block";
			}

			for (var k = 0; k < selectList.length; k++) {
				selectList[k].disabled = false;
			}

			var rowArea = document.getElementById("bomDetailRowArea");

			if (rowArea != null && rowArea.children.length === 0) {
				addBomDetailRow();
			}

			var version = document.getElementById("version");

			if (version != null) {
				version.focus();
			}
		} else {
			location.reload();
		}
	}


	function addBomDetailRow() {
		var rowArea = document.getElementById("bomDetailRowArea");

		if (rowArea == null) {
			return;
		}

		var row = document.createElement("div");
		row.className = "bom-detail-row";

		row.innerHTML =
			'<div class="bom-detail-row-grid">' +

				'<div class="autocomplete-wrap">' +
					'<input type="text" class="modal_input materialNameInput" ' +
						'placeholder="자재/부자재명 또는 코드를 입력하세요." autocomplete="off" required />' +
					'<input type="hidden" name="detailItemIds" class="materialItemIdInput" />' +
					'<div class="autocomplete-list materialAutoCompleteBox"></div>' +
				'</div>' +

				'<div class="bom-detail-qty-box">' +
					'<input type="text" class="modal_input qtyDisplayInput" ' +
						'placeholder="소요량" inputmode="decimal" autocomplete="off" ' +
						'oninput="handleQtyInput(this);" required />' +
					'<input type="hidden" name="detailQtys" class="qtyValueInput" />' +
					'<span class="bom-detail-unit-text">단위</span>' +
				'</div>' +

				'<div>' +
					'<input type="text" name="detailRemarks" class="modal_input" ' +
						'placeholder="비고 30자 이내" maxlength="30" />' +
				'</div>' +

				'<div>' +
					'<button type="button" class="search-btn search-btn-sub bom-detail-remove-btn" ' +
						'onclick="removeBomDetailRow(this);">삭제</button>' +
				'</div>' +

			'</div>';

		rowArea.appendChild(row);

		var nameInput = row.querySelector(".materialNameInput");

		if (nameInput != null) {
			nameInput.addEventListener("input", function() {
				searchMaterialAutoComplete(this);
			});

			nameInput.focus();
		}
	}


	function removeBomDetailRow(target) {
		var rowArea = document.getElementById("bomDetailRowArea");

		if (rowArea == null) {
			return;
		}

		var row = null;

		if (target != null) {
			row = target.closest(".bom-detail-row");
		}

		if (row == null) {
			return;
		}

		if (rowArea.children.length <= 1) {
			alert("BOM 구성 자재는 최소 1개 이상 필요합니다.");
			return;
		}

		rowArea.removeChild(row);
	}


	function searchMaterialAutoComplete(input) {
		if (input == null) {
			return;
		}

		var row = input.closest(".bom-detail-row");

		if (row == null) {
			return;
		}

		var itemIdInput = row.querySelector(".materialItemIdInput");
		var autoBox = row.querySelector(".materialAutoCompleteBox");
		var unitText = row.querySelector(".bom-detail-unit-text");

		if (itemIdInput != null) {
			itemIdInput.value = "";
		}

		if (unitText != null) {
			unitText.innerText = "단위";
		}

		if (autoBox == null) {
			return;
		}

		autoBox.innerHTML = "";
		autoBox.style.display = "none";

		var keyword = input.value.trim();

		if (keyword.length < 1) {
			return;
		}

		var resultList = filterItemList(materialItemList, keyword);

		if (resultList == null || resultList.length === 0) {
			return;
		}

		for (var i = 0; i < resultList.length; i++) {
			(function(itemData) {
				var item = document.createElement("div");
				item.className = "autocomplete-item";

				var label = "[" + itemData.itemCode + "] " + itemData.itemName;

				if (itemData.itemType != null && itemData.itemType !== "") {
					label += " / " + itemData.itemType;
				}

				if (itemData.itemUnit != null && itemData.itemUnit !== "") {
					label += " / " + itemData.itemUnit;
				}

				label += " / ID: " + itemData.itemId;

				item.innerText = label;

				item.onclick = function() {
					input.value = itemData.itemName + " (" + itemData.itemCode + ")";

					if (itemIdInput != null) {
						itemIdInput.value = itemData.itemId;
					}

					if (unitText != null) {
						if (itemData.itemUnit != null && itemData.itemUnit !== "") {
							unitText.innerText = itemData.itemUnit;
						} else {
							unitText.innerText = "단위";
						}
					}

					autoBox.innerHTML = "";
					autoBox.style.display = "none";
				};

				autoBox.appendChild(item);
			})(resultList[i]);
		}

		autoBox.style.display = "block";
	}


	function handleQtyInput(input) {
		if (input == null) {
			return;
		}

		var rawValue = normalizeQtyValue(input.value);
		var formattedValue = formatQtyWithComma(rawValue);

		input.value = formattedValue;

		var row = input.closest(".bom-detail-row");

		if (row == null) {
			return;
		}

		var hiddenInput = row.querySelector(".qtyValueInput");

		if (hiddenInput != null) {
			hiddenInput.value = rawValue;
		}
	}


	function normalizeQtyValue(value) {
		if (value == null) {
			return "";
		}

		var rawValue = value.replace(/,/g, "");
		rawValue = rawValue.replace(/[^\d.]/g, "");

		var parts = rawValue.split(".");

		if (parts.length > 1) {
			rawValue = parts[0] + "." + parts.slice(1).join("");
		}

		return rawValue;
	}


	function formatQtyWithComma(rawValue) {
		if (rawValue == null || rawValue === "") {
			return "";
		}

		var hasDot = rawValue.indexOf(".") > -1;
		var parts = rawValue.split(".");
		var intPart = parts[0];
		var decimalPart = "";

		if (parts.length > 1) {
			decimalPart = parts[1];
		}

		intPart = intPart.replace(/^0+(?=\d)/, "");

		if (intPart === "") {
			intPart = "0";
		}

		var formattedInt = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ",");

		if (hasDot) {
			return formattedInt + "." + decimalPart;
		}

		return formattedInt;
	}


	function filterItemList(itemList, keyword) {
		var resultList = [];

		if (itemList == null || keyword == null) {
			return resultList;
		}

		var lowerKeyword = keyword.toLowerCase();

		for (var i = 0; i < itemList.length; i++) {
			var itemName = "";
			var itemCode = "";

			if (itemList[i].itemName != null) {
				itemName = itemList[i].itemName.toLowerCase();
			}

			if (itemList[i].itemCode != null) {
				itemCode = itemList[i].itemCode.toLowerCase();
			}

			if (itemName.indexOf(lowerKeyword) > -1
					|| itemCode.indexOf(lowerKeyword) > -1) {
				resultList.push(itemList[i]);
			}
		}

		resultList.sort(function(a, b) {
			var aName = a.itemName == null ? "" : a.itemName.toLowerCase();
			var bName = b.itemName == null ? "" : b.itemName.toLowerCase();
			var aCode = a.itemCode == null ? "" : a.itemCode.toLowerCase();
			var bCode = b.itemCode == null ? "" : b.itemCode.toLowerCase();

			var aScore = getAutoCompleteScore(aName, aCode, lowerKeyword);
			var bScore = getAutoCompleteScore(bName, bCode, lowerKeyword);

			if (aScore !== bScore) {
				return aScore - bScore;
			}

			if (aCode < bCode) {
				return -1;
			}

			if (aCode > bCode) {
				return 1;
			}

			return 0;
		});

		if (resultList.length > 10) {
			resultList = resultList.slice(0, 10);
		}

		return resultList;
	}


	function getAutoCompleteScore(itemName, itemCode, keyword) {
		if (itemName === keyword) {
			return 1;
		}

		if (itemName.indexOf(keyword) === 0) {
			return 2;
		}

		if (itemCode === keyword) {
			return 3;
		}

		if (itemCode.indexOf(keyword) === 0) {
			return 4;
		}

		return 5;
	}


	function hideAllAutoCompleteBox() {
		var boxList = document.querySelectorAll(".autocomplete-list");

		for (var i = 0; i < boxList.length; i++) {
			boxList[i].innerHTML = "";
			boxList[i].style.display = "none";
		}
	}


	document.addEventListener("click", function(event) {
		if (event.target.closest(".autocomplete-wrap") == null) {
			hideAllAutoCompleteBox();
		}
	});


	function submitBomDetailModifyForm() {
		var version = document.getElementById("version");

		if (version == null || version.value.trim() === "") {
			alert("버전을 입력하세요.");

			if (version != null) {
				version.focus();
			}

			return false;
		}

		if (Number(version.value) <= 0) {
			alert("버전은 1 이상으로 입력하세요.");
			version.focus();
			return false;
		}

		if (!validateBomDetailRows()) {
			return false;
		}

		var selectList = document.querySelectorAll("[data-edit-select-control]");

		for (var i = 0; i < selectList.length; i++) {
			selectList[i].disabled = false;
		}

		return confirm("BOM과 구성 자재를 수정하시겠습니까?");
	}


	function validateBomDetailRows() {
		var rowArea = document.getElementById("bomDetailRowArea");

		if (rowArea == null) {
			alert("BOM 구성 자재 영역을 찾을 수 없습니다.");
			return false;
		}

		var rowList = rowArea.querySelectorAll(".bom-detail-row");

		if (rowList.length === 0) {
			alert("BOM 구성 자재를 1개 이상 입력하세요.");
			return false;
		}

		var selectedItemMap = {};

		for (var i = 0; i < rowList.length; i++) {
			var itemIdInput = rowList[i].querySelector(".materialItemIdInput");
			var nameInput = rowList[i].querySelector(".materialNameInput");
			var qtyDisplayInput = rowList[i].querySelector(".qtyDisplayInput");
			var qtyInput = rowList[i].querySelector(".qtyValueInput");

			if (nameInput == null || nameInput.value.trim() === "") {
				alert("자재/부자재명을 입력하세요.");

				if (nameInput != null) {
					nameInput.focus();
				}

				return false;
			}

			if (itemIdInput == null || itemIdInput.value.trim() === "") {
				alert("자동완성 목록에서 구성품을 선택하세요.");

				if (nameInput != null) {
					nameInput.focus();
				}

				return false;
			}

			if (selectedItemMap[itemIdInput.value] === true) {
				alert("같은 구성품이 중복 선택되었습니다.");

				if (nameInput != null) {
					nameInput.focus();
				}

				return false;
			}

			selectedItemMap[itemIdInput.value] = true;

			if (qtyDisplayInput != null) {
				handleQtyInput(qtyDisplayInput);
			}

			if (qtyInput == null || qtyInput.value.trim() === "") {
				alert("소요량을 입력하세요.");

				if (qtyDisplayInput != null) {
					qtyDisplayInput.focus();
				}

				return false;
			}

			if (Number(qtyInput.value) <= 0 || isNaN(Number(qtyInput.value))) {
				alert("소요량은 0보다 커야 합니다.");

				if (qtyDisplayInput != null) {
					qtyDisplayInput.focus();
				}

				return false;
			}
		}

		return true;
	}
</script>