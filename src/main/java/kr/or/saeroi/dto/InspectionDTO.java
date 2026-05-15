package kr.or.saeroi.dto;

import java.sql.Date;

public class InspectionDTO {
	//선언
	private int inspId;
	private Date inspDate;
	private String item_name;
	private String result;
	public int getInspId() {
		return inspId;
	}
	public void setInspId(int inspId) {
		this.inspId = inspId;
	}
	public Date getInspDate() {
		return inspDate;
	}
	public void setInspDate(Date inspDate) {
		this.inspDate = inspDate;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	@Override
	public String toString() {
		return "InspectionDTO [inspId=" + inspId + ", inspDate=" + inspDate + ", item_name=" + item_name + ", result="
				+ result + "]";
	}
	
	
}
