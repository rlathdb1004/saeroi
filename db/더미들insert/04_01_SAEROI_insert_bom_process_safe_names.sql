/*
    프로젝트 : 3차 프로젝트(saeroi) - EV용 배터리 절연가스켓 제조 MES
    파일명   : 04_01_SAEROI_insert_bom_process.sql
    목적     : BOM, 공정, 공정상세, 표준원가 기준정보 생성
    기간     : 2026-03-02 ~ 2026-06-02 / 전년도 비교 2025-03-02 ~ 2025-06-02
    제외     : 주말, 공휴일, 회사 휴무일
    기준     : 문서번호와 상태코드는 DB에 저장하지 않고 조회/화면에서 생성한다.
    비고     : remark 값은 최대 30자 이내로 작성한다.
*/

-- ========================================================================
-- 1. BOM(bom) - 완제품별 BOM 마스터
-- ========================================================================
INSERT INTO bom (bom_id, bom_code, version, use_yn, remark, created_date, updated_date, item_id) VALUES (1, 'BOM-FG-GSK-ION5-EPDM-001', 1, 'Y', 'BOM 기준정보', DATE '2025-01-02', DATE '2026-06-02', 1001);
INSERT INTO bom (bom_id, bom_code, version, use_yn, remark, created_date, updated_date, item_id) VALUES (2, 'BOM-FG-GSK-ION5-SIL-001', 1, 'Y', 'BOM 기준정보', DATE '2025-01-02', DATE '2026-06-02', 1002);
INSERT INTO bom (bom_id, bom_code, version, use_yn, remark, created_date, updated_date, item_id) VALUES (3, 'BOM-FG-GSK-ION5-PU-001', 1, 'Y', 'BOM 기준정보', DATE '2025-01-02', DATE '2026-06-02', 1003);
INSERT INTO bom (bom_id, bom_code, version, use_yn, remark, created_date, updated_date, item_id) VALUES (4, 'BOM-FG-GSK-EV6-EPDM-001', 1, 'Y', 'BOM 기준정보', DATE '2025-01-02', DATE '2026-06-02', 1004);
INSERT INTO bom (bom_id, bom_code, version, use_yn, remark, created_date, updated_date, item_id) VALUES (5, 'BOM-FG-GSK-EV6-SIL-001', 1, 'Y', 'BOM 기준정보', DATE '2025-01-02', DATE '2026-06-02', 1005);
INSERT INTO bom (bom_id, bom_code, version, use_yn, remark, created_date, updated_date, item_id) VALUES (6, 'BOM-FG-GSK-EV6-PU-001', 1, 'Y', 'BOM 기준정보', DATE '2025-01-02', DATE '2026-06-02', 1006);

-- ========================================================================
-- 2. BOM 상세(bom_detail) - 원자재/부자재 소요량
-- ========================================================================
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (1, 1, 0.55, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2001);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (2, 1, 0.52, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (3, 1, 0.02, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2005);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (4, 1, 1, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (5, 1, 0.02, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3001);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (6, 2, 0.48, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (7, 2, 0.45, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (8, 2, 0.48, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2006);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (9, 2, 1, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (10, 2, 0.02, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3001);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (11, 3, 0.42, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2003);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (12, 3, 0.4, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (13, 3, 0.01, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2005);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (14, 3, 1, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (15, 3, 0.05, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (16, 4, 0.58, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2001);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (17, 4, 0.55, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (18, 4, 0.02, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2005);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (19, 4, 1, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (20, 4, 0.02, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3001);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (21, 5, 0.5, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (22, 5, 0.47, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (23, 5, 0.5, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2006);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (24, 5, 1, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (25, 5, 0.02, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3001);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (26, 6, 0.44, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2003);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (27, 6, 0.42, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2004);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (28, 6, 0.01, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 2005);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (29, 6, 1, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3002);
INSERT INTO bom_detail (bom_detail_id, bom_id, qty, created_date, updated_date, remark, item_id) VALUES (30, 6, 0.05, DATE '2025-01-02', DATE '2026-06-02', '소요량 기준', 3004);

-- ========================================================================
-- 3. 공정(process) - 완제품별 기준 공정
-- ========================================================================
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (1, 1001, 1, 'PRC-CUT-001', '재단', '재단 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (2, 1001, 2, 'PRC-LAM-001', '라미네이팅', '라미네이팅 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (3, 1001, 3, 'PRC-PRS-001', '프레스성형', '프레스성형 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (4, 1001, 4, 'PRC-INSP-001', '검사', '검사 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (5, 1002, 5, 'PRC-CUT-001', '재단', '재단 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (6, 1002, 6, 'PRC-LAM-001', '라미네이팅', '라미네이팅 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (7, 1002, 7, 'PRC-PRS-001', '프레스성형', '프레스성형 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (8, 1002, 8, 'PRC-INSP-001', '검사', '검사 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (9, 1003, 9, 'PRC-CUT-001', '재단', '재단 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (10, 1003, 10, 'PRC-LAM-001', '라미네이팅', '라미네이팅 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (11, 1003, 11, 'PRC-PRS-001', '프레스성형', '프레스성형 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (12, 1003, 12, 'PRC-INSP-001', '검사', '검사 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (13, 1004, 1, 'PRC-CUT-001', '재단', '재단 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (14, 1004, 2, 'PRC-LAM-001', '라미네이팅', '라미네이팅 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (15, 1004, 3, 'PRC-PRS-001', '프레스성형', '프레스성형 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (16, 1004, 4, 'PRC-INSP-001', '검사', '검사 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (17, 1005, 5, 'PRC-CUT-001', '재단', '재단 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (18, 1005, 6, 'PRC-LAM-001', '라미네이팅', '라미네이팅 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (19, 1005, 7, 'PRC-PRS-001', '프레스성형', '프레스성형 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (20, 1005, 8, 'PRC-INSP-001', '검사', '검사 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (21, 1006, 9, 'PRC-CUT-001', '재단', '재단 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (22, 1006, 10, 'PRC-LAM-001', '라미네이팅', '라미네이팅 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (23, 1006, 11, 'PRC-PRS-001', '프레스성형', '프레스성형 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');
INSERT INTO process (proc_id, item_id, equip_id, proc_code, proc_name, proc_content, created_date, updated_date, remark) VALUES (24, 1006, 12, 'PRC-INSP-001', '검사', '검사 공정', DATE '2025-01-02', DATE '2026-06-02', '공정 기준');

-- ========================================================================
-- 4. 공정상세(process_detail) - 공정 이미지/설명
-- ========================================================================
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (1, 1, '/img/process/PRC-CUT-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '재단 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (2, 2, '/img/process/PRC-LAM-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '라미네이팅 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (3, 3, '/img/process/PRC-PRS-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '프레스성형 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (4, 4, '/img/process/PRC-INSP-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '검사 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (5, 5, '/img/process/PRC-CUT-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '재단 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (6, 6, '/img/process/PRC-LAM-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '라미네이팅 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (7, 7, '/img/process/PRC-PRS-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '프레스성형 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (8, 8, '/img/process/PRC-INSP-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '검사 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (9, 9, '/img/process/PRC-CUT-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '재단 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (10, 10, '/img/process/PRC-LAM-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '라미네이팅 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (11, 11, '/img/process/PRC-PRS-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '프레스성형 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (12, 12, '/img/process/PRC-INSP-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '검사 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (13, 13, '/img/process/PRC-CUT-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '재단 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (14, 14, '/img/process/PRC-LAM-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '라미네이팅 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (15, 15, '/img/process/PRC-PRS-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '프레스성형 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (16, 16, '/img/process/PRC-INSP-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '검사 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (17, 17, '/img/process/PRC-CUT-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '재단 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (18, 18, '/img/process/PRC-LAM-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '라미네이팅 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (19, 19, '/img/process/PRC-PRS-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '프레스성형 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (20, 20, '/img/process/PRC-INSP-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '검사 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (21, 21, '/img/process/PRC-CUT-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '재단 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (22, 22, '/img/process/PRC-LAM-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '라미네이팅 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (23, 23, '/img/process/PRC-PRS-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '프레스성형 작업 기준');
INSERT INTO process_detail (proc_id, proc_id2, proc_picture, created_date, updated_date, remark, proc_content) VALUES (24, 24, '/img/process/PRC-INSP-001.png', DATE '2025-01-02', DATE '2026-06-02', '공정상세', '검사 작업 기준');

-- ========================================================================
-- 5. 표준원가(standard_cost) - 원가 KPI 기준
-- ========================================================================
INSERT INTO standard_cost (standard_cost_id, item_id, unit_cost, cost_unit, material_cost, labor_cost, overhead_cost, use_yn, created_date, updated_date, remark) VALUES (1, 1001, 1280, 'KRW/EA', 794, 256, 230, 'Y', DATE '2025-01-02', DATE '2026-06-02', '표준단가');
INSERT INTO standard_cost (standard_cost_id, item_id, unit_cost, cost_unit, material_cost, labor_cost, overhead_cost, use_yn, created_date, updated_date, remark) VALUES (2, 1002, 1540, 'KRW/EA', 955, 308, 277, 'Y', DATE '2025-01-02', DATE '2026-06-02', '표준단가');
INSERT INTO standard_cost (standard_cost_id, item_id, unit_cost, cost_unit, material_cost, labor_cost, overhead_cost, use_yn, created_date, updated_date, remark) VALUES (3, 1003, 1160, 'KRW/EA', 719, 232, 209, 'Y', DATE '2025-01-02', DATE '2026-06-02', '표준단가');
INSERT INTO standard_cost (standard_cost_id, item_id, unit_cost, cost_unit, material_cost, labor_cost, overhead_cost, use_yn, created_date, updated_date, remark) VALUES (4, 1004, 1320, 'KRW/EA', 818, 264, 238, 'Y', DATE '2025-01-02', DATE '2026-06-02', '표준단가');
INSERT INTO standard_cost (standard_cost_id, item_id, unit_cost, cost_unit, material_cost, labor_cost, overhead_cost, use_yn, created_date, updated_date, remark) VALUES (5, 1005, 1580, 'KRW/EA', 980, 316, 284, 'Y', DATE '2025-01-02', DATE '2026-06-02', '표준단가');
INSERT INTO standard_cost (standard_cost_id, item_id, unit_cost, cost_unit, material_cost, labor_cost, overhead_cost, use_yn, created_date, updated_date, remark) VALUES (6, 1006, 1210, 'KRW/EA', 750, 242, 218, 'Y', DATE '2025-01-02', DATE '2026-06-02', '표준단가');

COMMIT;
