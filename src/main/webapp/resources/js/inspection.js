const lookupBtn = document.querySelector('.qiSmallSearchBtn');//조회 버튼
const qiLookupModal = document.querySelector('.qiLookupModal');//조회 모달

lookupBtn.addEventListener('click',function(){
    qiLookupModal.style.display = 'flex';
});

//종료일 달력 선택 시 종료일이 시작일 포함 이전으로 선택 못 하게

//name으로 값 가져오기
var endDate = document.getElementsByName('endDate')[0].value;


