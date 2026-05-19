//초기화 버튼
const coBtnReset = document.querySelector('.search-reset-btn');

coBtnReset.addEventListener('click', function () {
    //초기화 버튼 클릭 시 시작일과 종료일 초기화
    document.getElementsByName('startDate')[0].value = '';
    document.getElementsByName('endDate')[0].value = '';
    document.getElementsByName('searchType')[0].value = '';
    document.getElementsByName('keyword')[0].value = '';
});

//등록 버튼 클릭 시 모달 띄움
const qiRegisterOpenBtn = document.querySelector('.search-btn-right .search-btn-main');
const qiRegisterModal = document.querySelector('.qiRegisterModal');
const qiModalCloseBtn = document.querySelector('.qiModalCloseBtn');
const qiModalCancelBtn = document.querySelector('.qiModalCancelBtn');

qiRegisterOpenBtn.addEventListener('click', function () {
    qiRegisterModal.classList.add('isOpen');
});

qiModalCloseBtn.addEventListener('click', function () {
    qiRegisterModal.classList.remove('isOpen');
});

qiModalCancelBtn.addEventListener('click', function () {
    qiRegisterModal.classList.remove('isOpen');
});




//품목명 select 클릭 시 품목명 목록 띄우기
//등록 시 검사 테이블 컬럼 명이 prod_id 이므로 
var prod_id = document.getElementsByName('prod_id')[0];

var prodLoaded = false; //품목 목록 불러왔는지 확인

prod_id.addEventListener('click', function () {

    if (prodLoaded) {
        return; //품목 목록 클릭 이벤트 한 번만 실행되도록
    }

    //품목 목록 불러오는 주소
    fetch(contextPath + '/quality/inspection/option?searchType=itemName')
        //응답을 json 형태로 변환(JS가 사용할 수 있는 배열이나 객체로 바꾸기 위해서)
        .then(response => response.json())
        .then(data => {
            console.log('prod_id 클릭 시 응답받은 품목 목록:', data);

            prod_id.innerHTML = ''; //기존 옵션 제거
            prod_id.innerHTML += '<option value="">선택</option>'; //기본 옵션

            //품목 목록 반복문
            data.forEach(itemName => {
                prod_id.innerHTML += `<option value="${itemName}">${itemName}</option>`;
            });

            //선택한 값 유지하기
            prodLoaded = true;
        });
});

//검사자 select 클릭 시 검사자 목록 띄우기
var emp_id = document.getElementsByName('emp_id')[0];

var empNameLoaded = false;//검사자 목록 불러 왔는지 확인
emp_id.addEventListener('click', function () {

    if(empNameLoaded){
        return; //검사자 목록 클릭 이벤트 한 번만 실행되도록
    }
    //js로 검사자 목록 불러오는 주소
    fetch(contextPath + '/quality/inspection/option?searchType=ename')
        //응답을 json 형태로 변환(JS가 사용할 수 있는 배열이나 객체로 바꾸기 위해서)
        .then(response => response.json())
        .then(data => {
            console.log(' 클릭 시 응답받은 검사자 목록:', data);

            emp_id.innerHTML = ''; //기존 옵션 제거
            emp_id.innerHTML += '<option value="">선택</option>'; //기본 값 옵션
            //검사자 목록 반복문
            data.forEach(empName => {
                emp_id.innerHTML += `<option value="${empName}">${empName}</option>`;
            });
            //선택 한 값 유지하기
			empNameLoaded = true;
        });
});
//검사결과 select 클릭 시 검사결과 목록 띄우기
var result = document.getElementsByName('result')[0];

var resultLoaded = false;//검사자 목록 불러 왔는지 확인
result.addEventListener('click', function () {

    if(resultLoaded){
        return; //검사결과 목록 클릭 이벤트 한 번만 실행되도록
    }
    //js로 검사결과 목록 불러오는 주소
    fetch(contextPath + '/quality/inspection/option?searchType=result')
        //응답을 json 형태로 변환(JS가 사용할 수 있는 배열이나 객체로 바꾸기 위해서)
        .then(response => response.json())
        .then(data => {
            console.log(' 클릭 시 응답받은 검사결과 목록:', data);

            result.innerHTML = ''; //기존 옵션 제거
            result.innerHTML += '<option value="">선택</option>'; //기본 값 옵션
            //검사결과 목록 반복문
            data.forEach(result_tu => {
                result.innerHTML += `<option value="${result_tu}">${result_tu}</option>`;
            });
            //선택 한 값 유지하기
			resultLoaded = true;
        });
});
//검사상세 select 클릭 시 검사결과 목록 띄우기
var remark = document.getElementsByName('remark')[0];

var remarkLoaded = false;//검사상세 목록 불러 왔는지 확인
remark.addEventListener('click', function () {

    if(remarkLoaded){
        return; //검사상세 목록 클릭 이벤트 한 번만 실행되도록
    }
    //js로 검사상세 목록 불러오는 주소
    fetch(contextPath + '/quality/inspection/option?searchType=remark')
        //응답을 json 형태로 변환(JS가 사용할 수 있는 배열이나 객체로 바꾸기 위해서)
        .then(response => response.json())
        .then(data => {
            console.log(' 클릭 시 응in답받은 검사상세 목록:', data);

            remark.innerHTML = ''; //기존 옵션 제거
            remark.innerHTML += '<option value="">선택</option>'; //기본 값 옵션
            //검사결과 목록 반복문
            data.forEach(remark_tu => {
                remark.innerHTML += `<option value="${remark_tu}">${remark_tu}</option>`;
            });
            //선택 한 값 유지하기
			remarkLoaded = true;
        });
});

//날짜 현재 날짜 기준으로 고정값
const today = new Date();

//년, 월, 일로 따로 받아와야 함
const year = today.getFullYear();
const month = (today.getMonth()+1).toString().padStart(2,'0');//0~11까지 12개
const day = today.getDate().toString().padStart(2,'0');

const formattedDate = `${year}-${month}-${day}`;
consle.log(formattedDate);