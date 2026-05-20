<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명 : bom.jsp
	메뉴   : 기준정보관리 > BOM관리

	역할:
	- BOM 마스터 목록을 조회한다.
	- BOM 등록 모달을 제공한다.
	- BOM 선택삭제는 실제 삭제가 아니라 use_yn = 'N' 미사용 처리한다.
	- 상세 버튼 클릭 시 BOM 상세 페이지로 이동한다.

	공용 CSS 기준:
	- 목록/테이블/페이징: content.css
	- 검색 영역/버튼: searchtable.css
	- 등록 모달: modal.css
	- 모바일 대응: mobile.css

	모바일 목록 기준:
	- 총 5개 컬럼만 표시한다.
	- 체크박스 + BOM코드 + 완제품명 + 구성수 + 상세
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${not empty msg}">
	<script>
		alert("${msg}");
	</script>
</c:if>


<div class="coPageWrap">

	<%-- =========================================================
	     1. 검색 영역
	     ========================================================= --%>
	<div class="search-box">
		<form action="${contextPath}/master/bom" method="get" class="search-form">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">검색구분</label>

					<select name="searchType" class="search-select">
						<option value="" <c:if test="${empty bomDTO.searchType}">selected</c:if>>
							전체
						</option>

						<option value="bomCode" <c:if test="${bomDTO.searchType == 'bomCode'}">selected</c:if>>
							BOM코드
						</option>

						<option value="itemCode" <c:if test="${bomDTO.searchType == 'itemCode'}">selected</c:if>>
							완제품코드
						</option>

						<option value="itemName" <c:if test="${bomDTO.searchType == 'itemName'}">selected</c:if>>
							완제품명
						</option>

						<option value="material" <c:if test="${bomDTO.searchType == 'material'}">selected</c:if>>
							구성자재
						</option>

						<option value="useYn" <c:if test="${bomDTO.searchType == 'useYn'}">selected</c:if>>
							사용여부
						</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text"
						   name="searchKeyword"
						   class="search-input"
						   value="${bomDTO.searchKeyword}"
						   placeholder="검색어를 입력하세요. 사용여부는 Y 또는 N" />
				</div>

				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						검색
					</button>

					<button type="button" class="search-btn search-btn-sub"
							onclick="location.href='${contextPath}/master/bom'">
						초기화
					</button>
				</div>

			</div>

		</form>
	</div>


	<%-- =========================================================
	     2. 목록 상단 영역
	     ========================================================= --%>
	<div class="search-table-top">

		<div class="search-total-area">
			총 <strong>${bomCount}</strong>건
		</div>

		<div class="search-btn-right">
			<button type="button" class="search-btn search-btn-main"
					onclick="openBomAddModal();">
				등록
			</button>

			<button type="button" class="search-btn search-btn-sub"
					onclick="submitBomDeleteForm();">
				선택삭제
			</button>
		</div>

	</div>


	<%-- =========================================================
	     3. BOM 목록 테이블
	     ========================================================= --%>
	<form id="bomDeleteForm"
		  action="${contextPath}/master/bom/delete"
		  method="post"
		  accept-charset="UTF-8">

		<div class="coTableWrap">
			<table class="coTable" id="bomListTable">

				<thead>
					<tr>
						<%--
							모바일 표시 컬럼 1: 체크박스
							- 선택삭제 기능을 위해 모바일에서도 표시한다.
						--%>
						<th class="mobile_show">
							<input type="checkbox" id="checkAll" onclick="toggleAllCheck(this);">
						</th>

						<%--
							모바일 표시 컬럼 2: BOM코드
							- BOM을 식별하는 핵심 코드이므로 모바일에서도 표시한다.
						--%>
						<th class="mobile_show">BOM코드</th>

						<%--
							PC 전용 컬럼
							- 완제품코드는 BOM코드와 일부 중복되므로 모바일에서는 숨긴다.
						--%>
						<th class="mobile_hidden">완제품코드</th>

						<%--
							모바일 표시 컬럼 3: 완제품명
							- BOM 대상 품목을 가장 쉽게 확인할 수 있는 핵심 표시값이다.
						--%>
						<th class="mobile_show">완제품명</th>

						<%--
							PC 전용 컬럼
							- 버전은 PC 목록에서는 표시하지만 모바일 5컬럼 기준에서는 제외한다.
						--%>
						<th class="mobile_hidden">버전</th>

						<%--
							모바일 표시 컬럼 4: 구성수
							- BOM에 등록된 자재 개수를 빠르게 확인하기 위한 핵심값이다.
						--%>
						<th class="mobile_show">구성수</th>

						<%--
							PC 전용 컬럼
							- 사용여부는 PC에서는 표시하되 모바일 5컬럼 기준에서는 우선순위가 낮아 숨긴다.
						--%>
						<th class="mobile_hidden">사용여부</th>

						<%--
							모바일 표시 컬럼 5: 상세
							- 상세 이동은 모든 목록 화면에서 반드시 표시한다.
						--%>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty bomList}">
							<c:forEach var="bom" items="${bomList}">
								<tr>
									<%--
										모바일 표시 컬럼 1: 체크박스
										- 선택삭제 기능을 위해 모바일에서도 표시한다.
									--%>
									<td class="mobile_show">
										<input type="checkbox" name="bomIdList" value="${bom.bomId}">
									</td>

									<%--
										모바일 표시 컬럼 2: BOM코드
										- 긴 값은 공용 CSS에서 말줄임 처리된다.
										- title 속성으로 PC에서 전체 값을 확인할 수 있다.
									--%>
									<td class="mobile_show" title="${bom.bomCode}">
										${bom.bomCode}
									</td>

									<%--
										PC 전용 컬럼: 완제품코드
										- 모바일에서는 BOM코드와 정보가 겹치므로 숨긴다.
									--%>
									<td class="mobile_hidden" title="${bom.itemCode}">
										${bom.itemCode}
									</td>

									<%--
										모바일 표시 컬럼 3: 완제품명
										- BOM 대상 품목을 확인하는 핵심 표시값이다.
									--%>
									<td class="mobile_show" title="${bom.itemName}">
										${bom.itemName}
									</td>

									<%--
										PC 전용 컬럼: 버전
										- 모바일에서는 구성수보다 우선순위가 낮아 숨긴다.
									--%>
									<td class="mobile_hidden">
										V${bom.version}
									</td>

									<%--
										모바일 표시 컬럼 4: 구성수
										- BOM 상세 자재 개수를 표시한다.
									--%>
									<td class="mobile_show">
										<c:choose>
											<c:when test="${not empty bom.detailCount}">
												<fmt:formatNumber value="${bom.detailCount}" pattern="#,##0" />개
											</c:when>
											<c:otherwise>0개</c:otherwise>
										</c:choose>
									</td>

									<%--
										PC 전용 컬럼: 사용여부
										- PC에서는 표시하지만 모바일 5컬럼 기준에서는 숨긴다.
									--%>
									<td class="mobile_hidden">
										<c:choose>
											<c:when test="${bom.useYn == 'Y'}">
												<span class="coStatus coStatusUse">
													<c:choose>
														<c:when test="${not empty bom.useYnName}">
															${bom.useYnName}
														</c:when>
														<c:otherwise>사용</c:otherwise>
													</c:choose>
												</span>
											</c:when>

											<c:otherwise>
												<span class="coStatus coStatusStop">
													<c:choose>
														<c:when test="${not empty bom.useYnName}">
															${bom.useYnName}
														</c:when>
														<c:otherwise>미사용</c:otherwise>
													</c:choose>
												</span>
											</c:otherwise>
										</c:choose>
									</td>

									<%--
										모바일 표시 컬럼 5: 상세
										- BOM 상세 화면으로 이동한다.
									--%>
									<td class="mobile_show">
										<a href="${contextPath}/master/bom/detail?bomId=${bom.bomId}"
										   class="coDetailBtn">
											보기
										</a>
									</td>
								</tr>
							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8">
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
	     4. 공용 페이징
	     - 공용 paging.jsp는 수정하지 않는다.
	     - Controller에서 pageInfo/pageUrl을 전달한다.
	     ========================================================= --%>
	<c:if test="${not empty pageInfo}">
		<c:set var="pageUrl" value="/master/bom" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     5. BOM 등록 모달
     ============================================================= --%>
<div id="bomAddModal" class="modal_wrap">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">BOM 등록</h3>
		</div>

		<form action="${contextPath}/master/bom/add"
			  method="post"
			  accept-charset="UTF-8"
			  class="modal_form"
			  onsubmit="return validateBomAddForm();">

			<div class="modal_body modal_body_2col">

				<%--
					완제품 선택
					- BOM은 완제품 1개를 기준으로 구성자재를 관리한다.
					- 완제품은 직접 ID를 입력하지 않고 자동완성 목록에서 선택한다.
				--%>
				<div class="modal_item modal_item_full autocomplete-wrap">
					<label class="modal_label">
						완제품 <span class="modal_required">*</span>
					</label>

					<input type="hidden" name="itemId" id="productItemId" />

					<input type="text"
						   id="productItemKeyword"
						   class="modal_input"
						   placeholder="완제품코드 또는 완제품명을 입력하세요."
						   autocomplete="off"
						   oninput="searchProductItem();" />

					<div id="productItemAutoCompleteBox"></div>

					<p id="productItemSelectedText" class="autocomplete-id-text">
						자동완성 목록에서 완제품을 선택하세요.
					</p>
				</div>

				<%--
					BOM코드
					- 완제품 선택 시 BOM-완제품코드 형태로 자동 입력된다.
					- 예: BOM-FG-GSK-ION5-EPDM-001
				--%>
				<div class="modal_item modal_item_full">
					<label class="modal_label">
						BOM코드 <span class="modal_required">*</span>
					</label>

					<input type="text"
						   name="bomCode"
						   id="bomCode"
						   class="modal_input"
						   placeholder="완제품 선택 시 자동 입력됩니다."
						   readonly
						   required />
				</div>

				<%--
					버전
					- 기본값은 1이다.
					- 이후 설계 변경 시 버전을 올릴 수 있다.
				--%>
				<div class="modal_item">
					<label class="modal_label">
						버전 <span class="modal_required">*</span>
					</label>

					<input type="number"
						   name="version"
						   id="version"
						   class="modal_input"
						   value="1"
						   min="1"
						   required />
				</div>

				<%--
					사용여부
					- 기준정보 등록 시 기본값은 사용(Y)이다.
				--%>
				<div class="modal_item">
					<label class="modal_label">
						사용여부 <span class="modal_required">*</span>
					</label>

					<select name="useYn" id="useYn" class="modal_select" required>
						<option value="Y" selected>사용</option>
						<option value="N">미사용</option>
					</select>
				</div>

				<%--
					비고
					- BOM 마스터에 대한 간단한 설명을 입력한다.
					- 구성자재 상세 비고는 bomDetail.jsp에서 별도로 관리한다.
				--%>
				<div class="modal_item modal_item_full">
					<label class="modal_label">비고</label>

					<textarea name="remark"
							  id="remark"
							  class="modal_textarea"
							  placeholder="비고를 입력하세요."></textarea>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button" class="modal_btn modal_btn_cancel"
						onclick="closeBomAddModal();">
					취소
				</button>

				<button type="submit" class="modal_btn modal_btn_submit">
					등록
				</button>
			</div>

		</form>

	</div>

</div>


<%-- =============================================================
     6. bom.jsp 전용 최소 CSS
     - 공용 CSS에 없는 기능만 작성한다.
     ============================================================= --%>
<style>
/* 완제품 자동완성 input 기준 위치 */
.autocomplete-wrap {
	position: relative;
}

/* 완제품 자동완성 목록 박스 */
#productItemAutoCompleteBox {
	display: none;
	position: absolute;
	left: 0;
	right: 0;
	top: 76px;
	z-index: 30;
	max-height: 190px;
	overflow-y: auto;
	border: 1px solid #D6DEE0;
	border-radius: 8px;
	background-color: #FFFFFF;
	box-shadow: 0 8px 18px rgba(15, 23, 42, 0.12);
	box-sizing: border-box;
}

/* 자동완성 목록 한 줄 */
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

/* 자동완성 선택 후 ID 안내 문구 */
.autocomplete-id-text {
	margin: 4px 0 0 2px;
	color: #6B7280;
	font-size: 12px;
	line-height: 1.4;
}

/* 목록 테이블 컬럼폭 드래그 */
#bomListTable th {
	position: relative;
	user-select: none;
}

/* 컬럼 경계 드래그 핸들 */
.column-resizer {
	position: absolute;
	top: 0;
	right: 0;
	width: 7px;
	height: 100%;
	cursor: col-resize;
	z-index: 5;
}

.column-resizer:hover {
	background-color: rgba(47, 125, 96, 0.18);
}

/* 상세 컬럼은 보기 옆에 말줄임 점이 생기지 않도록 제외 */
#bomListTable th:last-child,
#bomListTable td:last-child {
	text-overflow: clip !important;
}

#bomListTable td:last-child .coDetailBtn {
	max-width: 100%;
	overflow: hidden;
	text-overflow: clip !important;
	white-space: nowrap;
}
</style>


<script>
	var contextPath = "${contextPath}";


	// =========================================================
	// 1. 등록 모달 열기 / 닫기
	// =========================================================

	function openBomAddModal() {
		var modal = document.getElementById("bomAddModal");

		if (modal != null) {
			modal.classList.add("modal_is_open");
			document.body.classList.add("modal_body_lock");
		}
	}


	function closeBomAddModal() {
		var modal = document.getElementById("bomAddModal");

		if (modal != null) {
			modal.classList.remove("modal_is_open");
			document.body.classList.remove("modal_body_lock");
		}

		clearBomAddForm();
	}


	function clearBomAddForm() {
		document.getElementById("productItemId").value = "";
		document.getElementById("productItemKeyword").value = "";
		document.getElementById("bomCode").value = "";
		document.getElementById("version").value = "1";
		document.getElementById("useYn").value = "Y";
		document.getElementById("remark").value = "";

		document.getElementById("productItemSelectedText").innerText =
			"자동완성 목록에서 완제품을 선택하세요.";

		hideProductItemAutoCompleteBox();
	}


	// =========================================================
	// 2. 선택삭제
	// =========================================================

	function toggleAllCheck(checkAll) {
		var checkboxList = document.querySelectorAll("input[name='bomIdList']");

		for (var i = 0; i < checkboxList.length; i++) {
			checkboxList[i].checked = checkAll.checked;
		}
	}


	function submitBomDeleteForm() {
		var checkedList = document.querySelectorAll("input[name='bomIdList']:checked");

		if (checkedList.length === 0) {
			alert("삭제할 BOM을 선택하세요.");
			return;
		}

		if (confirm("선택한 BOM을 미사용 처리하시겠습니까?")) {
			document.getElementById("bomDeleteForm").submit();
		}
	}


	// =========================================================
	// 3. 완제품 자동완성
	// =========================================================

	function searchProductItem() {
		var keywordInput = document.getElementById("productItemKeyword");
		var itemIdInput = document.getElementById("productItemId");
		var selectedText = document.getElementById("productItemSelectedText");

		var keyword = keywordInput.value.trim();

		itemIdInput.value = "";
		document.getElementById("bomCode").value = "";

		selectedText.innerText = "자동완성 목록에서 완제품을 선택하세요.";

		if (keyword.length < 1) {
			hideProductItemAutoCompleteBox();
			return;
		}

		fetch(contextPath + "/master/bom/productAutoComplete?keyword=" + encodeURIComponent(keyword))
			.then(function(response) {
				return response.json();
			})
			.then(function(itemList) {
				renderProductItemAutoComplete(itemList);
			})
			.catch(function() {
				hideProductItemAutoCompleteBox();
			});
	}


	function renderProductItemAutoComplete(itemList) {
		var box = document.getElementById("productItemAutoCompleteBox");

		box.innerHTML = "";

		if (itemList == null || itemList.length === 0) {
			hideProductItemAutoCompleteBox();
			return;
		}

		for (var i = 0; i < itemList.length; i++) {
			(function(item) {
				var itemId = item.itemId;
				var itemCode = item.itemCode;
				var itemName = item.itemName;
				var itemUnit = item.itemUnit;

				var row = document.createElement("div");
				row.className = "autocomplete-item";

				var label = "";

				if (itemCode != null && itemCode !== "") {
					label += "[" + itemCode + "] ";
				}

				label += itemName;

				if (itemUnit != null && itemUnit !== "") {
					label += " / " + itemUnit;
				}

				if (itemId != null && itemId !== "") {
					label += " / ID: " + itemId;
				}

				row.innerText = label;

				row.addEventListener("click", function() {
					selectProductItem(itemId, itemCode, itemName);
				});

				box.appendChild(row);
			})(itemList[i]);
		}

		box.style.display = "block";
	}


	function selectProductItem(itemId, itemCode, itemName) {
		document.getElementById("productItemId").value = itemId;
		document.getElementById("productItemKeyword").value = itemName;
		document.getElementById("bomCode").value = "BOM-" + itemCode;

		document.getElementById("productItemSelectedText").innerText =
			"선택된 완제품 ID: " + itemId + " / " + itemCode;

		hideProductItemAutoCompleteBox();
	}


	function hideProductItemAutoCompleteBox() {
		var box = document.getElementById("productItemAutoCompleteBox");

		if (box != null) {
			box.style.display = "none";
			box.innerHTML = "";
		}
	}


	// =========================================================
	// 4. 등록 검증
	// =========================================================

	function validateBomAddForm() {
		var productItemId = document.getElementById("productItemId").value.trim();
		var bomCode = document.getElementById("bomCode").value.trim();
		var version = document.getElementById("version").value.trim();

		if (productItemId === "") {
			alert("완제품은 자동완성 목록에서 선택하세요.");
			document.getElementById("productItemKeyword").focus();
			return false;
		}

		if (bomCode === "") {
			alert("BOM코드가 생성되지 않았습니다. 완제품을 다시 선택하세요.");
			document.getElementById("productItemKeyword").focus();
			return false;
		}

		if (version === "" || parseInt(version, 10) < 1) {
			alert("버전은 1 이상으로 입력하세요.");
			document.getElementById("version").focus();
			return false;
		}

		return confirm("BOM을 등록하시겠습니까?");
	}


	// =========================================================
	// 5. 목록 테이블 컬럼폭 드래그
	// - 새로고침 시 기본폭으로 복구
	// - 전체 테이블 폭은 화면 밖으로 나가지 않도록 보정
	// =========================================================

	document.addEventListener("DOMContentLoaded", function() {
		initResizableBomTable();
	});


	window.addEventListener("resize", function() {
		var table = document.getElementById("bomListTable");

		if (table == null) {
			return;
		}

		var colList = table.querySelectorAll("colgroup col");

		if (colList.length > 0) {
			fitBomColumnWidthsToTable(table, colList);
		}
	});


	function initResizableBomTable() {
		var table = document.getElementById("bomListTable");

		if (table == null) {
			return;
		}

		createBomColgroupIfNotExists(table);

		var colList = table.querySelectorAll("colgroup col");
		var thList = table.querySelectorAll("thead th");

		if (colList.length === 0 || thList.length === 0) {
			return;
		}

		resetDefaultBomColumnWidths(table, colList);

		for (var index = 0; index < thList.length - 1; index++) {
			addBomColumnResizeHandle(table, colList, thList[index], index);
		}
	}


	function createBomColgroupIfNotExists(table) {
		var existingColgroup = table.querySelector("colgroup");

		if (existingColgroup != null) {
			return;
		}

		var thList = table.querySelectorAll("thead th");

		if (thList.length === 0) {
			return;
		}

		var colgroup = document.createElement("colgroup");

		for (var i = 0; i < thList.length; i++) {
			var col = document.createElement("col");
			colgroup.appendChild(col);
		}

		table.insertBefore(colgroup, table.firstChild);
	}


	function addBomColumnResizeHandle(table, colList, th, index) {
		var resizer = document.createElement("span");
		resizer.className = "column-resizer";

		th.appendChild(resizer);

		var startX = 0;
		var leftStartWidth = 0;
		var rightStartWidth = 0;
		var rightIndex = index + 1;

		resizer.addEventListener("mousedown", function(event) {
			event.preventDefault();
			event.stopPropagation();

			startX = event.pageX;
			leftStartWidth = getBomColWidth(colList[index]);
			rightStartWidth = getBomColWidth(colList[rightIndex]);

			document.addEventListener("mousemove", resizeBomColumnPair);
			document.addEventListener("mouseup", stopResizeBomColumnPair);
		});


		function resizeBomColumnPair(event) {
			var diffX = event.pageX - startX;

			var leftMinWidth = getBomColumnMinWidth(index);
			var rightMinWidth = getBomColumnMinWidth(rightIndex);

			var newLeftWidth = leftStartWidth + diffX;
			var newRightWidth = rightStartWidth - diffX;

			if (newLeftWidth < leftMinWidth) {
				newLeftWidth = leftMinWidth;
				newRightWidth = leftStartWidth + rightStartWidth - newLeftWidth;
			}

			if (newRightWidth < rightMinWidth) {
				newRightWidth = rightMinWidth;
				newLeftWidth = leftStartWidth + rightStartWidth - newRightWidth;
			}

			colList[index].style.width = newLeftWidth + "px";
			colList[rightIndex].style.width = newRightWidth + "px";

			fitBomColumnWidthsToTable(table, colList);
		}


		function stopResizeBomColumnPair() {
			document.removeEventListener("mousemove", resizeBomColumnPair);
			document.removeEventListener("mouseup", stopResizeBomColumnPair);
		}


		resizer.addEventListener("dblclick", function(event) {
			event.preventDefault();
			event.stopPropagation();

			resetDefaultBomColumnWidths(table, colList);
		});
	}


	function resetDefaultBomColumnWidths(table, colList) {
		var defaultWidths = [48, 190, 170, 230, 80, 90, 90, 70];

		for (var i = 0; i < colList.length; i++) {
			if (i < defaultWidths.length) {
				colList[i].style.width = defaultWidths[i] + "px";
			} else {
				colList[i].style.width = "120px";
			}
		}

		fitBomColumnWidthsToTable(table, colList);
	}


	function fitBomColumnWidthsToTable(table, colList) {
		var tableWidth = getBomAvailableTableWidth(table);

		if (tableWidth <= 0) {
			return;
		}

		var totalWidth = 0;

		for (var i = 0; i < colList.length; i++) {
			totalWidth += getBomColWidth(colList[i]);
		}

		if (totalWidth <= 0) {
			return;
		}

		if (totalWidth > tableWidth) {
			var ratio = tableWidth / totalWidth;

			for (var j = 0; j < colList.length; j++) {
				var newWidth = getBomColWidth(colList[j]) * ratio;
				var minWidth = getBomColumnMinWidth(j);

				if (newWidth < minWidth) {
					newWidth = minWidth;
				}

				colList[j].style.width = newWidth + "px";
			}
		}

		var adjustedTotal = 0;

		for (var k = 0; k < colList.length; k++) {
			adjustedTotal += getBomColWidth(colList[k]);
		}

		if (adjustedTotal > tableWidth) {
			var overWidth = adjustedTotal - tableWidth;

			for (var x = colList.length - 1; x >= 0; x--) {
				var currentWidth = getBomColWidth(colList[x]);
				var min = getBomColumnAbsoluteMinWidth(x);
				var reducible = currentWidth - min;

				if (reducible <= 0) {
					continue;
				}

				var reduce = Math.min(reducible, overWidth);

				colList[x].style.width = (currentWidth - reduce) + "px";
				overWidth -= reduce;

				if (overWidth <= 0) {
					break;
				}
			}
		}

		var finalTotal = 0;

		for (var y = 0; y < colList.length; y++) {
			finalTotal += getBomColWidth(colList[y]);
		}

		var remainWidth = tableWidth - finalTotal;

		if (remainWidth > 2 && colList.length >= 4) {
			colList[1].style.width = (getBomColWidth(colList[1]) + remainWidth / 2) + "px";
			colList[3].style.width = (getBomColWidth(colList[3]) + remainWidth / 2) + "px";
		}
	}


	function getBomAvailableTableWidth(table) {
		var parent = table.parentElement;

		if (parent == null) {
			return Math.floor(table.getBoundingClientRect().width);
		}

		return Math.floor(parent.getBoundingClientRect().width);
	}


	function getBomColWidth(col) {
		var width = parseFloat(col.style.width);

		if (isNaN(width) || width <= 0) {
			width = col.getBoundingClientRect().width;
		}

		if (isNaN(width) || width <= 0) {
			width = 100;
		}

		return width;
	}


	function getBomColumnMinWidth(index) {
		if (index === 0) {
			return 42;
		}

		if (index === 4 || index === 5 || index === 6) {
			return 70;
		}

		if (index === 7) {
			return 60;
		}

		return 90;
	}


	function getBomColumnAbsoluteMinWidth(index) {
		if (index === 0) {
			return 36;
		}

		if (index === 7) {
			return 54;
		}

		return 64;
	}
</script>