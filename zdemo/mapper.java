package com.example.DATN.zdemo; // Đặt class trong package mapper (dùng để chuyển đổi dữ liệu giữa tầng DB và tầng Java entity)

import java.util.Map; // Import Map để nhận dữ liệu từ kết quả truy vấn (mỗi dòng là 1 Map)

import com.example.DATN.entity.DynamicProcedureEntity; // Import entity động đã định nghĩa sẵn để chứa dữ liệu procedure

public class mapper {

    // Phương thức chuyển đổi một hàng dữ liệu (Map) từ stored procedure thành một entity
    public static DynamicProcedureEntity toEntity(Map<String, Object> row) {
        DynamicProcedureEntity entity = new DynamicProcedureEntity(); // Tạo một object mới
        entity.setFields(row); // Gán toàn bộ cặp key-value (tên cột -> giá trị) vào entity
        return entity; // Trả về entity đã được map
    }
}
