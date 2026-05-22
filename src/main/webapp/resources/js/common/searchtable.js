// 화면 로딩 후 실행
document.addEventListener("DOMContentLoaded", function () {

    // 검색 시작일 달력에 오늘 날짜를 세팅한다.
    initSearchStartDateDefaultToday();

    // 검색 초기화 버튼 기능을 실행한다.
    initSearchResetButtons();

    // 공통 목록 테이블 컬럼 조절 기능을 실행한다.
    initCommonResizableTables();

    // 공통 목록 테이블 행 클릭 상세 이동 기능을 실행한다.
    initCommonRowDetailMove();

    // 공통 목록 테이블 툴팁 기능을 실행한다.
    initCommonTableTooltip();

});


// 화면 크기가 바뀌었을 때 테이블 컬럼 폭을 다시 맞춘다.
window.addEventListener("resize", function () {

    var tableList = document.querySelectorAll(".coTableWrap .coTable");

    for (var i = 0; i < tableList.length; i++) {
        fitCommonColumnWidthsToTable(tableList[i]);
    }

    // 화면 크기 변경 후 툴팁 필요 여부를 다시 검사한다.
    refreshCommonTableTooltip();

});

/**
 * 검색 시작일 기본값 오늘 날짜 세팅
 */
function initSearchStartDateDefaultToday() {

    // 검색 form 전체를 찾는다.
    var searchFormList = document.querySelectorAll(".search-form");

    // 검색 form이 없으면 종료한다.
    if (searchFormList.length === 0) {
        return;
    }

    // 오늘 날짜를 yyyy-MM-dd 형식으로 만든다.
    var todayValue = getSearchTodayDateValue();

    for (var i = 0; i < searchFormList.length; i++) {
        setSearchStartDateDefaultToday(searchFormList[i], todayValue);
    }

}


/**
 * 오늘 날짜를 input type="date"에 맞는 yyyy-MM-dd 형식으로 만든다.
 */
function getSearchTodayDateValue() {

    var today = new Date();

    var year = today.getFullYear();
    var month = String(today.getMonth() + 1).padStart(2, "0");
    var date = String(today.getDate()).padStart(2, "0");

    return year + "-" + month + "-" + date;

}


/**
 * 검색 form 안에 있는 비어있는 시작일 달력에만 오늘 날짜를 넣는다.
 */
function setSearchStartDateDefaultToday(searchForm, todayValue) {

	// 리포트처럼 시작일 기본값을 넣지 않아야 하는 검색 영역은 제외한다.
    if (searchForm.classList.contains("search-no-default-date")) {
        return;
    }
    
    // 검색 영역 안의 시작일 달력만 찾는다.
    var startDateList = searchForm.querySelectorAll("input[type='date'][name='startDate'].search-date");

    for (var i = 0; i < startDateList.length; i++) {

        // 이미 값이 있으면 검색 유지값이므로 건드리지 않는다.
        if (startDateList[i].value !== "") {
            continue;
        }

        // readonly 또는 disabled 상태면 건드리지 않는다.
        if (startDateList[i].readOnly || startDateList[i].disabled) {
            continue;
        }

        // 비어있는 시작일 달력에만 오늘 날짜를 넣는다.
        startDateList[i].value = todayValue;
    }

}


/**
 * 검색 초기화 버튼 기능
 */
function initSearchResetButtons() {

    // 초기화 버튼 전체 찾기
    var resetBtnList = document.querySelectorAll(".search-reset-btn");

    // 초기화 버튼 클릭 이벤트 연결
    for (var i = 0; i < resetBtnList.length; i++) {

        resetBtnList[i].addEventListener("click", function () {

            // 클릭한 버튼이 들어있는 form 찾기
            var searchForm = this.closest("form");

            // form이 없으면 종료
            if (searchForm == null) {
                return;
            }

            // input 값 비우기
            var inputList = searchForm.querySelectorAll("input");

            for (var j = 0; j < inputList.length; j++) {
                inputList[j].value = "";
            }

            // select 첫 번째 값으로 변경
            var selectList = searchForm.querySelectorAll("select");

            for (var k = 0; k < selectList.length; k++) {
                selectList[k].selectedIndex = 0;
            }

            // 초기화 후 시작일 달력만 다시 오늘 날짜로 세팅한다.
            setSearchStartDateDefaultToday(searchForm, getSearchTodayDateValue());

        });

    }

}


/**
 * 공통 목록 테이블 컬럼 조절 기능
 */
function initCommonResizableTables() {

    // 공통 목록 테이블만 찾는다.
    var tableList = document.querySelectorAll(".coTableWrap .coTable");

    for (var i = 0; i < tableList.length; i++) {
        initCommonResizableTable(tableList[i]);
    }

}


/**
 * 테이블 하나에 컬럼 조절 기능을 적용한다.
 */
function initCommonResizableTable(table) {

    // 모바일에서는 컬럼 조절 기능을 사용하지 않는다.
    if (window.innerWidth <= 760) {
        removeCommonColumnResizers(table);
        return;
    }

    // thead가 없는 테이블은 제외한다.
    var thList = table.querySelectorAll("thead th");

    if (thList.length === 0) {
        return;
    }

    // 중복 실행을 막기 위해 기존 핸들을 먼저 제거한다.
    removeCommonColumnResizers(table);

    // colgroup이 없으면 자동으로 생성한다.
    createCommonColgroupIfNotExists(table);

    var colList = table.querySelectorAll("colgroup col");

    if (colList.length === 0) {
        return;
    }

    // 처음 한 번만 기본 컬럼 폭을 세팅한다.
    if (table.getAttribute("data-resizable-width-set") !== "Y") {
        setCommonDefaultColumnWidths(table, colList);
        table.setAttribute("data-resizable-width-set", "Y");
    }

    // 마지막 컬럼은 오른쪽으로 같이 조절할 컬럼이 없어서 제외한다.
    for (var i = 0; i < thList.length - 1; i++) {
        addCommonColumnResizeHandle(table, colList, thList[i], i);
    }

    // 테이블 폭이 화면 밖으로 나가지 않게 보정한다.
    fitCommonColumnWidthsToTable(table);

}


/**
 * 기존 컬럼 조절 핸들을 제거한다.
 */
function removeCommonColumnResizers(table) {

    var resizerList = table.querySelectorAll(".column-resizer");

    for (var i = 0; i < resizerList.length; i++) {
        resizerList[i].remove();
    }

}


/**
 * colgroup이 없으면 자동으로 생성한다.
 */
function createCommonColgroupIfNotExists(table) {

    var existingColgroup = table.querySelector("colgroup");

    if (existingColgroup != null) {
        return;
    }

    var thList = table.querySelectorAll("thead th");

    if (thList.length === 0) {
        return;
    }

    var colgroup = document.createElement("colgroup");

    for (var i = 0; i < thList.length; i++) {
        var col = document.createElement("col");
        colgroup.appendChild(col);
    }

    table.insertBefore(colgroup, table.firstChild);

}


/**
 * 공통 테이블 기본 컬럼 폭을 세팅한다.
 */
function setCommonDefaultColumnWidths(table, colList) {

    var tableWidth = getCommonAvailableTableWidth(table);
    var colCount = colList.length;

    if (tableWidth <= 0 || colCount === 0) {
        return;
    }

    var firstWidth = 48;
    var lastWidth = 80;
    var remainCount = colCount;

    // 첫 번째 컬럼이 있으면 선택 컬럼으로 보고 작게 잡는다.
    if (colCount >= 1) {
        colList[0].style.width = firstWidth + "px";
        remainCount--;
    }

    // 마지막 컬럼이 있으면 상세 컬럼으로 보고 작게 잡는다.
    if (colCount >= 2) {
        colList[colCount - 1].style.width = lastWidth + "px";
        remainCount--;
    }

    var remainWidth = tableWidth - firstWidth - lastWidth;

    if (remainWidth < 0) {
        remainWidth = tableWidth;
    }

    var normalWidth = 120;

    if (remainCount > 0) {
        normalWidth = Math.floor(remainWidth / remainCount);
    }

    if (normalWidth < 90) {
        normalWidth = 90;
    }

    for (var i = 1; i < colCount - 1; i++) {
        colList[i].style.width = normalWidth + "px";
    }

}


/**
 * th 오른쪽에 컬럼 조절 핸들을 붙인다.
 */
function addCommonColumnResizeHandle(table, colList, th, index) {

    var resizer = document.createElement("span");
    resizer.className = "column-resizer";

    th.appendChild(resizer);

    var startX = 0;
    var leftStartWidth = 0;
    var rightStartWidth = 0;
    var rightIndex = index + 1;

    resizer.addEventListener("mousedown", function (event) {

        event.preventDefault();
        event.stopPropagation();

        startX = event.pageX;
        leftStartWidth = getCommonColWidth(colList[index]);
        rightStartWidth = getCommonColWidth(colList[rightIndex]);

        document.body.classList.add("is-column-resizing");

        document.addEventListener("mousemove", resizeCommonColumnPair);
        document.addEventListener("mouseup", stopResizeCommonColumnPair);

    });


    function resizeCommonColumnPair(event) {

        var diffX = event.pageX - startX;

        var leftMinWidth = getCommonColumnMinWidth(index, colList.length);
        var rightMinWidth = getCommonColumnMinWidth(rightIndex, colList.length);

        var newLeftWidth = leftStartWidth + diffX;
        var newRightWidth = rightStartWidth - diffX;

        if (newLeftWidth < leftMinWidth) {
            newLeftWidth = leftMinWidth;
            newRightWidth = leftStartWidth + rightStartWidth - newLeftWidth;
        }

        if (newRightWidth < rightMinWidth) {
            newRightWidth = rightMinWidth;
            newLeftWidth = leftStartWidth + rightStartWidth - newRightWidth;
        }

        colList[index].style.width = newLeftWidth + "px";
        colList[rightIndex].style.width = newRightWidth + "px";

        fitCommonColumnWidthsToTable(table);

    }


    function stopResizeCommonColumnPair() {

        document.body.classList.remove("is-column-resizing");

        document.removeEventListener("mousemove", resizeCommonColumnPair);
        document.removeEventListener("mouseup", stopResizeCommonColumnPair);

        // 컬럼 조절 후 툴팁 필요 여부를 다시 검사한다.
        refreshCommonTableTooltip();
    }


    // 컬럼 조절 핸들을 더블클릭하면 기본 폭으로 되돌린다.
    resizer.addEventListener("dblclick", function (event) {

        event.preventDefault();
        event.stopPropagation();

        table.removeAttribute("data-resizable-width-set");

        setCommonDefaultColumnWidths(table, colList);
        table.setAttribute("data-resizable-width-set", "Y");

        fitCommonColumnWidthsToTable(table);

    });

}


/**
 * 컬럼 폭 합계가 테이블 영역을 넘지 않게 보정한다.
 */
function fitCommonColumnWidthsToTable(table) {

    if (window.innerWidth <= 760) {
        return;
    }

    var colList = table.querySelectorAll("colgroup col");

    if (colList.length === 0) {
        return;
    }

    var tableWidth = getCommonAvailableTableWidth(table);

    if (tableWidth <= 0) {
        return;
    }

    var totalWidth = 0;

    for (var i = 0; i < colList.length; i++) {
        totalWidth += getCommonColWidth(colList[i]);
    }

    if (totalWidth <= tableWidth) {
        return;
    }

    var ratio = tableWidth / totalWidth;

    for (var j = 0; j < colList.length; j++) {

        var currentWidth = getCommonColWidth(colList[j]);
        var minWidth = getCommonColumnMinWidth(j, colList.length);
        var newWidth = Math.floor(currentWidth * ratio);

        if (newWidth < minWidth) {
            newWidth = minWidth;
        }

        colList[j].style.width = newWidth + "px";

    }

}


/**
 * 테이블이 사용할 수 있는 실제 너비를 구한다.
 */
function getCommonAvailableTableWidth(table) {

    var parent = table.parentElement;

    if (parent == null) {
        return Math.floor(table.getBoundingClientRect().width);
    }

    return Math.floor(parent.getBoundingClientRect().width);

}


/**
 * col의 현재 너비를 구한다.
 */
function getCommonColWidth(col) {

    var width = parseFloat(col.style.width);

    if (isNaN(width) || width <= 0) {
        width = col.getBoundingClientRect().width;
    }

    if (isNaN(width) || width <= 0) {
        width = 120;
    }

    return width;

}


/**
 * 컬럼별 최소 너비를 정한다.
 */
function getCommonColumnMinWidth(index, colCount) {

    // 첫 번째 선택 컬럼
    if (index === 0) {
        return 42;
    }

    // 마지막 상세 컬럼
    if (index === colCount - 1) {
        return 60;
    }

    // 일반 컬럼
    return 80;

}


/**
 * 공통 목록 테이블 행 클릭 상세 이동 기능
 */
function initCommonRowDetailMove() {

    // 공통 테이블의 목록 행을 찾는다.
    var rowList = document.querySelectorAll(".coTable tbody tr");

    for (var i = 0; i < rowList.length; i++) {

        // 행 안에 상세보기 버튼이 있는지 확인한다.
        var detailBtn = rowList[i].querySelector(".coDetailBtn");

        // 상세보기 버튼이 없는 행은 제외한다.
        if (detailBtn == null) {
            continue;
        }

        // 상세 이동이 가능한 행에 표시용 클래스를 추가한다.
        rowList[i].classList.add("coRowClickable");

        // 행 클릭 이벤트를 연결한다.
        rowList[i].addEventListener("click", function (event) {

            // 컬럼 너비 조절 중이면 상세 이동을 막는다.
            if (document.body.classList.contains("is-column-resizing")) {
                return;
            }

            // 체크박스, 버튼, 링크, 셀렉트박스 등을 클릭한 경우에는 행 이동을 막는다.
            var stopTarget = event.target.closest("input, button, a, select, textarea, label, .column-resizer");

            if (stopTarget != null) {
                return;
            }

            // 현재 행 안의 상세보기 버튼을 다시 찾는다.
            var rowDetailBtn = this.querySelector(".coDetailBtn");

            // 상세보기 버튼이 없으면 종료한다.
            if (rowDetailBtn == null) {
                return;
            }

            // 기존 상세보기 버튼을 클릭한 것처럼 실행한다.
            rowDetailBtn.click();

        });

    }

}


/**
 * 공통 목록 테이블 커스텀 툴팁 기능
 */
function initCommonTableTooltip() {

    // 화면 전체 위에 뜨는 공통 툴팁 박스를 만든다.
    var tooltipBox = document.querySelector(".coCommonTooltip");

    if (tooltipBox == null) {
        tooltipBox = document.createElement("div");
        tooltipBox.className = "coCommonTooltip";
        document.body.appendChild(tooltipBox);
    }

    // 현재 툴팁이 떠 있는 셀을 저장한다.
    window.coActiveTooltipCell = null;

    // 공통 테이블의 제목 칸과 내용 칸을 찾는다.
    var tdList = document.querySelectorAll(".coTable thead th, .coTable tbody td");

    for (var i = 0; i < tdList.length; i++) {

        // 이미 이벤트가 연결된 칸은 다시 연결하지 않는다.
        if (tdList[i].getAttribute("data-tooltip-ready") === "Y") {
            continue;
        }

        // 체크박스, 버튼, 링크, 셀렉트박스가 들어있는 칸은 제외한다.
        var exceptElement = tdList[i].querySelector("input, button, a, select, textarea, label");

        if (exceptElement != null) {
            continue;
        }

        // 기존 title 값을 먼저 가져온다.
        var tooltipText = tdList[i].getAttribute("title");

        // title이 없으면 현재 칸의 글자를 가져온다.
        if (tooltipText == null || tooltipText.trim() === "") {
            tooltipText = tdList[i].textContent.trim();
        }

        // 글자가 없으면 제외한다.
        if (tooltipText === "") {
            continue;
        }

        // 기본 브라우저 툴팁이 뜨지 않도록 title을 제거한다.
        tdList[i].removeAttribute("title");

        // 커스텀 툴팁에서 사용할 값을 저장한다.
        tdList[i].setAttribute("data-tooltip", tooltipText);

        // 중복 이벤트 연결을 막기 위한 표시이다.
        tdList[i].setAttribute("data-tooltip-ready", "Y");

        // 마우스가 올라간 순간 글자가 잘렸는지 다시 검사한다.
        tdList[i].addEventListener("mouseenter", function () {
            showCommonTooltip(this, tooltipBox);
        });

        // 마우스가 셀을 벗어나면 바로 툴팁을 숨긴다.
        tdList[i].addEventListener("mouseleave", function () {
            hideCommonTooltip(tooltipBox);
        });

    }

    // 현재 화면 기준으로 툴팁 표시가 필요한 셀만 표시한다.
    refreshCommonTableTooltip();

    // 문서 전체에서 마우스가 움직일 때 현재 툴팁 셀 밖이면 툴팁을 숨긴다.
    if (document.body.getAttribute("data-tooltip-move-ready") !== "Y") {

        document.body.setAttribute("data-tooltip-move-ready", "Y");

        document.addEventListener("mousemove", function (event) {

            var currentTooltipCell = event.target.closest(".coTooltipCell");
            var currentTooltipBox = document.querySelector(".coCommonTooltip");

            if (currentTooltipBox == null) {
                return;
            }

            // 툴팁 셀 위가 아니면 툴팁을 숨긴다.
            if (currentTooltipCell == null) {
                hideCommonTooltip(currentTooltipBox);
                return;
            }

            // 현재 셀이 더 이상 잘리지 않으면 툴팁을 숨긴다.
            if (!isCommonTooltipNeeded(currentTooltipCell)) {
                hideCommonTooltip(currentTooltipBox);
                return;
            }

            // 다른 툴팁 셀로 이동하면 해당 셀 내용으로 바로 바꾼다.
            if (window.coActiveTooltipCell !== currentTooltipCell) {
                showCommonTooltip(currentTooltipCell, currentTooltipBox);
            }

        });

        // 스크롤하면 위치가 어긋나므로 툴팁을 숨긴다.
        window.addEventListener("scroll", function () {

            var currentTooltipBox = document.querySelector(".coCommonTooltip");

            if (currentTooltipBox != null) {
                hideCommonTooltip(currentTooltipBox);
            }

        }, true);

        // 클릭하면 툴팁을 숨긴다.
        document.addEventListener("click", function () {

            var currentTooltipBox = document.querySelector(".coCommonTooltip");

            if (currentTooltipBox != null) {
                hideCommonTooltip(currentTooltipBox);
            }

        });

    }

}


/**
 * 현재 셀에 툴팁이 필요한지 검사한다.
 */
function isCommonTooltipNeeded(targetCell) {

    if (targetCell == null) {
        return false;
    }

    var tooltipText = targetCell.getAttribute("data-tooltip");

    if (tooltipText == null || tooltipText.trim() === "") {
        return false;
    }

    // 실제 글자 너비가 셀 너비보다 클 때만 툴팁을 사용한다.
    if (targetCell.scrollWidth > targetCell.clientWidth + 1) {
        return true;
    }

    return false;

}


/**
 * 공통 테이블 툴팁 필요 여부를 다시 검사한다.
 */
function refreshCommonTableTooltip() {

    var tdList = document.querySelectorAll(".coTable thead th[data-tooltip], .coTable tbody td[data-tooltip]");

    for (var i = 0; i < tdList.length; i++) {

        if (isCommonTooltipNeeded(tdList[i])) {
            tdList[i].classList.add("coTooltipCell");
        } else {
            tdList[i].classList.remove("coTooltipCell");
        }

    }

    var tooltipBox = document.querySelector(".coCommonTooltip");

    if (tooltipBox != null && window.coActiveTooltipCell != null) {

        if (!isCommonTooltipNeeded(window.coActiveTooltipCell)) {
            hideCommonTooltip(tooltipBox);
        }

    }

}


/**
 * 공통 툴팁을 보여준다.
 */
function showCommonTooltip(targetCell, tooltipBox) {

    // 마우스를 올린 순간 다시 검사해서, 글자가 다 보이면 툴팁을 띄우지 않는다.
    if (!isCommonTooltipNeeded(targetCell)) {
        hideCommonTooltip(tooltipBox);
        targetCell.classList.remove("coTooltipCell");
        return;
    }

    targetCell.classList.add("coTooltipCell");

    var tooltipText = targetCell.getAttribute("data-tooltip");

    if (tooltipText == null || tooltipText === "") {
        return;
    }

    // 현재 툴팁이 떠 있는 셀을 저장한다.
    window.coActiveTooltipCell = targetCell;

    // 툴팁 내용을 넣는다.
    tooltipBox.textContent = tooltipText;

    // 아래쪽 툴팁 모양으로 먼저 설정한다.
    tooltipBox.classList.add("is_show");
    tooltipBox.classList.add("is_bottom");

    var cellRect = targetCell.getBoundingClientRect();
    var tooltipRect = tooltipBox.getBoundingClientRect();

    var gap = 8;

    // 셀 가운데를 기준으로 툴팁의 가로 위치를 잡는다.
    var left = cellRect.left + (cellRect.width / 2) - (tooltipRect.width / 2);

    // 셀 아래쪽에 툴팁을 표시한다.
    var top = cellRect.bottom + gap;

    // 화면 왼쪽 밖으로 나가지 않게 한다.
    if (left < 8) {
        left = 8;
    }

    // 화면 오른쪽 밖으로 나가지 않게 한다.
    if (left + tooltipRect.width > window.innerWidth - 8) {
        left = window.innerWidth - tooltipRect.width - 8;
    }

    // 아래쪽 공간이 부족할 때만 위쪽으로 표시한다.
    if (top + tooltipRect.height > window.innerHeight - 8) {
        top = cellRect.top - tooltipRect.height - gap;
        tooltipBox.classList.remove("is_bottom");
    }

    // 툴팁 위치를 적용한다.
    tooltipBox.style.left = left + "px";
    tooltipBox.style.top = top + "px";

    // 꼬리 위치를 현재 칸 중앙에 맞춘다.
    var arrowLeft = cellRect.left + (cellRect.width / 2) - left;

    if (arrowLeft < 14) {
        arrowLeft = 14;
    }

    if (arrowLeft > tooltipRect.width - 14) {
        arrowLeft = tooltipRect.width - 14;
    }

    tooltipBox.style.setProperty("--tooltip-arrow-left", arrowLeft + "px");

}


/**
 * 공통 툴팁을 숨긴다.
 */
function hideCommonTooltip(tooltipBox) {

    tooltipBox.classList.remove("is_show");
    tooltipBox.classList.remove("is_bottom");

    window.coActiveTooltipCell = null;

}