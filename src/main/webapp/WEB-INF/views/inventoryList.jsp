<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<c:choose>

		<c:when test="${mode eq 'edit'}">

			<form method="post"
				action="${pageContext.request.contextPath}/inventory/stockList/update">

				<input type="hidden"
					name="inventoryId"
					value="${inventory.inventoryId}">

				<div class="coTableTop">

					<p class="coTotalCount">
						재고 상세정보
					</p>

					<div class="search-btn-right">

						<button type="submit"
							class="search-btn search-btn-main">
							수정완료
						</button>

						<button type="button"
							class="search-btn search-btn-sub"
							onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}'">
							취소
						</button>

						<button type="button"
							class="search-btn search-btn-sub"
							onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">
							목록
						</button>

					</div>

				</div>

				<div class="coTableWrap">

					<table class="coTable">

						<tr>
							<th>재고번호</th>
							<td>${inventory.inventoryId}</td>
						</tr>

						<tr>
							<th>품목코드</th>
							<td>${inventory.itemCode}</td>
						</tr>

						<tr>
							<th>품목명</th>
							<td>${inventory.itemName}</td>
						</tr>

						<tr>
							<th>품목유형</th>
							<td>${inventory.itemType}</td>
						</tr>

						<tr>
							<th>현재재고</th>
							<td>
								<input type="number"
									name="inventoryStock"
									class="search-input"
									value="${inventory.inventoryStock}">
							</td>
						</tr>

						<tr>
							<th>단위</th>
							<td>${inventory.itemUnit}</td>
						</tr>

						<tr>
							<th>창고위치</th>
							<td>
								<input type="text"
									name="stockLocation"
									class="search-input"
									value="${inventory.stockLocation}">
							</td>
						</tr>

						<tr>
							<th>비고</th>
							<td>
								<input type="text"
									name="remark"
									class="search-input"
									value="${inventory.remark}">
							</td>
						</tr>

						<tr>
							<th>생성일</th>
							<td>${inventory.createdDate}</td>
						</tr>

						<tr>
							<th>수정일</th>
							<td>${inventory.updatedDate}</td>
						</tr>

					</table>

				</div>

			</form>

		</c:when>

		<c:otherwise>

			<div class="coTableTop">

				<p class="coTotalCount">
					재고 상세정보
				</p>

				<div class="search-btn-right">

					<button type="button"
						class="search-btn search-btn-main"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}&mode=edit'">
						수정
					</button>

					<button type="button"
						class="search-btn search-btn-sub"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">
						목록
					</button>

				</div>

			</div>

			<div class="coTableWrap">

				<table class="coTable">

					<tr>
						<th>재고번호</th>
						<td>${inventory.inventoryId}</td>
					</tr>

					<tr>
						<th>품목코드</th>
						<td>${inventory.itemCode}</td>
					</tr>

					<tr>
						<th>품목명</th>
						<td>${inventory.itemName}</td>
					</tr>

					<tr>
						<th>품목유형</th>
						<td>${inventory.itemType}</td>
					</tr>

					<tr>
						<th>현재재고</th>
						<td>${inventory.inventoryStock}</td>
					</tr>

					<tr>
						<th>단위</th>
						<td>${inventory.itemUnit}</td>
					</tr>

					<tr>
						<th>창고위치</th>
						<td>${inventory.stockLocation}</td>
					</tr>

					<tr>
						<th>비고</th>
						<td>${inventory.remark}</td>
					</tr>

					<tr>
						<th>생성일</th>
						<td>${inventory.createdDate}</td>
					</tr>

					<tr>
						<th>수정일</th>
						<td>${inventory.updatedDate}</td>
					</tr>

				</table>

			</div>

		</c:otherwise>

	</c:choose>

</div>