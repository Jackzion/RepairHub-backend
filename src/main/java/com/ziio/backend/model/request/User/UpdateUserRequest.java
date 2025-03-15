package com.ziio.backend.model.request.User;

import lombok.Data;

import java.io.Serializable;

@Data
public class UpdateUserRequest implements Serializable {

    private Integer id;

    /**
     * 用户的真实姓名
     */
    private String name;

    /**
     * 用户头像的 URL 地址
     */
    private String avatar;


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


    private static final long serialVersionUID = 1L;
}