package com.ziio.backend.controller;

import cn.hutool.core.bean.BeanUtil;
import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.domain.Notifications;
import com.ziio.backend.model.request.AddNotificationRequest;
import com.ziio.backend.service.NotificationsService;
import com.ziio.backend.service.UsersService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/notification")
@Slf4j
public class NotificationController {

    @Resource
    private NotificationsService notificationsService;

    @Resource
    private UsersService usersService;

    // 获取我的消息列表
    @GetMapping("/myList")
    public BaseResponse<List<Notifications>> getMyList(HttpServletRequest request) {
        Integer userId = usersService.getLoginUsers(request).getId();
        List<Notifications> notificationsList = notificationsService.lambdaQuery()
                .eq(Notifications::getReceiverId, userId)
                .orderByDesc(Notifications::getCreatedAt)
                .list();
        return ResultUtils.success(notificationsList);
    }

    // 设置消息为已读
    @PutMapping("/read")
    public BaseResponse<Boolean> setRead(@RequestParam Integer notificationId) {
        Notifications notifications = notificationsService.getById(notificationId);
        notifications.setIsRead(1);
        boolean isSuccess = notificationsService.updateById(notifications);
        return ResultUtils.success(isSuccess);
    }

    // 设置消息为已读
    @PutMapping("/readAll")
    public BaseResponse<Boolean> setReadAll(HttpServletRequest request) {
        Integer userId = usersService.getLoginUsers(request).getId();
        List<Notifications> notificationsList = notificationsService.lambdaQuery()
                .eq(Notifications::getReceiverId, userId)
                .orderByDesc(Notifications::getCreatedAt)
                .list();
        for (Notifications notifications : notificationsList){
            notifications.setIsRead(1);
        }
        boolean isSuccess = notificationsService.updateBatchById(notificationsList);
        return ResultUtils.success(isSuccess);
    }

    // 删除全部消息
    @PutMapping("/deleteAll")
    public BaseResponse<Boolean> deleteAll(HttpServletRequest request) {
        Integer userId = usersService.getLoginUsers(request).getId();
        List<Notifications> notificationsList = notificationsService.lambdaQuery()
                .eq(Notifications::getReceiverId, userId)
                .orderByDesc(Notifications::getCreatedAt)
                .list();
        boolean isSuccess = notificationsService.removeBatchByIds(notificationsList);
        return ResultUtils.success(isSuccess);
    }

    // 新建消息
    @PutMapping("/create")
    public BaseResponse<Boolean> createNotification(AddNotificationRequest notificationRequest){
        Notifications notifications = new Notifications();
        BeanUtil.copyProperties(notificationRequest, notifications);
        boolean isSuccess = notificationsService.save(notifications);
        return ResultUtils.success(isSuccess);
    }

    // 删除消息
    @PutMapping("/delete")
    public BaseResponse<Boolean> deleteNotification(@RequestParam Integer notificationId){
        boolean isSuccess = notificationsService.removeById(notificationId);
        return ResultUtils.success(isSuccess);
    }

}