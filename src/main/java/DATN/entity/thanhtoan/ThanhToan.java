package DATN.entity.thanhtoan;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "THANH_TOAN")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ThanhToan {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tt")
    private Integer id;
    
    @Column(name = "hoadon", nullable = false)
    private Integer hoaDon;
    
    @Column(name = "phuongthuc", nullable = false)
    private String phuongThuc; // "MOMO", "COD", "BANK_TRANSFER"
    
    @Column(name = "sotien", nullable = false)
    private BigDecimal soTien;
    
    @Column(name = "ngaythanhtoan")
    private LocalDateTime ngayThanhToan;
    
    @Column(name = "magiaodich")
    private String maGiaoDich;
    
    @Column(name = "taikhoan", nullable = false)
    private Integer taiKhoan;
    
    @CreationTimestamp
    @Column(name = "ngaytao", nullable = false, updatable = false)
    private LocalDateTime ngayTao;
    

}