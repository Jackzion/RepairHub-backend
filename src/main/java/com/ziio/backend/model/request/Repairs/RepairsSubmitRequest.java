package com.ziio.backend.model.request.Repairs;
import lombok.Data;

import java.io.Serializable;

@Data
public class RepairsSubmitRequest implements Serializable {
    /**
     * 报修设备的类型
     */
    private String type;

    /**
     * 设备的位置信息，以 JSON 格式存储层级位置
     */
    private Object location;

    /**
     * 设备的详细位置描述
     */
    private String locationDetail;

    /**
     * 报修工单的优先级，分为高、中、低
     */
    private Object priority;

    /**
     * 设备问题的详细描述
     */
    private String description;

    /**
     * 报修工单的状态，分为待处理、处理中、已完成
     */
    private Object status;

    /**
     * 报修工单的创建人 ID，关联 users 表的 id
     */
    private Integer creatorId;

    /**
     * 负责处理该工单的维修人员 ID，关联 users 表的 id
     */
    private Integer maintainerId;

    /**
     * 与报修工单相关的图片 URL 数组，以 JSON 格式存储
     */
    private Object images;

    private static final long serialVersionUID = 1L;
}