package kr.or.saeroi.dto;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;

import lombok.Data;

@Data
public class EquipmentDTO {
	
    private int equip_id;
    private int line_id;
    private int client_id;
    private String equip_code;
    private String equip_name;
    private String equip_status;
    private String equip_loc;
    private Integer equip_price;
    private Date buy_date;
    private Timestamp created_date;
    private Timestamp updated_date;
    private String remark;
    private String use_yn;
    private String client_name;
    private String line_name;
}
