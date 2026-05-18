<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="coPageWrap">

	<div class="coTableTop">

		<p class="coTotalCount">
			입출고 상세정보
		</p>

		<div>
			<button type="button"
				class="inoutSubBtn"
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
					<td>${inout.inoutType}</td>
				</tr>

				<tr>
					<th>품목코드</th>
					<td>${inout.itemCode}</td>
					<th>품목명</th>
					<td>${inout.itemName}</td>
				</tr>

				<tr>
					<th>품목유형</th>
					<td>${inout.itemType}</td>
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