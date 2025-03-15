package com.ziio.backend.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.domain.Repairs;
import com.ziio.backend.model.request.Repairs.RepairsSubmitRequest;

/**
* @author Ziio
* @description 针对表【repairs】的数据库操作Service
* @createDate 2025-03-15 13:59:27
*/
public interface RepairsService extends IService<Repairs> {
    
    /**
     * 提交报修工单
     * @param submitRequest 报修工单信息
     * @param userId 用户ID
     * @return 创建的报修工单
     */
    Repairs submitRepair(RepairsSubmitRequest submitRequest, Integer userId);
    
    /**
     * 获取用户的工单列表
     * @param userId 用户ID
     * @param status 工单状态（可选）
     * @param page 分页参数
     * @return 工单列表
     */
    IPage<Repairs> getUserRepairs(Integer userId, String status, IPage<Repairs> page);
    
    /**
     * 取消未处理的工单
     * @param repairId 工单ID
     * @param userId 用户ID
     * @return 是否取消成功
     */
    boolean cancelRepair(Integer repairId, Integer userId);
    
    /**
     * 维修人员接单
     * @param repairId 工单ID
     * @param maintainerId 维修人员ID
     * @return 更新后的工单
     */
    Repairs acceptRepair(Integer repairId, Integer maintainerId);
    
    /**
     * 完成工单
     * @param repairId 工单ID
     * @param maintainerId 维修人员ID
     * @return 更新后的工单
     */
    Repairs completeRepair(Integer repairId, Integer maintainerId);
    
    /**
     * 管理员分配工单
     * @param repairId 工单ID
     * @param maintainerId 维修人员ID
     * @return 更新后的工单
     */
    Repairs assignRepair(Integer repairId, Integer maintainerId);
    
    /**
     * 调整工单优先级
     * @param repairId 工单ID
     * @param priority 新的优先级
     * @return 更新后的工单
     */
    Repairs updatePriority(Integer repairId, String priority);
    
    /**
     * 强制关闭工单
     * @param repairId 工单ID
     * @return 是否关闭成功
     */
    boolean forceCloseRepair(Integer repairId);
}
