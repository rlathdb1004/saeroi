/*
    파일명 : 05_SAEROI_select_v8_final_safe_names.sql
    목적   : 3차 프로젝트 EV용 배터리 절연가스켓 제조 MES
             최종 더미데이터 입력 후 점검 / 대시보드 / 리포트 / 알림 / LOT 추적 조회 예시
    기준   : INSERT v8 최종본 기준
             - 본년도 기간 : 2026-03-02 ~ 2026-06-02
             - 전년도 기간 : 2025-03-02 ~ 2025-06-02
             - 시연일     : 2026-06-02
             - 주말/공휴일 제외 데이터
    주의   : 문서번호(PP, WO, PR, INSP, DEF, EH, AC)는 DB에 저장하지 않고
             조회 시 일자 + 일자별 순번으로 표시용 생성한다.
             재고상태/납기상태도 DB 저장값이 아니라 조회 시 계산한다.
*/
/*
    보정사항 : Oracle 예약어/키워드 충돌 방지를 위해 테이블명을 변경했다.
             comment -> board_comment
             file    -> attached_file
             테이블명/컬럼명은 큰따옴표 없는 일반 Oracle 식별자 기준이다.
*/



-- ============================================================
-- 0. 기준일 확인용
-- ============================================================
SELECT
    DATE '2026-06-02' AS demo_date,
    DATE '2026-03-02' AS data_start_2026,
    DATE '2026-06-02' AS data_end_2026,
    DATE '2025-03-02' AS data_start_2025,
    DATE '2025-06-02' AS data_end_2025
FROM dual;


-- ============================================================
-- 1. 테이블별 데이터 건수 점검
-- 목적 : INSERT 누락 여부를 빠르게 확인한다.
-- ============================================================
SELECT table_name, row_count
FROM (
    SELECT 1 AS ord, 'client' AS table_name, COUNT(*) AS row_count FROM client
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
    UNION ALL SELECT 18, 'inventory', COUNT(*) FROM inventory
    UNION ALL SELECT 19, 'product_inout', COUNT(*) FROM product_inout
    UNION ALL SELECT 20, 'equipment_history', COUNT(*) FROM equipment_history
    UNION ALL SELECT 21, 'actual_cost_daily', COUNT(*) FROM actual_cost_daily
    UNION ALL SELECT 22, 'equipment_maintenance', COUNT(*) FROM equipment_maintenance
    UNION ALL SELECT 23, 'equipment_trouble', COUNT(*) FROM equipment_trouble
    UNION ALL SELECT 24, 'notice', COUNT(*) FROM notice
    UNION ALL SELECT 25, 'board', COUNT(*) FROM board
    UNION ALL SELECT 26, 'board_comment', COUNT(*) FROM board_comment
    UNION ALL SELECT 27, 'attached_file', COUNT(*) FROM attached_file
)
ORDER BY ord;


-- ============================================================
-- 2. 품목/거래처 조회
-- 목적 : 품목코드, 품목구분, 공급처, 납품처, 안전재고를 확인한다.
-- 기준 : 납품처는 item.client_id 기준으로 조회한다.
-- ============================================================
SELECT
    i.item_id,
    i.item_code,
    i.item_name,
    i.item_type,
    sup.client_name AS supplier_name,
    cus.client_name AS delivery_client_name,
    i.safety_stock,
    i.item_unit,
    i.use_yn
FROM item i
LEFT JOIN client sup ON sup.client_id = i.supplier_id
LEFT JOIN client cus ON cus.client_id = i.client_id
ORDER BY i.item_type, i.item_code;


-- ============================================================
-- 3. 표시용 문서번호 생성 예시
-- 목적 : 문서번호를 DB에 저장하지 않고 조회 시 생성한다.
-- ============================================================

-- 생산계획번호 표시용: PP-일자-일자별순번
SELECT
    'PP-' || TO_CHAR(pp.prod_plan_date, 'YYYYMMDD') || '-' ||
    LPAD(ROW_NUMBER() OVER (
        PARTITION BY pp.prod_plan_date
        ORDER BY pp.prod_plan_id
    ), 4, '0') AS prod_plan_no,
    pp.prod_plan_id,
    pp.prod_plan_date,
    i.item_code,
    i.item_name,
    pp.prod_plan_qty,
    pp.due_date
FROM production_plan pp
JOIN item i ON i.item_id = pp.item_id
WHERE pp.prod_plan_date = DATE '2026-06-02'
ORDER BY pp.prod_plan_id;


-- 작업지시번호 표시용: WO-일자-일자별순번
SELECT
    'WO-' || TO_CHAR(wo.order_date, 'YYYYMMDD') || '-' ||
    LPAD(ROW_NUMBER() OVER (
        PARTITION BY wo.order_date
        ORDER BY wo.order_id
    ), 4, '0') AS work_order_no,
    wo.order_id,
    wo.product_lot,
    i.item_code,
    i.item_name,
    l.line_code,
    l.line_name,
    wo.order_qty,
    wo.order_date,
    pp.due_date
FROM work_order wo
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item i ON i.item_id = pp.item_id
JOIN line l ON l.line_id = wo.line_id
WHERE wo.order_date = DATE '2026-06-02'
ORDER BY wo.order_id;


-- ============================================================
-- 4. LOT 계보 조회
-- 목적 : 원자재 LOT → 작업지시 → 완제품 LOT → 생산/검사 흐름을 확인한다.
-- 기준 : material_inout.material_lot, work_order.product_lot은 추적 대상이므로 DB 저장값이다.
-- ============================================================
SELECT
    mi.material_lot AS material_lot,
    mat.item_code AS material_item_code,
    mat.item_name AS material_item_name,
    mi.inout_qty AS used_qty,
    mi.inout_date AS material_out_date,
    wo.order_id,
    wo.product_lot AS product_lot,
    fg.item_code AS product_item_code,
    fg.item_name AS product_item_name,
    p.prod_date,
    p.prod_qty,
    i.insp_date,
    i.inspection_qty,
    i.good_qty
FROM material_inout mi
JOIN work_order wo ON wo.order_id = mi.order_id
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item fg ON fg.item_id = pp.item_id
JOIN item mat ON mat.item_id = mi.item_id
LEFT JOIN production p ON p.order_id = wo.order_id
LEFT JOIN inspection i ON i.prod_id = p.prod_id
WHERE mi.inout_type = 'MO-PROD'
  AND wo.order_date = DATE '2026-06-02'
ORDER BY wo.order_id, mat.item_code, mi.material_lot;


-- ============================================================
-- 5. 원자재 LOT 입고/출고 매칭 점검
-- 목적 : 출고된 LOT가 실제 입고 이력에 존재하는지 확인한다.
-- 결과 : 미매칭 건수가 0이어야 정상이다.
-- ============================================================
SELECT
    COUNT(*) AS unmatched_material_lot_count
FROM material_inout mo
WHERE mo.inout_type = 'MO-PROD'
  AND NOT EXISTS (
      SELECT 1
      FROM material_inout mi
      WHERE mi.inout_type = 'MI'
        AND mi.material_lot = mo.material_lot
        AND mi.item_id = mo.item_id
  );


-- ============================================================
-- 6. 대시보드 KPI: 시연일 생산달성률
-- 목적 : 계획수량 대비 생산실적을 계산한다.
-- 주의 : 생산계획이 작업지시 조인으로 중복 집계되지 않도록 CTE로 분리한다.
-- ============================================================
WITH
params AS (
    SELECT DATE '2026-06-02' AS base_date FROM dual
),
plan_qty AS (
    SELECT
        SUM(pp.prod_plan_qty) AS plan_qty
    FROM production_plan pp
    JOIN params p ON pp.prod_plan_date = p.base_date
),
prod_qty AS (
    SELECT
        SUM(pr.prod_qty) AS prod_qty
    FROM production pr
    JOIN params p ON pr.prod_date = p.base_date
)
SELECT
    p.base_date,
    NVL(pl.plan_qty, 0) AS plan_qty,
    NVL(pd.prod_qty, 0) AS prod_qty,
    ROUND(NVL(pd.prod_qty, 0) / NULLIF(NVL(pl.plan_qty, 0), 0) * 100, 1) AS production_rate
FROM params p
CROSS JOIN plan_qty pl
CROSS JOIN prod_qty pd;


-- ============================================================
-- 7. 대시보드 KPI: 시연일 납기준수율
-- 목적 : production_plan.due_date와 생산완료일을 비교한다.
-- 기준 : 작업지시별 최종 생산일이 납기일 이하이면 납기준수로 본다.
-- ============================================================
WITH
params AS (
    SELECT DATE '2026-06-02' AS base_date FROM dual
),
prod_done AS (
    SELECT
        order_id,
        MAX(prod_date) AS finish_date
    FROM production
    GROUP BY order_id
)
SELECT
    p.base_date,
    COUNT(*) AS target_order_count,
    SUM(CASE WHEN pd.finish_date <= pp.due_date THEN 1 ELSE 0 END) AS on_time_count,
    SUM(CASE WHEN pd.finish_date > pp.due_date THEN 1 ELSE 0 END) AS delay_count,
    ROUND(
        SUM(CASE WHEN pd.finish_date <= pp.due_date THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        1
    ) AS due_rate
FROM params p
JOIN work_order wo ON wo.order_date = p.base_date
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
LEFT JOIN prod_done pd ON pd.order_id = wo.order_id
GROUP BY p.base_date;


-- ============================================================
-- 8. 대시보드 KPI: 시연일 OEE
-- 목적 : 가동률, 성능률, 품질률을 조합해 OEE를 계산한다.
-- 기준 : equipment_history는 설비별 일 단위 집계 데이터다.
-- ============================================================
WITH
params AS (
    SELECT DATE '2026-06-02' AS base_date FROM dual
),
availability AS (
    SELECT
        ROUND(SUM(runtime_min) / NULLIF(SUM(plan_time_min), 0) * 100, 1) AS rate
    FROM equipment_history eh
    JOIN params p ON eh.operation_date = p.base_date
),
performance AS (
    SELECT
        ROUND(SUM(prod_qty) / NULLIF(SUM(order_qty), 0) * 100, 1) AS rate
    FROM production pr
    JOIN params p ON pr.prod_date = p.base_date
),
quality AS (
    SELECT
        ROUND(SUM(good_qty) / NULLIF(SUM(inspection_qty), 0) * 100, 1) AS rate
    FROM inspection ins
    JOIN params p ON ins.insp_date = p.base_date
)
SELECT
    a.rate AS availability_rate,
    pf.rate AS performance_rate,
    q.rate AS quality_rate,
    ROUND(a.rate * pf.rate * q.rate / 10000, 1) AS oee_rate
FROM availability a
CROSS JOIN performance pf
CROSS JOIN quality q;


-- ============================================================
-- 9. 대시보드 KPI: 시연일 불량률
-- 목적 : 검사수량 대비 불량수량을 계산한다.
-- 기준 : defect_list는 불량유형별 상세이므로 검사별 불량합계를 먼저 만든다.
-- ============================================================
WITH
params AS (
    SELECT DATE '2026-06-02' AS base_date FROM dual
),
defect_by_insp AS (
    SELECT
        insp_id,
        SUM(defect_qty) AS defect_qty
    FROM defect_list
    GROUP BY insp_id
)
SELECT
    p.base_date,
    SUM(i.inspection_qty) AS inspection_qty,
    NVL(SUM(dbi.defect_qty), 0) AS defect_qty,
    ROUND(NVL(SUM(dbi.defect_qty), 0) / NULLIF(SUM(i.inspection_qty), 0) * 100, 2) AS defect_rate
FROM params p
JOIN inspection i ON i.insp_date = p.base_date
LEFT JOIN defect_by_insp dbi ON dbi.insp_id = i.insp_id
GROUP BY p.base_date;


-- ============================================================
-- 10. 대시보드 KPI: 시연일 원가편차율 / 일일생산원가
-- 목적 : 표준단가 대비 일일 실제단가 차이를 확인한다.
-- ============================================================
SELECT
    ac.cost_date,
    i.item_code,
    i.item_name,
    sc.unit_cost AS standard_unit_cost,
    ac.unit_cost AS actual_unit_cost,
    ROUND((ac.unit_cost - sc.unit_cost) / NULLIF(sc.unit_cost, 0) * 100, 2) AS cost_variance_rate,
    ac.cost_unit
FROM actual_cost_daily ac
JOIN standard_cost sc ON sc.item_id = ac.item_id AND sc.use_yn = 'Y'
JOIN item i ON i.item_id = ac.item_id
WHERE ac.cost_date = DATE '2026-06-02'
ORDER BY i.item_code;


-- ============================================================
-- 11. 대시보드 추이: 최근 7개 생산일 생산달성률
-- 목적 : 최근 7개 영업일 기준 계획 대비 실적 추이를 표시한다.
-- ============================================================
WITH
recent_days AS (
    SELECT base_date
    FROM (
        SELECT DISTINCT pp.prod_plan_date AS base_date
        FROM production_plan pp
        WHERE pp.prod_plan_date <= DATE '2026-06-02'
        ORDER BY pp.prod_plan_date DESC
    )
    WHERE ROWNUM <= 7
),
plan_by_day AS (
    SELECT
        pp.prod_plan_date AS base_date,
        SUM(pp.prod_plan_qty) AS plan_qty
    FROM production_plan pp
    WHERE pp.prod_plan_date IN (SELECT base_date FROM recent_days)
    GROUP BY pp.prod_plan_date
),
prod_by_day AS (
    SELECT
        pr.prod_date AS base_date,
        SUM(pr.prod_qty) AS prod_qty
    FROM production pr
    WHERE pr.prod_date IN (SELECT base_date FROM recent_days)
    GROUP BY pr.prod_date
)
SELECT
    rd.base_date,
    NVL(pl.plan_qty, 0) AS plan_qty,
    NVL(pd.prod_qty, 0) AS prod_qty,
    ROUND(NVL(pd.prod_qty, 0) / NULLIF(NVL(pl.plan_qty, 0), 0) * 100, 1) AS production_rate
FROM recent_days rd
LEFT JOIN plan_by_day pl ON pl.base_date = rd.base_date
LEFT JOIN prod_by_day pd ON pd.base_date = rd.base_date
ORDER BY rd.base_date;


-- ============================================================
-- 12. 대시보드 추이: 최근 7개 생산일 OEE
-- 목적 : 최근 7개 영업일 기준 OEE 변동을 확인한다.
-- ============================================================
WITH
recent_days AS (
    SELECT base_date
    FROM (
        SELECT DISTINCT operation_date AS base_date
        FROM equipment_history
        WHERE operation_date <= DATE '2026-06-02'
        ORDER BY operation_date DESC
    )
    WHERE ROWNUM <= 7
),
availability AS (
    SELECT
        eh.operation_date AS base_date,
        SUM(eh.runtime_min) / NULLIF(SUM(eh.plan_time_min), 0) * 100 AS availability_rate
    FROM equipment_history eh
    WHERE eh.operation_date IN (SELECT base_date FROM recent_days)
    GROUP BY eh.operation_date
),
performance AS (
    SELECT
        pr.prod_date AS base_date,
        SUM(pr.prod_qty) / NULLIF(SUM(pr.order_qty), 0) * 100 AS performance_rate
    FROM production pr
    WHERE pr.prod_date IN (SELECT base_date FROM recent_days)
    GROUP BY pr.prod_date
),
quality AS (
    SELECT
        ins.insp_date AS base_date,
        SUM(ins.good_qty) / NULLIF(SUM(ins.inspection_qty), 0) * 100 AS quality_rate
    FROM inspection ins
    WHERE ins.insp_date IN (SELECT base_date FROM recent_days)
    GROUP BY ins.insp_date
)
SELECT
    rd.base_date,
    ROUND(a.availability_rate, 1) AS availability_rate,
    ROUND(p.performance_rate, 1) AS performance_rate,
    ROUND(q.quality_rate, 1) AS quality_rate,
    ROUND(a.availability_rate * p.performance_rate * q.quality_rate / 10000, 1) AS oee_rate
FROM recent_days rd
LEFT JOIN availability a ON a.base_date = rd.base_date
LEFT JOIN performance p ON p.base_date = rd.base_date
LEFT JOIN quality q ON q.base_date = rd.base_date
ORDER BY rd.base_date;


-- ============================================================
-- 13. 생산 리포트: 일자별 생산실적
-- 목적 : 계획수량 대비 생산수량 막대그래프에 사용한다.
-- ============================================================
WITH
plan_by_day AS (
    SELECT
        pp.prod_plan_date AS base_date,
        SUM(pp.prod_plan_qty) AS plan_qty
    FROM production_plan pp
    WHERE pp.prod_plan_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
    GROUP BY pp.prod_plan_date
),
prod_by_day AS (
    SELECT
        pr.prod_date AS base_date,
        SUM(pr.prod_qty) AS prod_qty
    FROM production pr
    WHERE pr.prod_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
    GROUP BY pr.prod_date
)
SELECT
    pbd.base_date,
    pbd.plan_qty,
    NVL(prd.prod_qty, 0) AS prod_qty,
    ROUND(NVL(prd.prod_qty, 0) / NULLIF(pbd.plan_qty, 0) * 100, 1) AS production_rate
FROM plan_by_day pbd
LEFT JOIN prod_by_day prd ON prd.base_date = pbd.base_date
ORDER BY pbd.base_date;


-- ============================================================
-- 14. 생산 리포트: 품목별 생산 비중
-- 목적 : 품목별 생산 비중 원형그래프에 사용한다.
-- ============================================================
SELECT
    i.item_code,
    i.item_name,
    SUM(p.prod_qty) AS prod_qty
FROM production p
JOIN work_order wo ON wo.order_id = p.order_id
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item i ON i.item_id = pp.item_id
WHERE p.prod_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
GROUP BY i.item_code, i.item_name
ORDER BY prod_qty DESC;


-- ============================================================
-- 15. 생산 리포트: 라인별 생산량
-- 목적 : 라인별 생산량 가로 막대그래프에 사용한다.
-- ============================================================
SELECT
    l.line_code,
    l.line_name,
    SUM(p.prod_qty) AS prod_qty
FROM production p
JOIN work_order wo ON wo.order_id = p.order_id
JOIN line l ON l.line_id = wo.line_id
WHERE p.prod_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
GROUP BY l.line_code, l.line_name
ORDER BY l.line_code;


-- ============================================================
-- 16. 품질 리포트: 일자별 검사/불량 실적
-- 목적 : 검사수량 대비 불량수량 막대그래프에 사용한다.
-- ============================================================
WITH
defect_by_insp AS (
    SELECT
        insp_id,
        SUM(defect_qty) AS defect_qty
    FROM defect_list
    GROUP BY insp_id
)
SELECT
    i.insp_date AS base_date,
    SUM(i.inspection_qty) AS inspection_qty,
    NVL(SUM(dbi.defect_qty), 0) AS defect_qty,
    ROUND(NVL(SUM(dbi.defect_qty), 0) / NULLIF(SUM(i.inspection_qty), 0) * 100, 2) AS defect_rate
FROM inspection i
LEFT JOIN defect_by_insp dbi ON dbi.insp_id = i.insp_id
WHERE i.insp_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
GROUP BY i.insp_date
ORDER BY i.insp_date;


-- ============================================================
-- 17. 품질 리포트: 불량유형 비중
-- 목적 : 불량유형 비중 원형그래프에 사용한다.
-- ============================================================
SELECT
    d.defect_code,
    d.defect_name,
    SUM(dl.defect_qty) AS defect_qty
FROM defect_list dl
JOIN defect d ON d.defect_id = dl.defect_id
WHERE dl.defect_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
GROUP BY d.defect_code, d.defect_name
ORDER BY defect_qty DESC;


-- ============================================================
-- 18. 품질 리포트: 라인별 불량수량
-- 목적 : 현재 DB에는 inspection.proc_id가 없으므로 공정별 직접 집계 대신 라인별로 집계한다.
--        공정별 불량을 정확히 구현하려면 검사와 공정 연결 컬럼이 필요하다.
-- ============================================================
SELECT
    l.line_code,
    l.line_name,
    SUM(dl.defect_qty) AS defect_qty
FROM defect_list dl
JOIN inspection ins ON ins.insp_id = dl.insp_id
JOIN production p ON p.prod_id = ins.prod_id
JOIN work_order wo ON wo.order_id = p.order_id
JOIN line l ON l.line_id = wo.line_id
WHERE dl.defect_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
GROUP BY l.line_code, l.line_name
ORDER BY l.line_code;


-- ============================================================
-- 19. 전년도 비교: 월별 생산량 / 불량률
-- 목적 : 2025년과 2026년 같은 기간 비교 리포트에 사용한다.
-- ============================================================
WITH
prod_month AS (
    SELECT
        TO_CHAR(p.prod_date, 'YYYY') AS data_year,
        TO_CHAR(p.prod_date, 'MM') AS data_month,
        SUM(p.prod_qty) AS prod_qty
    FROM production p
    WHERE p.prod_date BETWEEN DATE '2025-03-02' AND DATE '2025-06-02'
       OR p.prod_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
    GROUP BY TO_CHAR(p.prod_date, 'YYYY'), TO_CHAR(p.prod_date, 'MM')
),
defect_month AS (
    SELECT
        TO_CHAR(i.insp_date, 'YYYY') AS data_year,
        TO_CHAR(i.insp_date, 'MM') AS data_month,
        SUM(i.inspection_qty) AS inspection_qty,
        SUM(i.inspection_qty - i.good_qty) AS defect_qty
    FROM inspection i
    WHERE i.insp_date BETWEEN DATE '2025-03-02' AND DATE '2025-06-02'
       OR i.insp_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
    GROUP BY TO_CHAR(i.insp_date, 'YYYY'), TO_CHAR(i.insp_date, 'MM')
)
SELECT
    pm.data_year,
    pm.data_month,
    pm.prod_qty,
    dm.inspection_qty,
    dm.defect_qty,
    ROUND(dm.defect_qty / NULLIF(dm.inspection_qty, 0) * 100, 2) AS defect_rate
FROM prod_month pm
JOIN defect_month dm ON dm.data_year = pm.data_year AND dm.data_month = pm.data_month
ORDER BY pm.data_year, pm.data_month;


-- ============================================================
-- 20. 알림: 안전재고 부족
-- 목적 : inventory_stock과 item.safety_stock을 비교해 부족 품목을 조회한다.
-- 주의 : INV_SHORT 같은 상태 코드는 DB 저장값이 아니라 화면 표시용 계산값이다.
-- ============================================================
SELECT
    i.item_code,
    i.item_name,
    inv.stock_location,
    inv.inventory_stock,
    i.safety_stock,
    i.safety_stock - NVL(inv.inventory_stock, 0) AS shortage_qty,
    CASE
        WHEN NVL(inv.inventory_stock, 0) < NVL(i.safety_stock, 0) THEN '부족'
        ELSE '정상'
    END AS inventory_status
FROM inventory inv
JOIN item i ON i.item_id = inv.item_id
WHERE NVL(inv.inventory_stock, 0) < NVL(i.safety_stock, 0)
ORDER BY shortage_qty DESC, i.item_code;


-- ============================================================
-- 21. 알림: 납기지연 작업지시
-- 목적 : 완료일이 납기일보다 늦은 작업지시를 조회한다.
-- ============================================================
WITH
prod_done AS (
    SELECT
        order_id,
        MAX(prod_date) AS finish_date
    FROM production
    GROUP BY order_id
)
SELECT
    wo.order_id,
    wo.product_lot,
    i.item_code,
    i.item_name,
    wo.order_qty,
    pp.due_date,
    pd.finish_date,
    pd.finish_date - pp.due_date AS delay_days
FROM work_order wo
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item i ON i.item_id = pp.item_id
JOIN prod_done pd ON pd.order_id = wo.order_id
WHERE pd.finish_date > pp.due_date
  AND pd.finish_date BETWEEN DATE '2026-03-02' AND DATE '2026-06-02'
ORDER BY pd.finish_date DESC, delay_days DESC;


-- ============================================================
-- 22. 알림: 금일/예정 설비점검
-- 목적 : 오늘 및 7일 이내 점검 예정 설비를 조회한다.
-- ============================================================
SELECT
    em.equip_main_date,
    e.equip_code,
    e.equip_name,
    l.line_name,
    em.equip_main_type,
    em.equip_main_time,
    em.remark
FROM equipment_maintenance em
JOIN equipment e ON e.equip_id = em.equip_id
LEFT JOIN line l ON l.line_id = e.line_id
WHERE em.equip_main_date BETWEEN DATE '2026-06-02' AND DATE '2026-06-09'
ORDER BY em.equip_main_date, e.equip_code;


-- ============================================================
-- 23. 알림: 미조치 설비고장
-- 목적 : resolve_date가 없는 고장 이력을 조회한다.
-- ============================================================
SELECT
    et.trouble_date,
    e.equip_code,
    e.equip_name,
    l.line_name,
    et.trouble_content,
    et.trouble_resolve,
    et.resolve_date,
    et.remark
FROM equipment_trouble et
JOIN equipment e ON e.equip_id = et.equip_id
LEFT JOIN line l ON l.line_id = e.line_id
WHERE et.resolve_date IS NULL
ORDER BY et.trouble_date DESC, e.equip_code;


-- ============================================================
-- 24. 최근 작업지시 목록
-- 목적 : 대시보드 최근 작업지시 카드 또는 목록에 사용한다.
-- ============================================================
SELECT
    'WO-' || TO_CHAR(wo.order_date, 'YYYYMMDD') || '-' ||
    LPAD(ROW_NUMBER() OVER (
        PARTITION BY wo.order_date
        ORDER BY wo.order_id
    ), 4, '0') AS work_order_no,
    wo.order_id,
    wo.product_lot,
    i.item_code,
    i.item_name,
    l.line_name,
    wo.order_qty,
    wo.order_date,
    pp.due_date,
    CASE
        WHEN pd.finish_date IS NULL THEN '진행중'
        WHEN pd.finish_date > pp.due_date THEN '지연완료'
        ELSE '정상완료'
    END AS order_status
FROM work_order wo
JOIN production_plan pp ON pp.prod_plan_id = wo.prod_plan_id
JOIN item i ON i.item_id = pp.item_id
JOIN line l ON l.line_id = wo.line_id
LEFT JOIN (
    SELECT order_id, MAX(prod_date) AS finish_date
    FROM production
    GROUP BY order_id
) pd ON pd.order_id = wo.order_id
WHERE wo.order_date <= DATE '2026-06-02'
ORDER BY wo.order_date DESC, wo.order_id DESC
FETCH FIRST 20 ROWS ONLY;


-- ============================================================
-- 25. 최종 무결성 점검: LOT / 문서번호 / 비고
-- 목적 : INSERT 후 조건 위반 가능성을 한 번 더 확인한다.
-- ============================================================

-- 완제품 LOT 중복 확인: 결과가 없어야 정상
SELECT
    product_lot,
    COUNT(*) AS lot_count
FROM work_order
GROUP BY product_lot
HAVING COUNT(*) > 1;


-- 원자재 LOT가 여러 품목에 걸쳐 중복 사용되었는지 확인: 결과가 없어야 정상
SELECT
    material_lot,
    COUNT(DISTINCT item_id) AS item_count
FROM material_inout
WHERE material_lot IS NOT NULL
GROUP BY material_lot
HAVING COUNT(DISTINCT item_id) > 1;


-- remark 30자 초과 점검: 결과가 없어야 정상
SELECT 'equipment' AS table_name, equip_id AS row_id, LENGTH(remark) AS remark_len, remark FROM equipment WHERE LENGTH(remark) > 30
UNION ALL SELECT 'material_inout', inout_id, LENGTH(remark), remark FROM material_inout WHERE LENGTH(remark) > 30
UNION ALL SELECT 'bom', bom_id, LENGTH(remark), remark FROM bom WHERE LENGTH(remark) > 30
UNION ALL SELECT 'item', item_id, LENGTH(remark), remark FROM item WHERE LENGTH(remark) > 30
UNION ALL SELECT 'board_comment', comment_id, LENGTH(remark), remark FROM board_comment WHERE LENGTH(remark) > 30
UNION ALL SELECT 'bom_detail', bom_detail_id, LENGTH(remark), remark FROM bom_detail WHERE LENGTH(remark) > 30
UNION ALL SELECT 'equipment_maintenance', equip_main_id, LENGTH(remark), remark FROM equipment_maintenance WHERE LENGTH(remark) > 30
UNION ALL SELECT 'equipment_trouble', trouble_id, LENGTH(remark), remark FROM equipment_trouble WHERE LENGTH(remark) > 30
UNION ALL SELECT 'board', board_id, LENGTH(remark), remark FROM board WHERE LENGTH(remark) > 30
UNION ALL SELECT 'inspection', insp_id, LENGTH(remark), remark FROM inspection WHERE LENGTH(remark) > 30
UNION ALL SELECT 'defect', defect_id, LENGTH(remark), remark FROM defect WHERE LENGTH(remark) > 30
UNION ALL SELECT 'defect_list', defect_list_id, LENGTH(remark), remark FROM defect_list WHERE LENGTH(remark) > 30
UNION ALL SELECT 'production_plan', prod_plan_id, LENGTH(remark), remark FROM production_plan WHERE LENGTH(remark) > 30
UNION ALL SELECT 'actual_cost_daily', actual_cost_id, LENGTH(remark), remark FROM actual_cost_daily WHERE LENGTH(remark) > 30
UNION ALL SELECT 'process_detail', proc_id, LENGTH(remark), remark FROM process_detail WHERE LENGTH(remark) > 30
UNION ALL SELECT 'line', line_id, LENGTH(remark), remark FROM line WHERE LENGTH(remark) > 30
UNION ALL SELECT 'inventory', inventory_id, LENGTH(remark), remark FROM inventory WHERE LENGTH(remark) > 30
UNION ALL SELECT 'process', proc_id, LENGTH(remark), remark FROM process WHERE LENGTH(remark) > 30
UNION ALL SELECT 'client', client_id, LENGTH(remark), remark FROM client WHERE LENGTH(remark) > 30
UNION ALL SELECT 'product_inout', inout_id, LENGTH(remark), remark FROM product_inout WHERE LENGTH(remark) > 30
UNION ALL SELECT 'notice', notice_id, LENGTH(remark), remark FROM notice WHERE LENGTH(remark) > 30
UNION ALL SELECT 'work_order', order_id, LENGTH(remark), remark FROM work_order WHERE LENGTH(remark) > 30
UNION ALL SELECT 'production', prod_id, LENGTH(remark), remark FROM production WHERE LENGTH(remark) > 30;


-- 금지 저장값 점검: 결과가 없어야 정상
SELECT 'material_inout' AS table_name, inout_id AS row_id, remark FROM material_inout
WHERE remark LIKE '%PP-%' OR remark LIKE '%WO-%' OR remark LIKE '%PR-%'
   OR remark LIKE '%INSP-%' OR remark LIKE '%DEF-%'
   OR remark LIKE '%RM-MI%' OR remark LIKE '%RM-MO%'
   OR remark LIKE '%SM-MI%' OR remark LIKE '%SM-MO%'
   OR remark LIKE '%FG-MI%' OR remark LIKE '%FG-MO%'
   OR remark LIKE '%INV_%' OR remark LIKE '%DUE_%'
UNION ALL SELECT 'product_inout', inout_id, remark FROM product_inout
WHERE remark LIKE '%PP-%' OR remark LIKE '%WO-%' OR remark LIKE '%PR-%'
   OR remark LIKE '%INSP-%' OR remark LIKE '%DEF-%'
   OR remark LIKE '%RM-MI%' OR remark LIKE '%RM-MO%'
   OR remark LIKE '%SM-MI%' OR remark LIKE '%SM-MO%'
   OR remark LIKE '%FG-MI%' OR remark LIKE '%FG-MO%'
   OR remark LIKE '%INV_%' OR remark LIKE '%DUE_%'
UNION ALL SELECT 'inventory', inventory_id, remark FROM inventory
WHERE remark LIKE '%PP-%' OR remark LIKE '%WO-%' OR remark LIKE '%PR-%'
   OR remark LIKE '%INSP-%' OR remark LIKE '%DEF-%'
   OR remark LIKE '%RM-MI%' OR remark LIKE '%RM-MO%'
   OR remark LIKE '%SM-MI%' OR remark LIKE '%SM-MO%'
   OR remark LIKE '%FG-MI%' OR remark LIKE '%FG-MO%'
   OR remark LIKE '%INV_%' OR remark LIKE '%DUE_%';
