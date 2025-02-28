-- 用户表，用于存储用户的基本信息
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户唯一标识，主键',
                       username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名，用于登录系统，需唯一',
                       password VARCHAR(255) NOT NULL COMMENT '加密存储的用户密码',
                       name VARCHAR(50) COMMENT '用户的真实姓名',
                       avatar VARCHAR(255) COMMENT '用户头像的 URL 地址',
                       role ENUM('admin','maintainer', 'user') NOT NULL COMMENT '用户角色，分为管理员、维修人员和普通用户',
                       phone VARCHAR(20) COMMENT '用户的联系电话',
                       email VARCHAR(100) COMMENT '用户的电子邮箱地址',
                       department VARCHAR(50) COMMENT '用户所在的部门',
                       createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '用户记录创建的时间',
                       updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '用户记录更新的时间，自动更新',
                       isDelete TINYINT DEFAULT 0 COMMENT '逻辑删除字段，默认为 0，表示未删除，1 表示已删除'
);

-- 报修工单表，记录报修工单的详细信息
CREATE TABLE repairs (
                         id INT AUTO_INCREMENT PRIMARY KEY COMMENT '报修工单的唯一标识，主键',
                         type VARCHAR(50) COMMENT '报修设备的类型',
                         location JSON COMMENT '设备的位置信息，以 JSON 格式存储层级位置',
                         location_detail VARCHAR(255) COMMENT '设备的详细位置描述',
                         priority ENUM('high','medium', 'low') NOT NULL COMMENT '报修工单的优先级，分为高、中、低',
                         description TEXT COMMENT '设备问题的详细描述',
                         status ENUM('pending', 'processing', 'completed') NOT NULL COMMENT '报修工单的状态，分为待处理、处理中、已完成',
                         creator_id INT COMMENT '报修工单的创建人 ID，关联 users 表的 id',
                         maintainer_id INT COMMENT '负责处理该工单的维修人员 ID，关联 users 表的 id',
                         images JSON COMMENT '与报修工单相关的图片 URL 数组，以 JSON 格式存储',
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '报修工单创建的时间',
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报修工单更新的时间，自动更新',
                         FOREIGN KEY (creator_id) REFERENCES users(id) COMMENT '外键关联，指向创建该工单的用户',
                         FOREIGN KEY (maintainer_id) REFERENCES users(id) COMMENT '外键关联，指向处理该工单的维修人员'
);

-- 维修记录表，跟踪维修工单的处理过程
CREATE TABLE repair_records (
                                id INT AUTO_INCREMENT PRIMARY KEY COMMENT '维修记录的唯一标识，主键',
                                repair_id INT NOT NULL COMMENT '关联的报修工单 ID，指向 repairs 表的 id',
                                type ENUM('create', 'process', 'complete') NOT NULL COMMENT '维修记录的类型，分为创建、处理、完成',
                                content TEXT COMMENT '维修处理的详细说明',
                                images JSON COMMENT '与维修处理相关的图片 URL 数组，以 JSON 格式存储',
                                handler_id INT COMMENT '处理该维修记录的人员 ID，关联 users 表的 id',
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '维修记录创建的时间',
                                FOREIGN KEY (repair_id) REFERENCES repairs(id) COMMENT '外键关联，指向对应的报修工单',
                                FOREIGN KEY (handler_id) REFERENCES users(id) COMMENT '外键关联，指向处理该记录的用户'
);

-- 维修评价表，存储用户对维修服务的评价信息
CREATE TABLE repair_ratings (
                                id INT AUTO_INCREMENT PRIMARY KEY COMMENT '维修评价的唯一标识，主键',
                                repair_id INT NOT NULL COMMENT '关联的报修工单 ID，指向 repairs 表的 id',
                                score TINYINT CHECK (score BETWEEN 1 AND 5) COMMENT '用户对维修服务的评分，范围为 1 - 5 分',
                                content TEXT COMMENT '用户对维修服务的评价内容',
                                user_id INT COMMENT '进行评价的用户 ID，关联 users 表的 id',
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '维修评价创建的时间',
                                FOREIGN KEY (repair_id) REFERENCES repairs(id) COMMENT '外键关联，指向对应的报修工单',
                                FOREIGN KEY (user_id) REFERENCES users(id) COMMENT '外键关联，指向进行评价的用户'
);

-- 设备表，管理设备的基本信息
CREATE TABLE equipments (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT '设备的唯一标识，主键',
                            name VARCHAR(50) NOT NULL COMMENT '设备的名称',
                            type VARCHAR(50) COMMENT '设备的类型',
                            model VARCHAR(50) COMMENT '设备的型号',
                            location JSON COMMENT '设备的位置信息，以 JSON 格式存储层级位置',
                            status ENUM('normal','maintenance', 'broken') NOT NULL COMMENT '设备的状态，分为正常、维护中、损坏',
                            qr_code VARCHAR(255) COMMENT '设备的二维码信息',
                            description TEXT COMMENT '设备的详细描述',
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '设备记录创建的时间',
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '设备记录更新的时间，自动更新'
);

-- 设备维护记录表，记录设备的维护情况
CREATE TABLE equipment_maintenance (
                                       id INT AUTO_INCREMENT PRIMARY KEY COMMENT '设备维护记录的唯一标识，主键',
                                       equipment_id INT NOT NULL COMMENT '关联的设备 ID，指向 equipments 表的 id',
                                       type ENUM('routine','repair') NOT NULL COMMENT '设备维护的类型，分为常规维护和维修',
                                       content TEXT COMMENT '设备维护的具体内容',
                                       maintainer_id INT COMMENT '进行设备维护的人员 ID，关联 users 表的 id',
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '设备维护记录创建的时间',
                                       FOREIGN KEY (equipment_id) REFERENCES equipments(id) COMMENT '外键关联，指向对应的设备',
                                       FOREIGN KEY (maintainer_id) REFERENCES users(id) COMMENT '外键关联，指向进行维护的维修人员'
);

-- 知识库文章表，存储知识库中的文章信息
CREATE TABLE knowledge_articles (
                                    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '知识库文章的唯一标识，主键',
                                    title VARCHAR(100) NOT NULL COMMENT '文章的标题',
                                    content TEXT COMMENT '文章的富文本内容',
                                    category VARCHAR(50) COMMENT '文章所属的分类',
                                    tags JSON COMMENT '文章的标签数组，以 JSON 格式存储',
                                    author_id INT COMMENT '文章的作者 ID，关联 users 表的 id',
                                    view_count INT DEFAULT 0 COMMENT '文章的浏览次数，默认为 0',
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '文章创建的时间',
                                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '文章更新的时间，自动更新',
                                    FOREIGN KEY (author_id) REFERENCES users(id) COMMENT '外键关联，指向文章的作者'
);

-- 消息通知表，管理系统的消息通知信息
CREATE TABLE notifications (
                               id INT AUTO_INCREMENT PRIMARY KEY COMMENT '消息通知的唯一标识，主键',
                               type ENUM('repair','system','message') NOT NULL COMMENT '消息通知的类型，分为报修通知、系统通知、普通消息',
                               title VARCHAR(100) COMMENT '消息通知的标题',
                               content TEXT COMMENT '消息通知的详细内容',
                               sender_id INT COMMENT '消息通知的发送者 ID，关联 users 表的 id',
                               receiver_id INT COMMENT '消息通知的接收者 ID，关联 users 表的 id',
                               read BOOLEAN DEFAULT FALSE COMMENT '消息通知是否已读，默认为未读',
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '消息通知创建的时间',
                               FOREIGN KEY (sender_id) REFERENCES users(id) COMMENT '外键关联，指向消息的发送者',
                               FOREIGN KEY (receiver_id) REFERENCES users(id) COMMENT '外键关联，指向消息的接收者'
);

-- 系统日志表，记录系统的操作和运行日志
CREATE TABLE system_logs (
                             id INT AUTO_INCREMENT PRIMARY KEY COMMENT '系统日志的唯一标识，主键',
                             type ENUM('operation','system', 'error') NOT NULL COMMENT '系统日志的类型，分为操作日志、系统日志、错误日志',
                             content TEXT COMMENT '系统日志的详细内容',
                             operator_id INT COMMENT '进行操作的用户 ID，关联 users 表的 id',
                             ip VARCHAR(50) COMMENT '操作的 IP 地址',
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '系统日志创建的时间',
                             FOREIGN KEY (operator_id) REFERENCES users(id) COMMENT '外键关联，指向进行操作的用户'
);

-- 统计数据表，存储系统的各类统计数据
CREATE TABLE statistics (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT '统计数据的唯一标识，主键',
                            date DATE NOT NULL COMMENT '统计数据对应的日期',
                            type ENUM('repair', 'equipment', 'rating') NOT NULL COMMENT '统计数据的类型，分为报修统计、设备统计、评价统计',
                            data JSON COMMENT '统计数据的具体内容，以 JSON 格式存储',
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '统计数据创建的时间'
);

-- 位置信息表，管理位置的层级关系和详细信息
CREATE TABLE locations (
                           id INT AUTO_INCREMENT PRIMARY KEY COMMENT '位置信息的唯一标识，主键',
                           parent_id INT COMMENT '父级位置的 ID，关联 locations 表的 id，用于构建层级关系',
                           name VARCHAR(50) NOT NULL COMMENT '位置的名称',
                           level INT NOT NULL COMMENT '位置的层级',
                           path VARCHAR(255) COMMENT '位置的路径信息',
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '位置信息创建的时间',
                           FOREIGN KEY (parent_id) REFERENCES locations(id) COMMENT '外键关联，指向父级位置'
);

-- 设备类型表，配置设备的类型信息
CREATE TABLE equipment_types (
                                 id INT AUTO_INCREMENT PRIMARY KEY COMMENT '设备类型的唯一标识，主键',
                                 name VARCHAR(50) NOT NULL COMMENT '设备类型的名称',
                                 description TEXT COMMENT '设备类型的详细描述',
                                 icon VARCHAR(255) COMMENT '设备类型对应的图标 URL',
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '设备类型信息创建的时间'
);