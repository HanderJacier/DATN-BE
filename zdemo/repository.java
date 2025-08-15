package com.example.DATN.zdemo; // Đặt class này trong package repository (thường dùng để tương tác DB)

import java.util.Map; // Import Map để lưu các tham số truyền vào stored procedure

public class repository {

    // Trường params sẽ chứa danh sách các tham số đầu vào cho stored procedure
    private Map<String, Object> params;

    // Getter để lấy toàn bộ Map các tham số đầu vào
    public Map<String, Object> getParams() {
        return params;
    }

    // Setter để gán Map các tham số đầu vào (từ request gửi đến API)
    public void setParams(Map<String, Object> params) {
        this.params = params;
    }
}
