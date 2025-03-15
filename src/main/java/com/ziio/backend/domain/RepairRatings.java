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
 * @TableName repair_ratings
 */
@TableName(value ="repair_ratings")
@Data
public class RepairRatings implements Serializable {
    /**
     * 维修评价的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 关联的报修工单 ID，指向 repairs 表的 id
     */
    private Integer repairId;

    /**
     * 用户对维修服务的评分，范围为 1 - 5 分
     */
    private Integer score;

    /**
     * 用户对维修服务的评价内容
     */
    private String content;

    /**
     * 进行评价的用户 ID，关联 users 表的 id
     */
    private Integer userId;

    /**
     * 维修评价创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}