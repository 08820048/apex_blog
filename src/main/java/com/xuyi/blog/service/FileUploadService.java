package com.xuyi.blog.service;

import com.aliyun.oss.OSS;
import com.aliyun.oss.model.ObjectMetadata;
import com.aliyun.oss.model.PutObjectRequest;
import com.xuyi.blog.config.OssProperties;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * 文件上传服务
 * 
 * @author xuyi
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class FileUploadService {

    private final OSS ossClient;
    private final OssProperties ossProperties;

    /**
     * 支持的图片格式
     */
    private static final List<String> ALLOWED_IMAGE_TYPES = Arrays.asList(
            "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    );

    /**
     * 最大文件大小 (5MB)
     */
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    /**
     * 上传图片文件
     *
     * @param file 上传的文件
     * @param folder 存储文件夹 (如: covers, avatars, content)
     * @return 文件访问URL
     */
    public String uploadImage(MultipartFile file, String folder) {
        // 验证文件
        validateImageFile(file);

        // 生成文件名
        String fileName = generateFileName(file.getOriginalFilename(), folder);

        try {
            // 设置文件元数据
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            metadata.setContentType(file.getContentType());
            metadata.setCacheControl("max-age=31536000"); // 缓存一年

            // 创建上传请求
            PutObjectRequest putObjectRequest = new PutObjectRequest(
                    ossProperties.getBucketName(),
                    fileName,
                    file.getInputStream(),
                    metadata
            );

            // 上传文件
            ossClient.putObject(putObjectRequest);

            // 返回文件URL
            String fileUrl = ossProperties.getBaseUrl() + fileName;
            log.info("文件上传成功: {}", fileUrl);
            
            return fileUrl;

        } catch (IOException e) {
            log.error("文件上传失败: {}", e.getMessage(), e);
            throw new RuntimeException("文件上传失败: " + e.getMessage(), e);
        }
    }

    /**
     * 删除文件
     *
     * @param fileUrl 文件URL
     */
    public void deleteFile(String fileUrl) {
        if (fileUrl == null || !fileUrl.startsWith(ossProperties.getBaseUrl())) {
            return;
        }

        try {
            // 提取文件key
            String fileKey = fileUrl.replace(ossProperties.getBaseUrl(), "");
            
            // 删除文件
            ossClient.deleteObject(ossProperties.getBucketName(), fileKey);
            log.info("文件删除成功: {}", fileUrl);
            
        } catch (Exception e) {
            log.error("文件删除失败: {}", e.getMessage(), e);
            // 删除失败不抛异常，避免影响主业务
        }
    }

    /**
     * 验证图片文件
     */
    private void validateImageFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }

        // 检查文件大小
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("文件大小不能超过5MB");
        }

        // 检查文件类型
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_IMAGE_TYPES.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException("只支持JPG、PNG、GIF、WebP格式的图片");
        }

        // 检查文件扩展名
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !hasValidImageExtension(originalFilename)) {
            throw new IllegalArgumentException("文件扩展名不正确");
        }
    }

    /**
     * 检查文件扩展名
     */
    private boolean hasValidImageExtension(String filename) {
        String extension = getFileExtension(filename).toLowerCase();
        return Arrays.asList("jpg", "jpeg", "png", "gif", "webp").contains(extension);
    }

    /**
     * 生成文件名
     */
    private String generateFileName(String originalFilename, String folder) {
        // 获取文件扩展名
        String extension = getFileExtension(originalFilename);
        
        // 生成唯一文件名
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        return String.format("%s/%s/%s.%s", folder, dateStr, uuid, extension);
    }

    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }
}
