package com.ziio.backend.model.vo;

import com.ziio.backend.domain.RepairRatings;
import com.ziio.backend.domain.Repairs;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class RatingResVo {

    // 数据
    private List<RepairRatings> ratingsList;

    // 统计结果
    private double averageScore;

    private int totalRatings;

    private int satisfactionRate;

    private List<RatingDistribution> ratingDistribution = new ArrayList<>();

    // 评分分布实体类
    @Data
    public static
    class RatingDistribution {
        private int rating;
        private int count;
        private double percentage;
    }
}
