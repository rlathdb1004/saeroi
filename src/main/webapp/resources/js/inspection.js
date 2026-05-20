const coBtnReset = document.querySelector('.search-reset-btn');
//초기화 기능
if (coBtnReset) {
    coBtnReset.addEventListener('click', function () {
        document.getElementsByName('startDate')[0].value = '';
        document.getElementsByName('endDate')[0].value = '';
        document.getElementsByName('searchType')[0].value = '';
        document.getElementsByName('keyword')[0].value = '';
    });
}
// 모달 안에 있는 select 태그들 가져오기
const prodId = document.getElementsByName('prod_id')[0];
const empId = document.getElementsByName('emp_id')[0];
const inspectionType = document.getElementsByName('insp_type')[0];
const result = document.getElementsByName('result')[0];
// 옵션을 이미 불러왔는지 확인하는 변수
let prodLoaded = false;
let empLoaded = false;
// select 태그를 비우고 기본 옵션을 넣는 함수
function addDefaultOption(selectTag) {
    selectTag.innerHTML = '';
    selectTag.innerHTML += '<option value="">\uC120\uD0DD</option>';
}
//품목명 목록 불러옴 DB에서
function loadProdOptions() {
    if (!prodId || prodLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=itemName')
        .then(response => response.json())
        .then(data => {
            addDefaultOption(prodId);

            data.forEach(item => {
                prodId.innerHTML += `<option value="${item.prod_id}">${item.item_name}</option>`;
            });

            prodLoaded = true;
        });
}
//검사자 목록 불러옴 DB에서
function loadEmpOptions() {
    if (!empId || empLoaded) {
        return;
    }

    fetch(contextPath + '/quality/inspection/option?searchType=ename')
        .then(response => response.json())
        .then(data => {
            console.log('emp option data:', data);

            addDefaultOption(empId);

            data.forEach(emp => {
                empId.innerHTML += `<option value="${emp.emp_id}">${emp.ename}</option>`;
            });

            empLoaded = true;
        });
}
// 품목명 select 클릭 또는 포커스 시 품목명 옵션 불러오기
if (prodId) {
    prodId.addEventListener('focus', loadProdOptions);
    prodId.addEventListener('click', loadProdOptions);
}
// 검사자 select 클릭 또는 포커스 시 검사자 옵션 불러오기
if (empId) {
    empId.addEventListener('focus', loadEmpOptions);
    empId.addEventListener('click', loadEmpOptions);
}
// 검사구분 select에 고정 옵션 넣기
if (inspectionType) {
    inspectionType.innerHTML = '';
    inspectionType.innerHTML += '<option value="">\uC120\uD0DD</option>';
    inspectionType.innerHTML += '<option value="\uC678\uAD00\uAC80\uC0AC">\uC678\uAD00\uAC80\uC0AC</option>';
    inspectionType.innerHTML += '<option value="\uCE58\uC218\uAC80\uC0AC">\uCE58\uC218\uAC80\uC0AC</option>';
    inspectionType.innerHTML += '<option value="\uD488\uC9C8\uD310\uC815">\uD488\uC9C8\uD310\uC815</option>';
    inspectionType.innerHTML += '<option value="\uC7AC\uAC80\uC0AC">\uC7AC\uAC80\uC0AC</option>';
}
// 검사결과 select에 고정 옵션 넣기
if (result) {
    result.innerHTML = '';
    result.innerHTML += '<option value="">\uC120\uD0DD</option>';
    result.innerHTML += '<option value="\uD569\uACA9">\uD569\uACA9</option>';
    result.innerHTML += '<option value="\uC870\uAC74\uBD80">\uC870\uAC74\uBD80</option>';
}
// 페이지가 열리면 품목명, 검사자 옵션 미리 불러오기
loadProdOptions();
loadEmpOptions();

//수정 클릭 하면 인풋창으로 변경 됨(수정은 검사 일시, 품목명, 검사자, 검사결과, 검사 구분, ~수량, 비고까지 가능하게 할 것임)
//수정 할 칸이 여러 개이므로 All로 해야 함
const detailEditBtn = document.querySelector('#detailEditBtn');//수정 버튼
const detailText = document.querySelectorAll('.detailText');//span 부분 공통 클래스
const detailInput = document.querySelectorAll('.detailInput');//숨어 있는 인풋

if (detailEditBtn) {
    detailEditBtn.addEventListener('click', function () {

        detailText.forEach(function (text) {
            text.style.display = 'none';
        });

        detailInput.forEach(function (input) {
            input.style.display = 'inline-block';
        });

        detailEditBtn.style.display = 'none';
    });
}

function changeEditMode(isEdit) {
		var detailTexts = document.querySelectorAll('.detailText');
		var detailInputs = document.querySelectorAll('.detailInput');

		var editBtn = document.querySelector('#editBtn');
		var saveBtn = document.querySelector('#saveBtn');
		var cancelBtn = document.querySelector('#cancelBtn');

		detailTexts.forEach(function(text) {
			text.style.display = isEdit ? 'none' : '';
		});

		detailInputs.forEach(function(input) {
			input.style.display = isEdit ? 'inline-block' : 'none';
		});

		editBtn.style.display = isEdit ? 'none' : 'inline-block';
		saveBtn.style.display = isEdit ? 'inline-block' : 'none';
		cancelBtn.style.display = isEdit ? 'inline-block' : 'none';
	}
