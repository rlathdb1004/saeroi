package kr.or.saeroi.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.saeroi.common.PageDTO;
import kr.or.saeroi.dao.EquipmentDAO;
import kr.or.saeroi.dto.EquipmentDTO;
import kr.or.saeroi.service.EquipmentService;

@Controller
public class EquipmentController {

    @Autowired
    private EquipmentService equipmentService;
    @Autowired
	private EquipmentDAO equipmentDAO;

    @RequestMapping(value = "/equipment/equipment", method = RequestMethod.GET)
    public String eqp(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size,
            @RequestParam(value = "searchType", defaultValue = "all") String searchType,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            HttpSession session,
            Model model) {

        if (session.getAttribute("loginUser") == null) {
            return "redirect:/";
        }

        List<EquipmentDTO> list;
        model.addAttribute("clientList",equipmentDAO.get_client_list());
        model.addAttribute("lineList", equipmentDAO.get_line_list());
        
        if (keyword == null || keyword.trim().isEmpty()) {
            list = equipmentService.eqp_list();
        } else {          
            list = equipmentService.search_eqp_list(searchType,keyword);
        }
        
        int totalCount = list.size();
        int startIndex = (page - 1) * size;
        int endIndex = startIndex + size;
        if (endIndex > totalCount) {
            endIndex = totalCount;
        }

        List<EquipmentDTO> page_list =list.subList(startIndex, endIndex);

        PageDTO pageInfo = new PageDTO(page, size, totalCount);
        
        model.addAttribute("list", page_list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("pageUrl", "/equipment/equipment");
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        return "master/equipment.tiles";
    }
    
    @PostMapping("/equipment/insert")
    public String insert_equipment(EquipmentDTO dto,
                                  HttpServletRequest request) {
        try {
            dto.setEquip_loc(dto.getLine_id() + "라인");   
            int result = equipmentService.insert_equipment(dto);
            if (result > 0) {
                request.getSession().setAttribute("msg", "설비 등록 성공");
            } else {
                request.getSession().setAttribute("msg", "설비 등록 실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "오류 발생");
        }
        
        return "redirect:/equipment/equipment";
    }
    
    @PostMapping("/equipment/delete")
    public String delete_equipment(@RequestParam("eqp_ids") List<Integer> eqpIds,
                                   HttpServletRequest request) {

        try {
            int result = equipmentService.delete_equipment(eqpIds);
            request.getSession().setAttribute("msg",
            		result > 0 ? "삭제 성공" : "삭제 실패");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "오류 발생");        }

        return "redirect:/equipment/equipment";
    }
    
    @GetMapping("/equipment/detail")
    public String equipmentDetail(
    		@RequestParam("equip_id") String equip_id, 
    		 @RequestParam(required = false) String mode,
    		Model model) {

        EquipmentDTO dto = equipmentService.get_equipment_detail(equip_id);
        
        
        model.addAttribute("clientList",equipmentDAO.get_client_list());
        model.addAttribute("lineList", equipmentDAO.get_line_list());

        model.addAttribute("eqp", dto);
        model.addAttribute("mode", mode);

        return "master/equipmentDetail.tiles"; 
    }
    
    
    @PostMapping("/equipment/update")
    public String updateEquipment(EquipmentDTO dto) {

    	dto.setEquip_loc(dto.getLine_id() + "라인");
        equipmentService.update_equipment(dto);

        return "redirect:/equipment/detail?equip_id=" + dto.getEquip_id();
    }
   
}
