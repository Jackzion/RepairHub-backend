package com.ziio.backend.service;

import java.util.List;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.domain.Locations;

/**
* @author Ziio
* @description 针对表【locations】的数据库操作Service
* @createDate 2025-03-15 13:59:27
*/
public interface LocationsService extends IService<Locations> {
    /**
     * 获取所有位置信息
     *
     * @return 位置信息列表
     */
    List<Locations> getAllLocations();
}
