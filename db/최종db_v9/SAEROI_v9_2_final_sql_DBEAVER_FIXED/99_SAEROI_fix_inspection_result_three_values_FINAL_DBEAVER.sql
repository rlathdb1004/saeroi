/*
    파일명 : 99_SAEROI_fix_inspection_result_three_values_FINAL_DBEAVER.sql
    목적   : inspection.result 값을 최종 기준(합격 / 조건부 / 대기)으로 보정
    실행툴 : DBeaver / Oracle JDBC 기준

    최종 기준
    1) 검사 예정
       - inspection.result = '대기'
       - inspection.good_qty = 0
       - 연결된 defect_list / defect_action 은 use_yn = 'N'
       - product_inout 재고반영 없음

    2) 검사 완료 + 합격
       - inspection.result = '합격'
       - inspection.good_qty = inspection.inspection_qty
       - 연결된 활성 defect_list(use_yn='Y') 없음
       - 기존 defect_list / defect_action 은 삭제하지 않고 use_yn = 'N'
       - product_inout.inout_qty = inspection.good_qty

    3) 검사 완료 + 조건부
       - inspection.result = '조건부'
       - 활성 defect_list(use_yn='Y') 있음
       - inspection.good_qty = inspection.inspection_qty - 활성 defect_qty
       - product_inout.inout_qty = inspection.good_qty
*/

-- ============================================================
-- 0. 수정 전 점검
--    ORA-00934 방지를 위해 집계 결과를 inline view로 분리한다.
-- ============================================================
SELECT
    x.result,
    x.active_defect_yn,
    COUNT(*) AS cnt
FROM (
    SELECT
        i.insp_id,
        i.result,
        CASE
            WHEN NVL(d.active_defect_qty, 0) > 0 THEN '활성불량 있음'
            ELSE '활성불량 없음'
        END AS active_defect_yn
    FROM inspection i
    LEFT JOIN (
        SELECT
            insp_id,
            SUM(CASE WHEN use_yn = 'Y' THEN NVL(defect_qty, 0) ELSE 0 END) AS active_defect_qty
        FROM defect_list
        GROUP BY insp_id
    ) d
        ON d.insp_id = i.insp_id
) x
GROUP BY x.result, x.active_defect_yn
ORDER BY x.result, x.active_defect_yn;


-- ============================================================
-- 1. 기존 결과값 명칭 정리
-- ============================================================
UPDATE inspection
SET result = '조건부'
WHERE result = '조건부합격';


-- ============================================================
-- 2. inspection 결과값 / 양품수량 보정
--    - 기존 조건부 또는 일부 불량 건은 조건부로 유지
--    - 나머지 검사 완료 건은 합격으로 정리
-- ============================================================
MERGE INTO inspection i
USING (
    SELECT
        ix.insp_id,
        NVL(d.active_defect_qty, 0) AS active_defect_qty,
        CASE
            WHEN ix.insp_status = '검사 예정' THEN '대기'
            WHEN NVL(d.active_defect_qty, 0) > 0
                 AND (ix.result = '조건부' OR MOD(ix.insp_id, 9) = 0)
                THEN '조건부'
            ELSE '합격'
        END AS new_result,
        CASE
            WHEN ix.insp_status = '검사 예정' THEN 0
            WHEN NVL(d.active_defect_qty, 0) > 0
                 AND (ix.result = '조건부' OR MOD(ix.insp_id, 9) = 0)
                THEN GREATEST(NVL(ix.inspection_qty, 0) - NVL(d.active_defect_qty, 0), 0)
            ELSE NVL(ix.inspection_qty, 0)
        END AS new_good_qty,
        CASE
            WHEN ix.insp_status = '검사 예정' THEN '검사 대기'
            WHEN NVL(d.active_defect_qty, 0) > 0
                 AND (ix.result = '조건부' OR MOD(ix.insp_id, 9) = 0)
                THEN '조건부 입고대상'
            ELSE '검사합격 입고대상'
        END AS new_remark
    FROM inspection ix
    LEFT JOIN (
        SELECT
            insp_id,
            SUM(CASE WHEN use_yn = 'Y' THEN NVL(defect_qty, 0) ELSE 0 END) AS active_defect_qty
        FROM defect_list
        GROUP BY insp_id
    ) d
        ON d.insp_id = ix.insp_id
) s
ON (i.insp_id = s.insp_id)
WHEN MATCHED THEN UPDATE SET
    i.result = s.new_result,
    i.good_qty = s.new_good_qty,
    i.remark = s.new_remark;


-- ============================================================
-- 3. defect_list 논리 비활성/활성 정리
--    - 합격/대기 검사 건의 불량내역은 화면에 보이지 않도록 use_yn='N'
--    - 조건부 검사 건의 불량내역은 use_yn='Y'
-- ============================================================
UPDATE defect_list dl
SET dl.use_yn = (
    SELECT
        CASE
            WHEN i.result = '조건부' THEN 'Y'
            ELSE 'N'
        END
    FROM inspection i
    WHERE i.insp_id = dl.insp_id
)
WHERE EXISTS (
    SELECT 1
    FROM inspection i
    WHERE i.insp_id = dl.insp_id
);


-- ============================================================
-- 4. defect_action 논리 비활성/활성 정리
--    - 연결된 defect_list.use_yn과 동일하게 맞춘다.
-- ============================================================
UPDATE defect_action da
SET da.use_yn = (
    SELECT dl.use_yn
    FROM defect_list dl
    WHERE dl.defect_list_id = da.defect_list_id
)
WHERE EXISTS (
    SELECT 1
    FROM defect_list dl
    WHERE dl.defect_list_id = da.defect_list_id
);


-- ============================================================
-- 5. 검사 예정/대기 건의 완제품 입고 이력 제거
--    - 대기 상태는 재고 반영 대상이 아니므로 product_inout에 남기지 않는다.
-- ============================================================
DELETE FROM product_inout
WHERE insp_id IN (
    SELECT insp_id
    FROM inspection
    WHERE insp_status = '검사 예정'
       OR result = '대기'
);


-- ============================================================
-- 6. 검사 완료 건의 완제품 입고수량을 양품수량과 일치
--    - 합격: 전체 수량
--    - 조건부: 양품수량만
-- ============================================================
UPDATE product_inout pi
SET pi.inout_qty = (
        SELECT i.good_qty
        FROM inspection i
        WHERE i.insp_id = pi.insp_id
    ),
    pi.status = '완료',
    pi.use_yn = 'Y',
    pi.remark = (
        SELECT
            CASE
                WHEN i.result = '조건부' THEN '조건부 양품입고'
                ELSE '검사합격품 입고'
            END
        FROM inspection i
        WHERE i.insp_id = pi.insp_id
    )
WHERE EXISTS (
    SELECT 1
    FROM inspection i
    WHERE i.insp_id = pi.insp_id
      AND i.insp_status = '검사 완료'
);

COMMIT;


-- ============================================================
-- 7. 수정 후 점검
-- ============================================================

-- 7-1. inspection.result 분포
SELECT result, COUNT(*) AS cnt
FROM inspection
GROUP BY result
ORDER BY result;


-- 7-2. 결과값 / 활성불량 여부 분포
SELECT
    x.result,
    x.active_defect_yn,
    COUNT(*) AS cnt
FROM (
    SELECT
        i.insp_id,
        i.result,
        CASE
            WHEN NVL(d.active_defect_qty, 0) > 0 THEN '활성불량 있음'
            ELSE '활성불량 없음'
        END AS active_defect_yn
    FROM inspection i
    LEFT JOIN (
        SELECT
            insp_id,
            SUM(CASE WHEN use_yn = 'Y' THEN NVL(defect_qty, 0) ELSE 0 END) AS active_defect_qty
        FROM defect_list
        GROUP BY insp_id
    ) d
        ON d.insp_id = i.insp_id
) x
GROUP BY x.result, x.active_defect_yn
ORDER BY x.result, x.active_defect_yn;


-- 7-3. 합격인데 활성 defect_list가 있는 건: 0건이어야 함
SELECT
    i.insp_id,
    i.doc_no,
    i.result,
    NVL(d.active_defect_qty, 0) AS active_defect_qty
FROM inspection i
LEFT JOIN (
    SELECT
        insp_id,
        SUM(CASE WHEN use_yn = 'Y' THEN NVL(defect_qty, 0) ELSE 0 END) AS active_defect_qty
    FROM defect_list
    GROUP BY insp_id
) d
    ON d.insp_id = i.insp_id
WHERE i.result = '합격'
  AND NVL(d.active_defect_qty, 0) > 0
ORDER BY i.insp_id;


-- 7-4. 조건부인데 활성 defect_list가 없는 건: 0건이어야 함
SELECT
    i.insp_id,
    i.doc_no,
    i.result,
    NVL(d.active_defect_qty, 0) AS active_defect_qty
FROM inspection i
LEFT JOIN (
    SELECT
        insp_id,
        SUM(CASE WHEN use_yn = 'Y' THEN NVL(defect_qty, 0) ELSE 0 END) AS active_defect_qty
    FROM defect_list
    GROUP BY insp_id
) d
    ON d.insp_id = i.insp_id
WHERE i.result = '조건부'
  AND NVL(d.active_defect_qty, 0) = 0
ORDER BY i.insp_id;


-- 7-5. 검사 완료 수량 정합성: 0건이어야 함
SELECT
    i.insp_id,
    i.doc_no,
    i.result,
    i.inspection_qty,
    i.good_qty,
    NVL(d.active_defect_qty, 0) AS active_defect_qty
FROM inspection i
LEFT JOIN (
    SELECT
        insp_id,
        SUM(CASE WHEN use_yn = 'Y' THEN NVL(defect_qty, 0) ELSE 0 END) AS active_defect_qty
    FROM defect_list
    GROUP BY insp_id
) d
    ON d.insp_id = i.insp_id
WHERE i.insp_status = '검사 완료'
  AND NVL(i.inspection_qty, 0) <> NVL(i.good_qty, 0) + NVL(d.active_defect_qty, 0)
ORDER BY i.insp_id;


-- 7-6. 대기/검사예정인데 재고 반영된 건: 0건이어야 함
SELECT
    pi.inout_id,
    pi.insp_id,
    i.insp_status,
    i.result,
    pi.inout_qty
FROM product_inout pi
JOIN inspection i
    ON i.insp_id = pi.insp_id
WHERE i.insp_status = '검사 예정'
   OR i.result = '대기'
ORDER BY pi.inout_id;


-- 7-7. 입고수량과 양품수량 불일치: 0건이어야 함
SELECT
    pi.inout_id,
    pi.insp_id,
    pi.inout_qty,
    i.good_qty,
    i.result
FROM product_inout pi
JOIN inspection i
    ON i.insp_id = pi.insp_id
WHERE NVL(pi.inout_qty, 0) <> NVL(i.good_qty, 0)
ORDER BY pi.inout_id;


-- 7-8. defect_action과 defect_list의 use_yn 불일치: 0건이어야 함
SELECT
    da.defect_action_id,
    da.defect_list_id,
    da.use_yn AS action_use_yn,
    dl.use_yn AS defect_list_use_yn
FROM defect_action da
JOIN defect_list dl
    ON dl.defect_list_id = da.defect_list_id
WHERE NVL(da.use_yn, 'N') <> NVL(dl.use_yn, 'N')
ORDER BY da.defect_action_id;
