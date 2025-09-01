package com.xuyi.blog.controller.admin;

import com.xuyi.blog.dto.ApiResponse;
import com.xuyi.blog.dto.FileUploadResponse;
import com.xuyi.blog.service.FileUploadService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * 管理后台 - 文件上传控制器
 * 
 * @author xuyi
 */
@RestController
@RequestMapping("/admin/upload")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "管理后台 - 文件上传", description = "文件上传管理相关接口")
@SecurityRequirement(name = "Bearer Authentication")
@PreAuthorize("hasRole('ADMIN')")
public class FileUploadController {

    private final FileUploadService fileUploadService;

    @PostMapping("/cover")
    @Operation(summary = "上传文章封面", description = "上传文章封面图片到阿里云OSS")
    public ApiResponse<FileUploadResponse> uploadCover(
            @Parameter(description = "图片文件", required = true)
            @RequestParam("file") MultipartFile file) {
        
        log.info("开始上传文章封面，文件名: {}, 大小: {} bytes", 
                file.getOriginalFilename(), file.getSize());
        
        try {
            String fileUrl = fileUploadService.uploadImage(file, "covers");
            FileUploadResponse response = FileUploadResponse.of(
                    fileUrl, 
                    file.getOriginalFilename(), 
                    file.getSize(), 
                    file.getContentType()
            );
            
            log.info("文章封面上传成功: {}", fileUrl);
            return ApiResponse.success("文章封面上传成功", response);
            
        } catch (Exception e) {
            log.error("文章封面上传失败: {}", e.getMessage(), e);
            return ApiResponse.error("文章封面上传失败: " + e.getMessage());
        }
    }

    @PostMapping("/avatar")
    @Operation(summary = "上传用户头像", description = "上传用户头像图片到阿里云OSS")
    public ApiResponse<FileUploadResponse> uploadAvatar(
            @Parameter(description = "图片文件", required = true)
            @RequestParam("file") MultipartFile file) {
        
        log.info("开始上传用户头像，文件名: {}, 大小: {} bytes", 
                file.getOriginalFilename(), file.getSize());
        
        try {
            String fileUrl = fileUploadService.uploadImage(file, "avatars");
            FileUploadResponse response = FileUploadResponse.of(
                    fileUrl, 
                    file.getOriginalFilename(), 
                    file.getSize(), 
                    file.getContentType()
            );
            
            log.info("用户头像上传成功: {}", fileUrl);
            return ApiResponse.success("用户头像上传成功", response);
            
        } catch (Exception e) {
            log.error("用户头像上传失败: {}", e.getMessage(), e);
            return ApiResponse.error("用户头像上传失败: " + e.getMessage());
        }
    }

    @PostMapping("/image")
    @Operation(summary = "通用图片上传", description = "上传通用图片到阿里云OSS")
    public ApiResponse<FileUploadResponse> uploadImage(
            @Parameter(description = "图片文件", required = true)
            @RequestParam("file") MultipartFile file,
            @Parameter(description = "存储文件夹", example = "images")
            @RequestParam(value = "folder", defaultValue = "images") String folder) {
        
        log.info("开始上传图片到文件夹: {}, 文件名: {}, 大小: {} bytes", 
                folder, file.getOriginalFilename(), file.getSize());
        
        try {
            String fileUrl = fileUploadService.uploadImage(file, folder);
            FileUploadResponse response = FileUploadResponse.of(
                    fileUrl, 
                    file.getOriginalFilename(), 
                    file.getSize(), 
                    file.getContentType()
            );
            
            log.info("图片上传成功: {}", fileUrl);
            return ApiResponse.success("图片上传成功", response);
            
        } catch (Exception e) {
            log.error("图片上传失败: {}", e.getMessage(), e);
            return ApiResponse.error("图片上传失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/file")
    @Operation(summary = "删除文件", description = "从阿里云OSS删除指定文件")
    public ApiResponse<Void> deleteFile(
            @Parameter(description = "要删除的文件URL", required = true)
            @RequestParam("url") String fileUrl) {
        
        log.info("开始删除文件: {}", fileUrl);
        
        try {
            fileUploadService.deleteFile(fileUrl);
            log.info("文件删除成功: {}", fileUrl);
            return ApiResponse.success("文件删除成功");
            
        } catch (Exception e) {
            log.error("文件删除失败: {}", e.getMessage(), e);
            return ApiResponse.error("文件删除失败: " + e.getMessage());
        }
    }
}
