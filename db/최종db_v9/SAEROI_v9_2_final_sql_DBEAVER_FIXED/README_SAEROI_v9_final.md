# SAEROI v9 TUNED FINAL - PATH ONLY

## 기준
- 프로젝트: 3차 프로젝트(saeroi) EV용 배터리 절연가스켓 제조 MES
- 시연 기준일시: 2026-06-04 09:00
- 데이터 기간: 2025-03-02 ~ 2025-06-04, 2026-03-02 ~ 2026-06-04
- 목적: 현재 완성된 페이지 흐름, 대시보드, 리포트, LOT 추적, 검사상태 흐름을 고려한 최종 더미데이터

## 이미지 처리 기준
- 이 ZIP에는 resources/upload 폴더와 이미지 파일을 포함하지 않는다.
- DB에는 기존 프로젝트 upload 폴더를 그대로 사용할 수 있도록 경로 문자열만 유지한다.
- 공정사진: process_detail.proc_picture
- 불량사진: defect_list.defect_photo

## 실행 순서
새로 생성:
1. 02_SAEROI_drop_v9_final.sql
2. 01_SAEROI_create_v9_final.sql
3. 04_SAEROI_insert_v9_final.sql
4. 05_SAEROI_select_v9_check.sql

데이터만 재삽입:
1. 03_SAEROI_delete_v9_final.sql
2. 04_SAEROI_insert_v9_final.sql
3. 05_SAEROI_select_v9_check.sql

## 주요 반영사항
- production.inspection_status 추가: 검사 예정 / 검사 완료
- 검사 완료 건만 product_inout 반영
- client.business_no 추가
- doc_no/doc_seq 통합
- work_order QR 경로 컬럼 통합
- defect_photo, defect_action, action_dept 반영
- 대시보드/리포트용 OEE, 불량률, 생산량 편차 소폭 보정


## QR 더미데이터 기준

현재 프로젝트 화면은 작업지시 상세/인쇄에서 `/production/workorder/qr?orderId=...` 엔드포인트로 QR 이미지를 실시간 생성해서 표시한다.
따라서 더미데이터의 `work_order.qr_url`, `work_order.qr_image_path` 값은 혼동 방지를 위해 `NULL`로 유지한다.
컬럼은 기존 Mapper/DTO 호환을 위해 남겨둔다.


## v9.2 반영 사항

- `product_inout.insp_id` 컬럼을 추가했습니다.
- `product_inout.insp_id`는 `inspection.insp_id`를 FK로 참조합니다.
- 기존 `product_inout.order_id -> work_order.order_id`, `product_inout.item_id -> item.item_id` FK는 유지합니다.
- 완제품 입고 더미는 검사 완료 건만 생성되며, 각 입고건에 검사 근거 `insp_id`가 직접 들어갑니다.
- 검사 1건당 완제품 입고 1건 흐름을 명확히 하기 위해 `product_inout.insp_id`에는 UNIQUE 제약을 적용했습니다.


## DBeaver 실행 주의

`02_SAEROI_drop_v9_final.sql`은 DBeaver/JDBC 실행 기준으로 `/` 구분자를 제거한 버전입니다.
Oracle SQL Developer나 SQL*Plus에서 쓰는 `/` 한 줄 구분자는 DBeaver에서 ORA-00900으로 처리될 수 있으므로 넣지 않습니다.
