/*
    프로젝트 : 3차 프로젝트(saeroi) - EV용 배터리 절연가스켓 제조 MES
    파일명   : 04_00_SAEROI_insert_master.sql
    목적     : 거래처, 라인, 사원, 품목, 설비, 불량코드 기준정보 생성
    기간     : 2026-03-02 ~ 2026-06-02 / 전년도 비교 2025-03-02 ~ 2025-06-02
    제외     : 주말, 공휴일, 회사 휴무일
    기준     : 문서번호와 상태코드는 DB에 저장하지 않고 조회/화면에서 생성한다.
    비고     : remark 값은 최대 30자 이내로 작성한다.
*/

-- ========================================================================
-- 1. 거래처(client) - 공급처/고객사 기준정보
-- ========================================================================
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (1, 'BP-SUP-001', '한국EPDM소재', 'SUP', '충남 아산시 둔포면', '김도현', '041-550-1001', '영업1팀', '주원료 공급처', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (2, 'BP-SUP-002', '실리콘폼코리아', 'SUP', '경기 화성시 향남읍', '이서윤', '031-440-2002', '소재영업팀', '실리콘폼 공급', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (3, 'BP-SUP-003', 'PU테크폼', 'SUP', '충북 진천군 덕산읍', '박진우', '043-760-3003', '영업2팀', 'PU폼 공급처', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (4, 'BP-SUP-004', '오토접착소재', 'SUP', '경기 평택시 청북읍', '최민지', '031-660-4004', '품질영업팀', '접착재 공급처', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (5, 'BP-SUP-005', '패키징파트너스', 'SUP', '충남 천안시 서북구', '정하늘', '041-900-5005', '포장자재팀', '포장재 공급처', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (6, 'BP-CUS-001', '현대모비스 아산', 'CUS', '충남 아산시 영인면', '한준서', '041-540-6001', '구매품질팀', 'ION5 납품처', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (7, 'BP-CUS-002', '기아 오토랜드 화성', 'CUS', '경기 화성시 우정읍', '오세린', '031-800-7002', '전장구매팀', 'EV6 납품처', DATE '2025-01-02', DATE '2026-01-02', 'Y');
INSERT INTO client (client_id, client_code, client_name, client_type, client_adress, client_man, client_tel, client_dept, remark, created_date, updated_date, use_yn) VALUES (8, 'BP-CUS-003', '배터리팩검증센터', 'CUS', '경기 의왕시 포일동', '문태경', '031-770-8003', '검증구매팀', '시제품 고객', DATE '2025-01-02', DATE '2026-01-02', 'Y');

-- ========================================================================
-- 2. 라인(line) - 4개 생산라인 기준정보
-- ========================================================================
INSERT INTO line (line_id, line_code, line_name, line_status, created_date, updated_date, remark) VALUES (1, 'LINE-001', '1라인 EPDM', 'LINE-RUN', DATE '2025-01-02', DATE '2026-06-02', 'EPDM 주생산');
INSERT INTO line (line_id, line_code, line_name, line_status, created_date, updated_date, remark) VALUES (2, 'LINE-002', '2라인 SIL', 'LINE-RUN', DATE '2025-01-02', DATE '2026-06-02', '실리콘 주생산');
INSERT INTO line (line_id, line_code, line_name, line_status, created_date, updated_date, remark) VALUES (3, 'LINE-003', '3라인 PU', 'LINE-RUN', DATE '2025-01-02', DATE '2026-06-02', 'PU 주생산');
INSERT INTO line (line_id, line_code, line_name, line_status, created_date, updated_date, remark) VALUES (4, 'LINE-004', '4라인 혼합', 'LINE-IDLE', DATE '2025-01-02', DATE '2026-06-02', '혼합 예비라인');

-- ========================================================================
-- 3. 사원(emp) - 시스템 사용자/작업자 기준정보
-- ========================================================================
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (1, 'E2026001', 'pw0001', '박민호', '관리자', '관리자', DATE '2025-01-09', '010-5501-1001', 'user1@saeroi.co.kr', '재직', 'ADMIN', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (2, 'E2026002', 'pw0002', '이왕재', '생산관리', '생산관리', DATE '2025-01-16', '010-5502-1002', 'user2@saeroi.co.kr', '재직', 'MANAGER', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (3, 'E2026003', 'pw0003', '강정석', '품질관리', '품질관리', DATE '2025-01-23', '010-5503-1003', 'user3@saeroi.co.kr', '재직', 'QC', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (4, 'E2026004', 'pw0004', '이용상', '설비관리', '설비관리', DATE '2025-01-30', '010-5504-1004', 'user4@saeroi.co.kr', '재직', 'MAINT', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (5, 'E2026005', 'pw0005', '강유빈', '작업자', '작업자', DATE '2025-02-06', '010-5505-1005', 'user5@saeroi.co.kr', '재직', 'WORKER', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (6, 'E2026006', 'pw0006', '김하준', '관리자', '관리자', DATE '2025-02-13', '010-5506-1006', 'user6@saeroi.co.kr', '재직', 'ADMIN', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (7, 'E2026007', 'pw0007', '윤서아', '생산관리', '생산관리', DATE '2025-02-20', '010-5507-1007', 'user7@saeroi.co.kr', '재직', 'MANAGER', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (8, 'E2026008', 'pw0008', '정도윤', '품질관리', '품질관리', DATE '2025-02-27', '010-5508-1008', 'user8@saeroi.co.kr', '재직', 'QC', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (9, 'E2026009', 'pw0009', '최지안', '설비관리', '설비관리', DATE '2025-03-06', '010-5509-1009', 'user9@saeroi.co.kr', '재직', 'MAINT', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (10, 'E2026010', 'pw0010', '문서준', '작업자', '작업자', DATE '2025-03-13', '010-5510-1010', 'user10@saeroi.co.kr', '재직', 'WORKER', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (11, 'E2026011', 'pw0011', '한유진', '관리자', '관리자', DATE '2025-03-20', '010-5511-1011', 'user11@saeroi.co.kr', '재직', 'ADMIN', DATE '2025-01-02', DATE '2026-06-02');
INSERT INTO emp (emp_id, empno, emp_pw, ename, dept, job, hire_date, emp_tel, email, status, role, created_date, updated_date) VALUES (12, 'E2026012', 'pw0012', '오지호', '생산관리', '생산관리', DATE '2025-03-27', '010-5512-1012', 'user12@saeroi.co.kr', '재직', 'MANAGER', DATE '2025-01-02', DATE '2026-06-02');

-- ========================================================================
-- 4. 품목(item) - 완제품/원자재/부자재 기준정보
-- ========================================================================
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (1001, 1, 6, 'FG-GSK-ION5-EPDM-001', '아이오닉5 배터리팩 메인 방수 가스켓', 'FG', 3000, 'EA', 'ION5 EPDM 완제품', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (1002, 2, 6, 'FG-GSK-ION5-SIL-001', '아이오닉5 배터리 커버 실리콘 가스켓', 'FG', 2500, 'EA', 'ION5 SIL 완제품', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (1003, 3, 6, 'FG-GSK-ION5-PU-001', '아이오닉5 배터리 서비스커버 PU 가스켓', 'FG', 2200, 'EA', 'ION5 PU 완제품', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (1004, 1, 7, 'FG-GSK-EV6-EPDM-001', 'EV6 배터리팩 메인 방수 가스켓', 'FG', 2800, 'EA', 'EV6 EPDM 완제품', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (1005, 2, 7, 'FG-GSK-EV6-SIL-001', 'EV6 배터리 커버 실리콘 가스켓', 'FG', 2400, 'EA', 'EV6 SIL 완제품', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (1006, 3, 7, 'FG-GSK-EV6-PU-001', 'EV6 배터리 모듈 보호 PU 가스켓', 'FG', 2000, 'EA', 'EV6 PU 완제품', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (2001, 1, NULL, 'RM-EPDM-SHEET-001', 'EPDM Foam Sheet 3.0T', 'RM', 8000, 'M', 'EPDM 시트', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (2002, 2, NULL, 'RM-SIL-FOAM-001', 'Silicone Foam Sheet 2.5T', 'RM', 6500, 'M', '실리콘 시트', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (2003, 3, NULL, 'RM-PU-FOAM-001', 'PU Foam Sheet 2.0T', 'RM', 7000, 'M', 'PU 시트', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (2004, 4, NULL, 'RM-ADH-FILM-001', '양면 접착 필름', 'RM', 5000, 'M', '접착필름', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (2005, 4, NULL, 'RM-PRIMER-LIQ-001', '프라이머 용액', 'RM', 300, 'KG', '프라이머', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (2006, 4, NULL, 'RM-REL-FILM-001', '이형 필름', 'RM', 4500, 'M', '이형필름', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (3001, 5, NULL, 'SM-BOX-001', '완제품 포장 박스', 'SM', 1000, 'EA', '포장박스', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (3002, 5, NULL, 'SM-LABEL-001', 'LOT 라벨지', 'SM', 5000, 'EA', 'LOT 라벨', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (3003, 5, NULL, 'SM-PALLET-001', '출하 팔레트', 'SM', 150, 'EA', '팔레트', DATE '2025-01-02', DATE '2026-06-02', 'Y');
INSERT INTO item (item_id, supplier_id, client_id, item_code, item_name, item_type, safety_stock, item_unit, remark, created_date, updated_date, use_yn) VALUES (3004, 5, NULL, 'SM-BAG-001', '방진 포장 비닐', 'SM', 2000, 'EA', '방진비닐', DATE '2025-01-02', DATE '2026-06-02', 'Y');

-- ========================================================================
-- 5. 설비(equipment) - 라인별 주요 설비 기준정보
-- ========================================================================
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (1, 1, 'EQ-CUT-001', '1라인 자동 재단기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 2, 55000000, DATE '2024-06-25', '1라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (2, 1, 'EQ-LAM-001', '1라인 라미네이팅기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 3, 72000000, DATE '2024-07-05', '1라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (3, 1, 'EQ-PRS-001', '1라인 프레스 성형기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 4, 88000000, DATE '2024-07-15', '1라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (4, 1, 'EQ-VIS-001', '1라인 비전 검사기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 1, 64000000, DATE '2024-07-25', '1라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (5, 2, 'EQ-CUT-002', '2라인 자동 재단기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 2, 55000000, DATE '2024-08-04', '2라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (6, 2, 'EQ-LAM-002', '2라인 라미네이팅기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 3, 72000000, DATE '2024-08-14', '2라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (7, 2, 'EQ-PRS-002', '2라인 프레스 성형기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 4, 88000000, DATE '2024-08-24', '2라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (8, 2, 'EQ-VIS-002', '2라인 비전 검사기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 1, 64000000, DATE '2024-09-03', '2라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (9, 3, 'EQ-CUT-003', '3라인 자동 재단기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 2, 55000000, DATE '2024-09-13', '3라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (10, 3, 'EQ-LAM-003', '3라인 라미네이팅기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 3, 72000000, DATE '2024-09-23', '3라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (11, 3, 'EQ-PRS-003', '3라인 프레스 성형기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 4, 88000000, DATE '2024-10-03', '3라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (12, 3, 'EQ-VIS-003', '3라인 비전 검사기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 1, 64000000, DATE '2024-10-13', '3라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (13, 4, 'EQ-CUT-004', '4라인 자동 재단기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 2, 55000000, DATE '2024-10-23', '4라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (14, 4, 'EQ-LAM-004', '4라인 라미네이팅기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 3, 72000000, DATE '2024-11-02', '4라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (15, 4, 'EQ-PRS-004', '4라인 프레스 성형기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 4, 88000000, DATE '2024-11-12', '4라인');
INSERT INTO equipment (equip_id, line_id, equip_code, equip_name, equip_status, created_date, updated_date, use_yn, remark, client_id, equip_price, buy_date, equip_loc) VALUES (16, 4, 'EQ-VIS-004', '4라인 비전 검사기', '가동', DATE '2025-01-02', DATE '2026-06-02', 'Y', '설비 정상가동', 1, 64000000, DATE '2024-11-22', '4라인');

-- ========================================================================
-- 6. 불량코드(defect) - 검사 불량 유형 기준정보
-- ========================================================================
INSERT INTO defect (defect_id, defect_code, defect_type, defect_name, created_date, updated_date, remark) VALUES (1, 'DCD-DIM-001', '치수', '치수 초과', DATE '2025-01-02', DATE '2026-06-02', '공차이탈');
INSERT INTO defect (defect_id, defect_code, defect_type, defect_name, created_date, updated_date, remark) VALUES (2, 'DCD-CUT-001', '재단', '재단 버 발생', DATE '2025-01-02', DATE '2026-06-02', '재단불량');
INSERT INTO defect (defect_id, defect_code, defect_type, defect_name, created_date, updated_date, remark) VALUES (3, 'DCD-ADH-001', '접착', '접착 들뜸', DATE '2025-01-02', DATE '2026-06-02', '접착불량');
INSERT INTO defect (defect_id, defect_code, defect_type, defect_name, created_date, updated_date, remark) VALUES (4, 'DCD-CONT-001', '외관', '이물 오염', DATE '2025-01-02', DATE '2026-06-02', '오염불량');
INSERT INTO defect (defect_id, defect_code, defect_type, defect_name, created_date, updated_date, remark) VALUES (5, 'DCD-CRK-001', '외관', '눌림/크랙', DATE '2025-01-02', DATE '2026-06-02', '크랙불량');
INSERT INTO defect (defect_id, defect_code, defect_type, defect_name, created_date, updated_date, remark) VALUES (6, 'DEF-BAR-001', '라벨', '바코드 인식불량', DATE '2025-01-02', DATE '2026-06-02', '라벨불량');

COMMIT;
