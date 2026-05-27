<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">
<style>
.coPagination {
		display: flex !important;
		list-style: none !important;
		padding: 0 !important;
		margin: 20px 0 !important;
		justify-content: center !important;
		align-items: center !important;
		gap: 6px !important;
	}
	.coPagination li {
		display: inline-block !important;
		margin: 0 !important;
		padding: 0 !important;
	}
	.coPagination li a, .coPagination li span {
		display: block !important;
		padding: 6px 12px !important;
		border: 1px solid #dee2e6 !important;
		color: #007bff !important;
		text-decoration: none !important;
		border-radius: 4px !important;
		font-size: 14px !important;
		cursor: pointer;
	}
	.coPagination li.active strong {
		display: block !important;
		padding: 6px 12px !important;
		background-color: #007bff !important;
		color: #fff !important;
		border: 1px solid #007bff !important;
		border-radius: 4px !important;
		font-size: 14px !important;
	}
	.coPagination li a:hover {
		background-color: #e9ecef !important;
	}
</style>
</head>
<body>
	<!-- 라이브러리 -->
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
	<div class="coPageWrap">
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

		<p class="coTotalCount">총 ${pageInfo.totalCount}건</p>


		<div class="coTableWrap">
			<table class="coTable" id="reportTable">
				<thead>
					<tr>
						<th class="mobile_show" onclick="toggleAllCheckByTitle();"
							title="전체 선택/해제">선택</th>
						<th class="mobile_show">일자/기간</th>
						<th class="mobile_show">품목명</th>
						<th class="mobile_show">계획량</th>
						<th class="mobile_show">작업량</th>
						<th class="mobile_show">불량</th>
						<th class="mobile_show">상세</th>
					</tr>
				</thead>
				<tbody id="tableBody">

				</tbody>
			</table>
		</div>
	</div>
	</div>
	<div id="paginationContainer" class="coPaginationWrap"></div>
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
	const pageSize = 5;
	
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
        document.querySelector('.coTotalCount').innerText = `총 ${totalCount}건`;

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
      	
      	pagedList.forEach(item => {
      		let row = document.createElement('tr');
      		row.innerHTML = `
      			<td class="mobile_show"><input type="checkbox" name="orderIds"
				value="${progress.orderId}"></td>
      			<td>\${item.계획일자}</td>
      			<td><a href="${pageContext.request.contextPath}/report/chart?searchType=\${searchType}&searchItem=\${searchItem}&startDate=\${startDate}&endDate=\${endDate}">\${item.품목명}</a></td>
                <td>\${Number(item.생산계획량).toLocaleString()}</td>
                <td>\${Number(item.작업량).toLocaleString()}</td>
                <td style="color: #FF4560; font-weight: bold;">\${Number(item.불량수량).toLocaleString()}</td>
                <td colspan="5">보기</td>
                `;
      		tableBody.appendChild(row);
      		
      		totalPlan += Number(item.생산계획량 || 0);
            totalOrder += Number(item.작업량 || 0);
            totalDefect += Number(item.불량수량 || 0);
      	});
      	
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
	    let html = '<ul class="coPagination">';
	    
	    // [이전] 버튼
	    if (currentPage > 1) {
	        html += `<li><a href="#" onclick="changePage(${currentPage - 1}, '${searchType}', '${searchItem}'); return false;">이전</a></li>`;
	    }

	    // 숫자 버튼 (최대 5개씩 끊어서 보여주는 등 응용 가능)
	    for (let i = 1; i <= totalPage; i++) {
	        if (i === currentPage) {
	            html += '<li class="active-page"><span>' + i + '</span></li>';
	        } else {
	            html += '<li><a href="#" onclick="changePage(' + i + ', \'' + searchType + '\', \'' + searchItem + '\'); return false;">' + i + '</a></li>';
	        }
	    }

	    // [다음] 버튼
	    if (currentPage < totalPage) {
	        html += `<li><a href="#" onclick="changePage(${currentPage + 1}, '${searchType}', '${searchItem}'); return false;">다음</a></li>`;
	    }
	    
	    html += '</ul>';
	    container.innerHTML = html;
	}

	// 페이지 변경 시 호출되는 함수
	function changePage(page, searchType, searchItem) {
	    currentPage = page;
	    loadChartData(searchType, searchItem);
	}
</script>


</body>
</html>