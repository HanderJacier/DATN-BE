package DATN.entity.thanhtoan;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "HOA_DON")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class HoaDon {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_hd")
    private Integer id;
    
    @Column(name = "taikhoan", nullable = false)
    private Integer taiKhoan;
    
    @CreationTimestamp
    @Column(name = "ngaytao", nullable = false, updatable = false)
    private LocalDateTime ngayTao;
    
    @Column(name = "giahoadon", nullable = false)
    private BigDecimal giaHoaDon;
    
    @Column(name = "trangthai", nullable = false)
    private String trangThai; // "PENDING", "PAID", "CANCELLED", "PROCESSING", "SHIPPED", "DELIVERED"
    
    @Column(name = "noidung")
    private String noiDung;
   
}