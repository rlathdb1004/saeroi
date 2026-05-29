/*
    파일명 : 01_SAEROI_create_v9_final.sql
    목적   : 3차 프로젝트 EV용 배터리 절연가스켓 제조 MES 최종 통합 테이블 생성
    기준   : 현재 완성 페이지/Mapper 기준 통합본
             - doc_no/doc_seq 컬럼 통합
             - work_order QR 컬럼 통합
             - production.inspection_status 추가
             - inspection.insp_status/use_yn 통합
             - defect.action_dept/use_yn, defect_list.defect_photo/use_yn 통합
             - defect_action 테이블 통합
             - client.business_no/latitude/longitude 통합
             - 화면 등록에서 사용하는 시퀀스 포함
    시연일 : 2026-06-04 09:00
    주의   : 기존 ALTER/UPDATE 패치 파일을 별도로 실행하지 않는다.
*/

CREATE TABLE client (
    client_id       NUMBER        NOT NULL,
    client_code     VARCHAR2(50)  NOT NULL,
    client_name     VARCHAR2(100),
    client_type     VARCHAR2(30),
    business_no     VARCHAR2(20),
    client_adress   VARCHAR2(300),
    client_man      VARCHAR2(50),
    client_tel      VARCHAR2(30),
    client_dept     VARCHAR2(50),
    latitude        NUMBER(13,10),
    longitude       NUMBER(13,10),
    remark          VARCHAR2(500),
    created_date    DATE,
    updated_date    DATE,
    use_yn          CHAR(1) DEFAULT 'Y'
);

CREATE TABLE line (
    line_id         NUMBER        NOT NULL,
    line_code       VARCHAR2(50)  NOT NULL,
    line_name       VARCHAR2(100),
    line_status     VARCHAR2(30),
    created_date    DATE,
    updated_date    DATE,
    remark          VARCHAR2(500)
);

CREATE TABLE emp (
    emp_id           NUMBER        NOT NULL,
    empno            VARCHAR2(30)  NOT NULL,
    emp_pw           VARCHAR2(100),
    ename            VARCHAR2(50),
    dept             VARCHAR2(50),
    job              VARCHAR2(50),
    hire_date        DATE,
    emp_tel          VARCHAR2(30),
    email            VARCHAR2(100),
    status           VARCHAR2(30),
    role             VARCHAR2(30),
    created_date     DATE,
    updated_date     DATE,
    auto_login_token VARCHAR2(200)
);

CREATE TABLE item (
    item_id        NUMBER        NOT NULL,
    supplier_id    NUMBER,
    client_id      NUMBER,
    item_code      VARCHAR2(60)  NOT NULL,
    item_name      VARCHAR2(150),
    item_type      VARCHAR2(30),
    safety_stock   NUMBER,
    item_unit      VARCHAR2(20),
    remark         VARCHAR2(500),
    created_date   DATE,
    updated_date   DATE,
    use_yn         CHAR(1) DEFAULT 'Y'
);

CREATE TABLE equipment (
    equip_id      NUMBER        NOT NULL,
    line_id       NUMBER,
    equip_code    VARCHAR2(50)  NOT NULL,
    equip_name    VARCHAR2(100),
    equip_status  VARCHAR2(30),
    created_date  DATE,
    updated_date  DATE,
    use_yn        CHAR(1) DEFAULT 'Y',
    remark        VARCHAR2(500),
    client_id     NUMBER,
    equip_price   NUMBER,
    buy_date      DATE,
    equip_loc     VARCHAR2(100)
);

CREATE TABLE defect (
    defect_id     NUMBER        NOT NULL,
    defect_code   VARCHAR2(50)  NOT NULL,
    defect_type   VARCHAR2(30),
    defect_name   VARCHAR2(100),
    action_dept   VARCHAR2(50),
    use_yn        CHAR(1) DEFAULT 'Y',
    created_date  DATE,
    updated_date  DATE,
    remark        VARCHAR2(500)
);

CREATE TABLE bom (
    bom_id        NUMBER        NOT NULL,
    bom_code      VARCHAR2(80)  NOT NULL,
    version       NUMBER,
    use_yn        CHAR(1) DEFAULT 'Y',
    remark        VARCHAR2(500),
    created_date  DATE,
    updated_date  DATE,
    item_id       NUMBER        NOT NULL
);

CREATE TABLE bom_detail (
    bom_detail_id NUMBER        NOT NULL,
    bom_id        NUMBER,
    qty           NUMBER,
    created_date  DATE,
    updated_date  DATE,
    remark        VARCHAR2(500),
    item_id       NUMBER        NOT NULL
);

CREATE TABLE process (
    proc_id       NUMBER        NOT NULL,
    item_id       NUMBER        NOT NULL,
    equip_id      NUMBER,
    proc_code     VARCHAR2(50),
    proc_name     VARCHAR2(100),
    proc_content  VARCHAR2(1000),
    created_date  DATE,
    updated_date  DATE,
    remark        VARCHAR2(500)
);

CREATE TABLE process_detail (
    proc_id       NUMBER        NOT NULL,
    proc_id2      NUMBER,
    proc_picture  VARCHAR2(500),
    created_date  DATE,
    updated_date  DATE,
    remark        VARCHAR2(500),
    proc_content  VARCHAR2(1000)
);

CREATE TABLE standard_cost (
    standard_cost_id NUMBER       NOT NULL,
    item_id          NUMBER       NOT NULL,
    unit_cost        NUMBER,
    cost_unit        VARCHAR2(20),
    material_cost    NUMBER,
    labor_cost       NUMBER,
    overhead_cost    NUMBER,
    use_yn           CHAR(1) DEFAULT 'Y',
    created_date     DATE,
    updated_date     DATE,
    remark           VARCHAR2(500)
);

CREATE TABLE production_plan (
    prod_plan_id   NUMBER        NOT NULL,
    prod_plan_qty  NUMBER,
    prod_plan_date DATE,
    created_date   DATE,
    updated_date   DATE,
    remark         VARCHAR2(500),
    item_id        NUMBER        NOT NULL,
    due_date       DATE,
    doc_no         VARCHAR2(50),
    doc_seq        NUMBER
);

CREATE TABLE work_order (
    order_id       NUMBER        NOT NULL,
    prod_plan_id   NUMBER,
    line_id        NUMBER,
    emp_id         NUMBER        NOT NULL,
    product_lot    VARCHAR2(30)  NOT NULL,
    order_qty      NUMBER,
    order_date     DATE,
    created_date   DATE,
    updated_date   DATE,
    remark         VARCHAR2(500),
    doc_no         VARCHAR2(50),
    doc_seq        NUMBER,
    qr_url         VARCHAR2(500),
    qr_image_path  VARCHAR2(500)
);

CREATE TABLE material_inout (
    inout_id      NUMBER        NOT NULL,
    emp_id        NUMBER        NOT NULL,
    inout_type    VARCHAR2(30),
    material_lot  VARCHAR2(30),
    inout_qty     NUMBER,
    inout_date    DATE,
    remark        VARCHAR2(500),
    created_date  DATE,
    updated_date  DATE,
    use_yn        CHAR(1) DEFAULT 'Y',
    status        VARCHAR2(30),
    order_id      NUMBER,
    item_id       NUMBER        NOT NULL,
    doc_no        VARCHAR2(50),
    doc_seq       NUMBER
);

CREATE TABLE production (
    prod_id            NUMBER        NOT NULL,
    emp_id             NUMBER        NOT NULL,
    order_id           NUMBER,
    prod_date          DATE,
    order_qty          NUMBER,
    prod_qty           NUMBER,
    loss_qty           NUMBER,
    prod_status        VARCHAR2(30),
    inspection_status  VARCHAR2(30) DEFAULT '검사 예정' NOT NULL,
    created_date       DATE,
    updated_date       DATE,
    remark             VARCHAR2(500),
    doc_no             VARCHAR2(50),
    doc_seq            NUMBER
);

CREATE TABLE inspection (
    insp_id         NUMBER        NOT NULL,
    emp_id          NUMBER        NOT NULL,
    prod_id         NUMBER,
    insp_type       VARCHAR2(30),
    insp_date       DATE,
    insp_status     VARCHAR2(30),
    result          VARCHAR2(30),
    inspection_qty  NUMBER,
    good_qty        NUMBER,
    remark          VARCHAR2(4000),
    created_date    DATE,
    updated_date    DATE,
    doc_no          VARCHAR2(50),
    doc_seq         NUMBER,
    use_yn          CHAR(1) DEFAULT 'Y'
);

CREATE TABLE defect_list (
    defect_list_id NUMBER        NOT NULL,
    defect_id      NUMBER        NOT NULL,
    insp_id        NUMBER        NOT NULL,
    defect_date    DATE,
    created_date   DATE,
    updated_date   DATE,
    remark         VARCHAR2(500),
    defect_qty     NUMBER,
    doc_no         VARCHAR2(50),
    doc_seq        NUMBER,
    defect_photo   VARCHAR2(500),
    use_yn         CHAR(1) DEFAULT 'Y'
);

CREATE TABLE defect_action (
    defect_action_id NUMBER       NOT NULL,
    action_type      VARCHAR2(20) DEFAULT 'DIRECT' NOT NULL,
    defect_id        NUMBER,
    defect_list_id   NUMBER,
    sort_no          NUMBER DEFAULT 1,
    action_date      DATE DEFAULT SYSDATE,
    emp_id           NUMBER,
    action_content   VARCHAR2(1000),
    use_yn           VARCHAR2(1) DEFAULT 'Y',
    created_date     DATE DEFAULT SYSDATE,
    updated_date     DATE DEFAULT SYSDATE
);

CREATE TABLE inventory (
    inventory_id     NUMBER        NOT NULL,
    inventory_stock  NUMBER,
    remark           VARCHAR2(500),
    stock_location   VARCHAR2(100),
    created_date     DATE,
    updated_date     DATE,
    item_id          NUMBER        NOT NULL
);

CREATE TABLE product_inout (
    inout_id     NUMBER        NOT NULL,
    emp_id       NUMBER        NOT NULL,
    inout_type   VARCHAR2(30),
    inout_qty    NUMBER,
    inout_date   DATE,
    remark       VARCHAR2(500),
    use_yn       CHAR(1) DEFAULT 'Y',
    status       VARCHAR2(30),
    order_id     NUMBER,
    item_id      NUMBER        NOT NULL,
    insp_id      NUMBER,
    doc_no       VARCHAR2(50),
    doc_seq      NUMBER
);

CREATE TABLE equipment_history (
    history_id      NUMBER        NOT NULL,
    equip_id        NUMBER        NOT NULL,
    operation_date  DATE          NOT NULL,
    time_start      DATE,
    time_end        DATE,
    plan_time_min   NUMBER,
    runtime_min     NUMBER,
    downtime_min    NUMBER,
    down_reason     VARCHAR2(100),
    remark          VARCHAR2(500),
    doc_no          VARCHAR2(50),
    doc_seq         NUMBER
);

CREATE TABLE actual_cost_daily (
    actual_cost_id NUMBER        NOT NULL,
    item_id        NUMBER        NOT NULL,
    cost_date      DATE          NOT NULL,
    unit_cost      NUMBER,
    cost_unit      VARCHAR2(20),
    material_cost  NUMBER,
    labor_cost     NUMBER,
    overhead_cost  NUMBER,
    created_date   DATE,
    updated_date   DATE,
    remark         VARCHAR2(500),
    doc_no         VARCHAR2(50),
    doc_seq        NUMBER
);

CREATE TABLE equipment_maintenance (
    equip_main_id       NUMBER       NOT NULL,
    equip_id            NUMBER,
    emp_id              NUMBER       NOT NULL,
    equip_main_date     DATE,
    equip_main_type     VARCHAR2(30),
    equip_main_content  VARCHAR2(1000),
    equip_main_time     NUMBER,
    created_date        DATE,
    updated_date        DATE,
    remark              VARCHAR2(500)
);

CREATE TABLE equipment_trouble (
    trouble_id       NUMBER       NOT NULL,
    equip_id         NUMBER,
    emp_id           NUMBER       NOT NULL,
    trouble_content  VARCHAR2(1000),
    trouble_date     DATE,
    trouble_resolve  VARCHAR2(1000),
    resolve_date     DATE,
    remark           VARCHAR2(500),
    created_date     DATE,
    updated_date     DATE
);

CREATE TABLE notice (
    notice_id     NUMBER        NOT NULL,
    title         VARCHAR2(200),
    content       CLOB,
    emp_id        NUMBER        NOT NULL,
    view_count    NUMBER,
    created_date  DATE,
    updated_date  DATE,
    status        VARCHAR2(30),
    use_yn        CHAR(1) DEFAULT 'Y',
    remark        VARCHAR2(500)
);

CREATE TABLE board (
    board_id      NUMBER        NOT NULL,
    title         VARCHAR2(200),
    content       CLOB,
    emp_id        NUMBER        NOT NULL,
    view_count    NUMBER,
    created_date  DATE,
    updated_date  DATE,
    status        VARCHAR2(30),
    remark        VARCHAR2(500),
    use_yn        CHAR(1) DEFAULT 'Y'
);

CREATE TABLE board_comment (
    comment_id         NUMBER       NOT NULL,
    board_id           NUMBER       NOT NULL,
    parent_comment_id  NUMBER,
    emp_id             NUMBER       NOT NULL,
    content            VARCHAR2(1000),
    created_date       DATE,
    updated_date       DATE,
    status             VARCHAR2(30),
    use_yn             CHAR(1) DEFAULT 'Y',
    remark             VARCHAR2(500)
);

CREATE TABLE attached_file (
    file_id       NUMBER        NOT NULL,
    notice_id     NUMBER,
    board_id      NUMBER,
    title         VARCHAR2(200),
    saved_title   VARCHAR2(255),
    file_path     VARCHAR2(500),
    file_size     NUMBER,
    created_date  DATE,
    updated_date  DATE
);

ALTER TABLE client ADD CONSTRAINT pk_clnt PRIMARY KEY (client_id);
ALTER TABLE line ADD CONSTRAINT pk_line PRIMARY KEY (line_id);
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (emp_id);
ALTER TABLE item ADD CONSTRAINT pk_item PRIMARY KEY (item_id);
ALTER TABLE equipment ADD CONSTRAINT pk_equip PRIMARY KEY (equip_id);
ALTER TABLE defect ADD CONSTRAINT pk_def PRIMARY KEY (defect_id);
ALTER TABLE bom ADD CONSTRAINT pk_bom PRIMARY KEY (bom_id);
ALTER TABLE bom_detail ADD CONSTRAINT pk_bom_dtl PRIMARY KEY (bom_detail_id);
ALTER TABLE process ADD CONSTRAINT pk_proc PRIMARY KEY (proc_id);
ALTER TABLE process_detail ADD CONSTRAINT pk_proc_dtl PRIMARY KEY (proc_id);
ALTER TABLE standard_cost ADD CONSTRAINT pk_std_cost PRIMARY KEY (standard_cost_id);
ALTER TABLE production_plan ADD CONSTRAINT pk_pp PRIMARY KEY (prod_plan_id);
ALTER TABLE work_order ADD CONSTRAINT pk_wo PRIMARY KEY (order_id);
ALTER TABLE material_inout ADD CONSTRAINT pk_mat_io PRIMARY KEY (inout_id);
ALTER TABLE production ADD CONSTRAINT pk_prod PRIMARY KEY (prod_id);
ALTER TABLE inspection ADD CONSTRAINT pk_insp PRIMARY KEY (insp_id);
ALTER TABLE defect_list ADD CONSTRAINT pk_def_list PRIMARY KEY (defect_list_id);
ALTER TABLE defect_action ADD CONSTRAINT pk_def_act PRIMARY KEY (defect_action_id);
ALTER TABLE inventory ADD CONSTRAINT pk_inv PRIMARY KEY (inventory_id);
ALTER TABLE product_inout ADD CONSTRAINT pk_prd_io PRIMARY KEY (inout_id);
ALTER TABLE equipment_history ADD CONSTRAINT pk_eq_hist PRIMARY KEY (history_id);
ALTER TABLE actual_cost_daily ADD CONSTRAINT pk_act_cost PRIMARY KEY (actual_cost_id);
ALTER TABLE equipment_maintenance ADD CONSTRAINT pk_eq_maint PRIMARY KEY (equip_main_id);
ALTER TABLE equipment_trouble ADD CONSTRAINT pk_eq_trbl PRIMARY KEY (trouble_id);
ALTER TABLE notice ADD CONSTRAINT pk_ntc PRIMARY KEY (notice_id);
ALTER TABLE board ADD CONSTRAINT pk_board PRIMARY KEY (board_id);
ALTER TABLE board_comment ADD CONSTRAINT pk_cmt PRIMARY KEY (comment_id);
ALTER TABLE attached_file ADD CONSTRAINT pk_file PRIMARY KEY (file_id);

ALTER TABLE client ADD CONSTRAINT uk_clnt_code UNIQUE (client_code);
ALTER TABLE client ADD CONSTRAINT uk_clnt_biz UNIQUE (business_no);
ALTER TABLE line ADD CONSTRAINT uk_line_code UNIQUE (line_code);
ALTER TABLE emp ADD CONSTRAINT uk_emp_no UNIQUE (empno);
ALTER TABLE item ADD CONSTRAINT uk_item_code UNIQUE (item_code);
ALTER TABLE equipment ADD CONSTRAINT uk_eq_code UNIQUE (equip_code);
ALTER TABLE defect ADD CONSTRAINT uk_def_code UNIQUE (defect_code);
ALTER TABLE bom ADD CONSTRAINT uk_bom_code UNIQUE (bom_code);
ALTER TABLE production_plan ADD CONSTRAINT uk_pp_doc UNIQUE (doc_no);
ALTER TABLE work_order ADD CONSTRAINT uk_wo_lot UNIQUE (product_lot);
ALTER TABLE work_order ADD CONSTRAINT uk_wo_doc UNIQUE (doc_no);
ALTER TABLE material_inout ADD CONSTRAINT uk_mio_doc UNIQUE (doc_no);
ALTER TABLE production ADD CONSTRAINT uk_prod_doc UNIQUE (doc_no);
ALTER TABLE inspection ADD CONSTRAINT uk_insp_doc UNIQUE (doc_no);
ALTER TABLE defect_list ADD CONSTRAINT uk_def_list_doc UNIQUE (doc_no);
ALTER TABLE product_inout ADD CONSTRAINT uk_pio_doc UNIQUE (doc_no);
ALTER TABLE product_inout ADD CONSTRAINT uk_pio_insp UNIQUE (insp_id);
ALTER TABLE equipment_history ADD CONSTRAINT uk_eq_hist_day UNIQUE (equip_id, operation_date);
ALTER TABLE equipment_history ADD CONSTRAINT uk_eqh_doc UNIQUE (doc_no);
ALTER TABLE actual_cost_daily ADD CONSTRAINT uk_acd_item_dt UNIQUE (item_id, cost_date);
ALTER TABLE actual_cost_daily ADD CONSTRAINT uk_acd_doc UNIQUE (doc_no);

ALTER TABLE item ADD CONSTRAINT fk_item_sup FOREIGN KEY (supplier_id) REFERENCES client(client_id);
ALTER TABLE item ADD CONSTRAINT fk_item_cust FOREIGN KEY (client_id) REFERENCES client(client_id);
ALTER TABLE equipment ADD CONSTRAINT fk_eq_line FOREIGN KEY (line_id) REFERENCES line(line_id);
ALTER TABLE equipment ADD CONSTRAINT fk_eq_client FOREIGN KEY (client_id) REFERENCES client(client_id);
ALTER TABLE bom ADD CONSTRAINT fk_bom_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE bom_detail ADD CONSTRAINT fk_bd_bom FOREIGN KEY (bom_id) REFERENCES bom(bom_id);
ALTER TABLE bom_detail ADD CONSTRAINT fk_bd_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE process ADD CONSTRAINT fk_proc_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE process ADD CONSTRAINT fk_proc_eq FOREIGN KEY (equip_id) REFERENCES equipment(equip_id);
ALTER TABLE process_detail ADD CONSTRAINT fk_pd_proc FOREIGN KEY (proc_id2) REFERENCES process(proc_id);
ALTER TABLE standard_cost ADD CONSTRAINT fk_stdc_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE production_plan ADD CONSTRAINT fk_pp_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE work_order ADD CONSTRAINT fk_wo_pp FOREIGN KEY (prod_plan_id) REFERENCES production_plan(prod_plan_id);
ALTER TABLE work_order ADD CONSTRAINT fk_wo_line FOREIGN KEY (line_id) REFERENCES line(line_id);
ALTER TABLE work_order ADD CONSTRAINT fk_wo_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE material_inout ADD CONSTRAINT fk_mio_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE material_inout ADD CONSTRAINT fk_mio_wo FOREIGN KEY (order_id) REFERENCES work_order(order_id);
ALTER TABLE material_inout ADD CONSTRAINT fk_mio_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE production ADD CONSTRAINT fk_prod_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE production ADD CONSTRAINT fk_prod_wo FOREIGN KEY (order_id) REFERENCES work_order(order_id);
ALTER TABLE inspection ADD CONSTRAINT fk_insp_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE inspection ADD CONSTRAINT fk_insp_prod FOREIGN KEY (prod_id) REFERENCES production(prod_id);
ALTER TABLE defect_list ADD CONSTRAINT fk_dl_def FOREIGN KEY (defect_id) REFERENCES defect(defect_id);
ALTER TABLE defect_list ADD CONSTRAINT fk_dl_insp FOREIGN KEY (insp_id) REFERENCES inspection(insp_id);
ALTER TABLE defect_action ADD CONSTRAINT fk_da_def FOREIGN KEY (defect_id) REFERENCES defect(defect_id);
ALTER TABLE defect_action ADD CONSTRAINT fk_da_list FOREIGN KEY (defect_list_id) REFERENCES defect_list(defect_list_id);
ALTER TABLE defect_action ADD CONSTRAINT fk_da_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE inventory ADD CONSTRAINT fk_inv_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE product_inout ADD CONSTRAINT fk_pio_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE product_inout ADD CONSTRAINT fk_pio_wo FOREIGN KEY (order_id) REFERENCES work_order(order_id);
ALTER TABLE product_inout ADD CONSTRAINT fk_pio_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE product_inout ADD CONSTRAINT fk_pio_insp FOREIGN KEY (insp_id) REFERENCES inspection(insp_id);
ALTER TABLE equipment_history ADD CONSTRAINT fk_eqh_eq FOREIGN KEY (equip_id) REFERENCES equipment(equip_id);
ALTER TABLE actual_cost_daily ADD CONSTRAINT fk_acd_item FOREIGN KEY (item_id) REFERENCES item(item_id);
ALTER TABLE equipment_maintenance ADD CONSTRAINT fk_eqm_eq FOREIGN KEY (equip_id) REFERENCES equipment(equip_id);
ALTER TABLE equipment_maintenance ADD CONSTRAINT fk_eqm_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE equipment_trouble ADD CONSTRAINT fk_eqt_eq FOREIGN KEY (equip_id) REFERENCES equipment(equip_id);
ALTER TABLE equipment_trouble ADD CONSTRAINT fk_eqt_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE notice ADD CONSTRAINT fk_ntc_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE board ADD CONSTRAINT fk_board_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE board_comment ADD CONSTRAINT fk_cmt_board FOREIGN KEY (board_id) REFERENCES board(board_id);
ALTER TABLE board_comment ADD CONSTRAINT fk_cmt_parent FOREIGN KEY (parent_comment_id) REFERENCES board_comment(comment_id);
ALTER TABLE board_comment ADD CONSTRAINT fk_cmt_emp FOREIGN KEY (emp_id) REFERENCES emp(emp_id);
ALTER TABLE attached_file ADD CONSTRAINT fk_file_ntc FOREIGN KEY (notice_id) REFERENCES notice(notice_id);
ALTER TABLE attached_file ADD CONSTRAINT fk_file_board FOREIGN KEY (board_id) REFERENCES board(board_id);

ALTER TABLE production ADD CONSTRAINT ck_prod_insp_status CHECK (inspection_status IN ('검사 예정', '검사 완료'));
ALTER TABLE inspection ADD CONSTRAINT ck_insp_status CHECK (insp_status IN ('검사 예정', '검사 완료'));
ALTER TABLE defect_action ADD CONSTRAINT ck_da_type CHECK (action_type IN ('BASIC', 'DIRECT'));
ALTER TABLE defect_action ADD CONSTRAINT ck_da_target CHECK ((action_type = 'BASIC' AND defect_id IS NOT NULL AND defect_list_id IS NULL) OR (action_type = 'DIRECT' AND defect_list_id IS NOT NULL));

CREATE SEQUENCE equipment_seq START WITH 1000 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE equipment_history_seq START WITH 10000 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_material_inout START WITH 100000 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_inventory_id START WITH 1000 INCREMENT BY 1 NOCACHE;

COMMENT ON COLUMN client.business_no IS '사업자 등록번호';
COMMENT ON COLUMN production.inspection_status IS '생산실적 기준 검사상태. 검사 예정/검사 완료';
COMMENT ON COLUMN inspection.insp_status IS '검사 이력 상태. 검사 예정/검사 완료';
COMMENT ON COLUMN defect_list.defect_photo IS '불량사진 경로';

COMMIT;
