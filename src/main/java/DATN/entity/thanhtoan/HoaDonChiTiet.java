package DATN.entity.thanhtoan;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "HD_CHI_TIET")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class HoaDonChiTiet {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_hdct")
    private Integer id;
    
    @Column(name = "hoadon", nullable = false)
    private Integer hoaDon;
    
    @Column(name = "sanpham", nullable = false)
    private Integer sanPham;
    
    @Column(name = "dongia", nullable = false)
    private BigDecimal donGia;
    
    @Column(name = "soluong", nullable = false)
    private Integer soLuong;
}