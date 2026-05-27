package kr.or.saeroi.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dao.EquipmentStatusDAO;
import kr.or.saeroi.dto.EquipmentDTO;
import kr.or.saeroi.dto.EquipmentStatusDTO;
import kr.or.saeroi.service.EquipmentStatusService;

@Controller
public class EquipmentStatusController {
	
	@Autowired
    private EquipmentStatusService service;
	
	@Autowired
	private EquipmentStatusDAO dao;
	
	@GetMapping("/equipment/equipmentstatus")
	public String equipmentStatus(
			@RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size,
	        @RequestParam(defaultValue = "all") String searchType,
	        @RequestParam(defaultValue = "") String keyword,
	        HttpSession session,
	        Model model) {

		if (session.getAttribute("loginUser") == null) {
            return "redirect:/login";
        }
		
	    List<EquipmentStatusDTO> list = service.eqp_status_search(searchType, keyword);

	    int totalCount = list.size();
        int startIndex = (page - 1) * size;
        int endIndex = startIndex + size;
        if (endIndex > totalCount) {
            endIndex = totalCount;
        }
        List<EquipmentStatusDTO> page_list =list.subList(startIndex, endIndex);

        PageDTO pageInfo = new PageDTO(page, size, totalCount);
        
        model.addAttribute("list", page_list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/equipment/equipmentstatus");
	    model.addAttribute("searchType", searchType);
	    model.addAttribute("keyword", keyword);

	    return "master/equipmentStatus.tiles";
	}

    @PostMapping("/equipment_status/insert")
    public String insert(EquipmentStatusDTO dto) {
        service.insert(dto);
        return "redirect:/equipment/equipmentstatus";
    }
    
    @GetMapping("/equipment_status/detail")
    public String equipment_status_detail(
    		@RequestParam("history_id") int history_id, 
    		@RequestParam(required = false) String mode,
    		Model model) {

        EquipmentStatusDTO dto = service.get_equipment_status_detail(history_id);        
        
        model.addAttribute("eqp", dto);
        model.addAttribute("mode", mode);

        return "master/equipmentStatusDetail.tiles"; 
    }

    @PostMapping("/equipment_status/update")
    public String update(EquipmentStatusDTO dto) {
        service.update(dto);
        return "redirect:/equipment_status/detail?history_id=" + dto.getHistory_id();
    }

    @PostMapping("/equipment_status/delete")
    public String delete(
        @RequestParam("history_ids") List<Integer> ids
    ) {
        service.delete(ids);
        return "redirect:/equipment/equipmentstatus";
    }
    
    
}
