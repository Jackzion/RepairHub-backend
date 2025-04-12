/*
 Navicat Premium Data Transfer

 Source Server         : demo
 Source Server Type    : MySQL
 Source Server Version : 50724
 Source Host           : localhost:3306
 Source Schema         : repaire_hub

 Target Server Type    : MySQL
 Target Server Version : 50724
 File Encoding         : 65001

 Date: 12/04/2025 21:23:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for equipment_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `equipment_maintenance`;
CREATE TABLE `equipment_maintenance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备维护记录的唯一标识，主键',
  `equipmentId` int(11) NOT NULL COMMENT '关联的设备 ID，指向 equipments 表的 id',
  `type` enum('routine','repair') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备维护的类型，分为常规维护和维修',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '设备维护的具体内容',
  `maintainerId` int(11) NULL DEFAULT NULL COMMENT '进行设备维护的人员 ID，关联 users 表的 id',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '设备维护记录创建的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `equipmentId`(`equipmentId`) USING BTREE,
  INDEX `maintainerId`(`maintainerId`) USING BTREE,
  CONSTRAINT `equipment_maintenance_ibfk_1` FOREIGN KEY (`equipmentId`) REFERENCES `equipments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `equipment_maintenance_ibfk_2` FOREIGN KEY (`maintainerId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipment_maintenance
-- ----------------------------
INSERT INTO `equipment_maintenance` VALUES (1, 1, 'repair', '检查投影仪电源模块，疑似烧毁，等待备件更换', 3, '2025-03-14 10:30:00');
INSERT INTO `equipment_maintenance` VALUES (2, 2, 'routine', '清洗空调滤网和冷凝器，补充冷媒R410A', 3, '2025-03-14 10:00:00');
INSERT INTO `equipment_maintenance` VALUES (3, 2, 'repair', '检查空调压缩机运行正常，调整风向板', 3, '2025-03-14 10:15:00');
INSERT INTO `equipment_maintenance` VALUES (4, 3, 'repair', '更换内存条并清理机箱内部灰尘', 4, '2025-03-12 13:30:00');
INSERT INTO `equipment_maintenance` VALUES (5, 4, 'repair', '更换水龙头密封圈，测试无渗漏', 5, '2025-03-14 14:30:00');
INSERT INTO `equipment_maintenance` VALUES (6, 5, 'routine', '检查吊灯线路，未发现短路，建议更换灯管', 4, '2025-03-14 16:00:00');
INSERT INTO `equipment_maintenance` VALUES (7, 6, 'repair', '清理打印机进纸通道，修复卡纸问题', 3, '2025-03-13 10:45:00');
INSERT INTO `equipment_maintenance` VALUES (8, 7, 'repair', '焊接椅子靠背断裂处，加固底部螺丝', 4, '2025-03-14 12:30:00');
INSERT INTO `equipment_maintenance` VALUES (9, 8, 'repair', '检查门锁电路，疑似主板故障，需更换', 5, '2025-03-15 09:00:00');
INSERT INTO `equipment_maintenance` VALUES (10, 3, 'routine', '定期检查电脑硬盘健康状态，运行正常', 4, '2025-03-10 14:00:00');

-- ----------------------------
-- Table structure for equipment_types
-- ----------------------------
DROP TABLE IF EXISTS `equipment_types`;
CREATE TABLE `equipment_types`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备类型的唯一标识，主键',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备类型的名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '设备类型的详细描述',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备类型对应的图标 URL',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '设备类型信息创建的时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipment_types
-- ----------------------------
INSERT INTO `equipment_types` VALUES (1, '投影仪', '用于教学的多媒体投影设备，支持高清投影', 'http://example.com/icons/projector.png', '2025-01-01 08:00:00');
INSERT INTO `equipment_types` VALUES (2, '空调', '宿舍或办公室用空调，提供制冷制热功能', 'http://example.com/icons/ac.png', '2025-01-01 08:00:00');
INSERT INTO `equipment_types` VALUES (3, '电脑', '实验室或办公室用台式电脑，适合编程和办公', 'http://example.com/icons/pc.png', '2025-01-01 08:00:00');
INSERT INTO `equipment_types` VALUES (4, '水龙头', '卫生间或厨房用节水型水龙头', 'http://example.com/icons/tap.png', '2025-01-01 08:00:00');
INSERT INTO `equipment_types` VALUES (5, '电灯', '节能型照明设备，适用于教室和公共区域', 'http://example.com/icons/light.png', '2025-01-01 08:00:00');
INSERT INTO `equipment_types` VALUES (6, '打印机', '黑白或彩色打印机，支持网络打印', 'http://example.com/icons/printer.png', '2025-01-01 08:00:00');

-- ----------------------------
-- Table structure for equipments
-- ----------------------------
DROP TABLE IF EXISTS `equipments`;
CREATE TABLE `equipments`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '设备的唯一标识，主键',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备的名称',
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备的类型',
  `model` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备的型号',
  `location` json NULL COMMENT '设备的位置信息，以 JSON 格式存储层级位置',
  `status` enum('normal','maintenance','broken') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备的状态，分为正常、维护中、损坏',
  `qrCode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备的二维码信息',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '设备的详细描述',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '设备记录创建的时间',
  `updatedAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '设备记录更新的时间，自动更新',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipments
-- ----------------------------
INSERT INTO `equipments` VALUES (1, '投影仪A3', '投影仪', 'Epson EB-X41', '{\"area\": \"多媒体教室\", \"room\": \"305\", \"floor\": 3, \"building\": \"教学楼A\"}', 'broken', 'QR123456', '教室用高清投影仪，支持无线投影', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (2, '空调B5', '空调', 'Gree KFR-35GW', '{\"area\": \"男生宿舍\", \"room\": \"502\", \"floor\": 5, \"building\": \"宿舍楼B\"}', 'maintenance', 'QR789012', '宿舍用壁挂式空调，制冷制热双用', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (3, '电脑C2', '电脑', 'Dell OptiPlex 3070', '{\"area\": \"计算机实验室\", \"room\": \"Lab201\", \"floor\": 2, \"building\": \"实验楼C\"}', 'normal', 'QR345678', '实验室用台式电脑，配置i5处理器', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (4, '水龙头D1', '水龙头', 'Moen 123', '{\"area\": \"东侧洗手池\", \"room\": \"洗手间\", \"floor\": 1, \"building\": \"食堂D\"}', 'maintenance', 'QR901234', '不锈钢水龙头，感应式设计', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (5, '吊灯E4', '电灯', 'Philips LED-40W', '{\"area\": \"自习区\", \"room\": \"阅览室402\", \"floor\": 4, \"building\": \"图书馆E\"}', 'broken', 'QR567890', '节能LED吊灯，亮度可调', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (6, '打印机F2', '打印机', 'HP LaserJet Pro M404', '{\"area\": \"教师办公室\", \"room\": \"办公室203\", \"floor\": 2, \"building\": \"行政楼F\"}', 'normal', 'QR112233', '黑白激光打印机，支持双面打印', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (7, '椅子A2', '椅子', 'Generic Classroom Chair', '{\"area\": \"阶梯教室\", \"room\": \"201\", \"floor\": 2, \"building\": \"教学楼A\"}', 'maintenance', 'QR445566', '教室用靠背椅，木质框架', '2025-01-01 08:00:00', '2025-03-15 15:19:06');
INSERT INTO `equipments` VALUES (8, '门锁B3', '门锁', 'Yale YDM4109', '{\"area\": \"女生宿舍\", \"room\": \"301\", \"floor\": 3, \"building\": \"宿舍楼B\"}', 'broken', 'QR778899', '智能指纹门锁，支持密码开锁', '2025-01-01 08:00:00', '2025-03-15 15:19:06');

-- ----------------------------
-- Table structure for knowledge_articles
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_articles`;
CREATE TABLE `knowledge_articles`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '知识库文章的唯一标识，主键',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文章的标题',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文章的富文本内容',
  `category` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章所属的分类',
  `tags` json NULL COMMENT '文章的标签数组，以 JSON 格式存储',
  `authorId` int(11) NULL DEFAULT NULL COMMENT '文章的作者 ID，关联 users 表的 id',
  `viewCount` int(11) NULL DEFAULT 0 COMMENT '文章的浏览次数，默认为 0',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '文章创建的时间',
  `updatedAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '文章更新的时间，自动更新',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `authorId`(`authorId`) USING BTREE,
  CONSTRAINT `knowledge_articles_ibfk_1` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_articles
-- ----------------------------
INSERT INTO `knowledge_articles` VALUES (6, '如何保养空调设备', '定期清洗滤网，每季度检查冷媒量，避免长时间超负荷运行...', '设备维护', '[\"空调\", \"保养\", \"节能\"]', 1, 25, '2025-03-10 09:00:00', '2025-03-15 15:23:21');
INSERT INTO `knowledge_articles` VALUES (7, '投影仪常见故障排除', '若电源无反应，检查电源线是否松动；若画面模糊，调整镜头焦距...', '故障排除', '[\"投影仪\", \"故障\", \"维修\"]', 2, 18, '2025-03-11 14:00:00', '2025-03-15 15:23:21');
INSERT INTO `knowledge_articles` VALUES (8, '电脑蓝屏问题解决方法', '蓝屏可能是内存或驱动问题，建议重启后检查硬件连接...', '故障排除', '[\"电脑\", \"蓝屏\", \"硬件\"]', 3, 30, '2025-03-12 10:00:00', '2025-03-15 15:23:21');
INSERT INTO `knowledge_articles` VALUES (9, '水龙头维护指南', '漏水通常由密封圈老化引起，可自行更换或联系维修人员...', '设备维护', '[\"水龙头\", \"漏水\", \"维护\"]', 1, 12, '2025-03-13 15:00:00', '2025-03-15 15:23:21');
INSERT INTO `knowledge_articles` VALUES (10, '如何延长电灯寿命', '避免频繁开关，使用LED灯管可显著降低能耗...', '节能建议', '[\"电灯\", \"节能\", \"寿命\"]', 2, 8, '2025-03-14 08:30:00', '2025-03-15 15:23:21');

-- ----------------------------
-- Table structure for locations
-- ----------------------------
DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '位置信息的唯一标识，主键',
  `parentId` int(11) NULL DEFAULT NULL COMMENT '父级位置的 ID，关联 locations 表的 id，用于构建层级关系',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '位置的名称',
  `level` int(11) NOT NULL COMMENT '位置的层级',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '位置的路径信息',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '位置信息创建的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `parentId`(`parentId`) USING BTREE,
  CONSTRAINT `locations_ibfk_1` FOREIGN KEY (`parentId`) REFERENCES `locations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of locations
-- ----------------------------
INSERT INTO `locations` VALUES (1, NULL, '校园', 1, '/校园', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (2, 1, '教学楼A', 2, '/校园/教学楼A', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (3, 1, '教学楼B', 2, '/校园/教学楼B', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (4, 1, '宿舍楼B', 2, '/校园/宿舍楼B', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (5, 1, '宿舍楼C', 2, '/校园/宿舍楼C', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (6, 1, '实验楼C', 2, '/校园/实验楼C', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (7, 1, '实验楼D', 2, '/校园/实验楼D', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (8, 1, '食堂D', 2, '/校园/食堂D', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (9, 1, '食堂E', 2, '/校园/食堂E', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (10, 1, '图书馆E', 2, '/校园/图书馆E', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (11, 1, '行政楼F', 2, '/校园/行政楼F', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (12, 2, '1楼', 3, '/校园/教学楼A/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (13, 2, '2楼', 3, '/校园/教学楼A/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (14, 2, '3楼', 3, '/校园/教学楼A/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (15, 2, '4楼', 3, '/校园/教学楼A/4楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (16, 2, '5楼', 3, '/校园/教学楼A/5楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (17, 3, '1楼', 3, '/校园/教学楼B/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (18, 3, '2楼', 3, '/校园/教学楼B/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (19, 3, '3楼', 3, '/校园/教学楼B/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (20, 3, '4楼', 3, '/校园/教学楼B/4楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (21, 3, '5楼', 3, '/校园/教学楼B/5楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (22, 4, '1楼', 3, '/校园/宿舍楼B/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (23, 4, '2楼', 3, '/校园/宿舍楼B/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (24, 4, '3楼', 3, '/校园/宿舍楼B/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (25, 4, '4楼', 3, '/校园/宿舍楼B/4楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (26, 4, '5楼', 3, '/校园/宿舍楼B/5楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (27, 5, '1楼', 3, '/校园/宿舍楼C/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (28, 5, '2楼', 3, '/校园/宿舍楼C/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (29, 5, '3楼', 3, '/校园/宿舍楼C/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (30, 5, '4楼', 3, '/校园/宿舍楼C/4楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (31, 5, '5楼', 3, '/校园/宿舍楼C/5楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (32, 6, '1楼', 3, '/校园/实验楼C/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (33, 6, '2楼', 3, '/校园/实验楼C/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (34, 6, '3楼', 3, '/校园/实验楼C/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (35, 6, '4楼', 3, '/校园/实验楼C/4楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (36, 6, '5楼', 3, '/校园/实验楼C/5楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (37, 7, '1楼', 3, '/校园/实验楼D/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (38, 7, '2楼', 3, '/校园/实验楼D/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (39, 7, '3楼', 3, '/校园/实验楼D/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (40, 7, '4楼', 3, '/校园/实验楼D/4楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (41, 7, '5楼', 3, '/校园/实验楼D/5楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (42, 8, '1楼', 3, '/校园/食堂D/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (43, 8, '2楼', 3, '/校园/食堂D/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (44, 9, '1楼', 3, '/校园/食堂E/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (45, 9, '2楼', 3, '/校园/食堂E/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (46, 10, '1楼', 3, '/校园/图书馆E/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (47, 10, '2楼', 3, '/校园/图书馆E/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (48, 10, '3楼', 3, '/校园/图书馆E/3楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (49, 11, '1楼', 3, '/校园/行政楼F/1楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (50, 11, '2楼', 3, '/校园/行政楼F/2楼', '2025-01-01 08:00:00');
INSERT INTO `locations` VALUES (51, 11, '3楼', 3, '/校园/行政楼F/3楼', '2025-01-01 08:00:00');

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '消息通知的唯一标识，主键',
  `type` enum('repair','system','message') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消息通知的类型，分为报修通知、系统通知、普通消息',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '消息通知的标题',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '消息通知的详细内容',
  `senderId` int(11) NULL DEFAULT NULL COMMENT '消息通知的发送者 ID，关联 users 表的 id',
  `receiverId` int(11) NULL DEFAULT NULL COMMENT '消息通知的接收者 ID，关联 users 表的 id',
  `isRead` tinyint(1) NULL DEFAULT 0 COMMENT '消息通知是否已读，默认为未读',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '消息通知创建的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `senderId`(`senderId`) USING BTREE,
  INDEX `receiverId`(`receiverId`) USING BTREE,
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`senderId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`receiverId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications
-- ----------------------------
INSERT INTO `notifications` VALUES (1, 'repair', '新报修工单 #1', '投影仪故障已提交，请尽快安排维修人员处理', 6, 3, 0, '2025-03-14 09:05:00');
INSERT INTO `notifications` VALUES (2, 'repair', '新报修工单 #4', '水龙头漏水严重，请立即处理', 8, 5, 0, '2025-03-14 13:05:00');
INSERT INTO `notifications` VALUES (3, 'system', '系统维护通知', '系统将于今晚23:00-次日2:00进行维护，请提前保存工作', 1, 6, 1, '2025-03-14 08:00:00');
INSERT INTO `notifications` VALUES (4, 'message', '维修进度更新', '空调维修已开始，冷凝器清洗完成', 3, 7, 0, '2025-03-14 10:05:00');
INSERT INTO `notifications` VALUES (5, 'repair', '新报修工单 #5', '阅览室电灯闪烁，请安排检查', 9, 4, 0, '2025-03-14 15:35:00');
INSERT INTO `notifications` VALUES (6, 'message', '维修完成通知', '电脑蓝屏问题已解决，请验收', 4, 6, 1, '2025-03-12 15:05:00');
INSERT INTO `notifications` VALUES (7, 'repair', '新报修工单 #8', '宿舍门锁损坏，请尽快修复', 7, 5, 0, '2025-03-15 08:05:00');
INSERT INTO `notifications` VALUES (8, 'system', '用户注册成功', '欢迎新用户徐静加入系统', 1, 10, 1, '2025-03-13 09:00:00');
INSERT INTO `notifications` VALUES (9, 'message', '维修进度更新', '椅子靠背已焊接完成，待验收', 4, 6, 0, '2025-03-14 12:35:00');
INSERT INTO `notifications` VALUES (10, 'repair', '新报修工单 #6', '打印机卡纸问题已提交，请处理', 10, 3, 1, '2025-03-13 09:50:00');

-- ----------------------------
-- Table structure for repair_ratings
-- ----------------------------
DROP TABLE IF EXISTS `repair_ratings`;
CREATE TABLE `repair_ratings`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '维修评价的唯一标识，主键',
  `repairId` int(11) NOT NULL COMMENT '关联的报修工单 ID，指向 repairs 表的 id',
  `score` tinyint(4) NULL DEFAULT NULL COMMENT '用户对维修服务的评分，范围为 1 - 5 分',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '用户对维修服务的评价内容',
  `userId` int(11) NULL DEFAULT NULL COMMENT '进行评价的用户 ID，关联 users 表的 id',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '维修评价创建的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `repairId`(`repairId`) USING BTREE,
  INDEX `userId`(`userId`) USING BTREE,
  CONSTRAINT `repair_ratings_ibfk_1` FOREIGN KEY (`repairId`) REFERENCES `repairs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `repair_ratings_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of repair_ratings
-- ----------------------------
INSERT INTO `repair_ratings` VALUES (1, 3, 5, '维修速度很快，电脑当天就修好了，服务态度也很好！', 6, '2025-03-12 16:00:00');
INSERT INTO `repair_ratings` VALUES (2, 2, 4, '空调修好了，制冷效果有所改善，但希望响应速度更快些', 7, '2025-03-14 11:00:00');
INSERT INTO `repair_ratings` VALUES (3, 6, 5, '打印机问题解决得非常迅速，感谢维修人员！', 10, '2025-03-13 11:30:00');
INSERT INTO `repair_ratings` VALUES (4, 4, 3, '水龙头修好了，但维修过程中有点吵', 8, '2025-03-14 15:00:00');
INSERT INTO `repair_ratings` VALUES (5, 7, 4, '椅子修得不错，但建议备一些新椅子替换', 6, '2025-03-14 14:00:00');
INSERT INTO `repair_ratings` VALUES (6, 19, 5, 'good', 13, '2025-04-12 15:58:02');

-- ----------------------------
-- Table structure for repair_records
-- ----------------------------
DROP TABLE IF EXISTS `repair_records`;
CREATE TABLE `repair_records`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '维修记录的唯一标识，主键',
  `repairId` int(11) NOT NULL COMMENT '关联的报修工单 ID，指向 repairs 表的 id',
  `type` enum('create','process','complete') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '维修记录的类型，分为创建、处理、完成',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '维修处理的详细说明',
  `images` json NULL COMMENT '与维修处理相关的图片 URL 数组，以 JSON 格式存储',
  `handlerId` int(11) NULL DEFAULT NULL COMMENT '处理该维修记录的人员 ID，关联 users 表的 id',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '维修记录创建的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `repairId`(`repairId`) USING BTREE,
  INDEX `handlerId`(`handlerId`) USING BTREE,
  CONSTRAINT `repair_records_ibfk_1` FOREIGN KEY (`repairId`) REFERENCES `repairs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `repair_records_ibfk_2` FOREIGN KEY (`handlerId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of repair_records
-- ----------------------------
INSERT INTO `repair_records` VALUES (1, 1, 'create', '用户提交报修：投影仪电源无反应，疑似线路故障', '[\"https://th.bing.com/th/id/OIP.2e4ggNlI2AYr-0ptBT9HTAHaJ4?rs=1&pid=ImgDetMain\"]', 6, '2025-03-14 09:00:00');
INSERT INTO `repair_records` VALUES (2, 2, 'create', '用户提交报修：空调制冷效果差，室内温度仍高达28度', '[\"http://example.com/images/ac1.jpg\"]', 7, '2025-03-13 14:30:00');
INSERT INTO `repair_records` VALUES (3, 2, 'process', '维修人员检查：冷凝器脏污严重，已清洗并补充冷媒', '[\"http://example.com/images/ac2.jpg\"]', 3, '2025-03-14 10:00:00');
INSERT INTO `repair_records` VALUES (4, 3, 'create', '用户提交报修：电脑开机后蓝屏，显示内存错误', '[\"http://example.com/images/pc1.jpg\"]', 6, '2025-03-12 10:15:00');
INSERT INTO `repair_records` VALUES (5, 3, 'process', '维修人员诊断：内存条接触不良，已重新插拔', '[\"http://example.com/images/pc2.jpg\"]', 4, '2025-03-12 13:30:00');
INSERT INTO `repair_records` VALUES (6, 3, 'complete', '维修完成：电脑恢复正常运行', '[\"http://example.com/images/pc3.jpg\"]', 4, '2025-03-12 15:00:00');
INSERT INTO `repair_records` VALUES (7, 4, 'create', '用户提交报修：水龙头漏水严重，地面已积水', '[\"http://example.com/images/tap1.jpg\"]', 8, '2025-03-14 13:00:00');
INSERT INTO `repair_records` VALUES (8, 4, 'process', '维修人员检查：密封圈老化，已更换新密封圈', '[\"http://example.com/images/tap2.jpg\"]', 5, '2025-03-14 14:30:00');
INSERT INTO `repair_records` VALUES (9, 5, 'create', '用户提交报修：电灯闪烁，疑似灯管老化', '[\"http://example.com/images/light1.jpg\"]', 9, '2025-03-14 15:30:00');
INSERT INTO `repair_records` VALUES (10, 6, 'create', '用户提交报修：打印机卡纸，无法正常打印', '[\"http://example.com/images/printer1.jpg\"]', 10, '2025-03-13 09:45:00');
INSERT INTO `repair_records` VALUES (11, 6, 'complete', '维修完成：清除卡纸并测试打印正常', '[\"http://example.com/images/printer2.jpg\"]', 3, '2025-03-13 11:00:00');
INSERT INTO `repair_records` VALUES (12, 7, 'create', '用户提交报修：椅子靠背断裂', '[\"http://example.com/images/chair1.jpg\"]', 6, '2025-03-14 11:00:00');
INSERT INTO `repair_records` VALUES (25, 8, 'process', '开始接单', NULL, 12, '2025-04-12 13:10:24');
INSERT INTO `repair_records` VALUES (26, 13, 'process', '维修人员接单', NULL, 12, '2025-04-12 13:24:07');
INSERT INTO `repair_records` VALUES (27, 13, 'process', 'aaa', NULL, 12, '2025-04-12 13:24:07');
INSERT INTO `repair_records` VALUES (28, 13, 'process', '开始工作', NULL, 12, '2025-04-12 13:28:59');
INSERT INTO `repair_records` VALUES (29, 13, 'process', '工作 ing', NULL, 12, '2025-04-12 13:30:26');
INSERT INTO `repair_records` VALUES (30, 19, 'create', '工单创建', '[\"https://zh.wikipedia.org/wiki/Bing_Maps#/media/File:Bing_Fluent_Logo_Text.svg\"]', 13, '2025-04-12 14:47:04');
INSERT INTO `repair_records` VALUES (31, 19, 'process', '开始接单', NULL, 12, '2025-04-12 14:48:07');
INSERT INTO `repair_records` VALUES (32, 19, 'process', '开始换雪种', NULL, 12, '2025-04-12 14:50:02');
INSERT INTO `repair_records` VALUES (33, 19, 'process', 'ing', NULL, 12, '2025-04-12 14:52:46');
INSERT INTO `repair_records` VALUES (34, 19, 'process', 'ing', NULL, 12, '2025-04-12 14:53:23');
INSERT INTO `repair_records` VALUES (35, 19, 'process', 'ing', NULL, 12, '2025-04-12 14:55:41');
INSERT INTO `repair_records` VALUES (36, 19, 'complete', '已完成', NULL, 12, '2025-04-12 15:04:43');

-- ----------------------------
-- Table structure for repairs
-- ----------------------------
DROP TABLE IF EXISTS `repairs`;
CREATE TABLE `repairs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '报修工单的唯一标识，主键',
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报修设备的类型',
  `location` json NULL COMMENT '设备的位置信息，以 JSON 格式存储层级位置',
  `locationDetail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备的详细位置描述',
  `priority` enum('high','medium','low') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '报修工单的优先级，分为高、中、低',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '设备问题的详细描述',
  `status` enum('pending','processing','completed') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '报修工单的状态，分为待处理、处理中、已完成',
  `creatorId` int(11) NULL DEFAULT NULL COMMENT '报修工单的创建人 ID，关联 users 表的 id',
  `maintainerId` int(11) NULL DEFAULT NULL COMMENT '负责处理该工单的维修人员 ID，关联 users 表的 id',
  `images` json NULL COMMENT '与报修工单相关的图片 URL 数组，以 JSON 格式存储',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '报修工单创建的时间',
  `updatedAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '报修工单更新的时间，自动更新',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `creatorId`(`creatorId`) USING BTREE,
  INDEX `maintainerId`(`maintainerId`) USING BTREE,
  CONSTRAINT `repairs_ibfk_1` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `repairs_ibfk_2` FOREIGN KEY (`maintainerId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of repairs
-- ----------------------------
INSERT INTO `repairs` VALUES (1, '投影仪', '{\"area\": \"校园\", \"floor\": \"3楼\", \"building\": \"教学楼A\"}', '教室东北角投影仪支架', 'high', '投影仪电源无反应，疑似线路故障', 'pending', 6, NULL, '[\"https://th.bing.com/th/id/OIP.2e4ggNlI2AYr-0ptBT9HTAHaJ4?rs=1&pid=ImgDetMain\"]', '2025-03-14 09:00:00', '2025-04-12 13:19:22');
INSERT INTO `repairs` VALUES (2, '空调', '{\"area\": \"校园\", \"floor\": \"5楼\", \"building\": \"宿舍楼B\"}', '靠窗的壁挂式空调', 'medium', '空调制冷效果差，室内温度仍高达28度', 'processing', 7, 3, '[\"http://example.com/images/ac1.jpg\", \"http://example.com/images/ac2.jpg\"]', '2025-03-13 14:30:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (3, '电脑', '{\"area\": \"校园\", \"floor\": \"2楼\", \"building\": \"实验楼C\"}', '第5号机位桌面电脑', 'low', '电脑开机后蓝屏，显示内存错误', 'completed', 6, 4, '[\"http://example.com/images/pc1.jpg\", \"http://example.com/images/pc2.jpg\"]', '2025-03-12 10:15:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (4, '水龙头', '{\"area\": \"校园\", \"floor\": \"1楼\", \"building\": \"食堂D\"}', '第三个水龙头', 'high', '水龙头漏水严重，地面已积水', 'processing', 8, 5, '[\"http://example.com/images/tap1.jpg\"]', '2025-03-14 13:00:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (5, '电灯', '{\"area\": \"校园\", \"floor\": \"4楼\", \"building\": \"图书馆E\"}', '靠窗第三排吊灯', 'medium', '电灯闪烁，疑似灯管老化', 'pending', 9, NULL, '[\"http://example.com/images/light1.jpg\"]', '2025-03-14 15:30:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (6, '打印机', '{\"area\": \"校园\", \"floor\": \"2楼\", \"building\": \"行政楼F\"}', '角落的彩色打印机', 'low', '打印机卡纸，无法正常打印', 'completed', 10, 3, '[\"http://example.com/images/printer1.jpg\"]', '2025-03-13 09:45:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (7, '椅子', '{\"area\": \"校园\", \"floor\": \"2楼\", \"building\": \"教学楼A\"}', '第5排第3座', 'low', '椅子靠背断裂', 'processing', 6, 4, '[\"http://example.com/images/chair1.jpg\"]', '2025-03-14 11:00:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (8, '门锁', '{\"area\": \"校园\", \"floor\": \"3楼\", \"building\": \"宿舍楼B\"}', '房间门锁', 'high', '门锁损坏，无法正常开锁', 'processing', 7, NULL, '[\"http://example.com/images/lock1.jpg\"]', '2025-03-15 08:00:00', '2025-03-15 20:44:37');
INSERT INTO `repairs` VALUES (13, '空调', '{\"area\": \"校园\", \"floor\": \"3楼\", \"building\": \"宿舍楼C\"}', 'safasfas', 'low', 'safasfasfas', 'processing', 2, 12, '[\"https://zh.wikipedia.org/wiki/Bing_Maps#/media/File:Bing_Fluent_Logo_Text.svg\"]', '2025-03-15 21:27:57', '2025-04-12 13:19:22');
INSERT INTO `repairs` VALUES (19, '空调', '{\"area\": \"校园\", \"floor\": \"3楼\", \"building\": \"教学楼B\"}', '三楼走廊东侧', 'medium', '空调没雪种了', 'completed', 13, 12, '[\"https://zh.wikipedia.org/wiki/Bing_Maps#/media/File:Bing_Fluent_Logo_Text.svg\"]', '2025-04-12 14:47:03', '2025-04-12 14:47:03');

-- ----------------------------
-- Table structure for statistics
-- ----------------------------
DROP TABLE IF EXISTS `statistics`;
CREATE TABLE `statistics`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '统计数据的唯一标识，主键',
  `date` date NOT NULL COMMENT '统计数据对应的日期',
  `type` enum('repair','equipment','rating') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '统计数据的类型，分为报修统计、设备统计、评价统计',
  `data` json NULL COMMENT '统计数据的具体内容，以 JSON 格式存储',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '统计数据创建的时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of statistics
-- ----------------------------
INSERT INTO `statistics` VALUES (1, '2025-03-14', 'repair', '{\"total\": 8, \"pending\": 3, \"completed\": 2, \"processing\": 3}', '2025-03-14 18:00:00');
INSERT INTO `statistics` VALUES (2, '2025-03-14', 'equipment', '{\"broken\": 3, \"normal\": 2, \"maintenance\": 3}', '2025-03-14 18:00:00');
INSERT INTO `statistics` VALUES (3, '2025-03-14', 'rating', '{\"low\": 0, \"high\": 2, \"count\": 5, \"medium\": 3, \"average\": 4.2}', '2025-03-14 18:00:00');
INSERT INTO `statistics` VALUES (4, '2025-03-13', 'repair', '{\"total\": 6, \"pending\": 2, \"completed\": 2, \"processing\": 2}', '2025-03-13 18:00:00');
INSERT INTO `statistics` VALUES (5, '2025-03-12', 'repair', '{\"total\": 3, \"pending\": 1, \"completed\": 1, \"processing\": 1}', '2025-03-12 18:00:00');
INSERT INTO `statistics` VALUES (6, '2025-03-14', 'equipment', '{\"broken\": 3, \"normal\": 3, \"maintenance\": 2}', '2025-03-14 12:00:00');

-- ----------------------------
-- Table structure for system_logs
-- ----------------------------
DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '系统日志的唯一标识，主键',
  `type` enum('operation','system','error') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '系统日志的类型，分为操作日志、系统日志、错误日志',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '系统日志的详细内容',
  `operatorId` int(11) NULL DEFAULT NULL COMMENT '进行操作的用户 ID，关联 users 表的 id',
  `ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作的 IP 地址',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '系统日志创建的时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `operatorId`(`operatorId`) USING BTREE,
  CONSTRAINT `system_logs_ibfk_1` FOREIGN KEY (`operatorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_logs
-- ----------------------------
INSERT INTO `system_logs` VALUES (1, 'operation', '用户提交报修工单 #1：投影仪故障', 6, '192.168.1.100', '2025-03-14 09:00:00');
INSERT INTO `system_logs` VALUES (2, 'system', '系统启动成功，版本v2.1.3', NULL, '127.0.0.1', '2025-03-14 08:00:00');
INSERT INTO `system_logs` VALUES (3, 'error', '用户登录失败：密码错误', 7, '192.168.1.101', '2025-03-13 13:00:00');
INSERT INTO `system_logs` VALUES (4, 'operation', '维修人员更新工单 #2：空调维修中', 3, '192.168.1.102', '2025-03-14 10:00:00');
INSERT INTO `system_logs` VALUES (5, 'operation', '用户提交报修工单 #4：水龙头漏水', 8, '192.168.1.103', '2025-03-14 13:00:00');
INSERT INTO `system_logs` VALUES (6, 'operation', '维修完成工单 #6：打印机卡纸修复', 3, '192.168.1.102', '2025-03-13 11:00:00');
INSERT INTO `system_logs` VALUES (7, 'system', '数据库备份成功，文件大小120MB', NULL, '127.0.0.1', '2025-03-14 02:00:00');
INSERT INTO `system_logs` VALUES (8, 'operation', '用户提交评价：工单 #3，评分5', 6, '192.168.1.100', '2025-03-12 16:00:00');
INSERT INTO `system_logs` VALUES (9, 'error', '文件上传失败：图像超过10MB限制', 9, '192.168.1.104', '2025-03-14 15:40:00');
INSERT INTO `system_logs` VALUES (10, 'operation', '管理员发布知识库文章：如何保养空调', 1, '192.168.1.105', '2025-03-10 09:00:00');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识，主键',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名，用于登录系统，需唯一',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '加密存储的用户密码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的真实姓名',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户头像的 URL 地址',
  `role` tinyint(4) NOT NULL DEFAULT 0,
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的联系电话',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的电子邮箱地址',
  `department` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户所在的部门',
  `createdAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '用户记录创建的时间',
  `updatedAt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '用户记录更新的时间，自动更新',
  `isDelete` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除字段，默认为 0，表示未删除，1 表示已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'user005', 'e4e214660b5a4ab7f54b4daccd3d49e0', '徐静', 'http://example.com/avatar/user005.jpg', 1, '13288889999', 'user005@university.edu', '艺术学院', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (2, 'ziio', 'e4e214660b5a4ab7f54b4daccd3d49e0', 'ziiojj', NULL, 2, '18665439225', NULL, 'computer science', '2025-03-09 21:13:09', '2025-03-09 21:14:31', 0);
INSERT INTO `users` VALUES (3, 'admin001', 'e4e214660b5a4ab7f54b4daccd3d49e0', '张伟', 'http://example.com/avatar/admin001.jpg', 2, '13812345678', 'admin001@university.edu', '信息中心', '2025-03-15 15:19:05', '2025-03-15 15:19:05', 0);
INSERT INTO `users` VALUES (4, 'admin002', 'e4e214660b5a4ab7f54b4daccd3d49e0', '刘强', 'http://example.com/avatar/admin002.jpg', 2, '13898765432', 'admin002@university.edu', '信息中心', '2025-03-15 15:19:05', '2025-03-15 15:19:05', 0);
INSERT INTO `users` VALUES (5, 'maintainer001', 'e4e214660b5a4ab7f54b4daccd3d49e0', '李明', 'http://example.com/avatar/maintainer001.jpg', 3, '13987654321', 'maintainer001@university.edu', '后勤部', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (6, 'maintainer002', 'e4e214660b5a4ab7f54b4daccd3d49e0', '陈浩', 'http://example.com/avatar/maintainer002.jpg', 3, '13911112222', 'maintainer002@university.edu', '后勤部', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (7, 'maintainer003', 'e4e214660b5a4ab7f54b4daccd3d49e0', '周杰', 'http://example.com/avatar/maintainer003.jpg', 3, '13933334444', 'maintainer003@university.edu', '后勤部', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (8, 'user001', 'e4e214660b5a4ab7f54b4daccd3d49e0', '王芳', 'http://example.com/avatar/user001.jpg', 1, '13655556666', 'user001@university.edu', '计算机学院', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (9, 'user002', 'e4e214660b5a4ab7f54b4daccd3d49e0', '赵丽', 'http://example.com/avatar/user002.jpg', 1, '13777778888', 'user002@university.edu', '图书馆', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (10, 'user003', 'e4e214660b5a4ab7f54b4daccd3d49e0', '孙娜', 'http://example.com/avatar/user003.jpg', 1, '13599990000', 'user003@university.edu', '经济学院', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (11, 'user004', 'e4e214660b5a4ab7f54b4daccd3d49e0', '杨磊', 'http://example.com/avatar/user004.jpg', 1, '13466667777', 'user004@university.edu', '机械学院', '2025-03-15 15:19:05', '2025-04-12 13:02:46', 0);
INSERT INTO `users` VALUES (12, 'zeenoh', 'e4e214660b5a4ab7f54b4daccd3d49e0', 'zeenoh', NULL, 3, '18665439225', NULL, 'cs', '2025-04-12 13:00:28', '2025-04-12 13:00:28', 0);
INSERT INTO `users` VALUES (13, 'ziiro', 'e4e214660b5a4ab7f54b4daccd3d49e0', 'ziiro', NULL, 1, '18665439225', NULL, 'cs', '2025-04-12 14:46:12', '2025-04-12 14:46:12', 0);

SET FOREIGN_KEY_CHECKS = 1;

