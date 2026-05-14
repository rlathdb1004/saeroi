/*
    프로젝트 : 3차 프로젝트(saeroi) - EV용 배터리 절연가스켓 제조 MES
    파일명   : 04_08_SAEROI_doc_no_view_examples.sql
    목적     : DB 저장 없이 화면 표시용 문서번호 생성 예시
    기간     : 2026-03-02 ~ 2026-06-02 / 전년도 비교 2025-03-02 ~ 2025-06-02
    제외     : 주말, 공휴일, 회사 휴무일
    기준     : 문서번호와 상태코드는 DB에 저장하지 않고 조회/화면에서 생성한다.
    비고     : remark 값은 최대 30자 이내로 작성한다.
*/

-- ========================================================================
-- 1. 생산계획번호 표시 예시
-- ========================================================================
SELECT
    'PP-' || TO_CHAR(pp."prod_plan_date", 'YYYYMMDD') || '-' || LPAD(pp."prod_plan_id", 4, '0') AS prod_plan_no,
    pp.*
FROM "production_plan" pp
WHERE pp."prod_plan_date" = DATE '2026-06-02'
ORDER BY pp."prod_plan_id";

-- ========================================================================
-- 2. 작업지시번호 표시 예시
-- ========================================================================
SELECT
    'WO-' || TO_CHAR(wo."order_date", 'YYYYMMDD') || '-' || LPAD(wo."order_id", 4, '0') AS work_order_no,
    wo."product_lot",
    wo."order_qty"
FROM "work_order" wo
WHERE wo."order_date" = DATE '2026-06-02'
ORDER BY wo."order_id";

-- ========================================================================
-- 3. 입출고문서번호 표시 예시
-- ========================================================================
SELECT
    CASE
        WHEN i."item_type" = 'FG' THEN 'FG-'
        WHEN i."item_type" = 'SM' THEN 'SM-'
        ELSE 'RM-'
    END || mi."inout_type" || '-' || TO_CHAR(mi."inout_date", 'YYYYMMDD') || '-' || LPAD(mi."inout_id", 4, '0') AS inout_no,
    mi."material_lot",
    i."item_code",
    mi."inout_qty"
FROM "material_inout" mi
JOIN "item" i ON i."item_id" = mi."item_id"
WHERE mi."inout_date" = DATE '2026-06-02'
ORDER BY mi."inout_id";

