package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.EquipmentDAO;
import kr.or.saeroi.dao.EquipmentStatusDAO;
import kr.or.saeroi.dto.EquipmentDTO;
import kr.or.saeroi.dto.EquipmentMaintenanceDTO;
import kr.or.saeroi.dto.EquipmentTroubleDTO;

@Service
public class EquipmentService {
	@Autowired
    private EquipmentDAO equipmentDAO;
	@Autowired
    private EquipmentStatusDAO equipmentstatusDAO;

	public List<EquipmentDTO> eqp_list() {
	    return equipmentDAO.eqp_list();
	}
	
	public List<EquipmentDTO> search_eqp_list(
	        String searchType,
	        String keyword){
		return equipmentDAO.search_eqp_list(searchType,keyword);
	}
	
	public int insert_equipment(EquipmentDTO dto) {
	    return equipmentDAO.insert_equipment(dto);
	}
	
	public int delete_equipment(List<Integer> eqpIds) {
	    return equipmentDAO.delete_equipment(eqpIds);
	}
	
	public EquipmentDTO get_equipment_detail(String equip_id) {
	    return equipmentDAO.get_equipment_detail(equip_id);
	}
	
	public int update_equipment(EquipmentDTO dto) {		
		 
	    return equipmentDAO.update_equipment(dto);
	}

	public void update_equip_status(EquipmentDTO dto, int emp_id) {
		EquipmentDTO old_data =
                equipmentDAO.get_equipment_detail(String.valueOf(dto.getEquip_id()));

        String old_status = old_data.getEquip_status();
        String new_status = dto.getEquip_status();
       
        equipmentDAO.update_equipment(dto);        

        if (old_status != null && !old_status.equals(new_status)) {

            if ("점검".equals(new_status)) {

                EquipmentMaintenanceDTO m = new EquipmentMaintenanceDTO();
                m.setEquip_id(dto.getEquip_id());
                m.setEmp_id(emp_id);
                m.setEquip_main_date(new java.sql.Date(System.currentTimeMillis()));
                m.setEquip_main_type("상태변경정비");
                m.setEquip_main_content("설비 상태 변경으로 인한 정비 등록");
                m.setEquip_main_time(0);
                m.setRemark("AUTO");

                equipmentstatusDAO.maintenance_insert(m);
            }

            else if ("고장".equals(new_status)) {

                EquipmentTroubleDTO t = new EquipmentTroubleDTO();
                t.setEquip_id(dto.getEquip_id());
                t.setEmp_id(emp_id);
                t.setTrouble_content("설비 상태 변경으로 고장 등록");
                t.setTrouble_date(new java.sql.Timestamp(System.currentTimeMillis()));
                t.setRemark("AUTO");

                equipmentstatusDAO.trouble_insert(t);
            }
        }
    }	
	
	
}
