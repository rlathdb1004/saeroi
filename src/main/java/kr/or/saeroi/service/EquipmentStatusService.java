package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.EquipmentStatusDAO;
import kr.or.saeroi.dto.EquipmentDTO;
import kr.or.saeroi.dto.EquipmentStatusDTO;

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
	
	public EquipmentStatusDTO get_equipment_status_detail(int history_id) {
	    return dao.get_equipment_status_detail(history_id);
	}

	public void update(EquipmentStatusDTO dto) {
		// TODO Auto-generated method stub
		
	}

	public int delete(List<Integer> ids) {
		return dao.delete(ids);		
	}



	

	
}
