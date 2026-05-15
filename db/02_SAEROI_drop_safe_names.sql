/*
    파일명 : 02_SAEROI_drop_safe_names.sql
    목적   : 3차 프로젝트 MES 테이블 전체 삭제
    사용법 : 기존 테이블을 완전히 제거하고 CREATE 파일을 다시 실행할 때 사용한다.
    주의   : DROP TABLE은 되돌릴 수 없다. 필요한 데이터는 백업 후 실행한다.
             테이블이 존재하지 않으면 ORA-00942가 발생할 수 있다.
*/
/*
    보정사항 : Oracle 예약어/키워드 충돌 방지를 위해 테이블명을 변경했다.
             comment -> board_comment
             file    -> attached_file
             테이블명/컬럼명은 큰따옴표 없는 일반 Oracle 식별자 기준이다.
*/

/*
    변경사항 : 모든 테이블명/컬럼명 참조의 큰따옴표 제거.
    중요주의 : board_comment, attached_file 테이블은 Oracle 예약어/키워드 충돌 가능성이 있으므로 CREATE 실행 결과를 먼저 확인한다.
*/

-- 자식 테이블부터 삭제하기 위해 CREATE 순서의 역순으로 DROP한다.

-- production 테이블 삭제
DROP TABLE production CASCADE CONSTRAINTS PURGE;

-- work_order 테이블 삭제
DROP TABLE work_order CASCADE CONSTRAINTS PURGE;

-- notice 테이블 삭제
DROP TABLE notice CASCADE CONSTRAINTS PURGE;

-- product_inout 테이블 삭제
DROP TABLE product_inout CASCADE CONSTRAINTS PURGE;

-- client 테이블 삭제
DROP TABLE client CASCADE CONSTRAINTS PURGE;

-- process 테이블 삭제
DROP TABLE process CASCADE CONSTRAINTS PURGE;

-- inventory 테이블 삭제
DROP TABLE inventory CASCADE CONSTRAINTS PURGE;

-- line 테이블 삭제
DROP TABLE line CASCADE CONSTRAINTS PURGE;

-- process_detail 테이블 삭제
DROP TABLE process_detail CASCADE CONSTRAINTS PURGE;

-- actual_cost_daily 테이블 삭제
DROP TABLE actual_cost_daily CASCADE CONSTRAINTS PURGE;

-- production_plan 테이블 삭제
DROP TABLE production_plan CASCADE CONSTRAINTS PURGE;

-- defect_list 테이블 삭제
DROP TABLE defect_list CASCADE CONSTRAINTS PURGE;

-- defect 테이블 삭제
DROP TABLE defect CASCADE CONSTRAINTS PURGE;

-- inspection 테이블 삭제
DROP TABLE inspection CASCADE CONSTRAINTS PURGE;

-- board 테이블 삭제
DROP TABLE board CASCADE CONSTRAINTS PURGE;

-- equipment_trouble 테이블 삭제
DROP TABLE equipment_trouble CASCADE CONSTRAINTS PURGE;

-- attached_file 테이블 삭제
DROP TABLE attached_file CASCADE CONSTRAINTS PURGE;

-- equipment_maintenance 테이블 삭제
DROP TABLE equipment_maintenance CASCADE CONSTRAINTS PURGE;

-- bom_detail 테이블 삭제
DROP TABLE bom_detail CASCADE CONSTRAINTS PURGE;

-- board_comment 테이블 삭제
DROP TABLE board_comment CASCADE CONSTRAINTS PURGE;

-- item 테이블 삭제
DROP TABLE item CASCADE CONSTRAINTS PURGE;

-- bom 테이블 삭제
DROP TABLE bom CASCADE CONSTRAINTS PURGE;

-- material_inout 테이블 삭제
DROP TABLE material_inout CASCADE CONSTRAINTS PURGE;

-- emp 테이블 삭제
DROP TABLE emp CASCADE CONSTRAINTS PURGE;

-- standard_cost 테이블 삭제
DROP TABLE standard_cost CASCADE CONSTRAINTS PURGE;

-- equipment_history 테이블 삭제
DROP TABLE equipment_history CASCADE CONSTRAINTS PURGE;

-- equipment 테이블 삭제
DROP TABLE equipment CASCADE CONSTRAINTS PURGE;
