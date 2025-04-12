package com.ziio.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.Notifications;
import com.ziio.backend.domain.RepairRecords;
import com.ziio.backend.domain.Repairs;
import com.ziio.backend.domain.Users;
import com.ziio.backend.model.request.AddNotificationRequest;
import com.ziio.backend.model.request.Repairs.RepairsSubmitRequest;
import com.ziio.backend.model.vo.RepairsResVo;
import com.ziio.backend.model.vo.RepairsStatistics;
import com.ziio.backend.service.NotificationsService;
import com.ziio.backend.service.RepairsService;
import com.ziio.backend.mapper.RepairsMapper;

import com.ziio.backend.service.UsersService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ziio.backend.service.RepairRecordsService;

import java.util.Date;
import java.util.List;

/**
* @author Ziio
* @description 针对表【repairs】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class RepairsServiceImpl extends ServiceImpl<RepairsMapper, Repairs>
    implements RepairsService {

    @Resource
    private RepairRecordsService repairRecordsService;

    @Resource
    private UsersService usersService;

    @Resource
    private NotificationsService notificationsService;

    @Override
    @Transactional
    public Repairs submitRepair(RepairsSubmitRequest request, Integer userId) {
        Repairs repairs = new Repairs();
        BeanUtil.copyProperties(request, repairs);
        this.save(repairs);
        
        // 添加创建记录
        repairRecordsService.addRecord(repairs.getId(), userId, "create", "工单创建", repairs.getImages());
        return repairs;
    }

    @Override
    public IPage<Repairs> getUserRepairs(Integer userId, String status, IPage<Repairs> page) {
        LambdaQueryWrapper<Repairs> wrapper = new LambdaQueryWrapper<Repairs>()
            .eq(Repairs::getCreatorId, userId)
            .eq(status != null, Repairs::getStatus, status)
            .orderByDesc(Repairs::getCreatedAt);
        return this.page(page, wrapper);
    }

    @Override
    @Transactional
    public Repairs acceptRepair(Integer repairId, Integer maintainerId) {
        Repairs repair = this.getById(repairId);
        if (repair == null || !"pending".equals(repair.getStatus())) {
            return null;
        }
        // 更新工单
        repair.setMaintainerId(maintainerId);
        repair.setStatus("processing");
        this.updateById(repair);
        
        // 添加接单记录
        repairRecordsService.addRecord(repairId, maintainerId, "processing", "维修人员接单", null);
        return repair;
    }

    @Override
    public Repairs updateRepairStatus(Integer repairId, String status , Integer maintainerId) {
        // 更新工单状态
        Repairs repair = this.getById(repairId);
        repair.setStatus(status);
        repair.setMaintainerId(maintainerId);
        this.updateById(repair);
        Integer repairID = repair.getId();
        // 发送通知
        if("processing".equals(status)){
            String content = "您的报修工单 " + repairID + " 已更新";
            AddNotificationRequest notificationRequest = new AddNotificationRequest("repair", "维修工单状态更新", content, maintainerId, repair.getCreatorId());
            notificationsService.createNotification(notificationRequest);
        }else{
            String content = "您的报修工单 " + repairID + " 已完成维修，请及时评价";
            AddNotificationRequest notificationRequest = new AddNotificationRequest("message", "维修完成通知", content, maintainerId, repair.getCreatorId());
            notificationsService.createNotification(notificationRequest);
        }
        return repair;
    }

    @Override
    @Transactional
    public Repairs completeRepair(Integer repairId, Integer maintainerId) {
        Repairs repair = this.getById(repairId);
        if (repair == null || !repair.getMaintainerId().equals(maintainerId) || !"processing".equals(repair.getStatus())) {
            return null;
        }
        repair.setStatus("completed");
        this.updateById(repair);
        
        // 添加完成记录
        repairRecordsService.addRecord(repairId, maintainerId, "complete", "工单完成", null);
        return repair;
    }

    @Override
    @Transactional
    public Repairs assignRepair(Integer repairId, Integer maintainerId) {
        Repairs repair = this.getById(repairId);
        if (repair == null || !"pending".equals(repair.getStatus())) {
            return null;
        }
        repair.setMaintainerId(maintainerId);
        repair.setStatus("processing");
        this.updateById(repair);
        
        // 添加分配记录
        repairRecordsService.addRecord(repairId, maintainerId, "process", "管理员分配工单", null);
        return repair;
    }

    @Override
    public Repairs updatePriority(Integer repairId, String priority) {
        Repairs repair = this.getById(repairId);
        if (repair == null) {
            return null;
        }
        repair.setPriority(priority);
        this.updateById(repair);
        return repair;
    }

    @Override
    public RepairsResVo getUserRepairs(HttpServletRequest request , String status) {
        Users loginUser = usersService.getLoginUsers(request);
        Integer userId = loginUser.getId();
        // 用户只展示自己创建的订单
        if(loginUser.getRole().equals(1)){
            List<Repairs> repairsList = this.list(new LambdaQueryWrapper<Repairs>()
                    .eq(Repairs::getCreatorId, userId)
                    .eq(status != null, Repairs::getStatus, status)
                    .orderByDesc(Repairs::getCreatedAt));
            // 统计订单
            RepairsStatistics repairsStatistics = new RepairsStatistics();
            for(Repairs repairs : repairsList){
                if(repairs.getStatus().equals("pending")){
                    repairsStatistics.setPending(repairsStatistics.getPending() + 1);
                }
                else if(repairs.getStatus().equals("processing")){
                    repairsStatistics.setProcessing(repairsStatistics.getProcessing() + 1);
                }
                else{
                    repairsStatistics.setCompleted(repairsStatistics.getCompleted() + 1);
                }
                repairsStatistics.setPendingPercentage(repairsStatistics.getPending() * 100 / repairsList.size());
                repairsStatistics.setProcessingPercentage(repairsStatistics.getProcessing() * 100 / repairsList.size());
                repairsStatistics.setCompletedPercentage(repairsStatistics.getCompleted() * 100 / repairsList.size());
            }
            return new RepairsResVo(repairsList, repairsStatistics);
        }
        // 管理员能看到全部订单
        else if(loginUser.getRole().equals(2)){
            List<Repairs> repairsList = this.list(new LambdaQueryWrapper<Repairs>()
                    .eq(status != null, Repairs::getStatus, status)
                    .orderByDesc(Repairs::getCreatedAt));
            // 统计订单
            RepairsStatistics repairsStatistics = new RepairsStatistics();
            for(Repairs repairs : repairsList){
                if(repairs.getStatus().equals("pending")){
                    repairsStatistics.setPending(repairsStatistics.getPending() + 1);
                }
                else if(repairs.getStatus().equals("processing")){
                    repairsStatistics.setProcessing(repairsStatistics.getProcessing() + 1);
                }
                else{
                    repairsStatistics.setCompleted(repairsStatistics.getCompleted() + 1);
                }
                repairsStatistics.setPendingPercentage(repairsStatistics.getPending() * 100 / repairsList.size());
                repairsStatistics.setProcessingPercentage(repairsStatistics.getProcessing() * 100 / repairsList.size());
                repairsStatistics.setCompletedPercentage(repairsStatistics.getCompleted() * 100 / repairsList.size());
            }
            return new RepairsResVo(repairsList, repairsStatistics);
        }
        // 维修人员能看到 pending or maintainer 为自己的工单
        else{
            LambdaQueryWrapper<Repairs> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.and(wrapper -> wrapper
                    .eq(Repairs::getMaintainerId, userId)
                    .or()
                    .eq(Repairs::getStatus, "pending")
            );
            if (status != null) {
                queryWrapper.eq(Repairs::getStatus, status);
            }
            queryWrapper.orderByDesc(Repairs::getCreatedAt);
            List<Repairs> repairsList = this.list(queryWrapper);
            // 统计订单
            RepairsStatistics repairsStatistics = new RepairsStatistics();
            for(Repairs repairs : repairsList){
                if(repairs.getStatus().equals("pending")){
                    repairsStatistics.setPending(repairsStatistics.getPending() + 1);
                }
                else if(repairs.getStatus().equals("processing")){
                    repairsStatistics.setProcessing(repairsStatistics.getProcessing() + 1);
                }
                else{
                    repairsStatistics.setCompleted(repairsStatistics.getCompleted() + 1);
                }
                repairsStatistics.setPendingPercentage(repairsStatistics.getPending() * 100 / repairsList.size());
                repairsStatistics.setProcessingPercentage(repairsStatistics.getProcessing() * 100 / repairsList.size());
                repairsStatistics.setCompletedPercentage(repairsStatistics.getCompleted() * 100 / repairsList.size());
            }
            return new RepairsResVo(repairsList, repairsStatistics);
        }
    }

    @Override
    @Transactional
    public boolean forceCloseRepair(Integer repairId , Integer adminId) {
        Repairs repair = this.getById(repairId);
        // 同时强制关闭工单记录
        repairRecordsService.addRecord(repairId, adminId, "complete", "管理员强制关闭工单", null);
        if (repair == null || "completed".equals(repair.getStatus())) {
            return false;
        }
        repair.setStatus("completed");
        return this.updateById(repair);
    }

    @Override
    public RepairRecords getRepairRecords(Integer repairId) {
        LambdaQueryWrapper<RepairRecords> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RepairRecords::getRepairId, repairId);
        return repairRecordsService.getOne(wrapper);
    }

    @Override
    @Transactional
    public Boolean cancelPendingRepair(Integer repairId) {
        // 先删除记录
        repairRecordsService.remove(new LambdaQueryWrapper<RepairRecords>()
                .eq(RepairRecords::getRepairId, repairId)
        );
        this.removeById(repairId);
        return true;
    }
}




