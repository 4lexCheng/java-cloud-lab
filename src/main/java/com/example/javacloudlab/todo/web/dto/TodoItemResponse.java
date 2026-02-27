package com.example.javacloudlab.todo.web.dto;

import com.example.javacloudlab.todo.domain.TodoItem;

import java.time.LocalDateTime;

public record TodoItemResponse(
        Long id,
        String title,
        boolean completed,
        LocalDateTime createdAt
) {
    public static TodoItemResponse from(TodoItem todoItem) {
        return new TodoItemResponse(
                todoItem.getId(),
                todoItem.getTitle(),
                todoItem.isCompleted(),
                todoItem.getCreatedAt()
        );
    }
}
