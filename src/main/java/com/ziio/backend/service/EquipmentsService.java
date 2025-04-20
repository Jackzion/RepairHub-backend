package com.ziio.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.domain.Equipments;
import com.ziio.backend.model.request.EquipmentUpdateRequest;

import java.util.List;

/**
* @author Ziio
* @description 针对表【equipments】的数据库操作Service
* @createDate 2025-03-15 13:59:27
*/
public interface EquipmentsService extends IService<Equipments> {

    List<Equipments> listEquipments( String status);

    Boolean updateEquipments(EquipmentUpdateRequest updateRequest);
}
