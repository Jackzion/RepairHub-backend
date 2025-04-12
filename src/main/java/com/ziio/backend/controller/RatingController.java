package com.ziio.backend.controller;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.domain.Notifications;
import com.ziio.backend.domain.RepairRatings;
import com.ziio.backend.model.request.AddNotificationRequest;
import com.ziio.backend.model.request.AddRatingRequest;
import com.ziio.backend.model.vo.RatingResVo;
import com.ziio.backend.service.NotificationsService;
import com.ziio.backend.service.RepairRatingsService;
import com.ziio.backend.service.UsersService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.TemporalAdjusters;
import java.util.List;


@RestController
@RequestMapping("/rating")
@Slf4j
public class RatingController {

    @Resource
    private RepairRatingsService repairRatingsService;

    // 添加评分
    @PutMapping("/add")
    public BaseResponse<Boolean> addRating(@RequestBody AddRatingRequest request) {
        RepairRatings repairRatings = new RepairRatings();
        BeanUtil.copyProperties(request, repairRatings);
        return ResultUtils.success(repairRatingsService.save(repairRatings));
    }

    // 判断是否已经存在 rating
    @GetMapping("/exist")
    public BaseResponse<Boolean> isExistRating(@RequestParam Integer repairId) {
        RepairRatings repairRatings = repairRatingsService.getOne(new LambdaQueryWrapper<RepairRatings>().eq(RepairRatings::getRepairId,repairId));
        return ResultUtils.success(repairRatings != null);
    }

    // 评价统计
    @GetMapping("/statistics")
    public BaseResponse<RatingResVo> getRatingStatistics(@RequestParam String timeRange) {
        RatingResVo ratingResVo = new RatingResVo();

        LambdaQueryWrapper<RepairRatings> queryWrapper = new LambdaQueryWrapper<>();
        LocalDate now = LocalDate.now();
        if ("year".equals(timeRange)) {
            // 筛选出今年的数据
            int currentYear = now.getYear();
            LocalDate startOfYear = LocalDate.of(currentYear, 1, 1);
            LocalDate endOfYear = LocalDate.of(currentYear, 12, 31);
            queryWrapper.between(RepairRatings::getCreatedAt, startOfYear, endOfYear);
        } else if ("month".equals(timeRange)) {
            // 筛选出本月的数据
            YearMonth currentMonth = YearMonth.from(now);
            LocalDate startOfMonth = currentMonth.atDay(1);
            LocalDate endOfMonth = currentMonth.atEndOfMonth();
            queryWrapper.between(RepairRatings::getCreatedAt, startOfMonth, endOfMonth);
        } else if ("week".equals(timeRange)) {
            // 筛选出本周的数据
            LocalDate startOfWeek = now.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
            LocalDate endOfWeek = now.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
            queryWrapper.between(RepairRatings::getCreatedAt, startOfWeek, endOfWeek);
        }
        List<RepairRatings> list = repairRatingsService.list(queryWrapper);
        ratingResVo.setRatingsList(list);
        ratingResVo.setTotalRatings(list.size());

        // 平均评分
        int totalScore = 0;
        for (RepairRatings rating : list) {
            totalScore += rating.getScore();
        }
        if (ratingResVo.getTotalRatings() > 0) {
            // 取一位小数
            ratingResVo.setAverageScore(Math.round((double) totalScore / ratingResVo.getTotalRatings() * 10) / 10.0);
        }
        // 满意度 ： 平均评分/5.0 , 取百分比
        if (ratingResVo.getAverageScore() > 0) {
            ratingResVo.setSatisfactionRate((int) (ratingResVo.getAverageScore() / 5.0 * 100));
        }

        // 评分分布
        for (int i = 1; i <= 5; i++) {
            int count = 0;
            for (RepairRatings rating : list) {
                if (rating.getScore() == i) {
                    count++;
                }
            }
            RatingResVo.RatingDistribution distribution = new RatingResVo.RatingDistribution();
            distribution.setRating(i);
            distribution.setCount(count);
            if(count == 0){
                distribution.setPercentage(0.0);
            }else{
                // 取百分比小数点一位
                distribution.setPercentage(Math.round((double) count / ratingResVo.getTotalRatings() * 1000) / 10.0);
            }
            ratingResVo.getRatingDistribution().add(distribution);
        }

        return ResultUtils.success(ratingResVo);
    }
}