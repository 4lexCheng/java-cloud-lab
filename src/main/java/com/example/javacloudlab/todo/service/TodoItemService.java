package com.example.javacloudlab.todo.service;

import com.example.javacloudlab.todo.domain.TodoItem;
import com.example.javacloudlab.todo.repository.TodoItemRepository;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class TodoItemService {

    private final TodoItemRepository todoItemRepository;

    public TodoItemService(TodoItemRepository todoItemRepository) {
        this.todoItemRepository = todoItemRepository;
    }

    @Transactional
    public TodoItem create(String title) {
        String normalizedTitle = title == null ? "" : title.trim();
        if (normalizedTitle.isEmpty()) {
            throw new IllegalArgumentException("title must not be blank");
        }

        TodoItem todoItem = new TodoItem();
        todoItem.setTitle(normalizedTitle);
        todoItem.setCompleted(false);
        return todoItemRepository.save(todoItem);
    }

    @Transactional(readOnly = true)
    public List<TodoItem> listAll() {
        return todoItemRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
    }

    @Transactional(readOnly = true)
    public Optional<TodoItem> findById(Long id) {
        return todoItemRepository.findById(id);
    }
}
