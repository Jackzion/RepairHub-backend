package com.ziio.backend.controller;

import com.ziio.backend.model.request.Repairs.RepairsSubmitRequest;
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
import com.ziio.backend.domain.Repairs;
import com.ziio.backend.service.RepairsService;
import com.ziio.backend.service.UsersService;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/repairs")
public class RepairsController {

    @Autowired
    private RepairsService repairsService;

    @Resource
    private  UsersService usersService;

    /**
     * 提交报修工单
     */
    @PostMapping("/submit")
    public BaseResponse<Repairs> submitRepair(@RequestBody RepairsSubmitRequest submitRequest , HttpServletRequest request) {
        Integer userId = usersService.getLoginUsers(request).getId();
        return ResultUtils.success(repairsService.submitRepair(submitRequest, userId));
    }

    /**
     * 获取用户的工单列表
     */
    @GetMapping("/user")
    public BaseResponse<IPage<Repairs>> getUserRepairs(
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            HttpServletRequest request
            ) {
        Integer userId = usersService.getLoginUsers(request).getId();
        IPage<Repairs> page = new Page<>(current, size);
        return ResultUtils.success(repairsService.getUserRepairs(userId, status, page));
    }

    /**
     * 取消未处理的工单
     */
    @DeleteMapping("/{repairId}")
    public BaseResponse<Boolean> cancelRepair(@PathVariable Integer repairId,HttpServletRequest request) {
        Integer userId = usersService.getLoginUsers(request).getId();
        return ResultUtils.success(repairsService.cancelRepair(repairId, userId));
    }

    /**
     * 维修人员接单
     */
    @PutMapping("/{repairId}/accept")
    public BaseResponse<Repairs> acceptRepair(@PathVariable Integer repairId,HttpServletRequest request) {
        Integer maintainerId = usersService.getLoginUsers(request).getId();
        return ResultUtils.success(repairsService.acceptRepair(repairId, maintainerId));
    }

    /**
     * 完成工单
     */
    @PutMapping("/{repairId}/complete")
    public BaseResponse<Repairs> completeRepair(@PathVariable Integer repairId,HttpServletRequest request) {
        Integer maintainerId = usersService.getLoginUsers(request).getId();
        return ResultUtils.success(repairsService.completeRepair(repairId, maintainerId));
    }

    /**
     * 管理员分配工单
     */
    @PutMapping("/{repairId}/assign/{maintainerId}")
    public BaseResponse<Repairs> assignRepair(
            @PathVariable Integer repairId,
            @PathVariable Integer maintainerId) {
        return ResultUtils.success(repairsService.assignRepair(repairId, maintainerId));
    }

    /**
     * 调整工单优先级
     */
    @PutMapping("/{repairId}/priority")
    public BaseResponse<Repairs> updatePriority(
            @PathVariable Integer repairId,
            @RequestParam String priority) {
        return ResultUtils.success(repairsService.updatePriority(repairId, priority));
    }

    /**
     * 强制关闭工单
     */
    @PutMapping("/{repairId}/force-close")
    public BaseResponse<Boolean> forceCloseRepair(@PathVariable Integer repairId) {
        return ResultUtils.success(repairsService.forceCloseRepair(repairId));
    }
}