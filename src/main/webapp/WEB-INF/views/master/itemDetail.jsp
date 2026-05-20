<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명 : itemDetail.jsp
	메뉴   : 기준정보관리 > 품목관리 > 품목 상세

	수정 내용:
	1. 공용 detail.css 클래스만 사용
	2. 수정 클릭 전: 일반 상세 텍스트 표시
	3. 수정 클릭 후: 기존 값이 input/select/autocomplete로 전환
	4. 품목코드는 수정 제외(readonly)
	5. 단위는 품목등록과 동일하게 select + 직접입력 지원
	6. 공급처/납품처는 품목등록과 동일하게 자동완성 지원
--%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">품목 상세</h2>
			<div class="detail_path">기준정보관리 &gt; 품목관리 &gt; 품목 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty itemDetail}">

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
					form="itemModifyForm" style="display: none;">

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
				onclick="location.href='${contextPath}/master/item'">

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


	<c:choose>

		<c:when test="${not empty itemDetail}">

			<form id="itemModifyForm" action="${contextPath}/master/item/modify"
				method="post" accept-charset="UTF-8"
				onsubmit="return submitItemModifyForm();">

				<input type="hidden" name="itemId" value="${itemDetail.itemId}" />

				<%-- 단위 실제 전송값 --%>
				<input type="hidden" name="itemUnit" id="itemUnit"
					value="${itemDetail.itemUnit}" />

				<%-- 공급처/납품처 실제 전송값 --%>
				<input type="hidden" name="supplierId" id="supplierId"
					value="${itemDetail.supplierId}" /> <input type="hidden"
					name="clientId" id="clientId" value="${itemDetail.clientId}" />

				<%-- =====================================================
				     1. 기본 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">기본 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 16%;">
							<col style="width: 10%;">
							<col style="width: 32%;">
							<col style="width: 10%;">
							<col style="width: 22%;">
						</colgroup>

						<tbody>
							<tr>
								<th>품목 ID</th>
								<td>${itemDetail.itemId}</td>

								<th>품목코드</th>
								<td><span data-view-value>${itemDetail.itemCode}</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="itemCode"
											value="${itemDetail.itemCode}" readonly
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>

								<th>품목구분</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.itemTypeName}">
												${itemDetail.itemTypeName}
											</c:when>
											<c:otherwise>${itemDetail.itemType}</c:otherwise>
										</c:choose> <c:if test="${not empty itemDetail.itemType}">
											(${itemDetail.itemType})
										</c:if>
								</span>

									<div data-edit-box style="display: none;">
										<select name="itemType" id="itemType" data-edit-select-control
											disabled required
											style="width: 100%; max-width: 100%; box-sizing: border-box;">
											<option value="">선택</option>
											<option value="FG"
												<c:if test="${itemDetail.itemType == 'FG'}">selected</c:if>>완제품
												(FG)</option>
											<option value="RM"
												<c:if test="${itemDetail.itemType == 'RM'}">selected</c:if>>원자재
												(RM)</option>
											<option value="SM"
												<c:if test="${itemDetail.itemType == 'SM'}">selected</c:if>>부자재
												(SM)</option>
										</select>
									</div></td>
							</tr>

							<tr>
								<th>품목명</th>
								<td colspan="3"><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.itemName}">
												${itemDetail.itemName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="itemName" id="itemName"
											value="${itemDetail.itemName}" required
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>

								<th>사용여부</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${itemDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">
													<c:choose>
														<c:when test="${not empty itemDetail.useYnName}">
															${itemDetail.useYnName}
														</c:when>
														<c:otherwise>사용</c:otherwise>
													</c:choose>
												</span>
											</c:when>
											<c:otherwise>
												<span class="detail_status_badge detail_status_fail">
													<c:choose>
														<c:when test="${not empty itemDetail.useYnName}">
															${itemDetail.useYnName}
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
												<c:if test="${itemDetail.useYn == 'Y'}">selected</c:if>>사용</option>
											<option value="N"
												<c:if test="${itemDetail.useYn == 'N'}">selected</c:if>>미사용</option>
										</select>
									</div></td>
							</tr>

							<tr>
								<th>안전재고</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.safetyStock}">
												<fmt:formatNumber value="${itemDetail.safetyStock}"
													pattern="#,##0" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="safetyStock" id="safetyStock"
											value="${itemDetail.safetyStock}" min="0"
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>

								<th>단위</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.itemUnit}">
												${itemDetail.itemUnit}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<select id="itemUnitSelect" onchange="changeItemUnitOption();"
											required
											style="width: 100%; max-width: 100%; box-sizing: border-box;">
											<option value="">선택</option>
											<option value="EA">EA</option>
											<option value="M">M</option>
											<option value="KG">KG</option>
											<option value="ROLL">ROLL</option>
											<option value="SET">SET</option>
											<option value="BOX">BOX</option>
											<option value="DIRECT">직접입력</option>
										</select> <input type="text" id="itemUnitDirect"
											placeholder="단위를 직접 입력하세요. 예: PCS"
											oninput="syncDirectItemUnit();"
											style="display: none; width: 100%; max-width: 100%; box-sizing: border-box; margin-top: 6px;" />
									</div></td>

								<th>비고</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.remark}">
												${itemDetail.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="remark" value="${itemDetail.remark}"
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />
									</div></td>
							</tr>
						</tbody>
					</table>
				</div>


				<%-- =====================================================
				     2. 거래처 정보
				     ===================================================== --%>
				<div class="detail_card">

					<div class="detail_card_title">거래처 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 40%;">
							<col style="width: 10%;">
							<col style="width: 40%;">
						</colgroup>

						<tbody>
							<tr>
								<th>공급처</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.supplierName}">
												${itemDetail.supplierName}
												<c:if test="${not empty itemDetail.supplierId}">
													(ID: ${itemDetail.supplierId})
												</c:if>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" id="supplierNameInput"
											value="${itemDetail.supplierName}" placeholder="공급처명을 입력하세요."
											autocomplete="off"
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />

										<div id="supplierAutoCompleteBox"
											style="display: none; border: 1px solid #d1d5db; background: #fff; margin-top: 4px;"></div>

										<div id="supplierSelectedText"
											style="font-size: 12px; margin-top: 4px; color: #6b7280;">
											<c:choose>
												<c:when test="${not empty itemDetail.supplierId}">
													선택된 공급처 ID: ${itemDetail.supplierId}
												</c:when>
												<c:otherwise>
													자동완성 목록에서 공급처를 선택하세요.
												</c:otherwise>
											</c:choose>
										</div>
									</div></td>

								<th>납품처</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty itemDetail.deliveryClientName}">
												${itemDetail.deliveryClientName}
												<c:if test="${not empty itemDetail.clientId}">
													(ID: ${itemDetail.clientId})
												</c:if>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" id="deliveryClientNameInput"
											value="${itemDetail.deliveryClientName}"
											placeholder="납품처명을 입력하세요." autocomplete="off"
											style="width: 100%; max-width: 100%; box-sizing: border-box;" />

										<div id="deliveryClientAutoCompleteBox"
											style="display: none; border: 1px solid #d1d5db; background: #fff; margin-top: 4px;"></div>

										<div id="deliveryClientSelectedText"
											style="font-size: 12px; margin-top: 4px; color: #6b7280;">
											<c:choose>
												<c:when test="${not empty itemDetail.clientId}">
													선택된 납품처 ID: ${itemDetail.clientId}
												</c:when>
												<c:otherwise>
													납품처가 필요하면 자동완성 목록에서 선택하세요.
												</c:otherwise>
											</c:choose>
										</div>
									</div></td>
							</tr>
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
										<c:when test="${not empty itemDetail.createdDate}">
											<fmt:formatDate value="${itemDetail.createdDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>수정일</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.updatedDate}">
											<fmt:formatDate value="${itemDetail.updatedDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>상태</th>
								<td><c:choose>
										<c:when test="${itemDetail.useYn == 'Y'}">
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

		</c:when>


		<c:otherwise>

			<div class="detail_card">
				<div class="detail_card_title">조회 결과</div>

				<div class="detail_content_area">
					<div class="detail_empty_box">조회된 품목 상세정보가 없습니다.</div>
				</div>
			</div>

		</c:otherwise>

	</c:choose>

</div>


<script>
	var contextPath = "${contextPath}";

	document.addEventListener("DOMContentLoaded", function() {
		initItemUnitEdit();

		bindClientAutoComplete(
			"supplierNameInput",
			"supplierId",
			"supplierAutoCompleteBox",
			"supplierSelectedText",
			"SUP"
		);

		bindClientAutoComplete(
			"deliveryClientNameInput",
			"clientId",
			"deliveryClientAutoCompleteBox",
			"deliveryClientSelectedText",
			"CUS"
		);
	});


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

			initItemUnitEdit();

			var itemName = document.getElementById("itemName");

			if (itemName != null) {
				itemName.focus();
			}
		} else {
			location.reload();
		}
	}


	function initItemUnitEdit() {
		var itemUnit = document.getElementById("itemUnit");
		var itemUnitSelect = document.getElementById("itemUnitSelect");
		var itemUnitDirect = document.getElementById("itemUnitDirect");

		if (itemUnit == null || itemUnitSelect == null || itemUnitDirect == null) {
			return;
		}

		var unit = itemUnit.value;

		if (unit == null) {
			unit = "";
		}

		unit = unit.trim().toUpperCase();

		var exists = false;

		for (var i = 0; i < itemUnitSelect.options.length; i++) {
			if (itemUnitSelect.options[i].value === unit) {
				exists = true;
				break;
			}
		}

		if (exists) {
			itemUnitSelect.value = unit;
			itemUnitDirect.style.display = "none";
			itemUnitDirect.value = "";
			itemUnit.value = unit;
		} else if (unit !== "") {
			itemUnitSelect.value = "DIRECT";
			itemUnitDirect.style.display = "block";
			itemUnitDirect.value = unit;
			itemUnit.value = unit;
		} else {
			itemUnitSelect.value = "";
			itemUnitDirect.style.display = "none";
			itemUnitDirect.value = "";
			itemUnit.value = "";
		}
	}


	function changeItemUnitOption() {
		var itemUnitSelect = document.getElementById("itemUnitSelect");
		var itemUnitDirect = document.getElementById("itemUnitDirect");
		var itemUnit = document.getElementById("itemUnit");

		if (itemUnitSelect.value === "DIRECT") {
			itemUnitDirect.style.display = "block";
			itemUnitDirect.value = "";
			itemUnit.value = "";
			itemUnitDirect.focus();
		} else {
			itemUnitDirect.style.display = "none";
			itemUnitDirect.value = "";
			itemUnit.value = itemUnitSelect.value;
		}
	}


	function syncDirectItemUnit() {
		var itemUnitDirect = document.getElementById("itemUnitDirect");
		var itemUnit = document.getElementById("itemUnit");

		itemUnit.value = itemUnitDirect.value.trim().toUpperCase();
	}


	function bindClientAutoComplete(inputId, hiddenId, boxId, selectedTextId, clientType) {
		var input = document.getElementById(inputId);
		var hidden = document.getElementById(hiddenId);
		var box = document.getElementById(boxId);
		var selectedText = document.getElementById(selectedTextId);

		if (input == null || hidden == null || box == null) {
			return;
		}

		input.addEventListener("input", function() {
			var keyword = input.value.trim();

			hidden.value = "";

			if (selectedText != null) {
				selectedText.innerText = "자동완성 목록에서 거래처를 선택하세요.";
			}

			if (keyword.length < 1) {
				box.style.display = "none";
				box.innerHTML = "";
				return;
			}

			fetch(contextPath + "/master/item/clientAutoComplete?clientType="
					+ encodeURIComponent(clientType)
					+ "&keyword="
					+ encodeURIComponent(keyword))
				.then(function(response) {
					return response.json();
				})
				.then(function(clientList) {
					renderClientAutoCompleteList(clientList, input, hidden, box, selectedText, clientType);
				})
				.catch(function() {
					box.style.display = "none";
					box.innerHTML = "";
				});
		});
	}


	function renderClientAutoCompleteList(clientList, input, hidden, box, selectedText, clientType) {
		box.innerHTML = "";

		if (clientList == null || clientList.length === 0) {
			box.style.display = "none";
			return;
		}

		for (var i = 0; i < clientList.length; i++) {
			(function(client) {
				var clientId = client.clientId;
				var clientName = client.clientName;
				var clientCode = client.clientCode;

				var item = document.createElement("div");

				item.style.padding = "7px 8px";
				item.style.cursor = "pointer";
				item.style.borderBottom = "1px solid #e5e7eb";
				item.style.fontSize = "13px";

				var label = "";

				if (clientCode != null && clientCode !== "") {
					label += "[" + clientCode + "] ";
				}

				label += clientName;

				if (clientId != null && clientId !== "") {
					label += " / ID: " + clientId;
				}

				item.innerText = label;

				item.addEventListener("mouseover", function() {
					item.style.backgroundColor = "#f3f4f6";
				});

				item.addEventListener("mouseout", function() {
					item.style.backgroundColor = "#ffffff";
				});

				item.addEventListener("click", function() {
					input.value = clientName;
					hidden.value = clientId;

					if (selectedText != null) {
						if (clientType === "SUP") {
							selectedText.innerText = "선택된 공급처 ID: " + clientId;
						} else {
							selectedText.innerText = "선택된 납품처 ID: " + clientId;
						}
					}

					box.style.display = "none";
					box.innerHTML = "";
				});

				box.appendChild(item);
			})(clientList[i]);
		}

		box.style.display = "block";
	}


	function submitItemModifyForm() {
		var itemName = document.getElementById("itemName").value.trim();
		var itemType = document.getElementById("itemType").value.trim();
		var itemUnit = document.getElementById("itemUnit").value.trim();
		var itemUnitSelect = document.getElementById("itemUnitSelect");
		var itemUnitDirect = document.getElementById("itemUnitDirect");

		var supplierNameInput = document.getElementById("supplierNameInput");
		var supplierId = document.getElementById("supplierId");

		var deliveryClientNameInput = document.getElementById("deliveryClientNameInput");
		var clientId = document.getElementById("clientId");

		if (itemName === "") {
			alert("품목명을 입력하세요.");
			document.getElementById("itemName").focus();
			return false;
		}

		if (itemType === "") {
			alert("품목구분을 선택하세요.");
			document.getElementById("itemType").focus();
			return false;
		}

		if (itemUnitSelect.value === "DIRECT") {
			syncDirectItemUnit();
			itemUnit = document.getElementById("itemUnit").value.trim();

			if (itemUnit === "") {
				alert("단위를 직접 입력하세요.");
				itemUnitDirect.focus();
				return false;
			}
		}

		if (itemUnit === "") {
			alert("단위를 선택하거나 직접 입력하세요.");
			itemUnitSelect.focus();
			return false;
		}

		if (supplierNameInput.value.trim() !== "" && supplierId.value.trim() === "") {
			alert("공급처는 자동완성 목록에서 선택하세요.");
			supplierNameInput.focus();
			return false;
		}

		if (itemType === "FG" && deliveryClientNameInput.value.trim() !== "" && clientId.value.trim() === "") {
			alert("납품처는 자동완성 목록에서 선택하세요.");
			deliveryClientNameInput.focus();
			return false;
		}

		var selectList = document.querySelectorAll("[data-edit-select-control]");

		for (var i = 0; i < selectList.length; i++) {
			selectList[i].disabled = false;
		}

		return confirm("품목 정보를 수정하시겠습니까?");
	}
</script>