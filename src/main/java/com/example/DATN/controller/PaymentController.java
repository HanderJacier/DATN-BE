package com.example.DATN.controller;

import com.example.DATN.entity.OrderRequest;
import com.example.DATN.service.PaymentService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.*;

@RestController
@RequestMapping("/api/datn/payment")
public class PaymentController {

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> createPayment(@RequestBody OrderRequest order) {
        try {
            Map<String, Object> response = paymentService.createPayment(order);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body(Map.of("error", e.getMessage()));
        }
    }
    @PostMapping("/momo/ipn")
    public ResponseEntity<String> momoIpn(@RequestBody Map<String, Object> callbackData) {
        try {
            boolean updated = paymentService.handleMomoIpn(callbackData);
            if (updated) {
                return ResponseEntity.ok("IPN nhận thành công");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                     .body("IPN thất bại hoặc dữ liệu không hợp lệ");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Lỗi xử lý IPN: " + e.getMessage());
        }
    }
    @GetMapping("/momo/return")
    public ResponseEntity<String> momoReturn(
            @RequestParam Map<String, String> params) {

        String orderId = params.get("orderId");     // transactionId đã gửi
        String resultCode = params.get("resultCode"); // 0 = thành công

        String message;
        if ("0".equals(resultCode)) {
            message = "Thanh toán thành công cho đơn hàng: " + orderId;
        } else {
            message = "Thanh toán thất bại cho đơn hàng: " + orderId;
        }

        // 🚩 Trả text đơn giản, Vue sẽ đọc và render lại giao diện
        return ResponseEntity.ok(message);
    }

}
