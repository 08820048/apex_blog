package com.xuyi.blog.service;

import com.xuyi.blog.entity.User;
import com.xuyi.blog.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 密码修改功能测试
 * 
 * @author xuyi
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class AuthServicePasswordTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    private User testUser;
    private final String originalPassword = "oldPassword123";
    private final String newPassword = "newPassword456";

    @BeforeEach
    void setUp() {
        // 创建测试用户
        testUser = new User();
        testUser.setUsername("testuser");
        testUser.setPassword(authService.encodePassword(originalPassword));
        testUser.setEmail("test@example.com");
        testUser.setNickname("Test User");
        testUser = userRepository.save(testUser);
    }

    @Test
    void testChangePasswordSuccess() {
        // 正常修改密码
        assertDoesNotThrow(() -> {
            authService.changePassword(testUser.getUsername(), originalPassword, newPassword, newPassword);
        });

        // 验证密码已更改
        User updatedUser = userRepository.findByUsername(testUser.getUsername()).orElseThrow();
        assertTrue(authService.validatePassword(newPassword, updatedUser.getPassword()));
        assertFalse(authService.validatePassword(originalPassword, updatedUser.getPassword()));
    }

    @Test
    void testChangePasswordWithWrongCurrentPassword() {
        // 当前密码错误
        assertThrows(BadCredentialsException.class, () -> {
            authService.changePassword(testUser.getUsername(), "wrongPassword", newPassword, newPassword);
        });
    }

    @Test
    void testChangePasswordWithMismatchedConfirmation() {
        // 新密码和确认密码不一致
        assertThrows(IllegalArgumentException.class, () -> {
            authService.changePassword(testUser.getUsername(), originalPassword, newPassword, "differentPassword");
        });
    }

    @Test
    void testChangePasswordWithSamePassword() {
        // 新密码与当前密码相同
        assertThrows(IllegalArgumentException.class, () -> {
            authService.changePassword(testUser.getUsername(), originalPassword, originalPassword, originalPassword);
        });
    }

    @Test
    void testChangePasswordWithNonExistentUser() {
        // 用户不存在
        assertThrows(BadCredentialsException.class, () -> {
            authService.changePassword("nonexistent", originalPassword, newPassword, newPassword);
        });
    }
}
