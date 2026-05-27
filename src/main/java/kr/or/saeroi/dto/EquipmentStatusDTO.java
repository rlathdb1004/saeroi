package kr.or.saeroi.dto;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class EquipmentStatusDTO {

	private int history_id;
	private int equip_id;
	private String equip_code;
	private String equip_name;
	private Date operation_date;
	private int plan_time_min;
	private int runtime_min;
	private int downtime_min;
	private String down_reason;
	private String remark;
	
}
