package DATN.service;

import DATN.dao.thanhtoan.HoaDonDAO;
import DATN.dao.thanhtoan.HoaDonChiTietDAO;
import DATN.dao.thanhtoan.ThanhToanDAO;
import DATN.dto.MoMoPaymentResponseDTO;
import DATN.dto.ThanhToanDTO;
import DATN.entity.thanhtoan.HoaDon;
import DATN.entity.thanhtoan.HoaDonChiTiet;
import DATN.entity.thanhtoan.ThanhToan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThanhToanService {

    private final HoaDonDAO hoaDonDAO;
    private final HoaDonChiTietDAO hoaDonChiTietDAO;
    private final ThanhToanDAO thanhToanDAO;
    private final MoMoPaymentService moMoPaymentService;

    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> taoHoaDon(ThanhToanDTO thanhToanDTO) {
        Map<String, Object> response = new HashMap<>();

        // Validate input data
        if (thanhToanDTO == null || thanhToanDTO.getTaiKhoanId() == null) {
            response.put("success", false);
            response.put("message", "Thông tin tài khoản không hợp lệ");
            return response;
        }

        if (thanhToanDTO.getDanhSachSanPham() == null || thanhToanDTO.getDanhSachSanPham().isEmpty()) {
            response.put("success", false);
            response.put("message", "Danh sách sản phẩm không được để trống");
            return response;
        }

        if (thanhToanDTO.getTongTien() == null || thanhToanDTO.getTongTien().compareTo(BigDecimal.ZERO) <= 0) {
            response.put("success", false);
            response.put("message", "Tổng tiền không hợp lệ");
            return response;
        }

        try {
            // Tạo hóa đơn
            HoaDon hoaDon = createHoaDon(thanhToanDTO);
            HoaDon savedHoaDon = hoaDonDAO.save(hoaDon);

            // Tạo chi tiết hóa đơn
            createHoaDonChiTiet(savedHoaDon, thanhToanDTO.getDanhSachSanPham());

            // Xử lý thanh toán
            return processPayment(savedHoaDon, thanhToanDTO);

        } catch (Exception e) {
            // Log the error for debugging
            System.err.println("Error in taoHoaDon: " + e.getMessage());
            e.printStackTrace();
            
            // Rethrow as RuntimeException to trigger rollback
            throw new RuntimeException("Lỗi khi tạo hóa đơn: " + e.getMessage(), e);
        }
    }

    private HoaDon createHoaDon(ThanhToanDTO thanhToanDTO) {
        HoaDon hoaDon = new HoaDon();
        hoaDon.setTaiKhoan(thanhToanDTO.getTaiKhoanId());
        hoaDon.setGiaHoaDon(thanhToanDTO.getTongTien());
        hoaDon.setTrangThai("PENDING");
        hoaDon.setNoiDung(thanhToanDTO.getGhiChu());
        
        return hoaDon;
    }

    private void createHoaDonChiTiet(HoaDon hoaDon, java.util.List<ThanhToanDTO.SanPhamThanhToanDTO> danhSachSanPham) {
        for (ThanhToanDTO.SanPhamThanhToanDTO sanPham : danhSachSanPham) {
            if (sanPham.getSanPhamId() == null || sanPham.getSoLuong() == null || sanPham.getDonGia() == null) {
                throw new IllegalArgumentException("Thông tin sản phẩm không hợp lệ");
            }

            HoaDonChiTiet chiTiet = new HoaDonChiTiet();
            chiTiet.setHoaDon(hoaDon.getId());
            chiTiet.setSanPham(sanPham.getSanPhamId());
            chiTiet.setDonGia(sanPham.getDonGia());
            chiTiet.setSoLuong(sanPham.getSoLuong());
            hoaDonChiTietDAO.save(chiTiet);
        }
    }

    private Map<String, Object> processPayment(HoaDon hoaDon, ThanhToanDTO thanhToanDTO) {
        Map<String, Object> response = new HashMap<>();

        // Tạo thanh toán
        ThanhToan thanhToan = new ThanhToan();
        thanhToan.setHoaDon(hoaDon.getId());
        thanhToan.setPhuongThuc(thanhToanDTO.getPhuongThucThanhToan());
        thanhToan.setSoTien(thanhToanDTO.getTongTien());
        thanhToan.setTaiKhoan(thanhToanDTO.getTaiKhoanId());
       

        // Xử lý theo phương thức thanh toán
        if ("MOMO".equals(thanhToanDTO.getPhuongThucThanhToan())) {
            return processMoMoPayment(thanhToan, hoaDon, thanhToanDTO.getTongTien());
        } else if ("COD".equals(thanhToanDTO.getPhuongThucThanhToan())) {
            return processCODPayment(thanhToan, hoaDon);
        } else {
            response.put("success", false);
            response.put("message", "Phương thức thanh toán không được hỗ trợ");
            return response;
        }
    }

    private Map<String, Object> processMoMoPayment(ThanhToan thanhToan, HoaDon hoaDon, BigDecimal tongTien) {
        Map<String, Object> response = new HashMap<>();

        try {
            String orderId = "ORDER_" + hoaDon.getId() + "_" + System.currentTimeMillis();
            String orderInfo = "Thanh toán đơn hàng #" + hoaDon.getId();
            Long amount = tongTien.longValue();

            System.out.println("🔄 Đang tạo thanh toán MoMo...");
            System.out.println("OrderId: " + orderId);
            System.out.println("Amount: " + amount);

            MoMoPaymentResponseDTO momoResponse = moMoPaymentService.createPayment(orderId, amount, orderInfo);

            if (momoResponse != null && momoResponse.getResultCode() == 0) {
                thanhToan.setMaGiaoDich(orderId);
                thanhToanDAO.save(thanhToan);

                response.put("success", true);
                response.put("message", "Tạo thanh toán MoMo thành công");
                response.put("hoaDonId", hoaDon.getId());
                response.put("payUrl", momoResponse.getPayUrl());
                response.put("qrCodeUrl", momoResponse.getQrCodeUrl());
                response.put("orderId", orderId);
            } else {
                // Log lỗi MoMo để debug
                String errorMessage = momoResponse != null ? 
                    "ResultCode: " + momoResponse.getResultCode() + ", Message: " + momoResponse.getMessage() : 
                    "Không thể kết nối đến MoMo";
                
                System.err.println("❌ Lỗi MoMo: " + errorMessage);
                
                // Fallback to COD instead of throwing exception
                System.out.println("🔄 Chuyển sang thanh toán COD do lỗi MoMo...");
                
                // Update payment method to COD
                thanhToan.setPhuongThuc("COD");
                thanhToan.setMaGiaoDich("COD_" + UUID.randomUUID().toString());
                thanhToanDAO.save(thanhToan);

                response.put("success", true);
                response.put("message", "Thanh toán MoMo tạm thời không khả dụng. Đơn hàng đã được chuyển sang thanh toán khi nhận hàng (COD).");
                response.put("hoaDonId", hoaDon.getId());
                response.put("paymentMethod", "COD");
                response.put("momoError", errorMessage);
            }
        } catch (Exception e) {
            System.err.println("❌ Exception trong MoMo payment: " + e.getMessage());
            e.printStackTrace();
            
            // Fallback to COD
            try {
                thanhToan.setPhuongThuc("COD");
                thanhToan.setMaGiaoDich("COD_" + UUID.randomUUID().toString());
                thanhToanDAO.save(thanhToan);

                response.put("success", true);
                response.put("message", "Thanh toán MoMo gặp sự cố. Đơn hàng đã được chuyển sang thanh toán khi nhận hàng (COD).");
                response.put("hoaDonId", hoaDon.getId());
                response.put("paymentMethod", "COD");
                response.put("error", e.getMessage());
            } catch (Exception fallbackError) {
                throw new RuntimeException("Lỗi xử lý thanh toán: " + e.getMessage(), e);
            }
        }

        return response;
    }

    private Map<String, Object> processCODPayment(ThanhToan thanhToan, HoaDon hoaDon) {
        Map<String, Object> response = new HashMap<>();

        try {
            thanhToan.setMaGiaoDich("COD_" + UUID.randomUUID().toString());
            thanhToanDAO.save(thanhToan);

            response.put("success", true);
            response.put("message", "Đặt hàng thành công. Thanh toán khi nhận hàng");
            response.put("hoaDonId", hoaDon.getId());
        } catch (Exception e) {
            throw new RuntimeException("Lỗi xử lý thanh toán COD: " + e.getMessage(), e);
        }

        return response;
    }

    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> xacNhanThanhToan(String maGiaoDich, String trangThai) {
        Map<String, Object> response = new HashMap<>();

        if (maGiaoDich == null || maGiaoDich.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Mã giao dịch không hợp lệ");
            return response;
        }

        if (trangThai == null || trangThai.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Trạng thái không hợp lệ");
            return response;
        }

        try {
            Optional<ThanhToan> thanhToanOpt = thanhToanDAO.findByMaGiaoDich(maGiaoDich);

            if (thanhToanOpt.isPresent()) {
                ThanhToan thanhToan = thanhToanOpt.get();
                
                thanhToan.setNgayThanhToan(LocalDateTime.now());
                thanhToanDAO.save(thanhToan);

                // Cập nhật trạng thái hóa đơn
                updateHoaDonStatus(thanhToan.getHoaDon(), trangThai);

                response.put("success", true);
                response.put("message", "Cập nhật trạng thái thanh toán thành công");
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy giao dịch");
            }

        } catch (Exception e) {
            System.err.println("Error in xacNhanThanhToan: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xác nhận thanh toán: " + e.getMessage(), e);
        }

        return response;
    }

    private void updateHoaDonStatus(Integer hoaDonId, String trangThaiThanhToan) {
        Optional<HoaDon> hoaDonOpt = hoaDonDAO.findById(hoaDonId);
        if (hoaDonOpt.isPresent()) {
            HoaDon hoaDon = hoaDonOpt.get();
            if ("SUCCESS".equals(trangThaiThanhToan)) {
                hoaDon.setTrangThai("PAID");
            } else {
                hoaDon.setTrangThai("CANCELLED");
            }
            hoaDonDAO.save(hoaDon);
        }
    }
}
