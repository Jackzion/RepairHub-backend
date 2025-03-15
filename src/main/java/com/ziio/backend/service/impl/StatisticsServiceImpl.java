package com.ziio.backend.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.Statistics;
import com.ziio.backend.service.StatisticsService;
import com.ziio.backend.mapper.StatisticsMapper;
import org.springframework.stereotype.Service;

/**
* @author Ziio
* @description 针对表【statistics】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class StatisticsServiceImpl extends ServiceImpl<StatisticsMapper, Statistics>
    implements StatisticsService{

}




