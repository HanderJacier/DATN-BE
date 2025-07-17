package DATN.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DanhGiaDTO {
    private Integer id_dg;
    private String tenNguoiDung;
    private String noidung;
    private Integer diemso;
}
