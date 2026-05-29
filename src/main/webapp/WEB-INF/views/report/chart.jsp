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
#chart {
	max-width: 100%;
	margin: 40px auto;
}
/* 대시보드 전체 레이아웃 (가로 배열) */
.dashboard-container {
	display: flex;
	gap: 20px;
	max-width: 1400px; /* 화면에 맞춰 최대 폭 확장 */
	margin: 20px auto;
}

.left-panel {
	flex: 7; /* 좌측 70% 비율 */
	background: #fff;
	padding: 15px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.right-panel {
	flex: 3; /* 우측 30% 비율 */
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.chart-box, .table-box {
	background: #fff;
	padding: 15px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.box-title {
	margin-top: 0;
	margin-bottom: 15px;
	font-size: 16px;
	font-weight: bold;
	color: #333;
	border-left: 4px solid #2f7d62;
	padding-left: 8px;
}

/* 데이터 테이블 스타일 */
.report-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 13px;
	text-align: center;
}

.report-table th {
	background-color: #f8f9fa;
	color: #495057;
	font-weight: 600;
	padding: 8px;
	border-bottom: 2px solid #dee2e6;
}

.report-table td {
	padding: 8px;
	border-bottom: 1px solid #dee2e6;
	color: #333;
}

.report-table tr:hover {
	background-color: #f1f3f5;
}
.dashboard-container {
	flex-direction: column; /* 가로 배열을 세로 배열로 변경 ✨ */
}
.apexcharts-toolbar {
    top: 30px !important;    /* 🔴 원래 0px 근처인 값을 아래로 내림 (원하는 만큼 수정 가능) */
    right: 10px !important;  /* 우측 여백 조정 */
}

</style>
</head>
<body>
	<!-- 라이브러리 -->
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

	<form class="search-form search-no-default-date" method="get">
		<div class="search-box">
			<div class="search-row">
				<!-- 구분 -->
				<div class="search-item">
					<label class="search-label">차트구분</label> <select name="searchType"
						class="search-select" id="select_type">
						<option value="month"
							${empty searchType || searchType == 'month' ? 'selected' : ''}>월별</option>
						<option value="day" ${searchType == 'day' ? 'selected' : ''}>일별</option>
						<option value="week" ${searchType == 'week' ? 'selected' : ''}>주별</option>
						<option value="year_sum"
							${searchType == 'year_sum' ? 'selected' : ''}>년별(합)</option>
					</select>
				</div>

				<!-- 시작일 -->
				<div class="search-item">
					<label class="search-label">시작일</label> <input type="date"
						name="startDate" class="search-date" id="startDate"
						value="${not empty startDate ? startDate : ''}">
				</div>
				<!-- 종료일 -->
				<div class="search-item">
					<label class="search-label">종료일</label> <input type="date"
						name="endDate" class="search-date" id="endDate"
						value="${not empty endDate ? endDate : ''}">
				</div>
				<div class="search-item">
					<label class="search-label">품목구분</label> <select name="searchItem"
						class="search-select" id="select_item">
						<option value="all"
							${empty searchItem || searchItem == 'all' ? 'selected' : ''}>전체</option>
						<c:forEach var="i" items="${item }">
							<option value="${i.ITEM_NAME}"
								${searchItem == i.ITEM_NAME ? 'selected' : ''}>${i.ITEM_NAME}>${i.ITEM_NAME}</option>
						</c:forEach>
					</select>
				</div>
				 <div class="search-btn-wrap">
				 <button type="button"
                    class="search-btn search-btn-sub search-reset-btn">
                   
                    초기화
                </button>
                </div>
			</div>
		</div>
	</form>

	<div class="dashboard-container">
		<div class="left-panel">
			<div id="chart"></div>
		</div>

		<div class="right-panel">
			<div class="chart-box">
				<h4 class="box-title" id="boxTitle">불량 원인</h4>
				<div id="oChart"></div>
			</div>
			<div class="coTableTop">
				<p class="coTotalCount">총 0건</p>
			</div>
			<div class="coTableWrap">
				<table class="coTable" id="reportTable">
					<thead>
						<tr>
							<th style="width: 180px !important;" >일자/기간</th>
							<th class="mobile_hidden">품목명</th>
							<th>계획량</th>
							<th>작업량</th>
							<th class="mobile_hidden">불량</th>
							<th class="mobile_hidden">달성률</th>
						</tr>
					</thead>
					<tbody id="tableBody">

					</tbody>
				</table>
				<div id="paginationContainer"></div>
			</div>
		</div>
		
	</div>


	<script>
	
	function getLocalDateFromWeek(weekStr, isEnd) {
	    if (!weekStr) return "";
	    // 문자열에서 숫자만 추출 (예: "2026-W22" 또는 "2026-22" -> ["2026", "22"])
	    let matches = weekStr.match(/\d+/g);
	    if (!matches || matches.length < 2) return weekStr; // 형식이 안 맞으면 원본 반환
	    
	    let year = parseInt(matches[0], 10);
	    let week = parseInt(matches[1], 10);
	    
	    // 해당 연도의 1월 4일 기준(ISO 주차 기준점)으로 첫 주를 잡고 계산
	    let thurs = new Date(year, 0, 4);
	    let dayN = thurs.getDay();
	    let daynum = dayN === 0 ? 7 : dayN;
	    
	    // 주차의 시작일(월요일) 구하기
	    let memoDay = new Date(thurs.getTime() + (week - 1) * 7 * 24 * 60 * 60 * 1000);
	    memoDay.setDate(memoDay.getDate() - daynum + 1);
	    
	    // 만약 종료일(endDate) 변환이고 주차의 마지막일(일요일)을 구하고 싶다면 6일을 더함
	    if (isEnd) {
	        memoDay.setDate(memoDay.getDate() + 6);
	    }
	    
	    // YYYY-MM-DD 형식으로 리턴
	    let yyyy = memoDay.getFullYear();
	    let mm = String(memoDay.getMonth() + 1).padStart(2, '0');
	    let dd = String(memoDay.getDate()).padStart(2, '0');
	    
	    return yyyy + "-" + mm + "-" + dd;
	}

	
	
	let chart = null;
	let ochart = null;
	let currentPage = 1; 
	let pageSize = 5;
	document.addEventListener('DOMContentLoaded', function(){
		let initialType = document.querySelector('#select_type').value || 'month';
		let initialItem = document.querySelector('#select_item').value || 'all';
		
		loadChartData(initialType,initialItem);
		
		document.querySelector('#startDate').addEventListener('change', function(){
		    let type = document.querySelector('#select_type').value || 'month';
		    let item = document.querySelector('#select_item').value || 'all';
		    loadChartData(type,item);
		});
		
		document.querySelector('#endDate').addEventListener('change', function(){
		    let type = document.querySelector('#select_type').value || 'month';
		    let item = document.querySelector('#select_item').value || 'all';
		    loadChartData(type,item);
		});
		document.querySelector('#select_type').addEventListener('change', function(){
		    let item = document.querySelector('#select_item').value || 'all';
		    loadChartData(this.value,item);
		});
		document.querySelector('#select_item').addEventListener('change', function(){
		    let type = document.querySelector('#select_type').value || 'month';
		    loadChartData(type,this.value);
		});
		
		let resetBtn = document.querySelector('.search-reset-btn');
		
		if (resetBtn) {
		    resetBtn.addEventListener('click', function() {
		    	
		        document.querySelector('#select_type').value = 'month'; 
		        document.querySelector('#select_item').value = 'all';   
		        document.querySelector('#startDate').value = '';       
		        document.querySelector('#endDate').value = '';         
		        
		        currentPage = 1;
		        
		        loadChartData('month', 'all');
		    });
		}
		
	});
	
	async function loadChartData(searchType,searchItem){
// 		let url = "chart_bar?searchType="+searchType+"&searchItem="+searchItem
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
        			// 1. DB에서 온 targetDate(예: "2026-22")를 헬퍼 함수를 통해 실제 월요일 날짜(YYYY-MM-DD)로 변환 🎯
        	        let realTarget = targetDate.includes('-') && targetDate.length <= 8 
        	                         ? getLocalDateFromWeek(targetDate, false) 
        	                         : targetDate; 
        	                         
        	        // 2. 검색 조건(startDate, endDate)이 월별(YYYY-MM)이나 년별(YYYY) 포맷일 수 있으므로 안전하게 YYYY-MM-DD로 채우기
        	        let realStart = startDate || "0000-00-00";
        	        let realEnd = endDate || "9999-12-31";
        	        
        	        if (realStart.length === 7) realStart += "-01";
        	        if (realStart.length === 4) realStart += "-01-01";
        	        if (realEnd.length === 7) realEnd += "-01";
        	        if (realEnd.length === 4) realEnd += "-12-31";

        	        // 3. 캘린더 표준 포맷 문자열로 정밀한 대소 범위 비교 수행 🔍
        	        if (realTarget < realStart || realTarget > realEnd) return false;
        		} else if(searchType === 'year_sum' || searchType === 'year_avg'){
        			let startYear = startDate ? startDate.substring(0, 4) : "";
        			let endYear = endDate ? endDate.substring(0, 4) : "";
        			
        			if (startYear && targetDate < startYear) return false;
        			if (endYear && targetDate > endYear) return false;
        		}
        		return true;
        	})
        }
        
        
        
        let totalCount = chartList.length;
        document.querySelector('.coTotalCount').innerText = '총 ' + totalCount + '건';

        let boxTitleEl = document.querySelector('#boxTitle');
        if (boxTitleEl) {
            if (searchType === 'year_sum' || searchType === 'year_avg') {
                boxTitleEl.innerText = '불량 원인 TOP3';
            } else {
                boxTitleEl.innerText = '불량 원인';
            }
        }
        
         // 2. 페이징 계산 (JavaScript 버전)
         let totalPage = Math.ceil(totalCount / pageSize) || 1;
         if (currentPage > totalPage) currentPage = totalPage;

         let startIndex = (currentPage - 1) * pageSize;
         let endIndex = Math.min(startIndex + pageSize, totalCount);
         let pagedList = chartList.slice(startIndex, endIndex);

        
        
        let tableBody = document.querySelector('#tableBody')
        tableBody.innerHTML = '';
        let totalPlan = 0, totalOrder = 0, totalDefect = 0;
        
        
        let dates = chartList.map(item => item.계획일자);
      	let planValues = chartList.map(item => item.생산계획량);
      	let orderValues = chartList.map(item => item.작업량);
      	let defectValues = chartList.map(item => item.불량수량);
      	
      	
      	if (pagedList.length === 0) {
      		let row = document.createElement('tr');
      		row.innerHTML = '<td colspan="6">조회된 데이터가 없습니다.</td>';
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
      			+ '<td>' + escapeHtml(item.계획일자) + '</td>'
      			+ '<td class="mobile_hidden">' + escapeHtml(item.품목명) + '</td>'
      			+ '<td>' + planQty.toLocaleString() + '</td>'
      			+ '<td>' + orderQty.toLocaleString() + '</td>'
      			+ '<td class="mobile_hidden" style="color: #FF4560; font-weight: bold;">' + defectQty.toLocaleString() + '</td>'
      			+ '<td class="mobile_hidden">' + escapeHtml(achievementRate) + '</td>'
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
      	renderPagination(totalPage, searchType, searchItem);
      	let defectOptions = {
      		series: [],
      		chart:{
      			type: 'donut',
      			height:230,
      			dropShadow: {
      	            enabled: true,
      	            top: 2,
      	            left: 2,
      	            blur: 4,
      	            opacity: 0.15
      	        },
      	        events:{}
      		},
      		plotOptions: {
      	        pie: {
      	            donut: {
      	                size: '10%' 
      	            }
      	        }
      	    },
      		labels: [],
            colors: ['#00E396', '#FF4560', '#FEB019', '#008FFB', '#775DD0', '#546E7A', '#FF69B4'],
            legend: {
                position: 'bottom'
            },
            responsive: [{
                breakpoint: 480,
                options: {
                    chart: { width: 200 },
                    legend: { position: 'bottom' }
                }
            }]
      	};
      	
      	if(ochart !== null){
      		ochart.destroy();
        }
        ochart = new ApexCharts(document.querySelector('#oChart'), defectOptions);
        ochart.render();
        
      	let title_text = '월별 생산계획 대비 작업 실적 및 불량 현황';
 		if(searchType == 'day') title_text = '일별 생산계획 대비 작업 실적 및 불량 현황'
 		if(searchType == 'week') title_text = '주간별 생산계획 대비 작업 실적 및 불량 현황'
 		if(searchType == 'month') title_text = '월별 생산계획 대비 작업 실적 및 불량 현황'
 		if(searchType == 'year_sum') title_text = '년별(합) 생산계획 대비 작업 실적 및 불량 현황'
 		if(searchType == 'year_avg') title_text = '년별(평균) 생산계획 대비 작업 실적 및 불량 현황'
      	let options= {
      			series:[{
      				name: '생산계획량',
      				type: 'column',
      				data: planValues
      			},
      			{
      				name: '작업량',
      				type: 'column',
      				data: orderValues
      			},{
      				name: '불량수량',
      				type: 'line',
      				data: defectValues
      			}],
      	
      	chart: {
      		height: 480,
      		type: 'line',
      		toolbar: {show:true},
      	events: {
      		zoomed:function(chartContext,{xaxis,yaxis}){
      			
    		if (chartContext.updateTimer) {
      	        clearTimeout(chartContext.updateTimer);
      	    }
      		chartContext.updateTimer = setTimeout(function() {
      			if(xaxis.min ===undefined && xaxis.max === undefined){
      				chartContext.updateOptions({
      					dataLabels:{
      						enabled:false
      					}
      				},false, true);
      				return;
      			} 
      			let min_index = Math.max(0,Math.floor(xaxis.min));
      			let max_index = Math.min(dates.length - 1, Math.ceil(xaxis.max));
      			
      			let visivle_cnt = (max_index-min_index)+1;
      			
      			if(visivle_cnt <= 10){
      				chartContext.updateOptions({
      					dataLabels:{
      						enabled: true,
      						enabledOnSeries: [0,1]
      					}
      				},false, true);
      			} else{
      				chartContext.updateOptions({
      					dataLabels:{
      						enabled: false,
      					}
      				},false, true);
      			}
      		},50);
      		}
      	}
      },
      	stroke:{
      		width:[0,0,4],
      	},
      	title: {
      		text: title_text,
      		align: 'center',
      		offsetX: -10,
      		offsety: 0,
      	},
      	dataLabels: {
      		enabled: false
      	},
      	xaxis: {
      		categories: dates
      	},
      	yaxis:[{
      	    seriesName: '생산계획량',
      	    title: { text: '생산 / 작업 수량 (EA)' }
      	  },
      	  {
      	    seriesName: '생산계획량', 
      	    show: false
      	  },
      	  {
      	    seriesName: '불량수량',
      	    opposite: true,
      	    title: { text: '불량 수량 (EA)' },
      	    min: 0
      	  }],
      	legend:{
      		show: true,
      		position: 'top',
      		horizontalAlign: 'left',
      		floating: true,
      		fontSize:'14px',
      		offsetY: 0,
      		offsetX: 0,
      		width: 600,
      		containerWidth: 600,
      		containerMargin: {
      	      left: 0,
      	      top: 0
      	    },
      		itemMargin:{
      			horizontal:20,
      			vertical: 0
      		}
      	},
      	grid: {
      	    padding: {
      	        top: 50
      	    }
      	},
      	colors:['#008FFB', '#00E396', '#FF4560'],
      	markers: {
      		size: 5
      	}
      	};
      	if(chart!==null){
      		chart.destroy();
      	}
      	chart = new ApexCharts(document.querySelector('#chart'), options)
      	chart.render();
      	
      	let reasonMap={};
      	
      	chartList.forEach(item => {
      		let detailStr = item.불량사유상세;
      		if(detailStr){
      			let pieces = detailStr.split(',');
				pieces.forEach(piece => {
					let [name, qtyStr] = piece.split(':');
					let qty = Number(qtyStr) || 0;
					if(reasonMap[name]){
						reasonMap[name] += qty;
						} else {
							reasonMap[name] = qty;
						}
					})
				}      			
			});
      	let rawKeys = Object.keys(reasonMap);
      	let finalValues = Object.values(reasonMap);

      	let finalNames = rawKeys.map(key => key.split('_')[1]);
      	let finalCodes = rawKeys.map(key => key. split('_')[0]);
      	
      	ochart.updateOptions({
      		series: finalValues,
      		labels: finalNames,
      		chart:{
      			 events:{
       	        	dataPointSelection: function(event, chartContext, config){
       	        		let clickIndex = config.dataPointIndex;
       	        		let defectCode = finalCodes[clickIndex];
       	        		if(defectCode){
       	        			let currentStartDate = document.querySelector('#startDate').value;
       	                    let currentEndDate = document.querySelector('#endDate').value;
       	                    
       	                 let targetUrl = '${pageContext.request.contextPath}/quality/defect'
                             + '?startDate=' + encodeURIComponent(currentStartDate)
                             + '&endDate=' + encodeURIComponent(currentEndDate)
                             + '&searchType=defectCode'
                             + '&keyword=' + encodeURIComponent(defectCode);
       	                 window.location.href = targetUrl;
       	        		}
       	        	}
       	        }
      		}
      	})
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


</body>
</html>