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
 * @TableName locations
 */
@TableName(value ="locations")
@Data
public class Locations implements Serializable {
    /**
     * 位置信息的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 父级位置的 ID，关联 locations 表的 id，用于构建层级关系
     */
    private Integer parentId;

    /**
     * 位置的名称
     */
    private String name;

    /**
     * 位置的层级
     */
    private Integer level;

    /**
     * 位置的路径信息
     */
    private String path;

    /**
     * 位置信息创建的时间
     */
    private Date createdAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}