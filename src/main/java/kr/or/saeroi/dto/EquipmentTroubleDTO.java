package kr.or.saeroi.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class EquipmentTroubleDTO {
	private int trouble_id;
	private int equip_id;
	private int emp_id;	
	private String ename;	
	private String trouble_content;
	private Date trouble_date;
	private String trouble_resolve;
	private Date resolve_date;
	private String remark;
}
