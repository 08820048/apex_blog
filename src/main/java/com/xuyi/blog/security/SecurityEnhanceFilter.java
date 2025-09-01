package com.xuyi.blog.security;

import com.xuyi.blog.util.IpUtils;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 安全增强过滤器
 * 防止恶意攻击、SQL注入、XSS等
 * 
 * @author xuyi
 */
@Component
@Slf4j
public class SecurityEnhanceFilter extends OncePerRequestFilter {

    @Value("${spring.profiles.active:prod}")
    private String activeProfile;

    // 恶意IP黑名单（内存存储）
    private final ConcurrentHashMap<String, AtomicInteger> suspiciousIps = new ConcurrentHashMap<>();
    
    // SQL注入关键词
    private static final List<String> SQL_INJECTION_PATTERNS = Arrays.asList(
        "select", "insert", "update", "delete", "drop", "create", "alter",
        "union", "script", "javascript", "vbscript", "onload", "onerror",
        "eval", "expression", "alert", "confirm", "prompt", "document.cookie",
        "window.location", "document.write", "<script", "</script>",
        "exec", "execute", "sp_", "xp_", "cmdshell", "char(", "ascii(",
        "waitfor", "delay", "benchmark", "sleep(", "pg_sleep", "dbms_pipe"
    );

    // 危险文件扩展名
    private static final List<String> DANGEROUS_EXTENSIONS = Arrays.asList(
        ".jsp", ".asp", ".aspx", ".php", ".exe", ".bat", ".cmd", ".sh",
        ".ps1", ".vbs", ".jar", ".war", ".ear"
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        
        String clientIp = IpUtils.getClientIp(request);
        String requestUri = request.getRequestURI();
        String queryString = request.getQueryString();
        String userAgent = request.getHeader("User-Agent");
        
        // 1. 检查恶意请求
        if (isMaliciousRequest(requestUri, queryString, userAgent)) {
            handleMaliciousRequest(response, clientIp, "恶意请求检测");
            return;
        }
        
        // 2. 检查SQL注入
        if (containsSqlInjection(requestUri, queryString)) {
            handleMaliciousRequest(response, clientIp, "SQL注入尝试");
            return;
        }
        
        // 3. 检查XSS攻击
        if (containsXss(requestUri, queryString)) {
            handleMaliciousRequest(response, clientIp, "XSS攻击尝试");
            return;
        }
        
        // 4. 检查路径遍历攻击
        if (containsPathTraversal(requestUri)) {
            handleMaliciousRequest(response, clientIp, "路径遍历攻击");
            return;
        }
        
        // 5. 检查文件上传攻击
        if (containsDangerousFileExtension(requestUri)) {
            handleMaliciousRequest(response, clientIp, "危险文件访问");
            return;
        }
        
        // 6. 添加安全响应头
        addSecurityHeaders(response);
        
        filterChain.doFilter(request, response);
    }

    /**
     * 检查是否为恶意请求
     */
    private boolean isMaliciousRequest(String requestUri, String queryString, String userAgent) {
        // 开发环境下放宽限制
        if ("dev".equals(activeProfile)) {
            return false;
        }

        // 检查User-Agent
        if (userAgent == null || userAgent.trim().isEmpty()) {
            return true;
        }

        // 检查常见的恶意User-Agent
        String lowerUserAgent = userAgent.toLowerCase();
        if (lowerUserAgent.contains("sqlmap") ||
            lowerUserAgent.contains("nmap") ||
            lowerUserAgent.contains("nikto") ||
            lowerUserAgent.contains("masscan") ||
            lowerUserAgent.contains("python-requests")) {
            return true;
        }
        
        // 检查异常长的URI
        if (requestUri.length() > 2048) {
            return true;
        }
        
        // 检查异常长的查询字符串
        if (queryString != null && queryString.length() > 4096) {
            return true;
        }
        
        return false;
    }

    /**
     * 检查SQL注入
     */
    private boolean containsSqlInjection(String requestUri, String queryString) {
        String content = (requestUri + " " + (queryString != null ? queryString : "")).toLowerCase();
        
        return SQL_INJECTION_PATTERNS.stream()
                .anyMatch(pattern -> content.contains(pattern.toLowerCase()));
    }

    /**
     * 检查XSS攻击
     */
    private boolean containsXss(String requestUri, String queryString) {
        String content = requestUri + " " + (queryString != null ? queryString : "");
        
        // 检查常见的XSS模式
        return content.contains("<script") ||
               content.contains("javascript:") ||
               content.contains("onload=") ||
               content.contains("onerror=") ||
               content.contains("alert(") ||
               content.contains("document.cookie") ||
               content.contains("window.location") ||
               content.contains("eval(");
    }

    /**
     * 检查路径遍历攻击
     */
    private boolean containsPathTraversal(String requestUri) {
        return requestUri.contains("../") ||
               requestUri.contains("..\\") ||
               requestUri.contains("%2e%2e") ||
               requestUri.contains("..%2f") ||
               requestUri.contains("..%5c");
    }

    /**
     * 检查危险文件扩展名
     */
    private boolean containsDangerousFileExtension(String requestUri) {
        String lowerUri = requestUri.toLowerCase();
        return DANGEROUS_EXTENSIONS.stream()
                .anyMatch(lowerUri::endsWith);
    }

    /**
     * 处理恶意请求
     */
    private void handleMaliciousRequest(HttpServletResponse response, String clientIp, String reason) 
            throws IOException {
        
        // 记录可疑IP
        suspiciousIps.computeIfAbsent(clientIp, k -> new AtomicInteger(0)).incrementAndGet();
        
        log.warn("检测到恶意请求 - IP: {}, 原因: {}, 累计次数: {}",
                IpUtils.maskIp(clientIp), reason, suspiciousIps.get(clientIp).get());
        
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"code\":403,\"message\":\"请求被拒绝\",\"data\":null}");
    }

    /**
     * 添加安全响应头
     */
    private void addSecurityHeaders(HttpServletResponse response) {
        // 防止点击劫持
        response.setHeader("X-Frame-Options", "DENY");
        
        // 防止MIME类型嗅探
        response.setHeader("X-Content-Type-Options", "nosniff");
        
        // XSS保护
        response.setHeader("X-XSS-Protection", "1; mode=block");
        
        // 强制HTTPS（生产环境）
        response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        
        // 内容安全策略
        response.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' 'unsafe-eval'; " +
            "style-src 'self' 'unsafe-inline'; " +
            "img-src 'self' data: https:; " +
            "font-src 'self' data:; " +
            "connect-src 'self'");
        
        // 引用策略
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        
        // 权限策略
        response.setHeader("Permissions-Policy", 
            "camera=(), microphone=(), geolocation=(), payment=()");
    }

    /**
     * 获取可疑IP统计
     */
    public ConcurrentHashMap<String, AtomicInteger> getSuspiciousIps() {
        return new ConcurrentHashMap<>(suspiciousIps);
    }

    /**
     * 清理可疑IP记录
     */
    public void clearSuspiciousIps() {
        suspiciousIps.clear();
        log.info("已清理可疑IP记录");
    }
}
