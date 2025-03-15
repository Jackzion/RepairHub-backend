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
 * @TableName equipment_types
 */
@TableName(value ="equipment_types")
@Data
public class EquipmentTypes implements Serializable {
    /**
     * 设备类型的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 设备类型的名称
     */
    private String name;

    /**
     * 设备类型的详细描述
     */
    private String description;

    /**
     * 设备类型对应的图标 URL
     */
    private String icon;

    /**
     * 设备类型信息创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}