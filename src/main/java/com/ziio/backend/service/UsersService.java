package com.ziio.backend.service;

import com.ziio.backend.domain.Users;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ziio.backend.model.request.UserLoginRequest;
import com.ziio.backend.model.request.UserRegisterRequest;

import javax.servlet.http.HttpServletRequest;

/**
* @author Ziio
* @description 针对表【users】的数据库操作Service
* @createDate 2025-03-01 10:48:02
*/
public interface UsersService extends IService<Users> {

    Users register(UserRegisterRequest registerRequest);

    Users login(UserLoginRequest loginRequest , HttpServletRequest request);

}
