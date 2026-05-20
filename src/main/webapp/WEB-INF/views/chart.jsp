<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
	<form class="search-form" method="get">
		<div class="search-box">
			<div class="search-row">
				<!-- 구분 -->
				<div class="search-item">
					<label class="search-label">구분</label> <select name="searchType"
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
					<label class="search-label">시작일</label> 
					<input type="date" name="startDate" class="search-date" id="startDate">
				</div>
				<!-- 종료일 -->
				<div class="search-item">
					<label class="search-label">종료일</label> 
					<input type="date" name="endDate" class="search-date" id="endDate">
				</div>

				<!-- 검색, 초기화 버튼 -->
				<div class="search-btn-wrap">
					<button type="submit" class="search-btn search-btn-main">
						<svg viewBox="0 0 24 24" fill="none"> <circle cx="10.5"
								cy="10.5" r="7.5" stroke="currentColor" stroke-width="2"></circle> <path
								d="M16 16L21 21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round"></path> </svg>
						검색
					</button>
					<button type="button"
						class="search-btn search-btn-sub search-reset-btn">
						<svg viewBox="0 0 24 24" fill="none"> <path
								d="M20 12C20 16.4 16.4 20 12 20C7.6 20 4 16.4 4 12C4 7.6 7.6 4 12 4C14.4 4 16.5 5.1 18 6.8"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"></path> <path
								d="M18 4V7H21" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round"></path> </svg>
						초기화
					</button>
				</div>
			</div>
		</div>
	</form>
	<div id="chart"></div>


	<script>
	let chart = null;
	document.addEventListener('DOMContentLoaded', function(){
		loadChartData('month');
		
		document.querySelector('#select_type').
			addEventListener('change',function(){
				loadChartData(this.value);
			});
		document.querySelector('#startDate').
			addEventListener('change',function(){
				let type = document.querySelector('#select_type').value || 'month';
				loadChartData(type);
			});
		document.querySelector('#endDate').
			addEventListener('change',function(){
				loadChartData(this.value);
			});
		});
	
	async function loadChartData(searchType){
		
		let url = "chart_bar?searchType="+searchType
		try{
		let response = await fetch(url);
        let data = await response.json();
        
        let chartList = data.chartList;
		
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
      			if(xaxis.min ===undefined && xaxis.max === undefined){
      				chartContext.updateOptions({
      					dataLabels:{
      						enabled:false
      					}
      				},false, false);
      				return;
      			} 
      			let min_index = Math.max(0,Math.floor(xaxis.min));
      			let max_index = Math.min(dates.length - 1, Math.ceil(xaxis.max));
      			
      			let visivle_cnt = (max_index-min_index)+1
      			
      			if(visivle_cnt <= 10){
      				chartContext.updateOptions({
      					dataLabels:{
      						enabled: true,
      						enabledOnSeries: [0,1]
      					}
      				},false, false);
      			} else{
      				chartContext.updateOptions({
      					dataLabels:{
      						enabled: false,
      					}
      				},false, false);
      			}
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
      		title: {text:'생산 / 작업 수량 (EA)'}
      	},
      	{
      		opposite: true,
      		title: {text: '불량 수량 (EA)'}
      	}],
      	legend:{
      		show: true,
      		position: 'top',
      		horizontalAlign: 'left',
      		floating: true,
      		fontSize:'14px',
      		offsetY: -40,
      		offsetX: 10,
      		itemMargin:{
      			horizontal:12,
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