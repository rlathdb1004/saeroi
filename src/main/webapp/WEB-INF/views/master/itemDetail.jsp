<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--
	파일명: itemDetail.jsp
	메뉴: 기준정보관리 > 품목관리 > 상세보기

	역할:
	- 품목관리 목록에서 "보기" 클릭 시 품목 상세정보를 출력한다.
	- 공용 CSS(coPageWrap, coTable, search-btn, coStatus)를 우선 사용한다.
	- 공용 CSS 파일은 수정하지 않는다.
--%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<div class="coPageWrap">

	<%-- =========================================================
	     1. 상단 제목 / 버튼 영역
	     ========================================================= --%>
	<div class="search-table-top item-detail-top">

		<div>
			<div class="item-detail-title">품목 상세보기</div>
			<div class="item-detail-path">기준정보관리 &gt; 품목관리 &gt; 상세보기</div>
		</div>

		<div class="search-btn-right">
			<button type="button" class="search-btn search-btn-sub"
				onclick="location.href='${contextPath}/master/item'">목록</button>
		</div>

	</div>


	<c:choose>

		<%-- =====================================================
		     2. 상세 정보가 있을 때
		     ===================================================== --%>
		<c:when test="${not empty itemDetail}">

			<%-- 기본 정보 --%>
			<div class="item-detail-section">
				<div class="item-detail-section-title">기본 정보</div>

				<div class="coTableWrap">
					<table class="coTable item-detail-table">
						<tbody>
							<tr>
								<th>품목 ID</th>
								<td>${itemDetail.itemId}</td>

								<th>품목코드</th>
								<td>${itemDetail.itemCode}</td>
							</tr>

							<tr>
								<th>품목명</th>
								<td colspan="3">${itemDetail.itemName}</td>
							</tr>

							<tr>
								<th>품목구분</th>
								<td><span class="coStatus coStatusUse"> <c:choose>
											<c:when test="${not empty itemDetail.itemTypeName}">
												${itemDetail.itemTypeName}
											</c:when>
											<c:otherwise>
												${itemDetail.itemType}
											</c:otherwise>
										</c:choose>
								</span> <span class="item-detail-code"> (${itemDetail.itemType})
								</span></td>

								<th>사용여부</th>
								<td><c:choose>
										<c:when test="${itemDetail.useYn == 'Y'}">
											<span class="coStatus coStatusUse"> <c:choose>
													<c:when test="${not empty itemDetail.useYnName}">
														${itemDetail.useYnName}
													</c:when>
													<c:otherwise>사용</c:otherwise>
												</c:choose>
											</span>
										</c:when>

										<c:otherwise>
											<span class="coStatus coStatusStop"> <c:choose>
													<c:when test="${not empty itemDetail.useYnName}">
														${itemDetail.useYnName}
													</c:when>
													<c:otherwise>미사용</c:otherwise>
												</c:choose>
											</span>
										</c:otherwise>
									</c:choose> <span class="item-detail-code"> (${itemDetail.useYn}) </span>
								</td>
							</tr>

							<tr>
								<th>안전재고</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.safetyStock}">
											<fmt:formatNumber value="${itemDetail.safetyStock}"
												pattern="#,##0" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>단위</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.itemUnit}">
											${itemDetail.itemUnit}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


			<%-- 거래처 정보 --%>
			<div class="item-detail-section">
				<div class="item-detail-section-title">거래처 정보</div>

				<div class="coTableWrap">
					<table class="coTable item-detail-table">
						<tbody>
							<tr>
								<th>공급처 ID</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.supplierId}">
											${itemDetail.supplierId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>공급처명</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.supplierName}">
											${itemDetail.supplierName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>납품처 ID</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.clientId}">
											${itemDetail.clientId}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>납품처명</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.deliveryClientName}">
											${itemDetail.deliveryClientName}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


			<%-- 관리 정보 --%>
			<div class="item-detail-section">
				<div class="item-detail-section-title">관리 정보</div>

				<div class="coTableWrap">
					<table class="coTable item-detail-table">
						<tbody>
							<tr>
								<th>등록일</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.createdDate}">
											<fmt:formatDate value="${itemDetail.createdDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>

								<th>수정일</th>
								<td><c:choose>
										<c:when test="${not empty itemDetail.updatedDate}">
											<fmt:formatDate value="${itemDetail.updatedDate}"
												pattern="yyyy-MM-dd" />
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>

							<tr>
								<th>비고</th>
								<td colspan="3"><c:choose>
										<c:when test="${not empty itemDetail.remark}">
											${itemDetail.remark}
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


			<%-- 하단 버튼 --%>
			<div class="item-detail-bottom-btn">
				<button type="button" class="search-btn search-btn-sub"
					onclick="location.href='${contextPath}/master/item'">목록으로
				</button>
			</div>

		</c:when>


		<%-- =====================================================
		     3. 상세 정보가 없을 때
		     ===================================================== --%>
		<c:otherwise>

			<div class="coTableWrap">
				<table class="coTable">
					<tbody>
						<tr>
							<td style="text-align: center;">조회된 품목 상세정보가 없습니다.</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="item-detail-bottom-btn">
				<button type="button" class="search-btn search-btn-sub"
					onclick="location.href='${contextPath}/master/item'">목록으로
				</button>
			</div>

		</c:otherwise>

	</c:choose>

</div>
