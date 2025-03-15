package com.ziio.backend.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.Locations;
import com.ziio.backend.service.LocationsService;
import com.ziio.backend.mapper.LocationsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
* @author Ziio
* @description 针对表【locations】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class LocationsServiceImpl extends ServiceImpl<LocationsMapper, Locations>
    implements LocationsService{
    
        @Override
        public List<Locations> getAllLocations() {
            LambdaQueryWrapper<Locations> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.orderByAsc(Locations::getLevel, Locations::getId);
            return this.baseMapper.selectList(queryWrapper);
        }
}




