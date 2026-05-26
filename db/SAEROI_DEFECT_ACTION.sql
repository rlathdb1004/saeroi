-------------------------------
SELECT * FROM DEFECT;

--defect 테이블 불량 처리 담당부서 컬럼 추가 함--
ALTER TABLE defect
ADD action_dept VARCHAR2(50);

UPDATE defect
SET action_dept = '품질'
WHERE defect_id = 1;

UPDATE defect
SET action_dept = '생산'
WHERE defect_id = 2;

UPDATE defect
SET action_dept = '생산'
WHERE defect_id = 3;

UPDATE defect
SET action_dept = '품질'
WHERE defect_id = 4;

UPDATE defect
SET action_dept = '물류'
WHERE defect_id = 5;

UPDATE defect
SET action_dept = '설비'
WHERE defect_id = 6;

COMMIT;

--테이블 드랍--
DROP TABLE defect_action CASCADE CONSTRAINTS;
SELECT * FROM defect_action;
--조치 및 처리내역 자체 테이블 생성--
CREATE TABLE defect_action (
    defect_action_id NUMBER NOT NULL,
    action_type VARCHAR2(20) DEFAULT 'DIRECT' NOT NULL,
    defect_id NUMBER,
    defect_list_id NUMBER,
    sort_no NUMBER DEFAULT 1,
    action_date DATE DEFAULT SYSDATE,
    emp_id NUMBER,
    action_content VARCHAR2(1000),
    use_yn VARCHAR2(1) DEFAULT 'Y',
    created_date DATE DEFAULT SYSDATE,
    updated_date DATE DEFAULT SYSDATE,

    CONSTRAINT pk_defect_action PRIMARY KEY (defect_action_id),

    CONSTRAINT fk_defect_action_defect
        FOREIGN KEY (defect_id)
        REFERENCES defect(defect_id),

    CONSTRAINT fk_defect_action_list
        FOREIGN KEY (defect_list_id)
        REFERENCES defect_list(defect_list_id),

    CONSTRAINT fk_defect_action_emp
        FOREIGN KEY (emp_id)
        REFERENCES emp(emp_id),

    CONSTRAINT ck_defect_action_type
        CHECK (action_type IN ('BASIC', 'DIRECT')),

    CONSTRAINT ck_defect_action_target
        CHECK (
            (action_type = 'BASIC' AND defect_id IS NOT NULL AND defect_list_id IS NULL)
            OR
            (action_type = 'DIRECT' AND defect_list_id IS NOT NULL)
        )
);

--내용 넣기--
INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 1, 1, 3, '치수 기준 초과로 품질관리팀 재측정 후 기준 초과 수량 격리 처리');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 1, 2, 3, '치수 초과 원인 확인 후 작업 조건 점검 및 재발 방지 조치 등록');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 2, 1, 4, '재단 버 발생으로 생산관리팀 재단 장비 칼날 상태 점검 후 재작업 진행');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 2, 2, 4, '재단면 불량 수량 분리 후 작업 조건 조정 및 재검사 요청');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 3, 1, 4, '접착 들뜸 발생으로 생산관리팀 접착 공정 조건 확인 후 재압착 처리');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 3, 2, 4, '접착 불량 부위 확인 후 자재 표면 상태 점검 및 불량품 분리');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 4, 1, 3, '이물 오염 확인으로 품질관리팀 오염 수량 격리 후 세척 가능 여부 판단');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 4, 2, 3, '이물 발생 원인 확인 후 작업장 청결 상태 점검 및 재검사 진행');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 5, 1, 5, '눌림/크랙 발생으로 물류관리팀 운반 및 적재 상태 확인 후 손상품 분리');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 5, 2, 5, '포장 및 보관 과정 문제 확인 후 재포장 처리, 사용 불가품 폐기 요청');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 6, 1, 6, '바코드 인식불량으로 설비관리팀 라벨 프린터 상태 점검 후 재출력 처리');

INSERT INTO defect_action
(defect_action_id, action_type, defect_id, sort_no, emp_id, action_content)
VALUES
((SELECT NVL(MAX(defect_action_id), 0) + 1 FROM defect_action),
 'BASIC', 6, 2, 6, '바코드 스캔 오류 원인 확인 후 라벨 위치 및 인쇄 농도 조정');

COMMIT;
--확인쿼리
SELECT
    da.defect_action_id,
    dl.defect_list_id,
    TO_CHAR(NVL(da.action_date, dl.defect_date), 'YYYY-MM-DD') AS action_date,
    d.action_dept AS dept,
    da.emp_id AS action_emp_id,
    NVL(e.ename, '-') AS action_ename,
    da.action_content
FROM defect_list dl,
     defect d,
     defect_action da,
     emp e
WHERE dl.defect_id = d.defect_id
AND da.emp_id = e.emp_id(+)
AND dl.defect_list_id = 604
AND (
    da.defect_list_id = dl.defect_list_id
    OR
    (da.defect_id = dl.defect_id AND da.defect_list_id IS NULL)
);

SELECT defect_action_id,
       action_type,
       defect_id,
       defect_list_id,
       sort_no,
       emp_id,
       action_content
FROM tofhdl.defect_action
WHERE defect_id = 6
OR defect_list_id = 604;

--------defect사진추가하기--------
SELECT * FROM DEFECT_LIST;
UPDATE defect_list
SET defect_photo =
    CASE defect_id
        WHEN 1 THEN
            CASE
                WHEN DBMS_RANDOM.VALUE(0, 1) < 0.5
                THEN '/resources/upload/defect/defect_size_1.png'
                ELSE '/resources/upload/defect/defect_size_2.png'
            END

        WHEN 2 THEN
            CASE
                WHEN DBMS_RANDOM.VALUE(0, 1) < 0.5
                THEN '/resources/upload/defect/defect_cut_1.png'
                ELSE '/resources/upload/defect/defect_cut_2.png'
            END

        WHEN 3 THEN
            CASE
                WHEN DBMS_RANDOM.VALUE(0, 1) < 0.5
                THEN '/resources/upload/defect/defect_bond_1.png'
                ELSE '/resources/upload/defect/defect_bond_2.png'
            END

        WHEN 4 THEN
            CASE
                WHEN DBMS_RANDOM.VALUE(0, 1) < 0.5
                THEN '/resources/upload/defect/defect_foreign_1.png'
                ELSE '/resources/upload/defect/defect_foreign_2.png'
            END

        WHEN 5 THEN
            CASE
                WHEN DBMS_RANDOM.VALUE(0, 1) < 0.5
                THEN '/resources/upload/defect/defect_crack_1.png'
                ELSE '/resources/upload/defect/defect_crack_2.png'
            END

        WHEN 6 THEN
            CASE
                WHEN DBMS_RANDOM.VALUE(0, 1) < 0.5
                THEN '/resources/upload/defect/defect_barcode_1.png'
                ELSE '/resources/upload/defect/defect_barcode_2.png'
            END
    END
WHERE defect_id IN (1, 2, 3, 4, 5, 6);

COMMIT;
