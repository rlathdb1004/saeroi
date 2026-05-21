<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common/detail.css">
<style>
#chart {
	max-width: 850px;
	margin: 40px auto;
}
</style>
</head>
<body>
	<!-- 라이브러리 -->
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
	
	<form class="search-form" method="get">
		<div class="search-box">
			<div class="search-row">
				<!-- 구분 -->
				<div class="search-item">
					<label class="search-label">차트구분</label> 
					<select name="searchType" class="search-select" id="select_type">
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
					<label class="search-label">품목구분</label> 
					<select name="searchItem" class="search-select" id="select_item">
						<option value="all">전체</option>
						<c:forEach var="i" items="${item }">
							<option value="${i.ITEM_NAME}">${i.ITEM_NAME}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</div>
	</form>
	<div id="chart"></div>


	<script>
	let chart = null;
	document.addEventListener('DOMContentLoaded', function(){
		loadChartData('month','all');
		
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
		
	});
	
	async function loadChartData(searchType,searchItem){
		let url = "chart_bar?searchType="+searchType+"&searchItem="+searchItem

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
        
        
        let dates = chartList.map(item => item.계획일자);
      	let planValues = chartList.map(item => item.생산계획량);
      	let orderValues = chartList.map(item => item.작업량);
      	let defectValues = chartList.map(item => item.불량수량);
      	
      	
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
      		height: 450,
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
      		align: 'center'
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
      		offsetY: -30,
      		offsetX: 10,
      		itemMargin:{
      			horizontal:8,
      			vertical: 0
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
		}catch (error){
			console.error("데이터 로딩 중 에러 발생:", error);
		}
	}
</script>


</body>
</html>