package com.ziio.backend.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.Equipments;
import com.ziio.backend.mapper.EquipmentsMapper;
import com.ziio.backend.model.request.EquipmentUpdateRequest;
import com.ziio.backend.service.EquipmentsService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
* @author Ziio
* @description 针对表【equipments】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class EquipmentsServiceImpl extends ServiceImpl<EquipmentsMapper, Equipments>
    implements EquipmentsService{

    @Override
    public List<Equipments> listEquipments(String status) {
        LambdaQueryWrapper<Equipments> eq = new LambdaQueryWrapper<>();
        eq.eq(status != null, Equipments::getStatus, status);
        eq.orderByDesc(Equipments::getCreatedAt);
        return this.list(eq);
    }

    @Override
    public Boolean updateEquipments(EquipmentUpdateRequest updateRequest) {
        Equipments equipments = new Equipments();
        BeanUtil.copyProperties(updateRequest, equipments);
        return this.updateById(equipments);
    }
}




