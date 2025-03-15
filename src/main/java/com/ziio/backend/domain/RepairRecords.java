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
 * @TableName repair_records
 */
@TableName(value ="repair_records")
@Data
public class RepairRecords implements Serializable {
    /**
     * 维修记录的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 关联的报修工单 ID，指向 repairs 表的 id
     */
    private Integer repairId;

    /**
     * 维修记录的类型，分为创建、处理、完成
     */
    private Object type;

    /**
     * 维修处理的详细说明
     */
    private String content;

    /**
     * 与维修处理相关的图片 URL 数组，以 JSON 格式存储
     */
    private Object images;

    /**
     * 处理该维修记录的人员 ID，关联 users 表的 id
     */
    private Integer handlerId;

    /**
     * 维修记录创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}