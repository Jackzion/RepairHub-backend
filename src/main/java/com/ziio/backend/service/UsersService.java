package com.ziio.backend.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.domain.Users;
import com.ziio.backend.model.request.User.UserLoginRequest;
import com.ziio.backend.model.request.User.UserRegisterRequest;

import jakarta.servlet.http.HttpServletRequest;

/**
* @author Ziio
* @description 针对表【users】的数据库操作Service
* @createDate 2025-03-01 10:48:02
*/
public interface UsersService extends IService<Users> {

    Users register(UserRegisterRequest registerRequest);

    Users login(UserLoginRequest loginRequest , HttpServletRequest request);

    Users getLoginUsers(HttpServletRequest request);
}
