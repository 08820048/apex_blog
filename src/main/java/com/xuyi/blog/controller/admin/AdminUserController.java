package com.xuyi.blog.controller.admin;

import com.xuyi.blog.dto.ApiResponse;
import com.xuyi.blog.dto.ChangePasswordRequestDTO;
import com.xuyi.blog.dto.UserDTO;
import com.xuyi.blog.service.AuthService;
import com.xuyi.blog.service.SecurityAuditService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

/**
 * 管理后台 - 用户管理控制器
 * 
 * @author xuyi
 */
@RestController
@RequestMapping("/admin/user")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "管理后台 - 用户管理", description = "用户管理相关接口")
@SecurityRequirement(name = "Bearer Authentication")
public class AdminUserController {

    private final AuthService authService;
    private final SecurityAuditService securityAuditService;

    @GetMapping("/profile")
    @Operation(summary = "获取当前用户信息", description = "获取当前登录用户的详细信息")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<UserDTO> getCurrentUser(Authentication authentication) {
        String username = authentication.getName();
        UserDTO user = authService.getCurrentUser(username);
        return ApiResponse.success(user);
    }

    @PutMapping("/change-password")
    @Operation(summary = "修改密码", description = "修改当前用户的登录密码")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> changePassword(
            @Valid @RequestBody ChangePasswordRequestDTO request,
            Authentication authentication) {
        
        String username = authentication.getName();
        
        try {
            authService.changePassword(
                username, 
                request.getCurrentPassword(), 
                request.getNewPassword(), 
                request.getConfirmPassword()
            );
            
            // 记录安全审计日志
            securityAuditService.logAdminOperation("CHANGE_PASSWORD", "User", username, 
                    "管理员修改密码");
            
            log.info("管理员 {} 修改密码成功", username);
            return ApiResponse.success("密码修改成功");
            
        } catch (IllegalArgumentException e) {
            log.warn("管理员 {} 修改密码失败: {}", username, e.getMessage());
            return ApiResponse.error(e.getMessage());
        } catch (Exception e) {
            log.error("管理员 {} 修改密码时发生错误: {}", username, e.getMessage(), e);
            
            // 记录可疑活动
            securityAuditService.logSuspiciousActivity("PASSWORD_CHANGE_ERROR", 
                    String.format("用户 %s 修改密码时发生异常: %s", username, e.getMessage()));
            
            return ApiResponse.error("密码修改失败，请稍后重试");
        }
    }
}
