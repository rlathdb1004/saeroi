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
const itemName = document.getElementsByName('item_name')[0];

let itemNameLoaded = false;

itemName.addEventListener('click', function () {

    if (itemNameLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=itemName')
        .then(response => response.json())
        .then(data => {
            itemName.innerHTML = '';
            itemName.innerHTML += '<option value="">선택</option>';

            data.forEach(item => {
                itemName.innerHTML += `<option value="${item}">${item}</option>`;
            });

            itemNameLoaded = true;
        });
});


//검사자 select 클릭 시 검사자 목록 띄우기
const inspector = document.getElementsByName('inspector')[0];

let inspectorLoaded = false;

inspector.addEventListener('click', function () {

    if (inspectorLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=ename')
        .then(response => response.json())
        .then(data => {
            inspector.innerHTML = '';
            inspector.innerHTML += '<option value="">선택</option>';

            data.forEach(name => {
                inspector.innerHTML += `<option value="${name}">${name}</option>`;
            });

            inspectorLoaded = true;
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
const inspectionResult = document.getElementsByName('inspection_result')[0];

let resultLoaded = false;

inspectionResult.addEventListener('click', function () {

    if (resultLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=result')
        .then(response => response.json())
        .then(data => {
            inspectionResult.innerHTML = '';
            inspectionResult.innerHTML += '<option value="">선택</option>';

            data.forEach(result => {
                inspectionResult.innerHTML += `<option value="${result}">${result}</option>`;
            });

            resultLoaded = true;
        });
});


//검사상세 select 클릭 시 검사상세 목록 띄우기
const inspectionDetail = document.getElementsByName('inspection_detail')[0];

let detailLoaded = false;

inspectionDetail.addEventListener('click', function () {

    if (detailLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=remark')
        .then(response => response.json())
        .then(data => {
            inspectionDetail.innerHTML = '';
            inspectionDetail.innerHTML += '<option value="">선택</option>';

            data.forEach(detail => {
                inspectionDetail.innerHTML += `<option value="${detail}">${detail}</option>`;
            });

            detailLoaded = true;
        });
});
