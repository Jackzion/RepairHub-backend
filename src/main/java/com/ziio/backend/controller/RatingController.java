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
import com.ziio.backend.service.NotificationsService;
import com.ziio.backend.service.RepairRatingsService;
import com.ziio.backend.service.UsersService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

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
}