package kr.or.saeroi.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class EquipmentMaintenanceDTO {
	private int equip_main_id;
	private int equip_id;
	private int emp_id;
	private String ename;	
	private Date equip_main_date;
	private String equip_main_type;
	private String equip_main_content;
	private int equip_main_time;
	private String remark;	
	private int history_id;
}
