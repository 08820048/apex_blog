package com.xuyi.blog.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 安全审计服务
 * 记录所有敏感操作的审计日志
 * 
 * @author xuyi
 */
@Service
@Slf4j
public class SecurityAuditService {

    private static final String AUDIT_LOG_PREFIX = "[SECURITY_AUDIT]";
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 记录管理员操作审计日志
     */
    public void logAdminOperation(String operation, String resourceType, String resourceId, String details) {
        String username = getCurrentUsername();
        String timestamp = LocalDateTime.now().format(FORMATTER);
        
        log.warn("{} {} - 用户: {}, 操作: {}, 资源类型: {}, 资源ID: {}, 详情: {}", 
                AUDIT_LOG_PREFIX, timestamp, username, operation, resourceType, resourceId, details);
    }

    /**
     * 记录文章访问审计日志
     */
    public void logArticleAccess(String accessType, Long articleId, String articleStatus) {
        String username = getCurrentUsername();
        String timestamp = LocalDateTime.now().format(FORMATTER);
        
        log.info("{} {} - 用户: {}, 访问类型: {}, 文章ID: {}, 文章状态: {}", 
                AUDIT_LOG_PREFIX, timestamp, username, accessType, articleId, articleStatus);
    }

    /**
     * 记录可疑操作
     */
    public void logSuspiciousActivity(String activity, String details) {
        String username = getCurrentUsername();
        String timestamp = LocalDateTime.now().format(FORMATTER);
        
        log.error("{} {} - 可疑活动 - 用户: {}, 活动: {}, 详情: {}", 
                AUDIT_LOG_PREFIX, timestamp, username, activity, details);
    }

    /**
     * 记录权限验证失败
     */
    public void logAccessDenied(String resource, String requiredRole) {
        String username = getCurrentUsername();
        String timestamp = LocalDateTime.now().format(FORMATTER);
        
        log.warn("{} {} - 权限验证失败 - 用户: {}, 资源: {}, 需要角色: {}", 
                AUDIT_LOG_PREFIX, timestamp, username, resource, requiredRole);
    }

    /**
     * 获取当前用户名
     */
    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return "anonymous";
    }
}
