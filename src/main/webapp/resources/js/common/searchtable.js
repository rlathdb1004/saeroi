// 화면 로딩 후 실행
document.addEventListener("DOMContentLoaded", function () {

    // 초기화 버튼 전체 찾기
    const resetBtnList = document.querySelectorAll(".search-reset-btn");

    // 초기화 버튼 클릭 이벤트 연결
    resetBtnList.forEach(function (resetBtn) {

        resetBtn.addEventListener("click", function () {

            // 클릭한 버튼이 들어있는 form 찾기
            const searchForm = resetBtn.closest("form");

            // form이 없으면 종료
            if (!searchForm) {
                return;
            }

            // input 값 비우기
            const inputList = searchForm.querySelectorAll("input");

            inputList.forEach(function (input) {
                input.value = "";
            });

            // select 첫 번째 값으로 변경
            const selectList = searchForm.querySelectorAll("select");

            selectList.forEach(function (select) {
                select.selectedIndex = 0;
            });

        });

    });

});