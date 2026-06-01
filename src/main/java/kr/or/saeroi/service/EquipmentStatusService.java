package kr.or.saeroi.service;

import java.sql.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.EquipmentStatusDAO;
import kr.or.saeroi.dto.EquipmentMaintenanceDTO;
import kr.or.saeroi.dto.EquipmentStatusDTO;
import kr.or.saeroi.dto.EquipmentTroubleDTO;

@Service
public class EquipmentStatusService {
	
	@Autowired
    private EquipmentStatusDAO dao;
	
	public List<EquipmentStatusDTO> eqp_status_list() {
	    return dao.eqp_status_list();
	}
	
	public List<EquipmentStatusDTO> eqp_status_search(String searchType, String keyword) {
	    return dao.eqp_status_search(searchType, keyword);
	}

	public int insert(EquipmentStatusDTO dto) {
		return dao.insert(dto);		
	}
	
	public EquipmentStatusDTO equipment_status_detail(int history_id) {
	    return dao.equipment_status_detail(history_id);
	}

	public int update(EquipmentStatusDTO dto) {
		return dao.update(dto);		
	}

	public int delete(List<Integer> ids) {
		return dao.delete(ids);		
	}

	public List<EquipmentMaintenanceDTO> maintenance_history(
	        int equip_id, Date operation_date) {

	    return dao.maintenance_history(equip_id, operation_date);
	}
	
	public List<EquipmentTroubleDTO> trouble_history(
	        int equip_id, Date operation_date) {

	    return dao.trouble_history(equip_id, operation_date);
	}
	
	public int maintenance_insert(EquipmentMaintenanceDTO dto) {
		return dao.maintenance_insert(dto);	
		
	}

	public int trouble_update(EquipmentStatusDTO dto) {
		return dao.truoble_update(dto);
		
	}

	public int trouble_insert(EquipmentTroubleDTO dto) {
		return dao.trouble_insert(dto);	
		
	}

	

	
}
