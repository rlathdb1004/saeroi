package kr.or.saeroi.controller;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dao.EquipmentStatusDAO;
import kr.or.saeroi.dto.EquipmentMaintenanceDTO;
import kr.or.saeroi.dto.EquipmentStatusDTO;
import kr.or.saeroi.dto.EquipmentTroubleDTO;
import kr.or.saeroi.dto.LoginDTO;
import kr.or.saeroi.service.EquipmentStatusService;
import kr.or.saeroi.service.LoginService;

@Controller
public class EquipmentStatusController {
	
	@Autowired
    private EquipmentStatusService service;
	
	@Autowired
	private EquipmentStatusDAO dao;
	
	@Autowired
	private LoginService loginService;
	
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
    
    @GetMapping("/equipment/equipmentstatus/detail")
    public String equipment_status_detail(
            @RequestParam("history_id") int history_id,
            @RequestParam(required = false) String mode,
            Model model) {

        EquipmentStatusDTO dto = service.equipment_status_detail(history_id);

        List<EquipmentMaintenanceDTO> maintenanceList =
                service.maintenance_history(dto.getEquip_id(),
                							dto.getOperation_date());

        List<EquipmentTroubleDTO> troubleList =
                service.trouble_history(dto.getEquip_id(),
                        				dto.getOperation_date());

        List<LoginDTO> empList = loginService.emp_list();
        
        model.addAttribute("eqp", dto);
        model.addAttribute("maintenanceList",maintenanceList);
        model.addAttribute("troubleList",troubleList);
        model.addAttribute("empList",empList);
        model.addAttribute("mode", mode);

        return "master/equipmentStatusDetail.tiles";
    }

    @PostMapping("/equipment_status/update")
    public String update(EquipmentStatusDTO dto) {
        service.update(dto);
        return "redirect:/equipment/equipmentstatus/detail?history_id=" + dto.getHistory_id();
    }

    @PostMapping("/equipment_status/delete")
    public String delete(
        @RequestParam("history_ids") List<Integer> ids
    ) {
        service.delete(ids);
        return "redirect:/equipment/equipmentstatus";
    }
    

    @PostMapping("/equipment_trouble/insert")
    public String trouble_insert(
            @RequestParam int equip_id,
            @RequestParam int emp_id,
            @RequestParam String trouble_content,
            @RequestParam(required = false) String trouble_resolve,
            @RequestParam(required = false) String remark,
            @RequestParam String trouble_date,
            @RequestParam(required = false) String resolve_date,
            @RequestParam int history_id
    ) {

        EquipmentTroubleDTO dto = new EquipmentTroubleDTO();

        dto.setEquip_id(equip_id);
        dto.setEmp_id(emp_id);
        dto.setTrouble_content(trouble_content);
        dto.setTrouble_resolve(trouble_resolve);
        dto.setRemark(remark);

        dto.setTrouble_date(
            Timestamp.valueOf(
                trouble_date.replace("T", " ") + ":00"
            )
        );

        if(resolve_date != null && !resolve_date.isEmpty()) {
            dto.setResolve_date(
                Timestamp.valueOf(
                    resolve_date.replace("T", " ") + ":00"
                )
            );
        }

        service.trouble_insert(dto);

        return "redirect:/equipment/equipmentstatus/detail?history_id=" + history_id;
    }
    
    @PostMapping("/equipment_maintenance/insert")
    public String maintenance_insert(EquipmentMaintenanceDTO dto) {
        service.maintenance_insert(dto);
        return "redirect:/equipment/equipmentstatus/detail?history_id=" + dto.getHistory_id();
    }
    
    @GetMapping("/equipment/equipmentstatus/maintenance_detail")
    public String equipment_maintenance_detail(
            @RequestParam("equip_main_id") int equip_main_id,
            @RequestParam int history_id,
            @RequestParam(required = false) String mode,
            Model model) {

        EquipmentMaintenanceDTO dto = service.maintenance_detail(equip_main_id);
        List<LoginDTO> empList = loginService.emp_list();       

        model.addAttribute("eqp", dto);
        model.addAttribute("empList", empList);
        model.addAttribute("mode", mode);        
        model.addAttribute("history_id", history_id);

        return "master/equipmentMaintenanceDetail.tiles";
    }
    
    @GetMapping("/equipment/equipmentstatus/trouble_detail")
    public String equipment_trouble_detail(
            @RequestParam("trouble_id") int trouble_id,
            @RequestParam int history_id,
            @RequestParam(required = false) String mode,
            Model model) {

        EquipmentTroubleDTO dto = service.equipment_trouble_detail(trouble_id);
        List<LoginDTO> empList = loginService.emp_list();

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

        String troubleDate = null;
        String resolveDate = null;

        if (dto.getTrouble_date() != null) {
            troubleDate = dto.getTrouble_date()
                    .toLocalDateTime()
                    .format(fmt);
        }

        if (dto.getResolve_date() != null) {
            resolveDate = dto.getResolve_date()
                    .toLocalDateTime()
                    .format(fmt);
        }

        model.addAttribute("eqp", dto);
        model.addAttribute("empList", empList);
        model.addAttribute("mode", mode);
        model.addAttribute("troubleDate", troubleDate);
        model.addAttribute("resolveDate", resolveDate);
        model.addAttribute("history_id", history_id);

        return "master/equipmentTroubleDetail.tiles";
    }
    
    @PostMapping("/equipment_maintenance/update")
    public String maintenance_update(@RequestParam Map<String, String> param) {

        EquipmentMaintenanceDTO dto = new EquipmentMaintenanceDTO();

        dto.setEquip_main_id(Integer.parseInt(param.get("equip_main_id")));
        dto.setEmp_id(Integer.parseInt(param.get("emp_id")));
        dto.setEquip_main_type(param.get("equip_main_type"));
        dto.setEquip_main_content(param.get("equip_main_content"));
        dto.setEquip_main_time(Integer.parseInt(param.get("equip_main_time")));
        dto.setRemark(param.get("remark"));
        dto.setHistory_id(Integer.parseInt(param.get("history_id")));

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        if (param.get("equip_main_date") != null && !param.get("equip_main_date").isEmpty()) {
            LocalDate ld = LocalDate.parse(param.get("equip_main_date"), fmt);
            dto.setEquip_main_date(java.sql.Date.valueOf(ld));
        }

        service.maintenance_update(dto);

        return "redirect:/equipment/equipmentstatus/maintenance_detail"
                + "?equip_main_id=" + dto.getEquip_main_id()
                + "&history_id=" + dto.getHistory_id();
    }
    
    @PostMapping("/equipment_trouble/update")
    public String update_trouble(@RequestParam Map<String, String> param) {

        EquipmentTroubleDTO dto = new EquipmentTroubleDTO();

        dto.setTrouble_id(Integer.parseInt(param.get("trouble_id")));
        dto.setEmp_id(Integer.parseInt(param.get("emp_id")));
        dto.setTrouble_content(param.get("trouble_content"));
        dto.setTrouble_resolve(param.get("trouble_resolve"));
        dto.setRemark(param.get("remark"));
        dto.setHistory_id(Integer.parseInt(param.get("history_id")));

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

        if (param.get("trouble_date") != null && !param.get("trouble_date").isEmpty()) {
            LocalDateTime ldt = LocalDateTime.parse(param.get("trouble_date"), fmt);
            dto.setTrouble_date(Timestamp.valueOf(ldt));
        }
        
        if (param.get("resolve_date") != null && !param.get("resolve_date").isEmpty()) {
            LocalDateTime ldt2 = LocalDateTime.parse(param.get("resolve_date"), fmt);
            dto.setResolve_date(Timestamp.valueOf(ldt2));
        }

        
        service.trouble_update(dto);

        return "redirect:/equipment/equipmentstatus/trouble_detail"
        + "?trouble_id=" + dto.getTrouble_id()
        + "&history_id=" + dto.getHistory_id();
    }
    
    @PostMapping("/equipment_status/maintenance_delete")
    public String maintenance_delete(@RequestParam("equip_main_ids") List<Integer> ids,
                                 @RequestParam("history_id") int history_id) {

        service.maintenance_delete(ids);

        return "redirect:/equipment/equipmentstatus/detail?history_id=" + history_id;
    }
    
    @PostMapping("/equipment_status/trouble_delete")
    public String trouble_delete(@RequestParam("trouble_ids") List<Integer> ids,
                                 @RequestParam("history_id") int history_id) {

        service.trouble_delete(ids);

        return "redirect:/equipment/equipmentstatus/detail?history_id=" + history_id;
    }
}
