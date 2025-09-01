#!/bin/bash

# ApexBlog 部署脚本
# 作者: xuyi

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查Docker是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker 未安装，请先安装 Docker"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose 未安装，请先安装 Docker Compose"
        exit 1
    fi
    
    log_success "Docker 环境检查通过"
}

# 检查环境变量文件
check_env() {
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            log_warning ".env 文件不存在，正在从 .env.example 复制..."
            cp .env.example .env
            log_warning "请编辑 .env 文件配置相关参数"
        else
            log_error ".env 和 .env.example 文件都不存在"
            exit 1
        fi
    fi
    log_success "环境变量文件检查通过"
}

# 创建必要的目录
create_directories() {
    log_info "创建必要的目录..."
    
    mkdir -p docker/nginx/ssl
    mkdir -p docker/redis
    mkdir -p logs
    mkdir -p uploads
    
    log_success "目录创建完成"
}

# 构建应用
build_app() {
    log_info "构建应用镜像..."
    
    docker-compose build app
    
    log_success "应用镜像构建完成"
}

# 启动服务
start_services() {
    log_info "启动服务..."
    
    # 先启动数据库和Redis
    docker-compose up -d mysql redis
    
    # 等待数据库启动
    log_info "等待数据库启动..."
    sleep 30
    
    # 启动应用
    docker-compose up -d app
    
    # 等待应用启动
    log_info "等待应用启动..."
    sleep 30
    
    # 启动Nginx（可选）
    if [ "$1" = "--with-nginx" ]; then
        docker-compose up -d nginx
        log_info "Nginx 已启动"
    fi
    
    log_success "所有服务启动完成"
}

# 检查服务状态
check_services() {
    log_info "检查服务状态..."
    
    docker-compose ps
    
    # 检查应用健康状态
    log_info "检查应用健康状态..."
    for i in {1..10}; do
        if curl -f http://localhost:8888/api/actuator/health &> /dev/null; then
            log_success "应用健康检查通过"
            break
        else
            log_warning "应用健康检查失败，重试中... ($i/10)"
            sleep 10
        fi
    done
}

# 显示日志
show_logs() {
    log_info "显示应用日志..."
    docker-compose logs -f app
}

# 停止服务
stop_services() {
    log_info "停止服务..."
    docker-compose down
    log_success "服务已停止"
}

# 清理
cleanup() {
    log_info "清理资源..."
    docker-compose down -v --rmi all
    docker system prune -f
    log_success "清理完成"
}

# 备份数据
backup_data() {
    log_info "备份数据..."
    
    BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP_DIR
    
    # 备份数据库
    docker-compose exec mysql mysqldump -u root -p$MYSQL_ROOT_PASSWORD apex_blog > $BACKUP_DIR/database.sql
    
    # 备份上传文件
    if [ -d uploads ]; then
        cp -r uploads $BACKUP_DIR/
    fi
    
    log_success "数据备份完成: $BACKUP_DIR"
}

# 显示帮助信息
show_help() {
    echo "ApexBlog 部署脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  start [--with-nginx]  启动服务"
    echo "  stop                  停止服务"
    echo "  restart               重启服务"
    echo "  logs                  显示日志"
    echo "  status                检查服务状态"
    echo "  backup                备份数据"
    echo "  cleanup               清理资源"
    echo "  help                  显示帮助信息"
    echo ""
}

# 主函数
main() {
    case "$1" in
        start)
            check_docker
            check_env
            create_directories
            build_app
            start_services $2
            check_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            stop_services
            sleep 5
            main start $2
            ;;
        logs)
            show_logs
            ;;
        status)
            check_services
            ;;
        backup)
            backup_data
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
