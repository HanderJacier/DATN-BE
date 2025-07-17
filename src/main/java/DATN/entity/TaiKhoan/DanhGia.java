package DATN.entity.TaiKhoan;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "DANH_GIA")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DanhGia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_dg;

    @Column(nullable = false)
    private Integer taikhoan;

    @Column(nullable = false)
    private Integer sanpham;

    @Column(length = 255)
    private String noidung;

    @Column(nullable = false)
    private Integer diemso;
}
