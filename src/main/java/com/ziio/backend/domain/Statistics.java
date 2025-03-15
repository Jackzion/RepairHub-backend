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
 * @TableName statistics
 */
@TableName(value ="statistics")
@Data
public class Statistics implements Serializable {
    /**
     * 统计数据的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 统计数据对应的日期
     */
    private Date date;

    /**
     * 统计数据的类型，分为报修统计、设备统计、评价统计
     */
    private Object type;

    /**
     * 统计数据的具体内容，以 JSON 格式存储
     */
    private Object data;

    /**
     * 统计数据创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}