package com.ziio.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.Repairs;
import com.ziio.backend.model.request.Repairs.RepairsSubmitRequest;
import com.ziio.backend.service.RepairsService;
import com.ziio.backend.mapper.RepairsMapper;

import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ziio.backend.service.RepairRecordsService;

import java.util.Date;

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
    public boolean cancelRepair(Integer repairId, Integer userId) {
        Repairs repair = this.getById(repairId);
        if (repair == null || !repair.getCreatorId().equals(userId) || !"pending".equals(repair.getStatus())) {
            return false;
        }
        this.removeById(repairId);
        return true;
    }

    @Override
    @Transactional
    public Repairs acceptRepair(Integer repairId, Integer maintainerId) {
        Repairs repair = this.getById(repairId);
        if (repair == null || !"pending".equals(repair.getStatus())) {
            return null;
        }
        repair.setMaintainerId(maintainerId);
        repair.setStatus("processing");
        this.updateById(repair);
        
        // 添加接单记录
        repairRecordsService.addRecord(repairId, maintainerId, "accept", "维修人员接单", null);
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
        repairRecordsService.addRecord(repairId, maintainerId, "assign", "管理员分配工单", null);
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
    @Transactional
    public boolean forceCloseRepair(Integer repairId) {
        Repairs repair = this.getById(repairId);
        if (repair == null || "completed".equals(repair.getStatus())) {
            return false;
        }
        repair.setStatus("completed");
        return this.updateById(repair);
    }
}




