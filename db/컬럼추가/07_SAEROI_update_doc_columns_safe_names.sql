/*
    파일명 : 07_SAEROI_update_doc_columns_safe_names.sql
    목적   : 3차 프로젝트 SAEROI MES 문서번호 컬럼 더미데이터 UPDATE
    기준   : safe_names 스키마 + original_volume INSERT 기준
    선행   : 06_SAEROI_add_doc_columns_safe_names.sql 실행 후 실행한다.
    제외   : work_order 테이블은 product_lot 컬럼을 사용하므로 문서번호 컬럼 UPDATE 대상에서 제외한다.

    추가 컬럼 의미
    - doc_no  : 화면 표시 및 검색에 사용할 전체 문서번호
    - doc_seq : 해당 날짜/문서구분 기준의 일자별 순번

    문서번호 규칙
    - production_plan  : PP-YYYYMMDD-0001
    - material_inout   : RM-MI-YYYYMMDD-0001 / RM-MO-YYYYMMDD-0001 / SM-MI-YYYYMMDD-0001 / SM-MO-YYYYMMDD-0001
    - product_inout    : FG-MI-YYYYMMDD-0001 / FG-MO-YYYYMMDD-0001
    - production       : PR-YYYYMMDD-0001
    - inspection       : INSP-YYYYMMDD-0001
    - defect_list      : DEF-YYYYMMDD-0001
    - equipment_history: EH-YYYYMMDD-0001
    - actual_cost_daily: AC-YYYYMMDD-0001
*/

-- ============================================================
-- 1. 생산계획 문서번호 UPDATE
-- ============================================================
MERGE INTO production_plan t
USING (
    SELECT
        prod_plan_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(prod_plan_date)
            ORDER BY prod_plan_id
        ) AS new_doc_seq,
        'PP-' || TO_CHAR(TRUNC(prod_plan_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(prod_plan_date)
            ORDER BY prod_plan_id
        ), 4, '0') AS new_doc_no
    FROM production_plan
) s
ON (t.prod_plan_id = s.prod_plan_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 2. 자재 입출고 문서번호 UPDATE
--    item_type 기준으로 RM/SM을 구분하고, inout_type 기준으로 MI/MO를 구분한다.
-- ============================================================
MERGE INTO material_inout t
USING (
    SELECT
        mi.inout_id,
        ROW_NUMBER() OVER (
            PARTITION BY
                TRUNC(mi.inout_date),
                CASE
                    WHEN i.item_type = 'RM' THEN 'RM'
                    WHEN i.item_type = 'SM' THEN 'SM'
                    ELSE 'MT'
                END,
                CASE
                    WHEN mi.inout_type = 'MI' THEN 'MI'
                    WHEN mi.inout_type LIKE 'MO%' THEN 'MO'
                    ELSE mi.inout_type
                END
            ORDER BY mi.inout_id
        ) AS new_doc_seq,
        CASE
            WHEN i.item_type = 'RM' THEN 'RM'
            WHEN i.item_type = 'SM' THEN 'SM'
            ELSE 'MT'
        END || '-' ||
        CASE
            WHEN mi.inout_type = 'MI' THEN 'MI'
            WHEN mi.inout_type LIKE 'MO%' THEN 'MO'
            ELSE mi.inout_type
        END || '-' ||
        TO_CHAR(TRUNC(mi.inout_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY
                TRUNC(mi.inout_date),
                CASE
                    WHEN i.item_type = 'RM' THEN 'RM'
                    WHEN i.item_type = 'SM' THEN 'SM'
                    ELSE 'MT'
                END,
                CASE
                    WHEN mi.inout_type = 'MI' THEN 'MI'
                    WHEN mi.inout_type LIKE 'MO%' THEN 'MO'
                    ELSE mi.inout_type
                END
            ORDER BY mi.inout_id
        ), 4, '0') AS new_doc_no
    FROM material_inout mi
    JOIN item i ON i.item_id = mi.item_id
) s
ON (t.inout_id = s.inout_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 3. 완제품 입출고 문서번호 UPDATE
-- ============================================================
MERGE INTO product_inout t
USING (
    SELECT
        inout_id,
        ROW_NUMBER() OVER (
            PARTITION BY
                TRUNC(inout_date),
                CASE
                    WHEN inout_type = 'MI' THEN 'MI'
                    WHEN inout_type LIKE 'MO%' THEN 'MO'
                    ELSE inout_type
                END
            ORDER BY inout_id
        ) AS new_doc_seq,
        'FG-' ||
        CASE
            WHEN inout_type = 'MI' THEN 'MI'
            WHEN inout_type LIKE 'MO%' THEN 'MO'
            ELSE inout_type
        END || '-' ||
        TO_CHAR(TRUNC(inout_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY
                TRUNC(inout_date),
                CASE
                    WHEN inout_type = 'MI' THEN 'MI'
                    WHEN inout_type LIKE 'MO%' THEN 'MO'
                    ELSE inout_type
                END
            ORDER BY inout_id
        ), 4, '0') AS new_doc_no
    FROM product_inout
) s
ON (t.inout_id = s.inout_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 4. 생산실적 문서번호 UPDATE
-- ============================================================
MERGE INTO production t
USING (
    SELECT
        prod_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(prod_date)
            ORDER BY prod_id
        ) AS new_doc_seq,
        'PR-' || TO_CHAR(TRUNC(prod_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(prod_date)
            ORDER BY prod_id
        ), 4, '0') AS new_doc_no
    FROM production
) s
ON (t.prod_id = s.prod_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 5. 검사 문서번호 UPDATE
-- ============================================================
MERGE INTO inspection t
USING (
    SELECT
        insp_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(insp_date)
            ORDER BY insp_id
        ) AS new_doc_seq,
        'INSP-' || TO_CHAR(TRUNC(insp_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(insp_date)
            ORDER BY insp_id
        ), 4, '0') AS new_doc_no
    FROM inspection
) s
ON (t.insp_id = s.insp_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 6. 불량상세 문서번호 UPDATE
-- ============================================================
MERGE INTO defect_list t
USING (
    SELECT
        defect_list_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(defect_date)
            ORDER BY defect_list_id
        ) AS new_doc_seq,
        'DEF-' || TO_CHAR(TRUNC(defect_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(defect_date)
            ORDER BY defect_list_id
        ), 4, '0') AS new_doc_no
    FROM defect_list
) s
ON (t.defect_list_id = s.defect_list_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 7. 설비가동이력 문서번호 UPDATE
-- ============================================================
MERGE INTO equipment_history t
USING (
    SELECT
        history_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(operation_date)
            ORDER BY history_id
        ) AS new_doc_seq,
        'EH-' || TO_CHAR(TRUNC(operation_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(operation_date)
            ORDER BY history_id
        ), 4, '0') AS new_doc_no
    FROM equipment_history
) s
ON (t.history_id = s.history_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


-- ============================================================
-- 8. 일일실제원가 문서번호 UPDATE
-- ============================================================
MERGE INTO actual_cost_daily t
USING (
    SELECT
        actual_cost_id,
        ROW_NUMBER() OVER (
            PARTITION BY TRUNC(cost_date)
            ORDER BY actual_cost_id
        ) AS new_doc_seq,
        'AC-' || TO_CHAR(TRUNC(cost_date), 'YYYYMMDD') || '-' ||
        LPAD(ROW_NUMBER() OVER (
            PARTITION BY TRUNC(cost_date)
            ORDER BY actual_cost_id
        ), 4, '0') AS new_doc_no
    FROM actual_cost_daily
) s
ON (t.actual_cost_id = s.actual_cost_id)
WHEN MATCHED THEN UPDATE SET
    t.doc_seq = s.new_doc_seq,
    t.doc_no = s.new_doc_no;


COMMIT;


-- ============================================================
-- 9. UPDATE 결과 점검
--    null_count가 0이면 정상이다.
-- ============================================================
SELECT table_name, total_count, null_doc_no_count, null_doc_seq_count
FROM (
    SELECT 1 AS ord, 'production_plan' AS table_name, COUNT(*) AS total_count,
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END) AS null_doc_no_count,
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END) AS null_doc_seq_count
    FROM production_plan
    UNION ALL SELECT 2, 'material_inout', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM material_inout
    UNION ALL SELECT 3, 'product_inout', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM product_inout
    UNION ALL SELECT 4, 'production', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM production
    UNION ALL SELECT 5, 'inspection', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM inspection
    UNION ALL SELECT 6, 'defect_list', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM defect_list
    UNION ALL SELECT 7, 'equipment_history', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM equipment_history
    UNION ALL SELECT 8, 'actual_cost_daily', COUNT(*),
           SUM(CASE WHEN doc_no IS NULL THEN 1 ELSE 0 END),
           SUM(CASE WHEN doc_seq IS NULL THEN 1 ELSE 0 END)
    FROM actual_cost_daily
)
ORDER BY ord;


-- ============================================================
-- 10. 문서번호 중복 점검
--     결과가 없어야 정상이다.
-- ============================================================
SELECT 'production_plan' AS table_name, doc_no, COUNT(*) AS dup_count
FROM production_plan
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'material_inout', doc_no, COUNT(*)
FROM material_inout
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'product_inout', doc_no, COUNT(*)
FROM product_inout
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'production', doc_no, COUNT(*)
FROM production
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'inspection', doc_no, COUNT(*)
FROM inspection
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'defect_list', doc_no, COUNT(*)
FROM defect_list
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'equipment_history', doc_no, COUNT(*)
FROM equipment_history
GROUP BY doc_no
HAVING COUNT(*) > 1
UNION ALL
SELECT 'actual_cost_daily', doc_no, COUNT(*)
FROM actual_cost_daily
GROUP BY doc_no
HAVING COUNT(*) > 1;


-- ============================================================
-- 11. 문서번호 샘플 확인
-- ============================================================
SELECT 'production_plan' AS table_name, prod_plan_id AS pk_id, doc_no, doc_seq FROM production_plan WHERE ROWNUM <= 5
UNION ALL
SELECT 'material_inout', inout_id, doc_no, doc_seq FROM material_inout WHERE ROWNUM <= 5
UNION ALL
SELECT 'product_inout', inout_id, doc_no, doc_seq FROM product_inout WHERE ROWNUM <= 5
UNION ALL
SELECT 'production', prod_id, doc_no, doc_seq FROM production WHERE ROWNUM <= 5
UNION ALL
SELECT 'inspection', insp_id, doc_no, doc_seq FROM inspection WHERE ROWNUM <= 5
UNION ALL
SELECT 'defect_list', defect_list_id, doc_no, doc_seq FROM defect_list WHERE ROWNUM <= 5
UNION ALL
SELECT 'equipment_history', history_id, doc_no, doc_seq FROM equipment_history WHERE ROWNUM <= 5
UNION ALL
SELECT 'actual_cost_daily', actual_cost_id, doc_no, doc_seq FROM actual_cost_daily WHERE ROWNUM <= 5;
