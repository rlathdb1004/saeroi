<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--
    파일명: bom.jsp
    메뉴: 기준정보관리 > BOM관리

    기준:
    - 품목관리 item.jsp 구조 기준
    - 등록 버튼 클릭 시 BOM 등록 모달 열림
    - 선택 컬럼명 클릭 시 현재 목록 체크박스 전체선택/해제
    - 선택삭제는 bomIdList 전달
    - 등록 시 detailItemIds, detailQtys, detailRemarks 배열 전달
    - 소요량은 화면에서 천단위 콤마 표시
    - 소요량 옆 단위는 자재/부자재 선택 시 자동 표시
    - 서버 전송용 소요량은 hidden detailQtys로 숫자만 전송
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
         1. 검색 영역
         ========================================================= --%>
	<div class="search-box">
		<form class="search-form" method="get"
			action="${contextPath}/master/bom">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="searchType" class="search-select">
						<option value="">선택</option>

						<option value="bomCode"
							<c:if test="${bomDTO.searchType == 'bomCode'}">selected</c:if>>
							BOM코드
						</option>

						<option value="itemCode"
							<c:if test="${bomDTO.searchType == 'itemCode'}">selected</c:if>>
							완제품코드
						</option>

						<option value="itemName"
							<c:if test="${bomDTO.searchType == 'itemName'}">selected</c:if>>
							완제품명
						</option>

						<option value="useYn"
							<c:if test="${bomDTO.searchType == 'useYn'}">selected</c:if>>
							사용여부
						</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text" name="searchKeyword" class="search-input"
						value="${bomDTO.searchKeyword}" placeholder="내용을 입력하세요." />
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none">
							<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor"
								stroke-width="2"></circle>
							<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path>
						</svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${contextPath}/master/bom'">
						<svg viewBox="0 0 24 24" fill="none">
							<path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"></path>
							<path d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round"></path>
						</svg>
						초기화
					</button>
				</div>

			</div>
		</form>
	</div>


	<%-- =========================================================
         2. 처리 메시지
         ========================================================= --%>
	<c:if test="${not empty msg}">
		<script>
			alert("${msg}");
		</script>
	</c:if>


	<%-- =========================================================
         3. 총 건수 / 버튼 영역
         ========================================================= --%>
	<div class="search-table-top">

		<div class="search-total-area">
			총 <strong>${bomCount}</strong>건
		</div>

		<div class="search-btn-right">
			<button type="button" class="search-btn search-btn-main"
				onclick="openBomModal();">등록</button>

			<button type="button"
				class="search-btn search-btn-sub pc-only-delete-btn"
				onclick="submitDeleteForm();">선택 삭제</button>
		</div>
	</div>


	<%-- =========================================================
         4. BOM 목록
         ========================================================= --%>
	<form id="bomDeleteForm" method="post"
		action="${contextPath}/master/bom/delete">

		<div class="coTableWrap">
			<table class="coTable bom-table" id="bomListTable">

				<thead>
					<tr>
						<th class="mobile_show" onclick="toggleAllCheckByTitle();"
							title="전체 선택/해제">선택</th>

						<th class="mobile_show">BOM코드</th>
						<th class="mobile_hidden">완제품코드</th>
						<th class="mobile_show">완제품명</th>
						<th class="mobile_hidden">버전</th>
						<th class="mobile_hidden">구성품수</th>
						<th class="mobile_show">사용여부</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>
						<c:when test="${not empty bomList}">
							<c:forEach var="bom" items="${bomList}">
								<tr>
									<td class="mobile_show">
										<input type="checkbox" name="bomIdList"
											value="${bom.bomId}">
									</td>

									<td class="mobile_show" title="${bom.bomCode}">
										${bom.bomCode}
									</td>

									<td class="mobile_hidden" title="${bom.itemCode}">
										${bom.itemCode}
									</td>

									<td class="mobile_show" title="${bom.itemName}">
										${bom.itemName}
									</td>

									<td class="mobile_hidden">
										V${bom.version}
									</td>

									<td class="mobile_hidden">
										${bom.detailCount}
									</td>

									<td class="mobile_show">
										<c:choose>
											<c:when test="${bom.useYn == 'Y'}">
												<span class="coStatus coStatusUse">사용</span>
											</c:when>
											<c:otherwise>
												<span class="coStatus coStatusStop">미사용</span>
											</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show">
										<a href="${contextPath}/master/bom/detail?bomId=${bom.bomId}"
											class="coDetailBtn">보기</a>
									</td>
								</tr>
							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">
									조회된 BOM 정보가 없습니다.
								</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>

			</table>
		</div>
	</form>


	<%-- =========================================================
         5. 페이징
         ========================================================= --%>
	<c:if test="${not empty pageInfo}">
		<c:set var="pageUrl" value="/master/bom" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. BOM 등록 모달
     ============================================================= --%>
<div id="bomModal" class="modal_wrap" aria-hidden="true">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">BOM 등록</h3>
		</div>

		<form id="bomAddForm" class="modal_form" method="post"
			action="${contextPath}/master/bom/add"
			onsubmit="return validateBomAddForm();">

			<div class="modal_body modal_body_2col">

				<div class="modal_item modal_item_full autocomplete-wrap">
					<label class="modal_label">
						완제품 <span class="modal_required">*</span>
					</label>

					<input type="text" id="productItemInput" class="modal_input"
						placeholder="완제품명 또는 완제품코드를 입력하세요."
						autocomplete="off" required />

					<input type="hidden" name="itemId" id="productItemId" />

					<div id="productItemAutoList" class="autocomplete-list"></div>

					<p id="productItemIdText" class="autocomplete-id-text">
						완제품 ID: 선택 안 됨
					</p>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						BOM코드 <span class="modal_required">*</span>
					</label>

					<div class="bom-code-generate-box">
						<input type="text" name="bomCode" id="bomCode"
							class="modal_input" placeholder="완제품 선택 시 자동생성됩니다."
							readonly required />

						<button type="button"
							class="search-btn search-btn-main bom-code-btn"
							onclick="generateBomCodeAndVersion();">자동생성</button>
					</div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						버전 <span class="modal_required">*</span>
					</label>

					<input type="number" name="version" id="version"
						class="modal_input" value="1" min="1" readonly required />
				</div>

				<div class="modal_item">
					<label class="modal_label">사용여부</label>

					<select name="useYn" class="modal_select">
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				</div>

				<div class="modal_item">
					<label class="modal_label">비고</label>

					<textarea name="remark" class="modal_textarea" maxlength="30"
						placeholder="비고는 30자 이내로 입력하세요."></textarea>
				</div>

				<div class="modal_item modal_item_full">
					<div class="bom-detail-title-row">
						<label class="modal_label">
							BOM 구성품 <span class="modal_required">*</span>
						</label>

						<button type="button" class="search-btn search-btn-sub"
							onclick="addBomDetailRow();">구성품 추가</button>
					</div>

					<div id="bomDetailRowArea" class="bom-detail-row-area"></div>

					<p class="autocomplete-id-text">
						원자재/부자재는 자동완성 목록에서 선택해야 저장됩니다.
					</p>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button" class="modal_btn modal_btn_cancel"
					onclick="closeBomModal();">취소</button>

				<button type="submit" class="modal_btn modal_btn_submit">
					등록
				</button>
			</div>

		</form>
	</div>
</div>


<%-- =============================================================
     7. BOM 화면 전용 최소 스타일
     ============================================================= --%>
<style>
.autocomplete-wrap {
	position: relative;
	min-width: 0;
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

.autocomplete-name {
	display: inline-block;
	margin-right: 6px;
	font-weight: 700;
}

.autocomplete-code {
	color: #6B7280;
	font-size: 12px;
}

.bom-code-generate-box {
	display: flex;
	gap: 8px;
	align-items: center;
	width: 100%;
	box-sizing: border-box;
}

.bom-code-generate-box > input {
	flex: 1 1 auto;
	min-width: 0;
}

.bom-code-btn {
	flex: 0 0 auto;
	white-space: nowrap;
}

.bom-detail-title-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 8px;
	margin-bottom: 8px;
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


<%-- =============================================================
     8. BOM 화면 전용 스크립트
     ============================================================= --%>
<script>
	var contextPath = "${contextPath}";

	var productAutoTimer = null;
	var materialAutoTimerMap = {};
	var bomDetailRowSeq = 0;


	function openBomModal() {
		resetBomAddForm();

		var modal = document.getElementById("bomModal");

		if (modal == null) {
			alert("BOM 등록 모달 영역을 찾을 수 없습니다.");
			return;
		}

		modal.classList.add("modal_is_open");
		modal.setAttribute("aria-hidden", "false");
		document.body.classList.add("modal_body_lock");
	}


	function closeBomModal() {
		var modal = document.getElementById("bomModal");

		if (modal == null) {
			return;
		}

		modal.classList.remove("modal_is_open");
		modal.setAttribute("aria-hidden", "true");

		if (document.querySelectorAll(".modal_wrap.modal_is_open").length === 0) {
			document.body.classList.remove("modal_body_lock");
		}
	}


	function resetBomAddForm() {
		var form = document.getElementById("bomAddForm");

		if (form != null) {
			form.reset();
		}

		setValueById("productItemId", "");
		setValueById("productItemInput", "");
		setTextById("productItemIdText", "완제품 ID: 선택 안 됨");

		var productItemAutoList = document.getElementById("productItemAutoList");

		if (productItemAutoList != null) {
			productItemAutoList.innerHTML = "";
			productItemAutoList.style.display = "none";
		}

		setValueById("bomCode", "");
		setValueById("version", "1");

		var bomDetailRowArea = document.getElementById("bomDetailRowArea");

		if (bomDetailRowArea != null) {
			bomDetailRowArea.innerHTML = "";
		}

		bomDetailRowSeq = 0;
		addBomDetailRow();
	}


	function setValueById(id, value) {
		var element = document.getElementById(id);

		if (element != null) {
			element.value = value;
		}
	}


	function setTextById(id, value) {
		var element = document.getElementById(id);

		if (element != null) {
			element.innerText = value;
		}
	}


	function toggleAllCheckByTitle() {
		var checkboxList = document.querySelectorAll("#bomDeleteForm input[name='bomIdList']");

		if (checkboxList.length === 0) {
			return;
		}

		var allChecked = true;

		for (var i = 0; i < checkboxList.length; i++) {
			if (!checkboxList[i].checked) {
				allChecked = false;
				break;
			}
		}

		var nextChecked = !allChecked;

		for (var j = 0; j < checkboxList.length; j++) {
			checkboxList[j].checked = nextChecked;
		}
	}


	function toggleAllCheck(checkAll) {
		var checkboxList = document.querySelectorAll("#bomDeleteForm input[name='bomIdList']");

		for (var i = 0; i < checkboxList.length; i++) {
			checkboxList[i].checked = checkAll.checked;
		}
	}


	function submitDeleteForm() {
		var checkedItems = document.querySelectorAll("#bomDeleteForm input[name='bomIdList']:checked");

		if (checkedItems.length === 0) {
			alert("삭제할 BOM을 선택하세요.");
			return;
		}

		if (confirm("선택한 BOM을 미사용 처리하시겠습니까?")) {
			document.getElementById("bomDeleteForm").submit();
		}
	}


	function searchProductItemAutoComplete(keyword) {
		var listBox = document.getElementById("productItemAutoList");

		if (listBox == null) {
			return;
		}

		if (keyword == null || keyword.length < 1) {
			listBox.style.display = "none";
			listBox.innerHTML = "";
			return;
		}

		fetch(contextPath + "/master/bom/productAutoComplete?keyword="
				+ encodeURIComponent(keyword))
			.then(function(response) {
				return response.json();
			})
			.then(function(itemList) {
				listBox.innerHTML = "";

				if (itemList == null || itemList.length === 0) {
					listBox.style.display = "none";
					return;
				}

				for (var i = 0; i < itemList.length; i++) {
					var item = itemList[i];

					var div = document.createElement("div");
					div.className = "autocomplete-item";

					var nameSpan = document.createElement("span");
					nameSpan.className = "autocomplete-name";
					nameSpan.textContent = item.itemName;

					var codeSpan = document.createElement("span");
					codeSpan.className = "autocomplete-code";
					codeSpan.textContent = "(" + item.itemCode + " / ID " + item.itemId + ")";

					div.appendChild(nameSpan);
					div.appendChild(codeSpan);

					div.setAttribute("data-item-id", item.itemId);
					div.setAttribute("data-item-code", item.itemCode);
					div.setAttribute("data-item-name", item.itemName);

					div.onclick = function() {
						var selectedId = this.getAttribute("data-item-id");
						var selectedCode = this.getAttribute("data-item-code");
						var selectedName = this.getAttribute("data-item-name");

						setValueById("productItemInput", selectedName + " (" + selectedCode + ")");
						setValueById("productItemId", selectedId);
						setTextById("productItemIdText", "완제품 ID: " + selectedId);

						listBox.style.display = "none";
						listBox.innerHTML = "";

						generateBomCodeAndVersion();
					};

					listBox.appendChild(div);
				}

				listBox.style.display = "block";
			})
			.catch(function() {
				listBox.style.display = "none";
				listBox.innerHTML = "";
			});
	}


	function generateBomCodeAndVersion() {
		var productItemId = document.getElementById("productItemId").value;

		if (productItemId === "") {
			alert("완제품을 자동완성 목록에서 선택하세요.");
			document.getElementById("productItemInput").focus();
			return;
		}

		fetch(contextPath + "/master/bom/nextCode?itemId="
				+ encodeURIComponent(productItemId))
			.then(function(response) {
				return response.text();
			})
			.then(function(nextBomCode) {
				setValueById("bomCode", nextBomCode);
			})
			.catch(function() {
				alert("BOM코드 자동생성 중 오류가 발생했습니다.");
			});

		fetch(contextPath + "/master/bom/nextVersion?itemId="
				+ encodeURIComponent(productItemId))
			.then(function(response) {
				return response.text();
			})
			.then(function(nextVersion) {
				setValueById("version", nextVersion);
			})
			.catch(function() {
				setValueById("version", "1");
			});
	}


	function addBomDetailRow() {
		bomDetailRowSeq++;

		var inputId = "materialItemInput_" + bomDetailRowSeq;
		var hiddenId = "detailItemId_" + bomDetailRowSeq;
		var listId = "materialItemAutoList_" + bomDetailRowSeq;
		var unitId = "materialItemUnit_" + bomDetailRowSeq;

		var rowArea = document.getElementById("bomDetailRowArea");

		if (rowArea == null) {
			return;
		}

		var row = document.createElement("div");
		row.className = "bom-detail-row";

		row.innerHTML =
			'<div class="bom-detail-row-grid">' +

				'<div class="autocomplete-wrap">' +
					'<input type="text" id="' + inputId + '" class="modal_input" ' +
						'placeholder="자재/부자재명 또는 코드를 입력하세요." autocomplete="off" required />' +
					'<input type="hidden" name="detailItemIds" id="' + hiddenId + '" />' +
					'<div id="' + listId + '" class="autocomplete-list"></div>' +
					'<p class="autocomplete-id-text">구성품 ID: 선택 안 됨</p>' +
				'</div>' +

				'<div class="bom-detail-qty-box">' +
					'<input type="text" class="modal_input qtyDisplayInput" ' +
						'placeholder="소요량" inputmode="decimal" autocomplete="off" ' +
						'oninput="handleQtyInput(this);" required />' +
					'<input type="hidden" name="detailQtys" class="qtyValueInput" />' +
					'<span id="' + unitId + '" class="bom-detail-unit-text">단위</span>' +
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

		var materialInput = document.getElementById(inputId);

		if (materialInput != null) {
			materialInput.addEventListener("input", function() {
				var keyword = this.value.trim();

				setValueById(hiddenId, "");

				var unitText = document.getElementById(unitId);

				if (unitText != null) {
					unitText.innerText = "단위";
				}

				var guideText = this.parentNode.querySelector(".autocomplete-id-text");

				if (guideText != null) {
					guideText.innerText = "구성품 ID: 선택 안 됨";
				}

				if (materialAutoTimerMap[inputId] != null) {
					clearTimeout(materialAutoTimerMap[inputId]);
				}

				materialAutoTimerMap[inputId] = setTimeout(function() {
					searchMaterialItemAutoComplete(keyword, inputId, hiddenId, listId, unitId);
				}, 300);
			});
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
			alert("BOM 구성품은 최소 1개 이상 필요합니다.");
			return;
		}

		rowArea.removeChild(row);
	}


	function searchMaterialItemAutoComplete(keyword, inputId, hiddenId, listId, unitId) {
		var listBox = document.getElementById(listId);

		if (listBox == null) {
			return;
		}

		if (keyword == null || keyword.length < 1) {
			listBox.style.display = "none";
			listBox.innerHTML = "";
			return;
		}

		fetch(contextPath + "/master/bom/materialAutoComplete?keyword="
				+ encodeURIComponent(keyword))
			.then(function(response) {
				return response.json();
			})
			.then(function(itemList) {
				listBox.innerHTML = "";

				if (itemList == null || itemList.length === 0) {
					listBox.style.display = "none";
					return;
				}

				for (var i = 0; i < itemList.length; i++) {
					var item = itemList[i];

					var div = document.createElement("div");
					div.className = "autocomplete-item";

					var nameSpan = document.createElement("span");
					nameSpan.className = "autocomplete-name";
					nameSpan.textContent = item.itemName;

					var codeSpan = document.createElement("span");
					codeSpan.className = "autocomplete-code";
					codeSpan.textContent = "(" + item.itemCode + " / " + item.itemType + " / ID " + item.itemId + ")";

					div.appendChild(nameSpan);
					div.appendChild(codeSpan);

					div.setAttribute("data-item-id", item.itemId);
					div.setAttribute("data-item-code", item.itemCode);
					div.setAttribute("data-item-name", item.itemName);
					div.setAttribute("data-item-unit", item.itemUnit);

					div.onclick = function() {
						var selectedId = this.getAttribute("data-item-id");
						var selectedCode = this.getAttribute("data-item-code");
						var selectedName = this.getAttribute("data-item-name");
						var selectedUnit = this.getAttribute("data-item-unit");

						setValueById(inputId, selectedName + " (" + selectedCode + ")");
						setValueById(hiddenId, selectedId);

						var unitText = document.getElementById(unitId);

						if (unitText != null) {
							if (selectedUnit != null && selectedUnit !== "" && selectedUnit !== "null") {
								unitText.innerText = selectedUnit;
							} else {
								unitText.innerText = "단위";
							}
						}

						var input = document.getElementById(inputId);

						if (input != null) {
							var guideText = input.parentNode.querySelector(".autocomplete-id-text");

							if (guideText != null) {
								guideText.innerText = "구성품 ID: " + selectedId;
							}
						}

						listBox.style.display = "none";
						listBox.innerHTML = "";
					};

					listBox.appendChild(div);
				}

				listBox.style.display = "block";
			})
			.catch(function() {
				listBox.style.display = "none";
				listBox.innerHTML = "";
			});
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


	function validateBomAddForm() {
		var productItemId = document.getElementById("productItemId").value;
		var bomCode = document.getElementById("bomCode").value.trim();
		var version = document.getElementById("version").value;
		var detailHiddenList = document.querySelectorAll("#bomAddForm input[name='detailItemIds']");
		var detailQtyValueList = document.querySelectorAll("#bomAddForm input[name='detailQtys']");
		var detailQtyDisplayList = document.querySelectorAll("#bomAddForm .qtyDisplayInput");

		if (productItemId === "") {
			alert("완제품은 자동완성 목록에서 선택해야 합니다.");
			document.getElementById("productItemInput").focus();
			return false;
		}

		if (bomCode === "") {
			alert("BOM코드를 자동생성하세요.");
			document.getElementById("bomCode").focus();
			return false;
		}

		if (version === "" || Number(version) <= 0) {
			alert("BOM 버전은 1 이상이어야 합니다.");
			document.getElementById("version").focus();
			return false;
		}

		if (detailHiddenList.length === 0) {
			alert("BOM 구성품을 1개 이상 추가하세요.");
			return false;
		}

		var selectedItemMap = {};

		for (var i = 0; i < detailHiddenList.length; i++) {
			var itemId = detailHiddenList[i].value;

			if (detailQtyDisplayList[i] != null) {
				handleQtyInput(detailQtyDisplayList[i]);
			}

			var qty = detailQtyValueList[i].value;

			if (itemId === "") {
				alert("구성품은 자동완성 목록에서 선택해야 합니다.");
				return false;
			}

			if (qty === "" || Number(qty) <= 0 || isNaN(Number(qty))) {
				alert("구성품 소요량은 0보다 커야 합니다.");

				if (detailQtyDisplayList[i] != null) {
					detailQtyDisplayList[i].focus();
				}

				return false;
			}

			if (selectedItemMap[itemId] === true) {
				alert("같은 구성품이 중복되었습니다.");
				return false;
			}

			selectedItemMap[itemId] = true;
		}

		return true;
	}


	document.addEventListener("DOMContentLoaded", function() {
		var productInput = document.getElementById("productItemInput");

		if (productInput != null) {
			productInput.addEventListener("input", function() {
				clearTimeout(productAutoTimer);

				var keyword = this.value.trim();

				setValueById("productItemId", "");
				setTextById("productItemIdText", "완제품 ID: 선택 안 됨");
				setValueById("bomCode", "");
				setValueById("version", "1");

				productAutoTimer = setTimeout(function() {
					searchProductItemAutoComplete(keyword);
				}, 300);
			});
		}

		var modal = document.getElementById("bomModal");

		if (modal != null) {
			modal.addEventListener("click", function(event) {
				if (event.target === modal) {
					closeBomModal();
				}
			});
		}

		document.addEventListener("keydown", function(event) {
			if (event.key === "Escape") {
				closeBomModal();
			}
		});

		document.addEventListener("click", function(event) {
			var isAutoCompleteArea = event.target.closest(".autocomplete-wrap");

			if (isAutoCompleteArea != null) {
				return;
			}

			var listBoxList = document.querySelectorAll(".autocomplete-list");

			for (var i = 0; i < listBoxList.length; i++) {
				listBoxList[i].style.display = "none";
			}
		});
	});
</script>