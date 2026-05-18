package kr.or.saeroi.dto;

import java.sql.Date;

public class InspectionDTO {
	//선언(테이블 컬럼명 그대로)
	private int insp_id;
	private String doc_no;
	private Date insp_date;
	private String item_name;
	private String product_lot;
	private String ename;
	private String result;
	
	//검사 - 등록 시 필요 필드
	private int prod_id;
	private int emp_id;
	private String insp_type;
	private String insp_status;
	private int inspection_qty;
	private int good_qty;
	private String remark;
	
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
	public Date getInsp_date() {
		return insp_date;
	}
	public void setInsp_date(Date insp_date) {
		this.insp_date = insp_date;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
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
	@Override
	public String toString() {
		return "InspectionDTO [insp_id=" + insp_id + ", doc_no=" + doc_no + ", insp_date=" + insp_date + ", item_name="
				+ item_name + ", product_lot=" + product_lot + ", ename=" + ename + ", result=" + result + ", prod_id="
				+ prod_id + ", emp_id=" + emp_id + ", insp_type=" + insp_type + ", insp_status=" + insp_status
				+ ", inspection_qty=" + inspection_qty + ", good_qty=" + good_qty + ", remark=" + remark + "]";
	}
	
	
	
	
}
