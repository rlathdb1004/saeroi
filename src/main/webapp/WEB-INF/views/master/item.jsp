<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--
    파일명: item.jsp
    메뉴: 기준정보관리 > 품목관리

    역할:
    - 품목 목록 조회
    - 품목 검색
    - 품목 등록 모달
    - 공급처/납품처 자동완성
    - 품목코드 자동생성
    - 선택 삭제
    - 상세보기 이동

    화면 기준:
    - PC 목록 테이블: 체크박스 + 상세 포함 최대 8개 컬럼
    - 모바일 목록 테이블: 체크박스 제외 + 상세 포함 최대 4개 컬럼
    - 나머지 전체 컬럼은 상세보기 페이지에서 확인
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
         1. 검색 영역
         - 구분 selectbox 1개
         - 검색어 input 1개
         ========================================================= --%>
	<div class="search-box">
		<form class="search-form" method="get"
			action="${contextPath}/master/item">

			<div class="search-row">

				<%-- 검색 구분 --%>
				<div class="search-item">
					<label class="search-label">구분</label> <select name="searchType"
						class="search-select">
						<option value="">선택</option>

						<option value="itemCode"
							<c:if test="${itemDTO.searchType == 'itemCode'}">selected</c:if>>
							품목코드</option>

						<option value="itemName"
							<c:if test="${itemDTO.searchType == 'itemName'}">selected</c:if>>
							품목명</option>

						<option value="itemType"
							<c:if test="${itemDTO.searchType == 'itemType'}">selected</c:if>>
							품목구분</option>

						<option value="supplierName"
							<c:if test="${itemDTO.searchType == 'supplierName'}">selected</c:if>>
							공급처</option>

						<option value="deliveryClientName"
							<c:if test="${itemDTO.searchType == 'deliveryClientName'}">selected</c:if>>
							납품처</option>
					</select>
				</div>

				<%-- 검색어 --%>
				<div class="search-item">
					<label class="search-label">검색어</label> <input type="text"
						name="searchKeyword" class="search-input"
						value="${itemDTO.searchKeyword}" placeholder="내용을 입력하세요." />
				</div>

				<%-- 검색 / 초기화 버튼 --%>
				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none"> <circle cx="10.5"
								cy="10.5" r="7.5" stroke="currentColor" stroke-width="2"></circle> <path
								d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path> </svg>
						검색
					</button>

					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/master/item'">
						<svg viewBox="0 0 24 24" fill="none">
                            <path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"></path>
                            <path d="M18 4V7H21" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                        </svg>
						초기화
					</button>
				</div>

			</div>
		</form>
	</div>


	<%-- =========================================================
         2. 처리 메시지
         - Controller에서 RedirectAttributes로 msg 전달 시 출력
         ========================================================= --%>
	<c:if test="${not empty msg}">
		<script>
            alert("${msg}");
        </script>
	</c:if>


	<%-- =========================================================
         3. 총 건수 / 등록 / 선택삭제 영역
         ========================================================= --%>
	<div class="search-table-top">

		<div class="search-total-area">
			총 <strong>${itemCount}</strong>건
		</div>

		<div class="search-btn-right">

			<%-- 등록 모달 열기 --%>
			<button type="button" class="search-btn search-btn-main"
				onclick="openItemModal();">등록</button>

			<%-- PC 전용 선택삭제 버튼. 모바일에서는 숨김 --%>
			<button type="button"
				class="search-btn search-btn-sub pc-only-delete-btn"
				onclick="submitDeleteForm();">선택 삭제</button>
		</div>
	</div>


	<%-- =========================================================
         4. 품목 목록 테이블
         PC 컬럼 8개:
         1 체크박스
         2 품목코드
         3 품목명
         4 품목구분
         5 공급처
         6 납품처
         7 사용여부
         8 상세

         모바일 컬럼 최대 4개:
         1 품목코드
         2 품목명
         3 품목구분
         4 상세
         ========================================================= --%>
	<form id="itemDeleteForm" method="post"
		action="${contextPath}/master/item/delete">

		<div class="coTableWrap">
			<table class="coTable item-table">

				<thead>
					<tr>
						<th class="col-check"><input type="checkbox" id="checkAll"
							onclick="toggleAllItems(this);" /></th>
						<th class="col-code">품목코드</th>
						<th class="col-name">품목명</th>
						<th class="col-type">품목구분</th>
						<th class="col-supplier">공급처</th>
						<th class="col-client">납품처</th>
						<th class="col-use">사용여부</th>
						<th class="col-detail">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty itemList}">
							<c:forEach var="item" items="${itemList}">
								<tr>
									<%-- PC 전용 체크박스 --%>
									<td class="col-check"><input type="checkbox"
										name="itemIdList" value="${item.itemId}" /></td>

									<%-- 모바일에서도 표시 --%>
									<td class="col-code" title="${item.itemCode}">
										${item.itemCode}</td>

									<%-- 모바일에서도 표시 --%>
									<td class="col-name" title="${item.itemName}">
										${item.itemName}</td>

									<%-- 모바일에서도 표시 --%>
									<td class="col-type"><span class="coStatus coStatusUse">
											${item.itemTypeName} </span></td>

									<%-- PC 전용 --%>
									<td class="col-supplier" title="${item.supplierName}"><c:choose>
											<c:when test="${not empty item.supplierName}">
                                                ${item.supplierName}
                                            </c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose></td>

									<%-- PC 전용 --%>
									<td class="col-client" title="${item.deliveryClientName}">
										<c:choose>
											<c:when test="${not empty item.deliveryClientName}">
                                                ${item.deliveryClientName}
                                            </c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<%-- PC 전용 --%>
									<td class="col-use"><c:choose>
											<c:when test="${item.useYn == 'Y'}">
												<span class="coStatus coStatusUse">사용</span>
											</c:when>
											<c:otherwise>
												<span class="coStatus coStatusStop">미사용</span>
											</c:otherwise>
										</c:choose></td>

									<%-- 모바일에서도 표시 --%>
									<td class="col-detail"><a
										href="${contextPath}/master/item/detail?itemId=${item.itemId}"
										class="coDetailBtn"> 보기 </a></td>
								</tr>
							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">조회된 품목 정보가
									없습니다.</td>
							</tr>
						</c:otherwise>

					</c:choose>
				</tbody>

			</table>
		</div>
	</form>


	<%-- =========================================================
         5. 페이징 영역
         - pageInfo가 준비되어 있으면 공용 paging.jsp 사용
         ========================================================= --%>
	<c:if test="${not empty pageInfo}">
		<c:set var="pageUrl" value="/master/item" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. 품목 등록 모달
     - 공용 modal.css 클래스 사용
     ============================================================= --%>
<div id="itemModal" class="modal_wrap">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">품목 등록</h3>
		</div>

		<form id="itemAddForm" class="modal_form" method="post"
			action="${contextPath}/master/item/add"
			onsubmit="return validateItemAddForm();">

			<div class="modal_body modal_body_2col">

				<%-- 품목구분 --%>
				<div class="modal_item">
					<label class="modal_label"> 품목구분 <span
						class="modal_required">*</span>
					</label> <select name="itemType" id="itemType" class="modal_select"
						onchange="changeItemTypeCodeOptions();" required>
						<option value="">선택</option>
						<option value="FG">완제품</option>
						<option value="RM">원자재</option>
						<option value="SM">부자재</option>
					</select>
				</div>

				<%-- 품목코드 구성 선택 --%>
				<div class="modal_item modal_item_full">
					<label class="modal_label"> 품목코드 구성 <span
						class="modal_required">*</span>
					</label>

					<%-- 실제 자동생성에 사용할 prefix 값 --%>
					<input type="hidden" id="itemCodePrefix" />

					<%-- 완제품 코드 선택 영역 --%>
					<div id="fgCodeGroup" class="item-code-option-group">

						<div class="item-code-select-grid">

							<div>
								<label class="code-sub-label">제품군</label> <select
									id="fgProductGroup" class="modal_select"
									onchange="buildItemCodePrefix(true);">
									<option value="GSK" selected>GSK - 가스켓</option>
								</select>
							</div>

							<div>
								<label class="code-sub-label">차종</label> <select id="fgCarType"
									class="modal_select" onchange="buildItemCodePrefix(true);">
									<option value="">선택</option>
									<option value="ION5">ION5 - 아이오닉5</option>
									<option value="EV6">EV6 - EV6</option>
								</select>
							</div>

							<div>
								<label class="code-sub-label">재질</label> <select id="fgMaterial"
									class="modal_select" onchange="buildItemCodePrefix(true);">
									<option value="">선택</option>
									<option value="EPDM">EPDM - EPDM Foam</option>
									<option value="SIL">SIL - Silicone Foam</option>
									<option value="PU">PU - PU Foam</option>
								</select>
							</div>

						</div>
					</div>

					<%-- 원자재 코드 선택 영역 --%>
					<div id="rmCodeGroup" class="item-code-option-group">

						<div class="item-code-select-grid">

							<div>
								<label class="code-sub-label">원자재 코드</label> <select
									id="rmCodeTemplate" class="modal_select"
									onchange="buildItemCodePrefix(true);">
									<option value="">선택</option>
									<option value="RM-EPDM-SHEET" data-name="EPDM Foam Sheet 3.0T"
										data-unit="M">RM-EPDM-SHEET - EPDM 시트</option>
									<option value="RM-SIL-FOAM"
										data-name="Silicone Foam Sheet 2.5T" data-unit="M">
										RM-SIL-FOAM - 실리콘 폼</option>
									<option value="RM-PU-FOAM" data-name="PU Foam Sheet 2.0T"
										data-unit="M">RM-PU-FOAM - PU 폼</option>
									<option value="RM-ADH-FILM" data-name="양면 접착 필름" data-unit="M">
										RM-ADH-FILM - 접착 필름</option>
									<option value="RM-PRIMER-LIQ" data-name="프라이머 용액"
										data-unit="KG">RM-PRIMER-LIQ - 프라이머 용액</option>
									<option value="RM-REL-FILM" data-name="이형 필름" data-unit="M">
										RM-REL-FILM - 이형 필름</option>
								</select>
							</div>

						</div>
					</div>

					<%-- 부자재 코드 선택 영역 --%>
					<div id="smCodeGroup" class="item-code-option-group">

						<div class="item-code-select-grid">

							<div>
								<label class="code-sub-label">부자재 코드</label> <select
									id="smCodeTemplate" class="modal_select"
									onchange="buildItemCodePrefix(true);">
									<option value="">선택</option>
									<option value="SM-BOX" data-name="완제품 포장 박스" data-unit="EA">
										SM-BOX - 포장 박스</option>
									<option value="SM-LABEL" data-name="LOT 라벨지" data-unit="EA">
										SM-LABEL - LOT 라벨지</option>
									<option value="SM-PALLET" data-name="출하 팔레트" data-unit="EA">
										SM-PALLET - 출하 팔레트</option>
									<option value="SM-BAG" data-name="방진 포장 비닐" data-unit="EA">
										SM-BAG - 방진 비닐</option>
								</select>
							</div>

						</div>
					</div>

					<p id="itemCodePrefixText" class="autocomplete-id-text">현재
						중요코드: 선택 안 됨</p>
				</div>

				<%-- 자동 생성된 품목코드 --%>
				<div class="modal_item modal_item_full">
					<label class="modal_label"> 품목코드 <span
						class="modal_required">*</span>
					</label>

					<div class="item-code-generate-box">
						<input type="text" name="itemCode" id="itemCode"
							class="modal_input" placeholder="중요코드 입력 후 자동생성을 누르세요." readonly
							required />

						<button type="button"
							class="search-btn search-btn-main item-code-btn"
							onclick="generateItemCode();">자동생성</button>
					</div>
				</div>

				<%-- 품목명 --%>
				<div class="modal_item">
					<label class="modal_label"> 품목명 <span
						class="modal_required">*</span>
					</label> <input type="text" name="itemName" id="itemName"
						class="modal_input" placeholder="품목명을 입력하세요." required />
				</div>

				<%-- 공급처 자동완성 --%>
				<div class="modal_item autocomplete-wrap">
					<label class="modal_label"> 공급처 <span
						class="modal_required">*</span>
					</label>

					<%-- 사용자가 보는 업체명 input --%>
					<input type="text" id="supplierNameInput" class="modal_input"
						placeholder="공급처명을 입력하세요." autocomplete="off" required />

					<%-- 실제 DB에 저장될 supplier_id --%>
					<input type="hidden" name="supplierId" id="supplierId" />

					<%-- 자동완성 후보 목록 --%>
					<div id="supplierAutoList" class="autocomplete-list"></div>

					<%-- 선택된 ID 표시 --%>
					<p id="supplierIdText" class="autocomplete-id-text">공급처 ID: 선택
						안 됨</p>
				</div>

				<%-- 납품처 자동완성 --%>
				<div class="modal_item autocomplete-wrap">
					<label class="modal_label"> 납품처 </label>

					<%-- 사용자가 보는 업체명 input --%>
					<input type="text" id="clientNameInput" class="modal_input"
						placeholder="납품처명을 입력하세요." autocomplete="off" />

					<%-- 실제 DB에 저장될 client_id --%>
					<input type="hidden" name="clientId" id="clientId" />

					<%-- 자동완성 후보 목록 --%>
					<div id="clientAutoList" class="autocomplete-list"></div>

					<%-- 선택된 ID 표시 --%>
					<p id="clientIdText" class="autocomplete-id-text">납품처 ID: 선택 안
						됨</p>
				</div>

				<%-- 안전재고 --%>
				<div class="modal_item">
					<label class="modal_label"> 안전재고 </label> <input type="number"
						name="safetyStock" class="modal_input" placeholder="안전재고 수량"
						min="0" />
				</div>

				<%-- 단위 --%>
				<div class="modal_item">
					<label class="modal_label"> 단위 <span class="modal_required">*</span>
					</label>

					<%-- 실제 DB로 넘어가는 값 --%>
					<input type="hidden" name="itemUnit" id="itemUnit" /> <select
						id="itemUnitSelect" class="modal_select"
						onchange="changeItemUnitOption();" required>
						<option value="">선택</option>
						<option value="EA">EA</option>
						<option value="M">M</option>
						<option value="KG">KG</option>
						<option value="ROLL">ROLL</option>
						<option value="SET">SET</option>
						<option value="BOX">BOX</option>
						<option value="DIRECT">직접입력</option>
					</select> <input type="text" id="itemUnitDirect" class="modal_input"
						placeholder="단위를 직접 입력하세요. 예: PCS"
						style="display: none; margin-top: 8px;"
						oninput="syncDirectItemUnit();" />
				</div>

				<%-- 사용여부 --%>
				<div class="modal_item">
					<label class="modal_label"> 사용여부 </label> <select name="useYn"
						class="modal_select">
						<option value="Y">사용</option>
						<option value="N">미사용</option>
					</select>
				</div>

				<%-- 비고 --%>
				<div class="modal_item modal_item_full">
					<label class="modal_label"> 비고 </label>

					<textarea name="remark" class="modal_textarea" maxlength="30"
						placeholder="비고는 30자 이내로 입력하세요."></textarea>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button" class="modal_btn modal_btn_cancel"
					onclick="closeItemModal();">취소</button>

				<button type="submit" class="modal_btn modal_btn_submit">
					등록</button>
			</div>

		</form>
	</div>
</div>


<%-- =============================================================
     7. item.jsp 전용 스타일
     - 공용 CSS 수정 없이 현재 화면에만 적용
     ============================================================= --%>
<style>
/* 긴 텍스트 말줄임 처리 */
.item-table td {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

/* 품목코드 자동생성 input + 버튼 배치 */
.item-code-generate-box {
	display: flex;
	gap: 8px;
	width: 100%;
}

.item-code-generate-box .modal_input {
	flex: 1;
}

.item-code-btn {
	height: 42px;
	min-width: 96px;
}

/* 자동완성 영역 기준점 */
.autocomplete-wrap {
	position: relative;
}

/* 자동완성 후보 목록 */
.autocomplete-list {
	display: none;
	position: absolute;
	top: 72px;
	left: 0;
	right: 0;
	z-index: 1100;
	max-height: 180px;
	overflow-y: auto;
	background-color: #FFFFFF;
	border: 1px solid #D6DEE0;
	border-radius: 8px;
	box-shadow: 0 8px 18px rgba(15, 23, 42, 0.12);
}

.autocomplete-item {
	padding: 10px 12px;
	font-size: 14px;
	color: #1F2933;
	cursor: pointer;
}

.autocomplete-item:hover {
	background-color: #E6F2ED;
	color: #2F7D62;
}

.autocomplete-name {
	font-weight: 600;
}

.autocomplete-code {
	margin-left: 6px;
	color: #6B7280;
	font-size: 12px;
}

/* 선택된 ID 표시 */
.autocomplete-id-text {
	margin: 4px 0 0 2px;
	color: #6B7280;
	font-size: 12px;
	line-height: 1.2;
}

@media ( max-width : 760px) {
	/*
            모바일 목록 기준:
            - 체크박스 제외
            - 상세 포함 최대 4개 컬럼
            - 품목코드, 품목명, 품목구분, 상세 표시
        */
	.item-table .col-check, .item-table .col-supplier, .item-table .col-client,
		.item-table .col-use {
		display: none;
	}

	/* 모바일에서는 선택삭제 기능 제외 */
	.pc-only-delete-btn {
		display: none;
	}
	.item-table .col-name {
		max-width: 150px;
	}
	.item-code-generate-box {
		flex-direction: column;
	}
	.item-code-btn {
		width: 100%;
	}
}

.item-code-option-group {
	display: none;
	margin-top: 6px;
}

.item-code-select-grid {
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 8px;
}

.code-sub-label {
	display: block;
	margin: 0 0 4px 2px;
	color: #4B5563;
	font-size: 12px;
	font-weight: 600;
}

@media ( max-width : 760px) {
	.item-code-select-grid {
		grid-template-columns: 1fr;
	}
}
</style>


<%-- =============================================================
     8. item.jsp 전용 스크립트
     - 공용 JS 수정 없음
     ============================================================= --%>
<script>
    var contextPath = "${contextPath}";

    /*
        자동완성 요청 타이머
        - 사용자가 키를 누를 때마다 바로 DB 조회하지 않고,
          마지막 입력 후 300ms 뒤에 조회한다.
    */
    var supplierAutoTimer = null;
    var clientAutoTimer = null;


    /**
     * 등록 모달 열기
     */
    function openItemModal() {
        var modal = document.getElementById("itemModal");

        if (modal != null) {
            modal.classList.add("modal_is_open");
            document.body.classList.add("modal_body_lock");
        }
    }


    /**
     * 등록 모달 닫기
     */
    function closeItemModal() {
        var modal = document.getElementById("itemModal");

        if (modal != null) {
            modal.classList.remove("modal_is_open");
            document.body.classList.remove("modal_body_lock");
        }
    }


    /**
     * 전체 선택 / 전체 해제
     */
    function toggleAllItems(checkAll) {
        var checkboxes = document.querySelectorAll("input[name='itemIdList']");

        for (var i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = checkAll.checked;
        }
    }


    /**
     * 선택 삭제 submit
     */
    function submitDeleteForm() {
        var checkedItems = document.querySelectorAll("input[name='itemIdList']:checked");

        if (checkedItems.length === 0) {
            alert("삭제할 품목을 선택하세요.");
            return;
        }

        if (confirm("선택한 품목을 미사용 처리하시겠습니까?")) {
            document.getElementById("itemDeleteForm").submit();
        }
    }


    /**
     * 품목코드 자동생성
     *
     * 처리 흐름:
     * 1. 사용자가 중요코드를 입력한다.
     * 2. /master/item/nextCode로 prefix를 전달한다.
     * 3. 서버에서 다음 순번을 계산한다.
     * 4. 완성된 품목코드를 itemCode input에 넣는다.
     */
     function changeItemTypeCodeOptions() {
    		var itemType = document.getElementById("itemType").value;

    		document.getElementById("fgCodeGroup").style.display = "none";
    		document.getElementById("rmCodeGroup").style.display = "none";
    		document.getElementById("smCodeGroup").style.display = "none";

    		document.getElementById("itemCodePrefix").value = "";
    		document.getElementById("itemCodePrefixText").innerText = "현재 중요코드: 선택 안 됨";
    		document.getElementById("itemCode").value = "";

    		if (itemType === "FG") {
    			document.getElementById("fgCodeGroup").style.display = "block";
    		} else if (itemType === "RM") {
    			document.getElementById("rmCodeGroup").style.display = "block";
    		} else if (itemType === "SM") {
    			document.getElementById("smCodeGroup").style.display = "block";
    		}

    		buildItemCodePrefix(true);
    	}


    	function buildItemCodePrefix(clearGeneratedCode) {
    		var itemType = document.getElementById("itemType").value;
    		var prefix = "";
    		var itemName = "";
    		var itemUnit = "";

    		if (itemType === "FG") {
    			var productGroup = document.getElementById("fgProductGroup").value;
    			var carType = document.getElementById("fgCarType").value;
    			var material = document.getElementById("fgMaterial").value;

    			if (productGroup !== "" && carType !== "" && material !== "") {
    				prefix = "FG-" + productGroup + "-" + carType + "-" + material;

    				if (carType === "ION5" && material === "EPDM") {
    					itemName = "아이오닉5 배터리팩 메인 방수 가스켓";
    				} else if (carType === "ION5" && material === "SIL") {
    					itemName = "아이오닉5 배터리 커버 실리콘 가스켓";
    				} else if (carType === "ION5" && material === "PU") {
    					itemName = "아이오닉5 배터리 서비스커버 PU 가스켓";
    				} else if (carType === "EV6" && material === "EPDM") {
    					itemName = "EV6 배터리팩 메인 방수 가스켓";
    				} else if (carType === "EV6" && material === "SIL") {
    					itemName = "EV6 배터리 커버 실리콘 가스켓";
    				} else if (carType === "EV6" && material === "PU") {
    					itemName = "EV6 배터리 모듈 보호 PU 가스켓";
    				}

    				itemUnit = "EA";
    			}
    		} else if (itemType === "RM") {
    			var rmSelect = document.getElementById("rmCodeTemplate");
    			var rmOption = rmSelect.options[rmSelect.selectedIndex];

    			if (rmSelect.value !== "") {
    				prefix = rmSelect.value;
    				itemName = rmOption.getAttribute("data-name");
    				itemUnit = rmOption.getAttribute("data-unit");
    			}
    		} else if (itemType === "SM") {
    			var smSelect = document.getElementById("smCodeTemplate");
    			var smOption = smSelect.options[smSelect.selectedIndex];

    			if (smSelect.value !== "") {
    				prefix = smSelect.value;
    				itemName = smOption.getAttribute("data-name");
    				itemUnit = smOption.getAttribute("data-unit");
    			}
    		}

    		document.getElementById("itemCodePrefix").value = prefix;

    		if (prefix === "") {
    			document.getElementById("itemCodePrefixText").innerText = "현재 중요코드: 선택 안 됨";
    		} else {
    			document.getElementById("itemCodePrefixText").innerText = "현재 중요코드: " + prefix;
    		}

    		if (itemName !== null && itemName !== "") {
    			document.getElementById("itemName").value = itemName;
    		}

    		if (itemUnit !== null && itemUnit !== "") {
    			setItemUnit(itemUnit);
    		}

    		if (clearGeneratedCode === true) {
    			document.getElementById("itemCode").value = "";
    		}

    		return prefix;
    	}


    	function generateItemCode() {
    		var itemType = document.getElementById("itemType").value;
    		var itemCodePrefix = buildItemCodePrefix(false);

    		if (itemType === "") {
    			alert("품목구분을 먼저 선택하세요.");
    			document.getElementById("itemType").focus();
    			return;
    		}

    		if (itemCodePrefix === "") {
    			alert("품목코드 구성을 선택하세요.");
    			return;
    		}

    		fetch(contextPath + "/master/item/nextCode?itemCodePrefix="
    				+ encodeURIComponent(itemCodePrefix))
    			.then(function(response) {
    				return response.text();
    			})
    			.then(function(nextItemCode) {
    				document.getElementById("itemCode").value = nextItemCode;
    			})
    			.catch(function() {
    				alert("품목코드 자동생성 중 오류가 발생했습니다.");
    			});
    	}


    /**
     * 공급처 자동완성 이벤트 연결
     */
    document.getElementById("supplierNameInput").addEventListener("input", function() {
        clearTimeout(supplierAutoTimer);

        var keyword = this.value.trim();

        /* 사용자가 업체명을 다시 수정하면 기존 선택 ID를 초기화한다. */
        document.getElementById("supplierId").value = "";
        document.getElementById("supplierIdText").innerText = "공급처 ID: 선택 안 됨";

        supplierAutoTimer = setTimeout(function() {
            searchClientAutoComplete(
                "SUP",
                keyword,
                "supplierAutoList",
                "supplierNameInput",
                "supplierId",
                "supplierIdText",
                "공급처 ID: "
            );
        }, 300);
    });


    /**
     * 납품처 자동완성 이벤트 연결
     */
    document.getElementById("clientNameInput").addEventListener("input", function() {
        clearTimeout(clientAutoTimer);

        var keyword = this.value.trim();

        /* 사용자가 업체명을 다시 수정하면 기존 선택 ID를 초기화한다. */
        document.getElementById("clientId").value = "";
        document.getElementById("clientIdText").innerText = "납품처 ID: 선택 안 됨";

        clientAutoTimer = setTimeout(function() {
            searchClientAutoComplete(
                "CUS",
                keyword,
                "clientAutoList",
                "clientNameInput",
                "clientId",
                "clientIdText",
                "납품처 ID: "
            );
        }, 300);
    });


    /**
     * 거래처 자동완성 공통 함수
     *
     * @param clientType SUP 또는 CUS
     * @param keyword 검색어
     * @param listId 후보 목록 div id
     * @param inputId 사용자가 보는 input id
     * @param hiddenId 실제 저장할 hidden input id
     * @param idTextId 선택된 ID 표시 p 태그 id
     * @param idTextPrefix 표시 문구
     */
    function searchClientAutoComplete(clientType, keyword, listId, inputId, hiddenId, idTextId, idTextPrefix) {
        var listBox = document.getElementById(listId);

        if (keyword.length < 1) {
            listBox.style.display = "none";
            listBox.innerHTML = "";
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
                listBox.innerHTML = "";

                if (clientList.length === 0) {
                    listBox.style.display = "none";
                    return;
                }

                for (var i = 0; i < clientList.length; i++) {
                    var client = clientList[i];

                    var item = document.createElement("div");
                    item.className = "autocomplete-item";

                    var nameSpan = document.createElement("span");
                    nameSpan.className = "autocomplete-name";
                    nameSpan.textContent = client.clientName;

                    var codeSpan = document.createElement("span");
                    codeSpan.className = "autocomplete-code";
                    codeSpan.textContent = "(" + client.clientCode + " / ID " + client.clientId + ")";

                    item.appendChild(nameSpan);
                    item.appendChild(codeSpan);

                    item.setAttribute("data-client-id", client.clientId);
                    item.setAttribute("data-client-name", client.clientName);

                    item.onclick = function() {
                        var selectedId = this.getAttribute("data-client-id");
                        var selectedName = this.getAttribute("data-client-name");

                        document.getElementById(inputId).value = selectedName;
                        document.getElementById(hiddenId).value = selectedId;
                        document.getElementById(idTextId).innerText = idTextPrefix + selectedId;

                        listBox.style.display = "none";
                        listBox.innerHTML = "";
                    };

                    listBox.appendChild(item);
                }

                listBox.style.display = "block";
            })
            .catch(function() {
                listBox.style.display = "none";
                listBox.innerHTML = "";
            });
    }


    /**
     * 품목 등록 form 검증
     *
     * 주의:
     * - 공급처는 자동완성 목록에서 선택해야 supplierId가 들어간다.
     * - 품목코드는 자동생성 버튼을 눌러 생성해야 한다.
     */
     function validateItemAddForm() {
    		var itemType = document.getElementById("itemType").value;
    		var itemCodePrefix = document.getElementById("itemCodePrefix").value.trim();
    		var itemCode = document.getElementById("itemCode").value.trim();
    		var supplierId = document.getElementById("supplierId").value;
    		var itemUnit = document.getElementById("itemUnit").value.trim();

    		if (itemUnit === "") {
    			alert("단위를 선택하거나 직접 입력하세요.");
    			document.getElementById("itemUnitSelect").focus();
    			return false;
    		}

    		if (itemType === "") {
    			alert("품목구분을 선택하세요.");
    			document.getElementById("itemType").focus();
    			return false;
    		}

    		if (itemCodePrefix === "") {
    			alert("품목코드 구성을 선택하세요.");
    			return false;
    		}

    		if (itemCode === "") {
    			alert("품목코드를 자동생성하세요.");
    			return false;
    		}

    		if (supplierId === "") {
    			alert("공급처는 자동완성 목록에서 선택해야 합니다.");
    			document.getElementById("supplierNameInput").focus();
    			return false;
    		}

    		return true;
    	}


    /**
     * 화면 아무 곳이나 클릭했을 때 자동완성 목록 닫기
     */
    document.addEventListener("click", function(event) {
        var supplierWrap = document.getElementById("supplierNameInput");
        var clientWrap = document.getElementById("clientNameInput");

        if (event.target !== supplierWrap) {
            document.getElementById("supplierAutoList").style.display = "none";
        }

        if (event.target !== clientWrap) {
            document.getElementById("clientAutoList").style.display = "none";
        }
    });
    
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

    function setItemUnit(unit) {
    	var itemUnitSelect = document.getElementById("itemUnitSelect");
    	var itemUnitDirect = document.getElementById("itemUnitDirect");
    	var itemUnit = document.getElementById("itemUnit");

    	if (unit === null || unit === undefined) {
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
</script>