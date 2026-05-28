<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/detail.css">

			<div class="detail_page">

				<div class="detail_header">

					<div>
						<h2 class="detail_title">설비 상세</h2>
						<div class="detail_path">설비관리 > 설비관리 > 설비 상세</div>

					</div>

					<div class="detail_btn_area">
						<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
									or sessionScope.loginUser.role eq 'MANAGER'}">
							<c:if test="${mode ne 'edit'}">
								<button type="button" class="detail_btn_green"
									onclick="location.href='${pageContext.request.contextPath}/equipment/detail?equip_id=${eqp.equip_id}&mode=edit'">

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
									onclick="location.href='${pageContext.request.contextPath}/equipment/detail?equip_id=${eqp.equip_id}'">
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
							onclick="location.href='${pageContext.request.contextPath}/equipment/equipment'">

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
							action="${pageContext.request.contextPath}/equipment/update">

							<input type="hidden" name="equip_id" value="${eqp.equip_id}">
							

							<div class="detail_card">

								<div class="detail_card_title">기본 정보</div>
								<table class="detail_info_table">
									<tr>
										<th>설비코드</th>
										<td>${eqp.equip_code}</td>

										<th>설비명</th>
										<td><input type="text" name="equip_name" value="${eqp.equip_name}"></td>

										<th>상태</th>
										<td><input type="text" name="equip_status" value="${eqp.equip_status}"></td>
									</tr>

									<tr>
										<th>제조사</th>
										<td><select name="client_id">
												<c:forEach var="client" items="${clientList}">
													<option value="${client.client_id}"
														${client.client_id==eqp.client_id ? 'selected' : '' }>
														${client.client_name}</option>
												</c:forEach>
											</select></td>

										<th>설비 가격</th>
										<td><input type="number" name="equip_price" value="${eqp.equip_price}"></td>

										<th>구매일</th>
										<td><input type="date" name="buy_date" value="${eqp.buy_date}"></td>
									</tr>

									<tr>
										<th>위치</th>
										<td>
											<select name="line_id">
												<c:forEach var="line" items="${lineList}">
													<option value="${line.line_id}" ${line.line_id==eqp.line_id
														? 'selected' : '' }>
														${line.line_name}
													</option>
												</c:forEach>
											</select>
										</td>

										<th>수정일</th>
										<td><fmt:formatDate value="${eqp.updated_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>

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

									<th>상태</th>
									<td>${eqp.equip_status}</td>
								</tr>

								<tr>
									<th>제조사</th>
									<td>${eqp.client_name}</td>

									<th>설비 가격</th>
									<td>
										<fmt:formatNumber value="${eqp.equip_price}" pattern="#,###" />
									</td>

									<th>구매일</th>
									<td>${eqp.buy_date}</td>
								</tr>

								<tr>
									<th>설비 위치</th>
									<td>${eqp.equip_loc}</td>

									<th>수정일</th>
									<td><fmt:formatDate value="${eqp.updated_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
									
									<th>비고</th>
									<td>${eqp.remark}</td>
								</tr>
							</table>
						</div>
					</c:otherwise>

				</c:choose>

			</div>