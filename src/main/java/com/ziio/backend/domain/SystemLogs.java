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
 * @TableName system_logs
 */
@TableName(value ="system_logs")
@Data
public class SystemLogs implements Serializable {
    /**
     * 系统日志的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 系统日志的类型，分为操作日志、系统日志、错误日志
     */
    private Object type;

    /**
     * 系统日志的详细内容
     */
    private String content;

    /**
     * 进行操作的用户 ID，关联 users 表的 id
     */
    private Integer operatorId;

    /**
     * 操作的 IP 地址
     */
    private String ip;

    /**
     * 系统日志创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}