package com.ziio.backend.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ziio.backend.common.CommonConstant;
import com.ziio.backend.common.ErrorCode;
import com.ziio.backend.exception.BusinessException;
import com.ziio.backend.mapper.UsersMapper;
import com.ziio.backend.model.enums.UserRoleEnum;
import com.ziio.backend.model.request.UserLoginRequest;
import com.ziio.backend.model.request.UserRegisterRequest;
import com.ziio.backend.service.UsersService;
import com.ziio.backend.domain.Users;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;


/**
* @author Ziio
* @description 针对表【users】的数据库操作Service实现
* @createDate 2025-03-01 10:48:02
*/
@Service
public class UsersServiceImpl extends ServiceImpl<UsersMapper, Users>
    implements UsersService {

    /**
     * 盐值，混淆密码
     */
    public static final String SALT = "ziio";

    @Override
    public Users register(UserRegisterRequest userRegisterRequest) {
        String username = userRegisterRequest.getUsername();
        String password = userRegisterRequest.getPassword();
        Integer role = userRegisterRequest.getRole();
        // 检验
        if (StringUtils.isAnyBlank(username, password)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "参数为空");
        }
        if (username.length() < 4 ) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "username.length() < 4 ");
        }
        if (password.length() < 6 ) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "password.length() < 6");
        }
        // 账号不可重复
        synchronized (username.intern()) {
            // 账户不能重复
            QueryWrapper<Users> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("userAccount", username);
            long count = this.baseMapper.selectCount(queryWrapper);
            if (count > 0) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "账号重复");
            }
            // 2. 加密
            String encryptPassword = DigestUtils.md5DigestAsHex((SALT + password).getBytes());
            // 3. 插入数据
            Users user = new Users();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);
            boolean saveResult = this.save(user);
            if (!saveResult) {
                throw new BusinessException(ErrorCode.SYSTEM_ERROR, "注册失败，数据库错误");
            }
            return user;
        }
    }

    @Override
    public Users login(UserLoginRequest userLoginRequest , HttpServletRequest request) {
        // 检验并设置session
        if (userLoginRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "请求参数为空");
        }
        String username = userLoginRequest.getUsername();
        String password = userLoginRequest.getPassword();
        if (StringUtils.isAnyBlank(username, password)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "请求参数为空");
        }
        QueryWrapper<Users> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        Users user = this.baseMapper.selectOne(queryWrapper);
        if (user == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        String encryptPassword = DigestUtils.md5DigestAsHex((SALT + password).getBytes());
        if (!user.getPassword().equals(encryptPassword)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "密码错误");
        }
        request.getSession().setAttribute(CommonConstant.SESSION_KEY, user.getId());
        return user;
    }
}




