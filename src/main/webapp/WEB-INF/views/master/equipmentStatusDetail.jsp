<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/detail.css">

			<style>
				.detail_card_title {
					display: flex;
					align-items: center;
					justify-content: space-between;
					font-size: 18px;
					font-weight: 600;
					margin-bottom: 14px;
				}

				.detail_add_btn {
					display: inline-flex;
					align-items: center;
					gap: 6px;

					padding: 7px 14px;

					border: none;
					border-radius: 6px;

					background: #2f7d62;
					color: #fff;

					font-size: 14px;
					font-weight: 500;

					cursor: pointer;
					transition: 0.2s;
				}

				.detail_add_btn svg {
					width: 16px;
					height: 16px;
				}
			</style>

			<div class="detail_page">

				<div class="detail_header">

					<div>
						<h2 class="detail_title">설비 가동 현황 상세</h2>
						<div class="detail_path">설비관리 > 설비관리 > 설비 가동 현황 상세</div>

					</div>

					<div class="detail_btn_area">
						<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
									or sessionScope.loginUser.role eq 'MANAGER'}">
							<c:if test="${mode ne 'edit'}">
								<button type="button" class="detail_btn_green"
									onclick="location.href='${pageContext.request.contextPath}/equipment/equipmentstatus/detail?history_id=${eqp.history_id}&mode=edit'">

									<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
										stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
										style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
										<path d="M12 20h9"></path>
										<path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
									</svg>
									수정
								</button>

							</c:if>

							<c:if test="${mode eq 'edit'}">
								<button type="submit" class="detail_btn_green" form="updateForm">
									<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
										stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
										style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
										<path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
										</path>
										<path d="M17 21v-8H7v8"></path>
										<path d="M7 3v5h8"></path>
									</svg>
									저장
								</button>

								<button type="button" class="detail_btn_line"
									onclick="location.href='${pageContext.request.contextPath}/equipment/equipmentstatus/detail?history_id=${eqp.history_id}'">
									<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
										stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
										style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
										<path d="M18 6L6 18"></path>
										<path d="M6 6l12 12"></path>
									</svg>
									취소
								</button>

							</c:if>

						</c:if>

						<button type="button" class="detail_btn_line"
							onclick="location.href='${pageContext.request.contextPath}/equipment/equipmentstatus'">

							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								style="vertical-align: -3px; margin-right: 6px;" aria-hidden="true">
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

				<c:choose>
					<c:when test="${mode eq 'edit'}">

						<form id="updateForm" method="post"
							action="${pageContext.request.contextPath}/equipment_status/update">

							<input type="hidden" name="history_id" value="${eqp.history_id}">
							<input type="hidden" name="equip_id" value="${eqp.equip_id}">

							<div class="detail_card">

								<div class="detail_card_title">기본 정보</div>
								<table class="detail_info_table">
									<tr>
										<th>설비코드</th>
										<td>${eqp.equip_code}</td>
										<th>설비명</th>
										<td>${eqp.equip_name}</td>
										<th>작동 일자</th>
										<td>${eqp.operation_date}</td>
									</tr>

									<tr>
										<th>계획 가동 시간</th>
										<td>${eqp.plan_time_min}</td>
										<th>가동 시간</th>
										<td>
											<input type="number" name="runtime_min" value="${eqp.runtime_min}">
										</td>
										<th>비가동 시간</th>
										<td>
											<input type="number" name="downtime_min" value="${eqp.downtime_min}">
										</td>
									</tr>

									<tr>
										<th>비가동 이유</th>
										<td>
											<input type="text" name="down_reason" value="${eqp.down_reason}">
										</td>

										<th>DOC 번호</th>
										<td>${eqp.doc_no}</td>

										<th>비고</th>
										<td><input type="text" name="remark" value="${eqp.remark}">
										</td>
									</tr>
								</table>
							</div>
						</form>
					</c:when>

					<c:otherwise>
						<div class="detail_card">
							<div class="detail_card_title">기본 정보</div>
							<table class="detail_info_table">
								<tr>
									<th>설비코드</th>
									<td>${eqp.equip_code}</td>

									<th>설비명</th>
									<td>${eqp.equip_name}</td>

									<th>작동 일자</th>
									<td>${eqp.operation_date}</td>
								</tr>

								<tr>
									<th>계획 가동 시간</th>
									<td>${eqp.plan_time_min}</td>

									<th>가동 시간</th>
									<td>${eqp.runtime_min}</td>

									<th>비가동 시간</th>
									<td>${eqp.downtime_min}</td>
								</tr>

								<tr>
									<th>비가동 원인</th>
									<td>${eqp.down_reason}</td>

									<th>DOC 번호</th>
									<td>${eqp.doc_no}</td>

									<th>비고</th>
									<td>${eqp.remark}</td>
								</tr>
							</table>
						</div>


						<div class="detail_card">
							<div class="detail_card_title">
								정비 이력
								<button type="button" class="detail_add_btn modal_open_btn"
									data_modal_target="#eqp_main_insert">

									<svg viewBox="0 0 24 24" fill="none">
										<path d="M12 5V19" stroke="currentColor" stroke-width="2"
											stroke-linecap="round">
										</path>

										<path d="M5 12H19" stroke="currentColor" stroke-width="2"
											stroke-linecap="round">
										</path>
									</svg>

									등록
								</button>

							</div>

							<table class="detail_info_table">
								<c:choose>
									<c:when test="${not empty maintenanceList}">
										<tr>
											<th>정비 종류</th>
											<th>정비 내용</th>
											<th>정비자</th>
											<th>정비 시간</th>
											<th>비고</th>
											
										</tr>

										<c:forEach var="m" items="${maintenanceList}">
											<tr>
												<td>${m.equip_main_type}</td>
												<td>${m.equip_main_content}</td>
												<td>${m.ename}</td>
												<td>${m.equip_main_time}</td>
												<td>${m.remark}</td>

												<!-- <td>
													<button type="button" class="coDetailBtn"
														onclick="location.href='${pageContext.request.contextPath}/equipment/equipmentstatus/main_detail?equip_main_id=${eqp.equip_main_id}'">
														보기</button>
												</td> -->
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="5" style="text-align:center;">
												정비 이력이 없습니다.
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</table>
						</div>


						<div class="detail_card">
							<div class="detail_card_title">
								고장 이력
								<button type="button" class="detail_add_btn modal_open_btn"
									data_modal_target="#eqp_trouble_insert">

									<svg viewBox="0 0 24 24" fill="none">
										<path d="M12 5V19" stroke="currentColor" stroke-width="2"
											stroke-linecap="round">
										</path>

										<path d="M5 12H19" stroke="currentColor" stroke-width="2"
											stroke-linecap="round">
										</path>
									</svg>

									등록
								</button>
							</div>

							<table class="detail_info_table">
								<c:choose>
									<c:when test="${not empty troubleList}">
										<tr>
											<th>고장원인</th>
											<th>고장일시</th>
											<th>작업자</th>
											<th>해결방안</th>
											<th>해결일시</th>
											<th>비고</th>
										</tr>
										<c:forEach var="t" items="${troubleList}">
											<tr>
												<td>${t.trouble_content}</td>
												<td>
													<fmt:formatDate value="${t.trouble_date}"
														pattern="yyyy-MM-dd HH:mm" />
												</td>
												<td>${t.ename}</td>
												<td>${t.trouble_resolve}</td>												
												<td>
													<c:if test="${not empty t.resolve_date}">
														<fmt:formatDate value="${t.resolve_date}"
															pattern="yyyy-MM-dd HH:mm" />
													</c:if>
												</td>
												<td>${t.remark}</td>
											</tr>
										</c:forEach>
									</c:when>

									<c:otherwise>
										<tr>
											<td colspan="6" style="text-align:center;">
												고장 이력이 없습니다.
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</table>
						</div>
					</c:otherwise>

				</c:choose>

				<%-- 공통 모달 구조 사용 --%>
					<div id="eqp_main_insert" class="modal_wrap" aria-hidden="true">
						<div class="modal_box" role="dialog" aria-modal="true">

							<div class="modal_header">
								<h3 class="modal_title">설비 정비 이력 등록</h3>
							</div>

							<form class="modal_form" method="post"
								action="${pageContext.request.contextPath}/equipment_maintenance/insert"
								onsubmit="return checkEquipmentInsert();">

								<div class="modal_body modal_body_2col">
									<input type="hidden" name="equip_id" value="${eqp.equip_id}">
									<input type="hidden" name="history_id" value="${eqp.history_id}">

									<div class="modal_item">
										<label class="modal_label">
											설비명<span class="modal_required">*</span>
										</label>
										<input type="text" name="equip_name" value="${eqp.equip_name}"
											class="modal_input eqp_name" readonly>
									</div>

									<div class="modal_item">
										<label class="modal_label">
											작업자<span class="modal_required">*</span>
										</label>
										<select name="emp_id" class="modal_select id_select" required>
											<option value="">선택</option>
											<c:forEach var="emp" items="${empList}">
												<option value="${emp.emp_id}">
													${emp.ename}
												</option>
											</c:forEach>
										</select>
									</div>

									<div class="modal_item">
										<label class="modal_label">
											정비 일자<span class="modal_required">*</span>
										</label>
										<input type="date" name="equip_main_date" class="modal_input" required>
									</div>

									<div class="modal_item">
										<label class="modal_label">
											정비 타입<span class="modal_required">*</span>
										</label>
										<input type="text" name="equip_main_type" class="modal_input" required>
									</div>

									<div class="modal_item">
										<label class="modal_label">
											정비 내용<span class="modal_required">*</span>
										</label>
										<input type="text" name="equip_main_content" class="modal_input" required>
									</div>

									<div class="modal_item">
										<label class="modal_label">
											정비 시간<span class="modal_required">*</span>
										</label>
										<input type="number" name="equip_main_time" class="modal_input" required>
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

					<%-- 공통 모달 구조 사용 --%>
						<div id="eqp_trouble_insert" class="modal_wrap" aria-hidden="true">

							<div class="modal_box" role="dialog" aria-modal="true">

								<div class="modal_header">
									<h3 class="modal_title">설비 고장 이력 등록</h3>
								</div>

								<form class="modal_form" method="post"
									action="${pageContext.request.contextPath}/equipment_trouble/insert"
									onsubmit="return checkEquipmentInsert();">

									<div class="modal_body modal_body_2col">
										<input type="hidden" name="equip_id" value="${eqp.equip_id}">
										<input type="hidden" name="history_id" value="${eqp.history_id}">

										<div class="modal_item">
											<label class="modal_label">
												설비명<span class="modal_required">*</span>
											</label>
											<input type="text" name="equip_name" value="${eqp.equip_name}"
												class="modal_input eqp_name" readonly>
										</div>

										<div class="modal_item">
											<label class="modal_label">
												고장 발생일<span class="modal_required">*</span>
											</label>
											<input type="datetime-local" name="trouble_date" class="modal_input"
												required>
										</div>

										<div class="modal_item">
											<label class="modal_label">
												고장 내용<span class="modal_required">*</span>
											</label>
											<input type="text" name="trouble_content" class="modal_input" required>
										</div>

										<div class="modal_item">
											<label class="modal_label">
												작업자<span class="modal_required">*</span>
											</label>
											<select name="emp_id" class="modal_select id_select" required>
												<option value="">선택</option>
												<c:forEach var="emp" items="${empList}">
													<option value="${emp.emp_id}">
														${emp.ename}
													</option>
												</c:forEach>
											</select>
										</div>

										<div class="modal_item">
											<label class="modal_label">
												해결 방법
											</label>
											<input type="text" name="trouble_resolve" class="modal_input">
										</div>

										<div class="modal_item">
											<label class="modal_label">
												고장 해결일
											</label>
											<input type="datetime-local" name="resolve_date" class="modal_input">
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

			</div>

			<script>
				const planTime = ${ eqp.plan_time_min };

				const downtime = document.querySelector("input[name='downtime_min']");
				const runtime = document.querySelector("input[name='runtime_min']");

				if (downtime && runtime) {
					function calcRuntime() {
						const d = Number(downtime.value) || 0;
						runtime.value = Math.max(0, planTime - d);
					}
					downtime.addEventListener("input", calcRuntime);
				}
			</script>