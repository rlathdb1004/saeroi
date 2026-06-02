/* =========================================================
   99_SAEROI_fix_production_status_by_qty_FINAL_DBEAVER.sql

   목적:
   - 기존 생산실적 중 수량 기준과 맞지 않는 PROD_STATUS 보정
   - 지시수량보다 누적 생산수량 + 누적 LOSS량이 부족한데 '완료'인 데이터 수정
   - 누적수량이 지시수량에 도달한 마지막 실적은 '완료' 처리
   - '보류', '취소' 상태는 사용자가 명시한 상태로 보고 유지

   기준:
   - 생산 진행수량 = PROD_QTY + LOSS_QTY
   - 취소 건은 누적수량에서 제외
   - 보류 건은 상태는 유지하지만, 수량은 기존 Mapper 기준처럼 누적에 포함
   - DBeaver 실행 기준
   - SQL*Plus용 / 구분자 사용하지 않음
   ========================================================= */


/* =========================================================
   1. 보정 전 이상 데이터 확인
   - 마지막 실적상태가 완료인데 누적수량이 지시수량보다 부족한 작업지시
   ========================================================= */

SELECT
    X.ORDER_ID,
    X.WORK_ORDER_DOC_NO,
    X.PRODUCT_LOT,
    X.ORDER_QTY,
    X.TOTAL_RUN_QTY,
    X.REMAIN_QTY,
    X.LAST_PROD_STATUS
FROM (
    SELECT
        WO.ORDER_ID,
        WO.DOC_NO AS WORK_ORDER_DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY,

        NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS TOTAL_RUN_QTY,

        WO.ORDER_QTY
        - NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS REMAIN_QTY,

        MAX(P.PROD_STATUS) KEEP (DENSE_RANK LAST ORDER BY P.PROD_ID) AS LAST_PROD_STATUS

    FROM WORK_ORDER WO
    LEFT JOIN PRODUCTION P
    ON WO.ORDER_ID = P.ORDER_ID
    GROUP BY
        WO.ORDER_ID,
        WO.DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY
) X
WHERE X.LAST_PROD_STATUS = '완료'
  AND X.TOTAL_RUN_QTY < X.ORDER_QTY
ORDER BY X.ORDER_ID;


/* =========================================================
   2. 생산실적 개별 상태 보정 대상 확인
   - 각 작업지시 안에서 PROD_ID 순서대로 누적수량 계산
   - 누적수량이 지시수량 미만이면 진행중
   - 누적수량이 지시수량 이상이면 완료
   - 보류 / 취소는 유지
   ========================================================= */

SELECT
    C.PROD_ID,
    C.ORDER_ID,
    C.WORK_ORDER_DOC_NO,
    C.PRODUCT_LOT,
    C.ORDER_QTY,
    C.PROD_QTY,
    C.LOSS_QTY,
    C.CUMULATIVE_QTY,
    C.OLD_PROD_STATUS,
    C.NEW_PROD_STATUS
FROM (
    SELECT
        P.PROD_ID,
        P.ORDER_ID,
        WO.DOC_NO AS WORK_ORDER_DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY,
        P.PROD_QTY,
        P.LOSS_QTY,
        P.PROD_STATUS AS OLD_PROD_STATUS,

        SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ) OVER (
            PARTITION BY P.ORDER_ID
            ORDER BY P.PROD_ID
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS CUMULATIVE_QTY,

        CASE
        WHEN SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ) OVER (
            PARTITION BY P.ORDER_ID
            ORDER BY P.PROD_ID
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) >= NVL(WO.ORDER_QTY, 0)
        THEN '완료'
        ELSE '진행중'
        END AS NEW_PROD_STATUS

    FROM PRODUCTION P
    JOIN WORK_ORDER WO
    ON P.ORDER_ID = WO.ORDER_ID
) C
WHERE NVL(C.OLD_PROD_STATUS, '진행중') NOT IN ('보류', '취소')
  AND NVL(C.OLD_PROD_STATUS, '진행중') != C.NEW_PROD_STATUS
ORDER BY C.ORDER_ID, C.PROD_ID;


/* =========================================================
   3. 생산실적 상태 보정 실행
   ========================================================= */

MERGE INTO PRODUCTION P
USING (
    SELECT
        C.PROD_ID,
        C.NEW_PROD_STATUS
    FROM (
        SELECT
            P2.PROD_ID,
            P2.PROD_STATUS AS OLD_PROD_STATUS,

            CASE
            WHEN SUM(
                CASE
                WHEN NVL(P2.PROD_STATUS, '진행중') != '취소'
                THEN NVL(P2.PROD_QTY, 0) + NVL(P2.LOSS_QTY, 0)
                ELSE 0
                END
            ) OVER (
                PARTITION BY P2.ORDER_ID
                ORDER BY P2.PROD_ID
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) >= NVL(WO.ORDER_QTY, 0)
            THEN '완료'
            ELSE '진행중'
            END AS NEW_PROD_STATUS

        FROM PRODUCTION P2
        JOIN WORK_ORDER WO
        ON P2.ORDER_ID = WO.ORDER_ID
    ) C
    WHERE NVL(C.OLD_PROD_STATUS, '진행중') NOT IN ('보류', '취소')
      AND NVL(C.OLD_PROD_STATUS, '진행중') != C.NEW_PROD_STATUS
) FIX
ON (P.PROD_ID = FIX.PROD_ID)
WHEN MATCHED THEN
UPDATE SET
    P.PROD_STATUS = FIX.NEW_PROD_STATUS,
    P.UPDATED_DATE = SYSDATE;

COMMIT;


/* =========================================================
   4. 보정 후 이상 데이터 재확인
   - 결과가 0건이어야 정상
   ========================================================= */

SELECT
    X.ORDER_ID,
    X.WORK_ORDER_DOC_NO,
    X.PRODUCT_LOT,
    X.ORDER_QTY,
    X.TOTAL_RUN_QTY,
    X.REMAIN_QTY,
    X.LAST_PROD_STATUS
FROM (
    SELECT
        WO.ORDER_ID,
        WO.DOC_NO AS WORK_ORDER_DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY,

        NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS TOTAL_RUN_QTY,

        WO.ORDER_QTY
        - NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS REMAIN_QTY,

        MAX(P.PROD_STATUS) KEEP (DENSE_RANK LAST ORDER BY P.PROD_ID) AS LAST_PROD_STATUS

    FROM WORK_ORDER WO
    LEFT JOIN PRODUCTION P
    ON WO.ORDER_ID = P.ORDER_ID
    GROUP BY
        WO.ORDER_ID,
        WO.DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY
) X
WHERE X.LAST_PROD_STATUS = '완료'
  AND X.TOTAL_RUN_QTY < X.ORDER_QTY
ORDER BY X.ORDER_ID;


/* =========================================================
   5. 전체 작업지시별 진행상태 확인용
   ========================================================= */

SELECT
    X.ORDER_ID,
    X.WORK_ORDER_DOC_NO,
    X.PRODUCT_LOT,
    X.ORDER_QTY,
    X.TOTAL_PROD_QTY,
    X.TOTAL_LOSS_QTY,
    X.TOTAL_RUN_QTY,
    X.REMAIN_QTY,
    X.LAST_PROD_STATUS,
    CASE
    WHEN X.LAST_PROD_STATUS = '보류' THEN '보류'
    WHEN X.LAST_PROD_STATUS = '취소' THEN '취소'
    WHEN X.TOTAL_RUN_QTY = 0 THEN '대기'
    WHEN X.TOTAL_RUN_QTY < X.ORDER_QTY THEN '진행중'
    ELSE '완료'
    END AS CALC_PROGRESS_STATUS
FROM (
    SELECT
        WO.ORDER_ID,
        WO.DOC_NO AS WORK_ORDER_DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY,

        NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0)
            ELSE 0
            END
        ), 0) AS TOTAL_PROD_QTY,

        NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS TOTAL_LOSS_QTY,

        NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS TOTAL_RUN_QTY,

        WO.ORDER_QTY
        - NVL(SUM(
            CASE
            WHEN NVL(P.PROD_STATUS, '진행중') != '취소'
            THEN NVL(P.PROD_QTY, 0) + NVL(P.LOSS_QTY, 0)
            ELSE 0
            END
        ), 0) AS REMAIN_QTY,

        MAX(P.PROD_STATUS) KEEP (DENSE_RANK LAST ORDER BY P.PROD_ID) AS LAST_PROD_STATUS

    FROM WORK_ORDER WO
    LEFT JOIN PRODUCTION P
    ON WO.ORDER_ID = P.ORDER_ID
    GROUP BY
        WO.ORDER_ID,
        WO.DOC_NO,
        WO.PRODUCT_LOT,
        WO.ORDER_QTY
) X
ORDER BY X.ORDER_ID DESC;

/* =========================================================
   생산실적 / MO-PROD 담당자 부서 정합성 보정
   기준:
   - 생산실적 담당자와 MO-PROD 담당자는 생산관리 작업자
   - 생산실적 담당자는 15,16,17,18번 작업자로 재배치
   ========================================================= */


/* 1. 생산실적 및 MO-PROD 담당자로 쓰인 작업자 부서 정리 */
UPDATE emp
SET
    dept = '생산관리',
    job = '작업자',
    role = 'WORKER',
    updated_date = SYSDATE
WHERE emp_id IN (15, 16, 17, 18);


/* 2. 생산실적 담당자가 아닌 계정으로 들어간 실적 재배치 */
UPDATE production p
SET
    p.emp_id =
        CASE MOD(p.prod_id, 4)
            WHEN 0 THEN 15
            WHEN 1 THEN 16
            WHEN 2 THEN 17
            ELSE 18
        END,
    p.updated_date = SYSDATE
WHERE p.emp_id NOT IN (15, 16, 17, 18);


/* 3. 적용 */
COMMIT;


/* 4. 생산실적 담당자 확인 */
SELECT
    p.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role,
    COUNT(*) AS prod_count
FROM production p
JOIN emp e
ON p.emp_id = e.emp_id
GROUP BY
    p.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role
ORDER BY p.emp_id;


/* 5. 생산실적 담당자 이상 데이터 확인
   결과가 0건이면 정상 */
SELECT
    p.prod_id,
    p.doc_no,
    p.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role
FROM production p
JOIN emp e
ON p.emp_id = e.emp_id
WHERE e.dept <> '생산관리'
   OR e.job <> '작업자'
   OR e.role <> 'WORKER'
ORDER BY p.prod_id;


/* 6. MO-PROD 담당자 확인 */
SELECT
    mi.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role,
    mi.inout_type,
    COUNT(*) AS cnt
FROM material_inout mi
JOIN emp e
ON mi.emp_id = e.emp_id
WHERE mi.inout_type = 'MO-PROD'
GROUP BY
    mi.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role,
    mi.inout_type
ORDER BY mi.emp_id;