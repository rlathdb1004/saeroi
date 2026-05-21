package kr.or.saeroi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.saeroi.dao.EquipmentDAO;
import kr.or.saeroi.dto.EquipmentDTO;

@Service
public class EquipmentService {
	@Autowired
    private EquipmentDAO equipmentDAO;

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
	
}
