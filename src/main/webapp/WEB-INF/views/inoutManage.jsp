<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	/* 상단 등록/삭제 버튼 영역 */
	.inoutBtnArea {
		text-align: right;
		margin-bottom: 30px;
	}

	/* 메인 버튼 */
	.inoutMainBtn {
		background-color: #2F7D62;
		color: white;
		border: none;
		border-radius: 8px;
		padding: 11px 24px;
		font-weight: bold;
		cursor: pointer;
	}

	/* 보조 버튼 */
	.inoutSubBtn {
		background-color: white;
		color: #1F2933;
		border: 1px solid #cbd5df;
		border-radius: 8px;
		padding: 8px 14px;
		font-weight: bold;
		font-size: 12px;
		cursor: pointer;
	}

	/* 검색 조건 한 줄 정렬 */
	.inoutSearchLine {
		display: flex;
		align-items: center;
		gap: 12px;
	}

	/* 검색 select, input */
	.inoutSearchLine select,
	.inoutSearchLine input {
		height: 42px;
		border: 1px solid #d8e1ea;
		border-radius: 12px;
		padding: 0 14px;
	}

	/* 검색 키워드 input 크기 */
	.inoutKeyword {
		width: 340px;
	}

	/* 테이블 전체 너비 고정 */
	.coTable {
		table-layout: fixed;
		width: 100%;
	}

	/* 테이블 글자/간격 줄이기 */
	.coTable th,
	.coTable td {
		font-size: 12px;
		padding: 9px 6px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		text-align: center;
	}
</style>

<div class="coPageWrap">

	<!-- 등록 / 선택 삭제 버튼 -->
	<div class="inoutBtnArea">
		<button type="button" class="inoutMainBtn">등록</button>
		<button type="button" class="inoutSubBtn">선택 삭제</button>
	</div>

	<!-- 검색 영역 -->
	<div class="coSearchBox">

		<div class="inoutSearchLine">

			<select>
				<option>전체 / 품목코드 / 품목명</option>
				<option>품목코드</option>
				<option>품목명</option>
			</select>

			<label>시작일</label>
			<input type="date">

			<label>종료일</label>
			<input type="date">

			<input type="text" class="inoutKeyword" placeholder="검색키워드">

			<button type="button" class="inoutMainBtn">검색</button>
			<button type="button" class="inoutSubBtn">초기화</button>

		</div>

	</div>

	<!-- 총 건수 -->
	<div class="coTableTop">
		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>
	</div>

	<!-- 테이블 -->
	<div class="coTableWrap">

		<table class="coTable">

			<thead>
				<tr>
					<th><input type="checkbox" id="checkAll"></th>
					<th>NO</th>
					<th>입출고번호</th>
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

				<c:forEach var="inout" items="${list}">
					<tr>

						<!-- 체크박스 -->
						<td>
							<input type="checkbox" name="rowCheck">
						</td>

						<!-- 번호 -->
						<td>${inout.inoutId}</td>

						<!-- 입출고번호 -->
						<td>${inout.docNo}</td>

						<!-- 입고/출고 표시 -->
						<td>
							<c:choose>

								<c:when test="${inout.docNo.contains('-MI-')}">
									입고
								</c:when>

								<c:when test="${inout.docNo.contains('-MO-')}">
									출고
								</c:when>

								<c:when test="${inout.inoutType eq 'MI'}">
									입고
								</c:when>

								<c:otherwise>
									출고
								</c:otherwise>

							</c:choose>
						</td>

						<!-- 품목코드 -->
						<td>${inout.itemCode}</td>

						<!-- 품목유형 -->
						<td>

							<c:choose>

								<c:when test="${inout.itemType eq 'FG'}">
									완제품
								</c:when>

								<c:when test="${inout.itemType eq 'RM'}">
									원자재
								</c:when>

								<c:when test="${inout.itemType eq 'SM'}">
									부자재
								</c:when>

								<c:otherwise>
									${inout.itemType}
								</c:otherwise>

							</c:choose>

						</td>

						<!-- 품목명 -->
						<td>${inout.itemName}</td>

						<!-- 입출고량 -->
						<td>${inout.inoutQty}</td>

						<!-- 단위 -->
						<td>${inout.itemUnit}</td>

						<!-- 날짜 -->
						<td>${inout.inoutDate}</td>

						<!-- 상세보기 버튼 -->
						<td>
							<button type="button" class="inoutSubBtn">
								상세보기
							</button>
						</td>

					</tr>
				</c:forEach>

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