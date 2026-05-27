<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/detail.css">

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
									onclick="location.href='${pageContext.request.contextPath}/equipment_status/detail?history_id=${eqp.history_id}&mode=edit'">

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
									onclick="location.href='${pageContext.request.contextPath}/equipment_status/detail?history_id=${eqp.history_id}'">
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
										<th>시작일시</th>
										<td>
                                            <input type="text" name="time_start" value="${eqp.time_start}">
                                        </td>

										<th>종료일시</th>
										<td>
                                            <input type="text" name="time_end" value="${eqp.time_end}">
                                        </td>

										<th>적용 시간</th>
										<td>
                                            <input type="number" name="time_min" readonly>
                                        </td>
									</tr>

									<tr>

                                        <th>설비 상태</th>
										<td><select name="eqp_status">
                                            <option> 가동 </option>
                                            <option> 정비 </option>
                                            <option> 고장 </option>
                                        </select>
                                        </td>

										<th>비가동 이유</th>
										<td>
											<input type="text" name="down_reason" value="${eqp.down_reason}">
										</td>
										

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
									<th>가동 시간</th>
									<td>${eqp.runtime_min}</td>

									<th>비가동 시간</th>
									<td>${eqp.downtime_min}</td>

									<th>비가동 원인</th>
									<td>${eqp.down_reason}</td>
								</tr>

								<tr>
									<th>조치자</th>
									<td></td>

									<th>조치 내역</th>
									<td></td>

									<th>비고</th>
									<td>${eqp.remark}</td>
								</tr>
							</table>
						</div>
					</c:otherwise>

				</c:choose>

			</div>