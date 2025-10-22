package com.example.orderservice.model;

public class Order {
    private Long id;
    private String orderNumber;
    private Double total;
    private String status;

    public Order() {}

    public Order(Long id, String orderNumber, Double total, String status) {
        this.id = id;
        this.orderNumber = orderNumber;
        this.total = total;
        this.status = status;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public Double getTotal() { return total; }
    public void setTotal(Double total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
