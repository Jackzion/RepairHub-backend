package com.ziio.backend.model.enums;
import cn.hutool.core.util.ObjectUtil;

import java.util.Arrays;

/**
 * 用户角色枚举
 */
public enum UserRoleEnum {
    USER(1),
    MAINTAINER(3),
    ADMIN(2),
    BAN(4);

    private int value;

    UserRoleEnum(int i) {
        this.value = i;
    }

    /**
     * 根据值获得枚举对象
     */
    public static UserRoleEnum getEnumByValue(Integer value) {
        if (ObjectUtil.isNull(value)) {
            return null;
        }
        return Arrays.stream(values()).filter(item -> item.value == value).findFirst().orElse(null);
    }

    public int getValue() {
        return value;
    }
}
