/*
    파일명 : 03_SAEROI_delete_safe_names.sql
    목적   : 3차 프로젝트 MES 더미데이터 전체 삭제
    사용법 : INSERT 파일을 다시 넣기 전에 실행한다.
    기준   : FK 오류를 피하기 위해 자식 테이블부터 부모 테이블 순서로 DELETE한다.
    주의   : 테이블 구조는 유지하고 데이터만 삭제한다.
*/
/*
    보정사항 : Oracle 예약어/키워드 충돌 방지를 위해 테이블명을 변경했다.
             comment -> board_comment
             file    -> attached_file
             테이블명/컬럼명은 큰따옴표 없는 일반 Oracle 식별자 기준이다.
*/



-- attached_file 데이터 삭제
DELETE FROM attached_file;

-- board_comment 데이터 삭제
DELETE FROM board_comment;

-- defect_list 데이터 삭제
DELETE FROM defect_list;

-- inspection 데이터 삭제
DELETE FROM inspection;

-- product_inout 데이터 삭제
DELETE FROM product_inout;

-- material_inout 데이터 삭제
DELETE FROM material_inout;

-- production 데이터 삭제
DELETE FROM production;

-- equipment_history 데이터 삭제
DELETE FROM equipment_history;

-- actual_cost_daily 데이터 삭제
DELETE FROM actual_cost_daily;

-- standard_cost 데이터 삭제
DELETE FROM standard_cost;

-- process_detail 데이터 삭제
DELETE FROM process_detail;

-- equipment_maintenance 데이터 삭제
DELETE FROM equipment_maintenance;

-- equipment_trouble 데이터 삭제
DELETE FROM equipment_trouble;

-- process 데이터 삭제
DELETE FROM process;

-- bom_detail 데이터 삭제
DELETE FROM bom_detail;

-- bom 데이터 삭제
DELETE FROM bom;

-- work_order 데이터 삭제
DELETE FROM work_order;

-- production_plan 데이터 삭제
DELETE FROM production_plan;

-- inventory 데이터 삭제
DELETE FROM inventory;

-- equipment 데이터 삭제
DELETE FROM equipment;

-- board 데이터 삭제
DELETE FROM board;

-- notice 데이터 삭제
DELETE FROM notice;

-- item 데이터 삭제
DELETE FROM item;

-- emp 데이터 삭제
DELETE FROM emp;

-- line 데이터 삭제
DELETE FROM line;

-- client 데이터 삭제
DELETE FROM client;

-- 삭제 확정
COMMIT;
