<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	.reportPage .search-form {
		margin-bottom: 30px;
		/* 검색 박스와 총 건수 영역 사이 간격이다. */
	}

	.reportPage .coTableTop {
		margin-bottom: 14px;
		/* 총 건수와 테이블 사이 간격이다. */
	}
</style>

<!-- 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

<div class="coPageWrap reportPage">
	<form class="search-form search-no-default-date" method="get">
		<div class="search-box">
			<div class="search-row">
				<!-- 구분 -->
				<div class="search-item">
					<label class="search-label">차트구분</label> <select name="searchType"
						class="search-select" id="select_type">
						<option value="day">일별</option>
						<option value="week">주별</option>
						<option value="month" selected>월별</option>
						<option value="year_sum">년별(합)</option>
						<option value="year_avg">년별(평균)</option>
					</select>
				</div>

				<!-- 시작일 -->
				<div class="search-item">
					<label class="search-label">시작일</label> <input type="date"
						name="startDate" class="search-date" id="startDate">
				</div>
				<!-- 종료일 -->
				<div class="search-item">
					<label class="search-label">종료일</label> <input type="date"
						name="endDate" class="search-date" id="endDate">
				</div>
				<div class="search-item">
					<label class="search-label">품목구분</label> <select name="searchItem"
						class="search-select" id="select_item">
						<option value="all">전체</option>
						<c:forEach var="i" items="${item }">
							<option value="${i.ITEM_NAME}">${i.ITEM_NAME}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</div>
	</form>

	<div class="coTableTop">
	<p class="coTotalCount">총 0건</p>
	</div>


	<div class="coTableWrap">
		<table class="coTable" id="reportTable">
			<thead>
				<tr>
					<th onclick="toggleAllCheckByTitle();" title="전체 선택/해제">선택</th>
					<th>일자/기간</th>
					<th class="mobile_hidden">품목명</th>
					<th>계획량</th>
					<th>작업량</th>
					<th class="mobile_hidden">불량</th>
					<th class="mobile_hidden">달성률</th>
					<th>상세</th>
				</tr>
			</thead>
			<tbody id="tableBody">

			</tbody>
		</table>
	</div>

	<div id="paginationContainer"></div>

</div>

<script>
	let chart = null;
	let ochart = null;
	document.addEventListener('DOMContentLoaded', function(){
		loadChartData('month','all');
		
		document.querySelector('#startDate').addEventListener('change', function(){
			currentPage = 1;
		    let type = document.querySelector('#select_type').value || 'month';
		    let item = document.querySelector('#select_item').value || 'all';
		    loadChartData(type,item);
		});
		
		document.querySelector('#endDate').addEventListener('change', function(){
			currentPage = 1;
			let type = document.querySelector('#select_type').value || 'month';
		    let item = document.querySelector('#select_item').value || 'all';
		    loadChartData(type,item);
		});
		document.querySelector('#select_type').addEventListener('change', function(){
			currentPage = 1;
			let item = document.querySelector('#select_item').value || 'all';
		    loadChartData(this.value,item);
		});
		document.querySelector('#select_item').addEventListener('change', function(){
			currentPage = 1;
			let type = document.querySelector('#select_type').value || 'month';
		    loadChartData(type,this.value);
		});
		
	});
	
	let currentPage = 1;
	let pageSize = 5;
	
	async function loadChartData(searchType, searchItem) {
		// contextPath를 포함해서 AJAX 요청 주소를 고정한다.
		let url = "${pageContext.request.contextPath}/report/chart_bar"
				+ "?searchType=" + encodeURIComponent(searchType)
				+ "&searchItem=" + encodeURIComponent(searchItem);

		try{
			
		let response = await fetch(url);
        let data = await response.json();
        
        let chartList = data.chartList;

        let startDate = document.querySelector('#startDate').value
        let endDate = document.querySelector('#endDate').value
        if(!startDate && !endDate){
        	let year =new Date().getFullYear().toString();
        	let lastyear =(new Date().getFullYear() -1).toString();
        	
        	chartList = chartList.filter(item =>{
        		let data_year = item.계획일자.substring(0,4);
        		
        		return data_year === year || data_year === lastyear;
        	});
        } else {
        	chartList = chartList.filter(item =>{
        		let targetDate = item.계획일자;
        		
        		if (searchType === 'day') {
        			if(startDate && targetDate < startDate) return false;
        			if(endDate && targetDate > endDate) return false;
        		} else if(searchType === 'month' || searchType === ''){
        			let startMonth= startDate ? startDate.substring(0,7) : "";
        			let endMonth= endDate ? endDate.substring(0,7) : "";
        			
        			if (startMonth && targetDate < startMonth) return false;
        			if (endMonth && targetDate > endMonth) return false;
        		} else if(searchType === 'week'){
        			let targetYear = targetDate.substring(0, 4);
        			let startYear = startDate ? startDate.substring(0, 4) : "0000";
        			let endYear = endDate ? endDate.substring(0, 4) : "9999";
        			
        			if (targetYear < startYear || targetYear > endYear) return false;
        		} else if(searchType === 'year_sum' || searchType === 'year_avg'){
        			let startYear = startDate ? startDate.substring(0, 4) : "";
        			let endYear = endDate ? endDate.substring(0, 4) : "";
        			
        			if (startYear && targetDate < startYear) return false;
        			if (endYear && targetDate > endYear) return false;
        		}
        		return true;
        	})
        }
        ////////////////////////////////////////////////////////////
       let totalCount = chartList.length;
       document.querySelector('.coTotalCount').innerText = '총 ' + totalCount + '건';

        // 2. 페이징 계산 (JavaScript 버전)
        let totalPage = Math.ceil(totalCount / pageSize) || 1;
        if (currentPage > totalPage) currentPage = totalPage;

        let startIndex = (currentPage - 1) * pageSize;
        let endIndex = Math.min(startIndex + pageSize, totalCount);
        let pagedList = chartList.slice(startIndex, endIndex);

        /////////////////////////////////////////////////////////
        let tableBody = document.querySelector('#tableBody')
        tableBody.innerHTML = '';
        let totalPlan = 0, totalOrder = 0, totalDefect = 0;
        
        
        let dates = chartList.map(item => item.계획일자);
      	let planValues = chartList.map(item => item.생산계획량);
      	let orderValues = chartList.map(item => item.작업량);
      	let defectValues = chartList.map(item => item.불량수량);
      	
      	if (pagedList.length === 0) {
      		let row = document.createElement('tr');
      		row.innerHTML = '<td colspan="8">조회된 데이터가 없습니다.</td>';
      		tableBody.appendChild(row);
      	}
      	
      	pagedList.forEach(item => {
      		let row = document.createElement('tr');

      		let planQty = Number(item.생산계획량 || 0);
      		let orderQty = Number(item.작업량 || 0);
      		let defectQty = Number(item.불량수량 || 0);
      		let achievementRate = planQty > 0 ? ((orderQty / planQty) * 100).toFixed(1) + '%' : '-';

      		let detailUrl = "${pageContext.request.contextPath}/report/chart"
      				+ "?searchType=" + encodeURIComponent(searchType)
      				+ "&searchItem=" + encodeURIComponent(item.품목명 || searchItem)
      				+ "&startDate=" + encodeURIComponent(startDate || "")
      				+ "&endDate=" + encodeURIComponent(endDate || "");

      		row.innerHTML = ''
      			+ '<td><input type="checkbox" name="orderIds" value="' + escapeHtml(item.계획일자) + '"></td>'
      			+ '<td>' + escapeHtml(item.계획일자) + '</td>'
      			+ '<td class="mobile_hidden">' + escapeHtml(item.품목명) + '</td>'
      			+ '<td>' + planQty.toLocaleString() + '</td>'
      			+ '<td>' + orderQty.toLocaleString() + '</td>'
      			+ '<td class="mobile_hidden" style="color: #FF4560; font-weight: bold;">' + defectQty.toLocaleString() + '</td>'
      			+ '<td class="mobile_hidden">' + escapeHtml(achievementRate) + '</td>'
      			+ '<td><a href="' + escapeHtml(detailUrl) + '" class="coDetailBtn">보기</a></td>';
      		tableBody.appendChild(row);
      		
      		totalPlan += Number(item.생산계획량 || 0);
            totalOrder += Number(item.작업량 || 0);
            totalDefect += Number(item.불량수량 || 0);
      	});

      	if (typeof initCommonRowDetailMove === 'function') {
      		initCommonRowDetailMove();
      	}

      	if (typeof initCommonTableTooltip === 'function') {
      		initCommonTableTooltip();
      	}

      	if (typeof refreshCommonTableTooltip === 'function') {
      		refreshCommonTableTooltip();
      	}

      	if (typeof initCommonResizableTables === 'function') {
      		initCommonResizableTables();
      	}
      	
		/////////////////////////////////////////////////////
  		renderPagination(totalPage, searchType, searchItem);
  		////////////////////////////////////////////////////////
		}catch (error){
			console.error("데이터 로딩 중 에러 발생:", error);
		}
	}
	
	function renderPagination(totalPage, searchType, searchItem) {
	    let container = document.querySelector('#paginationContainer');
	    container.innerHTML = '';

	    // 간단한 이전/다음 버튼 예시 (필요시 스타일링에 맞춰 pagination 디자인 수정)
	    let blockSize = 5;
	    let startPage = Math.floor((currentPage - 1) / blockSize) * blockSize + 1;
	    let endPage = Math.min(startPage + blockSize - 1, totalPage);
	    let html = '<div class="coTableBottom">';
	    html += '<div class="coPaging">';
	    
	    // [이전] 버튼
	    if (currentPage > 1) {
	        html += '<a href="#" class="coPageMoveBtn" onclick="changePage(1); return false;">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M11 18L5 12L11 6"></path>';
	        html += '<path d="M19 18L13 12L19 6"></path>';
	        html += '</svg>';
	        html += '</a>';
	        html += '<a href="#" class="coPageMoveBtn" onclick="changePage(' + (currentPage - 1) + '); return false;">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M15 18L9 12L15 6"></path>';
	        html += '</svg>';
	        html += '</a>';
	    } else {
	        html += '<span class="coPageMoveBtn disabled">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M11 18L5 12L11 6"></path>';
	        html += '<path d="M19 18L13 12L19 6"></path>';
	        html += '</svg>';
	        html += '</span>';
	        html += '<span class="coPageMoveBtn disabled">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M15 18L9 12L15 6"></path>';
	        html += '</svg>';
	        html += '</span>';
	    }

	    // 숫자 버튼 (최대 5개씩 끊어서 보여주는 등 응용 가능)
	    for (let i = startPage; i <= endPage; i++) {
	        if (i === currentPage) {
	            html += '<span class="coPageBtn active">' + i + '</span>';
	        } else {
	            html += '<a href="#" class="coPageBtn" onclick="changePage(' + i + '); return false;">' + i + '</a>';
	        }
	    }

	    // [다음] 버튼
	    if (currentPage < totalPage) {
	        html += '<a href="#" class="coPageMoveBtn" onclick="changePage(' + (currentPage + 1) + '); return false;">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M9 18L15 12L9 6"></path>';
	        html += '</svg>';
	        html += '</a>';
	        html += '<a href="#" class="coPageMoveBtn" onclick="changePage(' + totalPage + '); return false;">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M5 18L11 12L5 6"></path>';
	        html += '<path d="M13 18L19 12L13 6"></path>';
	        html += '</svg>';
	        html += '</a>';
	    } else {
	        html += '<span class="coPageMoveBtn disabled">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M9 18L15 12L9 6"></path>';
	        html += '</svg>';
	        html += '</span>';
	        html += '<span class="coPageMoveBtn disabled">';
	        html += '<svg class="coPageIcon" viewBox="0 0 24 24" fill="none" stroke-width="2">';
	        html += '<path d="M5 18L11 12L5 6"></path>';
	        html += '<path d="M13 18L19 12L13 6"></path>';
	        html += '</svg>';
	        html += '</span>';
	    }
	    
	    html += '</div>';
	    html += '<div class="coPageSizeBox">';
	    html += '<select class="coPageSizeSelect" onchange="changePageSize(this)">';
	    html += '<option value="5" ' + (pageSize === 5 ? 'selected' : '') + '>5개씩 보기</option>';
	    html += '<option value="10" ' + (pageSize === 10 ? 'selected' : '') + '>10개씩 보기</option>';
	    html += '<option value="20" ' + (pageSize === 20 ? 'selected' : '') + '>20개씩 보기</option>';
	    html += '<option value="30" ' + (pageSize === 30 ? 'selected' : '') + '>30개씩 보기</option>';
	    html += '</select>';
	    html += '</div>';
	    html += '</div>';
	    container.innerHTML = html;
	}

	// 페이지 변경 시 호출되는 함수
	function changePage(page) {
	    currentPage = page;

	    let searchType = document.querySelector('#select_type').value || 'month';
	    let searchItem = document.querySelector('#select_item').value || 'all';

	    loadChartData(searchType, searchItem);
	}

	function changePageSize(selectBox) {
		pageSize = Number(selectBox.value);
		currentPage = 1;

		let searchType = document.querySelector('#select_type').value || 'month';
		let searchItem = document.querySelector('#select_item').value || 'all';

		loadChartData(searchType, searchItem);
	}

	function escapeHtml(value) {
		if (value === null || value === undefined) {
			return '';
		}

		return String(value)
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#039;');
	}
</script>