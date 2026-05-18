/*
    파일명 : 06_SAEROI_add_doc_columns_safe_names.sql
    목적   : 3차 프로젝트 EV용 배터리 절연가스켓 제조 MES 문서번호 컬럼 추가
    기준   : safe_names 스키마 + original_volume INSERT 기준
    반영   : 큰따옴표 없는 Oracle 일반 식별자 기준
             comment -> board_comment, file -> attached_file 보정 기준 유지

    추가 컬럼:
      - doc_no  : 전체 문서번호 저장용
      - doc_seq : 해당 날짜의 데이터 순서. 문서번호 마지막 4자리 숫자의 기준값

    제외 테이블:
      - work_order
        작업지시 테이블은 현재 기준에서 product_lot 컬럼을 LOT 추적 기준으로 사용하므로
        요청 기준에 따라 문서번호 컬럼 추가 대상에서 제외한다.

    주의:
      1) 이 파일은 컬럼 추가 전용이다.
      2) 기존 데이터가 들어있는 상태에서도 실행 가능하도록 doc_no, doc_seq는 우선 NULL 허용으로 추가한다.
      3) 기존 데이터에 문서번호 값을 채운 뒤 NOT NULL / UNIQUE 제약조건을 별도 SQL로 추가하는 것을 권장한다.
      4) 이미 컬럼이 추가된 상태에서 다시 실행하면 ORA-01430 오류가 발생할 수 있다.
*/

-- ============================================================
-- 1. 생산계획 문서번호 컬럼 추가
-- 문서번호 예시: PP-20260602-0001
-- 기준 날짜 컬럼: prod_plan_date
-- ============================================================
ALTER TABLE production_plan ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN production_plan.doc_no IS '생산계획 문서번호. 예: PP-20260602-0001';
COMMENT ON COLUMN production_plan.doc_seq IS '생산계획 해당 날짜 순번. 문서번호 마지막 숫자 기준';


-- ============================================================
-- 2. 자재 입출고 문서번호 컬럼 추가
-- 문서번호 예시: RM-MI-20260602-0001, RM-MO-20260602-0001, SM-MI-20260602-0001, SM-MO-20260602-0001
-- 기준 날짜 컬럼: inout_date
-- ============================================================
ALTER TABLE material_inout ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN material_inout.doc_no IS '자재 입출고 문서번호. 예: RM-MI-20260602-0001';
COMMENT ON COLUMN material_inout.doc_seq IS '자재 입출고 해당 날짜/구분별 순번';


-- ============================================================
-- 3. 완제품 입출고 문서번호 컬럼 추가
-- 문서번호 예시: FG-MI-20260602-0001, FG-MO-20260602-0001
-- 기준 날짜 컬럼: inout_date
-- ============================================================
ALTER TABLE product_inout ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN product_inout.doc_no IS '완제품 입출고 문서번호. 예: FG-MI-20260602-0001';
COMMENT ON COLUMN product_inout.doc_seq IS '완제품 입출고 해당 날짜/구분별 순번';


-- ============================================================
-- 4. 생산실적 문서번호 컬럼 추가
-- 문서번호 예시: PR-20260602-0001
-- 기준 날짜 컬럼: prod_date
-- ============================================================
ALTER TABLE production ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN production.doc_no IS '생산실적 문서번호. 예: PR-20260602-0001';
COMMENT ON COLUMN production.doc_seq IS '생산실적 해당 날짜 순번. 문서번호 마지막 숫자 기준';


-- ============================================================
-- 5. 검사 문서번호 컬럼 추가
-- 문서번호 예시: INSP-20260602-0001
-- 기준 날짜 컬럼: insp_date
-- ============================================================
ALTER TABLE inspection ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN inspection.doc_no IS '검사 문서번호. 예: INSP-20260602-0001';
COMMENT ON COLUMN inspection.doc_seq IS '검사 해당 날짜 순번. 문서번호 마지막 숫자 기준';


-- ============================================================
-- 6. 불량내역 문서번호 컬럼 추가
-- 문서번호 예시: DEF-20260602-0001
-- 기준 날짜 컬럼: defect_date
-- ============================================================
ALTER TABLE defect_list ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN defect_list.doc_no IS '불량내역 문서번호. 예: DEF-20260602-0001';
COMMENT ON COLUMN defect_list.doc_seq IS '불량내역 해당 날짜 순번. 문서번호 마지막 숫자 기준';


-- ============================================================
-- 7. 설비가동이력 문서번호 컬럼 추가
-- 문서번호 예시: EH-20260602-0001
-- 기준 날짜 컬럼: operation_date
-- ============================================================
ALTER TABLE equipment_history ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN equipment_history.doc_no IS '설비가동이력 문서번호. 예: EH-20260602-0001';
COMMENT ON COLUMN equipment_history.doc_seq IS '설비가동이력 해당 날짜 순번. 문서번호 마지막 숫자 기준';


-- ============================================================
-- 8. 일일 실제원가 문서번호 컬럼 추가
-- 문서번호 예시: AC-20260602-0001
-- 기준 날짜 컬럼: cost_date
-- ============================================================
ALTER TABLE actual_cost_daily ADD (
    doc_no  VARCHAR2(50),
    doc_seq NUMBER
);

COMMENT ON COLUMN actual_cost_daily.doc_no IS '일일 실제원가 문서번호. 예: AC-20260602-0001';
COMMENT ON COLUMN actual_cost_daily.doc_seq IS '일일 실제원가 해당 날짜 순번. 문서번호 마지막 숫자 기준';


-- ============================================================
-- 9. 컬럼 추가 확인용 조회
-- 목적: doc_no, doc_seq 컬럼이 정상 추가되었는지 확인한다.
-- ============================================================
SELECT
    table_name,
    column_name,
    data_type,
    data_length,
    nullable
FROM user_tab_columns
WHERE table_name IN (
    'PRODUCTION_PLAN',
    'MATERIAL_INOUT',
    'PRODUCT_INOUT',
    'PRODUCTION',
    'INSPECTION',
    'DEFECT_LIST',
    'EQUIPMENT_HISTORY',
    'ACTUAL_COST_DAILY'
)
AND column_name IN ('DOC_NO', 'DOC_SEQ')
ORDER BY table_name, column_id;

COMMIT;
