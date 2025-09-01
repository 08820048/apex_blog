package com.xuyi.blog.security;

import com.xuyi.blog.entity.Article;
import com.xuyi.blog.entity.User;
import com.xuyi.blog.repository.ArticleRepository;
import com.xuyi.blog.service.ArticleService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 文章安全性测试
 * 验证权限控制是否正确实现
 * 
 * @author xuyi
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class ArticleSecurityTest {

    @Autowired
    private ArticleService articleService;

    @Autowired
    private ArticleRepository articleRepository;

    private Article draftArticle;
    private Article publishedArticle;

    @BeforeEach
    void setUp() {
        // 创建测试用户
        User testUser = new User();
        testUser.setUsername("testuser");
        testUser.setPassword("password");
        testUser.setEmail("test@example.com");

        // 创建草稿文章
        draftArticle = new Article();
        draftArticle.setTitle("草稿文章");
        draftArticle.setContent("这是一篇草稿文章");
        draftArticle.setAuthor(testUser);
        draftArticle.setStatus(Article.ArticleStatus.DRAFT);
        draftArticle = articleRepository.save(draftArticle);

        // 创建已发布文章
        publishedArticle = new Article();
        publishedArticle.setTitle("已发布文章");
        publishedArticle.setContent("这是一篇已发布文章");
        publishedArticle.setAuthor(testUser);
        publishedArticle.setStatus(Article.ArticleStatus.PUBLISHED);
        publishedArticle = articleRepository.save(publishedArticle);
    }

    @Test
    void testAnonymousUserCannotAccessDraftArticle() {
        // 匿名用户不能访问草稿文章
        assertThrows(Exception.class, () -> {
            articleService.getArticleById(draftArticle.getId());
        });
    }

    @Test
    void testAnonymousUserCanAccessPublishedArticle() {
        // 匿名用户可以访问已发布文章
        assertDoesNotThrow(() -> {
            articleService.getArticleById(publishedArticle.getId());
        });
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void testAdminCanAccessDraftArticle() {
        // 管理员可以访问草稿文章
        assertDoesNotThrow(() -> {
            articleService.getArticleByIdForAdmin(draftArticle.getId());
        });
    }

    @Test
    @WithMockUser(roles = "USER")
    void testNonAdminCannotUseAdminMethod() {
        // 非管理员不能使用管理员方法
        assertThrows(AccessDeniedException.class, () -> {
            articleService.getArticleByIdForAdmin(draftArticle.getId());
        });
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void testAdminCanPublishArticle() {
        // 管理员可以发布文章
        assertDoesNotThrow(() -> {
            articleService.publishArticle(draftArticle.getId());
        });
    }

    @Test
    @WithMockUser(roles = "USER")
    void testNonAdminCannotPublishArticle() {
        // 非管理员不能发布文章
        assertThrows(AccessDeniedException.class, () -> {
            articleService.publishArticle(draftArticle.getId());
        });
    }
}
