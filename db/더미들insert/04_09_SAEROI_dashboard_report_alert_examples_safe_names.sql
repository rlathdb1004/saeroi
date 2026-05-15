/*
    프로젝트 : 3차 프로젝트(saeroi) - EV용 배터리 절연가스켓 제조 MES
    파일명   : 04_09_SAEROI_dashboard_report_alert_examples.sql
    목적     : 대시보드, 리포트, 알림 조회 예시
    기간     : 2026-03-02 ~ 2026-06-02 / 전년도 비교 2025-03-02 ~ 2025-06-02
    제외     : 주말, 공휴일, 회사 휴무일
    기준     : 문서번호와 상태코드는 DB에 저장하지 않고 조회/화면에서 생성한다.
    비고     : remark 값은 최대 30자 이내로 작성한다.
*/

-- ========================================================================
-- 1. 시연일 KPI 요약
-- ========================================================================
WITH defect_by_insp AS (
    SELECT insp_id, SUM(defect_qty) AS defect_qty
    FROM defect_list
    GROUP BY insp_id
), kpi AS (
    SELECT
        ROUND(SUM(p.prod_qty) / NULLIF(SUM(p.order_qty), 0) * 100, 1) AS production_rate,
        ROUND(SUM(CASE WHEN p.prod_date <= pp.due_date THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 1) AS due_rate,
        ROUND(NVL(SUM(d.defect_qty), 0) / NULLIF(SUM(i.inspection_qty), 0) * 100, 2) AS defect_rate
    FROM production p
    JOIN work_order wo ON wo.order_id = p.order_id
    JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
    JOIN inspection i ON i.prod_id = p.prod_id
    LEFT JOIN defect_by_insp d ON d.insp_id = i.insp_id
    WHERE p.prod_date = DATE '2026-06-02'
), oee AS (
    SELECT ROUND(SUM(runtime_min) / NULLIF(SUM(plan_time_min), 0) * 100, 1) AS availability_rate
    FROM equipment_history
    WHERE operation_date = DATE '2026-06-02'
)
SELECT k.*, o.availability_rate
FROM kpi k CROSS JOIN oee o;

-- ========================================================================
-- 2. 안전재고 부족 알림
-- ========================================================================
SELECT
    i.item_code,
    i.item_name,
    inv.stock_location,
    inv.inventory_stock,
    i.safety_stock
FROM inventory inv
JOIN item i ON i.item_id = inv.item_id
WHERE NVL(inv.inventory_stock, 0) < NVL(i.safety_stock, 0)
  AND inv.stock_location NOT LIKE 'WH-HOLD%'
  AND inv.stock_location NOT LIKE 'WH-DIS%'
ORDER BY i.item_code;

-- ========================================================================
-- 3. 설비 점검/미조치 알림
-- ========================================================================
SELECT e.equip_code, e.equip_name, m.equip_main_date, m.remark
FROM equipment_maintenance m
JOIN equipment e ON e.equip_id = m.equip_id
WHERE m.equip_main_date = DATE '2026-06-02'
UNION ALL
SELECT e.equip_code, e.equip_name, t.trouble_date, t.remark
FROM equipment_trouble t
JOIN equipment e ON e.equip_id = t.equip_id
WHERE t.resolve_date IS NULL
ORDER BY 1;

-- ========================================================================
-- 4. LOT 계보 조회
-- ========================================================================
SELECT
    mi.material_lot,
    mat.item_code AS material_item_code,
    wo.product_lot,
    fg.item_code AS fg_item_code,
    mi.inout_qty,
    mi.inout_date
FROM material_inout mi
JOIN work_order wo ON wo.order_id = mi.order_id
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item fg ON fg.item_id = pp.item_id
JOIN item mat ON mat.item_id = mi.item_id
WHERE mi.inout_type = 'MO-PROD'
  AND wo.order_date = DATE '2026-06-02'
ORDER BY wo.order_id, mat.item_code;
