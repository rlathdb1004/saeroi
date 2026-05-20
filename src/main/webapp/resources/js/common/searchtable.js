// 화면 로딩 후 실행
document.addEventListener("DOMContentLoaded", function () {

    // 검색 초기화 버튼 기능을 실행한다.
    initSearchResetButtons();

    // 공통 목록 테이블 컬럼 조절 기능을 실행한다.
    initCommonResizableTables();

});


// 화면 크기가 바뀌었을 때 테이블 컬럼 폭을 다시 맞춘다.
window.addEventListener("resize", function () {

    var tableList = document.querySelectorAll(".coTableWrap .coTable");

    for (var i = 0; i < tableList.length; i++) {
        fitCommonColumnWidthsToTable(tableList[i]);
    }

});


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