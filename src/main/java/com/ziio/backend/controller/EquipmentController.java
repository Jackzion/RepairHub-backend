package com.ziio.backend.controller;

import cn.hutool.core.bean.BeanUtil;
import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.domain.Equipments;
import com.ziio.backend.model.request.EquipmentAddRequest;
import com.ziio.backend.model.request.EquipmentUpdateRequest;
import com.ziio.backend.service.EquipmentsService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/equipment")
@Slf4j
public class EquipmentController {

    @Resource
    private EquipmentsService equipmentsService;

    @PutMapping("/add")
    public BaseResponse<Boolean> addEquipment(@RequestBody EquipmentAddRequest addRequest) {
        Equipments equipments = new Equipments();
        BeanUtil.copyProperties(addRequest, equipments);
        equipmentsService.save(equipments);
        equipments.setName( equipments.getType() + equipments.getId());
        equipmentsService.updateById(equipments);
        return ResultUtils.success(true);
    }

    /**
     * 获取用户的工单列表
     */
    @GetMapping("/list")
    public BaseResponse<List<Equipments>> listEquipments(@RequestParam(required = false) String status) {
        return ResultUtils.success(equipmentsService.listEquipments(status));
    }

    /**
     * 获取用户的工单列表
     */
    @PutMapping("/update")
    public BaseResponse<Boolean> updateEquipments(@RequestBody EquipmentUpdateRequest updateRequest) {
        return ResultUtils.success(equipmentsService.updateEquipments(updateRequest));
    }

    @PostMapping("/delete")
    public BaseResponse<Boolean> deleteEquipments(@RequestParam Integer id) {
        return ResultUtils.success(equipmentsService.removeById(id));
    }

}