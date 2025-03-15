package com.ziio.backend.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;

/**
 * 
 * @TableName notifications
 */
@TableName(value ="notifications")
@Data
public class Notifications implements Serializable {
    /**
     * 消息通知的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

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

    /**
     * 消息通知是否已读，默认为未读
     */
    private Integer isRead;

    /**
     * 消息通知创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}