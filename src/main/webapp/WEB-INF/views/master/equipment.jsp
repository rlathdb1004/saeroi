<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


		<c:set var="isAdmin" value="${
		sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'
        }" />

		<div class="coPageWrap">

			<form class="search-form" method="get" action="${pageContext.request.contextPath}/equipment/equipment">

				<div class="search-box">
					<div class="search-row">

						<div class="search-item">
							<label class="search-label">구분</label>
							<select name="searchType" class="search-select">

								<option value="all">전체</option>

								<option value="equip_code" <c:if test="${searchType eq 'equip_code'}">selected</c:if>>
									설비코드
								</option>
								<option value="equip_name" <c:if test="${searchType eq 'equip_name'}">selected</c:if>>
									설비명
								</option>
								<option value="equip_status" <c:if test="${searchType eq 'equip_status'}">selected
									</c:if>>
									설비 상태
								</option>
								<option value="equip_loc" <c:if test="${searchType eq 'equip_loc'}">selected</c:if>>
									설비 위치
								</option>
								<option value="client_name" <c:if test="${searchType eq 'client_name'}">selected</c:if>>
									제조사
								</option>

							</select>
						</div>

						<div class="search-item">
							<label class="search-label">검색어</label> <input type="text" name="keyword"
								class="search-input" placeholder="검색키워드" value="${keyword}">
						</div>

						<div class="search-btn-wrap">

							<button type="submit" class="search-btn 	search-btn-main">

								<svg viewBox="0 0 24 24" fill="none">
									<circle cx="10.5" cy="10.5" r="7.5" stroke="currentColor" stroke-width="2">
									</circle>

									<path d="M16 16L21 21" stroke="currentColor" stroke-width="2"
										stroke-linecap="round">
									</path>
								</svg>

								검색
							</button>

							<button type="button" class="search-btn search-btn-sub search-reset-btn"
								onclick="location.href='${pageContext.request.contextPath}/equipment/equipment'">

								<svg viewBox="0 0 24 24" fill="none">
									<path
										d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
										stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>

									<path d="M18 4V7H21" stroke="currentColor" stroke-width="2" stroke-linecap="round"
										stroke-linejoin="round">
									</path>
								</svg>

								초기화
							</button>

						</div>

					</div>
				</div>

			</form>

			<form method="post" id="deleteForm" action="${pageContext.request.contextPath}/equipment/delete">

				<div class="coTableTop">

					<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

					<c:if test="${isAdmin}">
						<div class="search-btn-right">
							<button type="button" class="search-btn search-btn-main modal_open_btn"
								data_modal_target="#modal_insert">

								<svg viewBox="0 0 24 24" fill="none" width="18" height="18">
									<path d="M12 5V19" stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>

									<path d="M5 12H19" stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>
								</svg>

								등록
							</button>

							<button type="button" class="search-btn search-btn-sub" onclick="deleteCheck()">
								<svg viewBox="0 0 24 24" fill="none">
									<path d="M4 7H20" stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>

									<path d="M10 11V17" stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>

									<path d="M14 11V17" stroke="currentColor" stroke-width="2" stroke-linecap="round">
									</path>

									<path d="M6 7L7 21H17L18 7" stroke="currentColor" stroke-width="2"
										stroke-linejoin="round">
									</path>

									<path d="M9 7V4H15V7" stroke="currentColor" stroke-width="2"
										stroke-linejoin="round">
									</path>
								</svg>
								선택 삭제
							</button>
						</div>
					</c:if>

				</div>

				<div class="coTableWrap">

					<table class="coTable">
						<thead>
							<tr>
								<th class="mobile_show"><label id="checkAllLabel">선택</label>

									<input type="checkbox" id="checkAll" style="display: none;">
								</th>

								<th class="mobile_hidden">설비 코드</th>
								<th class="mobile_show">설비명</th>
								<th class="mobile_show">설비 상태</th>
								<th class="mobile_hidden">설치 위치</th>
								<th class="mobile_hidden">제조사</th>
								<th class="mobile_show">비고</th>
								<th class="mobile_show">상세</th>
							</tr>
						</thead>

						<tbody>

							<c:forEach var="eqp" items="${list}">

								<tr>

									<td class="mobile_show"><input type="checkbox" name="eqp_ids"
											value="${eqp.equip_id}"></td>

									<td class="mobile_hidden">${eqp.equip_code}</td>
									<td class="mobile_show">${eqp.equip_name}</td>
									<td class="mobile_show">${eqp.equip_status}</td>
									<td class="mobile_hidden">${eqp.equip_loc}</td>
									<td class="mobile_hidden">${eqp.client_name}</td>
									<td class="mobile_show">${eqp.remark}</td>

									<td class="mobile_show">
										<button type="button" class="coDetailBtn"
											onclick="location.href='${pageContext.request.contextPath}/equipment/detail?equip_id=${eqp.equip_id}'">
											보기</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</form>

			<%-- 공통 모달 구조 사용 --%>
				<div id="modal_insert" class="modal_wrap" aria-hidden="true">

					<div class="modal_box" role="dialog" aria-modal="true">

						<div class="modal_header">
							<h3 class="modal_title">설비 등록</h3>
						</div>

						<form class="modal_form" method="post"
							action="${pageContext.request.contextPath}/equipment/insert"
							onsubmit="return checkEquipmentInsert();">

							<div class="modal_body modal_body_2col">

								<div class="modal_item">
									<label class="modal_label">
										설비코드<span class="modal_required">*</span>
									</label>

									<input type="text" name="equip_code" class="modal_input" required>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비명<span class="modal_required">*</span>
									</label>

									<input type="text" name="equip_name" class="modal_input" required>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비 상태<span class="modal_required">*</span>
									</label>

									<select name="equip_status" class="modal_select" required>
										<option value="가동">가동</option>
										<option value="비가동">비가동</option>
									</select>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비 위치<span class="modal_required">*</span>
									</label>

									<select name="line_id" class="modal_select" required>
										<option value="">선택</option>
										<c:forEach var="line" items="${lineList}">
											<option value="${line.line_id}">
												${line.line_name}
											</option>
										</c:forEach>
									</select>
								</div>

								<div class="modal_item">
									<label class="modal_label">제조사<span class="modal_required">*</span></label>
									<select name="client_id" class="modal_select" required>

										<option value="">선택</option>
										<c:forEach var="client" items="${clientList}">
											<option value="${client.client_id}">
												${client.client_name}
											</option>
										</c:forEach>

									</select>

								</div>

								<div class="modal_item">
									<label class="modal_label">설비 가격</label>

									<input type="number" name="equip_price" class="modal_input" min="1">
								</div>

								<div class="modal_item">
									<label class="modal_label">구매일</label>

									<input type="date" name="buy_date" class="modal_input">
								</div>

								<div class="modal_item">
									<label class="modal_label">비고</label>

									<input type="text" name="remark" class="modal_input">
								</div>

							</div>

							<div class="modal_footer">

								<button type="button" class="modal_btn modal_btn_cancel modal_close_btn">
									취소
								</button>

								<button type="submit" class="modal_btn modal_btn_submit">
									등록
								</button>

							</div>

						</form>
					</div>
				</div>

				<jsp:include page="/WEB-INF/views/common/paging.jsp" />

		</div>

		<script>
			document.getElementById("checkAllLabel").onclick = function () {

				var checkAll = document.getElementById("checkAll");

				var checks = document.getElementsByName("eqp_ids");

				checkAll.checked = !checkAll.checked;

				for (var i = 0; i < checks.length; i++) {

					checks[i].checked = checkAll.checked;
				}
			};

			var checks = document.getElementsByName("eqp_ids");

			for (var i = 0; i < checks.length; i++) {

				checks[i].onclick = function () {

					var allChecked = true;

					for (var j = 0; j < checks.length; j++) {

						if (!checks[j].checked) {
							allChecked = false;
							break;
						}
					}

					document.getElementById("checkAll").checked = allChecked;
				};
			}

			function deleteCheck() {

				var checks = document.getElementsByName("eqp_ids");

				var checked = false;

				for (var i = 0; i < checks.length; i++) {

					if (checks[i].checked) {
						checked = true;
					}
				}

				if (!checked) {
					alert("삭제할 항목을 선택해주세요.");
					return;
				}

				if (confirm("선택한 항목을 삭제하시겠습니까?")) {
					document.getElementById("deleteForm").submit();
				}
			}
		</script>