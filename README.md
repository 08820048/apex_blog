
# ApexBlog - 轻量化个人博客系统

## 项目简介

ApexBlog 是一个基于 Spring Boot 3.x 开发的轻量化个人博客系统，采用前后端分离架构，追求极致的性能和简洁的设计。

## 📸 系统预览

### 前台界面
<div align="center">

**首页展示**
![首页](https://images.waer.ltd/notes/202509011625643.png)

**文章详情页**
![文章详情](https://images.waer.ltd/notes/202509011625617.png)

**分类页面**
![分类页面](https://images.waer.ltd/notes/202509011626870.png)

</div>


<div align="center">

**后台首页**
![后台首页](https://images.waer.ltd/notes/202509011627937.png)

**文章管理**
![文章管理](https://images.waer.ltd/notes/202509011628464.png)

**文章编辑**
![文章编辑](https://images.waer.ltd/notes/202509011628802.png)

**分类管理**
![分类管理](https://images.waer.ltd/notes/202509011628496.png)

**系统统计**
![系统统计](https://images.waer.ltd/notes/202509011629136.png)

</div>

## 🚀 相关项目

本项目是 ApexBlog 的后端服务，完整的博客系统还包括：

- **🔧 后端服务**: [apex_blog](https://github.com/08820048/apex_blog) (当前项目)
- **🎨 前台界面**: [apex_ft](https://github.com/08820048/apex_ft) - 博客前台展示页面
- **⚙️ 后台管理**: [apex_admin](https://github.com/08820048/apex_admin) - 博客后台管理系统

## 🏗️ 系统架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   前台界面       │    │   后台管理       │    │   后端服务       │
│   (apex_ft)     │    │   (apex_admin)   │    │   (apex_blog)   │
│                 │    │                 │    │                 │
│  - 文章浏览      │    │  - 文章管理      │    │  - RESTful API  │
│  - 分类标签      │    │  - 用户认证      │    │  - 数据库操作    │
│  - 搜索功能      │    │  - 数据统计      │    │  - 缓存管理      │
│  - RSS订阅      │    │  - 系统配置      │    │  - 邮件服务      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   数据存储       │
                    │                 │
                    │  - MySQL 数据库  │
                    │  - 内存缓存      │
                    │  - 文件存储      │
                    └─────────────────┘
```

## 技术栈

- **后端框架**: Spring Boot 3.2.0
- **Java版本**: Java 17
- **构建工具**: Gradle 8.5
- **数据库**: MySQL 8.0
- **缓存**: Spring Cache (内存缓存)
- **安全认证**: Spring Security + JWT
- **API文档**: SpringDoc OpenAPI 3
- **容器化**: Docker + Docker Compose

## 主要功能

### 前台功能
- ✅ 文章浏览（支持Markdown渲染）
- ✅ 文章搜索（全文搜索）
- ✅ 分类和标签浏览
- ✅ 作品集展示
- ✅ 友链展示
- ✅ RSS订阅
- ✅ 邮箱订阅
- ✅ 访问统计

### 后台功能
- ✅ 文章管理（CRUD、发布、归档）
- ✅ 分类和标签管理
- ✅ 作品集管理
- ✅ 友链管理
- ✅ 邮箱订阅管理
- ✅ 访问统计查看
- ✅ 用户认证（仅限博主登录）

### 技术特性
- ✅ 内存缓存优化
- ✅ 异步任务处理
- ✅ 访问统计（IP去重）
- ✅ 邮件通知
- ✅ 全文搜索
- ✅ RESTful API
- ✅ Docker部署
- ✅ 性能监控

## 快速开始

### 环境要求

- Java 17+
- MySQL 8.0+
- Docker & Docker Compose（可选）

### 本地开发

1. **克隆项目**
```bash
git clone https://github.com/08820048/apex_blog.git
cd apex_blog
```

2. **配置数据库**
```sql
CREATE DATABASE apex_blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. **配置环境变量**
```bash
cp .env.example .env
# 编辑 .env 文件，配置数据库和邮件等信息
```

4. **运行应用**
```bash
./gradlew bootRun
```

5. **访问应用**
- API文档: http://localhost:8888/api/swagger-ui.html
- 健康检查: http://localhost:8888/api/actuator/health

### Docker部署

1. **使用部署脚本**
```bash
# 启动所有服务
./deploy.sh start

# 启动服务并包含Nginx
./deploy.sh start --with-nginx

# 查看服务状态
./deploy.sh status

# 查看日志
./deploy.sh logs

# 停止服务
./deploy.sh stop
```

2. **手动部署**
```bash
# 复制环境变量文件
cp .env.example .env

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

## API文档

启动应用后，访问 [Swagger UI](http://localhost:8888/api/swagger-ui.html) 查看完整的API文档。

### 主要接口

#### 前台接口
- `GET /articles` - 获取文章列表
- `GET /articles/{id}` - 获取文章详情
- `GET /articles/search` - 搜索文章
- `GET /categories` - 获取分类列表
- `GET /tags` - 获取标签列表
- `GET /portfolios` - 获取作品集
- `GET /friend-links` - 获取友链
- `GET /rss/feed.xml` - RSS订阅
- `POST /email-subscribers/subscribe` - 邮箱订阅

#### 后台接口（需要认证）
- `POST /auth/login` - 用户登录
- `POST /admin/articles` - 创建文章
- `PUT /admin/articles/{id}` - 更新文章
- `DELETE /admin/articles/{id}` - 删除文章

## 配置说明

### 应用配置

主要配置文件位于 `src/main/resources/application.yml`：

```yaml
server:
  port: 8888  # 应用端口

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/apex_blog
    username: root
    password: ${DB_PASSWORD:password}

  cache:
    type: simple  # 使用简单内存缓存

jwt:
  secret: ${JWT_SECRET:your-secret-key}
  expiration: 86400000  # 24小时

blog:
  title: "Xuyi's Blog"
  description: "个人技术博客"
  author: "xuyi"
  url: ${BLOG_URL:http://localhost:8888}
```

### 环境变量

```bash
# 数据库配置
DB_PASSWORD=your_password

# JWT配置
JWT_SECRET=your-jwt-secret

# 邮件配置
MAIL_HOST=smtp.gmail.com
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# 博客配置
BLOG_URL=https://yourdomain.com
```

## 性能优化

### 缓存策略
- 文章列表缓存：2小时
- 文章详情缓存：2小时
- 分类标签缓存：6小时
- 搜索结果缓存：30分钟
- 访问统计缓存：10分钟

### 数据库优化
- 使用索引优化查询
- 连接池配置
- 批量操作优化
- 分页查询

### 异步处理
- 邮件发送异步化
- 访问统计异步记录
- 缓存预热

## 部署建议

### 生产环境
1. 使用外部MySQL服务
2. 配置SSL证书
3. 使用Nginx反向代理
4. 配置日志收集
5. 设置监控告警

### 安全配置
1. 修改默认端口
2. 配置强密码
3. 启用HTTPS
4. 配置防火墙
5. 定期备份数据

## 开发指南

### 项目结构
```
src/main/java/com/xuyi/blog/
├── config/          # 配置类
├── controller/      # 控制器
├── dto/            # 数据传输对象
├── entity/         # 实体类
├── exception/      # 异常处理
├── repository/     # 数据访问层
├── security/       # 安全配置
├── service/        # 业务逻辑层
└── util/           # 工具类
```

### 开发规范
1. 遵循RESTful API设计
2. 使用统一的响应格式
3. 完善的异常处理
4. 详细的API文档
5. 单元测试覆盖

### 测试
```bash
# 运行所有测试
./gradlew test

# 运行特定测试
./gradlew test --tests ArticleServiceTest

# 生成测试报告
./gradlew jacocoTestReport
```

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

- 作者: xuyi
- 邮箱: xuyi@example.com
- 博客: https://yourblog.com

## 更新日志

### v1.0.0 (2024-01-01)
- 初始版本发布
- 完成基础功能开发
- 支持Docker部署
- 完善API文档

---

如果这个项目对你有帮助，请给个 ⭐️ 支持一下！
