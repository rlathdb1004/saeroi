//초기화 버튼
const coBtnReset = document.querySelector('.coBtnReset');

coBtnReset.addEventListener('click', function(){
    //초기화 버튼 클릭 시 시작일과 종료일 초기화
    document.getElementsByName('startDate')[0].value = '';
    document.getElementsByName('endDate')[0].value = '';
    document.getElementsByName('searchType')[0].value = '';
    document.getElementsByName('keyword')[0].value = '';
});

//등록 버튼 클릭 시 모달 띄움
const qiRegisterOpenBtn = document.querySelector('.qiRegisterOpenBtn');
const qiRegisterModal = document.querySelector('.qiRegisterModal');
qiRegisterOpenBtn.addEventListener('click', function(){
    
    qiRegisterModal.style.display = 'flex';
});