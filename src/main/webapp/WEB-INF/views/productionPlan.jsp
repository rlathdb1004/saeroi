<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="coPageWrap">

	<div class="coSearchBox">

		<label>계획일자</label>
		<input type="date">

		<span>~</span>

		<input type="date">

		<label>품목명</label>
		<select>
			<option>전체</option>
			<option>절연가스켓</option>
			<option>EPDM 원단</option>
			<option>실리콘 접착제</option>
		</select>

		<label>계획상태</label>
		<select>
			<option>전체</option>
			<option>계획중</option>
			<option>진행중</option>
			<option>완료</option>
		</select>

		<label>담당자</label>
		<input type="text" placeholder="담당자 입력">

		<button type="button">검색</button>
		<button type="button">초기화</button>

	</div>

	<div class="coTableTop">

		<p class="coTotalCount">총 1건</p>

		<div>
			<button type="button">신규 등록</button>
			<button type="button">삭제</button>
		</div>

	</div>

	<div class="coTableWrap">

		<table class="coTable">
			<thead>
				<tr>
					<th><input type="checkbox"></th>
					<th>NO</th>
					<th>작업시작 예정일자</th>
					<th>품목명</th>
					<th>계획수량</th>
					<th>단위</th>
					<th>납기예정 일자</th>
					<th>계획상태</th>
					<th>담당자</th>
					<th>비고</th>
				</tr>
			</thead>

			<tbody>
				<tr>
					<td><input type="checkbox"></td>
					<td>1</td>
					<td>2026-04-07</td>
					<td>절연가스켓</td>
					<td>500</td>
					<td>EA</td>
					<td>2026-04-10</td>
					<td>계획중</td>
					<td>관리자</td>
					<td>-</td>
				</tr>

				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
				<tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
			</tbody>
		</table>

	</div>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>