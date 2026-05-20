<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<div class="coPageWrap">

	<!-- 검색 영역 -->
	<form class="search-form"
		method="get"
		action="${pageContext.request.contextPath}/inventory/stockList">

		<div class="search-box">
			<div class="search-row">

				<!-- 구분 -->
				<div class="search-item">
					<label class="search-label">구분</label>

					<select name="searchType"
						class="search-select">

						<option value="">선택</option>

						<option value="itemCode"
							<c:if test="${searchType eq 'itemCode'}">selected</c:if>>
							품목코드
						</option>

						<option value="itemName"
							<c:if test="${searchType eq 'itemName'}">selected</c:if>>
							품목명
						</option>

					</select>
				</div>

				<!-- 시작일 -->
				<div class="search-item">
					<label class="search-label">시작일</label>

					<input type="date"
						name="startDate"
						class="search-date"
						value="${startDate}">
				</div>

				<!-- 종료일 -->
				<div class="search-item">
					<label class="search-label">종료일</label>

					<input type="date"
						name="endDate"
						class="search-date"
						value="${endDate}">
				</div>

				<!-- 검색어 -->
				<div class="search-item">
					<label class="search-label">검색어</label>

					<input type="text"
						name="keyword"
						class="search-input"
						placeholder="검색키워드"
						value="${keyword}">
				</div>

				<!-- 검색 / 초기화 버튼 -->
				<div class="search-btn-wrap">

					<!-- 검색 버튼 -->
					<button type="submit"
						class="search-btn search-btn-main">

						<!-- 돋보기 아이콘 -->
						<svg viewBox="0 0 24 24" fill="none">

							<circle cx="10.5"
								cy="10.5"
								r="7.5"
								stroke="currentColor"
								stroke-width="2">
							</circle>

							<path d="M16 16L21 21"
								stroke="currentColor"
								stroke-width="2"
								stroke-linecap="round">
							</path>

						</svg>

						검색

					</button>

					<!-- 초기화 버튼 -->
					<button type="button"
						class="search-btn search-btn-sub search-reset-btn"
						onclick="location.href='${pageContext.request.contextPath}/inventory/stockList'">

						초기화

					</button>

				</div>

			</div>
		</div>

	</form>

	<!-- 삭제 form -->
	<form method="post"
		id="deleteForm"
		action="${pageContext.request.contextPath}/inventory/stockList/delete">

		<div class="coTableTop">

			<p class="coTotalCount">
				총 ${pageInfo.totalCount}건
			</p>

			<!-- 관리자 / 매니저만 등록, 삭제 버튼 보임 -->
			<c:if test="${sessionScope.loginUser.role eq 'ADMIN'
				or sessionScope.loginUser.role eq 'MANAGER'}">

				<div class="search-btn-right">

					<!-- 등록 버튼 -->
					<button type="button"
						class="search-btn search-btn-main modal_open_btn"
						data_modal_target="#modal_insert">

						등록

					</button>

					<!-- 선택 삭제 버튼 -->
					<button type="button"
						class="search-btn search-btn-sub"
						onclick="deleteCheck()">

						선택 삭제

					</button>

				</div>

			</c:if>

		</div>

		<!-- 목록 테이블 -->
		<div class="coTableWrap">

			<table class="coTable">

				<thead>

					<tr>

						<!-- 전체 선택 -->
						<th>

							<label for="checkAll">
								선택
							</label>

							<input type="checkbox"
								id="checkAll"
								style="display:none;">

						</th>

						<th>품목코드</th>
						<th>품목유형</th>
						<th>품목명</th>
						<th>현재재고</th>
						<th>단위</th>
						<th>창고위치</th>
						<th>상세</th>

					</tr>

				</thead>

				<tbody>

					<c:forEach var="inventory"
						items="${list}">

						<tr>

							<td>

								<input type="checkbox"
									name="inventoryIds"
									value="${inventory.inventoryId}">

							</td>

							<td title="${inventory.itemCode}">
								${inventory.itemCode}
							</td>

							<td>

								<c:choose>

									<c:when test="${inventory.itemType eq 'FG'}">
										완제품
									</c:when>

									<c:when test="${inventory.itemType eq 'RM'}">
										원자재
									</c:when>

									<c:when test="${inventory.itemType eq 'SM'}">
										부자재
									</c:when>

									<c:otherwise>
										${inventory.itemType}
									</c:otherwise>

								</c:choose>

							</td>

							<td title="${inventory.itemName}">
								${inventory.itemName}
							</td>

							<td>
								${inventory.inventoryStock}
							</td>

							<td>
								${inventory.itemUnit}
							</td>

							<td>
								${inventory.stockLocation}
							</td>

							<td>

								<button type="button"
									class="coDetailBtn"
									onclick="location.href='${pageContext.request.contextPath}/inventory/stockList/detail?inventoryId=${inventory.inventoryId}'">

									보기

								</button>

							</td>

						</tr>

					</c:forEach>

				</tbody>

			</table>

		</div>

	</form>

	<!-- 공통 페이징 -->
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />

</div>

<script>

	// 전체 선택 체크박스
	document.getElementById("checkAll").onclick = function() {

		var checks =
			document.getElementsByName("inventoryIds");

		for (var i = 0; i < checks.length; i++) {

			checks[i].checked = this.checked;
		}
	};

	// 선택 삭제
	function deleteCheck() {

		var checks =
			document.getElementsByName("inventoryIds");

		var checked = false;

		for (var i = 0; i < checks.length; i++) {

			if (checks[i].checked) {

				checked = true;
			}
		}

		if (!checked) {

			alert("삭제할 항목을 선택해주세요.");
			return;
		}

		if (confirm("선택한 항목을 삭제하시겠습니까?")) {

			document.getElementById("deleteForm").submit();
		}
	}

</script>