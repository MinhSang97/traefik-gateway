package com.example.orderservice.controller;

import com.example.orderservice.model.Order;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    @GetMapping("/")
    public ResponseEntity<List<Order>> getAllOrders() {
        List<Order> orders = Arrays.asList(
            new Order(1L, "ORD-001", 150.00, "PENDING"),
            new Order(2L, "ORD-002", 299.99, "COMPLETED"),
            new Order(3L, "ORD-003", 75.50, "SHIPPED")
        );
        return ResponseEntity.ok(orders);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrder(@PathVariable Long id) {
        Order order = new Order(id, "ORD-" + String.format("%03d", id), 99.99, "PENDING");
        return ResponseEntity.ok(order);
    }

    @PostMapping("/")
    public ResponseEntity<Order> createOrder(@RequestBody Order order) {
        order.setId(System.currentTimeMillis());
        order.setOrderNumber("ORD-" + order.getId());
        return ResponseEntity.ok(order);
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Order Service is healthy");
    }
}
