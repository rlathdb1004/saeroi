const lookupBtn = document.querySelector('.qiSmallSearchBtn');//조회 버튼
const qiLookupModal = document.querySelector('.qiLookupModal');//조회 모달

lookupBtn.addEventListener('click',function(){
    qiLookupModal.style.display = 'flex';
});

//종료일 달력 선택 시 종료일이 시작일 포함 이전으로 선택 못 하게

//name으로 값 가져오기
var endDate = document.getElementsByName('endDate')[0].value;
var startDate = document.getElementsByName('startDate')[0].value;

endDate.addEventListener('click', function(){
	//시작일 값 포함 이전 선택 불가
	//시작일 선택 하면 js가 알아야 할 거 같음
	
	
});

//초기화 버튼
const coBtnReset = document.querySelector('.coBtnReset');

coBtnReset.addEventListener('click', function(){
    //초기화 버튼 클릭 시 시작일과 종료일 초기화
    document.getElementsByName('startDate')[0].value = '';
    document.getElementsByName('endDate')[0].value = '';
    document.getElementsByName('searchType')[0].value = '';
    document.getElementsByName('keyword')[0].value = '';
});