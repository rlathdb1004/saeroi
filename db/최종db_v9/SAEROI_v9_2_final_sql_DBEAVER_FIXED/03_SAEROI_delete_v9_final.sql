/*
    파일명 : 03_SAEROI_delete_v9_final.sql
    목적   : v9 최종 더미데이터 전체 삭제. 테이블 구조와 시퀀스는 유지.
*/

DELETE FROM attached_file;
DELETE FROM board_comment;
DELETE FROM defect_action;
DELETE FROM defect_list;
DELETE FROM product_inout;
DELETE FROM inspection;
DELETE FROM material_inout;
DELETE FROM production;
DELETE FROM equipment_history;
DELETE FROM actual_cost_daily;
DELETE FROM equipment_maintenance;
DELETE FROM equipment_trouble;
DELETE FROM process_detail;
DELETE FROM process;
DELETE FROM bom_detail;
DELETE FROM bom;
DELETE FROM work_order;
DELETE FROM production_plan;
DELETE FROM inventory;
DELETE FROM standard_cost;
DELETE FROM defect;
DELETE FROM equipment;
DELETE FROM board;
DELETE FROM notice;
DELETE FROM item;
DELETE FROM emp;
DELETE FROM line;
DELETE FROM client;

COMMIT;
