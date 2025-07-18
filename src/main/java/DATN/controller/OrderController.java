package DATN.controller;

import org.springframework.web.bind.annotation.*;

import DATN.Data.OrderRequestt;


@RestController
@RequestMapping("/api/order")
public class OrderController {

    @PostMapping("/save")
    public String saveOrder(@RequestBody OrderRequestt orderRequest) {
        // Lưu orderRequest vào database (sử dụng JPA hoặc cách lưu trữ khác)
        System.out.println("Đơn hàng đã được lưu: " + orderRequest);
        return "Đơn hàng đã được lưu thành công!";
    }
}



