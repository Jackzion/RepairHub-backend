package com.ziio.backend.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.domain.RepairRecords;
import com.ziio.backend.domain.Repairs;
import com.ziio.backend.model.request.Repairs.RepairsSubmitRequest;
import com.ziio.backend.model.vo.RepairsResVo;
import com.ziio.backend.model.vo.RepairsStatistics;
import jakarta.servlet.http.HttpServletRequest;

import java.net.http.HttpRequest;
import java.util.List;

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
     * 维修人员接单
     * @param repairId 工单ID
     * @param maintainerId 维修人员ID
     * @return 更新后的工单
     */
    Repairs acceptRepair(Integer repairId, Integer maintainerId);

    /**
     * 更新工单状态
     */
    Repairs updateRepairStatus(Integer repairId, String status);

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
     * 查看自己提交的工单列表
     */
    RepairsResVo getUserRepairs(HttpServletRequest request , String status);


    /**
     * 强制关闭工单
     * @param repairId 工单ID
     * @return 是否关闭成功
     */
    boolean forceCloseRepair(Integer repairId,Integer adminId);

    /**
     * 获取工单进度详情
     * @param repairId
     * @return
     */
    RepairRecords getRepairRecords(Integer repairId);

    /**
     * 取消未处理（pending） 工单
     * @param repairId
     * @return
     */
    Boolean cancelPendingRepair(Integer repairId);
}
