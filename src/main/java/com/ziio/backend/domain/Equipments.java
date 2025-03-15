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
 * @TableName equipments
 */
@TableName(value ="equipments")
@Data
public class Equipments implements Serializable {
    /**
     * 设备的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 设备的名称
     */
    private String name;

    /**
     * 设备的类型
     */
    private String type;

    /**
     * 设备的型号
     */
    private String model;

    /**
     * 设备的位置信息，以 JSON 格式存储层级位置
     */
    private Object location;

    /**
     * 设备的状态，分为正常、维护中、损坏
     */
    private Object status;

    /**
     * 设备的二维码信息
     */
    private String qrCode;

    /**
     * 设备的详细描述
     */
    private String description;

    /**
     * 设备记录创建的时间
     */
    private Date createdAt;

    /**
     * 设备记录更新的时间，自动更新
     */
    private Date updatedAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}