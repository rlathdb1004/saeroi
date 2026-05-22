<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명 : bomDetail.jsp
	메뉴   : 기준정보관리 > BOM관리 > BOM 상세

	기준:
	- 품목관리 itemDetail.jsp 구조 기준
	- 공용 detail.css 사용
	- 수정 클릭 전: 상세 텍스트 표시
	- 수정 클릭 후: input/select/autocomplete 전환
	- BOM 기본정보 + BOM 구성품을 한 번에 수정
	- 자재/부자재는 자동완성 목록에서 선택
	- 저장 시 detailItemIds, detailQtys, detailRemarks 배열로 Controller에 전달
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

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
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
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


	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<c:choose>

		<c:when test="${not empty bomDetail}">

			<form id="bomDetailModifyForm"
				action="${contextPath}/master/bom/detail/modify" method="post"
				accept-charset="UTF-8"
				onsubmit="return submitBomDetailModifyForm();">

				<input type="hidden" name="bomId" value="${bomDetail.bomId}" /> <input
					type="hidden" name="itemId" value="${bomDetail.itemId}" />

				<%-- =====================================================
				     1. BOM 기본 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">BOM 기본 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 23%;">
							<col style="width: 10%;">
							<col style="width: 23%;">
							<col style="width: 10%;">
							<col style="width: 24%;">
						</colgroup>

						<tbody>
							<tr>
								<th>BOM ID</th>
								<td>${bomDetail.bomId}</td>

								<th>BOM코드</th>
								<td><span data-view-value title="${bomDetail.bomCode}">
										${bomDetail.bomCode} </span>

									<div data-edit-box style="display: none;">
										<input type="text" name="bomCode" value="${bomDetail.bomCode}"
											readonly
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>

								<th>버전</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty bomDetail.version}">
												V${bomDetail.version}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="version" id="version"
											value="${bomDetail.version}" min="1" required
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>
							</tr>

							<tr>
								<th>완제품코드</th>
								<td><span data-view-value title="${bomDetail.itemCode}">
										<c:choose>
											<c:when test="${not empty bomDetail.itemCode}">
												${bomDetail.itemCode}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" value="${bomDetail.itemCode}" readonly
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>

								<th>완제품명</th>
								<td><span data-view-value title="${bomDetail.itemName}">
										<c:choose>
											<c:when test="${not empty bomDetail.itemName}">
												${bomDetail.itemName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" value="${bomDetail.itemName}" readonly
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>

								<th>사용여부</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${bomDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">
													<c:choose>
														<c:when test="${not empty bomDetail.useYnName}">
															${bomDetail.useYnName}
														</c:when>
														<c:otherwise>사용</c:otherwise>
													</c:choose>
												</span>
											</c:when>
											<c:otherwise>
												<span class="detail_status_badge detail_status_fail">
													<c:choose>
														<c:when test="${not empty bomDetail.useYnName}">
															${bomDetail.useYnName}
														</c:when>
														<c:otherwise>미사용</c:otherwise>
													</c:choose>
												</span>
											</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<select name="useYn" data-edit-select-control disabled
											style="width: 100%; max-width: 100%; box-sizing: border-box;">
											<option value="Y"
												<c:if test="${bomDetail.useYn == 'Y'}">selected</c:if>>
												사용</option>
											<option value="N"
												<c:if test="${bomDetail.useYn == 'N'}">selected</c:if>>
												미사용</option>
										</select>
									</div></td>
							</tr>

							<tr>
								<th>비고</th>
								<td colspan="5"><span data-view-value
									title="${bomDetail.remark}"> <c:choose>
											<c:when test="${not empty bomDetail.remark}">
												${bomDetail.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="remark" value="${bomDetail.remark}"
											maxlength="30"
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>
							</tr>
						</tbody>
					</table>
				</div>


				<%-- =====================================================
				     2. BOM 구성 자재
				     ===================================================== --%>
				<div class="detail_card">

					<div class="bom_detail_title_row">
						<div class="detail_card_title">BOM 구성 자재</div>

						<div data-edit-box style="display: none;">
							<button type="button" class="detail_btn_green"
								onclick="addBomDetailRow();">구성 자재 추가</button>
						</div>
					</div>

					<table class="detail_info_table" id="bomDetailMaterialTable">
						<thead>
							<tr>
								<th>상세ID</th>
								<th>자재코드</th>
								<th>자재명</th>
								<th>소요량</th>
								<th>단위</th>
								<th>비고</th>
								<th><span data-edit-box style="display: none;">삭제</span></th>
							</tr>
						</thead>

						<tbody id="bomDetailTbody">
							<c:choose>
								<c:when test="${not empty bomDetailList}">
									<c:forEach var="detail" items="${bomDetailList}">
										<tr>
											<td title="${detail.bomDetailId}"><c:choose>
													<c:when test="${not empty detail.bomDetailId}">
														${detail.bomDetailId}
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose></td>

											<td title="${detail.itemCode}"><span data-view-value>
													<c:choose>
														<c:when test="${not empty detail.itemCode}">
															${detail.itemCode}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
											</span>

												<div data-edit-box style="display: none;">
													<input type="text" class="materialCodeInput"
														value="${detail.itemCode}" readonly
														style="width: 100%; max-width: 100%; box-sizing: border-box;" />
												</div></td>

											<td title="${detail.itemName}"
												class="autocomplete-wrap bomMaterialAutoCell"><span
												data-view-value> <c:choose>
														<c:when test="${not empty detail.itemName}">
															${detail.itemName}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
											</span>

												<div data-edit-box style="display: none;">
													<input type="hidden" name="detailItemIds"
														class="materialItemIdInput" value="${detail.itemId}" /> <input
														type="text" class="materialNameInput"
														value="${detail.itemName}" placeholder="자재/부자재명을 입력하세요."
														autocomplete="off" required
														oninput="searchMaterialAutoComplete(this);"
														style="width: 100%; max-width: 100%; box-sizing: border-box;" />

													<div class="autocomplete-list materialAutoCompleteBox"></div>

													<p class="autocomplete-id-text materialSelectedText">
														<c:choose>
															<c:when test="${not empty detail.itemId}">
																선택된 구성품 ID: ${detail.itemId}
															</c:when>
															<c:otherwise>
																자동완성 목록에서 구성품을 선택하세요.
															</c:otherwise>
														</c:choose>
													</p>
												</div></td>

											<td><span data-view-value> <c:choose>
														<c:when test="${not empty detail.qty}">
															<fmt:formatNumber value="${detail.qty}"
																pattern="#,##0.###" />
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
											</span>

												<div data-edit-box style="display: none;">
													<input type="number" name="detailQtys"
														value="${detail.qty}" min="0.001" step="0.001" required
														style="width: 100%; max-width: 100%; box-sizing: border-box;" />
												</div></td>

											<td title="${detail.itemUnit}"><span data-view-value>
													<c:choose>
														<c:when test="${not empty detail.itemUnit}">
															${detail.itemUnit}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
											</span>

												<div data-edit-box style="display: none;">
													<input type="text" class="materialUnitInput"
														value="${detail.itemUnit}" readonly
														style="width: 100%; max-width: 100%; box-sizing: border-box;" />
												</div></td>

											<td title="${detail.remark}"><span data-view-value>
													<c:choose>
														<c:when test="${not empty detail.remark}">
															${detail.remark}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
											</span>

												<div data-edit-box style="display: none;">
													<input type="text" name="detailRemarks"
														value="${detail.remark}" maxlength="30"
														style="width: 100%; max-width: 100%; box-sizing: border-box;" />
												</div></td>

											<td>
												<div data-edit-box style="display: none;">
													<a href="javascript:void(0);" class="coDetailBtn"
														onclick="removeBomDetailRow(this);"> 삭제 </a>
												</div>
											</td>
										</tr>
									</c:forEach>
								</c:when>

								<c:otherwise>
									<tr id="emptyBomDetailRow">
										<td colspan="7" style="text-align: center;">조회된 BOM 구성
											자재가 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>

					
				</div>


				<%-- =====================================================
				     3. 관리 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">관리 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 23%;">
							<col style="width: 10%;">
							<col style="width: 23%;">
							<col style="width: 10%;">
							<col style="width: 24%;">
						</colgroup>

						<tbody>
							<tr>
								<th>등록일</th>
								<td><c:choose>
										<c:when test="${not empty bomDetail.createdDate}">
											<fmt:formatDate value="${bomDetail.createdDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>수정일</th>
								<td><c:choose>
										<c:when test="${not empty bomDetail.updatedDate}">
											<fmt:formatDate value="${bomDetail.updatedDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>상태</th>
								<td><c:choose>
										<c:when test="${bomDetail.useYn == 'Y'}">
											<span class="detail_status_badge detail_status_pass">정상</span>
										</c:when>
										<c:otherwise>
											<span class="detail_status_badge detail_status_fail">중지</span>
										</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>
				</div>

			</form>


			<%-- 신규 구성품 행 템플릿 --%>
			<table style="display: none;">
				<tbody>
					<tr id="bomDetailTemplateRow">
						<td>신규</td>

						<td><input type="text" class="materialCodeInput" readonly
							style="width: 100%; max-width: 100%; box-sizing: border-box;" />
						</td>

						<td class="autocomplete-wrap bomMaterialAutoCell"><input
							type="hidden" name="detailItemIds" class="materialItemIdInput" />

							<input type="text" class="materialNameInput"
							placeholder="자재/부자재명을 입력하세요." autocomplete="off" required
							oninput="searchMaterialAutoComplete(this);"
							style="width: 100%; max-width: 100%; box-sizing: border-box;" />

							<div class="autocomplete-list materialAutoCompleteBox"></div>

							<p class="autocomplete-id-text materialSelectedText">자동완성
								목록에서 구성품을 선택하세요.</p></td>

						<td><input type="number" name="detailQtys" min="0.001"
							step="0.001" required
							style="width: 100%; max-width: 100%; box-sizing: border-box;" />
						</td>

						<td><input type="text" class="materialUnitInput" readonly
							style="width: 100%; max-width: 100%; box-sizing: border-box;" />
						</td>

						<td><input type="text" name="detailRemarks" maxlength="30"
							value="소요량 기준"
							style="width: 100%; max-width: 100%; box-sizing: border-box;" />
						</td>

						<td><a href="javascript:void(0);" class="coDetailBtn"
							onclick="removeBomDetailRow(this);"> 삭제 </a></td>
					</tr>
				</tbody>
			</table>

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
#bomDetailMaterialTable thead th {
	text-align: center;
}

#bomDetailMaterialTable th, #bomDetailMaterialTable td {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	vertical-align: middle;
}

#bomDetailMaterialTable .bomMaterialAutoCell {
	overflow: visible;
}

.autocomplete-wrap {
	position: relative;
}

.autocomplete-id-text {
	margin: 4px 0 0 2px;
	color: #6B7280;
	font-size: 12px;
	line-height: 1.4;
}

.autocomplete-list {
	display: none;
	position: absolute;
	left: 0;
	right: 0;
	top: 100%;
	z-index: 50;
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

.bom_detail_title_row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-bottom: 12px;
}

.bom_detail_title_row .detail_card_title {
	margin-bottom: 0;
}

.bom_detail_title_row [data-edit-box] {
	margin: 0;
}

</style>


<script>
	var contextPath = "${contextPath}";

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
			editBtn.style.display = "none";
			saveBtn.style.display = "inline-flex";
			cancelBtn.style.display = "inline-flex";

			for (var i = 0; i < viewValueList.length; i++) {
				viewValueList[i].style.display = "none";
			}

			for (var j = 0; j < editBoxList.length; j++) {
				editBoxList[j].style.display = "block";
			}

			for (var k = 0; k < selectList.length; k++) {
				selectList[k].disabled = false;
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
		var tbody = document.getElementById("bomDetailTbody");
		var templateRow = document.getElementById("bomDetailTemplateRow");

		if (tbody == null || templateRow == null) {
			return;
		}

		var emptyRow = document.getElementById("emptyBomDetailRow");

		if (emptyRow != null) {
			emptyRow.remove();
		}

		var newRow = templateRow.cloneNode(true);

		newRow.removeAttribute("id");

		clearBomDetailRow(newRow);

		tbody.appendChild(newRow);

		var nameInput = newRow.querySelector(".materialNameInput");

		if (nameInput != null) {
			nameInput.focus();
		}
	}


	function clearBomDetailRow(row) {
		if (row == null) {
			return;
		}

		var itemIdInput = row.querySelector(".materialItemIdInput");
		var codeInput = row.querySelector(".materialCodeInput");
		var nameInput = row.querySelector(".materialNameInput");
		var unitInput = row.querySelector(".materialUnitInput");
		var qtyInput = row.querySelector("input[name='detailQtys']");
		var remarkInput = row.querySelector("input[name='detailRemarks']");
		var selectedText = row.querySelector(".materialSelectedText");
		var autoBox = row.querySelector(".materialAutoCompleteBox");

		if (itemIdInput != null) {
			itemIdInput.value = "";
		}

		if (codeInput != null) {
			codeInput.value = "";
		}

		if (nameInput != null) {
			nameInput.value = "";
		}

		if (unitInput != null) {
			unitInput.value = "";
		}

		if (qtyInput != null) {
			qtyInput.value = "";
		}

		if (remarkInput != null) {
			remarkInput.value = "소요량 기준";
		}

		if (selectedText != null) {
			selectedText.innerText = "자동완성 목록에서 구성품을 선택하세요.";
		}

		clearAutoCompleteBox(autoBox);
	}


	function removeBomDetailRow(element) {
		var tbody = document.getElementById("bomDetailTbody");

		if (tbody == null) {
			return;
		}

		var rowList = tbody.querySelectorAll("tr");

		if (rowList.length <= 1) {
			alert("BOM 구성 자재는 최소 1개 이상 필요합니다.");
			return;
		}

		var row = element.closest("tr");

		if (row != null) {
			row.remove();
		}
	}


	function searchMaterialAutoComplete(input) {
		if (input == null) {
			return;
		}

		var row = input.closest("tr");

		if (row == null) {
			return;
		}

		var itemIdInput = row.querySelector(".materialItemIdInput");
		var codeInput = row.querySelector(".materialCodeInput");
		var unitInput = row.querySelector(".materialUnitInput");
		var selectedText = row.querySelector(".materialSelectedText");
		var autoBox = row.querySelector(".materialAutoCompleteBox");

		var keyword = input.value.trim();

		if (itemIdInput != null) {
			itemIdInput.value = "";
		}

		if (codeInput != null) {
			codeInput.value = "";
		}

		if (unitInput != null) {
			unitInput.value = "";
		}

		if (selectedText != null) {
			selectedText.innerText = "자동완성 목록에서 구성품을 선택하세요.";
		}

		clearAutoCompleteBox(autoBox);

		if (keyword.length < 1) {
			if (autoBox != null) {
				autoBox.style.display = "none";
			}

			return;
		}

		var resultList = filterItemList(materialItemList, keyword);

		renderMaterialAutoCompleteList(resultList, input, autoBox);
	}


	function renderMaterialAutoCompleteList(itemList, input, autoBox) {
		clearAutoCompleteBox(autoBox);

		if (autoBox == null) {
			return;
		}

		if (itemList == null || itemList.length === 0) {
			autoBox.style.display = "none";
			return;
		}

		for (var i = 0; i < itemList.length; i++) {
			(function(itemData) {
				var item = document.createElement("div");
				item.className = "autocomplete-item";

				var label = "";

				if (itemData.itemCode != null && itemData.itemCode !== "") {
					label += "[" + itemData.itemCode + "] ";
				}

				label += itemData.itemName;

				if (itemData.itemType != null && itemData.itemType !== "") {
					label += " / " + itemData.itemType;
				}

				if (itemData.itemUnit != null && itemData.itemUnit !== "") {
					label += " / " + itemData.itemUnit;
				}

				label += " / ID: " + itemData.itemId;

				item.innerText = label;

				item.addEventListener("click", function() {
					selectMaterialItem(input, itemData);
				});

				autoBox.appendChild(item);
			})(itemList[i]);
		}

		autoBox.style.display = "block";
	}


	function selectMaterialItem(input, itemData) {
		var row = input.closest("tr");

		if (row == null) {
			return;
		}

		var itemIdInput = row.querySelector(".materialItemIdInput");
		var codeInput = row.querySelector(".materialCodeInput");
		var unitInput = row.querySelector(".materialUnitInput");
		var selectedText = row.querySelector(".materialSelectedText");
		var autoBox = row.querySelector(".materialAutoCompleteBox");

		input.value = itemData.itemName;

		if (itemIdInput != null) {
			itemIdInput.value = itemData.itemId;
		}

		if (codeInput != null) {
			codeInput.value = itemData.itemCode;
		}

		if (unitInput != null) {
			unitInput.value = itemData.itemUnit;
		}

		if (selectedText != null) {
			selectedText.innerText = "선택된 구성품 ID: " + itemData.itemId;
		}

		clearAutoCompleteBox(autoBox);

		if (autoBox != null) {
			autoBox.style.display = "none";
		}
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
			var aName = "";
			var bName = "";
			var aCode = "";
			var bCode = "";

			if (a.itemName != null) {
				aName = a.itemName.toLowerCase();
			}

			if (b.itemName != null) {
				bName = b.itemName.toLowerCase();
			}

			if (a.itemCode != null) {
				aCode = a.itemCode.toLowerCase();
			}

			if (b.itemCode != null) {
				bCode = b.itemCode.toLowerCase();
			}

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


	function clearAutoCompleteBox(autoBox) {
		if (autoBox == null) {
			return;
		}

		while (autoBox.firstChild) {
			autoBox.removeChild(autoBox.firstChild);
		}
	}


	function hideAllAutoCompleteBox() {
		var boxList = document.querySelectorAll(".autocomplete-list");

		for (var i = 0; i < boxList.length; i++) {
			clearAutoCompleteBox(boxList[i]);
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
		var tbody = document.getElementById("bomDetailTbody");

		if (tbody == null) {
			alert("BOM 구성 자재 영역을 찾을 수 없습니다.");
			return false;
		}

		var emptyRow = document.getElementById("emptyBomDetailRow");

		if (emptyRow != null) {
			alert("BOM 구성 자재를 1개 이상 입력하세요.");
			return false;
		}

		var rowList = tbody.querySelectorAll("tr");

		if (rowList.length === 0) {
			alert("BOM 구성 자재를 1개 이상 입력하세요.");
			return false;
		}

		var selectedItemMap = {};

		for (var i = 0; i < rowList.length; i++) {
			var itemIdInput = rowList[i].querySelector(".materialItemIdInput");
			var nameInput = rowList[i].querySelector(".materialNameInput");
			var qtyInput = rowList[i].querySelector("input[name='detailQtys']");

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

			if (qtyInput == null || qtyInput.value.trim() === "") {
				alert("소요량을 입력하세요.");

				if (qtyInput != null) {
					qtyInput.focus();
				}

				return false;
			}

			if (Number(qtyInput.value) <= 0) {
				alert("소요량은 0보다 커야 합니다.");
				qtyInput.focus();
				return false;
			}
		}

		return true;
	}
</script>