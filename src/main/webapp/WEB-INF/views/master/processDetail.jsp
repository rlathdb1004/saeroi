<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
    파일명 : processDetail.jsp
    메뉴   : 기준정보관리 > 공정관리 > 공정 상세

    기준:
    - 상세 페이지는 detail.css 기준
    - content.css / searchtable.css / modal.css는 Tiles layout에서 로딩
    - 공정 기본정보 수정은 상단 저장 버튼으로 처리
    - 공정 이미지 등록은 수정모드에서만 표시
    - 상세 페이지 내부 이미지 목록에는 상세 컬럼 없음
    - 전용 CSS는 파일선택/이미지크기/제목버튼정렬/버튼폭 보정만 최소 사용
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">공정 상세</h2>
			<div class="detail_path">기준정보관리 &gt; 공정관리 &gt; 공정 상세</div>
		</div>

		<div class="detail_btn_area">
			<c:if test="${not empty processDetail}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="processModifyForm" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>
					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="changeEditMode(false);" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/master/process'">
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
		<c:when test="${not empty processDetail}">

			<form id="processModifyForm"
				action="${contextPath}/master/process/modify"
				method="post"
				accept-charset="UTF-8"
				onsubmit="return validateProcessModifyForm();">

				<input type="hidden" name="procId" value="${processDetail.procId}">

				<div class="detail_card">
					<div class="detail_card_title">공정 기본 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
						</colgroup>

						<tbody>
							<tr>
								<th>공정 ID</th>
								<td>${processDetail.procId}</td>

								<th>공정코드</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty processDetail.procCode}">
												<c:out value="${processDetail.procCode}" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text"
											name="procCode"
											id="procCode"
											class="detail_input"
											value="${processDetail.procCode}"
											list="procCodeAutoList"
											maxlength="50"
											placeholder="예: PRC-CUT-001"
											oninput="handleProcCodeInput();"
											onblur="checkProcCodeDuplicate();"
											data-edit-control
											disabled
											required>
										<datalist id="procCodeAutoList"></datalist>
										<div id="procCodeMsg" class="process-field-msg"></div>
									</div>
								</td>

								<th>공정명</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty processDetail.procName}">
												<c:out value="${processDetail.procName}" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text"
											name="procName"
											id="procName"
											class="detail_input"
											value="${processDetail.procName}"
											maxlength="100"
											placeholder="예: 재단, 라미네이팅, 프레스성형"
											onblur="validateRequiredField('procName', 'procNameMsg', '공정명을 입력하세요.');"
											data-edit-control
											disabled
											required>
										<div id="procNameMsg" class="process-field-msg"></div>
									</div>
								</td>
							</tr>

							<tr>
								<th>공정내용</th>
								<td colspan="3">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty processDetail.procContent}">
												<c:out value="${processDetail.procContent}" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<textarea name="procContent"
											id="procContent"
											class="detail_textarea"
											maxlength="1000"
											placeholder="공정내용을 입력하세요."
											data-edit-control
											disabled><c:out value="${processDetail.procContent}" /></textarea>
									</div>
								</td>

								<th>비고</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty processDetail.remark}">
												<c:out value="${processDetail.remark}" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text"
											name="remark"
											class="detail_input"
											value="${processDetail.remark}"
											maxlength="30"
											placeholder="비고 30자 이내"
											data-edit-control
											disabled>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="detail_card">
					<div class="detail_card_title">완제품 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
						</colgroup>

						<tbody>
							<tr>
								<th>완제품</th>
								<td colspan="5">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty processDetail.itemName}">
												<c:out value="${processDetail.itemName}" />
												<c:if test="${not empty processDetail.itemCode}">
													(<c:out value="${processDetail.itemCode}" />)
												</c:if>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="itemId"
											id="itemId"
											class="detail_select"
											onchange="handleItemChange();"
											data-edit-control
											disabled
											required>
											<option value="">선택</option>

											<c:forEach var="item" items="${productItemList}">
												<option value="${item.itemId}"
													data-item-code="${item.itemCode}"
													data-item-name="${item.itemName}"
													data-item-unit="${item.itemUnit}"
													data-item-type="${item.itemType}"
													data-item-type-name="${item.itemTypeName}"
													<c:if test="${item.itemId == processDetail.itemId}">selected</c:if>>
													${item.itemName} (${item.itemCode})
												</option>
											</c:forEach>
										</select>
										<div id="itemIdMsg" class="process-field-msg"></div>
									</div>
								</td>
							</tr>

							<tr>
								<th>품목코드</th>
								<td id="viewItemCode">
									<c:choose>
										<c:when test="${not empty processDetail.itemCode}">
											<c:out value="${processDetail.itemCode}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목명</th>
								<td id="viewItemName">
									<c:choose>
										<c:when test="${not empty processDetail.itemName}">
											<c:out value="${processDetail.itemName}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>품목구분</th>
								<td id="viewItemType">
									<c:choose>
										<c:when test="${not empty processDetail.itemTypeName}">
											<c:out value="${processDetail.itemTypeName}" />
											<c:if test="${not empty processDetail.itemType}">
												(<c:out value="${processDetail.itemType}" />)
											</c:if>
										</c:when>
										<c:when test="${not empty processDetail.itemType}">
											<c:out value="${processDetail.itemType}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>단위</th>
								<td id="viewItemUnit">
									<c:choose>
										<c:when test="${not empty processDetail.itemUnit}">
											<c:out value="${processDetail.itemUnit}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty processDetail.createdDate}">
											<fmt:formatDate value="${processDetail.createdDate}" pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty processDetail.updatedDate}">
											<fmt:formatDate value="${processDetail.updatedDate}" pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="detail_card">
					<div class="detail_card_title">설비 / 라인 정보</div>

					<table class="detail_info_table">
						<colgroup>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
						</colgroup>

						<tbody>
							<tr>
								<th>설비</th>
								<td colspan="5">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty processDetail.equipName}">
												<c:out value="${processDetail.equipName}" />
												<c:if test="${not empty processDetail.equipCode}">
													(<c:out value="${processDetail.equipCode}" />)
												</c:if>
												<c:if test="${not empty processDetail.lineName}">
													/ <c:out value="${processDetail.lineName}" />
												</c:if>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="equipId"
											id="equipId"
											class="detail_select"
											onchange="handleEquipChange();"
											data-edit-control
											disabled
											required>
											<option value="">선택</option>

											<c:forEach var="equip" items="${equipmentList}">
												<option value="${equip.equipId}"
													data-equip-code="${equip.equipCode}"
													data-equip-name="${equip.equipName}"
													data-equip-status="${equip.equipStatus}"
													data-equip-loc="${equip.equipLoc}"
													data-line-code="${equip.lineCode}"
													data-line-name="${equip.lineName}"
													data-line-status="${equip.lineStatus}"
													<c:if test="${equip.equipId == processDetail.equipId}">selected</c:if>>
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
										<div id="equipIdMsg" class="process-field-msg"></div>
									</div>
								</td>
							</tr>

							<tr>
								<th>설비코드</th>
								<td id="viewEquipCode">
									<c:choose>
										<c:when test="${not empty processDetail.equipCode}">
											<c:out value="${processDetail.equipCode}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>설비명</th>
								<td id="viewEquipName">
									<c:choose>
										<c:when test="${not empty processDetail.equipName}">
											<c:out value="${processDetail.equipName}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>설비상태</th>
								<td id="viewEquipStatus">
									<c:choose>
										<c:when test="${processDetail.equipStatus == '가동'}">
											<span class="detail_status_badge detail_status_pass">가동</span>
										</c:when>
										<c:when test="${not empty processDetail.equipStatus}">
											<span class="detail_status_badge detail_status_fail">
												<c:out value="${processDetail.equipStatus}" />
											</span>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>라인코드</th>
								<td id="viewLineCode">
									<c:choose>
										<c:when test="${not empty processDetail.lineCode}">
											<c:out value="${processDetail.lineCode}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>라인명</th>
								<td id="viewLineName">
									<c:choose>
										<c:when test="${not empty processDetail.lineName}">
											<c:out value="${processDetail.lineName}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>라인상태</th>
								<td id="viewLineStatus">
									<c:choose>
										<c:when test="${processDetail.lineStatus == 'LINE-RUN'}">
											<span class="detail_status_badge detail_status_pass">가동</span>
										</c:when>
										<c:when test="${processDetail.lineStatus == 'LINE-IDLE'}">
											<span class="detail_status_badge detail_status_fail">대기</span>
										</c:when>
										<c:when test="${not empty processDetail.lineStatus}">
											<c:out value="${processDetail.lineStatus}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>설비위치</th>
								<td colspan="5" id="viewEquipLoc">
									<c:choose>
										<c:when test="${not empty processDetail.equipLoc}">
											<c:out value="${processDetail.equipLoc}" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

			</form>

			<div class="detail_card">
				<div class="process-card-head">
					<div class="detail_card_title">공정 이미지 등록</div>

					<button type="submit"
						id="imageSaveBtn"
						form="processImageAddForm"
						class="detail_btn_green process-image-save-btn"
						style="display: none;">
						<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
							<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
							<path d="M17 8l-5-5-5 5"></path>
							<path d="M12 3v12"></path>
						</svg>
						공정 이미지 등록
					</button>
				</div>

				<form id="processImageAddForm"
					action="${contextPath}/master/process/detail/add"
					method="post"
					enctype="multipart/form-data"
					accept-charset="UTF-8"
					onsubmit="return validateProcessImageAddForm();"
					style="display: none;">

					<input type="hidden" name="procId" value="${processDetail.procId}">

					<table class="detail_info_table">
						<colgroup>
							<col>
							<col>
							<col>
							<col>
							<col>
							<col>
						</colgroup>

						<tbody>
							<tr>
								<th>이미지</th>
								<td colspan="3">
									<input type="file"
										name="procImageFile"
										id="procImageFile"
										class="process-file-input"
										accept="image/*"
										onchange="handleProcessImageFile();"
										disabled>

									<label for="procImageFile"
										class="search-btn search-btn-sub process-file-label">
										파일 선택
									</label>

									<span id="procImageFileName" class="process-file-name">
										선택된 파일 없음
									</span>

									<div id="procImageFileMsg" class="process-field-msg"></div>
								</td>

								<th>비고</th>
								<td>
									<input type="text"
										name="remark"
										id="processImageRemark"
										class="detail_input"
										maxlength="30"
										placeholder="비고 30자 이내"
										disabled>
								</td>
							</tr>

							<tr>
								<th>상세설명</th>
								<td colspan="5">
									<textarea name="procContent"
										id="processImageContent"
										class="detail_textarea"
										maxlength="1000"
										placeholder="공정 이미지 설명, 작업표준, 주의사항 등을 입력하세요."
										disabled></textarea>
								</td>
							</tr>

							<tr id="processImagePreviewRow" style="display: none;">
								<th>미리보기</th>
								<td colspan="5">
									<img id="processImagePreview"
										src=""
										alt="공정 이미지 미리보기"
										class="process-preview-image">
								</td>
							</tr>
						</tbody>
					</table>
				</form>

				<p class="detail_help_text">수정 버튼을 클릭하면 공정 이미지 등록 영역이 표시됩니다.</p>
			</div>

			<div class="detail_card">
				<div class="process-card-head">
					<div class="detail_card_title">공정 이미지 목록</div>

					<button type="button"
						class="search-btn search-btn-sub"
						onclick="submitProcessImageDeleteForm();">
						선택 삭제
					</button>
				</div>

				<form id="processImageDeleteForm"
					action="${contextPath}/master/process/detail/delete"
					method="post"
					accept-charset="UTF-8">

					<input type="hidden" name="procId" value="${processDetail.procId}">

					<div class="coTableWrap">
						<table class="coTable">
							<colgroup>
								<col class="coColXs">
								<col class="coColMd">
								<col class="coColXl">
								<col class="coColMd">
								<col class="coColSm">
								<col class="coColSm">
							</colgroup>

							<thead>
								<tr>
									<th onclick="toggleAllProcessImageCheck();" title="전체 선택/해제">선택</th>
									<th>이미지</th>
									<th>상세설명</th>
									<th>비고</th>
									<th>등록일</th>
									<th>수정일</th>
								</tr>
							</thead>

							<tbody>
								<c:choose>
									<c:when test="${not empty processDetailList}">
										<c:forEach var="img" items="${processDetailList}">
											<tr>
												<td>
													<input type="checkbox"
														name="procDetailIdList"
														value="${img.procDetailId}">
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty img.procPicture}">
															<a href="${contextPath}${img.procPicture}" target="_blank">
																<img src="${contextPath}${img.procPicture}"
																	alt="공정 이미지"
																	class="process-thumb-image">
															</a>
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td class="coTextLeft" title="${img.procContent}">
													<c:choose>
														<c:when test="${not empty img.procContent}">
															<c:out value="${img.procContent}" />
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td title="${img.remark}">
													<c:choose>
														<c:when test="${not empty img.remark}">
															<c:out value="${img.remark}" />
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty img.createdDate}">
															<fmt:formatDate value="${img.createdDate}" pattern="yyyy-MM-dd" />
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>

												<td>
													<c:choose>
														<c:when test="${not empty img.updatedDate}">
															<fmt:formatDate value="${img.updatedDate}" pattern="yyyy-MM-dd" />
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="6" style="text-align: center;">
												등록된 공정 이미지가 없습니다.
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</form>
			</div>

		</c:when>

		<c:otherwise>
			<div class="detail_card">
				<div class="detail_card_title">조회 결과</div>
				<div class="detail_content_area">
					<div class="detail_empty_box">조회된 공정 상세정보가 없습니다.</div>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
</div>

<style>
.process-field-msg {
	display: none;
	color: #d93025;
	font-size: 12px;
	margin-top: 6px;
}

.process-card-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 12px;
	margin-bottom: 12px;
}

.process-card-head .detail_card_title {
	margin-bottom: 0;
}

.process-image-save-btn {
	width: 150px;
	white-space: nowrap;
}

.process-file-input {
	display: none;
}

.process-file-label {
	display: inline-flex;
	cursor: pointer;
	vertical-align: middle;
}

.process-file-name {
	margin-left: 10px;
	color: #6b7280;
	font-size: 13px;
	vertical-align: middle;
}

.process-preview-image {
	max-width: 240px;
	max-height: 160px;
	object-fit: cover;
	border-radius: 8px;
}

.process-thumb-image {
	width: 90px;
	height: 60px;
	object-fit: cover;
	border-radius: 8px;
}
</style>

<script>
	var procCodeTimer = null;
	var procCodeDuplicate = false;
	var procCodeCheckDone = false;
	var procCodeNameMap = {};

	function changeEditMode(isEdit) {
		if (!isEdit) {
			location.reload();
			return;
		}

		setDisplayById("editBtn", "none");
		setDisplayById("saveBtn", "inline-flex");
		setDisplayById("cancelBtn", "inline-flex");
		setDisplayById("processImageAddForm", "block");
		setDisplayById("imageSaveBtn", "inline-flex");

		document.querySelectorAll("[data-view-value]").forEach(function(el) {
			el.style.display = "none";
		});

		document.querySelectorAll("[data-edit-box]").forEach(function(el) {
			el.style.display = "block";
		});

		document.querySelectorAll("[data-edit-control]").forEach(function(el) {
			el.disabled = false;
		});

		setDisabledById("procImageFile", false);
		setDisabledById("processImageRemark", false);
		setDisabledById("processImageContent", false);

		handleItemChange();
		handleEquipChange();
	}

	function showFieldMsg(msgId, message) {
		var msgBox = document.getElementById(msgId);

		if (msgBox == null) {
			return;
		}

		if (message == null || message === "") {
			msgBox.style.display = "none";
			msgBox.textContent = "";
			return;
		}

		msgBox.style.display = "block";
		msgBox.textContent = message;
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

	function handleItemChange() {
		applySelectedItemInfo();
		validateRequiredField("itemId", "itemIdMsg", "완제품을 선택하세요.");

		var procCodeInput = document.getElementById("procCode");

		if (procCodeInput != null && procCodeInput.value.trim() !== "") {
			checkProcCodeDuplicate();
		}
	}

	function handleEquipChange() {
		applySelectedEquipmentInfo();
		validateRequiredField("equipId", "equipIdMsg", "설비를 선택하세요.");
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
		var itemSelect = document.getElementById("itemId");
		var procCodeInput = document.getElementById("procCode");
		var procId = "${processDetail.procId}";

		if (itemSelect == null || itemSelect.value === "") {
			procCodeDuplicate = false;
			procCodeCheckDone = false;

			if (procCodeInput != null && procCodeInput.value.trim() !== "") {
				showFieldMsg("procCodeMsg", "완제품을 먼저 선택하세요.");
			}

			if (callback != null) {
				callback(false);
			}

			return;
		}

		if (procCodeInput == null) {
			if (callback != null) {
				callback(false);
			}

			return;
		}

		var itemId = itemSelect.value;
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

		var url = "${contextPath}/master/process/checkProcCodeDuplicate"
			+ "?itemId=" + encodeURIComponent(itemId)
			+ "&procCode=" + encodeURIComponent(procCode)
			+ "&procId=" + encodeURIComponent(procId);

		fetch(url)
			.then(function(response) {
				return response.json();
			})
			.then(function(data) {
				procCodeDuplicate = data.duplicate === true;
				procCodeCheckDone = true;

				if (procCodeDuplicate) {
					showFieldMsg("procCodeMsg", data.message || "같은 완제품에 이미 존재하는 공정코드입니다.");
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

	function validateProcessModifyForm() {
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
				showFieldMsg("procCodeMsg", "같은 완제품에 이미 존재하는 공정코드입니다.");
				return;
			}

			document.getElementById("processModifyForm").submit();
		});

		return false;
	}

	function applySelectedItemInfo() {
		var option = getSelectedOption("itemId");

		if (option == null || option.value === "") {
			setTextById("viewItemCode", "-");
			setTextById("viewItemName", "-");
			setTextById("viewItemUnit", "-");
			setTextById("viewItemType", "-");
			return;
		}

		var itemCode = option.getAttribute("data-item-code");
		var itemName = option.getAttribute("data-item-name");
		var itemUnit = option.getAttribute("data-item-unit");
		var itemType = option.getAttribute("data-item-type");
		var itemTypeName = option.getAttribute("data-item-type-name");

		var typeText = "";

		if (itemTypeName != null && itemTypeName !== "") {
			typeText = itemTypeName;

			if (itemType != null && itemType !== "") {
				typeText += " (" + itemType + ")";
			}
		} else {
			typeText = itemType;
		}

		setTextById("viewItemCode", itemCode);
		setTextById("viewItemName", itemName);
		setTextById("viewItemUnit", itemUnit);
		setTextById("viewItemType", typeText);
	}

	function applySelectedEquipmentInfo() {
		var option = getSelectedOption("equipId");

		if (option == null || option.value === "") {
			setTextById("viewEquipCode", "-");
			setTextById("viewEquipName", "-");
			setHtmlById("viewEquipStatus", "-");
			setTextById("viewLineCode", "-");
			setTextById("viewLineName", "-");
			setHtmlById("viewLineStatus", "-");
			setTextById("viewEquipLoc", "-");
			return;
		}

		var equipCode = option.getAttribute("data-equip-code");
		var equipName = option.getAttribute("data-equip-name");
		var equipStatus = option.getAttribute("data-equip-status");
		var equipLoc = option.getAttribute("data-equip-loc");
		var lineCode = option.getAttribute("data-line-code");
		var lineName = option.getAttribute("data-line-name");
		var lineStatus = option.getAttribute("data-line-status");

		setTextById("viewEquipCode", equipCode);
		setTextById("viewEquipName", equipName);
		setHtmlById("viewEquipStatus", makeEquipStatusBadge(equipStatus));
		setTextById("viewLineCode", lineCode);
		setTextById("viewLineName", lineName);
		setHtmlById("viewLineStatus", makeLineStatusBadge(lineStatus));
		setTextById("viewEquipLoc", equipLoc);
	}

	function makeEquipStatusBadge(status) {
		if (status == null || status === "") {
			return "-";
		}

		if (status === "가동") {
			return '<span class="detail_status_badge detail_status_pass">가동</span>';
		}

		return '<span class="detail_status_badge detail_status_fail">' + escapeHtml(status) + '</span>';
	}

	function makeLineStatusBadge(status) {
		if (status == null || status === "") {
			return "-";
		}

		if (status === "LINE-RUN") {
			return '<span class="detail_status_badge detail_status_pass">가동</span>';
		}

		if (status === "LINE-IDLE") {
			return '<span class="detail_status_badge detail_status_fail">대기</span>';
		}

		return escapeHtml(status);
	}

	function validateProcessImageAddForm() {
		var fileInput = document.getElementById("procImageFile");
		var contentInput = document.getElementById("processImageContent");
		var remarkInput = document.getElementById("processImageRemark");

		var hasFile = fileInput != null && fileInput.value !== "";
		var hasContent = contentInput != null && contentInput.value.trim() !== "";
		var hasRemark = remarkInput != null && remarkInput.value.trim() !== "";

		if (!hasFile && !hasContent && !hasRemark) {
			showFieldMsg("procImageFileMsg", "이미지, 상세설명, 비고 중 하나 이상 입력하세요.");
			return false;
		}

		if (hasFile && !isImageFile(fileInput.value)) {
			showFieldMsg("procImageFileMsg", "이미지 파일만 업로드할 수 있습니다.");
			return false;
		}

		showFieldMsg("procImageFileMsg", "");
		return true;
	}

	function handleProcessImageFile() {
		var fileInput = document.getElementById("procImageFile");
		var fileNameBox = document.getElementById("procImageFileName");

		if (fileInput == null) {
			return;
		}

		if (fileInput.files == null || fileInput.files.length === 0) {
			if (fileNameBox != null) {
				fileNameBox.textContent = "선택된 파일 없음";
			}

			clearProcessImagePreview();
			return;
		}

		if (!isImageFile(fileInput.value)) {
			showFieldMsg("procImageFileMsg", "이미지 파일만 업로드할 수 있습니다.");
			fileInput.value = "";

			if (fileNameBox != null) {
				fileNameBox.textContent = "선택된 파일 없음";
			}

			clearProcessImagePreview();
			return;
		}

		showFieldMsg("procImageFileMsg", "");

		if (fileNameBox != null) {
			fileNameBox.textContent = fileInput.files[0].name;
		}

		previewProcessImage(fileInput.files[0]);
	}

	function previewProcessImage(file) {
		var previewRow = document.getElementById("processImagePreviewRow");
		var previewImage = document.getElementById("processImagePreview");

		if (previewRow == null || previewImage == null || file == null) {
			return;
		}

		var reader = new FileReader();

		reader.onload = function(e) {
			previewImage.src = e.target.result;
			previewRow.style.display = "";
		};

		reader.readAsDataURL(file);
	}

	function clearProcessImagePreview() {
		var previewRow = document.getElementById("processImagePreviewRow");
		var previewImage = document.getElementById("processImagePreview");

		if (previewRow != null) {
			previewRow.style.display = "none";
		}

		if (previewImage != null) {
			previewImage.src = "";
		}
	}

	function isImageFile(fileName) {
		if (fileName == null || fileName === "") {
			return false;
		}

		var lowerName = fileName.toLowerCase();

		return lowerName.endsWith(".jpg")
			|| lowerName.endsWith(".jpeg")
			|| lowerName.endsWith(".png")
			|| lowerName.endsWith(".gif")
			|| lowerName.endsWith(".webp");
	}

	function toggleAllProcessImageCheck() {
		var checkboxList = document.querySelectorAll("#processImageDeleteForm input[name='procDetailIdList']");

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

	function submitProcessImageDeleteForm() {
		var checkedList = document.querySelectorAll("#processImageDeleteForm input[name='procDetailIdList']:checked");

		if (checkedList.length === 0) {
			alert("삭제할 공정 이미지를 선택하세요.");
			return;
		}

		if (confirm("선택한 공정 이미지를 삭제하시겠습니까?")) {
			document.getElementById("processImageDeleteForm").submit();
		}
	}

	function getSelectedOption(selectId) {
		var select = document.getElementById(selectId);

		if (select == null || select.selectedIndex < 0) {
			return null;
		}

		return select.options[select.selectedIndex];
	}

	function setTextById(id, value) {
		var target = document.getElementById(id);

		if (target == null) {
			return;
		}

		if (value == null || value === "") {
			target.textContent = "-";
		} else {
			target.textContent = value;
		}
	}

	function setHtmlById(id, value) {
		var target = document.getElementById(id);

		if (target == null) {
			return;
		}

		if (value == null || value === "") {
			target.innerHTML = "-";
		} else {
			target.innerHTML = value;
		}
	}

	function setDisplayById(id, value) {
		var target = document.getElementById(id);

		if (target != null) {
			target.style.display = value;
		}
	}

	function setDisabledById(id, disabled) {
		var target = document.getElementById(id);

		if (target != null) {
			target.disabled = disabled;
		}
	}

	function escapeHtml(value) {
		if (value == null) {
			return "";
		}

		return String(value)
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;")
			.replace(/'/g, "&#039;");
	}
</script>