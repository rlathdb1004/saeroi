-- ============================================================
-- 파일명 : 06_SAEROI_alter_add_defect_photo.sql
-- 목적   : defect_list 테이블에 불량사진 경로 컬럼 추가
-- 작성 기준:
--   - 기존 3차 프로젝트 SAEROI DB 구조 유지
--   - defect_list는 검사별 불량 상세 이력 테이블
--   - defect_photo는 불량 사진 파일의 웹 접근 상대경로 저장용
-- 예시 저장값:
--   /resources/upload/defect/defect_1_20260522103000123.png
-- ============================================================

-- ------------------------------------------------------------
-- 1. 불량사진 컬럼 추가
-- ------------------------------------------------------------
ALTER TABLE defect_list
ADD defect_photo VARCHAR2(500) NULL;

-- ------------------------------------------------------------
-- 2. 컬럼 코멘트 추가
-- ------------------------------------------------------------
COMMENT ON COLUMN defect_list.defect_photo IS '불량사진 경로';

-- 3. 사용여부 컬럼 추가 --
ALTER TABLE defect
ADD use_yn CHAR(1) DEFAULT 'Y' NULL;

UPDATE defect
SET use_yn = 'Y'
WHERE use_yn IS NULL;

COMMIT;
