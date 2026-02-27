package com.example.javacloudlab.todo.web;

import com.example.javacloudlab.todo.domain.TodoItem;
import com.example.javacloudlab.todo.service.TodoItemService;
import com.example.javacloudlab.todo.web.dto.CreateTodoItemRequest;
import com.example.javacloudlab.todo.web.dto.TodoItemResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoItemController {

    private final TodoItemService todoItemService;

    public TodoItemController(TodoItemService todoItemService) {
        this.todoItemService = todoItemService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TodoItemResponse create(@RequestBody CreateTodoItemRequest request) {
        try {
            TodoItem created = todoItemService.create(request.title());
            return TodoItemResponse.from(created);
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @GetMapping
    public List<TodoItemResponse> listAll() {
        return todoItemService.listAll().stream()
                .map(TodoItemResponse::from)
                .toList();
    }

    @GetMapping("/{id}")
    public TodoItemResponse findById(@PathVariable Long id) {
        return todoItemService.findById(id)
                .map(TodoItemResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "todo item not found: " + id));
    }
}
