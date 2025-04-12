package com.ziio.backend.model.request;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
public class AddRatingRequest {

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

}
