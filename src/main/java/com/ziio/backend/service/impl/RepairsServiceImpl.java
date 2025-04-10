package com.ziio.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.RepairRecords;
import com.ziio.backend.domain.Repairs;
import com.ziio.backend.domain.Users;
import com.ziio.backend.model.request.Repairs.RepairsSubmitRequest;
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
        repairRecordsService.addRecord(repairId, maintainerId, "accept", "维修人员接单", null);
        return repair;
    }

    @Override
    public Repairs updateRepairStatus(Integer repairId, String status) {
        // 更新工单状态
        Repairs repair = this.getById(repairId);
        repair.setStatus(status);
        this.updateById(repair);
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
    public List<Repairs> getUserRepairs(HttpServletRequest request , String status) {
        Users loginUser = usersService.getLoginUsers(request);
        Integer userId = loginUser.getId();
        // 用户只展示自己创建的订单
        if(loginUser.getRole().equals(0)){
            return this.list(new LambdaQueryWrapper<Repairs>()
                    .eq(Repairs::getCreatorId, userId)
                    .eq(status != null, Repairs::getStatus, status)
                    .orderByDesc(Repairs::getCreatedAt));
        }
        // 其他人能看到全部订单
        else{
            return this.list(new LambdaQueryWrapper<Repairs>()
                    .eq(status != null, Repairs::getStatus, status)
                    .orderByDesc(Repairs::getCreatedAt));
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




