package com.xuyi.blog.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 文件上传响应DTO
 * 
 * @author xuyi
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "文件上传响应")
public class FileUploadResponse {

    @Schema(description = "文件访问URL", example = "https://ultimate-img.oss-cn-beijing.aliyuncs.com/covers/20241220/abc123.jpg")
    private String url;

    @Schema(description = "原始文件名", example = "cover.jpg")
    private String filename;

    @Schema(description = "文件大小（字节）", example = "1024000")
    private Long size;

    @Schema(description = "文件类型", example = "image/jpeg")
    private String contentType;

    public static FileUploadResponse of(String url, String filename, Long size, String contentType) {
        return new FileUploadResponse(url, filename, size, contentType);
    }

    public static FileUploadResponse of(String url, String filename) {
        return new FileUploadResponse(url, filename, null, null);
    }
}
