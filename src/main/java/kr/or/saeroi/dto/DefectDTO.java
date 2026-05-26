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
	private String defect_photo;
	private String ename;
	private int defect_qty;
	private String remark;

	private int defect_action_id;
	private String action_date;
	private String dept;
	private int action_emp_id;
	private String action_ename;
	private String action_status;
	private String action_content;

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

	public String getDefect_photo() {
		return defect_photo;
	}

	public void setDefect_photo(String defect_photo) {
		this.defect_photo = defect_photo;
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

	public int getDefect_action_id() {
		return defect_action_id;
	}

	public void setDefect_action_id(int defect_action_id) {
		this.defect_action_id = defect_action_id;
	}

	public String getAction_date() {
		return action_date;
	}

	public void setAction_date(String action_date) {
		this.action_date = action_date;
	}

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public int getAction_emp_id() {
		return action_emp_id;
	}

	public void setAction_emp_id(int action_emp_id) {
		this.action_emp_id = action_emp_id;
	}

	public String getAction_ename() {
		return action_ename;
	}

	public void setAction_ename(String action_ename) {
		this.action_ename = action_ename;
	}

	public String getAction_status() {
		return action_status;
	}

	public void setAction_status(String action_status) {
		this.action_status = action_status;
	}

	public String getAction_content() {
		return action_content;
	}

	public void setAction_content(String action_content) {
		this.action_content = action_content;
	}

	@Override
	public String toString() {
		return "DefectDTO [defect_list_id=" + defect_list_id + ", defect_id=" + defect_id + ", insp_id=" + insp_id
				+ ", defect_code=" + defect_code + ", defect_date=" + defect_date + ", item_name=" + item_name
				+ ", product_lot=" + product_lot + ", defect_name=" + defect_name + ", defect_photo=" + defect_photo
				+ ", ename=" + ename + ", defect_qty=" + defect_qty + ", remark=" + remark + ", defect_action_id="
				+ defect_action_id + ", action_date=" + action_date + ", dept=" + dept + ", action_emp_id="
				+ action_emp_id + ", action_ename=" + action_ename + ", action_status=" + action_status
				+ ", action_content=" + action_content + "]";
	}
}