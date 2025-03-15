package com.ziio.backend.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.domain.Notifications;
import com.ziio.backend.service.NotificationsService;
import com.ziio.backend.mapper.NotificationsMapper;
import org.springframework.stereotype.Service;

/**
* @author Ziio
* @description 针对表【notifications】的数据库操作Service实现
* @createDate 2025-03-15 13:59:27
*/
@Service
public class NotificationsServiceImpl extends ServiceImpl<NotificationsMapper, Notifications>
    implements NotificationsService{

}




