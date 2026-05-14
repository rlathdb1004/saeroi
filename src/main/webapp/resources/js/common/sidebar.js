function siChangeHeader(mainMenu, subMenu) {
    // 헤더에 대메뉴와 하위 메뉴를 표시하는 함수이다.

    var hePageTitle = document.getElementById("hePageTitle");
    // 헤더의 큰 제목 영역을 찾는다.

    var heCurrentMenuBox = document.getElementById("heCurrentMenuBox");
    // 헤더의 하위 메뉴 박스 영역을 찾는다.

    var heCurrentMenu = document.getElementById("heCurrentMenu");
    // 헤더의 현재 하위 메뉴 글씨 영역을 찾는다.

    if (hePageTitle != null) {
        // 큰 제목 영역이 있는지 확인한다.

        hePageTitle.innerHTML = mainMenu;
        // 큰 제목 영역에 대메뉴명을 넣는다.
    }
    // 큰 제목 확인을 끝낸다.

    if (heCurrentMenuBox != null && heCurrentMenu != null) {
        // 하위 메뉴 박스와 하위 메뉴 글씨 영역이 있는지 확인한다.

        if (subMenu == null || subMenu == "") {
            // 하위 메뉴명이 비어 있는지 확인한다.

            heCurrentMenu.innerHTML = "";
            // 하위 메뉴 글씨를 비운다.

            heCurrentMenuBox.classList.add("heHidden");
            // 하위 메뉴 영역을 숨긴다.

        } else {
            // 하위 메뉴명이 있을 때 실행한다.

            heCurrentMenu.innerHTML = subMenu;
            // 하위 메뉴 영역에 현재 하위 메뉴명을 넣는다.

            heCurrentMenuBox.classList.remove("heHidden");
            // 하위 메뉴 영역을 화면에 보여준다.
        }
        // 하위 메뉴 표시 조건문을 끝낸다.
    }
    // 하위 메뉴 영역 확인을 끝낸다.

    sessionStorage.setItem("saHeaderMainMenu", mainMenu);
    // 페이지가 이동되어도 현재 대메뉴명을 유지하기 위해 브라우저 탭에 저장한다.

    sessionStorage.setItem("saHeaderSubMenu", subMenu);
    // 페이지가 이동되어도 현재 하위 메뉴명을 유지하기 위해 브라우저 탭에 저장한다.
}
// siChangeHeader 함수를 끝낸다.


function siLoadHeader() {
    // 페이지가 다시 열렸을 때 저장된 헤더 값을 불러오는 함수이다.

    var savedMainMenu = sessionStorage.getItem("saHeaderMainMenu");
    // 저장되어 있는 대메뉴명을 가져온다.

    var savedSubMenu = sessionStorage.getItem("saHeaderSubMenu");
    // 저장되어 있는 하위 메뉴명을 가져온다.

    if (savedMainMenu != null) {
        // 저장된 대메뉴명이 있는지 확인한다.

        siChangeHeader(savedMainMenu, savedSubMenu);
        // 저장된 값으로 헤더를 다시 표시한다.
    }
    // 저장된 값 확인을 끝낸다.
}
// siLoadHeader 함수를 끝낸다.


function siRestoreActiveMenu() {
    // 페이지가 다시 열렸을 때 사이드바 active 상태를 복구하는 함수이다.

    var savedMainMenu = sessionStorage.getItem("saHeaderMainMenu");
    // 저장되어 있는 대메뉴명을 가져온다.

    var savedSubMenu = sessionStorage.getItem("saHeaderSubMenu");
    // 저장되어 있는 하위 메뉴명을 가져온다.

    var siSubMenuLinks = document.querySelectorAll(".siSubMenuLink");
    // 모든 하위 메뉴 링크를 찾는다.

    for (var i = 0; i < siSubMenuLinks.length; i++) {
        // 하위 메뉴 개수만큼 반복한다.

        var linkMainMenu = siSubMenuLinks[i].getAttribute("data-main-menu");
        // 하위 메뉴에 저장된 대메뉴명을 가져온다.

        var linkSubMenu = siSubMenuLinks[i].getAttribute("data-sub-menu");
        // 하위 메뉴에 저장된 하위 메뉴명을 가져온다.

        if (linkMainMenu == savedMainMenu && linkSubMenu == savedSubMenu) {
            // 저장된 메뉴명과 현재 하위 메뉴의 정보가 같은지 확인한다.

            siSubMenuLinks[i].classList.add("active");
            // 같은 메뉴라면 active class를 붙인다.

            var siSubMenu = siSubMenuLinks[i].parentElement;
            // 현재 하위 메뉴를 감싸는 영역을 찾는다.

            var siMenuGroup = siSubMenu.parentElement;
            // 하위 메뉴를 감싸는 큰 메뉴 그룹을 찾는다.

            siMenuGroup.classList.add("open");
            // 해당 큰 메뉴를 열린 상태로 만든다.
        }
        // 메뉴 정보 비교를 끝낸다.
    }
    // 하위 메뉴 반복을 끝낸다.
}
// siRestoreActiveMenu 함수를 끝낸다.


var siMenuSingles = document.querySelectorAll(".siMenuSingle");
// 대시보드처럼 하위 메뉴가 없는 메뉴를 전부 찾는다.

for (var a = 0; a < siMenuSingles.length; a++) {
    // 단일 메뉴 개수만큼 반복한다.

    siMenuSingles[a].addEventListener("click", function(event) {
        // 단일 메뉴를 클릭했을 때 실행할 동작을 만든다.

        var href = this.getAttribute("href");
        // 클릭한 메뉴의 href 값을 가져온다.

        if (href == "#") {
            // href가 임시 주소인지 확인한다.

            event.preventDefault();
            // 임시 주소일 때는 화면이 위로 튀는 것을 막는다.
        }
        // href 확인을 끝낸다.

        var mainMenu = this.getAttribute("data-main-menu");
        // 클릭한 메뉴의 대메뉴명을 가져온다.

        var subMenu = this.getAttribute("data-sub-menu");
        // 클릭한 메뉴의 하위 메뉴명을 가져온다.

        siChangeHeader(mainMenu, subMenu);
        // 클릭한 메뉴 정보로 헤더를 변경한다.
    });
    // 단일 메뉴 클릭 이벤트를 끝낸다.
}
// 단일 메뉴 반복을 끝낸다.


var siMenuTitles = document.querySelectorAll(".siMenuTitle");
// class 이름이 siMenuTitle인 큰 메뉴 버튼들을 전부 찾는다.

for (var b = 0; b < siMenuTitles.length; b++) {
    // 큰 메뉴 버튼 개수만큼 반복한다.

    siMenuTitles[b].addEventListener("click", function() {
        // 큰 메뉴 버튼을 클릭했을 때 실행할 동작을 만든다.

        var siMenuGroup = this.parentElement;
        // 클릭한 큰 메뉴 버튼의 부모 영역을 찾는다.

        siMenuGroup.classList.toggle("open");
        // 부모 영역에 open class가 없으면 추가하고, 있으면 제거한다.

        var mainMenu = this.getAttribute("data-main-menu");
        // 클릭한 큰 메뉴의 대메뉴명을 가져온다.

        siChangeHeader(mainMenu, "");
        // 대메뉴만 클릭했기 때문에 헤더에는 대메뉴명만 표시한다.
    });
    // 큰 메뉴 클릭 이벤트를 끝낸다.
}
// 큰 메뉴 반복을 끝낸다.


var siSubMenuLinks = document.querySelectorAll(".siSubMenuLink");
// class 이름이 siSubMenuLink인 하위 메뉴들을 전부 찾는다.

for (var c = 0; c < siSubMenuLinks.length; c++) {
    // 하위 메뉴 개수만큼 반복한다.

    siSubMenuLinks[c].addEventListener("click", function(event) {
        // 하위 메뉴를 클릭했을 때 실행할 동작을 만든다.

        var href = this.getAttribute("href");
        // 클릭한 하위 메뉴의 href 값을 가져온다.

        if (href == "#") {
            // href가 임시 주소인지 확인한다.

            event.preventDefault();
            // 임시 주소일 때는 화면이 위로 튀는 것을 막는다.
        }
        // href 확인을 끝낸다.

        for (var d = 0; d < siSubMenuLinks.length; d++) {
            // 모든 하위 메뉴를 반복한다.

            siSubMenuLinks[d].classList.remove("active");
            // 기존 active class를 제거한다.
        }
        // active 제거 반복을 끝낸다.

        this.classList.add("active");
        // 지금 클릭한 하위 메뉴에 active class를 추가한다.

        var siSubMenu = this.parentElement;
        // 지금 클릭한 하위 메뉴를 감싸는 siSubMenu 영역을 찾는다.

        var siMenuGroup = siSubMenu.parentElement;
        // siSubMenu를 감싸는 큰 메뉴 그룹을 찾는다.

        siMenuGroup.classList.add("open");
        // 하위 메뉴를 클릭해도 상위 메뉴가 열린 상태로 유지되게 한다.

        var mainMenu = this.getAttribute("data-main-menu");
        // 클릭한 하위 메뉴의 대메뉴명을 가져온다.

        var subMenu = this.getAttribute("data-sub-menu");
        // 클릭한 하위 메뉴명을 가져온다.

        siChangeHeader(mainMenu, subMenu);
        // 클릭한 하위 메뉴 정보로 헤더를 변경한다.
    });
    // 하위 메뉴 클릭 이벤트를 끝낸다.
}
// 하위 메뉴 반복을 끝낸다.


siLoadHeader();
// 페이지가 열릴 때 저장된 헤더 정보를 불러온다.

siRestoreActiveMenu();
// 페이지가 열릴 때 저장된 사이드바 active 상태를 복구한다.