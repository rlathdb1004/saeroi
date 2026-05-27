<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: masterDefectCodeDetail.jsp
	메뉴: 기준정보관리 > 불량코드관리 > 불량코드 상세

	기준:
	- 기존 DefectDTO / 품질관리 불량관리 기능과 충돌 방지를 위해 MasterDefectCode 명칭 사용
	- 품목관리 itemDetail.jsp / masterClientDetail.jsp / masterEquipmentDetail.jsp 구조 중심 적용
	- 공용 detail.css 클래스명 사용
	- 불량코드와 불량코드구분은 기준코드이므로 상세 수정 화면에서는 변경하지 않음
	- 실제 삭제 없음. 목록에서 선택삭제 시 use_yn = 'N' 처리
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${not empty masterDefectCodeDetail.createdDate}">
	<fmt:formatDate var="createdDateValue"
		value="${masterDefectCodeDetail.createdDate}" pattern="yyyy-MM-dd" />
</c:if>

<c:if test="${not empty masterDefectCodeDetail.updatedDate}">
	<fmt:formatDate var="updatedDateValue"
		value="${masterDefectCodeDetail.updatedDate}" pattern="yyyy-MM-dd" />
</c:if>

<link rel="stylesheet"
	href="${contextPath}/resources/css/common/detail.css">

<div class="detail_page">

	<div class="detail_header">
		<div>
			<h2 class="detail_title">불량코드 상세</h2>
			<div class="detail_path">기준정보관리 &gt; 불량코드관리 &gt; 불량코드 상세</div>
		</div>

		<div class="detail_btn_area">

			<c:if test="${not empty masterDefectCodeDetail}">

				<button type="button" id="editBtn" class="detail_btn_green"
					onclick="changeEditMode(true);">
					<svg class="detail_btn_icon" viewBox="0 0 24 24" aria-hidden="true">
						<path d="M12 20h9"></path>
						<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
					</svg>
					수정
				</button>

				<button type="submit" id="saveBtn" class="detail_btn_green"
					form="masterDefectCodeModifyForm" style="display: none;">
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
				onclick="location.href='${contextPath}/master/defectcode'">
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

		<c:when test="${not empty masterDefectCodeDetail}">

			<form id="masterDefectCodeModifyForm"
				action="${contextPath}/master/defectcode/modify" method="post"
				accept-charset="UTF-8"
				onsubmit="return validateMasterDefectCodeModifyForm();">

				<input type="hidden" name="defectId"
					value="${masterDefectCodeDetail.defectId}" />

				<%-- 불량코드와 불량코드구분은 상세 수정에서 변경하지 않는다. --%>
				<input type="hidden" name="defectCode"
					value="${masterDefectCodeDetail.defectCode}" />

				<input type="hidden" name="defectCodePrefix"
					value="${masterDefectCodeDetail.defectCodePrefix}" />


				<div class="detail_card">

					<div class="detail_card_title">불량코드 기본 정보</div>

					<table class="detail_info_table">
						<tbody>

							<tr>
								<th>불량코드 ID</th>
								<td>${masterDefectCodeDetail.defectId}</td>

								<th>불량코드구분</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterDefectCodeDetail.defectCodePrefix}">
											${masterDefectCodeDetail.defectCodePrefix}<c:choose><c:when test="${masterDefectCodeDetail.defectCodePrefix == 'DCD-DIM'}">(치수)</c:when><c:when test="${masterDefectCodeDetail.defectCodePrefix == 'DCD-CUT'}">(재단)</c:when><c:when test="${masterDefectCodeDetail.defectCodePrefix == 'DCD-ADH'}">(접착)</c:when><c:when test="${masterDefectCodeDetail.defectCodePrefix == 'DCD-CONT'}">(오염)</c:when><c:when test="${masterDefectCodeDetail.defectCodePrefix == 'DCD-CRK'}">(크랙)</c:when><c:when test="${masterDefectCodeDetail.defectCodePrefix == 'DEF-BAR'}">(바코드)</c:when></c:choose>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>불량코드</th>
								<td>
									<c:choose>
										<c:when test="${not empty masterDefectCodeDetail.defectCode}">
											${masterDefectCodeDetail.defectCode}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
							</tr>


							<tr>
								<th>불량유형</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterDefectCodeDetail.defectType}">
												${masterDefectCodeDetail.defectType}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="defectType" id="defectType"
											class="detail_input"
											value="${masterDefectCodeDetail.defectType}"
											maxlength="30" data-edit-control disabled required />
									</div>
								</td>

								<th>불량명</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterDefectCodeDetail.defectName}">
												${masterDefectCodeDetail.defectName}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<input type="text" name="defectName" id="defectName"
											class="detail_input"
											value="${masterDefectCodeDetail.defectName}"
											maxlength="100" data-edit-control disabled required />
									</div>
								</td>

								<th>사용여부</th>
								<td>
									<span data-view-value>
										<c:choose>
											<c:when test="${masterDefectCodeDetail.useYn == 'Y'}">
												<span class="detail_status_badge detail_status_pass">사용</span>
											</c:when>
											<c:when test="${masterDefectCodeDetail.useYn == 'N'}">
												<span class="detail_status_badge detail_status_fail">미사용</span>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<select name="useYn" id="useYn" class="detail_select"
											data-edit-control disabled>
											<option value="Y"
												<c:if test="${masterDefectCodeDetail.useYn == 'Y'}">selected</c:if>>
												사용
											</option>
											<option value="N"
												<c:if test="${masterDefectCodeDetail.useYn == 'N'}">selected</c:if>>
												미사용
											</option>
										</select>
									</div>
								</td>
							</tr>


							<tr>
								<th>등록일</th>
								<td>
									<c:choose>
										<c:when test="${not empty createdDateValue}">
											${createdDateValue}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th>수정일</th>
								<td>
									<c:choose>
										<c:when test="${not empty updatedDateValue}">
											${updatedDateValue}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>

								<th></th>
								<td></td>
							</tr>


							<tr>
								<th>비고</th>
								<td colspan="5">
									<span data-view-value>
										<c:choose>
											<c:when test="${not empty masterDefectCodeDetail.remark}">
												${masterDefectCodeDetail.remark}
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>

									<div data-edit-box style="display: none;">
										<textarea name="remark" id="remark"
											class="detail_textarea"
											maxlength="500"
											data-edit-control disabled>${masterDefectCodeDetail.remark}</textarea>
									</div>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="detail_help_text">
						불량코드와 불량코드구분은 기준코드이므로 상세 수정 화면에서는 변경하지 않습니다.
					</div>

				</div>

			</form>

		</c:when>

		<c:otherwise>
			<div class="detail_card">
				<div class="detail_empty_box">
					조회된 불량코드 정보가 없습니다.
				</div>
			</div>
		</c:otherwise>

	</c:choose>

</div>


<script>
	/*
	 * 상세 수정 모드 전환
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

		document.getElementById("editBtn").style.display =
			isEdit ? "none" : "inline-flex";

		document.getElementById("saveBtn").style.display =
			isEdit ? "inline-flex" : "none";

		document.getElementById("cancelBtn").style.display =
			isEdit ? "inline-flex" : "none";
	}


	/*
	 * 수정 검증
	 */
	function validateMasterDefectCodeModifyForm() {

		var defectType = document.getElementById("defectType").value.trim();
		var defectName = document.getElementById("defectName").value.trim();

		if (defectType === "") {
			alert("불량유형을 입력해 주세요.");
			document.getElementById("defectType").focus();
			return false;
		}

		if (defectName === "") {
			alert("불량명을 입력해 주세요.");
			document.getElementById("defectName").focus();
			return false;
		}

		if (!confirm("불량코드 정보를 수정하시겠습니까?")) {
			return false;
		}

		return true;
	}
</script>