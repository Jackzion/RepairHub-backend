package com.ziio.backend.model.request;

import lombok.Data;

@Data
public class UserLoginRequest {

    private String username;

    private String password;

    private String role;

}
