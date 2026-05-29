package kr.or.saeroi.dto;

public class InspectionDTO {
	//선언(테이블 컬럼명 그대로)
	private int insp_id;
	private String doc_no;
	private int doc_seq;
	private String insp_date;
	private String item_name;
	private String item_code;
	private String item_unit;
	private String product_lot;
	private String ename;
	private String dept;
	private String result;
	
	//검사 - 등록 시 필요 필드
	private int prod_id;
	private int emp_id;
	private String insp_type;
	private String insp_status;
	private int inspection_qty;
	private int good_qty;
	private String remark;
	private String created_date;
	private String updated_date;
	private String use_yn;
	
	// 생산실적/작업지시 연결 표시용
	private String prod_doc_no;
	private String prod_date;
	private int prod_qty;
	private int loss_qty;
	private String prod_status;
	private String work_order_doc_no;
	private int order_qty;
	private String order_date;
	
	public int getInsp_id() {
		return insp_id;
	}
	public void setInsp_id(int insp_id) {
		this.insp_id = insp_id;
	}
	public String getDoc_no() {
		return doc_no;
	}
	public void setDoc_no(String doc_no) {
		this.doc_no = doc_no;
	}
	public int getDoc_seq() {
		return doc_seq;
	}
	public void setDoc_seq(int doc_seq) {
		this.doc_seq = doc_seq;
	}
	public String getInsp_date() {
		return insp_date;
	}
	public void setInsp_date(String insp_date) {
		this.insp_date = insp_date;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public String getItem_code() {
		return item_code;
	}
	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}
	public String getItem_unit() {
		return item_unit;
	}
	public void setItem_unit(String item_unit) {
		this.item_unit = item_unit;
	}
	public String getProduct_lot() {
		return product_lot;
	}
	public void setProduct_lot(String product_lot) {
		this.product_lot = product_lot;
	}
	public String getEname() {
		return ename;
	}
	public void setEname(String ename) {
		this.ename = ename;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public int getProd_id() {
		return prod_id;
	}
	public void setProd_id(int prod_id) {
		this.prod_id = prod_id;
	}
	public int getEmp_id() {
		return emp_id;
	}
	public void setEmp_id(int emp_id) {
		this.emp_id = emp_id;
	}
	public String getInsp_type() {
		return insp_type;
	}
	public void setInsp_type(String insp_type) {
		this.insp_type = insp_type;
	}
	public String getInsp_status() {
		return insp_status;
	}
	public void setInsp_status(String insp_status) {
		this.insp_status = insp_status;
	}
	public int getInspection_qty() {
		return inspection_qty;
	}
	public void setInspection_qty(int inspection_qty) {
		this.inspection_qty = inspection_qty;
	}
	public int getGood_qty() {
		return good_qty;
	}
	public void setGood_qty(int good_qty) {
		this.good_qty = good_qty;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getCreated_date() {
		return created_date;
	}
	public void setCreated_date(String created_date) {
		this.created_date = created_date;
	}
	public String getUpdated_date() {
		return updated_date;
	}
	public void setUpdated_date(String updated_date) {
		this.updated_date = updated_date;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getProd_doc_no() {
		return prod_doc_no;
	}
	public void setProd_doc_no(String prod_doc_no) {
		this.prod_doc_no = prod_doc_no;
	}
	public String getProd_date() {
		return prod_date;
	}
	public void setProd_date(String prod_date) {
		this.prod_date = prod_date;
	}
	public int getProd_qty() {
		return prod_qty;
	}
	public void setProd_qty(int prod_qty) {
		this.prod_qty = prod_qty;
	}
	public int getLoss_qty() {
		return loss_qty;
	}
	public void setLoss_qty(int loss_qty) {
		this.loss_qty = loss_qty;
	}
	public String getProd_status() {
		return prod_status;
	}
	public void setProd_status(String prod_status) {
		this.prod_status = prod_status;
	}
	public String getWork_order_doc_no() {
		return work_order_doc_no;
	}
	public void setWork_order_doc_no(String work_order_doc_no) {
		this.work_order_doc_no = work_order_doc_no;
	}
	public int getOrder_qty() {
		return order_qty;
	}
	public void setOrder_qty(int order_qty) {
		this.order_qty = order_qty;
	}
	public String getOrder_date() {
		return order_date;
	}
	public void setOrder_date(String order_date) {
		this.order_date = order_date;
	}
	@Override
	public String toString() {
		return "InspectionDTO [insp_id=" + insp_id + ", doc_no=" + doc_no + ", doc_seq=" + doc_seq + ", insp_date="
				+ insp_date + ", item_name=" + item_name + ", item_code=" + item_code + ", item_unit=" + item_unit
				+ ", product_lot=" + product_lot + ", ename=" + ename + ", dept=" + dept + ", result=" + result
				+ ", prod_id=" + prod_id + ", emp_id=" + emp_id + ", insp_type=" + insp_type + ", insp_status="
				+ insp_status + ", inspection_qty=" + inspection_qty + ", good_qty=" + good_qty + ", remark=" + remark
				+ ", created_date=" + created_date + ", updated_date=" + updated_date + ", use_yn=" + use_yn
				+ ", prod_doc_no=" + prod_doc_no + ", prod_date=" + prod_date + ", prod_qty=" + prod_qty
				+ ", loss_qty=" + loss_qty + ", prod_status=" + prod_status + ", work_order_doc_no="
				+ work_order_doc_no + ", order_qty=" + order_qty + ", order_date=" + order_date + "]";
	}
	
	
	
	
}
