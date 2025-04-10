package com.ziio.backend.service.impl;

import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.RepairRecords;
import com.ziio.backend.mapper.RepairRecordsMapper;
import com.ziio.backend.service.RepairRecordsService;

/**
* @author Ziio
* @description 针对表【repair_records】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class RepairRecordsServiceImpl extends ServiceImpl<RepairRecordsMapper, RepairRecords>
    implements RepairRecordsService {

    @Override
    @Transactional
    public RepairRecords addRecord(Integer repairId, Integer handlerId, String type, String content, Object images) {
        if("processing".equals(type)){
            type = "process";
        }
        if("completed".equals(type)){
            type = "complete";
        }
        RepairRecords record = new RepairRecords();
        record.setRepairId(repairId);
        record.setHandlerId(handlerId);
        record.setType(type);
        record.setContent(content);
        record.setImages(images);
        record.setCreatedAt(new Date());
        this.save(record);
        return record;
    }

    @Override
    public IPage<RepairRecords> getRepairRecords(Integer repairId, IPage<RepairRecords> page) {
        LambdaQueryWrapper<RepairRecords> wrapper = new LambdaQueryWrapper<RepairRecords>()
            .eq(RepairRecords::getRepairId, repairId)
            .orderByDesc(RepairRecords::getCreatedAt);
        return this.page(page, wrapper);
    }

    @Override
    @Transactional
    public RepairRecords updateRecord(Integer recordId, String content, Object images) {
        RepairRecords record = this.getById(recordId);
        if (record == null) {
            return null;
        }
        record.setContent(content);
        record.setImages(images);
        this.updateById(record);
        return record;
    }

    @Override
    @Transactional
    public boolean deleteRecord(Integer recordId, Integer handlerId) {
        RepairRecords record = this.getById(recordId);
        if (record == null || !record.getHandlerId().equals(handlerId)) {
            return false;
        }
        return this.removeById(recordId);
    }
}




