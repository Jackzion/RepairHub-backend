package com.ziio.backend.model.request;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.util.Date;

@Data
public class EquipmentAddRequest {

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
     * 设备的状态，分为'normal','maintenance','broken'
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

}
