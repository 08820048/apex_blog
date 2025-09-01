/*
 Navicat Premium Dump SQL

 Source Server         : my_local
 Source Server Type    : MySQL
 Source Server Version : 90300 (9.3.0)
 Source Host           : localhost:3306
 Source Schema         : apex_blog

 Target Server Type    : MySQL
 Target Server Version : 90300 (9.3.0)
 File Encoding         : 65001

 Date: 01/09/2025 13:42:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article_tags
-- ----------------------------
DROP TABLE IF EXISTS `article_tags`;
CREATE TABLE `article_tags` (
  `article_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `article_tags_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `article_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of article_tags
-- ----------------------------
BEGIN;
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (1, 1);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (5, 1);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (7, 1);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (1, 2);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (5, 2);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (3, 3);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (7, 3);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (5, 4);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (7, 6);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (3, 7);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (1, 8);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (5, 8);
INSERT INTO `article_tags` (`article_id`, `tag_id`) VALUES (7, 8);
COMMIT;

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` bigint DEFAULT NULL,
  `author_id` bigint NOT NULL,
  `status` enum('DRAFT','PUBLISHED','ARCHIVED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
  `is_top` tinyint(1) DEFAULT '0',
  `view_count` bigint DEFAULT '0',
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_published_at` (`published_at`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_is_top` (`is_top`),
  KEY `idx_view_count` (`view_count`),
  FULLTEXT KEY `idx_title_content` (`title`,`content`),
  CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `articles_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of articles
-- ----------------------------
BEGIN;
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (1, 'Spring Boot 入门指南', '详细介绍Spring Boot框架的基础知识和快速上手方法', '# Spring Boot 入门指南\n\n## 什么是Spring Boot\n\nSpring Boot是一个基于Spring框架的快速开发框架，它简化了Spring应用的配置和部署过程。\n\n## 主要特性\n\n1. **自动配置**: 根据项目依赖自动配置Spring应用\n2. **起步依赖**: 简化Maven/Gradle依赖管理\n3. **内嵌服务器**: 内置Tomcat、Jetty等服务器\n4. **生产就绪**: 提供健康检查、监控等功能\n\n## 快速开始\n\n### 1. 创建项目\n\n使用Spring Initializr创建项目\n\n### 2. 编写Controller\n\n```java\n@RestController\npublic class HelloController {\n    @GetMapping(\"/hello\")\n    public String hello() {\n        return \"Hello, Spring Boot!\";\n    }\n}\n```\n\n### 3. 运行应用\n\n```bash\n./mvnw spring-boot:run\n```\n\n## 总结\n\nSpring Boot大大简化了Spring应用的开发过程，是现代Java Web开发的首选框架。', 'https://ultimate-img.oss-cn-beijing.aliyuncs.com/covers/20250820/d58d08d6a6c740a08c5bc163e86157a8.png', 6, 1, 'PUBLISHED', 1, 82, '2025-08-13 09:18:32', '2025-08-12 17:36:05', '2025-08-20 19:14:08');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (2, 'Java 集合框架详解', 'Java集合框架是Java编程中最重要的基础知识之一', '# Java 集合框架详解\n\n## 概述\n\nJava集合框架提供了一套性能优良、使用方便的接口和类，位于java.util包中。\n\n## 主要接口\n\n### Collection接口\n- List: 有序集合，允许重复元素\n- Set: 无序集合，不允许重复元素\n- Queue: 队列接口\n\n### Map接口\n- HashMap: 基于哈希表的Map实现\n- TreeMap: 基于红黑树的Map实现\n\n## 常用实现类\n\n### ArrayList vs LinkedList\n- ArrayList: 基于数组，随机访问快\n- LinkedList: 基于链表，插入删除快\n\n### HashSet vs TreeSet\n- HashSet: 基于哈希表，无序\n- TreeSet: 基于红黑树，有序\n\n## 最佳实践\n\n1. 优先使用接口类型声明变量\n2. 根据使用场景选择合适的实现类\n3. 注意线程安全问题\n\n## 总结\n\n掌握Java集合框架是Java开发的基础，合理选择集合类型能提高程序性能。', NULL, 5, 1, 'PUBLISHED', 1, 206, '2025-08-12 17:36:26', '2025-08-12 17:36:26', '2025-08-16 21:55:18');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (3, 'Vue.js 3.0 新特性', 'Vue.js 3.0带来了许多激动人心的新特性和改进', '# Vue.js 3.0 新特性\n\n## Composition API\n\nVue 3引入了Composition API，提供了更灵活的组件逻辑组织方式。\n\n```javascript\nimport { ref, computed } from \"vue\"\n\nexport default {\n  setup() {\n    const count = ref(0)\n    const doubleCount = computed(() => count.value * 2)\n    \n    return {\n      count,\n      doubleCount\n    }\n  }\n}\n```\n\n## 性能提升\n\n- 更小的包体积\n- 更快的渲染速度\n- 更好的Tree-shaking支持\n\n## TypeScript支持\n\nVue 3对TypeScript提供了更好的支持。', '', 7, 1, 'PUBLISHED', 0, 99, NULL, '2025-08-12 17:36:57', '2025-08-16 23:08:01');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (4, 'MySQL 性能优化指南', 'MySQL数据库性能优化的最佳实践', '# MySQL 性能优化指南\n\n## 索引优化\n\n正确使用索引是MySQL性能优化的关键。\n\n### 索引类型\n- B-Tree索引\n- 哈希索引\n- 全文索引\n\n### 索引设计原则\n1. 为经常查询的列创建索引\n2. 避免过多索引\n3. 复合索引的顺序很重要\n\n## 查询优化\n\n使用EXPLAIN分析查询执行计划。\n\n## 配置优化\n\n调整MySQL配置参数以获得最佳性能。', NULL, 8, 1, 'PUBLISHED', 0, 243, NULL, '2025-08-12 17:36:57', '2025-08-16 23:08:01');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (5, '微服务架构设计模式 1', '深入探讨微服务架构的设计模式和最佳实践1', '# 微服务架构设计模式\n\n## 什么是微服务\n\n微服务是一种架构风格，将单一应用程序开发为一套小服务。\n\n## 核心模式\n\n### 服务发现\n- 客户端发现\n- 服务端发现\n\n### 配置管理\n- 外部化配置\n- 配置中心\n\n### 断路器模式\n防止级联故障的重要模式。\n\n## 挑战与解决方案\n\n微服务架构带来的复杂性和解决方案。', '', 3, 1, 'PUBLISHED', 0, 6, '2025-08-12 17:42:35', '2025-08-12 17:36:57', '2025-08-16 21:51:31');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (6, 'React Hooks 深入理解', 'React Hooks的原理和使用技巧', '# React Hooks 深入理解\n\n## 什么是Hooks\n\nHooks是React 16.8引入的新特性，让你在不编写class的情况下使用state以及其他的React特性。\n\n## 常用Hooks\n\n### useState\n```javascript\nconst [count, setCount] = useState(0);\n```\n\n### useEffect\n```javascript\nuseEffect(() => {\n  document.title = `You clicked ${count} times`;\n}, [count]);\n```\n\n### useContext\n用于消费Context的Hook。\n\n## 自定义Hooks\n\n创建自己的Hooks来复用状态逻辑。', NULL, 7, 1, 'PUBLISHED', 0, 21, '2025-08-12 17:42:36', '2025-08-12 17:36:57', '2025-08-20 19:14:30');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (7, ' UE5 增强输入-第三人称角色移动、跳跃和视角转向功能实践', '增强输入是在UE5 早期引入的一个实验性功能。区别于早期的 UE4 之前得传统输入，增强输入现在已经作为虚幻 5 中一个完整的插件系统，在最新的虚幻引擎中，官方也明确表示传统的输入系统已经废弃，建议使用增强输入。', '# UE5 增强输入-第三人称角色移动、跳跃和视角转向功能实践\n\n增强输入是在UE5 早期引入的一个实验性功能。区别于早期的 UE4 之前得传统输入，增强输入现在已经作为虚幻 5 中一个完整的插件系统，在最新的虚幻引擎中，官方也明确表示传统的输入系统已经废弃，建议使用增强输入。\n\n![image-20250806092909629](https://images.waer.ltd/notes/202508060929883.png)\n\n因此，不管是刚刚入手虚幻还是老虚幻开发者，都要学会新的增强输入系统的基本操作，基于此，本文将以初学者视角，使用增强输入系统从头开始，以实践为主，理论为辅的方式，逐步完成一个第三人称角色的移动、跳跃、步行等基本操作功能，看完本文不能说立马就能开发出一款 3A 大作，但是对于理解增强输入的基础是够用的了。\n\n---\n\n## 两个关键概念\n\n在开始实践之前，有必要先简单理解一些关键的概念和术语，这有助于后面的学习。\n\n- 输入操作\n- 输入情景\n\n**输入情景**包含了与它们相关联的 **输入操作**，以及将执行这些操作的各种键。 **输入操作**包含了如何执行它们的规范。为了更好的理解二者的关系，理解它们是如何协同工作的，下面以游戏《使命召唤》的部分游戏操作为例。\n\n在使命召唤游戏中，玩家拥有不同得游戏映射情景，可以用不同的按键控制不同的人或对象。\n\n> 例如，当我们控制玩家角色在地图中奔跑、行走时，可以使用对应的几个移动键来控制角色的移动，也可以使用其他按键控制角色的跳跃，匍匐等。然后，当角色进入游戏载具内部时，玩家所能看到的控制方式也会发生改变，比如，之前控制角色移动的按键将变为控制载具的移动，之前控制角色视角的操作也变为控制载具的视角，换弹操作变为修理载具等等。\n\n在这个例子中，存在两个不同的 **输入情景**：\n\n- 控制角色\n- 控制载具（车辆）\n\n对于每一个输入情景，都有一组 **输入操作**。这些输入操作是由相同的按键触发的，这样设置并没有问题，因为它们是在不同得输入情景中完成的。\n\n**关键理解**\n\n**输入操作 = 游戏功能**\n\n> - 定义“做什么”比如，移动、攻击、交互等。\n> - 是抽象的游戏行为。\n\n**输入情景(输入映射情景) = 游戏状态**\n\n> - 定义“什么时候用什么键”。\n> - 根据游戏情况切换不同的按键映射。\n\n**协同关系**\n\n![image-20250806100020114](https://images.waer.ltd/notes/202508061000166.png)\n\n---\n\n## 启用增强输入系统\n\n由于增强输入是以插件的方式整合到 UE5 中，因此，我们在使用增强输入之前，可能需要手动启用 **增强输入系统**，为什么是可能呢？这个取决于你当前用的虚幻引擎版本，在最新的版本中，我的是虚幻 5.4。默认是开启这个功能的，因此，保险起见，建议按照下面的方式检查一下是否正常启用了该增强功能。\n\n- 在虚幻编辑器的顶部菜单中，选中 **编辑**，然后点击 **插件**，打开插件页面之后在 **内置**列表中找到输入相关的 2 插件，看看增强输入是否处于勾选状态。如果没有勾选，需要手动勾选并根据提示进行重启。\n\n![image-20250806100516042](https://images.waer.ltd/notes/202508061005149.png)\n\n- 告诉虚幻引擎，使用增强输入相关的类来进行玩家输入的处理。在项目设置中检查是否启用了增强输入相关的类作为默认类：\n\n![image-20250806100854835](https://images.waer.ltd/notes/202508061008965.png)\n\n---\n\n## 关键术语\n\n> 注意，从此刻开始，我们的实践项目就已经开始了。\n\n在 **内容浏览器**空白区域右击，在菜单中选择 **输入**并在其子列表中选择 **输入操作**命令，新建一个输入操作，命名为 `IA_Move`\n\n![image-20250806101723361](https://images.waer.ltd/notes/202508061017515.png)\n\n双击打开 **细节**面板，你会看到很多名称术语。下面挑一些关键的部分进行介绍：\n\n![image-20250806101907631](https://images.waer.ltd/notes/202508061019695.png)\n\n> **暂停时触发**：指定游戏暂停时是否可以触发这个操作。\n>\n> **保留所有映射**：如果指定由同一个键触发，是否会触发更高优先级的输入操作。\n>\n> **值类型**：指定输入操作的值类型，该类型的值可以是下面这些：\n>\n> - 数字（布尔）：用于具有二进制状态的输入操作，比如，跳跃的输入操作，玩家要么按下它，要么不按，这种情况下就可以使用该类型的值。\n> - Axis2D（浮点）：用于在一维中具有标量状态的输入操作，例如，在塞车游戏中的加速，我们可以使用手柄的触发器来控制油门。\n> - Axis2D（Vector2D）:用于在二维中具有标量状态的输入操作。例如，使用两个轴（向前轴和横向轴）完成用于角色移动的操作，此时，这个是最好的选择。\n> - Axis3D(向量)：用于在三维中具有标量状态的输入操作。例如，VR或AR应用中，追踪控制器的三维位置或方向，比如控制无人机、飞行器等。\n>\n> **触发器**：指定将执行此输入操作的关键事件。该值可以是一下值的组合。\n>\n> - 弦操作：只要另一个指定的输入操作也被触发，输入操作就会被触发。\n> - 下移：当按键超过驱动阈值，每一帧都会触发输入操作。\n> - 长按：当按键超过驱动阈值的时间达到指定的量时，输入操作被触发。我们可以指定它是触发一次还是每帧都触发。\n> - 已按下：当按键超过驱动阈值时，输入操作只触发一次，直到按键被释放才再次触发。\n> - 脉冲：只要按键超过驱动阈值，输入操作就会以指定的间隔触发。我们可以指定第一个脉冲是否触发输入操作，以及是否有被调用的次数限制。\n> - 点按：只要在指定的时间内完成，输入操作将在键启动时触发，然后在超过驱动阈值时停止。\n>\n> **修改器**：指定修改此输入操作的输入方式：\n>\n> - 盲区：如果低于下阈值，键的输入将读取为 0；如果高于上阈值，则读取为 1.\n> - 视野缩放：键的输入将与视野一起缩放（如果视野增加，则键的输出增加，如果视野减小，键的输出减小）\n> - 否定：反转键的输入。\n> - 响应曲线-指数：指数曲线将用于键的输入，用户定义的曲线同理。\n> - 标量：键的输入将根据指定的标量在每个轴上缩放。\n> - 平滑：键的输入将在多个帧之间平滑。\n> - 拌合输入轴值：拌合输入轴值的轴组件\n> - 到世界空间：输入空间将转换到世界空间。\n\n上面这些术语解释起来还是晦涩，但是这些东西都会在后续的学习中慢慢领悟，光靠这些文字解释是很难融会贯通的。\n\n---\n\n## 自定义角色的第三人称创建\n\n在这之前，请确保你能正确设置角色模型、设置自定义的游戏模式以及默认的 pawn 类。确保游戏开始后，采用得是我们自己的游戏模式和pawn。\n\n![image-20250806163652154](https://images.waer.ltd/notes/202508061636342.png)\n\n![image-20250806163749912](https://images.waer.ltd/notes/202508061637953.png)\n\n- 创建 C++类，通过代码处理相机相关得内容，同时也为后续的移动操作做准备。\n\n![image-20250806164451298](https://images.waer.ltd/notes/202508061644471.png)\n\n- 创建相机吊臂和相机组件，在头文件的 **GENERATED_BODY()**下面声明相机臂和相机组件.\n\n![image-20250806170308464](https://images.waer.ltd/notes/202508061703565.png)\n\n- 在源文件中创建相机臂和相机，以及角色相关配置；\n\n![image-20250806170516479](https://images.waer.ltd/notes/202508061705544.png)\n\n上述代码过程中，可能会提示缺少相关头文件的导入，按需导入即可。我用的是Rider，自身提供了辅助导入的功能，下面是一些需要导入的头文件。\n\n```cpp\n#include \"Components/CapsuleComponent.h\"\n#include \"GameFramework/SpringArmComponent.h\"\n#include \"Camera/CameraComponent.h\"\n```\n\n> 构建编译代码，然后最好是在UE编辑器中再次点击编译代码，然后运行游戏看看效果。\n\n![image-20250806171628761](https://images.waer.ltd/notes/202508061716139.png)\n\nok ,到此为止，我们已经完成了自定义角色的第三人称视角的创建。接下来就是处理角色的移动操作了，包括四个方向的跑动，以及向上跳跃和步行的功能，当然，也包括通过鼠标调整角色视角的操作。\n\n---\n\n## 增强输入-四个方向的跑动功能\n\n1. 打开`IA_Move`输入操作\n2. 在打开的设置面板中，将 **值类型**选择为 **Axis2D**,因为角色的移动是在两个轴上完成的，分别是向前轴（该输入操作的Y轴）和横向轴（该输入操作的X轴）。\n3. 添加触发器，类型为 **下移**，**驱动阈值**设置为0.1。确保其中一个键的触发驱动阈值至少为0.1时调用这个输入操作。\n\n![image-20250806181051716](https://images.waer.ltd/notes/202508061810838.png)\n\n4. 创建并打开输入情景映射 **IC_Character**\n5. 将前面创建的输入操作添加到映射中，点击映射右侧的加号进行添加。在下拉操作中设置第一个操作按键，这里添加游戏手柄左摇杆的Y轴。\n\n![image-20250806183440884](https://images.waer.ltd/notes/202508061834963.png)\n\n因为我们希望这个键控制输入操作的Y轴而不是X轴，因此我们还需要添加带有 **YXZ**值的  **拌合输入轴值**的修改器。\n\n![image-20250806183705969](https://images.waer.ltd/notes/202508061837013.png)\n\n6. 新增一个 **游戏手柄左摇杆X轴**的映射，不需要其他操作。\n7. 上述两个键的操作主要是针对游戏手柄的控制，下面开始新增常规的键盘控制，使用 **WASD**的经典方式控制角色移动。\n8. 添加 W 键，因为这个键用来控制向前移动，所以使用 Y 轴，再添加一个修改器，设置为 **拌合输入轴值**，其值排序为 **YXZ**\n9. 同理添加一个 S 键，用于向后移动，同样使用 Y 轴，同样添加一个 **拌合输入轴值**的修改器，排序与 W 键相同，另外，由于这个键的操作和 W 是反向操作，我们还需要添加另一个 **修改器**为 **否定**，因为我们希望该键按下时，移动输入操作在 Y 轴上的值为 **-1**，与 W 按下是的 **1**相反。\n10. 添加 D 键，用于向右移动，所以使用 X 轴的正向端，不需要任何修改器。\n11. 添加 A 键，用于控制左移，使用 X 轴的负向端，添加一个**否定**修改器即可。\n\n![image-20250806185036207](https://images.waer.ltd/notes/202508061850266.png)\n\n---\n\n## 添加跳跃输入操作\n\n1. 创建一个名为 **IA_Jump**的输入操作资产并打开。\n2. 添加一个 **下移**触发器，并保持 **驱动阈值**为 **0.5**,其中的 **值类型**保持默认的数字类型即可。\n\n![image-20250806185426367](https://images.waer.ltd/notes/202508061854419.png)\n\n3. 打开刚刚的输入情景映射操作面板，新增一组映射 **IA_Jump** 并添加两个操作键，分别是 **空格键和游戏手柄正面按钮下**。\n\n![image-20250806185847352](https://images.waer.ltd/notes/202508061858423.png)\n\n按照一般顺序，接下来应该继续添加鼠标控制视角的输入相关操作，但是这里选择先跳过，接下来使用代码对增强输入操作进行监听和逻辑响应。\n\n---\n\n## 监听移动和跳跃的输入操作\n\n在之前创建的类中，已经存在了输入操作相关的方法，玩家控制器或角色监听输入操作的主要方式是使用 `SetupPlayerInputcomponent`函数进行注册输入操作委托。因此，现在可以按照下面的步骤，使用我们之前创建好的角色类来完成输入操作的监听。\n\n1. 在类头文件中新增两个带有 **UPROPERTY**相关属性的组件声明，主要是声明两个组件，分别是输入映射上下文和输入操作相关的组件，**避免包含完整头文件，提高编译速度**。\n\n![image-20250806191302601](https://images.waer.ltd/notes/202508061913681.png)\n\n2. 打开该类对应的源文件，确保自动生成的代码模板中包含了下面的方法\n\n![image-20250806191826868](https://images.waer.ltd/notes/202508061918920.png)\n\n由于虚幻引擎存在两种输入方式，我们这里需要先将默认的输入方式转为增强输入，首先将`PlayerInputComponent`参数强转为`UEnhancedInputComponent`增强输入组件类。\n\n![image-20250806192524442](https://images.waer.ltd/notes/202508061925507.png)\n\n接下来将 `Controller`属性转为玩家控制器类 `APlayerController`，注意判空。\n\n![image-20250806193120652](https://images.waer.ltd/notes/202508061931722.png)\n\n待办你也看到了，下一步就是完成 **增强输入子系统**的获取，用来管理输入映射上下文相关的内容。由于获取的是本地当前玩家的输入子系统，我们可以使用`ULocalPlayer::GetSubsystem`方法来获取。\n\n![image-20250806194324588](https://images.waer.ltd/notes/202508061943663.png)\n\n4. 目前为止，我们已经完成了输入映射情景的逻辑，接下来需要添加监听输入操作的逻辑。调用 `BindAction`函数进行输入操作绑定，该函数接受以下参数：\n\n> 1. **`IA_Move`** - 输入动作对象\n>    - 类型：`UInputAction*`\n>    - 这是一个输入动作资产，定义了逻辑上的输入行为（如\"移动\"）\n>\n> 2. **`ETriggerEvent::Triggered`** - 触发事件类型\n>    - 类型：`ETriggerEvent`\n>    - 指定何时调用绑定的函数\n>    - 常用值：\n>      - `Started` - 输入开始时\n>      - `Ongoing` - 输入持续期间\n>      - `Triggered` - 输入被触发时（最常用）\n>      - `Completed` - 输入完成时\n>      - `Canceled` - 输入被取消时\n>\n> 3. **`this`** - 对象实例\n>    - 指向当前角色实例，表示在哪个对象上调用处理函数\n>\n> 4. **`&AMyCharacter::Move`** - 成员函数指针\n>    - 类型：函数指针\n>    - 指向要调用的处理函数\n>    - 函数签名通常为：`void Move(const FInputActionValue& Value)`\n>\n> 这种绑定方式让输入系统知道：当 `IA_Move` 动作被触发时，调用当前角色的 `Move` 函数来处理移动逻辑。\n\n![image-20250806195619046](https://images.waer.ltd/notes/202508061956121.png)\n\n> 注意，我们调用的 move 函数还是红色的，因为我们现在还没有实现这个方法，这将在添加完跳跃绑定之后一起实现。\n\n4. 同理添加跳跃输入绑定，参考添加移动输入绑定的代码，这里有一些变动，主要是触发事件类型上有所不同。\n\n![image-20250806213426801](https://images.waer.ltd/notes/202508062134880.png)\n\n5. 实现移动函数,首先在头文件中声明函数信息，然后在源文件中进行实现。\n\n   ![image-20250806213556282](https://images.waer.ltd/notes/202508062135336.png)\n\n![image-20250806213710998](https://images.waer.ltd/notes/202508062137061.png)\n\n可能你会注意到，整个过程中我们并没有手动定义和实现跳跃相关的方法，这是因为这是因为 `Jump` 和 `StopJumping` 是 UE 中 `ACharacter` 类已经提供的内置函数。跳跃是角色的基础行为，UE 的 `ACharacter` 类已经提供了标准的跳跃实现，包括重力、落地检测等物理逻辑，大多数情况下直接使用即可。\n\n6. 将增强输入插件添加到项目中，打开项目的构建文件.cs 文件，在 **PublicDependencyModuleNames** 数组中追加增强输入插件：\n\n![image-20250807094816634](https://images.waer.ltd/notes/202508070948148.png)\n\n7. 进入虚幻编辑器，在 **项目设置**中配置输入操作。打开 **BP_Character**，在 **细节**面板中进行设置。\n\n![image-20250807095431555](https://images.waer.ltd/notes/202508070954721.png)\n\n8. 运行游戏，查看效果。\n\n---\n\n## 围绕角色的视角转向与行走功能\n\n摄像机在游戏中是一个很重要的功能，决定了玩家的视角，决定玩家在游戏世界中能看到什么以及看到方式。在第三人称中，玩家不仅能看到周围世界，还可以看到自己控制的角色本身的状态。\n\n为了实现玩家视角转向功能，我们需要新增一个输入操作，命名为 **IA_Look**，复制之前的 **IA_Move**该一下名称。\n\n1. 打开输入情景映射，新增刚才的输入操作映射。\n\n![image-20250807180050974](https://images.waer.ltd/notes/202508071800211.png)\n\n2. 同理，我们还需要新增一个输入操作 **IA_Walk**.\n\n   ![image-20250807180246062](https://images.waer.ltd/notes/202508071802125.png)\n\n3. 回到代码编辑器，完成视角转向和行走功能的逻辑。由于很多内容都是相似的，就不再一一解释了，结合注释即可理解。\n\n![image-20250807180451394](https://images.waer.ltd/notes/202508071804476.png)\n\n![image-20250807180438181](https://images.waer.ltd/notes/202508071804387.png)\n\n![image-20250807180516059](https://images.waer.ltd/notes/202508071805130.png)\n\n![image-20250807180523708](https://images.waer.ltd/notes/202508071805757.png)\n\n4. 在角色蓝图的 **细节**面板中新增刚才创建的视角转换和行走这两个输入操作。\n\n![](https://images.waer.ltd/notes/202508071806497.png)\n\n5. 启动游戏，查看效果', 'https://images.waer.ltd/notes/202508061705544.png', 4, 1, 'PUBLISHED', 1, 181, '2025-08-12 19:29:58', '2025-08-12 18:58:18', '2025-08-20 21:48:35');
INSERT INTO `articles` (`id`, `title`, `summary`, `content`, `cover_image`, `category_id`, `author_id`, `status`, `is_top`, `view_count`, `published_at`, `created_at`, `updated_at`) VALUES (8, '《黑神话：悟空》官方游戏科学新作《黑神话：钟馗》先导预告片', '捉山中鬼易、斩心中鬼难！《黑神话：悟空》官方游戏科学新作《黑神话：钟馗》先导预告片', '捉山中鬼易、斩心中鬼难！《黑神话：悟空》官方游戏科学新作《黑神话：钟馗》先导预告片\nhttps://www.bilibili.com/video/BV12PeTzYEqm?t=47.4', 'https://ultimate-img.oss-cn-beijing.aliyuncs.com/covers/20250820/b5df51a15af7477a83aff13f5401c8ec.png', NULL, 1, 'PUBLISHED', 0, 25, '2025-08-20 20:53:27', '2025-08-20 20:53:27', '2025-08-21 00:23:05');
COMMIT;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of categories
-- ----------------------------
BEGIN;
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (2, '生活随笔 1', '记录生活中的点点滴滴', 2, '2025-08-12 12:54:47', '2025-08-13 09:27:57');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (3, '项目经验', '分享项目开发经验和心得', 3, '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (4, '学习笔记', '学习过程中的笔记和总结', 4, '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (5, 'Java', 'Java相关技术文章', 1, '2025-08-12 17:34:05', '2025-08-12 17:34:05');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (6, 'Spring Boot', 'Spring Boot框架相关', 2, '2025-08-12 17:34:05', '2025-08-12 17:34:05');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (7, '前端技术', '前端开发相关技术', 3, '2025-08-12 17:34:05', '2025-08-12 17:34:05');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (8, '数据库', '数据库相关技术', 4, '2025-08-12 17:34:05', '2025-08-12 17:34:05');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (11, '游戏开发', '游戏开发大类', 0, '2025-08-13 09:21:56', '2025-08-13 09:21:56');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (12, 'C++', 'C++开发', 0, '2025-08-13 09:22:19', '2025-08-13 09:22:19');
INSERT INTO `categories` (`id`, `name`, `description`, `sort_order`, `created_at`, `updated_at`) VALUES (13, '效率工具', '分享提高工作学习效率的一些好物', 0, '2025-08-13 09:22:48', '2025-08-13 09:22:48');
COMMIT;

-- ----------------------------
-- Table structure for email_subscribers
-- ----------------------------
DROP TABLE IF EXISTS `email_subscribers`;
CREATE TABLE `email_subscribers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `subscribed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `unsubscribed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_email` (`email`),
  KEY `idx_token` (`token`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of email_subscribers
-- ----------------------------
BEGIN;
INSERT INTO `email_subscribers` (`id`, `email`, `token`, `is_active`, `subscribed_at`, `unsubscribed_at`) VALUES (1, 'ilikexff@gmail.com', '147a26d0-9d54-41ba-9e88-58f0fdf0c3e4', 1, '2025-08-12 18:55:18', NULL);
COMMIT;

-- ----------------------------
-- Table structure for friend_links
-- ----------------------------
DROP TABLE IF EXISTS `friend_links`;
CREATE TABLE `friend_links` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of friend_links
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for portfolios
-- ----------------------------
DROP TABLE IF EXISTS `portfolios`;
CREATE TABLE `portfolios` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `technologies` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_featured` (`is_featured`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of portfolios
-- ----------------------------
BEGIN;
INSERT INTO `portfolios` (`id`, `name`, `description`, `url`, `cover_image`, `technologies`, `sort_order`, `is_featured`, `created_at`, `updated_at`) VALUES (1, '红鲱鱼', '一个现代化的综合推理平台', 'https://hherring.cn/', 'https://ultimate-img.oss-cn-beijing.aliyuncs.com/covers/20250820/23f5c48c210346b6ba17bc5148de3c18.png', '', 0, 1, '2025-08-12 18:17:21', '2025-08-20 13:09:32');
COMMIT;

-- ----------------------------
-- Table structure for system_configs
-- ----------------------------
DROP TABLE IF EXISTS `system_configs`;
CREATE TABLE `system_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`),
  KEY `idx_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of system_configs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT '#007bff',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of tags
-- ----------------------------
BEGIN;
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (1, 'Java', '#f89820', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (2, 'Spring Boot', '#6db33f', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (3, 'Vue.js', '#4fc08d', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (4, 'MySQL', '#4479a1', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (5, 'Redis', '#dc382d', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (6, 'Docker', '#2496ed', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (7, '前端', '#61dafb', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (8, '后端', '#68217a', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (9, '算法', '#ff6b6b', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES (10, '数据结构', '#4ecdc4', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `avatar`, `nickname`, `bio`, `created_at`, `updated_at`) VALUES (1, 'xuyi', '$2a$10$al.leQpHXmJguWmJYkxATeTexpZoleE1E8gqOhaIfipkNjxNeoWDa', 'xuyi@example.com', 'https://avatars.githubusercontent.com/u/1?v=4', '慕予', '全栈开发工程师，专注于Java和前端技术', '2025-08-12 12:54:47', '2025-08-22 10:27:09');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `avatar`, `nickname`, `bio`, `created_at`, `updated_at`) VALUES (2, 'testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lIkTJpKI2xdtNNETO', 'test@example.com', 'https://avatars.githubusercontent.com/u/2?v=4', '测试用户', '这是一个测试用户', '2025-08-12 12:54:47', '2025-08-12 12:54:47');
COMMIT;

-- ----------------------------
-- Table structure for visit_logs
-- ----------------------------
DROP TABLE IF EXISTS `visit_logs`;
CREATE TABLE `visit_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `referer` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_uri` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visit_date` date NOT NULL,
  `visit_count` int DEFAULT '1',
  `first_visit_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_visit_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ip_date` (`ip_address`,`visit_date`),
  KEY `idx_visit_date` (`visit_date`),
  KEY `idx_ip_address` (`ip_address`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of visit_logs
-- ----------------------------
BEGIN;
INSERT INTO `visit_logs` (`id`, `ip_address`, `user_agent`, `referer`, `request_uri`, `visit_date`, `visit_count`, `first_visit_time`, `last_visit_time`) VALUES (1, '192.168.1.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'http://localhost:5173/', '/api/articles', '2025-08-14', 6, '2025-08-14 17:19:37', '2025-08-14 17:43:29');
INSERT INTO `visit_logs` (`id`, `ip_address`, `user_agent`, `referer`, `request_uri`, `visit_date`, `visit_count`, `first_visit_time`, `last_visit_time`) VALUES (4, '192.168.1.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'http://localhost:5173/', '/api/articles', '2025-08-15', 69, '2025-08-15 14:19:49', '2025-08-15 18:48:31');
INSERT INTO `visit_logs` (`id`, `ip_address`, `user_agent`, `referer`, `request_uri`, `visit_date`, `visit_count`, `first_visit_time`, `last_visit_time`) VALUES (8, '192.168.1.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'http://localhost:5173/', '/api/tags/popular', '2025-08-16', 12, '2025-08-16 12:26:12', '2025-08-16 12:58:26');
INSERT INTO `visit_logs` (`id`, `ip_address`, `user_agent`, `referer`, `request_uri`, `visit_date`, `visit_count`, `first_visit_time`, `last_visit_time`) VALUES (10, '127.0.0.1', 'curl/8.7.1', NULL, '/api/articles', '2025-08-20', 114, '2025-08-20 12:32:36', '2025-08-20 20:10:29');
INSERT INTO `visit_logs` (`id`, `ip_address`, `user_agent`, `referer`, `request_uri`, `visit_date`, `visit_count`, `first_visit_time`, `last_visit_time`) VALUES (12, '192.168.1.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'http://localhost:5174/', '/api/articles', '2025-08-20', 285, '2025-08-20 16:59:32', '2025-08-20 21:48:36');
INSERT INTO `visit_logs` (`id`, `ip_address`, `user_agent`, `referer`, `request_uri`, `visit_date`, `visit_count`, `first_visit_time`, `last_visit_time`) VALUES (13, '192.168.1.6', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'http://localhost:5174/article/8', '/api/articles/8', '2025-08-21', 24, '2025-08-21 00:23:06', '2025-08-21 11:53:12');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
