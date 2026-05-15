3차 프로젝트(saeroi) INSERT 최종본 v8 실행 순서

[기준]
- 본년도: 2026-03-02 ~ 2026-06-02
- 전년도: 2025-03-02 ~ 2025-06-02
- 주말/공휴일 제외
- 2026-06-02 시연일 기준 데이터 포함
- 이벤트는 특정일에 몰지 않고 전 기간에 분산
- remark/비고는 최대 30자 이내
- 문서번호/재고상태/납기상태 코드는 DB 저장 금지

[실행 순서]
1. 01_SAEROI_create_short_constraints.sql
2. 04_00_SAEROI_insert_master.sql
3. 04_01_SAEROI_insert_bom_process.sql
4. 04_02_SAEROI_insert_plan_order.sql
5. 04_03_SAEROI_insert_material_inout.sql
6. 04_04_SAEROI_insert_production_inspection_defect.sql
7. 04_05_SAEROI_insert_inventory_product_inout.sql
8. 04_06_SAEROI_insert_equipment_cost.sql
9. 04_07_SAEROI_insert_board_notice.sql
10. 04_08_SAEROI_doc_no_view_examples.sql 또는 04_09_SAEROI_dashboard_report_alert_examples.sql로 점검

[파일 역할]
- 04_00: 거래처/라인/사원/품목/설비/불량코드
- 04_01: BOM/공정/표준원가
- 04_02: 생산계획/작업지시/완제품 LOT
- 04_03: 자재입고/생산투입/원자재 LOT
- 04_04: 생산실적/검사/불량
- 04_05: 현재고/완제품입고
- 04_06: 설비가동/정비/고장/일일원가
- 04_07: 공지/게시판/댓글/파일
- 04_08: 문서번호 화면 생성 예시
- 04_09: 대시보드/리포트/알림 조회 예시

[v8 보정]
- 원자재 LOT를 품목별로 고유하게 생성해 LOT 추적성을 강화함
