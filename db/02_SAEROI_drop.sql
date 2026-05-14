/*
    파일명 : 02_SAEROI_drop.sql
    목적   : 3차 프로젝트 MES 테이블 전체 삭제
    사용법 : 기존 테이블을 완전히 제거하고 CREATE 파일을 다시 실행할 때 사용한다.
    주의   : DROP TABLE은 되돌릴 수 없다. 필요한 데이터는 백업 후 실행한다.
             테이블이 존재하지 않으면 ORA-00942가 발생할 수 있다.
*/

-- 자식 테이블부터 삭제하기 위해 CREATE 순서의 역순으로 DROP한다.

-- production 테이블 삭제
DROP TABLE "production" CASCADE CONSTRAINTS PURGE;

-- work_order 테이블 삭제
DROP TABLE "work_order" CASCADE CONSTRAINTS PURGE;

-- notice 테이블 삭제
DROP TABLE "notice" CASCADE CONSTRAINTS PURGE;

-- product_inout 테이블 삭제
DROP TABLE "product_inout" CASCADE CONSTRAINTS PURGE;

-- client 테이블 삭제
DROP TABLE "client" CASCADE CONSTRAINTS PURGE;

-- process 테이블 삭제
DROP TABLE "process" CASCADE CONSTRAINTS PURGE;

-- inventory 테이블 삭제
DROP TABLE "inventory" CASCADE CONSTRAINTS PURGE;

-- line 테이블 삭제
DROP TABLE "line" CASCADE CONSTRAINTS PURGE;

-- process_detail 테이블 삭제
DROP TABLE "process_detail" CASCADE CONSTRAINTS PURGE;

-- actual_cost_daily 테이블 삭제
DROP TABLE "actual_cost_daily" CASCADE CONSTRAINTS PURGE;

-- production_plan 테이블 삭제
DROP TABLE "production_plan" CASCADE CONSTRAINTS PURGE;

-- defect_list 테이블 삭제
DROP TABLE "defect_list" CASCADE CONSTRAINTS PURGE;

-- defect 테이블 삭제
DROP TABLE "defect" CASCADE CONSTRAINTS PURGE;

-- inspection 테이블 삭제
DROP TABLE "inspection" CASCADE CONSTRAINTS PURGE;

-- board 테이블 삭제
DROP TABLE "board" CASCADE CONSTRAINTS PURGE;

-- equipment_trouble 테이블 삭제
DROP TABLE "equipment_trouble" CASCADE CONSTRAINTS PURGE;

-- file 테이블 삭제
DROP TABLE "file" CASCADE CONSTRAINTS PURGE;

-- equipment_maintenance 테이블 삭제
DROP TABLE "equipment_maintenance" CASCADE CONSTRAINTS PURGE;

-- bom_detail 테이블 삭제
DROP TABLE "bom_detail" CASCADE CONSTRAINTS PURGE;

-- comment 테이블 삭제
DROP TABLE "comment" CASCADE CONSTRAINTS PURGE;

-- item 테이블 삭제
DROP TABLE "item" CASCADE CONSTRAINTS PURGE;

-- bom 테이블 삭제
DROP TABLE "bom" CASCADE CONSTRAINTS PURGE;

-- material_inout 테이블 삭제
DROP TABLE "material_inout" CASCADE CONSTRAINTS PURGE;

-- emp 테이블 삭제
DROP TABLE "emp" CASCADE CONSTRAINTS PURGE;

-- standard_cost 테이블 삭제
DROP TABLE "standard_cost" CASCADE CONSTRAINTS PURGE;

-- equipment_history 테이블 삭제
DROP TABLE "equipment_history" CASCADE CONSTRAINTS PURGE;

-- equipment 테이블 삭제
DROP TABLE "equipment" CASCADE CONSTRAINTS PURGE;
