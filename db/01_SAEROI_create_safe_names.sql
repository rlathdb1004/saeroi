/*
    파일명 : 01_SAEROI_create_safe_names.sql
    목적   : 3차 프로젝트 EV용 배터리 절연가스켓 제조 MES 테이블 생성
    기준   : 사용자가 제공한 원본 ERD 구조 유지
    반영   : VARCHAR2 길이 지정, 주요 NOT NULL/UNIQUE 제약조건 설정
             제약조건명은 Oracle 30자 제한을 피하기 위해 짧은 이름으로 정리
    주의   : 테이블명/컬럼명에서 큰따옴표를 제거한 일반 Oracle 식별자 버전이다.
             SQL 작성 시 테이블명과 컬럼명을 큰따옴표 없이 사용한다.
*/
/*
    보정사항 : Oracle 예약어/키워드 충돌 방지를 위해 테이블명을 변경했다.
             comment -> board_comment
             file    -> attached_file
             테이블명/컬럼명은 큰따옴표 없는 일반 Oracle 식별자 기준이다.
*/

/*
    변경사항 : 모든 테이블명/컬럼명/제약조건 참조의 큰따옴표 제거.
    중요주의 : Oracle 예약어 comment/file은 테이블명으로 사용하지 않도록 board_comment/attached_file로 보정했다.
*/

-- ============================================================
-- 테이블: equipment
-- 설명  : 설비 마스터. 설비코드, 설비명, 현재상태, 라인, 구매정보를 관리한다.
-- ============================================================
CREATE TABLE equipment (
	equip_id	number		NULL,
	line_id	number		NULL,
	equip_code	varchar2(50)		NOT NULL,
	equip_name	varchar2(100)		NULL,
	equip_status	varchar2(30)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	use_yn	char(1)		NULL,
	remark	varchar2(500)		NULL,
	client_id	number		NULL,
	equip_price	number		NULL,
	buy_date	date		NULL,
	equip_loc	varchar2(100)		NULL
);


-- ============================================================
-- 테이블: equipment_history
-- 설명  : 설비별 일 단위 가동 집계. OEE 가동률과 최근 7일 추이도 계산에 사용한다.
-- ============================================================
CREATE TABLE equipment_history (
	history_id	number		NOT NULL,
	equip_id	number		NOT NULL,
	operation_date	date		NOT NULL,
	time_start	date		NULL,
	time_end	date		NULL,
	plan_time_min	number		NULL,
	runtime_min	number		NULL,
	downtime_min	number		NULL,
	down_reason	varchar2(100)		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: standard_cost
-- 설명  : 품목별 표준 단가. 원가편차율 계산의 기준값으로 사용한다.
-- ============================================================
CREATE TABLE standard_cost (
	standard_cost_id	number		NOT NULL,
	item_id	number		NOT NULL,
	unit_cost	number		NULL,
	cost_unit	varchar2(20)		NULL,
	material_cost	number		NULL,
	labor_cost	number		NULL,
	overhead_cost	number		NULL,
	use_yn	char(1)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: emp
-- 설명  : 사용자/사원 마스터. 로그인 계정과 권한(role)을 관리한다.
-- ============================================================
CREATE TABLE emp (
	emp_id	number		NOT NULL,
	empno	varchar2(30)		NOT NULL,
	emp_pw	varchar2(100)		NULL,
	ename	varchar2(50)		NULL,
	dept	varchar2(50)		NULL,
	job	varchar2(50)		NULL,
	hire_date	date		NULL,
	emp_tel	varchar2(30)		NULL,
	email	varchar2(100)		NULL,
	status	varchar2(30)		NULL,
	role	varchar2(30)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	AUTO_LOGIN_TOKEN VARCHAR2(200) NULL
);


-- ============================================================
-- 테이블: material_inout
-- 설명  : 원자재/부자재 입출고 이력. 원자재 LOT와 작업지시를 연결한다.
-- ============================================================
CREATE TABLE material_inout (
	inout_id	number		NULL,
	emp_id	number		NOT NULL,
	inout_type	varchar2(30)		NULL,
	material_lot	varchar2(30)		NULL,
	inout_qty	number		NULL,
	inout_date	date		NULL,
	remark	varchar2(500)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	use_yn	char(1)		NULL,
	status	varchar2(30)		NULL,
	order_id	number		NULL,
	item_id	number		NOT NULL
);


-- ============================================================
-- 테이블: bom
-- 설명  : 완제품별 BOM 마스터. 어떤 완제품의 BOM인지 관리한다.
-- ============================================================
CREATE TABLE bom (
	bom_id	number		NULL,
	bom_code	varchar2(80)		NOT NULL,
	version	number		NULL,
	use_yn	char(1)		NULL,
	remark	varchar2(500)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	item_id	number		NOT NULL
);


-- ============================================================
-- 테이블: item
-- 설명  : 품목 마스터. 완제품, 원자재, 부자재를 모두 관리한다.
-- ============================================================
CREATE TABLE item (
	item_id	number		NOT NULL,
	supplier_id	number		NULL,
	client_id	number		NULL,
	item_code	varchar2(60)		NOT NULL,
	item_name	varchar2(150)		NULL,
	item_type	varchar2(30)		NULL,
	safety_stock	number		NULL,
	item_unit	varchar2(20)		NULL,
	remark	varchar2(500)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	use_yn	char(1)		NULL
);


-- ============================================================
-- 테이블: board_comment
-- 설명  : 게시판 댓글. parent_comment_id 자기참조로 대댓글을 표현한다.
-- ============================================================
CREATE TABLE board_comment (
	comment_id	number		NOT NULL,
	board_id	number		NOT NULL,
	parent_comment_id	number		NULL,
	emp_id	number		NOT NULL,
	content	varchar2(1000)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	status	varchar2(30)		NULL,
	use_yn	char(1)		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: bom_detail
-- 설명  : BOM 상세. 완제품 생산에 투입되는 원자재/부자재와 소요량을 관리한다.
-- ============================================================
CREATE TABLE bom_detail (
	bom_detail_id	number		NOT NULL,
	bom_id	number		NULL,
	qty	number		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL,
	item_id	number		NOT NULL
);


-- ============================================================
-- 테이블: equipment_maintenance
-- 설명  : 설비 정비 이력. 정비일자, 유형, 내용, 시간을 관리한다.
-- ============================================================
CREATE TABLE equipment_maintenance (
	equip_main_id	number		NULL,
	equip_id	number		NULL,
	emp_id	number		NOT NULL,
	equip_main_date	date		NULL,
	equip_main_type	varchar2(30)		NULL,
	equip_main_content	varchar2(1000)		NULL,
	equip_main_time	number		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: attached_file
-- 설명  : 공지사항/게시글 첨부파일 정보. notice_id 또는 board_id 중 하나를 사용한다.
-- ============================================================
CREATE TABLE attached_file (
	file_id	number		NOT NULL,
	notice_id	number		NULL,
	board_id	number		NULL,
	title	varchar2(200)		NULL,
	saved_title	varchar2(255)		NULL,
	file_path	varchar2(500)		NULL,
	file_size	number		NULL,
	created_date	date		NULL,
	updated_date	date		NULL
);


-- ============================================================
-- 테이블: equipment_trouble
-- 설명  : 설비 고장 및 조치 이력. 고장내용과 조치결과를 관리한다.
-- ============================================================
CREATE TABLE equipment_trouble (
	trouble_id	number		NULL,
	equip_id	number		NULL,
	emp_id	number		NOT NULL,
	trouble_content	varchar2(1000)		NULL,
	trouble_date	date		NULL,
	trouble_resolve	varchar2(1000)		NULL,
	resolve_date	date		NULL,
	remark	varchar2(500)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL
);


-- ============================================================
-- 테이블: board
-- 설명  : 일반 게시판. 팀/현장 게시글을 관리한다.
-- ============================================================
CREATE TABLE board (
	board_id	number		NOT NULL,
	title	varchar2(200)		NULL,
	content	clob		NULL,
	emp_id	number		NOT NULL,
	view_count	number		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	status	varchar2(30)		NULL,
	remark	varchar2(500)		NULL,
	use_yn	char(1)		NULL
);


-- ============================================================
-- 테이블: inspection
-- 설명  : 검사 이력. 생산실적 기준 검사수량, 양품수량, 판정결과를 관리한다.
-- ============================================================
CREATE TABLE inspection (
	insp_id	number		NOT NULL,
	emp_id	number		NOT NULL,
	prod_id	number		NULL,
	insp_type	varchar2(30)		NULL,
	insp_date	date		NULL,
	insp_status	varchar2(30)		NULL,
	result	varchar2(30)		NULL,
	inspection_qty	number		NULL,
	good_qty	number		NULL,
	remark	varchar2(4000)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL
);


-- ============================================================
-- 테이블: defect
-- 설명  : 불량코드 마스터. 치수불량, 오염, 접착불량 등 불량유형을 관리한다.
-- ============================================================
CREATE TABLE defect (
	defect_id	number		NOT NULL,
	defect_code	varchar2(50)		NOT NULL,
	defect_type	varchar2(30)		NULL,
	defect_name	varchar2(100)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: defect_list
-- 설명  : 검사별 불량 상세 이력. 검사 1건에 여러 불량유형을 연결한다.
-- ============================================================
CREATE TABLE defect_list (
	defect_list_id	number		NOT NULL,
	defect_id	number		NOT NULL,
	insp_id	number		NOT NULL,
	defect_date	date		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL,
	defect_qty	number		NULL
);


-- ============================================================
-- 테이블: production_plan
-- 설명  : 생산계획. 품목, 계획수량, 계획일자, 납기일을 관리한다.
-- ============================================================
CREATE TABLE production_plan (
	prod_plan_id	number		NULL,
	prod_plan_qty	number		NULL,
	prod_plan_date	date		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL,
	item_id	number		NOT NULL,
	due_date	date		NULL
);


-- ============================================================
-- 테이블: actual_cost_daily
-- 설명  : 일자별 품목별 실제 단가. 일일생산원가와 원가편차율 계산에 사용한다.
-- ============================================================
CREATE TABLE actual_cost_daily (
	actual_cost_id	number		NOT NULL,
	item_id	number		NOT NULL,
	cost_date	date		NOT NULL,
	unit_cost	number		NULL,
	cost_unit	varchar2(20)		NULL,
	material_cost	number		NULL,
	labor_cost	number		NULL,
	overhead_cost	number		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: process_detail
-- 설명  : 공정 상세. 공정 사진과 상세 설명을 관리한다.
-- ============================================================
CREATE TABLE process_detail (
	proc_id	number		NULL,
	proc_id2	number		NULL,
	proc_picture	varchar2(500)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL,
	proc_content	varchar2(1000)		NULL
);


-- ============================================================
-- 테이블: line
-- 설명  : 생산라인 마스터. 1~4라인과 현재 라인상태를 관리한다.
-- ============================================================
CREATE TABLE line (
	line_id	number		NULL,
	line_code	varchar2(50)		NOT NULL,
	line_name	varchar2(100)		NULL,
	line_status	varchar2(30)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: inventory
-- 설명  : 품목별/보관위치별 현재고. LOT별 현재고는 관리하지 않는다.
-- ============================================================
CREATE TABLE inventory (
	inventory_id	number		NULL,
	inventory_stock	number		NULL,
	remark	varchar2(500)		NULL,
	stock_location	varchar2(100)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	item_id	number		NOT NULL
);


-- ============================================================
-- 테이블: process
-- 설명  : 공정 마스터. 품목별 공정과 연결 설비를 관리한다.
-- ============================================================
CREATE TABLE process (
	proc_id	number		NULL,
	item_id	number		NOT NULL,
	equip_id	number		NULL,
	proc_code	varchar2(50)		NULL,
	proc_name	varchar2(100)		NULL,
	proc_content	varchar2(1000)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: client
-- 설명  : 거래처 마스터. 공급업체, 고객사, 기타 협력업체를 관리한다.
-- ============================================================
CREATE TABLE client (
	client_id	number		NULL,
	client_code	varchar2(50)		NOT NULL,
	client_name	varchar2(100)		NULL,
	client_type	varchar2(30)		NULL,
	client_adress	varchar2(300)		NULL,
	client_man	varchar2(50)		NULL,
	client_tel	varchar2(30)		NULL,
	client_dept	varchar2(50)		NULL,
	remark	varchar2(500)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	use_yn	char(1)		NULL
);


-- ============================================================
-- 테이블: product_inout
-- 설명  : 완제품 입출고 이력. 작업지시와 완제품 품목을 연결한다.
-- ============================================================
CREATE TABLE product_inout (
	inout_id	number		NULL,
	emp_id	number		NOT NULL,
	inout_type	varchar2(30)		NULL,
	inout_qty	number		NULL,
	inout_date	date		NULL,
	remark	varchar2(500)		NULL,
	use_yn	char(1)		NULL,
	status	varchar2(30)		NULL,
	order_id	number		NULL,
	item_id	number		NOT NULL
);


-- ============================================================
-- 테이블: notice
-- 설명  : 공지사항. 현장/관리 공지와 조회수를 관리한다.
-- ============================================================
CREATE TABLE notice (
	notice_id	number		NOT NULL,
	title	varchar2(200)		NULL,
	content	clob		NULL,
	emp_id	number		NOT NULL,
	view_count	number		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	status	varchar2(30)		NULL,
	use_yn	char(1)		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: work_order
-- 설명  : 작업지시. 생산계획과 라인, 완제품 LOT를 연결한다.
-- ============================================================
CREATE TABLE work_order (
	order_id	number		NULL,
	prod_plan_id	number		NULL,
	line_id	number		NULL,
	emp_id	number		NOT NULL,
	product_lot	varchar2(30)		NOT NULL,
	order_qty	number		NULL,
	order_date	date		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 테이블: production
-- 설명  : 생산실적. 작업지시별 생산수량, 손실수량, 실적일자를 관리한다.
-- ============================================================
CREATE TABLE production (
	prod_id	number		NULL,
	emp_id	number		NOT NULL,
	order_id	number		NULL,
	prod_date	date		NULL,
	order_qty	number		NULL,
	prod_qty	number		NULL,
	loss_qty	number		NULL,
	prod_status	varchar2(30)		NULL,
	created_date	date		NULL,
	updated_date	date		NULL,
	remark	varchar2(500)		NULL
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE equipment ADD CONSTRAINT PK_EQUIP PRIMARY KEY (
	equip_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE equipment_history ADD CONSTRAINT PK_EQ_HIST PRIMARY KEY (
	history_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE standard_cost ADD CONSTRAINT PK_STD_COST PRIMARY KEY (
	standard_cost_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE emp ADD CONSTRAINT PK_EMP PRIMARY KEY (
	emp_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE material_inout ADD CONSTRAINT PK_MAT_IO PRIMARY KEY (
	inout_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE bom ADD CONSTRAINT PK_BOM PRIMARY KEY (
	bom_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE item ADD CONSTRAINT PK_ITEM PRIMARY KEY (
	item_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE board_comment ADD CONSTRAINT PK_CMT PRIMARY KEY (
	comment_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE bom_detail ADD CONSTRAINT PK_BOM_DTL PRIMARY KEY (
	bom_detail_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE equipment_maintenance ADD CONSTRAINT PK_EQ_MAINT PRIMARY KEY (
	equip_main_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE attached_file ADD CONSTRAINT PK_FILE PRIMARY KEY (
	file_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE equipment_trouble ADD CONSTRAINT PK_EQ_TRBL PRIMARY KEY (
	trouble_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE board ADD CONSTRAINT PK_BOARD PRIMARY KEY (
	board_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE inspection ADD CONSTRAINT PK_INSP PRIMARY KEY (
	insp_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE defect ADD CONSTRAINT PK_DEF PRIMARY KEY (
	defect_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE defect_list ADD CONSTRAINT PK_DEF_LIST PRIMARY KEY (
	defect_list_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE production_plan ADD CONSTRAINT PK_PP PRIMARY KEY (
	prod_plan_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE actual_cost_daily ADD CONSTRAINT PK_ACT_COST PRIMARY KEY (
	actual_cost_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE process_detail ADD CONSTRAINT PK_PROC_DTL PRIMARY KEY (
	proc_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE line ADD CONSTRAINT PK_LINE PRIMARY KEY (
	line_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE inventory ADD CONSTRAINT PK_INV PRIMARY KEY (
	inventory_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE process ADD CONSTRAINT PK_PROC PRIMARY KEY (
	proc_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE client ADD CONSTRAINT PK_CLNT PRIMARY KEY (
	client_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE product_inout ADD CONSTRAINT PK_PRD_IO PRIMARY KEY (
	inout_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE notice ADD CONSTRAINT PK_NTC PRIMARY KEY (
	notice_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE work_order ADD CONSTRAINT PK_WO PRIMARY KEY (
	order_id
);


-- ============================================================
-- 기본키(PK) 제약조건
-- ============================================================
ALTER TABLE production ADD CONSTRAINT PK_PROD PRIMARY KEY (
	prod_id
);




-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE equipment ADD CONSTRAINT UK_EQ_CODE UNIQUE (
	equip_code
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE emp ADD CONSTRAINT UK_EMP_NO UNIQUE (
	empno
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE item ADD CONSTRAINT UK_ITEM_CODE UNIQUE (
	item_code
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE bom ADD CONSTRAINT UK_BOM_CODE UNIQUE (
	bom_code
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE defect ADD CONSTRAINT UK_DEF_CODE UNIQUE (
	defect_code
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE line ADD CONSTRAINT UK_LINE_CODE UNIQUE (
	line_code
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE client ADD CONSTRAINT UK_CLNT_CODE UNIQUE (
	client_code
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE work_order ADD CONSTRAINT UK_WO_LOT UNIQUE (
	product_lot
);


-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE equipment_history ADD CONSTRAINT UK_EQ_HIST_DAY UNIQUE (
	equip_id, operation_date
);

-- ============================================================
-- 유니크(UNIQUE) 제약조건
-- ============================================================
ALTER TABLE actual_cost_daily ADD CONSTRAINT UK_ACD_ITEM_DT UNIQUE (
	item_id, cost_date
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment ADD CONSTRAINT FK_EQ_LINE FOREIGN KEY (
	line_id
)
REFERENCES line (
	line_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment ADD CONSTRAINT FK_EQ_CLIENT FOREIGN KEY (
	client_id
)
REFERENCES client (
	client_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment_history ADD CONSTRAINT FK_EQH_EQ FOREIGN KEY (
	equip_id
)
REFERENCES equipment (
	equip_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE standard_cost ADD CONSTRAINT FK_STDC_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE material_inout ADD CONSTRAINT FK_MIO_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE material_inout ADD CONSTRAINT FK_MIO_WO FOREIGN KEY (
	order_id
)
REFERENCES work_order (
	order_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE material_inout ADD CONSTRAINT FK_MIO_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE bom ADD CONSTRAINT FK_BOM_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE item ADD CONSTRAINT FK_ITEM_SUP FOREIGN KEY (
	supplier_id
)
REFERENCES client (
	client_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE item ADD CONSTRAINT FK_ITEM_CUST FOREIGN KEY (
	client_id
)
REFERENCES client (
	client_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE board_comment ADD CONSTRAINT FK_CMT_BOARD FOREIGN KEY (
	board_id
)
REFERENCES board (
	board_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE board_comment ADD CONSTRAINT FK_CMT_PARENT FOREIGN KEY (
	parent_comment_id
)
REFERENCES board_comment (
	comment_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE board_comment ADD CONSTRAINT FK_CMT_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE bom_detail ADD CONSTRAINT FK_BD_BOM FOREIGN KEY (
	bom_id
)
REFERENCES bom (
	bom_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE bom_detail ADD CONSTRAINT FK_BD_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment_maintenance ADD CONSTRAINT FK_EQM_EQ FOREIGN KEY (
	equip_id
)
REFERENCES equipment (
	equip_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment_maintenance ADD CONSTRAINT FK_EQM_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE attached_file ADD CONSTRAINT FK_FILE_NTC FOREIGN KEY (
	notice_id
)
REFERENCES notice (
	notice_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE attached_file ADD CONSTRAINT FK_FILE_BOARD FOREIGN KEY (
	board_id
)
REFERENCES board (
	board_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment_trouble ADD CONSTRAINT FK_EQT_EQ FOREIGN KEY (
	equip_id
)
REFERENCES equipment (
	equip_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE equipment_trouble ADD CONSTRAINT FK_EQT_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE board ADD CONSTRAINT FK_BOARD_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE inspection ADD CONSTRAINT FK_INSP_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE inspection ADD CONSTRAINT FK_INSP_PROD FOREIGN KEY (
	prod_id
)
REFERENCES production (
	prod_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE defect_list ADD CONSTRAINT FK_DL_DEF FOREIGN KEY (
	defect_id
)
REFERENCES defect (
	defect_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE defect_list ADD CONSTRAINT FK_DL_INSP FOREIGN KEY (
	insp_id
)
REFERENCES inspection (
	insp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE production_plan ADD CONSTRAINT FK_PP_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE actual_cost_daily ADD CONSTRAINT FK_ACD_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE process_detail ADD CONSTRAINT FK_PD_PROC FOREIGN KEY (
	proc_id2
)
REFERENCES process (
	proc_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE inventory ADD CONSTRAINT FK_INV_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE process ADD CONSTRAINT FK_PROC_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE process ADD CONSTRAINT FK_PROC_EQ FOREIGN KEY (
	equip_id
)
REFERENCES equipment (
	equip_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE product_inout ADD CONSTRAINT FK_PIO_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE product_inout ADD CONSTRAINT FK_PIO_WO FOREIGN KEY (
	order_id
)
REFERENCES work_order (
	order_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE product_inout ADD CONSTRAINT FK_PIO_ITEM FOREIGN KEY (
	item_id
)
REFERENCES item (
	item_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE notice ADD CONSTRAINT FK_NTC_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE work_order ADD CONSTRAINT FK_WO_PP FOREIGN KEY (
	prod_plan_id
)
REFERENCES production_plan (
	prod_plan_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE work_order ADD CONSTRAINT FK_WO_LINE FOREIGN KEY (
	line_id
)
REFERENCES line (
	line_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE work_order ADD CONSTRAINT FK_WO_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE production ADD CONSTRAINT FK_PROD_EMP FOREIGN KEY (
	emp_id
)
REFERENCES emp (
	emp_id
);


-- ============================================================
-- 외래키(FK) 제약조건
-- ============================================================
ALTER TABLE production ADD CONSTRAINT FK_PROD_WO FOREIGN KEY (
	order_id
)
REFERENCES work_order (
	order_id
);

COMMIT;
