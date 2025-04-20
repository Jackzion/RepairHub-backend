package com.ziio.backend.model.request;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.util.Date;

@Data
public class EquipmentUpdateRequest {

    // id
    private Integer id;

    /**
     * 设备的型号
     */
    private String model;

    /**
     * 设备的位置信息，以 JSON 格式存储层级位置
     */
    private Object location;

    /**
     * 设备的状态，分为'normal','maintenance','broken'
     */
    private Object status;

    /**
     * 设备的详细描述
     */
    private String description;

}
