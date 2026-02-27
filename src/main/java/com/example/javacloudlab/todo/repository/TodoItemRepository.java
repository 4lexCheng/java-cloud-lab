package com.example.javacloudlab.todo.repository;

import com.example.javacloudlab.todo.domain.TodoItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TodoItemRepository extends JpaRepository<TodoItem, Long> {
}
