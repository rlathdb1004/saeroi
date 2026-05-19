/*
    파일명 : 08_SAEROI_add_work_order_doc_columns_safe_names.sql
    목적   : 3차 프로젝트 EV용 배터리 절연가스켓 제조 MES
             작업지시(work_order) 문서번호 컬럼 추가
    기준   : safe_names 스키마 + original_volume INSERT + doc_no/doc_seq 운영 기준
    설명   : 기존에는 work_order를 product_lot 중심으로 관리했지만,
             화면 표시/검색용 작업지시번호가 필요하므로 doc_no/doc_seq를 추가한다.
    주의   : 기존 데이터가 있을 수 있으므로 NULL 허용 상태로 컬럼만 먼저 추가한다.
             기존 데이터 문서번호 채우기는 09번 UPDATE 파일을 실행한다.
*/

-- ============================================================
-- 1. 작업지시 문서번호 컬럼 추가
--    doc_no  : 전체 작업지시번호 저장용
--    doc_seq : 작업지시일자 기준 순번 저장용
-- ============================================================

ALTER TABLE work_order ADD (
    doc_no VARCHAR2(50),
    doc_seq NUMBER
);

COMMIT;


-- ============================================================
-- 2. 컬럼 추가 확인
-- ============================================================

SELECT
    table_name,
    column_name,
    data_type,
    data_length,
    nullable
FROM user_tab_columns
WHERE table_name = 'WORK_ORDER'
  AND column_name IN ('DOC_NO', 'DOC_SEQ')
ORDER BY column_name;
