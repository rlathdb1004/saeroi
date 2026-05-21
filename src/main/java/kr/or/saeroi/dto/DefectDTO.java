package kr.or.saeroi.dto;

public class DefectDTO {

	private int defect_list_id;
	private int defect_id;
	private int insp_id;
	private String defect_code;
	private String defect_date;
	private String item_name;
	private String product_lot;
	private String defect_name;
	private String ename;
	private int defect_qty;
	private String remark;

	public int getDefect_list_id() {
		return defect_list_id;
	}

	public void setDefect_list_id(int defect_list_id) {
		this.defect_list_id = defect_list_id;
	}

	public int getDefect_id() {
		return defect_id;
	}

	public void setDefect_id(int defect_id) {
		this.defect_id = defect_id;
	}

	public int getInsp_id() {
		return insp_id;
	}

	public void setInsp_id(int insp_id) {
		this.insp_id = insp_id;
	}

	public String getDefect_code() {
		return defect_code;
	}

	public void setDefect_code(String defect_code) {
		this.defect_code = defect_code;
	}

	public String getDefect_date() {
		return defect_date;
	}

	public void setDefect_date(String defect_date) {
		this.defect_date = defect_date;
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

	public String getDefect_name() {
		return defect_name;
	}

	public void setDefect_name(String defect_name) {
		this.defect_name = defect_name;
	}

	public String getEname() {
		return ename;
	}

	public void setEname(String ename) {
		this.ename = ename;
	}

	public int getDefect_qty() {
		return defect_qty;
	}

	public void setDefect_qty(int defect_qty) {
		this.defect_qty = defect_qty;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	@Override
	public String toString() {
		return "DefectDTO [defect_list_id=" + defect_list_id + ", defect_id=" + defect_id + ", insp_id=" + insp_id
				+ ", defect_code=" + defect_code + ", defect_date=" + defect_date + ", item_name=" + item_name
				+ ", product_lot=" + product_lot + ", defect_name=" + defect_name + ", ename=" + ename + ", defect_qty="
				+ defect_qty + ", remark=" + remark + "]";
	}
}