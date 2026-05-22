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
	max-width: 100%;
	margin: 40px auto;
}
/* 대시보드 전체 레이아웃 (가로 배열) */
.dashboard-container {
    display: flex;
    gap: 20px;
    max-width: 1400px; /* 화면에 맞춰 최대 폭 확장 */
    margin: 20px auto;
    padding: 0 20px;
}

.left-panel {
    flex: 7; /* 좌측 70% 비율 */
    background: #fff;
    padding: 15px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.box-title {
    margin-top: 0;
    margin-bottom: 15px;
    font-size: 16px;
    font-weight: bold;
    color: #333;
    border-left: 4px solid #008FFB;
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
	
	<div class="dashboard-container">
    <div class="left-panel">
        <div id="chart"></div>
    </div>
    
    <div class="right-panel">
        <div class="chart-box">
            <h4 class="box-title">불량 원인 TOP 3</h4>
            <div id="oChart"></div>
        </div>
        
        <div class="table-box">
            <h4 class="box-title">상세 데이터 내역</h4>
            <table class="report-table" id="reportTable">
                <thead>
                    <tr>
                        <th>일자/기간</th>
                        <th>계획량</th>
                        <th>작업량</th>
                        <th>불량</th>
                    </tr>
                </thead>
                <tbody id="tableBody">
                    </tbody>
            </table>
        </div>
    </div>
</div>


	<script>
	let chart = null;
	let ochart = null;
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
        
        let tableBody = document.querySelector('#tableBody')
        tableBody.innerHTML = '';
        let totalPlan = 0, totalOrder = 0, totalDefect = 0;
        
        
        let dates = chartList.map(item => item.계획일자);
      	let planValues = chartList.map(item => item.생산계획량);
      	let orderValues = chartList.map(item => item.작업량);
      	let defectValues = chartList.map(item => item.불량수량);
      	
      	chartList.forEach(item => {
      		let row = document.createElement('tr');
      		row.innerHTML = `
      			<td>\${item.계획일자}</td>
                <td>\${Number(item.생산계획량).toLocaleString()}</td>
                <td>\${Number(item.작업량).toLocaleString()}</td>
                <td style="color: #FF4560; font-weight: bold;">\${Number(item.불량수량).toLocaleString()}</td>
      		`;
      		tableBody.appendChild(row);
      		
      		totalPlan += Number(item.생산계획량 || 0);
            totalOrder += Number(item.작업량 || 0);
            totalDefect += Number(item.불량수량 || 0);
      	});
      	
      	let defectOptions = {
      		series: [
      			Math.round(totalDefect * 0.45),
      			Math.round(totalDefect * 0.30),
      			Math.round(totalDefect * 0.25)
      		],
      		chart:{
      			type: 'donut',
      			height:230
      		},
      		labels: ['치수 불량', '스크래치', '기타 이물질'],
            colors: ['#00E396', '#FF4560', '#FEB019'],
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
        oChart = new ApexCharts(document.querySelector('#oChart'), defectOptions);
        oChart.render();
        
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
      		offsety: 0
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
      		offsetY: -55,
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