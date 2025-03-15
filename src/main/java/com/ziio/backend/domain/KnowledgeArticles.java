package com.ziio.backend.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;

/**
 * 
 * @TableName knowledge_articles
 */
@TableName(value ="knowledge_articles")
@Data
public class KnowledgeArticles implements Serializable {
    /**
     * 知识库文章的唯一标识，主键
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 文章的标题
     */
    private String title;

    /**
     * 文章的富文本内容
     */
    private String content;

    /**
     * 文章所属的分类
     */
    private String category;

    /**
     * 文章的标签数组，以 JSON 格式存储
     */
    private Object tags;

    /**
     * 文章的作者 ID，关联 users 表的 id
     */
    private Integer authorId;

    /**
     * 文章的浏览次数，默认为 0
     */
    private Integer viewCount;

    /**
     * 文章创建的时间
     */
    private Date createdAt;

    /**
     * 文章更新的时间，自动更新
     */
    private Date updatedAt;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}