# 配置说明 / Configuration Guide

本项目使用环境变量来管理敏感配置信息。在部署前，请根据以下说明设置相应的环境变量。

This project uses environment variables to manage sensitive configuration information. Please set the corresponding environment variables according to the following instructions before deployment.

## 必需的环境变量 / Required Environment Variables

### 数据库配置 / Database Configuration
```bash
DB_PASSWORD=your_database_password
```
- 描述：MySQL数据库密码
- Description: MySQL database password

### 邮件服务配置 / Email Service Configuration
```bash
MAIL_USERNAME=your_email@example.com
MAIL_PASSWORD=your_email_password
```
- 描述：用于发送邮件的邮箱账号和密码（如果使用163邮箱，密码应为授权码）
- Description: Email account and password for sending emails (if using 163 email, password should be authorization code)

### JWT配置 / JWT Configuration
```bash
JWT_SECRET=your_jwt_secret_key_here
```
- 描述：JWT令牌签名密钥，建议使用长度至少32位的随机字符串
- Description: JWT token signing key, recommend using a random string of at least 32 characters

### 博客配置 / Blog Configuration
```bash
BLOG_EMAIL=your_blog_email@example.com
```
- 描述：博客联系邮箱
- Description: Blog contact email

### 阿里云OSS配置 / Aliyun OSS Configuration
```bash
ALIYUN_OSS_ENDPOINT=https://oss-cn-beijing.aliyuncs.com
ALIYUN_OSS_ACCESS_KEY_ID=your_access_key_id
ALIYUN_OSS_ACCESS_KEY_SECRET=your_access_key_secret
ALIYUN_OSS_BUCKET_NAME=your_bucket_name
ALIYUN_OSS_BASE_URL=https://your-bucket.oss-cn-beijing.aliyuncs.com/
```
- 描述：阿里云对象存储服务配置，用于文件上传
- Description: Aliyun Object Storage Service configuration for file uploads

## 设置环境变量的方法 / Methods to Set Environment Variables

### 1. 使用 .env 文件 / Using .env file
在项目根目录创建 `.env` 文件：
Create a `.env` file in the project root directory:

```bash
# Database
DB_PASSWORD=your_actual_password

# Email
MAIL_USERNAME=your_actual_email@163.com
MAIL_PASSWORD=your_actual_email_password

# JWT
JWT_SECRET=your_actual_jwt_secret_key

# Blog
BLOG_EMAIL=your_actual_blog_email@example.com

# Aliyun OSS
ALIYUN_OSS_ENDPOINT=https://oss-cn-beijing.aliyuncs.com
ALIYUN_OSS_ACCESS_KEY_ID=your_actual_access_key_id
ALIYUN_OSS_ACCESS_KEY_SECRET=your_actual_access_key_secret
ALIYUN_OSS_BUCKET_NAME=your_actual_bucket_name
ALIYUN_OSS_BASE_URL=https://your-actual-bucket.oss-cn-beijing.aliyuncs.com/
```

### 2. 系统环境变量 / System Environment Variables
```bash
export DB_PASSWORD="your_actual_password"
export MAIL_USERNAME="your_actual_email@163.com"
export MAIL_PASSWORD="your_actual_email_password"
export JWT_SECRET="your_actual_jwt_secret_key"
export BLOG_EMAIL="your_actual_blog_email@example.com"
export ALIYUN_OSS_ACCESS_KEY_ID="your_actual_access_key_id"
export ALIYUN_OSS_ACCESS_KEY_SECRET="your_actual_access_key_secret"
export ALIYUN_OSS_BUCKET_NAME="your_actual_bucket_name"
export ALIYUN_OSS_BASE_URL="https://your-actual-bucket.oss-cn-beijing.aliyuncs.com/"
```

### 3. Docker 环境 / Docker Environment
在 `docker-compose.yml` 或 Docker 运行命令中设置：
Set in `docker-compose.yml` or Docker run command:

```yaml
environment:
  - DB_PASSWORD=your_actual_password
  - MAIL_USERNAME=your_actual_email@163.com
  - MAIL_PASSWORD=your_actual_email_password
  - JWT_SECRET=your_actual_jwt_secret_key
  - BLOG_EMAIL=your_actual_blog_email@example.com
  - ALIYUN_OSS_ACCESS_KEY_ID=your_actual_access_key_id
  - ALIYUN_OSS_ACCESS_KEY_SECRET=your_actual_access_key_secret
  - ALIYUN_OSS_BUCKET_NAME=your_actual_bucket_name
  - ALIYUN_OSS_BASE_URL=https://your-actual-bucket.oss-cn-beijing.aliyuncs.com/
```

## 安全提示 / Security Tips

1. **永远不要将包含真实敏感信息的配置文件提交到版本控制系统**
   Never commit configuration files containing real sensitive information to version control

2. **定期更换密钥和密码**
   Regularly rotate keys and passwords

3. **使用强密码和复杂的JWT密钥**
   Use strong passwords and complex JWT keys

4. **在生产环境中使用专门的密钥管理服务**
   Use dedicated key management services in production environments

## 注意事项 / Notes

- `.env` 文件已添加到 `.gitignore` 中，不会被提交到仓库
- The `.env` file is added to `.gitignore` and will not be committed to the repository

- 如果某个环境变量未设置，系统将使用配置文件中的默认值
- If an environment variable is not set, the system will use the default value in the configuration file
