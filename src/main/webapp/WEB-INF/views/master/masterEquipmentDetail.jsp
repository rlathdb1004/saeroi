<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: masterEquipmentDetail.jsp
	메뉴: 기준정보관리 > 설비관리 > 설비 상세

	기준:
	- 사이드바 설비관리 업무 메뉴와 충돌 방지를 위해 masterEquipment 명칭 사용
	- 품목관리 itemDetail.jsp 구조 중심 적용
	- 공용 detail.css 사용
	- 설비구분은 equip_code prefix 기준으로 표시
	- 신규 설비구분은 등록 화면에서 직접 입력 가능
	- 상세 수정 화면에서는 설비코드와 설비구분은 변경하지 않음
	- 실제 삭제 없음. 목록에서 선택삭제 시 use_yn = 'N' 처리
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${not empty masterEquipmentDetail.buyDate}">
	<fmt:formatDate var="buyDateValue"
		value="${masterEquipmentDetail.buyDate}" pattern="yyyy-MM-dd" />
</c:if>

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">설비 상세</h2>
			<div class="detail_path">기준정보관리 &gt; 설비관리 &gt; 설비 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty masterEquipmentDetail}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg class="detail_btn_icon" viewBox="0 0 24 24"
						aria-hidden="true">
						<path d="M12 20h9"></path>
						<path
							d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="masterEquipmentModifyForm" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24"
						aria-hidden="true">
						<path
							d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
						<path d="M17 21v-8H7v8"></path>
						<path d="M7 3v5h8"></path>
					</svg>
					저장
				</button>

				<button type="button" id="cancelBtn" class="detail_btn_line"
					onclick="location.reload();" style="display: none;">
					<svg class="detail_btn_icon" viewBox="0 0 24 24"
						aria-hidden="true">
						<path d="M18 6L6 18"></path>
						<path d="M6 6l12 12"></path>
					</svg>
					취소
				</button>

			</c:if>

			<button type="button" class="detail_btn_line"
				onclick="location.href='${contextPath}/master/equipment'">
				<svg class="detail_btn_icon" viewBox="0 0 24 24"
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

		<c:when test="${not empty masterEquipmentDetail}">

			<form id="masterEquipmentModifyForm"
				action="${contextPath}/master/equipment/modify" method="post"
				accept-charset="UTF-8"
				onsubmit="return validateMasterEquipmentModifyForm();">

				<input type="hidden" name="equipId"
					value="${masterEquipmentDetail.equipId}" />

				<%-- 설비코드와 설비구분은 상세 수정에서 변경하지 않는다. --%>
				<input type="hidden" name="equipCode"
					value="${masterEquipmentDetail.equipCode}" />

				<input type="hidden" name="equipCodePrefix"
					value="${masterEquipmentDetail.equipCodePrefix}" />

				<div class="detail_card">

					<div class="detail_card_title">설비 기본 정보</div>

					<table class="detail_info_table">
						<tbody>
							<tr>
								<th>설비 ID</th>
								<td>${masterEquipmentDetail.equipId}</td>

								<th>설비구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterEquipmentDetail.equipCodePrefix}">
											${masterEquipmentDetail.equipCodePrefix}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>설비코드</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterEquipmentDetail.equipCode}">
											${masterEquipmentDetail.equipCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>설비명</th>
								<td colspan="3">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.equipName}">
												${masterEquipmentDetail.equipName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="equipName" id="equipName"
											class="detail_input"
											value="${masterEquipmentDetail.equipName}"
											maxlength="100" data-edit-control disabled required />
									</div>
								</td>

								<th>설비상태</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${masterEquipmentDetail.equipStatus == '가동'}">
												<span class="detail_status_badge detail_status_pass">가동</span>
											</c:when>
											<c:when test="${masterEquipmentDetail.equipStatus == '점검'}">
												<span class="detail_status_badge detail_status_conditional">점검</span>
											</c:when>
											<c:otherwise>
												<span class="detail_status_badge detail_status_fail">
													<c:choose>
														<c:when test="${not empty masterEquipmentDetail.equipStatus}">
															${masterEquipmentDetail.equipStatus}
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</span>
											</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="equipStatus" id="equipStatus"
											class="detail_select" data-edit-control disabled required>
											<option value="가동"
												<c:if test="${masterEquipmentDetail.equipStatus == '가동'}">selected</c:if>>
												가동
											</option>
											<option value="비가동"
												<c:if test="${masterEquipmentDetail.equipStatus == '비가동'}">selected</c:if>>
												비가동
											</option>
											<option value="점검"
												<c:if test="${masterEquipmentDetail.equipStatus == '점검'}">selected</c:if>>
												점검
											</option>
											<option value="고장"
												<c:if test="${masterEquipmentDetail.equipStatus == '고장'}">selected</c:if>>
												고장
											</option>
										</select>
									</div>
								</td>
							</tr>

							<tr>
								<th>라인</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.lineName}">
												${masterEquipmentDetail.lineName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="lineId" id="lineId" class="detail_select"
											data-edit-control disabled required>
											<option value="">선택</option>

											<c:forEach var="line" items="${lineList}">
												<option value="${line.line_id}"
													<c:if test="${line.line_id == masterEquipmentDetail.lineId}">selected</c:if>>
													${line.line_name}
												</option>
											</c:forEach>
										</select>
									</div>
								</td>

								<th>제조사</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.clientName}">
												${masterEquipmentDetail.clientName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="clientId" id="clientId"
											class="detail_select" data-edit-control disabled required>
											<option value="">선택</option>

											<c:forEach var="client" items="${clientList}">
												<option value="${client.clientId}"
													<c:if test="${client.clientId == masterEquipmentDetail.clientId}">selected</c:if>>
													${client.clientName}
												</option>
											</c:forEach>
										</select>
									</div>
								</td>

								<th>사용여부</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${masterEquipmentDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">사용</span>
											</c:when>
											<c:when test="${masterEquipmentDetail.useYn == 'N'}">
												<span class="detail_status_badge detail_status_fail">미사용</span>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="useYn" id="useYn" class="detail_select"
											data-edit-control disabled>
											<option value="Y"
												<c:if test="${masterEquipmentDetail.useYn == 'Y'}">selected</c:if>>
												사용
											</option>
											<option value="N"
												<c:if test="${masterEquipmentDetail.useYn == 'N'}">selected</c:if>>
												미사용
											</option>
										</select>
									</div>
								</td>
							</tr>

							<tr>
								<th>설치위치</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.equipLoc}">
												${masterEquipmentDetail.equipLoc}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="equipLoc" id="equipLoc"
											class="detail_input"
											value="${masterEquipmentDetail.equipLoc}"
											maxlength="100" data-edit-control disabled />
									</div>
								</td>

								<th>설비금액</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.equipPrice}">
												<fmt:formatNumber value="${masterEquipmentDetail.equipPrice}"
													pattern="#,###" /> 원
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="number" name="equipPrice" id="equipPrice"
											class="detail_input"
											value="${masterEquipmentDetail.equipPrice}"
											min="0" data-edit-control disabled />
									</div>
								</td>

								<th>구매일</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.buyDate}">
												<fmt:formatDate value="${masterEquipmentDetail.buyDate}"
													pattern="yyyy-MM-dd" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="date" name="buyDate" id="buyDate"
											class="detail_input"
											value="${buyDateValue}"
											data-edit-control disabled />
									</div>
								</td>
							</tr>

							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterEquipmentDetail.createdDate}">
											<fmt:formatDate value="${masterEquipmentDetail.createdDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterEquipmentDetail.updatedDate}">
											<fmt:formatDate value="${masterEquipmentDetail.updatedDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>거래처구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterEquipmentDetail.clientType}">
											${masterEquipmentDetail.clientType}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>

							<tr>
								<th>비고</th>
								<td colspan="5">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterEquipmentDetail.remark}">
												${masterEquipmentDetail.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<textarea name="remark" id="remark"
											class="detail_textarea" maxlength="500"
											data-edit-control disabled>${masterEquipmentDetail.remark}</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>


				<div class="detail_card">

					<div class="detail_card_title">운영 참고</div>

					<table class="detail_info_table">
						<tbody>
							<tr>
								<th>설비구분 기준</th>
								<td colspan="5">
									설비구분은 별도 고정 코드가 아니라 설비코드의 prefix로 관리합니다.
									예: EQ-CUT, EQ-LAM, EQ-DRY, EQ-ROBOT-ARM
								</td>
							</tr>

							<tr>
								<th>신규 구분 추가</th>
								<td colspan="5">
									등록 화면에서 기존 설비구분을 선택하거나 신규 설비구분을 직접 입력할 수 있습니다.
									신규 입력 시 EQ-는 생략할 수 있으며, 서버에서 EQ- prefix를 보정합니다.
								</td>
							</tr>

							<tr>
								<th>설비코드 규칙</th>
								<td colspan="5">
									설비코드는 설비구분 prefix + 일련번호 3자리로 생성됩니다.
									예: EQ-CUT-001, EQ-DRY-001
								</td>
							</tr>

							<tr>
								<th>삭제 기준</th>
								<td colspan="5">
									설비는 공정, 가동이력, 정비이력, 고장이력에서 참조될 수 있으므로 실제 삭제하지 않고 미사용 처리합니다.
								</td>
							</tr>
						</tbody>
					</table>

				</div>

			</form>

		</c:when>

		<c:otherwise>

			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 설비 정보가 없습니다.
				</div>
			</div>

		</c:otherwise>

	</c:choose>

</div>


<script>
	/*
	 * 상세/수정 모드 전환
	 */
	function changeEditMode(isEdit) {

		var viewValueList = document.querySelectorAll("[data-view-value]");
		var editBoxList = document.querySelectorAll("[data-edit-box]");
		var editControlList = document.querySelectorAll("[data-edit-control]");

		for (var i = 0; i < viewValueList.length; i++) {
			viewValueList[i].style.display = isEdit ? "none" : "";
		}

		for (var j = 0; j < editBoxList.length; j++) {
			editBoxList[j].style.display = isEdit ? "block" : "none";
		}

		for (var k = 0; k < editControlList.length; k++) {
			editControlList[k].disabled = !isEdit;
		}

		var editBtn = document.getElementById("editBtn");
		var saveBtn = document.getElementById("saveBtn");
		var cancelBtn = document.getElementById("cancelBtn");

		if (editBtn != null) {
			editBtn.style.display = isEdit ? "none" : "inline-flex";
		}

		if (saveBtn != null) {
			saveBtn.style.display = isEdit ? "inline-flex" : "none";
		}

		if (cancelBtn != null) {
			cancelBtn.style.display = isEdit ? "inline-flex" : "none";
		}
	}


	/*
	 * 설비 수정 검증
	 */
	function validateMasterEquipmentModifyForm() {

		var equipName = getTrimValue("equipName");
		var lineId = getTrimValue("lineId");
		var clientId = getTrimValue("clientId");
		var equipStatus = getTrimValue("equipStatus");
		var equipPrice = getTrimValue("equipPrice");

		if (equipName === "") {
			alert("설비명을 입력해 주세요.");
			document.getElementById("equipName").focus();
			return false;
		}

		if (lineId === "") {
			alert("라인을 선택해 주세요.");
			document.getElementById("lineId").focus();
			return false;
		}

		if (clientId === "") {
			alert("제조사를 선택해 주세요.");
			document.getElementById("clientId").focus();
			return false;
		}

		if (equipStatus === "") {
			alert("설비상태를 선택해 주세요.");
			document.getElementById("equipStatus").focus();
			return false;
		}

		if (equipPrice !== "" && Number(equipPrice) < 0) {
			alert("설비금액은 0 이상으로 입력해 주세요.");
			document.getElementById("equipPrice").focus();
			return false;
		}

		return true;
	}


	function getTrimValue(elementId) {

		var element = document.getElementById(elementId);

		if (element == null || element.value == null) {
			return "";
		}

		return element.value.trim();
	}
</script>