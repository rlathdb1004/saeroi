const lookupBtn = document.querySelector('.qiSmallSearchBtn');//조회 버튼
const qiLookupModal = document.querySelector('.qiLookupModal');//조회 모달

lookupBtn.addEventListener('click',function(){
    qiLookupModal.style.display = 'flex';
})