//초기화 버튼
const coBtnReset = document.querySelector('.search-reset-btn');

coBtnReset.addEventListener('click', function () {
    //초기화 버튼 클릭 시 시작일과 종료일 초기화
    document.getElementsByName('startDate')[0].value = '';
    document.getElementsByName('endDate')[0].value = '';
    document.getElementsByName('searchType')[0].value = '';
    document.getElementsByName('keyword')[0].value = '';
});


//품목명 select 클릭 시 품목명 목록 띄우기
const prodId = document.getElementsByName('prod_id')[0];

let prodLoaded = false;

prodId.addEventListener('click', function () {

    if (prodLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=itemName')
        .then(response => response.json())
        .then(data => {
            prodId.innerHTML = '';
            prodId.innerHTML += '<option value="">선택</option>';

            data.forEach(item => {
                prodId.innerHTML += `<option value="${item}">${item}</option>`;
            });

            prodLoaded = true;
        });
});


//검사자 select 클릭 시 검사자 목록 띄우기
const empId = document.getElementsByName('emp_id')[0];

let empLoaded = false;

empId.addEventListener('click', function () {

    if (empLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=ename')
        .then(response => response.json())
        .then(data => {
            empId.innerHTML = '';
            empId.innerHTML += '<option value="">선택</option>';

            data.forEach(name => {
                empId.innerHTML += `<option value="${name}">${name}</option>`;
            });

            empLoaded = true;
        });
});


//검사구분 select 기본 목록 넣기
const inspectionType = document.getElementsByName('inspection_type')[0];

inspectionType.innerHTML = '';
inspectionType.innerHTML += '<option value="">선택</option>';
inspectionType.innerHTML += '<option value="외관검사">외관검사</option>';
inspectionType.innerHTML += '<option value="치수검사">치수검사</option>';
inspectionType.innerHTML += '<option value="품질판정">품질판정</option>';
inspectionType.innerHTML += '<option value="재검사">재검사</option>';


//검사결과 select 클릭 시 검사결과 목록 띄우기
const result = document.getElementsByName('result')[0];

let resultLoaded = false;

result.addEventListener('click', function () {

    if (resultLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=result')
        .then(response => response.json())
        .then(data => {
            result.innerHTML = '';
            result.innerHTML += '<option value="">선택</option>';

            data.forEach(resultValue => {
                result.innerHTML += `<option value="${resultValue}">${resultValue}</option>`;
            });

            resultLoaded = true;
        });
});
