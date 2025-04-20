package com.ziio.backend.controller;

import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.domain.EquipmentTypes;
import com.ziio.backend.service.EquipmentTypesService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/equipmentTypes")
@Slf4j
public class EquipmentTypesController {

    @Resource
    private EquipmentTypesService equipmentTypesService;

    // 获取 EquipmentTypes列表
    @GetMapping("/list")
    public BaseResponse<String[]> getEquipmentTypes() {
        return ResultUtils.success(equipmentTypesService.getTypes());
    }

    @PutMapping("/add")
    public BaseResponse<Boolean> addEquipmentTypes(@RequestParam String name , @RequestParam String description) {
        EquipmentTypes equipmentTypes = new EquipmentTypes();
        equipmentTypes.setName(name);
        equipmentTypes.setDescription(description);
        return ResultUtils.success(equipmentTypesService.save(equipmentTypes));
    }

}