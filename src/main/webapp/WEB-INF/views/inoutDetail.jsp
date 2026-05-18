<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
	/* 상세페이지 목록 버튼 */
	.inoutDetailListBtn {
		background-color: #2F7D62;
		color: white;
		border: none;
		border-radius: 7px;
		padding: 8px 22px;
		font-weight: bold;
		cursor: pointer;
	}
</style>

<div class="coPageWrap">

	<div class="coTableTop">

		<p class="coTotalCount">
			입출고 상세정보
		</p>

		<div>
			<button type="button"
				class="inoutDetailListBtn"
				onclick="location.href='${pageContext.request.contextPath}/inventory/materialIn'">
				목록
			</button>
		</div>

	</div>

	<div class="coTableWrap">

		<table class="coTable">

			<tbody>

				<tr>
					<th>입출고번호</th>
					<td>${inout.docNo}</td>
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
					<th>품목코드</th>
					<td>${inout.itemCode}</td>
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
					<th>단위</th>
					<td>${inout.itemUnit}</td>
				</tr>

				<tr>
					<th>입출고량</th>
					<td>${inout.inoutQty}</td>
					<th>입출고일자</th>
					<td>${inout.inoutDate}</td>
				</tr>

				<tr>
					<th>LOT번호</th>
					<td>${inout.materialLot}</td>
					<th>상태</th>
					<td>${inout.status}</td>
				</tr>

				<tr>
					<th>비고</th>
					<td colspan="3">${inout.remark}</td>
				</tr>

			</tbody>

		</table>

	</div>

</div>