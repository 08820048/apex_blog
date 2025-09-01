package com.xuyi.blog.security;

import com.xuyi.blog.service.SecurityAuditService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * 管理员访问控制过滤器
 * 额外的安全层，监控和记录所有管理员操作
 * 
 * @author xuyi
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class AdminAccessControlFilter extends OncePerRequestFilter {

    private final SecurityAuditService securityAuditService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        
        String requestUri = request.getRequestURI();
        String method = request.getMethod();
        
        // 检查是否是管理员接口访问
        if (requestUri.startsWith("/admin/")) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            
            if (authentication != null && authentication.isAuthenticated()) {
                String username = authentication.getName();
                
                // 记录管理员接口访问
                log.info("管理员接口访问 - 用户: {}, 方法: {}, URI: {}", username, method, requestUri);
                
                // 特别关注文章相关操作
                if (requestUri.contains("/admin/articles")) {
                    securityAuditService.logAdminOperation("ADMIN_API_ACCESS", "AdminAPI", requestUri, 
                            String.format("方法: %s, URI: %s", method, requestUri));
                }
                
                // 检查可疑的批量操作
                if (isSuspiciousBatchOperation(requestUri, method)) {
                    securityAuditService.logSuspiciousActivity("POTENTIAL_BATCH_OPERATION", 
                            String.format("用户 %s 尝试批量操作: %s %s", username, method, requestUri));
                }
            } else {
                // 未认证用户尝试访问管理员接口
                securityAuditService.logSuspiciousActivity("UNAUTHORIZED_ADMIN_ACCESS", 
                        String.format("未认证用户尝试访问: %s %s", method, requestUri));
                
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
        }
        
        filterChain.doFilter(request, response);
    }

    /**
     * 检查是否为可疑的批量操作
     */
    private boolean isSuspiciousBatchOperation(String requestUri, String method) {
        // 检查是否包含批量操作的特征
        if ("DELETE".equals(method) && requestUri.contains("/admin/")) {
            return true;
        }
        
        // 检查是否有多个ID参数（可能的批量操作）
        if (requestUri.contains("ids=") || requestUri.contains("batch")) {
            return true;
        }
        
        return false;
    }
}
