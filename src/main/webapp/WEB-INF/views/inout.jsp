<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="coPageWrap">

	<div class="coSearchBox">

		<label>품목명</label>
		<select>
			<option>전체</option>
			<option>EPDM 원단</option>
			<option>실리콘 접착제</option>
			<option>절연가스켓</option>
		</select>

		<label>시작일</label>
		<input type="date">

		<label>종료일</label>
		<input type="date">

		<input type="text" placeholder="검색키워드">

		<button type="button">검색</button>
		<button type="button">초기화</button>

	</div>

	<div class="coTableTop">

		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>

		<div>
			<button type="button">등록</button>
			<button type="button">선택 삭제</button>
		</div>

	</div>

	<div class="coTableWrap">

		<table class="coTable">
			<thead>
				<tr>
					<th><input type="checkbox" id="checkAll"></th>
					<th>NO</th>
					<th>입출고구분</th>
					<th>품목코드</th>
					<th>품목유형</th>
					<th>품목명</th>
					<th>입출고량</th>
					<th>단위</th>
					<th>일자</th>
					<th>상세보기</th>
				</tr>
			</thead>

			<tbody>
				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td>1</td>
					<td>입고</td>
					<td>RM-001</td>
					<td>원자재</td>
					<td>EPDM 원단</td>
					<td>500</td>
					<td>KG</td>
					<td>2026-05-15</td>
					<td><button type="button">상세보기</button></td>
				</tr>
			</tbody>
		</table>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script>
	document.getElementById("checkAll").onclick = function() {
		var checks = document.getElementsByName("rowCheck");

		for (var i = 0; i < checks.length; i++) {
			checks[i].checked = this.checked;
		}
	};
</script>