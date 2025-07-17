package DATN.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DanhGiaCreateDTO {
    private Integer taikhoan;
    private Integer sanpham;
    private String noidung;
    private Integer diemso;
}
