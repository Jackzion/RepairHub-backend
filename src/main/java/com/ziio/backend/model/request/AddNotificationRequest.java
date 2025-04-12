package com.ziio.backend.model.request;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;

@Data
@AllArgsConstructor
public class AddNotificationRequest {

    /**
     * 消息通知的类型，分为报修通知、系统通知、普通消息
     */
    private Object type;

    /**
     * 消息通知的标题
     */
    private String title;

    /**
     * 消息通知的详细内容
     */
    private String content;

    /**
     * 消息通知的发送者 ID，关联 users 表的 id
     */
    private Integer senderId;

    /**
     * 消息通知的接收者 ID，关联 users 表的 id
     */
    private Integer receiverId;

}
