package DATN.dto;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ThanhToanDTO {
    private Integer taiKhoanId;
    private String phuongThucThanhToan; // "MOMO", "COD", "BANK_TRANSFER"
    private BigDecimal tongTien;
    private String diaChiGiaoHang;
    private String ghiChu;
    private List<SanPhamThanhToanDTO> danhSachSanPham;
    
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class SanPhamThanhToanDTO {
        private Integer sanPhamId;
        private Integer soLuong;
        private BigDecimal donGia;
    }
}
