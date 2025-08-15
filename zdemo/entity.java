package com.example.DATN.zdemo; // Đặt class này trong package "entity" thuộc dự án DATN

import java.util.HashMap;
import java.util.Map; // Import Map và HashMap để lưu trữ các cặp key-value động

import com.example.DATN.util.nulldata; // Import custom serializer để xử lý giá trị null nếu có
import com.fasterxml.jackson.annotation.JsonInclude; // Dùng để cấu hình JSON khi serialize
import com.fasterxml.jackson.databind.annotation.JsonSerialize; // Dùng để chỉ định custom serializer cho trường cụ thể

import lombok.Data; // Lombok annotation giúp tự động sinh getter, setter, toString, equals, hashCode

@Data // Tự động sinh toàn bộ getter, setter, toString, equals, hashCode
@JsonInclude(JsonInclude.Include.NON_NULL) // Bỏ qua các trường có giá trị null khi serialize sang JSON
public class entity {

    @JsonSerialize(using = nulldata.class) // Sử dụng custom serializer 'nulldata' cho trường fields
    private Map<String, Object> fields = new HashMap<>(); // Tạo Map để chứa dữ liệu động từ stored procedure (tên cột -> giá trị)

    // Phương thức để lấy giá trị theo key (tên cột trong kết quả stored procedure)
    public Object get(String key) {
        return fields.get(key); // Trả về giá trị tương ứng với key được truyền vào
    }

    // Phương thức để gán giá trị cho một key nhất định
    public void set(String key, Object value) {
        fields.put(key, value); // Thêm hoặc cập nhật một cặp key-value vào Map
    }

    // Getter chính thức cho trường 'fields' (Lombok đã sinh sẵn, nhưng bạn override lại thủ công nếu cần tùy chỉnh)
    public Map<String, Object> getFields() {
        return fields; // Trả về toàn bộ Map chứa dữ liệu
    }

    // Setter chính thức cho 'fields' (cho phép gán lại toàn bộ Map nếu cần)
    public void setFields(Map<String, Object> fields) {
        this.fields = fields; // Gán lại Map mới vào biến fields
    }
}
