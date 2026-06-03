package kr.or.saeroi.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class EquipmentStatusDTO {

	private int history_id;
	private int equip_id;
	private int equip_main_id;
	private int trouble_id;
	private String equip_code;
	private String equip_name;
	private Date operation_date;
	private Integer plan_time_min;
	private Integer runtime_min;
	private Integer downtime_min;
	private String down_reason;
	private String remark;
	private String doc_no;
	private int doc_seq;
	
}
