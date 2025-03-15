package com.ziio.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.domain.RepairRecords;
import com.ziio.backend.service.RepairRecordsService;
import com.ziio.backend.service.UsersService;

import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/repair-records")
public class RepairRecordsController {

    @Autowired
    private RepairRecordsService repairRecordsService;    
    
    @Autowired
    private UsersService usersService;

    /**
     * 获取工单的维修记录列表
     */
    @GetMapping("/{repairId}")
    public BaseResponse<IPage<RepairRecords>> getRepairRecords(
            @PathVariable Integer repairId,
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {
        IPage<RepairRecords> page = new Page<>(current, size);
        return ResultUtils.success(repairRecordsService.getRepairRecords(repairId, page));
    }

    /**
     * 添加维修记录
     */
    @PostMapping("/{repairId}")
    public BaseResponse<RepairRecords> addRecord(
            @PathVariable Integer repairId,
            @RequestParam String type,
            @RequestParam String content,
            @RequestBody(required = false) Object images,
            HttpServletRequest request) {
        Integer handlerId = usersService.getLoginUsers(request).getId();
        return ResultUtils.success(repairRecordsService.addRecord(repairId, handlerId, type, content, images));
    }

    /**
     * 更新维修记录
     */
    @PutMapping("/{recordId}")
    public BaseResponse<RepairRecords> updateRecord(
            @PathVariable Integer recordId,
            @RequestParam String content,
            @RequestBody(required = false) Object images) {
        return ResultUtils.success(repairRecordsService.updateRecord(recordId, content, images));
    }

    /**
     * 删除维修记录
     */
    @DeleteMapping("/{recordId}")
    public BaseResponse<Boolean> deleteRecord(@PathVariable Integer recordId,HttpServletRequest request) {
        Integer handlerId = usersService.getLoginUsers(request).getId();
        return ResultUtils.success(repairRecordsService.deleteRecord(recordId, handlerId));
    }
}