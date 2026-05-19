/*
    파일명 : 09_SAEROI_update_work_order_doc_columns_safe_names.sql
    목적   : 3차 프로젝트 EV용 배터리 절연가스켓 제조 MES
             기존 작업지시(work_order) 더미데이터에 작업지시번호/doc_seq 입력
    기준   : safe_names 스키마 + original_volume INSERT + doc_no/doc_seq 운영 기준
    생성규칙:
             work_order.doc_no  = WO-YYYYMMDD-0001
             work_order.doc_seq = order_date 기준 날짜별 순번
    주의   : 08_SAEROI_add_work_order_doc_columns_safe_names.sql 실행 후 실행한다.
*/

-- ============================================================
-- 1. 작업지시 문서번호 UPDATE
--    order_date 기준으로 날짜별 0001부터 다시 시작한다.
-- ============================================================

MERGE INTO work_order t
USING (
    SELECT
        order_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(order_date)
            ORDER BY order_id
        ) AS new_doc_seq,
        'WO-' || TO_CHAR(TRUNC(order_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(order_date)
            ORDER BY order_id
        ), 4, '0') AS new_doc_no
    FROM work_order
) s
ON (t.order_id = s.order_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;

COMMIT;


-- ============================================================
-- 2. NULL 점검
--    결과가 0이어야 정상이다.
-- ============================================================

SELECT
    COUNT(*) AS work_order_doc_null_count
FROM work_order
WHERE doc_no IS NULL
   OR doc_seq IS NULL;


-- ============================================================
-- 3. 작업지시번호 중복 점검
--    결과가 없어야 정상이다.
-- ============================================================

SELECT
    doc_no,
    COUNT(*) AS doc_no_count
FROM work_order
GROUP BY doc_no
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. 날짜별 순번 샘플 확인
-- ============================================================

SELECT
    doc_no,
    doc_seq,
    order_id,
    product_lot,
    order_date,
    order_qty,
    prod_plan_id,
    line_id,
    emp_id
FROM work_order
WHERE order_date IN (
    SELECT order_date
    FROM (
        SELECT DISTINCT order_date
        FROM work_order
        ORDER BY order_date DESC
    )
    WHERE ROWNUM <= 3
)
ORDER BY order_date DESC, doc_seq;


-- ============================================================
-- 5. 날짜별 순번 범위 점검
-- ============================================================

SELECT
    TRUNC(order_date) AS order_date,
    MIN(doc_seq) AS min_doc_seq,
    MAX(doc_seq) AS max_doc_seq,
    COUNT(*) AS row_count
FROM work_order
GROUP BY TRUNC(order_date)
ORDER BY order_date DESC;
