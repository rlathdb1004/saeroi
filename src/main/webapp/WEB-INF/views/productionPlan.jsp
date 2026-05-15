<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="coPageWrap">

	<style>

		/* 메인 버튼 */
		.btnMain {
			background-color: #2F7D62;
			color: white;
			border: none;
			padding: 5px 12px;
			border-radius: 4px;
			cursor: pointer;
		}

		/* 삭제 버튼 */
		.btnDark {
			background-color: #1F2933;
			color: white;
			border: none;
			padding: 5px 12px;
			border-radius: 4px;
			cursor: pointer;
		}

		/* 초기화 버튼 */
		.btnLight {
			background-color: #E6F2ED;
			color: #1F2933;
			border: 1px solid #79B59F;
			padding: 5px 12px;
			border-radius: 4px;
			cursor: pointer;
		}

		/* 검색 영역 */
		.searchRow {
			display: flex;
			align-items: center;
			gap: 14px;
			flex-wrap: wrap;
		}

		.searchItem {
			display: flex;
			align-items: center;
			gap: 6px;
		}

		.searchItem label {
			font-size: 13px;
			font-weight: bold;
		}

		.searchItem input {
			height: 28px;
			padding: 0 8px;
			border: 1px solid #ccc;
			border-radius: 4px;
		}

	</style>

	<!-- 검색 영역 -->
	<div class="coSearchBox">

		<div class="searchRow">

			<div class="searchItem">

				<label>계획일</label>

				<input type="date">

				<span>~</span>

				<input type="date">

			</div>

			<div class="searchItem">

				<label>품목ID</label>

				<input type="text" placeholder="품목ID 입력">

			</div>

			<button type="button" class="btnMain">
				검색
			</button>

			<button type="button" class="btnLight">
				초기화
			</button>

		</div>

	</div>

	<!-- 테이블 상단 -->
	<div class="coTableTop">

		<p class="coTotalCount">
			총 ${pageInfo.totalCount}건
		</p>

		<div>

			<button type="button" class="btnMain">
				신규 등록
			</button>

			<button type="button" class="btnDark">
				삭제
			</button>

		</div>

	</div>

	<!-- 테이블 -->
	<div class="coTableWrap">

		<table class="coTable">

			<thead>

				<tr>

					<th>
						<input type="checkbox" id="checkAll">
					</th>

					<th>생산계획ID</th>

					<th>품목ID</th>

					<th>계획일</th>

					<th>계획수량</th>

					<th>생성일</th>

					<th>수정일</th>

					<th>상세</th>

				</tr>

			</thead>

			<tbody>

				<tr>

					<td>
						<input type="checkbox" name="rowCheck">
					</td>

					<td>1</td>

					<td>1001</td>

					<td>2026-04-07</td>

					<td>500</td>

					<td>2026-04-07</td>

					<td>2026-04-07</td>

					<td>
						<button type="button" class="btnLight">
							상세
						</button>
					</td>

				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

				<tr>
					<td><input type="checkbox" name="rowCheck"></td>
					<td></td><td></td><td></td>
					<td></td><td></td><td></td><td></td>
				</tr>

			</tbody>

		</table>

	</div>

	<!-- 공통 페이징 -->
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script>

	// 전체 체크박스 선택

	document.getElementById("checkAll").onclick = function() {

		var checks = document.getElementsByName("rowCheck");

		for (var i = 0; i < checks.length; i++) {

			checks[i].checked = this.checked;

		}
	};

</script>