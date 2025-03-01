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
 * @TableName users
 */
@TableName(value ="users")
@Data
public class Users implements Serializable {
    /**
     * 用户唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 用户名，用于登录系统，需唯一
     */
    private String username;

    /**
     * 加密存储的用户密码
     */
    private String password;

    /**
     * 用户的真实姓名
     */
    private String name;

    /**
     * 用户头像的 URL 地址
     */
    private String avatar;

    /**
     *  用户的角色，0 表示user，1 maintainer,2 admin
     */
    private Integer role;

    /**
     * 用户的联系电话
     */
    private String phone;

    /**
     * 用户的电子邮箱地址
     */
    private String email;

    /**
     * 用户所在的部门
     */
    private String department;

    /**
     * 用户记录创建的时间
     */
    private Date createdAt;

    /**
     * 用户记录更新的时间，自动更新
     */
    private Date updatedAt;

    /**
     * 逻辑删除字段，默认为 0，表示未删除，1 表示已删除
     */
    private Integer isDelete;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}