package DATN.dto;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TaiKhoanResponseDTO {
    private String tenDangNhap;
    private String hoVaTen;
    private String email;
    private String soDienThoai;
    private Boolean vaiTro;
    private String matKhau;
}