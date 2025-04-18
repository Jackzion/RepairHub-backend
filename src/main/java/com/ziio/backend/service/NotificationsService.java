package com.ziio.backend.service;

import com.ziio.backend.domain.Notifications;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.model.request.AddNotificationRequest;

/**
* @author Ziio
* @description 针对表【notifications】的数据库操作Service
* @createDate 2025-03-15 13:59:27
*/
public interface NotificationsService extends IService<Notifications> {

    // 添加工单更新通知
    boolean createNotification(AddNotificationRequest notificationRequest);

}
