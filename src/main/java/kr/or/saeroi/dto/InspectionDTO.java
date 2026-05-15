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
	@Override
	public String toString() {
		return "InspectionDTO [insp_id=" + insp_id + ", doc_no=" + doc_no + ", insp_date=" + insp_date + ", item_name="
				+ item_name + ", product_lot=" + product_lot + ", ename=" + ename + ", result=" + result + "]";
	}
	
	
}
