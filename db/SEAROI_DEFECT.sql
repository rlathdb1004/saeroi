--use_yn 컬럼 추가 --
ALTER TABLE inspection ADD (use_yn CHAR(1) DEFAULT 'Y' NOT NULL);

SELECT * FROM PRODUCT_INOUT;

ALTER TABLE defect_list ADD (use_yn CHAR(1) DEFAULT 'Y' NOT NULL);

COMMIT;

--불량 바코드 인식 불량 -> QR 인식 불량으로 수정 함--
SELECT defect_id, defect_code, defect_name
FROM defect
WHERE defect_name LIKE '%바코드%';

UPDATE defect
SET defect_name = 'QR 인식 불량',
    updated_date = SYSDATE
WHERE defect_name = '바코드 인식불량';

COMMIT;

--QR 인식 불량으로 사진 변경--
UPDATE defect_list
SET defect_photo = '/resources/upload/defect/QR_1.png',
    updated_date = SYSDATE
WHERE defect_id = (
    SELECT defect_id
    FROM defect
    WHERE defect_name = 'QR 인식 불량'
);

COMMIT;

SELECT defect_list_id, defect_photo
FROM defect_list
WHERE defect_photo IS NOT NULL
ORDER BY defect_list_id DESC;
---product_inout 검사에서 양품 등록 시 중복으로 등록 방지 컬럼 추가 ---

