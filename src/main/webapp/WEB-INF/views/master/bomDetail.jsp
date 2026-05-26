<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M12 20h9"></path>
                        <path
							d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
                    </svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="bomModifyForm" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
                        <path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                        <path d="M17 21v-8H7v8"></path>
                        <path d="M7 3v5h8"></path>
                    </svg>
					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="location.reload();" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M18 6L6 18"></path>
                        <path d="M6 6l12 12"></path>
                    </svg>
					취소
				</button>
			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/master/bom'">
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
		<c:when test="${not empty bomDetail}">

			<form id="bomModifyForm"
				action="${contextPath}/master/bom/detail/modify" method="post"
				accept-charset="UTF-8" onsubmit="return validateBomModifyForm();">
				<input type="hidden" name="bomId" value="${bomDetail.bomId}">
				<input type="hidden" name="itemId" value="${bomDetail.itemId}">

				<div class="detail_card">
					<div class="detail_card_title">BOM 기본 정보</div>

					<table class="detail_info_table">
						<tbody>
							<tr>
								<th>BOM ID</th>
								<td>${bomDetail.bomId}</td>

								<th>BOM코드</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty bomDetail.bomCode}">${bomDetail.bomCode}</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>
									<div data-edit-box style="display: none;">
										<input type="text" name="bomCode" id="bomCode"
											class="detail_input" value="${bomDetail.bomCode}"
											maxlength="80" data-edit-control disabled required>
									</div></td>

								<th>버전</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty bomDetail.version}">V${bomDetail.version}</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>
									<div data-edit-box style="display: none;">
										<input type="number" name="version" id="version"
											class="detail_input" value="${bomDetail.version}" min="1"
											data-edit-control disabled required>
									</div></td>
							</tr>

							<tr>
								<th>완제품코드</th>
								<td title="${bomDetail.itemCode}"><c:choose>
										<c:when test="${not empty bomDetail.itemCode}">${bomDetail.itemCode}</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>완제품명</th>
								<td title="${bomDetail.itemName}"><c:choose>
										<c:when test="${not empty bomDetail.itemName}">${bomDetail.itemName}</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>품목구분</th>
								<td><c:choose>
										<c:when test="${not empty bomDetail.itemTypeName}">${bomDetail.itemTypeName}</c:when>
										<c:when test="${not empty bomDetail.itemType}">${bomDetail.itemType}</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>단위</th>
								<td><c:choose>
										<c:when test="${not empty bomDetail.itemUnit}">${bomDetail.itemUnit}</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>구성품수</th>
								<td><c:choose>
										<c:when test="${not empty bomDetail.detailCount}">${bomDetail.detailCount}</c:when>
										<c:otherwise>0</c:otherwise>
									</c:choose></td>

								<th>사용여부</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${bomDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">사용</span>
											</c:when>
											<c:when test="${bomDetail.useYn == 'N'}">
												<span class="detail_status_badge detail_status_fail">미사용</span>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<select name="useYn" class="detail_select" data-edit-control
											disabled>
											<option value="Y"
												<c:if test="${bomDetail.useYn == 'Y'}">selected</c:if>>사용</option>
											<option value="N"
												<c:if test="${bomDetail.useYn == 'N'}">selected</c:if>>미사용</option>
										</select>
									</div></td>
							</tr>

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

								<th>비고</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty bomDetail.remark}">${bomDetail.remark}</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>
									<div data-edit-box style="display: none;">
										<input type="text" name="remark" class="detail_input"
											value="${bomDetail.remark}" maxlength="30" data-edit-control
											disabled>
									</div></td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="detail_card">
					<div class="bom-detail-title-row">
						<div class="detail_card_title">BOM 구성품 목록</div>

						<div class="bom-detail-action-area">
							<button type="button" id="addDetailRowBtn"
								class="search-btn search-btn-main" onclick="addBomDetailRow();"
								style="display: none;">구성품 추가</button>
							<button type="button" class="search-btn search-btn-sub"
								onclick="submitBomDetailDeleteForm();">선택 삭제</button>
						</div>
					</div>

					<div class="coTableWrap">
						<table class="coTable" id="bomDetailTable">
							<colgroup>
								<col class="coColXs">
								<col class="coColSm">
								<col class="coColXl">
								<col class="coColXl">
								<col class="coColSm">
								<col class="coColMd">
								<col class="coColMd">
								<col class="coColSm">
							</colgroup>

							<thead>
								<tr>
									<th class="mobile_show"
										onclick="toggleAllDetailCheckByTitle();" title="전체 선택/해제">선택</th>
									<th class="mobile_hidden">상세ID</th>
									<th class="mobile_show">구성품코드</th>
									<th class="mobile_show">구성품명</th>
									<th class="mobile_hidden">구분</th>
									<th class="mobile_show">소요량</th>
									<th class="mobile_hidden">비고</th>
									<th class="mobile_hidden">등록일</th>
								</tr>
							</thead>

							<tbody id="bomDetailTbody">
								<c:choose>
									<c:when test="${not empty bomDetailList}">
										<c:forEach var="detail" items="${bomDetailList}"
											varStatus="status">
											<fmt:formatNumber var="qtyText" value="${detail.qty}"
												pattern="#,##0.####" />

											<tr class="bom-click-row" data-item-id="${detail.itemId}"
												onclick="goBomComponentDetail(this, event);"
												title="클릭하면 구성품 상세 페이지로 이동합니다.">
												<td class="mobile_show"><input type="checkbox"
													name="bomDetailIdList" value="${detail.bomDetailId}"
													form="bomDetailDeleteForm"></td>

												<td class="mobile_hidden">${detail.bomDetailId}</td>

												<td class="mobile_show coTextLeft"
													title="${detail.itemCode}"><span data-view-value>
														<c:choose>
															<c:when test="${not empty detail.itemCode}">${detail.itemCode}</c:when>
															<c:otherwise>-</c:otherwise>
														</c:choose>
												</span>

													<div data-edit-box class="autocomplete-wrap"
														style="display: none;">
														<input type="text" id="materialInput_${status.index}"
															class="detail_input material-item-input"
															value="${detail.itemName} (${detail.itemCode})"
															autocomplete="off"
															data-input-id="materialInput_${status.index}"
															data-hidden-id="detailItemId_${status.index}"
															data-list-id="materialList_${status.index}"
															data-unit-id="detailUnit_${status.index}"
															data-edit-control disabled> <input type="hidden"
															name="detailItemIds" id="detailItemId_${status.index}"
															value="${detail.itemId}">
														<div id="materialList_${status.index}"
															class="detail_auto_box"></div>
													</div></td>

												<td class="mobile_show coTextLeft"
													title="${detail.itemName}"><span data-view-value>
														<c:choose>
															<c:when test="${not empty detail.itemName}">${detail.itemName}</c:when>
															<c:otherwise>-</c:otherwise>
														</c:choose>
												</span> <span data-edit-box style="display: none;">자동완성 목록에서
														선택</span></td>

												<td class="mobile_hidden"><c:choose>
														<c:when test="${not empty detail.itemTypeName}">${detail.itemTypeName}</c:when>
														<c:when test="${not empty detail.itemType}">${detail.itemType}</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

												<td class="mobile_show"><span data-view-value> <fmt:formatNumber
															value="${detail.qty}" pattern="#,##0.####" /> <c:if
															test="${not empty detail.itemUnit}"> ${detail.itemUnit}</c:if>
												</span>

													<div data-edit-box class="bom-detail-qty-box"
														style="display: none;">
														<input type="text" class="detail_input qtyDisplayInput"
															value="${qtyText}" inputmode="decimal" autocomplete="off"
															oninput="handleQtyInput(this);" data-edit-control
															disabled> <input type="hidden" name="detailQtys"
															class="qtyValueInput" value="${detail.qty}"> <span
															id="detailUnit_${status.index}"
															class="bom-detail-unit-text"> <c:choose>
																<c:when test="${not empty detail.itemUnit}">${detail.itemUnit}</c:when>
																<c:otherwise>단위</c:otherwise>
															</c:choose>
														</span>
													</div></td>

												<td class="mobile_hidden" title="${detail.remark}"><span
													data-view-value> <c:choose>
															<c:when test="${not empty detail.remark}">${detail.remark}</c:when>
															<c:otherwise>-</c:otherwise>
														</c:choose>
												</span>

													<div data-edit-box style="display: none;">
														<input type="text" name="detailRemarks"
															class="detail_input" value="${detail.remark}"
															maxlength="30" data-edit-control disabled>
													</div></td>

												<td class="mobile_hidden"><c:choose>
														<c:when test="${not empty detail.createdDate}">
															<fmt:formatDate value="${detail.createdDate}"
																pattern="yyyy-MM-dd" />
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose></td>

											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr id="emptyBomDetailRow">
											<td colspan="8" style="text-align: center;">등록된 BOM 구성품이
												없습니다.</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>

					<p class="detail_help_text">수정 모드에서 구성품을 추가한 뒤 저장하면 현재 화면의 구성품
						목록으로 다시 저장됩니다.</p>
				</div>
			</form>

			<form id="bomDetailDeleteForm" method="post"
				action="${contextPath}/master/bom/detail/delete">
				<input type="hidden" name="bomId" value="${bomDetail.bomId}">
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
.autocomplete-wrap {
	position: relative;
	min-width: 0;
}

.autocomplete-wrap .detail_auto_box {
	display: none;
	position: absolute;
	left: 0;
	right: 0;
	top: 100%;
	z-index: 3000;
}

.bom-detail-title-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 12px;
	margin-bottom: 12px;
	width: 100%;
	box-sizing: border-box;
}

.bom-detail-title-row .detail_card_title {
	margin-bottom: 0;
}

.bom-detail-action-area {
	display: flex;
	justify-content: flex-end;
	align-items: center;
	gap: 8px;
	flex-shrink: 0;
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

#bomDetailTbody tr[data-item-id],
#bomDetailTbody tr[data-item-id] td {
    cursor: pointer;
}
</style>

<script>
var bomDetailContextPath = "${contextPath}";
var materialAutoTimerMap = {};
var bomDetailRowSeq = 1000;

function changeEditMode(isEdit) {
    if (!isEdit) {
        location.reload();
        return;
    }

    setDisplay("editBtn", "none");
    setDisplay("saveBtn", "inline-flex");
    setDisplay("cancelBtn", "inline-flex");
    setDisplay("addDetailRowBtn", "inline-flex");

    document.querySelectorAll("[data-view-value]").forEach(function(el) {
        el.style.display = "none";
    });

    document.querySelectorAll("[data-edit-box]").forEach(function(el) {
        if (el.classList.contains("bom-detail-qty-box")) {
            el.style.display = "flex";
        } else {
            el.style.display = "block";
        }
    });

    document.querySelectorAll("[data-edit-control]").forEach(function(el) {
        el.disabled = false;
    });
}

function toggleAllDetailCheckByTitle() {
    var list = document.querySelectorAll("#bomDetailTable input[name='bomDetailIdList']");

    if (list.length === 0) {
        return;
    }

    var allChecked = true;

    list.forEach(function(chk) {
        if (!chk.checked) {
            allChecked = false;
        }
    });

    list.forEach(function(chk) {
        chk.checked = !allChecked;
    });
}

function submitBomDetailDeleteForm() {
    var checked = document.querySelectorAll("#bomDetailTable input[name='bomDetailIdList']:checked");

    if (checked.length === 0) {
        alert("삭제할 구성품을 선택하세요.");
        return;
    }

    if (confirm("선택한 구성품을 삭제하시겠습니까?")) {
        document.getElementById("bomDetailDeleteForm").submit();
    }
}

function goBomComponentDetail(row, event) {
    var saveBtn = document.getElementById("saveBtn");

    if (saveBtn != null && saveBtn.style.display !== "none") {
        return;
    }

    if (event != null) {
        var blockedTarget = event.target.closest("input, button, select, textarea, a, .autocomplete-wrap, .detail_auto_box, .detail_auto_item");

        if (blockedTarget != null) {
            return;
        }
    }

    if (row == null) {
        return;
    }

    var itemId = row.getAttribute("data-item-id");

    if (itemId == null || itemId === "") {
        return;
    }

    location.href = bomDetailContextPath + "/master/item/detail?itemId=" + encodeURIComponent(itemId);
}

function addBomDetailRow() {
    var tbody = document.getElementById("bomDetailTbody");

    if (tbody == null) {
        return;
    }

    var emptyRow = document.getElementById("emptyBomDetailRow");

    if (emptyRow != null) {
        emptyRow.remove();
    }

    var idx = bomDetailRowSeq++;
    var tr = document.createElement("tr");

    tr.className = "bom-detail-row";

    tr.innerHTML = ""
        + "<td class='mobile_show'>-</td>"
        + "<td class='mobile_hidden'>신규</td>"
        + "<td class='mobile_show coTextLeft'>"
        + "  <div data-edit-box class='autocomplete-wrap' style='display:block;'>"
        + "    <input type='text' id='materialInput_" + idx + "' class='detail_input material-item-input' placeholder='자재명 또는 자재코드' autocomplete='off' data-input-id='materialInput_" + idx + "' data-hidden-id='detailItemId_" + idx + "' data-list-id='materialList_" + idx + "' data-unit-id='detailUnit_" + idx + "' data-edit-control required>"
        + "    <input type='hidden' name='detailItemIds' id='detailItemId_" + idx + "'>"
        + "    <div id='materialList_" + idx + "' class='detail_auto_box'></div>"
        + "  </div>"
        + "</td>"
        + "<td class='mobile_show coTextLeft'>자동완성 목록에서 선택</td>"
        + "<td class='mobile_hidden'>-</td>"
        + "<td class='mobile_show'>"
        + "  <div data-edit-box class='bom-detail-qty-box' style='display:flex;'>"
        + "    <input type='text' class='detail_input qtyDisplayInput' inputmode='decimal' autocomplete='off' oninput='handleQtyInput(this);' data-edit-control required>"
        + "    <input type='hidden' name='detailQtys' class='qtyValueInput'>"
        + "    <span id='detailUnit_" + idx + "' class='bom-detail-unit-text'>단위</span>"
        + "  </div>"
        + "</td>"
        + "<td class='mobile_hidden'>"
        + "  <div data-edit-box style='display:block;'>"
        + "    <input type='text' name='detailRemarks' class='detail_input' maxlength='30' data-edit-control>"
        + "  </div>"
        + "</td>"
        + "<td class='mobile_hidden'>-</td>";

    tbody.appendChild(tr);
    bindMaterialAutoCompleteForRow(tr);

    var input = document.getElementById("materialInput_" + idx);

    if (input != null) {
        input.focus();
    }
}

function bindMaterialAutoCompleteForRow(row) {
    var input = row.querySelector(".material-item-input");

    if (input == null) {
        return;
    }

    input.addEventListener("input", function() {
        var inputId = this.dataset.inputId;
        var hiddenId = this.dataset.hiddenId;
        var listId = this.dataset.listId;
        var unitId = this.dataset.unitId;
        var keyword = this.value.trim();

        setValueById(hiddenId, "");
        setTextById(unitId, "단위");

        clearTimeout(materialAutoTimerMap[inputId]);

        materialAutoTimerMap[inputId] = setTimeout(function() {
            searchMaterialItemAutoComplete(keyword, inputId, hiddenId, listId, unitId);
        }, 300);
    });
}

function searchMaterialItemAutoComplete(keyword, inputId, hiddenId, listId, unitId) {
    var listBox = document.getElementById(listId);

    if (listBox == null) {
        return;
    }

    if (keyword.length < 1) {
        listBox.style.display = "none";
        listBox.innerHTML = "";
        return;
    }

    fetch(bomDetailContextPath + "/master/bom/materialAutoComplete?keyword=" + encodeURIComponent(keyword))
        .then(function(response) {
            return response.json();
        })
        .then(function(itemList) {
            listBox.innerHTML = "";

            if (itemList == null || itemList.length === 0) {
                listBox.style.display = "none";
                return;
            }

            itemList.forEach(function(item) {
                var div = document.createElement("div");

                div.className = "detail_auto_item";
                div.textContent = item.itemName + " (" + item.itemCode + " / " + item.itemType + " / ID " + item.itemId + ")";

                div.onclick = function() {
                    setValueById(inputId, item.itemName + " (" + item.itemCode + ")");
                    setValueById(hiddenId, item.itemId);
                    setTextById(unitId, item.itemUnit || "단위");

                    listBox.style.display = "none";
                    listBox.innerHTML = "";
                };

                listBox.appendChild(div);
            });

            listBox.style.display = "block";
        })
        .catch(function() {
            listBox.style.display = "none";
            listBox.innerHTML = "";
        });
}

function handleQtyInput(input) {
    var raw = normalizeQtyValue(input.value);

    input.value = formatQtyWithComma(raw);

    var row = input.closest(".bom-detail-row");

    if (row == null) {
        return;
    }

    var hidden = row.querySelector(".qtyValueInput");

    if (hidden != null) {
        hidden.value = raw;
    }
}

function normalizeQtyValue(value) {
    var raw = (value || "").replace(/,/g, "").replace(/[^\d.]/g, "");
    var parts = raw.split(".");

    if (parts.length > 1) {
        raw = parts[0] + "." + parts.slice(1).join("");
    }

    return raw;
}

function formatQtyWithComma(raw) {
    if (raw == null || raw === "") {
        return "";
    }

    var hasDot = raw.indexOf(".") > -1;
    var parts = raw.split(".");
    var intPart = parts[0].replace(/^0+(?=\d)/, "") || "0";
    var result = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    if (hasDot) {
        return result + "." + (parts[1] || "");
    }

    return result;
}

function validateBomModifyForm() {
    var bomCode = document.getElementById("bomCode");
    var version = document.getElementById("version");
    var itemList = document.querySelectorAll("#bomModifyForm input[name='detailItemIds']");
    var qtyList = document.querySelectorAll("#bomModifyForm input[name='detailQtys']");
    var qtyDisplayList = document.querySelectorAll("#bomModifyForm .qtyDisplayInput");
    var itemMap = {};

    if (bomCode == null || bomCode.value.trim() === "") {
        alert("BOM코드를 입력하세요.");

        if (bomCode != null) {
            bomCode.focus();
        }

        return false;
    }

    if (version == null || version.value === "" || Number(version.value) <= 0) {
        alert("BOM 버전은 1 이상이어야 합니다.");

        if (version != null) {
            version.focus();
        }

        return false;
    }

    if (itemList.length === 0) {
        alert("BOM 구성품을 1개 이상 등록하세요.");
        return false;
    }

    for (var i = 0; i < itemList.length; i++) {
        if (qtyDisplayList[i] != null) {
            handleQtyInput(qtyDisplayList[i]);
        }

        var itemId = itemList[i].value;
        var qty = qtyList[i] == null ? "" : qtyList[i].value;

        if (itemId === "") {
            alert("구성품은 자동완성 목록에서 선택해야 합니다.");
            return false;
        }

        if (qty === "" || Number(qty) <= 0 || isNaN(Number(qty))) {
            alert("구성품 소요량은 0보다 커야 합니다.");

            if (qtyDisplayList[i] != null) {
                qtyDisplayList[i].focus();
            }

            return false;
        }

        if (itemMap[itemId]) {
            alert("같은 구성품이 중복되었습니다.");
            return false;
        }

        itemMap[itemId] = true;
    }

    return confirm("BOM 정보를 저장하시겠습니까?");
}

function setValueById(id, value) {
    var el = document.getElementById(id);

    if (el != null) {
        el.value = value;
    }
}

function setTextById(id, value) {
    var el = document.getElementById(id);

    if (el != null) {
        el.innerText = value;
    }
}

function setDisplay(id, value) {
    var el = document.getElementById(id);

    if (el != null) {
        el.style.display = value;
    }
}

document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll("#bomDetailTbody .bom-detail-row").forEach(function(row) {
        bindMaterialAutoCompleteForRow(row);
    });

    document.addEventListener("click", function(event) {
        if (event.target.closest(".autocomplete-wrap") != null) {
            return;
        }

        document.querySelectorAll(".detail_auto_box").forEach(function(box) {
            box.style.display = "none";
        });
    });
});
</script>