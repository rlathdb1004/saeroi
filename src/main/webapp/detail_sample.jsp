<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 디테일 페이지 공통 CSS를 연결한다. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/detail.css">

<div class="detail_page">

    <div class="detail_header">
        <div>
            <%-- 팀원별 메뉴에 맞게 상세 페이지 제목을 변경한다. --%>
            <h2 class="detail_title">검사 상세</h2>

            <%-- 현재 페이지 위치를 표시한다. --%>
            <div class="detail_path">품질관리 &gt; 검사관리 &gt; 검사 상세</div>
        </div>

        <div class="detail_btn_area">

            <%-- 목록으로 버튼은 새 창이 아니라 현재 페이지에서 목록 화면으로 이동한다. --%>
            <button type="button" class="detail_btn_line"
                    onclick="location.href='${pageContext.request.contextPath}/quality/inspection'">

                <%-- 목록 아이콘 SVG이다. --%>
                <svg width="16" height="16" viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round"
                     style="vertical-align: -3px; margin-right: 6px;""
                     aria-hidden="true">
                    <path d="M8 6h13"></path>
                    <path d="M8 12h13"></path>
                    <path d="M8 18h13"></path>
                    <path d="M3 6h.01"></path>
                    <path d="M3 12h.01"></path>
                    <path d="M3 18h.01"></path>
                </svg>

                목록
            </button>

            <%-- 수정 버튼은 새 창이 아니라 현재 페이지에서 수정 화면으로 이동한다. --%>
            <button type="button" class="detail_btn_green"
                    onclick="location.href='${pageContext.request.contextPath}/quality/inspection/update'">

                <%-- 수정 아이콘 SVG이다. --%>
                <svg width="16" height="16" viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round"
                     style="vertical-align: -3px; margin-right: 6px;""
                     aria-hidden="true">
                    <path d="M12 20h9"></path>
                    <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"></path>
                </svg>

                수정
            </button>
        </div>
    </div>

    <div class="detail_card">
        <%-- 상세 정보 카드 제목이다. --%>
        <div class="detail_card_title">기본 정보</div>

        <table class="detail_info_table">
            <colgroup>
                <col style="width: 12%;">
                <col style="width: 21%;">
                <col style="width: 12%;">
                <col style="width: 21%;">
                <col style="width: 12%;">
                <col style="width: 22%;">
            </colgroup>

            <tbody>
                <tr>
                    <th>검사번호</th>
                    <td>INSP-20260518-001</td>

                    <th>검사일시</th>
                    <td>2026-05-18</td>

                    <th>품목명</th>
                    <td>EV 절연 가스켓</td>
                </tr>

                <tr>
                    <th>LOT번호</th>
                    <td>LOT-20260518-001</td>

                    <th>검사자</th>
                    <td>김새로이</td>

                    <th>검사결과</th>
                    <td>
                        <span class="detail_status_badge detail_status_pass">합격</span>
                    </td>
                </tr>

                <tr>
                    <th>검사구분</th>
                    <td>외관검사</td>

                    <th>검사수량</th>
                    <td>100 EA</td>

                    <th>양품수량</th>
                    <td>98 EA</td>
                </tr>

                <tr>
                    <th>비고</th>
                    <td colspan="5">검사 상세 화면 디자인 확인용 임시 데이터입니다.</td>
                </tr>
            </tbody>
        </table>
    </div>

    <%-- 팀원별로 추가 상세 정보가 필요할 때 사용하는 영역이다. --%>
    <div class="detail_content_area">
        <div class="detail_empty_box">
            팀원별 상세 내용을 추가하는 영역입니다.
        </div>
    </div>

</div>