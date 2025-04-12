package com.ziio.backend.model.vo;

import lombok.Data;

@Data
public class RepairsStatistics {
    /**
     * 待处理工单数量
     */
    private Integer pending = 0;

    /**
     * 处理中工单数量
     */
    private Integer processing = 0;

    /**
     * 已完成工单数量
     */
    private Integer completed = 0;

    /**
     * 待处理工单百分比
     */
    private Integer pendingPercentage = 0;

    /**
     * 处理中工单百分比
     */
    private Integer processingPercentage = 0;

    /**
     * 已完成工单百分比
     */
    private Integer completedPercentage = 0;
}