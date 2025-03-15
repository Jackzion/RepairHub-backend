package com.ziio.backend.service;

import com.ziio.backend.domain.EquipmentTypes;
import com.baomidou.mybatisplus.extension.service.IService;

/**
* @author Ziio
* @description 针对表【equipment_types】的数据库操作Service
* @createDate 2025-03-15 13:59:27
*/
public interface EquipmentTypesService extends IService<EquipmentTypes> {

    // 返回类型列表(list<string>)
    public default String[] getTypes() {
        return this.list().stream().map(EquipmentTypes::getName).toArray(String[]::new);
    }



}
