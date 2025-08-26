package com.example.DATN.controller;

import java.io.IOException;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/api/payment/momo")
public class MoMoController {

    @GetMapping("/return")
    public void momoReturn(HttpServletResponse response) throws IOException {
        // demo → không cần validate gì cả
        response.sendRedirect("http://localhost:5173/"); // quay về trang chủ
    }

}

