package kr.or.saeroi.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EquipmentTroubleDTO {
	private int trouble_id;
	private int equip_id;
	private int emp_id;	
	private String ename;	
	private String trouble_content;	
	private Timestamp trouble_date;	
	private Timestamp resolve_date;
	private String trouble_resolve;	
	private String remark;
	private int history_id;
	private String equip_name;
}
