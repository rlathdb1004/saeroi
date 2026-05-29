/*
    파일명 : 99_SAEROI_update_emp_role_uppercase.sql
    목적   : emp 테이블 role 값을 전부 대문자로 업데이트
    사용법 : 기존 데이터 INSERT 후 실행
*/

UPDATE emp
SET role = UPPER(TRIM(role))
WHERE role IS NOT NULL;

COMMIT;

-- 확인용
SELECT role, COUNT(*) AS cnt
FROM emp
GROUP BY role
ORDER BY role;
