package com.ziio.backend.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.domain.RepairRecords;

/**
* @author Ziio
* @description 针对表【repair_records】的数据库操作Service
* @createDate 2025-03-15 13:59:27
*/
public interface RepairRecordsService extends IService<RepairRecords> {
    
    /**
     * 添加维修记录
     * @param repairId 工单ID
     * @param handlerId 处理人ID
     * @param type 记录类型
     * @param content 处理说明
     * @param images 相关图片
     * @return 创建的维修记录
     */
    RepairRecords addRecord(Integer repairId, Integer handlerId, String type, String content, Object images);
    
    /**
     * 获取工单的维修记录列表
     * @param repairId 工单ID
     * @param page 分页参数
     * @return 维修记录列表
     */
    IPage<RepairRecords> getRepairRecords(Integer repairId, IPage<RepairRecords> page);
    
    /**
     * 更新维修记录
     * @param recordId 记录ID
     * @param content 更新的内容
     * @param images 更新的图片
     * @return 更新后的维修记录
     */
    RepairRecords updateRecord(Integer recordId, String content, Object images);
    
    /**
     * 删除维修记录
     * @param recordId 记录ID
     * @param handlerId 处理人ID
     * @return 是否删除成功
     */
    boolean deleteRecord(Integer recordId, Integer handlerId);
}
