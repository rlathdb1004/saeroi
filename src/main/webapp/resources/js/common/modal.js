// 화면이 모두 준비된 뒤 공통 모달 기능을 실행한다.
document.addEventListener('DOMContentLoaded', function () {

    // 모달 열기 버튼 목록이다.
    const modal_open_btn_list = document.querySelectorAll('.modal_open_btn');

    // 모달 닫기 버튼 목록이다.
    const modal_close_btn_list = document.querySelectorAll('.modal_close_btn');

    // 오늘 날짜를 yyyy-MM-dd 형식으로 만든다.
    function modal_get_today() {
        const modal_today = new Date();
        const modal_year = modal_today.getFullYear();
        const modal_month = String(modal_today.getMonth() + 1).padStart(2, '0');
        const modal_date = String(modal_today.getDate()).padStart(2, '0');

        return modal_year + '-' + modal_month + '-' + modal_date;
    }

    // 모달 안에 있는 날짜 input을 오늘 날짜로 세팅한다.
    function modal_set_today(modal_wrap) {
        const modal_today_input_list = modal_wrap.querySelectorAll('.modal_today');

        modal_today_input_list.forEach(function (modal_today_input) {
            modal_today_input.value = modal_get_today();
        });
    }

    // 모달을 연다.
    function modal_open(modal_wrap) {
        const modal_form = modal_wrap.querySelector('.modal_form');

        // 모달 안에 form이 있으면 기존 입력값을 초기화한다.
        if (modal_form) {
            modal_form.reset();
        }

        // modal_today 클래스가 있는 날짜 input은 오늘 날짜로 세팅한다.
        modal_set_today(modal_wrap);

        // 모달을 화면에 보여준다.
        modal_wrap.classList.add('modal_is_open');

        // 접근성 상태를 열림으로 변경한다.
        modal_wrap.setAttribute('aria-hidden', 'false');

        // 모달이 열렸을 때 뒤쪽 화면 스크롤을 막는다.
        document.body.classList.add('modal_body_lock');
    }

    // 모달을 닫는다.
    function modal_close(modal_wrap) {
        // 모달을 화면에서 숨긴다.
        modal_wrap.classList.remove('modal_is_open');

        // 접근성 상태를 닫힘으로 변경한다.
        modal_wrap.setAttribute('aria-hidden', 'true');

        // 열려 있는 모달이 없으면 body 스크롤을 다시 허용한다.
        if (!document.querySelector('.modal_wrap.modal_is_open')) {
            document.body.classList.remove('modal_body_lock');
        }
    }

    // 모달 열기 버튼에 클릭 이벤트를 연결한다.
    modal_open_btn_list.forEach(function (modal_open_btn) {
        modal_open_btn.addEventListener('click', function () {
            const modal_target = modal_open_btn.getAttribute('data_modal_target');
            const modal_wrap = document.querySelector(modal_target);

            if (modal_wrap) {
                modal_open(modal_wrap);
            }
        });
    });

    // 모달 닫기 버튼에 클릭 이벤트를 연결한다.
    modal_close_btn_list.forEach(function (modal_close_btn) {
        modal_close_btn.addEventListener('click', function () {
            const modal_wrap = modal_close_btn.closest('.modal_wrap');

            if (modal_wrap) {
                modal_close(modal_wrap);
            }
        });
    });

    // 모달 배경을 클릭하면 모달을 닫는다.
    document.addEventListener('click', function (event) {
        if (event.target.classList.contains('modal_wrap')) {
            modal_close(event.target);
        }
    });

    // ESC 키를 누르면 열려 있는 모달을 닫는다.
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            const modal_opened = document.querySelector('.modal_wrap.modal_is_open');

            if (modal_opened) {
                modal_close(modal_opened);
            }
        }
    });

});