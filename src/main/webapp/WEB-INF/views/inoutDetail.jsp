<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>



<div class="coPageWrap">

	<div class="inoutDetailWrap">

		<c:choose>

			<c:when test="${mode eq 'edit'}">

				<!-- 수정 화면 form -->
				<form method="post"
					action="${pageContext.request.contextPath}/inventory/materialIn/update">

					<input type="hidden"
						name="inoutId"
						value="${inout.inoutId}">

					<!-- 수정 중 버튼 -->
					<div class="inoutDetailBtnArea">

						<button type="submit"
							class="inoutMainBtn">
							수정완료
						</button>

						<button type="button"
							class="inoutSubBtn"
							onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}'">
							취소
						</button>

						<button type="button"
							class="inoutSubBtn"
							onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">
							목록
						</button>

					</div>

					<table class="inoutDetailTable">

						<tr>
							<th>입출고번호</th>
							<td>${inout.docNo}</td>
						</tr>

						<tr>
							<th>품목코드</th>
							<td>${inout.itemCode}</td>
						</tr>

						<tr>
							<th>품목명</th>
							<td>${inout.itemName}</td>
						</tr>

						<tr>
							<th>품목유형</th>
							<td>
								<c:choose>
									<c:when test="${inout.itemType eq 'FG'}">완제품</c:when>
									<c:when test="${inout.itemType eq 'RM'}">원자재</c:when>
									<c:when test="${inout.itemType eq 'SM'}">부자재</c:when>
									<c:otherwise>${inout.itemType}</c:otherwise>
								</c:choose>
							</td>
						</tr>

						<tr>
							<th>단위</th>
							<td>${inout.itemUnit}</td>
						</tr>

						<tr>
							<th>입출고구분</th>
							<td>
								<select name="inoutType"
									class="inoutEditSelect">

									<option value="MI"
										<c:if test="${inout.inoutType eq 'MI'}">selected</c:if>>
										입고
									</option>

									<option value="MO-PROD"
										<c:if test="${inout.inoutType eq 'MO-PROD'}">selected</c:if>>
										출고
									</option>

								</select>
							</td>
						</tr>

						<tr>
							<th>수량</th>
							<td>
								<input type="number"
									name="inoutQty"
									class="inoutEditInput"
									value="${inout.inoutQty}">
							</td>
						</tr>

						<tr>
							<th>입출고일자</th>
							<td>
								<input type="date"
									name="inoutDate"
									class="inoutEditInput"
									value="${inout.inoutDate}">
							</td>
						</tr>

						<tr>
							<th>LOT번호</th>
							<td>${inout.materialLot}</td>
						</tr>

						<tr>
							<th>상태</th>
							<td>${inout.status}</td>
						</tr>

						<tr>
							<th>비고</th>
							<td>
								<textarea name="remark"
									class="inoutEditTextarea">${inout.remark}</textarea>
							</td>
						</tr>

					</table>

				</form>

			</c:when>

			<c:otherwise>

				<!-- 조회 화면 버튼 -->
				<div class="inoutDetailBtnArea">

					<button type="button"
						class="inoutMainBtn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn/detail?inoutId=${inout.inoutId}&mode=edit'">
						수정
					</button>

					<button type="button"
						class="inoutSubBtn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">
						목록
					</button>

				</div>

				<table class="inoutDetailTable">

					<tr>
						<th>입출고번호</th>
						<td>${inout.docNo}</td>
					</tr>

					<tr>
						<th>품목코드</th>
						<td>${inout.itemCode}</td>
					</tr>

					<tr>
						<th>품목명</th>
						<td>${inout.itemName}</td>
					</tr>

					<tr>
						<th>품목유형</th>
						<td>
							<c:choose>
								<c:when test="${inout.itemType eq 'FG'}">완제품</c:when>
								<c:when test="${inout.itemType eq 'RM'}">원자재</c:when>
								<c:when test="${inout.itemType eq 'SM'}">부자재</c:when>
								<c:otherwise>${inout.itemType}</c:otherwise>
							</c:choose>
						</td>
					</tr>

					<tr>
						<th>단위</th>
						<td>${inout.itemUnit}</td>
					</tr>

					<tr>
						<th>입출고구분</th>
						<td>
							<c:choose>
								<c:when test="${inout.inoutType eq 'MI'}">입고</c:when>
								<c:when test="${inout.inoutType eq 'MO-PROD'}">출고</c:when>
								<c:otherwise>${inout.inoutType}</c:otherwise>
							</c:choose>
						</td>
					</tr>

					<tr>
						<th>수량</th>
						<td>${inout.inoutQty}</td>
					</tr>

					<tr>
						<th>입출고일자</th>
						<td>${inout.inoutDate}</td>
					</tr>

					<tr>
						<th>LOT번호</th>
						<td>${inout.materialLot}</td>
					</tr>

					<tr>
						<th>상태</th>
						<td>${inout.status}</td>
					</tr>

					<tr>
						<th>비고</th>
						<td>${inout.remark}</td>
					</tr>

				</table>

			</c:otherwise>

		</c:choose>

	</div>

</div>