package DATN.controller;

import DATN.service.ThanhToanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/momo")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequiredArgsConstructor
public class MoMoController {

    private final ThanhToanService thanhToanService;

    /**
     * Webhook - MoMo gọi về khi thanh toán hoàn tất
     * URL: POST /api/momo/notify
     */
    @PostMapping("/notify")
    public ResponseEntity<?> momoNotify(@RequestBody Map<String, Object> payload) {
        try {
            System.out.println("🔔 MoMo Webhook nhận được: " + payload);
            
            String orderId = (String) payload.get("orderId");
            Integer resultCode = (Integer) payload.get("resultCode");
            String message = (String) payload.get("message");
            
            // resultCode = 0: Thành công, khác 0: Thất bại
            String trangThai = (resultCode == 0) ? "SUCCESS" : "FAILED";
            
            Map<String, Object> result = thanhToanService.xacNhanThanhToan(orderId, trangThai);
            
            System.out.println("✅ Xử lý webhook MoMo: " + result);
            return ResponseEntity.ok(Map.of(
                "message", "Webhook processed successfully",
                "orderId", orderId,
                "status", trangThai
            ));
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi xử lý webhook MoMo: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of(
                "message", "Lỗi xử lý callback MoMo",
                "error", e.getMessage()
            ));
        }
    }

    /**
     * Return URL - User được redirect về sau khi thanh toán
     * URL: GET /api/momo/return?orderId=xxx&resultCode=0
     */
    @GetMapping("/return")
    public ResponseEntity<?> momoReturn(@RequestParam Map<String, String> params) {
        try {
            System.out.println("🔙 MoMo Return nhận được: " + params);
            
            String orderId = params.get("orderId");
            String resultCode = params.get("resultCode");
            String message = params.get("message");
            
            // resultCode = "0": Thành công, khác "0": Thất bại
            String trangThai = "0".equals(resultCode) ? "SUCCESS" : "FAILED";
            
            Map<String, Object> result = thanhToanService.xacNhanThanhToan(orderId, trangThai);
            
            if ("SUCCESS".equals(trangThai)) {
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Thanh toán MoMo thành công! 🎉",
                    "orderId", orderId,
                    "redirectUrl", "http://localhost:5173/thanh-toan/thanh-cong?orderId=" + orderId
                ));
            } else {
                return ResponseEntity.ok(Map.of(
                    "success", false,
                    "message", "Thanh toán MoMo thất bại: " + message,
                    "orderId", orderId,
                    "redirectUrl", "http://localhost:5173/thanh-toan/that-bai?orderId=" + orderId
                ));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi xử lý return MoMo: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Lỗi xử lý kết quả thanh toán MoMo",
                "error", e.getMessage()
            ));
        }
    }

    /**
     * Kiểm tra trạng thái giao dịch MoMo
     * URL: GET /api/momo/status/{orderId}
     */
    @GetMapping("/status/{orderId}")
    public ResponseEntity<?> kiemTraTrangThai(@PathVariable String orderId) {
        try {
            // Có thể gọi API MoMo để check status
            // Hoặc check trong database
            return ResponseEntity.ok(Map.of(
                "orderId", orderId,
                "message", "Tính năng đang phát triển"
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "message", "Lỗi kiểm tra trạng thái",
                "error", e.getMessage()
            ));
        }
    }
}