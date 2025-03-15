package com.ziio.backend.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.SystemLogs;
import com.ziio.backend.service.SystemLogsService;
import com.ziio.backend.mapper.SystemLogsMapper;
import org.springframework.stereotype.Service;

/**
* @author Ziio
* @description 针对表【system_logs】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class SystemLogsServiceImpl extends ServiceImpl<SystemLogsMapper, SystemLogs>
    implements SystemLogsService{

}




