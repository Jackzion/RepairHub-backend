package com.ziio.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.CommonConstant;
import com.ziio.backend.common.ErrorCode;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.domain.Users;
import com.ziio.backend.exception.BusinessException;
import com.ziio.backend.model.enums.UserRoleEnum;
import com.ziio.backend.model.request.User.BanUserRequest;
import com.ziio.backend.model.request.User.UpdateUserRequest;
import com.ziio.backend.model.request.User.UserLoginRequest;
import com.ziio.backend.model.request.User.UserRegisterRequest;
import com.ziio.backend.service.UsersService;

import cn.hutool.core.bean.BeanUtil;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;



@RestController
@RequestMapping("/user")
@Slf4j
public class UserController {

    @Resource
    UsersService usersService;

    // 用户注册
    @PostMapping("/register")
    public BaseResponse<Users> userRegister(@RequestBody UserRegisterRequest userRegisterRequest){
        if (userRegisterRequest == null) {
            return ResultUtils.error(ErrorCode.PARAMS_ERROR);
        }
        Users user = usersService.register(userRegisterRequest);
        return ResultUtils.success(user);
    }

    // 用户登录
    @PostMapping("/login")
    public BaseResponse<Users> userLogin(@RequestBody UserLoginRequest userLoginRequest , HttpServletRequest request){
        if (userLoginRequest == null) {
            return ResultUtils.error(ErrorCode.PARAMS_ERROR);
        }
        Users user = usersService.login(userLoginRequest,request);
        return ResultUtils.success(user);
    }

    /**
     * 用户注销
     *
     * @param request
     * @return
     */
    @PostMapping("/logout")
    public BaseResponse<Boolean> userLogout(HttpServletRequest request) {
        if (request == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        if (request.getSession().getAttribute(CommonConstant.SESSION_KEY) == null) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "未登录");
        }
        // 移除登录态
        request.getSession().removeAttribute(CommonConstant.SESSION_KEY);
        return ResultUtils.success(true);
    }

    /**
     * 获取当前登录用户
     *
     * @param request
     * @return
     */
    @GetMapping("/get/login")
    public BaseResponse<Users> getLoginUser(HttpServletRequest request) {
        Users user = usersService.getLoginUsers(request);
        return ResultUtils.success(user);
    }

    /**
     * 修改用户信息
     */
    @PostMapping("/ban")
    public BaseResponse<Boolean> banUser(@RequestBody BanUserRequest banUserRequest) {
        // 查询用户
        Users user = usersService.getById(banUserRequest.getId());
        if (user == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        // ban 用户
        user.setRole(UserRoleEnum.BAN.getValue());
        return ResultUtils.success(true);
    }

    /**
     * 修改用户信息
     */
    @PostMapping("/update")
    public BaseResponse<Boolean> updateUser(@RequestBody UpdateUserRequest updateUserRequest) {
        // 查询用户
        Users user = usersService.getById(updateUserRequest.getId());
        if (user == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        BeanUtil.copyProperties(updateUserRequest, user);
        return ResultUtils.success(true);
    }
}
