package DATN.controller;

import DATN.dao.thanhtoan.HoaDonDAO;
import DATN.dto.ThanhToanDTO;
import DATN.entity.thanhtoan.HoaDon;
import DATN.service.ThanhToanService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/thanhtoan")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequiredArgsConstructor
public class ThanhToanController {

    private final ThanhToanService thanhToanService;
    private final HoaDonDAO hoaDonDAO;

    @PostMapping("/tao-hoa-don")
    public ResponseEntity<?> taoHoaDon(@RequestBody ThanhToanDTO thanhToanDTO, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Kiểm tra session
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj == null) {
                response.put("success", false);
                response.put("message", "Chưa đăng nhập");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            // Validate input
            if (thanhToanDTO == null) {
                response.put("success", false);
                response.put("message", "Dữ liệu không hợp lệ");
                return ResponseEntity.badRequest().body(response);
            }

            if (thanhToanDTO.getDanhSachSanPham() == null || thanhToanDTO.getDanhSachSanPham().isEmpty()) {
                response.put("success", false);
                response.put("message", "Danh sách sản phẩm không được để trống");
                return ResponseEntity.badRequest().body(response);
            }

            // Set user ID from session
            thanhToanDTO.setTaiKhoanId((Integer) userIdObj);
            
            // Log for debugging
            System.out.println("Creating order for user: " + userIdObj);
            System.out.println("Order data: " + thanhToanDTO);

            // Call service
            Map<String, Object> result = thanhToanService.taoHoaDon(thanhToanDTO);

            if ((Boolean) result.get("success")) {
                // Xóa giỏ hàng sau khi tạo hóa đơn thành công
                session.removeAttribute("gioHang");
                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.badRequest().body(result);
            }

        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (RuntimeException e) {
            System.err.println("Runtime error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi không xác định");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/lich-su")
    public ResponseEntity<?> lichSuDonHang(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj == null) {
                response.put("success", false);
                response.put("message", "Chưa đăng nhập");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            List<HoaDon> danhSachHoaDon = hoaDonDAO.findByTaiKhoanOrderByNgayTaoDesc((Integer) userIdObj);
            response.put("success", true);
            response.put("data", danhSachHoaDon);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("Error getting order history: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi khi lấy lịch sử đơn hàng");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/chi-tiet/{hoaDonId}")
    public ResponseEntity<?> chiTietHoaDon(@PathVariable Integer hoaDonId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj == null) {
                response.put("success", false);
                response.put("message", "Chưa đăng nhập");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            return hoaDonDAO.findById(hoaDonId)
                    .map(hoaDon -> {
                        if (!hoaDon.getTaiKhoan().equals(userIdObj)) {
                            response.put("success", false);
                            response.put("message", "Không có quyền truy cập");
                            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
                        }
                        response.put("success", true);
                        response.put("data", hoaDon);
                        return ResponseEntity.ok(response);
                    })
                    .orElseGet(() -> {
                        response.put("success", false);
                        response.put("message", "Không tìm thấy hóa đơn");
                        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
                    });
        } catch (Exception e) {
            System.err.println("Error getting order details: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi khi lấy chi tiết hóa đơn");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/xac-nhan-thanh-toan")
    public ResponseEntity<?> xacNhanThanhToan(@RequestParam String maGiaoDich, @RequestParam String trangThai) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Map<String, Object> result = thanhToanService.xacNhanThanhToan(maGiaoDich, trangThai);
            
            if ((Boolean) result.get("success")) {
                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.badRequest().body(result);
            }
        } catch (Exception e) {
            System.err.println("Error confirming payment: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi khi xác nhận thanh toán");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    // MoMo callback endpoints
    @PostMapping("/momo/notify")
    public ResponseEntity<?> momoNotify(@RequestBody Map<String, Object> notifyData) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("📥 MoMo Notify: " + notifyData);
            
            String orderId = (String) notifyData.get("orderId");
            Integer resultCode = (Integer) notifyData.get("resultCode");
            
            if (orderId != null && resultCode != null) {
                String status = resultCode == 0 ? "SUCCESS" : "FAILED";
                thanhToanService.xacNhanThanhToan(orderId, status);
            }
            
            response.put("success", true);
            response.put("message", "Processed MoMo notification");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("❌ Error processing MoMo notification: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Error processing notification");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
