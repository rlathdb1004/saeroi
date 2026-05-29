/*
    파일명 : 05_SAEROI_select_v9_check.sql
    목적   : v9 최종 DB 더미데이터 점검 / 대시보드 / 리포트 / LOT / 검사상태 확인
    기준   : 시연일 2026-06-04 09:00
*/

-- 0. 기준일 확인
SELECT
    TO_DATE('2026-06-04 09:00:00', 'YYYY-MM-DD HH24:MI:SS') AS demo_datetime,
    DATE '2026-03-02' AS data_start_2026,
    DATE '2026-06-04' AS data_end_2026,
    DATE '2025-03-02' AS data_start_2025,
    DATE '2025-06-04' AS data_end_2025
FROM dual;

-- 1. 테이블별 데이터 건수
SELECT table_name, row_count
FROM (
    SELECT 1 ord, 'client' table_name, COUNT(*) row_count FROM client
    UNION ALL SELECT 2, 'line', COUNT(*) FROM line
    UNION ALL SELECT 3, 'emp', COUNT(*) FROM emp
    UNION ALL SELECT 4, 'item', COUNT(*) FROM item
    UNION ALL SELECT 5, 'equipment', COUNT(*) FROM equipment
    UNION ALL SELECT 6, 'defect', COUNT(*) FROM defect
    UNION ALL SELECT 7, 'bom', COUNT(*) FROM bom
    UNION ALL SELECT 8, 'bom_detail', COUNT(*) FROM bom_detail
    UNION ALL SELECT 9, 'process', COUNT(*) FROM process
    UNION ALL SELECT 10, 'process_detail', COUNT(*) FROM process_detail
    UNION ALL SELECT 11, 'standard_cost', COUNT(*) FROM standard_cost
    UNION ALL SELECT 12, 'production_plan', COUNT(*) FROM production_plan
    UNION ALL SELECT 13, 'work_order', COUNT(*) FROM work_order
    UNION ALL SELECT 14, 'material_inout', COUNT(*) FROM material_inout
    UNION ALL SELECT 15, 'production', COUNT(*) FROM production
    UNION ALL SELECT 16, 'inspection', COUNT(*) FROM inspection
    UNION ALL SELECT 17, 'defect_list', COUNT(*) FROM defect_list
    UNION ALL SELECT 18, 'defect_action', COUNT(*) FROM defect_action
    UNION ALL SELECT 19, 'inventory', COUNT(*) FROM inventory
    UNION ALL SELECT 20, 'product_inout', COUNT(*) FROM product_inout
    UNION ALL SELECT 21, 'equipment_history', COUNT(*) FROM equipment_history
    UNION ALL SELECT 22, 'actual_cost_daily', COUNT(*) FROM actual_cost_daily
    UNION ALL SELECT 23, 'equipment_maintenance', COUNT(*) FROM equipment_maintenance
    UNION ALL SELECT 24, 'equipment_trouble', COUNT(*) FROM equipment_trouble
    UNION ALL SELECT 25, 'notice', COUNT(*) FROM notice
    UNION ALL SELECT 26, 'board', COUNT(*) FROM board
    UNION ALL SELECT 27, 'board_comment', COUNT(*) FROM board_comment
    UNION ALL SELECT 28, 'attached_file', COUNT(*) FROM attached_file
)
ORDER BY ord;

-- 2. 새 컬럼 반영 확인
SELECT table_name, column_name, data_type, nullable
FROM user_tab_columns
WHERE table_name IN ('CLIENT','PRODUCTION','INSPECTION','DEFECT','DEFECT_LIST','DEFECT_ACTION','WORK_ORDER','PRODUCT_INOUT')
  AND column_name IN ('BUSINESS_NO','INSPECTION_STATUS','INSP_STATUS','ACTION_DEPT','DEFECT_PHOTO','QR_URL','QR_IMAGE_PATH','DOC_NO','DOC_SEQ','INSP_ID')
ORDER BY table_name, column_id;

-- 3. 거래처 담당자/사업자번호 확인
SELECT client_code, client_name, client_type, business_no, client_man, client_dept, client_tel
FROM client
ORDER BY client_id;

-- 4. 생산자는 작업자만 배정되었는지 확인. 결과 0이어야 정상.
SELECT COUNT(*) AS non_worker_production_count
FROM production p
JOIN emp e ON e.emp_id = p.emp_id
WHERE e.dept <> '작업자';

-- 5. 생산계획 대비 실제생산량 초과 확인. 결과가 없어야 정상.
SELECT
    pp.doc_no AS prod_plan_no,
    pp.prod_plan_qty,
    SUM(NVL(p.prod_qty, 0)) AS total_prod_qty
FROM production_plan pp
JOIN work_order wo ON wo.prod_plan_id = pp.prod_plan_id
JOIN production p ON p.order_id = wo.order_id
GROUP BY pp.doc_no, pp.prod_plan_qty
HAVING SUM(NVL(p.prod_qty, 0)) > pp.prod_plan_qty
ORDER BY pp.doc_no;

-- 6. 검사상태별 생산실적 건수
SELECT inspection_status, COUNT(*) AS row_count
FROM production
GROUP BY inspection_status
ORDER BY inspection_status;

-- 7. 검사상태별 검사 이력 건수
SELECT insp_status, result, COUNT(*) AS row_count
FROM inspection
GROUP BY insp_status, result
ORDER BY insp_status, result;

-- 8. 검사 완료 건만 완제품 입고에 반영되었는지 확인. 결과 0이어야 정상.
-- v9.2 기준: product_inout.insp_id가 inspection.insp_id를 직접 참조한다.
SELECT COUNT(*) AS product_inout_without_completed_insp
FROM product_inout pio
JOIN inspection i ON i.insp_id = pio.insp_id
JOIN production p ON p.prod_id = i.prod_id
WHERE i.insp_status <> '검사 완료'
   OR p.inspection_status <> '검사 완료';

-- 8-1. 완제품 입고와 검사/작업지시 연결이 서로 맞는지 확인. 결과 0이어야 정상.
SELECT COUNT(*) AS product_inout_order_insp_mismatch
FROM product_inout pio
JOIN inspection i ON i.insp_id = pio.insp_id
JOIN production p ON p.prod_id = i.prod_id
WHERE pio.order_id <> p.order_id;

-- 8-2. 완제품 입고에 검사 FK가 누락되었는지 확인. 결과 0이어야 정상.
SELECT COUNT(*) AS product_inout_null_insp_id
FROM product_inout
WHERE insp_id IS NULL;

-- 9. 검사 예정인데 완제품 입고가 생성된 건 확인. 결과 0이어야 정상.
SELECT COUNT(*) AS pending_production_stocked_count
FROM production p
JOIN work_order wo ON wo.order_id = p.order_id
JOIN product_inout pio ON pio.order_id = wo.order_id
WHERE p.inspection_status = '검사 예정';

-- 10. 문서번호 NULL 점검. 모두 0이어야 정상.
SELECT 'production_plan' table_name, COUNT(*) null_doc_count FROM production_plan WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'work_order', COUNT(*) FROM work_order WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'material_inout', COUNT(*) FROM material_inout WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'production', COUNT(*) FROM production WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'inspection', COUNT(*) FROM inspection WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'defect_list', COUNT(*) FROM defect_list WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'product_inout', COUNT(*) FROM product_inout WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'equipment_history', COUNT(*) FROM equipment_history WHERE doc_no IS NULL OR doc_seq IS NULL
UNION ALL SELECT 'actual_cost_daily', COUNT(*) FROM actual_cost_daily WHERE doc_no IS NULL OR doc_seq IS NULL;

-- 11. 시연일 2026-06-04 오전 기준 작업/검사 현황
SELECT
    p.doc_no AS prod_doc_no,
    wo.doc_no AS work_order_no,
    wo.product_lot,
    i.item_code,
    i.item_name,
    p.prod_status,
    p.inspection_status,
    p.order_qty,
    p.prod_qty,
    p.loss_qty,
    NVL(insp.insp_status, '검사 미등록') AS insp_status,
    NVL(insp.result, '-') AS insp_result
FROM production p
JOIN work_order wo ON wo.order_id = p.order_id
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item i ON i.item_id = pp.item_id
LEFT JOIN inspection insp ON insp.prod_id = p.prod_id
WHERE p.prod_date = DATE '2026-06-04'
ORDER BY p.prod_id;

-- 12. 안전재고 부족 알림
SELECT i.item_code, i.item_name, inv.stock_location, inv.inventory_stock, i.safety_stock
FROM inventory inv
JOIN item i ON i.item_id = inv.item_id
WHERE NVL(inv.inventory_stock, 0) < NVL(i.safety_stock, 0)
  AND inv.stock_location NOT LIKE 'WH-HOLD%'
  AND inv.stock_location NOT LIKE 'WH-DIS%'
ORDER BY i.item_code;

-- 13. 설비 점검/미조치 알림
SELECT e.equip_code, e.equip_name, m.equip_main_date AS event_date, m.remark
FROM equipment_maintenance m
JOIN equipment e ON e.equip_id = m.equip_id
WHERE m.equip_main_date >= DATE '2026-06-04'
UNION ALL
SELECT e.equip_code, e.equip_name, t.trouble_date, t.remark
FROM equipment_trouble t
JOIN equipment e ON e.equip_id = t.equip_id
WHERE t.resolve_date IS NULL
ORDER BY event_date;

-- 14. LOT 계보 조회 샘플
SELECT
    mi.material_lot,
    mat.item_code AS material_item_code,
    mat.item_name AS material_item_name,
    mi.inout_qty AS used_qty,
    wo.doc_no AS work_order_no,
    wo.product_lot,
    fg.item_code AS product_item_code,
    fg.item_name AS product_item_name,
    p.doc_no AS prod_doc_no,
    p.prod_qty,
    insp.doc_no AS insp_doc_no,
    insp.insp_status,
    insp.good_qty
FROM material_inout mi
JOIN work_order wo ON wo.order_id = mi.order_id
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item fg ON fg.item_id = pp.item_id
JOIN item mat ON mat.item_id = mi.item_id
LEFT JOIN production p ON p.order_id = wo.order_id
LEFT JOIN inspection insp ON insp.prod_id = p.prod_id
WHERE mi.inout_type = 'MO-PROD'
  AND wo.order_date = DATE '2026-06-04'
ORDER BY wo.order_id, mat.item_code;

-- 15. 시연일 KPI 요약
WITH defect_by_insp AS (
    SELECT insp_id, SUM(defect_qty) AS defect_qty
    FROM defect_list
    WHERE use_yn = 'Y'
    GROUP BY insp_id
), kpi AS (
    SELECT
        ROUND(SUM(p.prod_qty) / NULLIF(SUM(p.order_qty), 0) * 100, 1) AS production_rate,
        ROUND(SUM(CASE WHEN p.prod_date <= pp.due_date THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 1) AS due_rate,
        ROUND(NVL(SUM(d.defect_qty), 0) / NULLIF(SUM(i.inspection_qty), 0) * 100, 2) AS defect_rate
    FROM production p
    JOIN work_order wo ON wo.order_id = p.order_id
    JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
    LEFT JOIN inspection i ON i.prod_id = p.prod_id AND i.insp_status = '검사 완료'
    LEFT JOIN defect_by_insp d ON d.insp_id = i.insp_id
    WHERE p.prod_date = DATE '2026-06-04'
), oee AS (
    SELECT ROUND(SUM(runtime_min) / NULLIF(SUM(plan_time_min), 0) * 100, 1) AS availability_rate
    FROM equipment_history
    WHERE operation_date = DATE '2026-06-04'
)
SELECT k.*, o.availability_rate
FROM kpi k CROSS JOIN oee o;


-- 15-1. 완제품 입고별 검사 근거 확인 샘플
SELECT
    pio.doc_no AS product_inout_no,
    pio.inout_qty,
    pio.inout_date,
    pio.order_id,
    wo.doc_no AS work_order_no,
    wo.product_lot,
    pio.insp_id,
    insp.doc_no AS inspection_no,
    insp.insp_status,
    insp.good_qty
FROM product_inout pio
JOIN inspection insp ON insp.insp_id = pio.insp_id
JOIN work_order wo ON wo.order_id = pio.order_id
WHERE pio.inout_date = DATE '2026-06-04'
ORDER BY pio.inout_id;

-- 16. 시퀀스 확인
SELECT sequence_name, last_number
FROM user_sequences
WHERE sequence_name IN ('EQUIPMENT_SEQ','EQUIPMENT_HISTORY_SEQ','SEQ_MATERIAL_INOUT','SEQ_INVENTORY_ID')
ORDER BY sequence_name;

-- ============================================================
-- 17. 대시보드/리포트 그래프 자연스러움 점검: 최근 작업일 생산/불량/OEE 추이
-- 목적 : 최근 작업일 기준 생산량, 불량률, OEE가 단일값처럼 보이지 않는지 확인한다.
-- ============================================================
WITH defect_by_insp AS (
    SELECT insp_id, SUM(defect_qty) AS defect_qty
    FROM defect_list
    WHERE use_yn = 'Y'
    GROUP BY insp_id
), daily_quality AS (
    SELECT
        i.insp_date,
        SUM(NVL(d.defect_qty, 0)) AS defect_qty,
        SUM(i.inspection_qty) AS inspection_qty
    FROM inspection i
    LEFT JOIN defect_by_insp d ON d.insp_id = i.insp_id
    WHERE i.insp_status = '검사 완료'
    GROUP BY i.insp_date
), daily_oee AS (
    SELECT
        operation_date,
        ROUND(SUM(runtime_min) / NULLIF(SUM(plan_time_min), 0) * 100, 1) AS oee_rate
    FROM equipment_history
    GROUP BY operation_date
), daily_prod AS (
    SELECT
        prod_date,
        SUM(prod_qty) AS prod_qty
    FROM production
    GROUP BY prod_date
)
SELECT
    p.prod_date,
    p.prod_qty,
    ROUND(NVL(q.defect_qty, 0) / NULLIF(q.inspection_qty, 0) * 100, 2) AS defect_rate,
    o.oee_rate
FROM daily_prod p
LEFT JOIN daily_quality q ON q.insp_date = p.prod_date
LEFT JOIN daily_oee o ON o.operation_date = p.prod_date
WHERE p.prod_date BETWEEN DATE '2026-05-26' AND DATE '2026-06-04'
ORDER BY p.prod_date;

-- ============================================================
-- 18. 라인별 생산량 분포 점검
-- 목적 : 라인별 그래프가 동일 막대로 보이지 않는지 확인한다.
-- ============================================================
SELECT
    l.line_code,
    l.line_name,
    SUM(p.prod_qty) AS total_prod_qty
FROM production p
JOIN work_order wo ON wo.order_id = p.order_id
JOIN line l ON l.line_id = wo.line_id
GROUP BY l.line_code, l.line_name
ORDER BY l.line_code;

-- ============================================================
-- 19. 불량유형별 분포 점검
-- 목적 : 품질 리포트 원형/막대 그래프가 한 유형으로 쏠리지 않는지 확인한다.
-- ============================================================
SELECT
    d.defect_type,
    d.defect_name,
    SUM(dl.defect_qty) AS defect_qty
FROM defect_list dl
JOIN defect d ON d.defect_id = dl.defect_id
WHERE dl.use_yn = 'Y'
GROUP BY d.defect_type, d.defect_name
ORDER BY defect_qty DESC;


-- ============================================================
-- QR 실시간 생성 기준 점검
-- 목적 : 작업지시 QR은 /production/workorder/qr?orderId=... 에서 실시간 생성하므로
--        더미데이터에는 QR 경로를 저장하지 않는다.
-- 기대 : qr_dummy_value_count = 0
-- ============================================================
SELECT COUNT(*) AS qr_dummy_value_count
FROM work_order
WHERE qr_url IS NOT NULL
   OR qr_image_path IS NOT NULL;
