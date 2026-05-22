<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--
    파일명: process.jsp
    메뉴: 기준정보관리 > 공정관리

    기준:
    - 품목관리 item.jsp 구조 기준
    - BOM관리 bom.jsp 구조 기준
    - 공용 searchtable.css 사용
    - 공용 modal.css 사용
    - 공용 mobile.css 사용
    - 공용 searchtable.js 사용
    - 공용 modal.js 사용
    - 별도 CSS 파일 추가 없음

    기능:
    - 공정 목록 조회
    - 공정 검색
    - 공정 등록 모달
    - 공정코드 자동완성
    - 공정코드 중복확인
    - 필수입력 안내문 input/select 하단 표시
    - 선택 삭제
    - 상세보기 이동
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
         1. 검색 영역
         ========================================================= --%>
	<div class="search-box">
		<form class="search-form" method="get"
			action="${contextPath}/master/process">

			<div class="search-row">

				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="searchType" class="search-select">
						<option value="">선택</option>

						<option value="procCode"
							<c:if test="${processDTO.searchType == 'procCode'}">selected</c:if>>
							공정코드
						</option>

						<option value="procName"
							<c:if test="${processDTO.searchType == 'procName'}">selected</c:if>>
							공정명
						</option>

						<option value="itemCode"
							<c:if test="${processDTO.searchType == 'itemCode'}">selected</c:if>>
							품목코드
						</option>

						<option value="itemName"
							<c:if test="${processDTO.searchType == 'itemName'}">selected</c:if>>
							품목명
						</option>

						<option value="equipCode"
							<c:if test="${processDTO.searchType == 'equipCode'}">selected</c:if>>
							설비코드
						</option>

						<option value="equipName"
							<c:if test="${processDTO.searchType == 'equipName'}">selected</c:if>>
							설비명
						</option>

						<option value="lineName"
							<c:if test="${processDTO.searchType == 'lineName'}">selected</c:if>>
							라인명
						</option>
					</select>
				</div>

				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text" name="searchKeyword" class="search-input"
						value="${processDTO.searchKeyword}" placeholder="내용을 입력하세요." />
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
						onclick="location.href='${contextPath}/master/process'">
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
         3. 총 건수 / 등록 / 선택삭제 영역
         ========================================================= --%>
	<div class="search-table-top">

		<div class="search-total-area">
			총 <strong>${processCount}</strong>건
		</div>

		<div class="search-btn-right">

			<button type="button"
				class="search-btn search-btn-main modal_open_btn"
				data_modal_target="#processModal">
				등록
			</button>

			<button type="button"
				class="search-btn search-btn-sub pc-only-delete-btn"
				onclick="submitDeleteForm();">
				선택 삭제
			</button>
		</div>
	</div>


	<%-- =========================================================
         4. 공정 목록 테이블
         ========================================================= --%>
	<form id="processDeleteForm" method="post"
		action="${contextPath}/master/process/delete">

		<div class="coTableWrap">
			<table class="coTable process-table" id="processListTable">

				<thead>
					<tr>
						<th class="mobile_show" onclick="toggleAllCheckByTitle();"
							title="전체 선택/해제">선택</th>

						<th class="mobile_show">완제품</th>
						<th class="mobile_hidden">공정코드</th>
						<th class="mobile_show">공정명</th>
						<th class="mobile_show">설비</th>
						<th class="mobile_hidden">라인</th>
						<th class="mobile_hidden">비고</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>

						<c:when test="${not empty processList}">
							<c:forEach var="process" items="${processList}">
								<tr>
									<td class="mobile_show">
										<input type="checkbox" name="procIdList"
											value="${process.procId}">
									</td>

									<td class="mobile_show" title="${process.itemName}">
										<c:choose>
											<c:when test="${not empty process.itemName}">
												${process.itemName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden" title="${process.procCode}">
										<c:choose>
											<c:when test="${not empty process.procCode}">
												${process.procCode}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show" title="${process.procName}">
										<c:choose>
											<c:when test="${not empty process.procName}">
												${process.procName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show" title="${process.equipName}">
										<c:choose>
											<c:when test="${not empty process.equipName}">
												${process.equipName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden" title="${process.lineName}">
										<c:choose>
											<c:when test="${not empty process.lineName}">
												${process.lineName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_hidden" title="${process.remark}">
										<c:choose>
											<c:when test="${not empty process.remark}">
												${process.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</td>

									<td class="mobile_show">
										<a href="${contextPath}/master/process/detail?procId=${process.procId}"
											class="coDetailBtn">보기</a>
									</td>
								</tr>
							</c:forEach>
						</c:when>

						<c:otherwise>
							<tr>
								<td colspan="8" style="text-align: center;">
									조회된 공정 정보가 없습니다.
								</td>
							</tr>
						</c:otherwise>

					</c:choose>
				</tbody>

			</table>
		</div>
	</form>


	<%-- =========================================================
         5. 페이징 영역
         ========================================================= --%>
	<c:if test="${not empty pageInfo}">
		<c:set var="pageUrl" value="/master/process" scope="request" />
		<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	</c:if>

</div>


<%-- =============================================================
     6. 공정 등록 모달
     ============================================================= --%>
<div id="processModal" class="modal_wrap" aria-hidden="true">

	<div class="modal_box">

		<div class="modal_header">
			<h3 class="modal_title">공정 등록</h3>
		</div>

		<form id="processAddForm" class="modal_form" method="post"
			action="${contextPath}/master/process/add"
			onsubmit="return validateProcessAddForm();">

			<div class="modal_body modal_body_2col">

				<div class="modal_item modal_item_full">
					<label class="modal_label">
						완제품 <span class="modal_required">*</span>
					</label>

					<select name="itemId" id="itemId" class="modal_select"
						onchange="validateRequiredField('itemId', 'itemIdMsg', '완제품을 선택하세요.');"
						required>
						<option value="">선택</option>

						<c:forEach var="item" items="${productItemList}">
							<option value="${item.itemId}">
								${item.itemName} (${item.itemCode})
							</option>
						</c:forEach>
					</select>

					<div id="itemIdMsg"
						style="display: none; color: #d93025; font-size: 12px; margin-top: 6px;"></div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						공정코드 <span class="modal_required">*</span>
					</label>

					<input type="text" name="procCode" id="procCode"
						class="modal_input"
						list="procCodeAutoList"
						maxlength="50"
						placeholder="예: PRC-CUT-005"
						oninput="handleProcCodeInput();"
						onblur="checkProcCodeDuplicate();"
						required />

					<datalist id="procCodeAutoList"></datalist>

					<div id="procCodeMsg"
						style="display: none; color: #d93025; font-size: 12px; margin-top: 6px;"></div>
				</div>

				<div class="modal_item">
					<label class="modal_label">
						공정명 <span class="modal_required">*</span>
					</label>

					<input type="text" name="procName" id="procName"
						class="modal_input"
						maxlength="100"
						placeholder="예: 자동 타발, 열압착, 외관검사"
						onblur="validateRequiredField('procName', 'procNameMsg', '공정명을 입력하세요.');"
						required />

					<div id="procNameMsg"
						style="display: none; color: #d93025; font-size: 12px; margin-top: 6px;"></div>
				</div>

				<div class="modal_item modal_item_full">
					<label class="modal_label">
						설비 <span class="modal_required">*</span>
					</label>

					<select name="equipId" id="equipId" class="modal_select"
						onchange="validateRequiredField('equipId', 'equipIdMsg', '설비를 선택하세요.');"
						required>
						<option value="">선택</option>

						<c:forEach var="equip" items="${equipmentList}">
							<option value="${equip.equipId}">
								${equip.equipName}
								<c:if test="${not empty equip.lineName}">
									/ ${equip.lineName}
								</c:if>
								<c:if test="${not empty equip.equipCode}">
									(${equip.equipCode})
								</c:if>
							</option>
						</c:forEach>
					</select>

					<div id="equipIdMsg"
						style="display: none; color: #d93025; font-size: 12px; margin-top: 6px;"></div>
				</div>

				<div class="modal_item modal_item_full">
					<label class="modal_label">공정내용</label>

					<textarea name="procContent" id="procContent"
						class="modal_textarea" maxlength="1000"
						placeholder="공정내용을 입력하세요."></textarea>
				</div>

				<div class="modal_item modal_item_full">
					<label class="modal_label">비고</label>

					<textarea name="remark" class="modal_textarea" maxlength="30"
						placeholder="비고는 30자 이내로 입력하세요."></textarea>
				</div>

			</div>

			<div class="modal_footer">
				<button type="button"
					class="modal_btn modal_btn_cancel modal_close_btn">
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
     7. 공정관리 화면 전용 최소 스크립트
     ============================================================= --%>
<script>
	var procCodeTimer = null;
	var procCodeDuplicate = false;
	var procCodeCheckDone = false;
	var procCodeNameMap = {};

	function toggleAllCheckByTitle() {
		var checkboxList = document.querySelectorAll("#processDeleteForm input[name='procIdList']");

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


	function submitDeleteForm() {
		var checkedItems = document.querySelectorAll("#processDeleteForm input[name='procIdList']:checked");

		if (checkedItems.length === 0) {
			alert("삭제할 공정을 선택하세요.");
			return;
		}

		if (confirm("선택한 공정을 삭제하시겠습니까?")) {
			document.getElementById("processDeleteForm").submit();
		}
	}


	function showFieldMsg(msgId, message) {
		var msgBox = document.getElementById(msgId);

		if (msgBox == null) {
			return;
		}

		if (message == null || message === "") {
			msgBox.style.display = "none";
			msgBox.innerHTML = "";
			return;
		}

		msgBox.style.display = "block";
		msgBox.innerHTML = message;
	}


	function validateRequiredField(inputId, msgId, message) {
		var input = document.getElementById(inputId);

		if (input == null || input.value.trim() === "") {
			showFieldMsg(msgId, message);
			return false;
		}

		showFieldMsg(msgId, "");
		return true;
	}


	function handleProcCodeInput() {
		var procCodeInput = document.getElementById("procCode");
		var procNameInput = document.getElementById("procName");

		if (procCodeInput == null) {
			return;
		}

		procCodeDuplicate = false;
		procCodeCheckDone = false;

		var keyword = procCodeInput.value.trim();

		if (keyword === "") {
			showFieldMsg("procCodeMsg", "공정코드를 입력하세요.");
			clearProcCodeAutoList();
			return;
		}

		showFieldMsg("procCodeMsg", "");

		clearTimeout(procCodeTimer);

		procCodeTimer = setTimeout(function() {
			loadProcCodeAutoComplete(keyword);
			checkProcCodeDuplicate();

			/*
			 * datalist에서 기존 공정코드를 정확히 선택한 경우
			 * 공정명이 비어 있으면 기존 공정명을 자동 입력한다.
			 * 단, 공정코드 자체는 중복이면 등록 불가다.
			 */
			if (procNameInput != null
					&& procNameInput.value.trim() === ""
					&& procCodeNameMap[keyword] != null) {
				procNameInput.value = procCodeNameMap[keyword];
				showFieldMsg("procNameMsg", "");
			}

		}, 300);
	}


	function clearProcCodeAutoList() {
		var dataList = document.getElementById("procCodeAutoList");

		if (dataList != null) {
			dataList.innerHTML = "";
		}

		procCodeNameMap = {};
	}


	function loadProcCodeAutoComplete(keyword) {
		if (keyword == null || keyword.trim() === "") {
			clearProcCodeAutoList();
			return;
		}

		fetch("${contextPath}/master/process/procCodeAutoComplete?keyword=" + encodeURIComponent(keyword))
			.then(function(response) {
				return response.json();
			})
			.then(function(data) {
				var dataList = document.getElementById("procCodeAutoList");

				if (dataList == null) {
					return;
				}

				dataList.innerHTML = "";
				procCodeNameMap = {};

				if (data == null || data.length === 0) {
					return;
				}

				for (var i = 0; i < data.length; i++) {
					var procCode = data[i].procCode;
					var procName = data[i].procName;

					if (procCode == null || procCode === "") {
						continue;
					}

					procCodeNameMap[procCode] = procName;

					var option = document.createElement("option");
					option.value = procCode;

					if (procName != null && procName !== "") {
						option.label = procCode + " / " + procName;
					}

					dataList.appendChild(option);
				}
			})
			.catch(function() {
				clearProcCodeAutoList();
			});
	}


	function checkProcCodeDuplicate(callback) {
		var procCodeInput = document.getElementById("procCode");

		if (procCodeInput == null) {
			if (callback != null) {
				callback(false);
			}
			return;
		}

		var procCode = procCodeInput.value.trim();

		if (procCode === "") {
			procCodeDuplicate = false;
			procCodeCheckDone = false;
			showFieldMsg("procCodeMsg", "공정코드를 입력하세요.");

			if (callback != null) {
				callback(false);
			}
			return;
		}

		fetch("${contextPath}/master/process/checkProcCodeDuplicate?procCode=" + encodeURIComponent(procCode))
			.then(function(response) {
				return response.json();
			})
			.then(function(data) {
				procCodeDuplicate = data.duplicate === true;
				procCodeCheckDone = true;

				if (procCodeDuplicate) {
					showFieldMsg("procCodeMsg", data.message);
				} else {
					showFieldMsg("procCodeMsg", "");
				}

				if (callback != null) {
					callback(procCodeDuplicate);
				}
			})
			.catch(function() {
				procCodeDuplicate = false;
				procCodeCheckDone = false;
				showFieldMsg("procCodeMsg", "공정코드 중복확인 중 오류가 발생했습니다.");

				if (callback != null) {
					callback(true);
				}
			});
	}


	function validateProcessAddForm() {
		var valid = true;

		if (!validateRequiredField("itemId", "itemIdMsg", "완제품을 선택하세요.")) {
			valid = false;
		}

		if (!validateRequiredField("procCode", "procCodeMsg", "공정코드를 입력하세요.")) {
			valid = false;
		}

		if (!validateRequiredField("procName", "procNameMsg", "공정명을 입력하세요.")) {
			valid = false;
		}

		if (!validateRequiredField("equipId", "equipIdMsg", "설비를 선택하세요.")) {
			valid = false;
		}

		if (!valid) {
			return false;
		}

		checkProcCodeDuplicate(function(isDuplicate) {
			if (isDuplicate) {
				showFieldMsg("procCodeMsg", "이미 존재하는 공정코드입니다.");
				return;
			}

			document.getElementById("processAddForm").submit();
		});

		return false;
	}
</script>