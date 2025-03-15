-- 用户表，用于存储用户的基本信息
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户唯一标识，主键',
                       username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名，用于登录系统，需唯一',
                       password VARCHAR(255) NOT NULL COMMENT '加密存储的用户密码',
                       name VARCHAR(50) COMMENT '用户的真实姓名',
                       avatar VARCHAR(255) COMMENT '用户头像的 URL 地址',
                       role tinyint(4) NOT NULL COMMENT '用户角色，分为管理员、维修人员和普通用户',
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
                         locationDetail VARCHAR(255) COMMENT '设备的详细位置描述',
                         priority ENUM('high', 'medium', 'low') NOT NULL COMMENT '报修工单的优先级，分为高、中、低',
                         description TEXT COMMENT '设备问题的详细描述',
                         status ENUM('pending', 'processing', 'completed') NOT NULL COMMENT '报修工单的状态，分为待处理、处理中、已完成',
                         creatorId INT COMMENT '报修工单的创建人 ID，关联 users 表的 id',
                         maintainerId INT COMMENT '负责处理该工单的维修人员 ID，关联 users 表的 id',
                         images JSON COMMENT '与报修工单相关的图片 URL 数组，以 JSON 格式存储',
                         createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '报修工单创建的时间',
                         updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '报修工单更新的时间，自动更新',
                         FOREIGN KEY (creatorId) REFERENCES users(id),
                         FOREIGN KEY (maintainerId) REFERENCES users(id)
);

-- 维修记录表，跟踪维修工单的处理过程
CREATE TABLE repair_records (
                                id INT AUTO_INCREMENT PRIMARY KEY COMMENT '维修记录的唯一标识，主键',
                                repairId INT NOT NULL COMMENT '关联的报修工单 ID，指向 repairs 表的 id',
                                type ENUM('create', 'process', 'complete') NOT NULL COMMENT '维修记录的类型，分为创建、处理、完成',
                                content TEXT COMMENT '维修处理的详细说明',
                                images JSON COMMENT '与维修处理相关的图片 URL 数组，以 JSON 格式存储',
                                handlerId INT COMMENT '处理该维修记录的人员 ID，关联 users 表的 id',
                                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '维修记录创建的时间',
                                FOREIGN KEY (repairId) REFERENCES repairs(id),
                                FOREIGN KEY (handlerId) REFERENCES users(id)
);

-- 维修评价表，存储用户对维修服务的评价信息
CREATE TABLE repair_ratings (
                                id INT AUTO_INCREMENT PRIMARY KEY COMMENT '维修评价的唯一标识，主键',
                                repairId INT NOT NULL COMMENT '关联的报修工单 ID，指向 repairs 表的 id',
                                score TINYINT COMMENT '用户对维修服务的评分，范围为 1 - 5 分',
                                content TEXT COMMENT '用户对维修服务的评价内容',
                                userId INT COMMENT '进行评价的用户 ID，关联 users 表的 id',
                                createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '维修评价创建的时间',
                                FOREIGN KEY (repairId) REFERENCES repairs(id),
                                FOREIGN KEY (userId) REFERENCES users(id)
);

-- 设备表，管理设备的基本信息
CREATE TABLE equipments (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT '设备的唯一标识，主键',
                            name VARCHAR(50) NOT NULL COMMENT '设备的名称',
                            type VARCHAR(50) COMMENT '设备的类型',
                            model VARCHAR(50) COMMENT '设备的型号',
                            location JSON COMMENT '设备的位置信息，以 JSON 格式存储层级位置',
                            status ENUM('normal', 'maintenance', 'broken') NOT NULL COMMENT '设备的状态，分为正常、维护中、损坏',
                            qrCode VARCHAR(255) COMMENT '设备的二维码信息',
                            description TEXT COMMENT '设备的详细描述',
                            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '设备记录创建的时间',
                            updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '设备记录更新的时间，自动更新'
);

-- 设备维护记录表，记录设备的维护情况
CREATE TABLE equipment_maintenance (
                                       id INT AUTO_INCREMENT PRIMARY KEY COMMENT '设备维护记录的唯一标识，主键',
                                       equipmentId INT NOT NULL COMMENT '关联的设备 ID，指向 equipments 表的 id',
                                       type ENUM('routine', 'repair') NOT NULL COMMENT '设备维护的类型，分为常规维护和维修',
                                       content TEXT COMMENT '设备维护的具体内容',
                                       maintainerId INT COMMENT '进行设备维护的人员 ID，关联 users 表的 id',
                                       createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '设备维护记录创建的时间',
                                       FOREIGN KEY (equipmentId) REFERENCES equipments(id),
                                       FOREIGN KEY (maintainerId) REFERENCES users(id)
);

-- 知识库文章表，存储知识库中的文章信息
CREATE TABLE knowledge_articles (
                                    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '知识库文章的唯一标识，主键',
                                    title VARCHAR(100) NOT NULL COMMENT '文章的标题',
                                    content TEXT COMMENT '文章的富文本内容',
                                    category VARCHAR(50) COMMENT '文章所属的分类',
                                    tags JSON COMMENT '文章的标签数组，以 JSON 格式存储',
                                    authorId INT COMMENT '文章的作者 ID，关联 users 表的 id',
                                    viewCount INT DEFAULT 0 COMMENT '文章的浏览次数，默认为 0',
                                    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '文章创建的时间',
                                    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '文章更新的时间，自动更新',
                                    FOREIGN KEY (authorId) REFERENCES users(id)
);

-- 消息通知表，管理系统的消息通知信息
CREATE TABLE notifications (
                               id INT AUTO_INCREMENT PRIMARY KEY COMMENT '消息通知的唯一标识，主键',
                               type ENUM('repair', 'system', 'message') NOT NULL COMMENT '消息通知的类型，分为报修通知、系统通知、普通消息',
                               title VARCHAR(100) COMMENT '消息通知的标题',
                               content TEXT COMMENT '消息通知的详细内容',
                               senderId INT COMMENT '消息通知的发送者 ID，关联 users 表的 id',
                               receiverId INT COMMENT '消息通知的接收者 ID，关联 users 表的 id',
                               isRead BOOLEAN DEFAULT FALSE COMMENT '消息通知是否已读，默认为未读',
                               createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '消息通知创建的时间',
                               FOREIGN KEY (senderId) REFERENCES users(id),
                               FOREIGN KEY (receiverId) REFERENCES users(id)
);

-- 系统日志表，记录系统的操作和运行日志
CREATE TABLE system_logs (
                             id INT AUTO_INCREMENT PRIMARY KEY COMMENT '系统日志的唯一标识，主键',
                             type ENUM('operation', 'system', 'error') NOT NULL COMMENT '系统日志的类型，分为操作日志、系统日志、错误日志',
                             content TEXT COMMENT '系统日志的详细内容',
                             operatorId INT COMMENT '进行操作的用户 ID，关联 users 表的 id',
                             ip VARCHAR(50) COMMENT '操作的 IP 地址',
                             createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '系统日志创建的时间',
                             FOREIGN KEY (operatorId) REFERENCES users(id)
);

-- 统计数据表，存储系统的各类统计数据
CREATE TABLE statistics (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT '统计数据的唯一标识，主键',
                            date DATE NOT NULL COMMENT '统计数据对应的日期',
                            type ENUM('repair', 'equipment', 'rating') NOT NULL COMMENT '统计数据的类型，分为报修统计、设备统计、评价统计',
                            data JSON COMMENT '统计数据的具体内容，以 JSON 格式存储',
                            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '统计数据创建的时间'
);

-- 位置信息表，管理位置的层级关系和详细信息
CREATE TABLE locations (
                           id INT AUTO_INCREMENT PRIMARY KEY COMMENT '位置信息的唯一标识，主键',
                           parentId INT COMMENT '父级位置的 ID，关联 locations 表的 id，用于构建层级关系',
                           name VARCHAR(50) NOT NULL COMMENT '位置的名称',
                           level INT NOT NULL COMMENT '位置的层级',
                           path VARCHAR(255) COMMENT '位置的路径信息',
                           createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '位置信息创建的时间',
                           FOREIGN KEY (parentId) REFERENCES locations(id)
);

-- 设备类型表，配置设备的类型信息
CREATE TABLE equipment_types (
                                 id INT AUTO_INCREMENT PRIMARY KEY COMMENT '设备类型的唯一标识，主键',
                                 name VARCHAR(50) NOT NULL COMMENT '设备类型的名称',
                                 description TEXT COMMENT '设备类型的详细描述',
                                 icon VARCHAR(255) COMMENT '设备类型对应的图标 URL',
                                 createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '设备类型信息创建的时间'
);

-- 1. users 表（10 个用户）
INSERT INTO users (username, password, name, avatar, role, phone, email, department, isDelete) VALUES
                                                                                                   ('admin001', 'e4e214660b5a4ab7f54b4daccd3d49e0', '张伟', 'http://example.com/avatar/admin001.jpg', 2, '13812345678', 'admin001@university.edu', '信息中心', 0),
                                                                                                   ('admin002', 'e4e214660b5a4ab7f54b4daccd3d49e0', '刘强', 'http://example.com/avatar/admin002.jpg', 2, '13898765432', 'admin002@university.edu', '信息中心', 0),
                                                                                                   ('maintainer001', 'e4e214660b5a4ab7f54b4daccd3d49e0', '李明', 'http://example.com/avatar/maintainer001.jpg', 1, '13987654321', 'maintainer001@university.edu', '后勤部', 0),
                                                                                                   ('maintainer002', 'e4e214660b5a4ab7f54b4daccd3d49e0', '陈浩', 'http://example.com/avatar/maintainer002.jpg', 1, '13911112222', 'maintainer002@university.edu', '后勤部', 0),
                                                                                                   ('maintainer003', 'e4e214660b5a4ab7f54b4daccd3d49e0', '周杰', 'http://example.com/avatar/maintainer003.jpg', 1, '13933334444', 'maintainer003@university.edu', '后勤部', 0),
                                                                                                   ('user001', 'e4e214660b5a4ab7f54b4daccd3d49e0', '王芳', 'http://example.com/avatar/user001.jpg', 0, '13655556666', 'user001@university.edu', '计算机学院', 0),
                                                                                                   ('user002', 'e4e214660b5a4ab7f54b4daccd3d49e0', '赵丽', 'http://example.com/avatar/user002.jpg', 0, '13777778888', 'user002@university.edu', '图书馆', 0),
                                                                                                   ('user003', 'e4e214660b5a4ab7f54b4daccd3d49e0', '孙娜', 'http://example.com/avatar/user003.jpg', 0, '13599990000', 'user003@university.edu', '经济学院', 0),
                                                                                                   ('user004', 'e4e214660b5a4ab7f54b4daccd3d49e0', '杨磊', 'http://example.com/avatar/user004.jpg', 0, '13466667777', 'user004@university.edu', '机械学院', 0),
                                                                                                   ('user005', 'e4e214660b5a4ab7f54b4daccd3d49e0', '徐静', 'http://example.com/avatar/user005.jpg', 0, '13288889999', 'user005@university.edu', '艺术学院', 0);

-- 2. repairs 表（8 个报修工单，location 保留 area 并统一为 "校园"）
INSERT INTO repairs (type, location, locationDetail, priority, description, status, creatorId, maintainerId, images, createdAt) VALUES
('投影仪', '{"building": "教学楼A", "floor": "3楼", "area": "校园"}', '教室东北角投影仪支架', 'high', '投影仪电源无反应，疑似线路故障', 'pending', 6, NULL, '["http://example.com/images/proj1.jpg", "http://example.com/images/proj2.jpg"]', '2025-03-14 09:00:00'),
('空调', '{"building": "宿舍楼B", "floor": "5楼", "area": "校园"}', '靠窗的壁挂式空调', 'medium', '空调制冷效果差，室内温度仍高达28度', 'processing', 7, 3, '["http://example.com/images/ac1.jpg", "http://example.com/images/ac2.jpg"]', '2025-03-13 14:30:00'),
('电脑', '{"building": "实验楼C", "floor": "2楼", "area": "校园"}', '第5号机位桌面电脑', 'low', '电脑开机后蓝屏，显示内存错误', 'completed', 6, 4, '["http://example.com/images/pc1.jpg", "http://example.com/images/pc2.jpg"]', '2025-03-12 10:15:00'),
('水龙头', '{"building": "食堂D", "floor": "1楼", "area": "校园"}', '第三个水龙头', 'high', '水龙头漏水严重，地面已积水', 'processing', 8, 5, '["http://example.com/images/tap1.jpg"]', '2025-03-14 13:00:00'),
('电灯', '{"building": "图书馆E", "floor": "4楼", "area": "校园"}', '靠窗第三排吊灯', 'medium', '电灯闪烁，疑似灯管老化', 'pending', 9, NULL, '["http://example.com/images/light1.jpg"]', '2025-03-14 15:30:00'),
('打印机', '{"building": "行政楼F", "floor": "2楼", "area": "校园"}', '角落的彩色打印机', 'low', '打印机卡纸，无法正常打印', 'completed', 10, 3, '["http://example.com/images/printer1.jpg"]', '2025-03-13 09:45:00'),
('椅子', '{"building": "教学楼A", "floor": "2楼", "area": "校园"}', '第5排第3座', 'low', '椅子靠背断裂', 'processing', 6, 4, '["http://example.com/images/chair1.jpg"]', '2025-03-14 11:00:00'),
('门锁', '{"building": "宿舍楼B", "floor": "3楼", "area": "校园"}', '房间门锁', 'high', '门锁损坏，无法正常开锁', 'pending', 7, NULL, '["http://example.com/images/lock1.jpg"]', '2025-03-15 08:00:00');

-- 3. repair_records 表（12 条记录）
INSERT INTO repair_records (repairId, type, content, images, handlerId, createdAt) VALUES
                                                                                       (1, 'create', '用户提交报修：投影仪电源无反应，疑似线路故障', '["http://example.com/images/proj1.jpg"]', 6, '2025-03-14 09:00:00'),
                                                                                       (2, 'create', '用户提交报修：空调制冷效果差，室内温度仍高达28度', '["http://example.com/images/ac1.jpg"]', 7, '2025-03-13 14:30:00'),
                                                                                       (2, 'process', '维修人员检查：冷凝器脏污严重，已清洗并补充冷媒', '["http://example.com/images/ac2.jpg"]', 3, '2025-03-14 10:00:00'),
                                                                                       (3, 'create', '用户提交报修：电脑开机后蓝屏，显示内存错误', '["http://example.com/images/pc1.jpg"]', 6, '2025-03-12 10:15:00'),
                                                                                       (3, 'process', '维修人员诊断：内存条接触不良，已重新插拔', '["http://example.com/images/pc2.jpg"]', 4, '2025-03-12 13:30:00'),
                                                                                       (3, 'complete', '维修完成：电脑恢复正常运行', '["http://example.com/images/pc3.jpg"]', 4, '2025-03-12 15:00:00'),
                                                                                       (4, 'create', '用户提交报修：水龙头漏水严重，地面已积水', '["http://example.com/images/tap1.jpg"]', 8, '2025-03-14 13:00:00'),
                                                                                       (4, 'process', '维修人员检查：密封圈老化，已更换新密封圈', '["http://example.com/images/tap2.jpg"]', 5, '2025-03-14 14:30:00'),
                                                                                       (5, 'create', '用户提交报修：电灯闪烁，疑似灯管老化', '["http://example.com/images/light1.jpg"]', 9, '2025-03-14 15:30:00'),
                                                                                       (6, 'create', '用户提交报修：打印机卡纸，无法正常打印', '["http://example.com/images/printer1.jpg"]', 10, '2025-03-13 09:45:00'),
                                                                                       (6, 'complete', '维修完成：清除卡纸并测试打印正常', '["http://example.com/images/printer2.jpg"]', 3, '2025-03-13 11:00:00'),
                                                                                       (7, 'create', '用户提交报修：椅子靠背断裂', '["http://example.com/images/chair1.jpg"]', 6, '2025-03-14 11:00:00');

-- 4. repair_ratings 表（5 条评价）
INSERT INTO repair_ratings (repairId, score, content, userId, createdAt) VALUES
                                                                             (3, 5, '维修速度很快，电脑当天就修好了，服务态度也很好！', 6, '2025-03-12 16:00:00'),
                                                                             (2, 4, '空调修好了，制冷效果有所改善，但希望响应速度更快些', 7, '2025-03-14 11:00:00'),
                                                                             (6, 5, '打印机问题解决得非常迅速，感谢维修人员！', 10, '2025-03-13 11:30:00'),
                                                                             (4, 3, '水龙头修好了，但维修过程中有点吵', 8, '2025-03-14 15:00:00'),
                                                                             (7, 4, '椅子修得不错，但建议备一些新椅子替换', 6, '2025-03-14 14:00:00');

-- 5. equipments 表（8 台设备）
INSERT INTO equipments (name, type, model, location, status, qrCode, description, createdAt) VALUES
                                                                                                 ('投影仪A3', '投影仪', 'Epson EB-X41', '{"building": "教学楼A", "floor": 3, "room": "305", "area": "多媒体教室"}', 'broken', 'QR123456', '教室用高清投影仪，支持无线投影', '2025-01-01 08:00:00'),
                                                                                                 ('空调B5', '空调', 'Gree KFR-35GW', '{"building": "宿舍楼B", "floor": 5, "room": "502", "area": "男生宿舍"}', 'maintenance', 'QR789012', '宿舍用壁挂式空调，制冷制热双用', '2025-01-01 08:00:00'),
                                                                                                 ('电脑C2', '电脑', 'Dell OptiPlex 3070', '{"building": "实验楼C", "floor": 2, "room": "Lab201", "area": "计算机实验室"}', 'normal', 'QR345678', '实验室用台式电脑，配置i5处理器', '2025-01-01 08:00:00'),
                                                                                                 ('水龙头D1', '水龙头', 'Moen 123', '{"building": "食堂D", "floor": 1, "room": "洗手间", "area": "东侧洗手池"}', 'maintenance', 'QR901234', '不锈钢水龙头，感应式设计', '2025-01-01 08:00:00'),
                                                                                                 ('吊灯E4', '电灯', 'Philips LED-40W', '{"building": "图书馆E", "floor": 4, "room": "阅览室402", "area": "自习区"}', 'broken', 'QR567890', '节能LED吊灯，亮度可调', '2025-01-01 08:00:00'),
                                                                                                 ('打印机F2', '打印机', 'HP LaserJet Pro M404', '{"building": "行政楼F", "floor": 2, "room": "办公室203", "area": "教师办公室"}', 'normal', 'QR112233', '黑白激光打印机，支持双面打印', '2025-01-01 08:00:00'),
                                                                                                 ('椅子A2', '椅子', 'Generic Classroom Chair', '{"building": "教学楼A", "floor": 2, "room": "201", "area": "阶梯教室"}', 'maintenance', 'QR445566', '教室用靠背椅，木质框架', '2025-01-01 08:00:00'),
                                                                                                 ('门锁B3', '门锁', 'Yale YDM4109', '{"building": "宿舍楼B", "floor": 3, "room": "301", "area": "女生宿舍"}', 'broken', 'QR778899', '智能指纹门锁，支持密码开锁', '2025-01-01 08:00:00');

-- 6. equipment_maintenance 表（10 条记录）
INSERT INTO equipment_maintenance (equipmentId, type, content, maintainerId, createdAt) VALUES
                                                                                            (1, 'repair', '检查投影仪电源模块，疑似烧毁，等待备件更换', 3, '2025-03-14 10:30:00'),
                                                                                            (2, 'routine', '清洗空调滤网和冷凝器，补充冷媒R410A', 3, '2025-03-14 10:00:00'),
                                                                                            (2, 'repair', '检查空调压缩机运行正常，调整风向板', 3, '2025-03-14 10:15:00'),
                                                                                            (3, 'repair', '更换内存条并清理机箱内部灰尘', 4, '2025-03-12 13:30:00'),
                                                                                            (4, 'repair', '更换水龙头密封圈，测试无渗漏', 5, '2025-03-14 14:30:00'),
                                                                                            (5, 'routine', '检查吊灯线路，未发现短路，建议更换灯管', 4, '2025-03-14 16:00:00'),
                                                                                            (6, 'repair', '清理打印机进纸通道，修复卡纸问题', 3, '2025-03-13 10:45:00'),
                                                                                            (7, 'repair', '焊接椅子靠背断裂处，加固底部螺丝', 4, '2025-03-14 12:30:00'),
                                                                                            (8, 'repair', '检查门锁电路，疑似主板故障，需更换', 5, '2025-03-15 09:00:00'),
                                                                                            (3, 'routine', '定期检查电脑硬盘健康状态，运行正常', 4, '2025-03-10 14:00:00');

-- 7. knowledge_articles 表（5 篇文章）
INSERT INTO knowledge_articles (title, content, category, tags, authorId, viewCount, createdAt) VALUES
                                                                                                    ('如何保养空调设备', '定期清洗滤网，每季度检查冷媒量，避免长时间超负荷运行...', '设备维护', '["空调", "保养", "节能"]', 1, 25, '2025-03-10 09:00:00'),
                                                                                                    ('投影仪常见故障排除', '若电源无反应，检查电源线是否松动；若画面模糊，调整镜头焦距...', '故障排除', '["投影仪", "故障", "维修"]', 2, 18, '2025-03-11 14:00:00'),
                                                                                                    ('电脑蓝屏问题解决方法', '蓝屏可能是内存或驱动问题，建议重启后检查硬件连接...', '故障排除', '["电脑", "蓝屏", "硬件"]', 3, 30, '2025-03-12 10:00:00'),
                                                                                                    ('水龙头维护指南', '漏水通常由密封圈老化引起，可自行更换或联系维修人员...', '设备维护', '["水龙头", "漏水", "维护"]', 1, 12, '2025-03-13 15:00:00'),
                                                                                                    ('如何延长电灯寿命', '避免频繁开关，使用LED灯管可显著降低能耗...', '节能建议', '["电灯", "节能", "寿命"]', 2, 8, '2025-03-14 08:30:00');

-- 8. notifications 表（10 条通知）
INSERT INTO notifications (type, title, content, senderId, receiverId, isRead, createdAt) VALUES
                                                                                              ('repair', '新报修工单 #1', '投影仪故障已提交，请尽快安排维修人员处理', 6, 3, FALSE, '2025-03-14 09:05:00'),
                                                                                              ('repair', '新报修工单 #4', '水龙头漏水严重，请立即处理', 8, 5, FALSE, '2025-03-14 13:05:00'),
                                                                                              ('system', '系统维护通知', '系统将于今晚23:00-次日2:00进行维护，请提前保存工作', 1, 6, TRUE, '2025-03-14 08:00:00'),
                                                                                              ('message', '维修进度更新', '空调维修已开始，冷凝器清洗完成', 3, 7, FALSE, '2025-03-14 10:05:00'),
                                                                                              ('repair', '新报修工单 #5', '阅览室电灯闪烁，请安排检查', 9, 4, FALSE, '2025-03-14 15:35:00'),
                                                                                              ('message', '维修完成通知', '电脑蓝屏问题已解决，请验收', 4, 6, TRUE, '2025-03-12 15:05:00'),
                                                                                              ('repair', '新报修工单 #8', '宿舍门锁损坏，请尽快修复', 7, 5, FALSE, '2025-03-15 08:05:00'),
                                                                                              ('system', '用户注册成功', '欢迎新用户徐静加入系统', 1, 10, TRUE, '2025-03-13 09:00:00'),
                                                                                              ('message', '维修进度更新', '椅子靠背已焊接完成，待验收', 4, 6, FALSE, '2025-03-14 12:35:00'),
                                                                                              ('repair', '新报修工单 #6', '打印机卡纸问题已提交，请处理', 10, 3, TRUE, '2025-03-13 09:50:00');

-- 9. system_logs 表（10 条日志）
INSERT INTO system_logs (type, content, operatorId, ip, createdAt) VALUES
                                                                       ('operation', '用户提交报修工单 #1：投影仪故障', 6, '192.168.1.100', '2025-03-14 09:00:00'),
                                                                       ('system', '系统启动成功，版本v2.1.3', NULL, '127.0.0.1', '2025-03-14 08:00:00'),
                                                                       ('error', '用户登录失败：密码错误', 7, '192.168.1.101', '2025-03-13 13:00:00'),
                                                                       ('operation', '维修人员更新工单 #2：空调维修中', 3, '192.168.1.102', '2025-03-14 10:00:00'),
                                                                       ('operation', '用户提交报修工单 #4：水龙头漏水', 8, '192.168.1.103', '2025-03-14 13:00:00'),
                                                                       ('operation', '维修完成工单 #6：打印机卡纸修复', 3, '192.168.1.102', '2025-03-13 11:00:00'),
                                                                       ('system', '数据库备份成功，文件大小120MB', NULL, '127.0.0.1', '2025-03-14 02:00:00'),
                                                                       ('operation', '用户提交评价：工单 #3，评分5', 6, '192.168.1.100', '2025-03-12 16:00:00'),
                                                                       ('error', '文件上传失败：图像超过10MB限制', 9, '192.168.1.104', '2025-03-14 15:40:00'),
                                                                       ('operation', '管理员发布知识库文章：如何保养空调', 1, '192.168.1.105', '2025-03-10 09:00:00');

-- 10. statistics 表（6 条统计数据）
INSERT INTO statistics (date, type, data, createdAt) VALUES
                                                         ('2025-03-14', 'repair', '{"total": 8, "pending": 3, "processing": 3, "completed": 2}', '2025-03-14 18:00:00'),
                                                         ('2025-03-14', 'equipment', '{"normal": 2, "maintenance": 3, "broken": 3}', '2025-03-14 18:00:00'),
                                                         ('2025-03-14', 'rating', '{"average": 4.2, "count": 5, "high": 2, "medium": 3, "low": 0}', '2025-03-14 18:00:00'),
                                                         ('2025-03-13', 'repair', '{"total": 6, "pending": 2, "processing": 2, "completed": 2}', '2025-03-13 18:00:00'),
                                                         ('2025-03-12', 'repair', '{"total": 3, "pending": 1, "processing": 1, "completed": 1}', '2025-03-12 18:00:00'),
                                                         ('2025-03-14', 'equipment', '{"normal": 3, "maintenance": 2, "broken": 3}', '2025-03-14 12:00:00');

-- 11. locations 表（修正后的位置数据）
INSERT INTO locations (parentId, name, level, path, createdAt) VALUES
-- 一级节点：校园（根节点）
(NULL, '校园', 1, '/校园', '2025-01-01 08:00:00'),

-- 二级节点：直接挂在 '校园' (id=1) 下
(1, '教学楼A', 2, '/校园/教学楼A', '2025-01-01 08:00:00'),
(1, '教学楼B', 2, '/校园/教学楼B', '2025-01-01 08:00:00'),
(1, '宿舍楼B', 2, '/校园/宿舍楼B', '2025-01-01 08:00:00'),
(1, '宿舍楼C', 2, '/校园/宿舍楼C', '2025-01-01 08:00:00'),
(1, '实验楼C', 2, '/校园/实验楼C', '2025-01-01 08:00:00'),
(1, '实验楼D', 2, '/校园/实验楼D', '2025-01-01 08:00:00'),
(1, '食堂D', 2, '/校园/食堂D', '2025-01-01 08:00:00'),
(1, '食堂E', 2, '/校园/食堂E', '2025-01-01 08:00:00'),
(1, '图书馆E', 2, '/校园/图书馆E', '2025-01-01 08:00:00'),
(1, '行政楼F', 2, '/校园/行政楼F', '2025-01-01 08:00:00'),

-- 三级节点：教学楼A (id=2) 的子节点
(2, '1楼', 3, '/校园/教学楼A/1楼', '2025-01-01 08:00:00'),
(2, '2楼', 3, '/校园/教学楼A/2楼', '2025-01-01 08:00:00'),
(2, '3楼', 3, '/校园/教学楼A/3楼', '2025-01-01 08:00:00'),
(2, '4楼', 3, '/校园/教学楼A/4楼', '2025-01-01 08:00:00'),
(2, '5楼', 3, '/校园/教学楼A/5楼', '2025-01-01 08:00:00'),

-- 三级节点：教学楼B (id=3) 的子节点
(3, '1楼', 3, '/校园/教学楼B/1楼', '2025-01-01 08:00:00'),
(3, '2楼', 3, '/校园/教学楼B/2楼', '2025-01-01 08:00:00'),
(3, '3楼', 3, '/校园/教学楼B/3楼', '2025-01-01 08:00:00'),
(3, '4楼', 3, '/校园/教学楼B/4楼', '2025-01-01 08:00:00'),
(3, '5楼', 3, '/校园/教学楼B/5楼', '2025-01-01 08:00:00'),

-- 三级节点：宿舍楼B (id=4) 的子节点
(4, '1楼', 3, '/校园/宿舍楼B/1楼', '2025-01-01 08:00:00'),
(4, '2楼', 3, '/校园/宿舍楼B/2楼', '2025-01-01 08:00:00'),
(4, '3楼', 3, '/校园/宿舍楼B/3楼', '2025-01-01 08:00:00'),
(4, '4楼', 3, '/校园/宿舍楼B/4楼', '2025-01-01 08:00:00'),
(4, '5楼', 3, '/校园/宿舍楼B/5楼', '2025-01-01 08:00:00'),

-- 三级节点：宿舍楼C (id=5) 的子节点
(5, '1楼', 3, '/校园/宿舍楼C/1楼', '2025-01-01 08:00:00'),
(5, '2楼', 3, '/校园/宿舍楼C/2楼', '2025-01-01 08:00:00'),
(5, '3楼', 3, '/校园/宿舍楼C/3楼', '2025-01-01 08:00:00'),
(5, '4楼', 3, '/校园/宿舍楼C/4楼', '2025-01-01 08:00:00'),
(5, '5楼', 3, '/校园/宿舍楼C/5楼', '2025-01-01 08:00:00'),

-- 三级节点：实验楼C (id=6) 的子节点
(6, '1楼', 3, '/校园/实验楼C/1楼', '2025-01-01 08:00:00'),
(6, '2楼', 3, '/校园/实验楼C/2楼', '2025-01-01 08:00:00'),
(6, '3楼', 3, '/校园/实验楼C/3楼', '2025-01-01 08:00:00'),
(6, '4楼', 3, '/校园/实验楼C/4楼', '2025-01-01 08:00:00'),
(6, '5楼', 3, '/校园/实验楼C/5楼', '2025-01-01 08:00:00'),

-- 三级节点：实验楼D (id=7) 的子节点
(7, '1楼', 3, '/校园/实验楼D/1楼', '2025-01-01 08:00:00'),
(7, '2楼', 3, '/校园/实验楼D/2楼', '2025-01-01 08:00:00'),
(7, '3楼', 3, '/校园/实验楼D/3楼', '2025-01-01 08:00:00'),
(7, '4楼', 3, '/校园/实验楼D/4楼', '2025-01-01 08:00:00'),
(7, '5楼', 3, '/校园/实验楼D/5楼', '2025-01-01 08:00:00'),

-- 三级节点：食堂D (id=8) 的子节点
(8, '1楼', 3, '/校园/食堂D/1楼', '2025-01-01 08:00:00'),
(8, '2楼', 3, '/校园/食堂D/2楼', '2025-01-01 08:00:00'),

-- 三级节点：食堂E (id=9) 的子节点
(9, '1楼', 3, '/校园/食堂E/1楼', '2025-01-01 08:00:00'),
(9, '2楼', 3, '/校园/食堂E/2楼', '2025-01-01 08:00:00'),

-- 三级节点：图书馆E (id=10) 的子节点
(10, '1楼', 3, '/校园/图书馆E/1楼', '2025-01-01 08:00:00'),
(10, '2楼', 3, '/校园/图书馆E/2楼', '2025-01-01 08:00:00'),
(10, '3楼', 3, '/校园/图书馆E/3楼', '2025-01-01 08:00:00'),

-- 三级节点：行政楼F (id=11) 的子节点
(11, '1楼', 3, '/校园/行政楼F/1楼', '2025-01-01 08:00:00'),
(11, '2楼', 3, '/校园/行政楼F/2楼', '2025-01-01 08:00:00'),
(11, '3楼', 3, '/校园/行政楼F/3楼', '2025-01-01 08:00:00');

-- 12. equipment_types 表（6 种设备类型）
INSERT INTO equipment_types (name, description, icon, createdAt) VALUES
                                                                     ('投影仪', '用于教学的多媒体投影设备，支持高清投影', 'http://example.com/icons/projector.png', '2025-01-01 08:00:00'),
                                                                     ('空调', '宿舍或办公室用空调，提供制冷制热功能', 'http://example.com/icons/ac.png', '2025-01-01 08:00:00'),
                                                                     ('电脑', '实验室或办公室用台式电脑，适合编程和办公', 'http://example.com/icons/pc.png', '2025-01-01 08:00:00'),
                                                                     ('水龙头', '卫生间或厨房用节水型水龙头', 'http://example.com/icons/tap.png', '2025-01-01 08:00:00'),
                                                                     ('电灯', '节能型照明设备，适用于教室和公共区域', 'http://example.com/icons/light.png', '2025-01-01 08:00:00'),
                                                                     ('打印机', '黑白或彩色打印机，支持网络打印', 'http://example.com/icons/printer.png', '2025-01-01 08:00:00');