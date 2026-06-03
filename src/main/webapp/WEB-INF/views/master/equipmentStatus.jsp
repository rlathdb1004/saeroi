<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


		<c:set var="isAdmin" value="${
		sessionScope.loginUser.role eq 'ADMIN'
		or sessionScope.loginUser.role eq 'MANAGER'
        }" />

		<div class="coPageWrap">

			<form class="search-form" method="get"
				action="${pageContext.request.contextPath}/equipment/equipmentstatus">

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
								<option value="operation_date" <c:if test="${searchType eq 'operation_date'}">selected
									</c:if>>
									가동 일자
								</option>
								<option value="down_reason" <c:if test="${searchType eq 'down_reason'}">selected</c:if>>
									비가동이유
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
								onclick="location.href='${pageContext.request.contextPath}/equipment/equipmentstatus'">
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

			<form method="post" id="deleteForm" action="${pageContext.request.contextPath}/equipment_status/delete">

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
								<th class="mobile_show">가동일자</th>
								<th class="mobile_show">가동 시간</th>
								<th class="mobile_hidden">비가동 시간</th>
								<th class="mobile_hidden">비가동이유</th>
								<th class="mobile_show">상세</th>
							</tr>
						</thead>

						<tbody>

							<c:forEach var="eqp" items="${list}">
								<tr>
									<td class="mobile_show"><input type="checkbox" name="history_ids"
											value="${eqp.history_id}"></td>

									<td class="mobile_hidden">${eqp.equip_code}</td>
									<td class="mobile_show">${eqp.equip_name}</td>
									<td class="mobile_show">${eqp.operation_date}</td>
									<td class="mobile_show">${eqp.runtime_min}</td>
									<td class="mobile_hidden">${eqp.downtime_min}</td>
									<td class="mobile_hidden">${eqp.down_reason}</td>

									<td class="mobile_show">
										<button type="button" class="coDetailBtn"
											onclick="location.href='${pageContext.request.contextPath}/equipment/equipmentstatus/detail?history_id=${eqp.history_id}'">
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
							<h3 class="modal_title">설비 가동 현황 등록</h3>
						</div>

						<form class="modal_form" method="post"
							action="${pageContext.request.contextPath}/equipment_status/insert"
							onsubmit="return checkEquipmentInsert();">

							<div class="modal_body modal_body_2col">

								<div class="modal_item">
									<label class="modal_label">
										설비코드<span class="modal_required">*</span>
									</label>
									<select name="equip_id" class="modal_select id_select" required>
										<option value="">선택</option>
										<c:forEach var="eqp" items="${list}">
											<option value="${eqp.equip_id}" data-name="${eqp.equip_name}">
												${eqp.equip_code}
											</option>
										</c:forEach>
									</select>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비명<span class="modal_required">*</span>
									</label>
									<input type="text" name="equip_name" class="modal_input eqp_name" readonly>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										가동일자<span class="modal_required">*</span>
									</label>
									<input type="date" name="operation_date" class="modal_input" required>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비 계획 가동 시간<span class="modal_required">*</span>
									</label>
									<input type="number" name="plan_time_min" class="modal_input" required>
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비 가동 시간
									</label>
									<input type="number" name="runtime_min" class="modal_input">
								</div>

								<div class="modal_item">
									<label class="modal_label">
										설비 비 가동 시간<span class="modal_required">
									</label>
									<input type="number" name="downtime_min" class="modal_input" >
								</div>

								<div class="modal_item">
									<label class="modal_label">비가동 이유</label>
									<input type="text" name="down_reason" class="modal_input" min="1">
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

				var checks = document.getElementsByName("history_ids");
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

			document.querySelector(".id_select").addEventListener("change", function () {
				const selectedOption = this.options[this.selectedIndex];
				const equipName = selectedOption.getAttribute("data-name");
				document.querySelector(".eqp_name").value =
					equipName || "";
			});

			const plantime = document.querySelector("input[name='plan_time_min']");
			const downtime = document.querySelector("input[name='downtime_min']");
			const runtime = document.querySelector("input[name='runtime_min']");

			function calcRuntime() {
				const p = Number(plantime.value) || 0;
				const d = Number(downtime.value) || 0;
				runtime.value = Math.max(0, p - d);
			}
			plantime.addEventListener("input", calcRuntime);
			downtime.addEventListener("input", calcRuntime);

		</script>