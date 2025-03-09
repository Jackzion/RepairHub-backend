package com.ziio.backend.model.request;

import lombok.Data;

@Data
public class UserRegisterRequest {

    private String username;

    private String password;
    private String name;
    private String phone;
    private String department;

    private Integer role;
}
