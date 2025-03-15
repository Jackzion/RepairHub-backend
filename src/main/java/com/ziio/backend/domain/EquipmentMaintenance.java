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
 * @TableName equipment_maintenance
 */
@TableName(value ="equipment_maintenance")
@Data
public class EquipmentMaintenance implements Serializable {
    /**
     * 设备维护记录的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 关联的设备 ID，指向 equipments 表的 id
     */
    private Integer equipmentId;

    /**
     * 设备维护的类型，分为常规维护和维修
     */
    private Object type;

    /**
     * 设备维护的具体内容
     */
    private String content;

    /**
     * 进行设备维护的人员 ID，关联 users 表的 id
     */
    private Integer maintainerId;

    /**
     * 设备维护记录创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}