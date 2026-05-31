const appContextPath = getAppContextPath();

function getAppContextPath() {
    if (typeof contextPath !== 'undefined') {
        return contextPath;
    }

    const scripts = document.querySelectorAll('script[src]');
    const marker = '/resources/js/inspection.js';

    for (const script of scripts) {
        const src = script.getAttribute('src');

        if (!src) {
            continue;
        }

        const markerIndex = src.indexOf(marker);

        if (markerIndex >= 0) {
            return src.substring(0, markerIndex);
        }
    }

    return '';
}

function addDefaultOption(selectTag) {
    if (!selectTag) {
        return;
    }

    selectTag.innerHTML = '<option value="">선택</option>';
}

function fetchJson(url) {
    return fetch(url).then(response => response.json());
}

function hasText(value) {
    return value !== null && value !== undefined && String(value).trim() !== '';
}

function validateDateRange(form) {
    const startDate = form.querySelector('[name="startDate"]');
    const endDate = form.querySelector('[name="endDate"]');

    if (!startDate || !endDate || !startDate.value || !endDate.value) {
        return true;
    }

    if (startDate.value > endDate.value) {
        alert('시작일은 종료일보다 늦을 수 없습니다.');
        endDate.focus();
        return false;
    }

    return true;
}

window.validateDateRange = validateDateRange;

const coBtnReset = document.querySelector('.search-reset-btn');

if (coBtnReset) {
    coBtnReset.addEventListener('click', function () {
        const startDate = document.getElementsByName('startDate')[0];
        const endDate = document.getElementsByName('endDate')[0];
        const searchType = document.getElementsByName('searchType')[0];
        const keyword = document.getElementsByName('keyword')[0];

        if (startDate) startDate.value = '';
        if (endDate) endDate.value = '';
        if (searchType) searchType.value = '';
        if (keyword) keyword.value = '';
    });
}

document.querySelectorAll('.modal_today').forEach(input => {
    if (!input.value) {
        input.value = new Date().toISOString().slice(0, 10);
    }
});

const inspectionType = document.querySelector('#modal_insert [name="insp_type"]');
const inspectionResult = document.querySelector('#modal_insert [name="result"]');
const RESULT_PASS = '합격';
const RESULT_CONDITIONAL = '조건부';

if (inspectionType) {
    inspectionType.innerHTML = '';
    inspectionType.innerHTML += '<option value="">선택</option>';
    inspectionType.innerHTML += '<option value="외관검사">외관검사</option>';
    inspectionType.innerHTML += '<option value="치수검사">치수검사</option>';
    inspectionType.innerHTML += '<option value="품질판정">품질판정</option>';
    inspectionType.innerHTML += '<option value="재검사">재검사</option>';
}

if (inspectionResult) {
    inspectionResult.innerHTML = '';
    inspectionResult.innerHTML += '<option value="">선택</option>';
    inspectionResult.innerHTML += '<option value="' + RESULT_PASS + '">' + RESULT_PASS + '</option>';
    inspectionResult.innerHTML += '<option value="' + RESULT_CONDITIONAL + '">' + RESULT_CONDITIONAL + '</option>';
}

let productionOptions = null;
let defectOptions = null;
let inspectionDocOptions = null;
const actionEmpCache = {};

function loadProductionOptions(selectTag) {
    if (!selectTag || selectTag.dataset.loaded === 'Y') {
        return;
    }

    const applyOptions = data => {
        addDefaultOption(selectTag);

        data.forEach(item => {
            const textParts = [
                item.prod_doc_no,
                item.product_lot,
                item.item_name,
                item.prod_date ? '생산일 ' + item.prod_date : '',
                item.prod_qty ? '생산 ' + item.prod_qty : ''
            ].filter(hasText);

            const option = document.createElement('option');
            option.value = item.prod_id;
            option.dataset.prodQty = hasText(item.prod_qty) ? item.prod_qty : '';
            option.textContent = textParts.join(' | ');
            selectTag.appendChild(option);
        });

        selectTag.dataset.loaded = 'Y';
        applySelectedProductionQty(selectTag);
    };

    if (productionOptions) {
        applyOptions(productionOptions);
        return;
    }

    fetchJson(appContextPath + '/quality/inspection/option?searchType=productionTarget&optionSize=100')
        .then(data => {
            productionOptions = data;
            applyOptions(data);
        });
}

function loadDefectOptions(selectTag) {
    if (!selectTag || selectTag.dataset.loaded === 'Y') {
        return;
    }

    const selectedValue = selectTag.dataset.selected || selectTag.value;

    const applyOptions = data => {
        addDefaultOption(selectTag);

        data.forEach(defect => {
            const option = document.createElement('option');
            option.value = defect.defect_id;
            option.dataset.dept = defect.action_dept || defect.dept || '';
            option.textContent = [
                defect.defect_code ? '[' + defect.defect_code + ']' : '',
                defect.defect_name || '',
                defect.defect_type ? '(' + defect.defect_type + ')' : ''
            ].filter(hasText).join(' ');

            if (String(defect.defect_id) === String(selectedValue)) {
                option.selected = true;
            }

            selectTag.appendChild(option);
        });

        selectTag.dataset.loaded = 'Y';
    };

    if (defectOptions) {
        applyOptions(defectOptions);
        return;
    }

    fetchJson(appContextPath + '/quality/defect/option')
        .then(data => {
            defectOptions = data;
            applyOptions(data);
        });
}

function loadInspectionDocOptions(selectTag) {
    if (!selectTag || selectTag.dataset.loaded === 'Y') {
        return;
    }

    const applyOptions = data => {
        addDefaultOption(selectTag);

        data.forEach(inspection => {
            const option = document.createElement('option');
            option.value = inspection.insp_id;
            option.textContent = [
                inspection.doc_no,
                inspection.item_name,
                inspection.product_lot
            ].filter(hasText).join(' | ');
            selectTag.appendChild(option);
        });

        selectTag.dataset.loaded = 'Y';
    };

    if (inspectionDocOptions) {
        applyOptions(inspectionDocOptions);
        return;
    }

    fetchJson(appContextPath + '/quality/inspection/option?searchType=docNo&optionSize=100')
        .then(data => {
            inspectionDocOptions = data;
            applyOptions(data);
        });
}

function loadActionEmpOptions(selectTag, dept) {
    if (!selectTag) {
        return;
    }

    if (!hasText(dept)) {
        addDefaultOption(selectTag);
        return;
    }

    if (selectTag.dataset.loadedDept === dept) {
        return;
    }

    const applyOptions = data => {
        addDefaultOption(selectTag);

        data.forEach(emp => {
            const option = document.createElement('option');
            option.value = emp.action_emp_id;
            option.textContent = emp.action_ename;
            selectTag.appendChild(option);
        });

        selectTag.dataset.loadedDept = dept;
    };

    if (actionEmpCache[dept]) {
        applyOptions(actionEmpCache[dept]);
        return;
    }

    fetchJson(appContextPath + '/quality/defect/action/empOption?dept=' + encodeURIComponent(dept))
        .then(data => {
            actionEmpCache[dept] = data;
            applyOptions(data);
        });
}

document.querySelectorAll('select[name="prod_id"]').forEach(select => {
    select.addEventListener('focus', function () {
        loadProductionOptions(select);
    });
    select.addEventListener('click', function () {
        loadProductionOptions(select);
    });
    select.addEventListener('change', function () {
        applySelectedProductionQty(select);
    });
});

document.querySelectorAll('select[name="defect_id"]').forEach(select => {
    select.addEventListener('focus', function () {
        loadDefectOptions(select);
    });
    select.addEventListener('click', function () {
        loadDefectOptions(select);
    });
});

document.querySelectorAll('select[name="insp_id"]').forEach(select => {
    select.addEventListener('focus', function () {
        loadInspectionDocOptions(select);
    });
    select.addEventListener('click', function () {
        loadInspectionDocOptions(select);
    });
});

const hasDefect = document.getElementById('hasDefect');
const inspectionDefectArea = document.getElementById('inspectionDefectArea');
const inspectionDefectId = document.getElementById('inspectionDefectId');
const inspectionActionDept = document.getElementById('inspectionActionDept');
const inspectionActionEmpId = document.getElementById('inspectionActionEmpId');
const inspectionInsertForm = document.querySelector('#modal_insert form');
const inspectionProdQty = document.getElementById('inspectionProdQty');
const inspectionGoodQty = document.getElementById('inspectionGoodQty');
const inspectionDefectQty = document.getElementById('inspectionDefectQty');
const inspectionQtyError = document.getElementById('inspectionQtyError');
const inspectionSubmitBtn = document.querySelector('#modal_insert .modal_btn_submit');

function toNumber(input) {
    if (!input || !hasText(input.value)) {
        return 0;
    }

    const value = Number(input.value);
    return Number.isFinite(value) ? value : 0;
}

function applySelectedProductionQty(selectTag) {
    if (!selectTag || !inspectionProdQty) {
        return;
    }

    const selectedOption = selectTag.options[selectTag.selectedIndex];
    const prodQty = selectedOption ? selectedOption.dataset.prodQty : '';

    inspectionProdQty.value = hasText(prodQty) ? prodQty : '';
    validateInspectionQuantity();
}

function isPassResult() {
    return inspectionResult && inspectionResult.value === RESULT_PASS;
}

function isConditionalResult() {
    return inspectionResult && inspectionResult.value === RESULT_CONDITIONAL;
}

function setInspectionQtyError(message) {
    if (!inspectionQtyError) {
        return;
    }

    if (message) {
        inspectionQtyError.textContent = message;
        inspectionQtyError.style.display = '';
        return;
    }

    inspectionQtyError.style.display = 'none';
}

function validateInspectionQuantity() {
    if (!inspectionProdQty || !inspectionGoodQty) {
        return true;
    }

    const prodQty = toNumber(inspectionProdQty);
    const goodQty = toNumber(inspectionGoodQty);
    const defectQty = hasDefect && hasDefect.checked && !hasDefect.disabled ? toNumber(inspectionDefectQty) : 0;
    let errorMessage = '';

    if (prodQty > 0 && goodQty + defectQty > prodQty) {
        errorMessage = '생산 수량을 초과 할 수 없습니다.';
    } else if (isPassResult() && prodQty > 0 && goodQty !== prodQty) {
        errorMessage = '합격은 생산수량 전체가 양품수량이어야 합니다.';
    } else if (isConditionalResult()) {
        if (!hasDefect || !hasDefect.checked) {
            errorMessage = '조건부는 불량 정보 및 조치를 함께 등록해야 합니다.';
        } else if (defectQty <= 0) {
            errorMessage = '조건부는 불량수량을 1개 이상 입력해야 합니다.';
        } else if (prodQty > 0 && goodQty + defectQty !== prodQty) {
            errorMessage = '조건부는 양품수량과 불량수량의 합계가 생산수량과 같아야 합니다.';
        }
    }

    setInspectionQtyError(errorMessage);

    if (inspectionSubmitBtn) {
        inspectionSubmitBtn.disabled = !!errorMessage;
    }

    return !errorMessage;
}

function updateDefectCheckboxByResult() {
    if (!hasDefect) {
        return;
    }

    if (isPassResult()) {
        hasDefect.checked = false;
        hasDefect.disabled = true;
    } else if (isConditionalResult()) {
        hasDefect.checked = true;
        hasDefect.disabled = false;
    } else {
        hasDefect.disabled = false;
    }

    toggleInspectionDefectArea();
    validateInspectionQuantity();
}

function toggleInspectionDefectArea() {
    if (!hasDefect || !inspectionDefectArea) {
        return;
    }

    const isChecked = hasDefect.checked && !hasDefect.disabled && !isPassResult();
    inspectionDefectArea.style.display = isChecked ? '' : 'none';

    inspectionDefectArea.querySelectorAll('input, select, textarea').forEach(input => {
        input.disabled = !isChecked;
    });

    inspectionDefectArea.querySelectorAll('.defectRequired').forEach(input => {
        input.required = isChecked;
    });

    if (isChecked && inspectionDefectId) {
        loadDefectOptions(inspectionDefectId);
    }

    validateInspectionQuantity();
}

function updateInspectionActionDept() {
    if (!inspectionDefectId) {
        return;
    }

    const selectedOption = inspectionDefectId.options[inspectionDefectId.selectedIndex];
    const dept = selectedOption ? selectedOption.dataset.dept : '';

    if (inspectionActionDept) {
        inspectionActionDept.value = dept || '';
    }

    if (inspectionActionEmpId) {
        inspectionActionEmpId.dataset.loadedDept = '';
        loadActionEmpOptions(inspectionActionEmpId, dept);
    }
}

if (hasDefect) {
    hasDefect.addEventListener('change', toggleInspectionDefectArea);
    toggleInspectionDefectArea();
}

if (inspectionResult) {
    inspectionResult.addEventListener('change', updateDefectCheckboxByResult);
    updateDefectCheckboxByResult();
}

if (inspectionGoodQty) {
    inspectionGoodQty.addEventListener('input', validateInspectionQuantity);
}

if (inspectionDefectQty) {
    inspectionDefectQty.addEventListener('input', validateInspectionQuantity);
}

if (inspectionInsertForm) {
    inspectionInsertForm.addEventListener('submit', function (event) {
        if (!validateInspectionQuantity()) {
            event.preventDefault();

            if (inspectionQtyError) {
                inspectionQtyError.style.display = '';
            }

            if (inspectionGoodQty) {
                inspectionGoodQty.focus();
            }
        }
    });
}

if (inspectionDefectId) {
    inspectionDefectId.addEventListener('change', updateInspectionActionDept);
}

if (inspectionActionEmpId) {
    inspectionActionEmpId.addEventListener('focus', function () {
        loadActionEmpOptions(inspectionActionEmpId, inspectionActionDept ? inspectionActionDept.value : '');
    });
    inspectionActionEmpId.addEventListener('click', function () {
        loadActionEmpOptions(inspectionActionEmpId, inspectionActionDept ? inspectionActionDept.value : '');
    });
}

const actionEmpId = document.querySelector('#actionEmpId');

if (actionEmpId) {
    actionEmpId.addEventListener('focus', function () {
        loadActionEmpOptions(actionEmpId, actionEmpId.dataset.dept);
    });
    actionEmpId.addEventListener('click', function () {
        loadActionEmpOptions(actionEmpId, actionEmpId.dataset.dept);
    });
}

function changeEditMode(isEdit) {
    const detailTexts = document.querySelectorAll('.detailText');
    const detailInputs = document.querySelectorAll('.detailInput');
    const editBtn = document.querySelector('#editBtn');
    const saveBtn = document.querySelector('#saveBtn');
    const cancelBtn = document.querySelector('#cancelBtn');
    const defectForm = document.querySelector('#defectDetailForm');

    detailTexts.forEach(function (text) {
        text.style.display = isEdit ? 'none' : '';
    });

    detailInputs.forEach(function (input) {
        input.style.display = isEdit ? 'inline-block' : 'none';

        if (isEdit && input.name === 'defect_id') {
            loadDefectOptions(input);
        }
    });

    if (editBtn) {
        editBtn.style.display = isEdit ? 'none' : 'inline-flex';
    }

    if (saveBtn) {
        saveBtn.style.display = isEdit ? 'inline-flex' : 'none';
    }

    if (cancelBtn) {
        cancelBtn.style.display = isEdit ? 'inline-flex' : 'none';
    }

    if (!isEdit && defectForm) {
        defectForm.reset();
    }
}

window.changeEditMode = changeEditMode;

const checkAllHeaders = document.querySelectorAll('.checkAllHeader');

checkAllHeaders.forEach(header => {
    header.addEventListener('click', function () {
        const table = header.closest('table');

        if (!table) {
            return;
        }

        const checkboxes = table.querySelectorAll('tbody input[type="checkbox"]');

        if (checkboxes.length === 0) {
            return;
        }

        const allChecked = Array.from(checkboxes).every(checkbox => checkbox.checked);

        checkboxes.forEach(checkbox => {
            checkbox.checked = !allChecked;
        });
    });
});
