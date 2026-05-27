<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: masterClientDetail.jsp
	메뉴: 기준정보관리 > 거래처관리 > 거래처 상세

	기준:
	- 기존 ClientDTO / ClientDAO와 충돌 방지를 위해 MasterClient 명칭 사용
	- 품목관리 itemDetail.jsp 구조 중심 적용
	- 공용 detail.css 사용
	- 거래처구분은 client_code prefix 기준으로 표시
	- 상세 수정 화면에서는 거래처코드와 거래처구분은 변경하지 않음
	- 실제 삭제 없음. 목록에서 선택삭제 시 use_yn = 'N' 처리
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">거래처 상세</h2>
			<div class="detail_path">기준정보관리 &gt; 거래처관리 &gt; 거래처 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty masterClientDetail}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="masterClientModifyForm" style="display: none;">
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
				onclick="location.href='${contextPath}/master/client'">
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

		<c:when test="${not empty masterClientDetail}">

			<form id="masterClientModifyForm"
				action="${contextPath}/master/client/modify" method="post"
				accept-charset="UTF-8"
				onsubmit="return validateMasterClientModifyForm();">

				<input type="hidden" name="clientId"
					value="${masterClientDetail.clientId}" />

				<%-- 거래처코드와 거래처구분은 상세 수정에서 변경하지 않는다. --%>
				<input type="hidden" name="clientCode"
					value="${masterClientDetail.clientCode}" /> <input type="hidden"
					name="clientCodePrefix"
					value="${masterClientDetail.clientCodePrefix}" /> <input
					type="hidden" name="clientType"
					value="${masterClientDetail.clientType}" />


				<div class="detail_card">

					<div class="detail_card_title">거래처 기본 정보</div>

					<table class="detail_info_table">
						<tbody>
							<tr>
								<th>거래처 ID</th>
								<td>${masterClientDetail.clientId}</td>

								<th>거래처구분</th>
								<td><c:choose>
										<c:when test="${not empty masterClientDetail.clientTypeName}">
											${masterClientDetail.clientTypeName}
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${not empty masterClientDetail.clientType}">
													${masterClientDetail.clientType}
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose></td>

								<th>거래처코드</th>
								<td><c:choose>
										<c:when test="${not empty masterClientDetail.clientCode}">
											${masterClientDetail.clientCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>거래처명</th>
								<td colspan="3"><span data-view-value> <c:choose>
											<c:when test="${not empty masterClientDetail.clientName}">
												${masterClientDetail.clientName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="clientName" id="clientName"
											class="detail_input" value="${masterClientDetail.clientName}"
											maxlength="100" data-edit-control disabled required />
									</div></td>

								<th>사용여부</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${masterClientDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">사용</span>
											</c:when>
											<c:when test="${masterClientDetail.useYn == 'N'}">
												<span class="detail_status_badge detail_status_fail">미사용</span>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<select name="useYn" id="useYn" class="detail_select"
											data-edit-control disabled>
											<option value="Y"
												<c:if test="${masterClientDetail.useYn == 'Y'}">selected</c:if>>
												사용</option>
											<option value="N"
												<c:if test="${masterClientDetail.useYn == 'N'}">selected</c:if>>
												미사용</option>
										</select>
									</div></td>
							</tr>

							<tr>
								<th>담당자</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty masterClientDetail.clientMan}">
												${masterClientDetail.clientMan}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="clientMan" id="clientMan"
											class="detail_input" value="${masterClientDetail.clientMan}"
											maxlength="50" data-edit-control disabled />
									</div></td>

								<th>전화번호</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty masterClientDetail.clientTel}">
												${masterClientDetail.clientTel}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="clientTel" id="clientTel"
											class="detail_input" value="${masterClientDetail.clientTel}"
											maxlength="30" data-edit-control disabled />
									</div></td>

								<th>담당부서</th>
								<td><span data-view-value> <c:choose>
											<c:when test="${not empty masterClientDetail.clientDept}">
												${masterClientDetail.clientDept}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="clientDept" id="clientDept"
											class="detail_input" value="${masterClientDetail.clientDept}"
											maxlength="50" data-edit-control disabled />
									</div></td>
							</tr>

							<tr>
								<th>주소</th>
								<td colspan="5"><span data-view-value> <c:choose>
											<c:when test="${not empty masterClientDetail.clientAdress}">
												${masterClientDetail.clientAdress}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="clientAdress" id="clientAdress"
											class="detail_input"
											value="${masterClientDetail.clientAdress}" maxlength="200"
											data-edit-control disabled />
									</div></td>
							</tr>

							<tr>
								<th>등록일</th>
								<td><c:choose>
										<c:when test="${not empty masterClientDetail.createdDate}">
											<fmt:formatDate value="${masterClientDetail.createdDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>수정일</th>
								<td><c:choose>
										<c:when test="${not empty masterClientDetail.updatedDate}">
											<fmt:formatDate value="${masterClientDetail.updatedDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>코드 Prefix</th>
								<td><c:choose>
										<c:when
											test="${not empty masterClientDetail.clientCodePrefix}">
											<c:choose>
												<c:when
													test="${masterClientDetail.clientCodePrefix == 'BP-SUP'}">
													BP-SUP(공급처)
												</c:when>
												<c:when
													test="${masterClientDetail.clientCodePrefix == 'BP-CUS'}">
													BP-CUS(납품처)
												</c:when>
												<c:otherwise>
													${masterClientDetail.clientCodePrefix}
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>비고</th>
								<td colspan="5"><span data-view-value> <c:choose>
											<c:when test="${not empty masterClientDetail.remark}">
												${masterClientDetail.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
								</span>

									<div data-edit-box style="display: none;">
										<textarea name="remark" id="remark" class="detail_textarea"
											maxlength="500" data-edit-control disabled>${masterClientDetail.remark}</textarea>
									</div></td>
							</tr>
						</tbody>
					</table>
				</div>


				<div class="detail_card">

					<div class="detail_card_title">연결 정보</div>

					<table class="detail_info_table">
						<tbody>
							<tr>
								<th>연결 품목 수</th>
								<td><c:choose>
										<c:when test="${not empty masterClientDetail.itemCount}">
											<fmt:formatNumber value="${masterClientDetail.itemCount}"
												pattern="#,###" /> 건
										</c:when>
										<c:otherwise>0 건</c:otherwise>
									</c:choose></td>

								<th>연결 설비 수</th>
								<td><c:choose>
										<c:when test="${not empty masterClientDetail.equipmentCount}">
											<fmt:formatNumber
												value="${masterClientDetail.equipmentCount}" pattern="#,###" /> 건
										</c:when>
										<c:otherwise>0 건</c:otherwise>
									</c:choose></td>

								<th>삭제 기준</th>
								<td>실제 삭제하지 않고 미사용 처리</td>
							</tr>
						</tbody>
					</table>

				</div>


				<div class="detail_card">

					<div class="detail_card_title">운영 참고</div>

					<table class="detail_info_table">
						<tbody>
							<tr>
								<th>거래처구분 기준</th>
								<td colspan="5">거래처구분은 별도 고정 코드가 아니라 거래처코드의 prefix로 관리합니다.
									예: BP-SUP, BP-CUS, BP-MAN</td>
							</tr>

							<tr>
								<th>신규 구분 추가</th>
								<td colspan="5">등록 화면에서 기존 거래처구분을 선택하거나 신규 거래처구분을 직접 입력할 수
									있습니다. 신규 입력 시 BP-는 생략할 수 있으며, 서버에서 BP- prefix를 보정합니다.</td>
							</tr>

							<tr>
								<th>거래처코드 규칙</th>
								<td colspan="5">거래처코드는 거래처구분 prefix + 일련번호 3자리로 생성됩니다. 예:
									BP-SUP-001, BP-CUS-001</td>
							</tr>

							<tr>
								<th>미사용 처리</th>
								<td colspan="5">거래처는 품목의 공급처/납품처 또는 설비 제조사로 참조될 수 있으므로 실제
									삭제하지 않고 미사용 처리합니다.</td>
							</tr>
						</tbody>
					</table>

				</div>

			</form>

		</c:when>

		<c:otherwise>

			<div class="detail_card">
				<div class="detail_empty_box">조회된 거래처 정보가 없습니다.</div>
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
	 * 거래처 수정 검증
	 */
	function validateMasterClientModifyForm() {

		var clientName = getTrimValue("clientName");

		if (clientName === "") {
			alert("거래처명을 입력해 주세요.");
			document.getElementById("clientName").focus();
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