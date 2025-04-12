package com.ziio.backend.model.vo;

import com.ziio.backend.domain.Repairs;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class RepairsResVo {

    // 数据
    private List<Repairs> repairsList;

    // 统计结果
    private RepairsStatistics repairsStatistics;

}
