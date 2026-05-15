CREATE TABLE "equipment" (
	"equip_id"	number		NULL,
	"line_id"	number		NULL,
	"equip_code"	varchar2(50)		NOT NULL,
	"equip_name"	varchar2(100)		NULL,
	"equip_status"	varchar2(30)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"use_yn"	char(1)		NULL,
	"remark"	varchar2(500)		NULL,
	"client_id"	number		NULL,
	"equip_price"	number		NULL,
	"buy_date"	date		NULL,
	"equip_loc"	varchar2(100)		NULL
);

CREATE TABLE "equipment_history" (
	"history_id"	number		NOT NULL,
	"equip_id"	number		NOT NULL,
	"operation_date"	date		NOT NULL,
	"time_start"	date		NULL,
	"time_end"	date		NULL,
	"plan_time_min"	number		NULL,
	"runtime_min"	number		NULL,
	"downtime_min"	number		NULL,
	"down_reason"	varchar2(100)		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "standard_cost" (
	"standard_cost_id"	number		NOT NULL,
	"item_id"	number		NOT NULL,
	"unit_cost"	number		NULL,
	"cost_unit"	varchar2(20)		NULL,
	"material_cost"	number		NULL,
	"labor_cost"	number		NULL,
	"overhead_cost"	number		NULL,
	"use_yn"	char(1)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "emp" (
	"emp_id"	number		NOT NULL,
	"empno"	varchar2(30)		NOT NULL,
	"emp_pw"	varchar2(100)		NULL,
	"ename"	varchar2(50)		NULL,
	"dept"	varchar2(50)		NULL,
	"job"	varchar2(50)		NULL,
	"hire_date"	date		NULL,
	"emp_tel"	varchar2(30)		NULL,
	"email"	varchar2(100)		NULL,
	"status"	varchar2(30)		NULL,
	"role"	varchar2(30)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL
);

CREATE TABLE "material_inout" (
	"inout_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"inout_type"	varchar2(30)		NULL,
	"material_lot"	varchar2(30)		NULL,
	"inout_qty"	number		NULL,
	"inout_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"use_yn"	char(1)		NULL,
	"status"	varchar2(30)		NULL,
	"order_id"	number		NULL,
	"item_id"	number		NOT NULL
);

CREATE TABLE "bom" (
	"bom_id"	number		NULL,
	"bom_code"	varchar2(80)		NOT NULL,
	"version"	number		NULL,
	"use_yn"	char(1)		NULL,
	"remark"	varchar2(500)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"item_id"	number		NOT NULL
);

CREATE TABLE "item" (
	"item_id"	number		NOT NULL,
	"supplier_id"	number		NULL,
	"client_id"	number		NULL,
	"item_code"	varchar2(60)		NOT NULL,
	"item_name"	varchar2(150)		NULL,
	"item_type"	varchar2(30)		NULL,
	"safety_stock"	number		NULL,
	"item_unit"	varchar2(20)		NULL,
	"remark"	varchar2(500)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"use_yn"	char(1)		NULL
);

CREATE TABLE "comment" (
	"comment_id"	number		NOT NULL,
	"board_id"	number		NOT NULL,
	"parent_comment_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"content"	varchar2(1000)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"status"	varchar2(30)		NULL,
	"use_yn"	char(1)		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "bom_detail" (
	"bom_detail_id"	number		NOT NULL,
	"bom_id"	number		NULL,
	"qty"	number		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"item_id"	number		NOT NULL
);

CREATE TABLE "equipment_maintenance" (
	"equip_main_id"	number		NULL,
	"equip_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"equip_main_date"	date		NULL,
	"equip_main_type"	varchar2(30)		NULL,
	"equip_main_content"	varchar2(1000)		NULL,
	"equip_main_time"	number		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "file" (
	"file_id"	number		NOT NULL,
	"notice_id"	number		NULL,
	"board_id"	number		NULL,
	"title"	varchar2(200)		NULL,
	"saved_title"	varchar2(255)		NULL,
	"file_path"	varchar2(500)		NULL,
	"file_size"	number		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL
);

CREATE TABLE "equipment_trouble" (
	"trouble_id"	number		NULL,
	"equip_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"trouble_content"	varchar2(1000)		NULL,
	"trouble_date"	date		NULL,
	"trouble_resolve"	varchar2(1000)		NULL,
	"resolve_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL
);

CREATE TABLE "board" (
	"board_id"	number		NOT NULL,
	"title"	varchar2(200)		NULL,
	"content"	clob		NULL,
	"emp_id"	number		NOT NULL,
	"view_count"	number		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"status"	varchar2(30)		NULL,
	"remark"	varchar2(500)		NULL,
	"use_yn"	char(1)		NULL
);

CREATE TABLE "inspection" (
	"insp_id"	number		NOT NULL,
	"emp_id"	number		NOT NULL,
	"prod_id"	number		NULL,
	"insp_type"	varchar2(30)		NULL,
	"insp_date"	date		NULL,
	"insp_status"	varchar2(30)		NULL,
	"result"	varchar2(30)		NULL,
	"inspection_qty"	number		NULL,
	"good_qty"	number		NULL,
	"remark"	varchar2(4000)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL
);

CREATE TABLE "defect" (
	"defect_id"	number		NOT NULL,
	"defect_code"	varchar2(50)		NOT NULL,
	"defect_type"	varchar2(30)		NULL,
	"defect_name"	varchar2(100)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "defect_list" (
	"defect_list_id"	number		NOT NULL,
	"defect_id"	number		NOT NULL,
	"insp_id"	number		NOT NULL,
	"defect_date"	date		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"defect_qty"	number		NULL
);

CREATE TABLE "production_plan" (
	"prod_plan_id"	number		NULL,
	"prod_plan_qty"	number		NULL,
	"prod_plan_date"	date		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"item_id"	number		NOT NULL,
	"due_date"	date		NULL
);

CREATE TABLE "actual_cost_daily" (
	"actual_cost_id"	number		NOT NULL,
	"item_id"	number		NOT NULL,
	"cost_date"	date		NOT NULL,
	"unit_cost"	number		NULL,
	"cost_unit"	varchar2(20)		NULL,
	"material_cost"	number		NULL,
	"labor_cost"	number		NULL,
	"overhead_cost"	number		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "process_detail" (
	"proc_id"	number		NULL,
	"proc_id2"	number		NULL,
	"proc_picture"	varchar2(500)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"proc_content"	varchar2(1000)		NULL
);

CREATE TABLE "line" (
	"line_id"	number		NULL,
	"line_code"	varchar2(50)		NOT NULL,
	"line_name"	varchar2(100)		NULL,
	"line_status"	varchar2(30)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "inventory" (
	"inventory_id"	number		NULL,
	"inventory_stock"	number		NULL,
	"remark"	varchar2(500)		NULL,
	"stock_location"	varchar2(100)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"item_id"	number		NOT NULL
);

CREATE TABLE "process" (
	"proc_id"	number		NULL,
	"item_id"	number		NOT NULL,
	"equip_id"	number		NULL,
	"proc_code"	varchar2(50)		NULL,
	"proc_name"	varchar2(100)		NULL,
	"proc_content"	varchar2(1000)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "client" (
	"client_id"	number		NULL,
	"client_code"	varchar2(50)		NOT NULL,
	"client_name"	varchar2(100)		NULL,
	"client_type"	varchar2(30)		NULL,
	"client_adress"	varchar2(300)		NULL,
	"client_man"	varchar2(50)		NULL,
	"client_tel"	varchar2(30)		NULL,
	"client_dept"	varchar2(50)		NULL,
	"remark"	varchar2(500)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"use_yn"	char(1)		NULL
);

CREATE TABLE "product_inout" (
	"inout_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"inout_type"	varchar2(30)		NULL,
	"inout_qty"	number		NULL,
	"inout_date"	date		NULL,
	"remark"	varchar2(500)		NULL,
	"use_yn"	char(1)		NULL,
	"status"	varchar2(30)		NULL,
	"order_id"	number		NULL,
	"item_id"	number		NOT NULL
);

CREATE TABLE "notice" (
	"notice_id"	number		NOT NULL,
	"title"	varchar2(200)		NULL,
	"content"	clob		NULL,
	"emp_id"	number		NOT NULL,
	"view_count"	number		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"status"	varchar2(30)		NULL,
	"use_yn"	char(1)		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "work_order" (
	"order_id"	number		NULL,
	"prod_plan_id"	number		NULL,
	"line_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"product_lot"	varchar2(30)		NOT NULL,
	"order_qty"	number		NULL,
	"order_date"	date		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

CREATE TABLE "production" (
	"prod_id"	number		NULL,
	"emp_id"	number		NOT NULL,
	"order_id"	number		NULL,
	"prod_date"	date		NULL,
	"order_qty"	number		NULL,
	"prod_qty"	number		NULL,
	"loss_qty"	number		NULL,
	"prod_status"	varchar2(30)		NULL,
	"created_date"	date		NULL,
	"updated_date"	date		NULL,
	"remark"	varchar2(500)		NULL
);

ALTER TABLE "equipment" ADD CONSTRAINT "PK_EQUIPMENT" PRIMARY KEY (
	"equip_id"
);

ALTER TABLE "equipment_history" ADD CONSTRAINT "PK_EQUIPMENT_HISTORY" PRIMARY KEY (
	"history_id"
);

ALTER TABLE "standard_cost" ADD CONSTRAINT "PK_STANDARD_COST" PRIMARY KEY (
	"standard_cost_id"
);

ALTER TABLE "emp" ADD CONSTRAINT "PK_EMP" PRIMARY KEY (
	"emp_id"
);

ALTER TABLE "material_inout" ADD CONSTRAINT "PK_MATERIAL_INOUT" PRIMARY KEY (
	"inout_id"
);

ALTER TABLE "bom" ADD CONSTRAINT "PK_BOM" PRIMARY KEY (
	"bom_id"
);

ALTER TABLE "item" ADD CONSTRAINT "PK_ITEM" PRIMARY KEY (
	"item_id"
);

ALTER TABLE "comment" ADD CONSTRAINT "PK_COMMENT" PRIMARY KEY (
	"comment_id"
);

ALTER TABLE "bom_detail" ADD CONSTRAINT "PK_BOM_DETAIL" PRIMARY KEY (
	"bom_detail_id"
);

ALTER TABLE "equipment_maintenance" ADD CONSTRAINT "PK_EQUIPMENT_MAINTENANCE" PRIMARY KEY (
	"equip_main_id"
);

ALTER TABLE "file" ADD CONSTRAINT "PK_FILE" PRIMARY KEY (
	"file_id"
);

ALTER TABLE "equipment_trouble" ADD CONSTRAINT "PK_EQUIPMENT_TROUBLE" PRIMARY KEY (
	"trouble_id"
);

ALTER TABLE "board" ADD CONSTRAINT "PK_BOARD" PRIMARY KEY (
	"board_id"
);

ALTER TABLE "inspection" ADD CONSTRAINT "PK_INSPECTION" PRIMARY KEY (
	"insp_id"
);

ALTER TABLE "defect" ADD CONSTRAINT "PK_DEFECT" PRIMARY KEY (
	"defect_id"
);

ALTER TABLE "defect_list" ADD CONSTRAINT "PK_DEFECT_LIST" PRIMARY KEY (
	"defect_list_id"
);

ALTER TABLE "production_plan" ADD CONSTRAINT "PK_PRODUCTION_PLAN" PRIMARY KEY (
	"prod_plan_id"
);

ALTER TABLE "actual_cost_daily" ADD CONSTRAINT "PK_ACTUAL_COST_DAILY" PRIMARY KEY (
	"actual_cost_id"
);

ALTER TABLE "process_detail" ADD CONSTRAINT "PK_PROCESS_DETAIL" PRIMARY KEY (
	"proc_id"
);

ALTER TABLE "line" ADD CONSTRAINT "PK_LINE" PRIMARY KEY (
	"line_id"
);

ALTER TABLE "inventory" ADD CONSTRAINT "PK_INVENTORY" PRIMARY KEY (
	"inventory_id"
);

ALTER TABLE "process" ADD CONSTRAINT "PK_PROCESS" PRIMARY KEY (
	"proc_id"
);

ALTER TABLE "client" ADD CONSTRAINT "PK_CLIENT" PRIMARY KEY (
	"client_id"
);

ALTER TABLE "product_inout" ADD CONSTRAINT "PK_PRODUCT_INOUT" PRIMARY KEY (
	"inout_id"
);

ALTER TABLE "notice" ADD CONSTRAINT "PK_NOTICE" PRIMARY KEY (
	"notice_id"
);

ALTER TABLE "work_order" ADD CONSTRAINT "PK_WORK_ORDER" PRIMARY KEY (
	"order_id"
);

ALTER TABLE "production" ADD CONSTRAINT "PK_PRODUCTION" PRIMARY KEY (
	"prod_id"
);



ALTER TABLE "equipment" ADD CONSTRAINT "UK_EQUIPMENT_CODE" UNIQUE (
	"equip_code"
);

ALTER TABLE "emp" ADD CONSTRAINT "UK_EMP_EMPNO" UNIQUE (
	"empno"
);

ALTER TABLE "item" ADD CONSTRAINT "UK_ITEM_CODE" UNIQUE (
	"item_code"
);

ALTER TABLE "bom" ADD CONSTRAINT "UK_BOM_CODE" UNIQUE (
	"bom_code"
);

ALTER TABLE "defect" ADD CONSTRAINT "UK_DEFECT_CODE" UNIQUE (
	"defect_code"
);

ALTER TABLE "line" ADD CONSTRAINT "UK_LINE_CODE" UNIQUE (
	"line_code"
);

ALTER TABLE "client" ADD CONSTRAINT "UK_CLIENT_CODE" UNIQUE (
	"client_code"
);

ALTER TABLE "work_order" ADD CONSTRAINT "UK_WORK_ORDER_PRODUCT_LOT" UNIQUE (
	"product_lot"
);

ALTER TABLE "equipment_history" ADD CONSTRAINT "UK_EQUIP_HISTORY_DAY" UNIQUE (
	"equip_id", "operation_date"
);
ALTER TABLE "actual_cost_daily" ADD CONSTRAINT "UK_ACTUAL_COST_DAILY_ITEM_DATE" UNIQUE (
	"item_id", "cost_date"
);

ALTER TABLE "equipment" ADD CONSTRAINT "FK_line_TO_equipment_1" FOREIGN KEY (
	"line_id"
)
REFERENCES "line" (
	"line_id"
);

ALTER TABLE "equipment" ADD CONSTRAINT "FK_client_TO_equipment_1" FOREIGN KEY (
	"client_id"
)
REFERENCES "client" (
	"client_id"
);

ALTER TABLE "equipment_history" ADD CONSTRAINT "FK_equipment_TO_equipment_history_1" FOREIGN KEY (
	"equip_id"
)
REFERENCES "equipment" (
	"equip_id"
);

ALTER TABLE "standard_cost" ADD CONSTRAINT "FK_item_TO_standard_cost_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "material_inout" ADD CONSTRAINT "FK_emp_TO_material_inout_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "material_inout" ADD CONSTRAINT "FK_work_order_TO_material_inout_1" FOREIGN KEY (
	"order_id"
)
REFERENCES "work_order" (
	"order_id"
);

ALTER TABLE "material_inout" ADD CONSTRAINT "FK_item_TO_material_inout_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "bom" ADD CONSTRAINT "FK_item_TO_bom_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "item" ADD CONSTRAINT "FK_client_TO_item_1" FOREIGN KEY (
	"supplier_id"
)
REFERENCES "client" (
	"client_id"
);

ALTER TABLE "item" ADD CONSTRAINT "FK_client_TO_item_2" FOREIGN KEY (
	"client_id"
)
REFERENCES "client" (
	"client_id"
);

ALTER TABLE "comment" ADD CONSTRAINT "FK_board_TO_comment_1" FOREIGN KEY (
	"board_id"
)
REFERENCES "board" (
	"board_id"
);

ALTER TABLE "comment" ADD CONSTRAINT "FK_comment_TO_comment_1" FOREIGN KEY (
	"parent_comment_id"
)
REFERENCES "comment" (
	"comment_id"
);

ALTER TABLE "comment" ADD CONSTRAINT "FK_emp_TO_comment_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "bom_detail" ADD CONSTRAINT "FK_bom_TO_bom_detail_1" FOREIGN KEY (
	"bom_id"
)
REFERENCES "bom" (
	"bom_id"
);

ALTER TABLE "bom_detail" ADD CONSTRAINT "FK_item_TO_bom_detail_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "equipment_maintenance" ADD CONSTRAINT "FK_equipment_TO_equipment_maintenance_1" FOREIGN KEY (
	"equip_id"
)
REFERENCES "equipment" (
	"equip_id"
);

ALTER TABLE "equipment_maintenance" ADD CONSTRAINT "FK_emp_TO_equipment_maintenance_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "file" ADD CONSTRAINT "FK_notice_TO_file_1" FOREIGN KEY (
	"notice_id"
)
REFERENCES "notice" (
	"notice_id"
);

ALTER TABLE "file" ADD CONSTRAINT "FK_board_TO_file_1" FOREIGN KEY (
	"board_id"
)
REFERENCES "board" (
	"board_id"
);

ALTER TABLE "equipment_trouble" ADD CONSTRAINT "FK_equipment_TO_equipment_trouble_1" FOREIGN KEY (
	"equip_id"
)
REFERENCES "equipment" (
	"equip_id"
);

ALTER TABLE "equipment_trouble" ADD CONSTRAINT "FK_emp_TO_equipment_trouble_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "board" ADD CONSTRAINT "FK_emp_TO_board_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "inspection" ADD CONSTRAINT "FK_emp_TO_inspection_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "inspection" ADD CONSTRAINT "FK_production_TO_inspection_1" FOREIGN KEY (
	"prod_id"
)
REFERENCES "production" (
	"prod_id"
);

ALTER TABLE "defect_list" ADD CONSTRAINT "FK_defect_TO_defect_list_1" FOREIGN KEY (
	"defect_id"
)
REFERENCES "defect" (
	"defect_id"
);

ALTER TABLE "defect_list" ADD CONSTRAINT "FK_inspection_TO_defect_list_1" FOREIGN KEY (
	"insp_id"
)
REFERENCES "inspection" (
	"insp_id"
);

ALTER TABLE "production_plan" ADD CONSTRAINT "FK_item_TO_production_plan_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "actual_cost_daily" ADD CONSTRAINT "FK_item_TO_actual_cost_daily_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "process_detail" ADD CONSTRAINT "FK_process_TO_process_detail_1" FOREIGN KEY (
	"proc_id2"
)
REFERENCES "process" (
	"proc_id"
);

ALTER TABLE "inventory" ADD CONSTRAINT "FK_item_TO_inventory_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "process" ADD CONSTRAINT "FK_item_TO_process_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "process" ADD CONSTRAINT "FK_equipment_TO_process_1" FOREIGN KEY (
	"equip_id"
)
REFERENCES "equipment" (
	"equip_id"
);

ALTER TABLE "product_inout" ADD CONSTRAINT "FK_emp_TO_product_inout_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "product_inout" ADD CONSTRAINT "FK_work_order_TO_product_inout_1" FOREIGN KEY (
	"order_id"
)
REFERENCES "work_order" (
	"order_id"
);

ALTER TABLE "product_inout" ADD CONSTRAINT "FK_item_TO_product_inout_1" FOREIGN KEY (
	"item_id"
)
REFERENCES "item" (
	"item_id"
);

ALTER TABLE "notice" ADD CONSTRAINT "FK_emp_TO_notice_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "work_order" ADD CONSTRAINT "FK_production_plan_TO_work_order_1" FOREIGN KEY (
	"prod_plan_id"
)
REFERENCES "production_plan" (
	"prod_plan_id"
);

ALTER TABLE "work_order" ADD CONSTRAINT "FK_line_TO_work_order_1" FOREIGN KEY (
	"line_id"
)
REFERENCES "line" (
	"line_id"
);

ALTER TABLE "work_order" ADD CONSTRAINT "FK_emp_TO_work_order_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "production" ADD CONSTRAINT "FK_emp_TO_production_1" FOREIGN KEY (
	"emp_id"
)
REFERENCES "emp" (
	"emp_id"
);

ALTER TABLE "production" ADD CONSTRAINT "FK_work_order_TO_production_1" FOREIGN KEY (
	"order_id"
)
REFERENCES "work_order" (
	"order_id"
);

