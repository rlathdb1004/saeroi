/* =========================================================
   99_SAEROI_fix_worker_department_FINAL_DBEAVER.sql

   목적:
   - 생산실적 담당자 / MO-PROD 생산투입 담당자의 부서 정합성 보정
   - 사용자 최종 기준 반영:
     1) 직무가 '작업자'인 인원은 부서도 '작업자'
     2) 실제 직무가 생산관리/공정관리/관리자 성격인 인원만 부서 '생산관리'
     3) 생산실적 담당자와 MO-PROD 담당자는 작업자 부서 기준

   적용 대상:
   - EMP_ID 15 배준호
   - EMP_ID 16 이하린
   - EMP_ID 17 고민석
   - EMP_ID 18 신유나

   DBeaver 실행 기준:
   - SQL*Plus용 '/' 구분자 사용하지 않음
   - 전체 파일 실행 가능
   ========================================================= */


/* =========================================================
   1. 보정 전 생산실적 담당자 분포 확인
   ========================================================= */

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


/* =========================================================
   2. 보정 전 MO-PROD 담당자 분포 확인
   ========================================================= */

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


/* =========================================================
   3. 작업자 인원 부서/직무/권한 보정
   - 직무가 작업자인 생산실적/MO-PROD 담당자는 부서도 작업자로 통일
   ========================================================= */

UPDATE emp
SET
    dept = '작업자',
    job = '작업자',
    role = 'WORKER',
    updated_date = SYSDATE
WHERE emp_id IN (15, 16, 17, 18);


/* =========================================================
   4. 생산실적 담당자 재배치
   - 생산실적 담당자가 관리자/품질/물류/설비/test 계정으로 들어간 경우
     15,16,17,18번 작업자에게 균등 재배치
   ========================================================= */

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


/* =========================================================
   5. MO-PROD 담당자 재배치
   - 작업지시 자동투입 / 생산투입 담당자가 작업자 외 계정이면
     15,16,17,18번 작업자에게 균등 재배치
   - 원자재 입고(MI)는 물류 담당자 흐름이므로 건드리지 않음
   ========================================================= */

UPDATE material_inout mi
SET
    mi.emp_id =
        CASE MOD(mi.inout_id, 4)
            WHEN 0 THEN 15
            WHEN 1 THEN 16
            WHEN 2 THEN 17
            ELSE 18
        END,
    mi.updated_date = SYSDATE
WHERE mi.inout_type = 'MO-PROD'
  AND mi.emp_id NOT IN (15, 16, 17, 18);


/* =========================================================
   6. 적용
   ========================================================= */

COMMIT;


/* =========================================================
   7. 보정 후 작업자 인원 확인
   - 15,16,17,18 모두 작업자 / 작업자 / WORKER 여야 정상
   ========================================================= */

SELECT
    emp_id,
    empno,
    ename,
    dept,
    job,
    role
FROM emp
WHERE emp_id IN (15, 16, 17, 18)
ORDER BY emp_id;


/* =========================================================
   8. 보정 후 생산실적 담당자 분포 확인
   - 15,16,17,18만 나와야 정상
   - dept/job/role은 작업자/작업자/WORKER 여야 정상
   ========================================================= */

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


/* =========================================================
   9. 생산실적 담당자 이상 데이터 확인
   - 결과가 0건이어야 정상
   ========================================================= */

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
WHERE e.dept <> '작업자'
   OR e.job <> '작업자'
   OR e.role <> 'WORKER'
ORDER BY p.prod_id;


/* =========================================================
   10. 보정 후 MO-PROD 담당자 분포 확인
   - MO-PROD는 생산투입 흐름이므로 작업자 담당자가 자연스러움
   ========================================================= */

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


/* =========================================================
   11. MO-PROD 담당자 이상 데이터 확인
   - 결과가 0건이어야 정상
   ========================================================= */

SELECT
    mi.inout_id,
    mi.inout_type,
    mi.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role
FROM material_inout mi
JOIN emp e
ON mi.emp_id = e.emp_id
WHERE mi.inout_type = 'MO-PROD'
  AND (
        e.dept <> '작업자'
        OR e.job <> '작업자'
        OR e.role <> 'WORKER'
  )
ORDER BY mi.inout_id;


/* =========================================================
   12. 참고 확인: MI 원자재 입고 담당자 분포
   - MI는 물류관리 담당자가 나오는 것이 자연스러움
   - 이 SQL은 확인용이며 데이터를 수정하지 않음
   ========================================================= */

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
WHERE mi.inout_type = 'MI'
GROUP BY
    mi.emp_id,
    e.empno,
    e.ename,
    e.dept,
    e.job,
    e.role,
    mi.inout_type
ORDER BY mi.emp_id;
