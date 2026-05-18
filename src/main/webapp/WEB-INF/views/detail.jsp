<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detail.css">

<div class="detail-page">

    <div class="detail-header">
        <div>
            <h2 class="detail-title">검사 상세</h2>
            <div class="detail-path">품질관리 &gt; 검사관리 &gt; 검사 상세</div>
        </div>

        <div class="detail-btn-area">
            <button type="button" class="btn-line">목록으로</button>
            <button type="button" class="btn-green">수정</button>
        </div>
    </div>

    <div class="detail-card">
        <div class="detail-card-title">기본 정보</div>

        <table class="detail-info-table">
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
                        <span class="status-badge pass">합격</span>
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

</div>