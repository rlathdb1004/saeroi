/*
    프로젝트 : 3차 프로젝트(saeroi) - EV용 배터리 절연가스켓 제조 MES
    파일명   : 04_07_SAEROI_insert_board_notice.sql
    목적     : 공지사항, 게시글, 댓글, 첨부파일 시연 데이터 생성
    기간     : 2026-03-02 ~ 2026-06-02 / 전년도 비교 2025-03-02 ~ 2025-06-02
    제외     : 주말, 공휴일, 회사 휴무일
    기준     : 문서번호와 상태코드는 DB에 저장하지 않고 조회/화면에서 생성한다.
    비고     : remark 값은 최대 30자 이내로 작성한다.
*/

-- ========================================================================
-- 1. 공지사항(notice) - 현장 알림 게시
-- ========================================================================
INSERT INTO "notice" ("notice_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (1, '시연 데이터 점검 안내', '대시보드와 LOT 추적 화면 점검 바랍니다.', 1, 13, DATE '2026-05-18', DATE '2026-05-18', '게시', 'Y', '공지 확인');
INSERT INTO "notice" ("notice_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (2, '품질 알림 기준 안내', '불량 발생 시 검사관리에서 확인합니다.', 1, 14, DATE '2026-05-22', DATE '2026-05-22', '게시', 'Y', '공지 확인');
INSERT INTO "notice" ("notice_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (3, '설비 점검 예정 안내', '금일 일부 설비 점검 예정입니다.', 1, 15, DATE '2026-06-02', DATE '2026-06-02', '게시', 'Y', '공지 확인');
INSERT INTO "notice" ("notice_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (4, '재고 부족 확인 안내', '안전재고 미만 품목 확인 바랍니다.', 1, 16, DATE '2026-06-02', DATE '2026-06-02', '게시', 'Y', '공지 확인');

-- ========================================================================
-- 2. 게시판(board) - 현장 공유 게시글
-- ========================================================================
INSERT INTO "board" ("board_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "remark", "use_yn") VALUES (1, 'LOT 추적 테스트', 'LOT 추적 테스트 관련 현장 공유 내용입니다.', 3, 6, DATE '2026-05-20', DATE '2026-05-20', '게시', '게시글 확인', 'Y');
INSERT INTO "board" ("board_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "remark", "use_yn") VALUES (2, '불량 원인 공유', '불량 원인 공유 관련 현장 공유 내용입니다.', 4, 7, DATE '2026-05-26', DATE '2026-05-26', '게시', '게시글 확인', 'Y');
INSERT INTO "board" ("board_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "remark", "use_yn") VALUES (3, '라인 점검 요청', '라인 점검 요청 관련 현장 공유 내용입니다.', 5, 8, DATE '2026-06-01', DATE '2026-06-01', '게시', '게시글 확인', 'Y');
INSERT INTO "board" ("board_id", "title", "content", "emp_id", "view_count", "created_date", "updated_date", "status", "remark", "use_yn") VALUES (4, '재고 수불 확인', '재고 수불 확인 관련 현장 공유 내용입니다.', 6, 9, DATE '2026-06-02', DATE '2026-06-02', '게시', '게시글 확인', 'Y');

-- ========================================================================
-- 3. 댓글(comment) - 게시글 확인 이력
-- ========================================================================
INSERT INTO "comment" ("comment_id", "board_id", "parent_comment_id", "emp_id", "content", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (1, 1, NULL, 7, '확인했습니다', DATE '2026-05-20', DATE '2026-05-20', '게시', 'Y', '댓글 확인');
INSERT INTO "comment" ("comment_id", "board_id", "parent_comment_id", "emp_id", "content", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (2, 2, NULL, 8, '확인했습니다', DATE '2026-05-26', DATE '2026-05-26', '게시', 'Y', '댓글 확인');
INSERT INTO "comment" ("comment_id", "board_id", "parent_comment_id", "emp_id", "content", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (3, 3, NULL, 9, '확인했습니다', DATE '2026-06-01', DATE '2026-06-01', '게시', 'Y', '댓글 확인');
INSERT INTO "comment" ("comment_id", "board_id", "parent_comment_id", "emp_id", "content", "created_date", "updated_date", "status", "use_yn", "remark") VALUES (4, 4, NULL, 6, '확인했습니다', DATE '2026-06-02', DATE '2026-06-02', '게시', 'Y', '댓글 확인');

-- ========================================================================
-- 4. 첨부파일(file) - 공지/게시글 파일
-- ========================================================================
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (1, 1, NULL, '시연 데이터 점검 안내.pdf', 'notice_1.pdf', '/upload/notice/notice_1.pdf', 1024, DATE '2026-05-18', DATE '2026-05-18');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (2, 2, NULL, '품질 알림 기준 안내.pdf', 'notice_2.pdf', '/upload/notice/notice_2.pdf', 2048, DATE '2026-05-22', DATE '2026-05-22');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (3, 3, NULL, '설비 점검 예정 안내.pdf', 'notice_3.pdf', '/upload/notice/notice_3.pdf', 3072, DATE '2026-06-02', DATE '2026-06-02');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (4, 4, NULL, '재고 부족 확인 안내.pdf', 'notice_4.pdf', '/upload/notice/notice_4.pdf', 4096, DATE '2026-06-02', DATE '2026-06-02');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (5, NULL, 1, 'LOT 추적 테스트.xlsx', 'board_1.xlsx', '/upload/board/board_1.xlsx', 2048, DATE '2026-05-20', DATE '2026-05-20');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (6, NULL, 2, '불량 원인 공유.xlsx', 'board_2.xlsx', '/upload/board/board_2.xlsx', 4096, DATE '2026-05-26', DATE '2026-05-26');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (7, NULL, 3, '라인 점검 요청.xlsx', 'board_3.xlsx', '/upload/board/board_3.xlsx', 6144, DATE '2026-06-01', DATE '2026-06-01');
INSERT INTO "file" ("file_id", "notice_id", "board_id", "title", "saved_title", "file_path", "file_size", "created_date", "updated_date") VALUES (8, NULL, 4, '재고 수불 확인.xlsx', 'board_4.xlsx', '/upload/board/board_4.xlsx', 8192, DATE '2026-06-02', DATE '2026-06-02');

COMMIT;
