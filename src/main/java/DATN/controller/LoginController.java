package DATN.controller;

import DATN.dto.LoginRequestDTO;
import DATN.dto.RegisterRequestDTO;
import DATN.entity.TaiKhoan.TaiKhoan;
import DATN.service.TaiKhoanService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true") // Cho phép gửi cookie
@RestController
@RequestMapping("/api/xacthuc")
@RequiredArgsConstructor
public class LoginController {

    private final TaiKhoanService taiKhoanService;

    @PostMapping("/dangnhap")
    public ResponseEntity<?> dangNhap(@RequestBody LoginRequestDTO loginDTO, HttpSession session) {
        String tenDangNhap = loginDTO.getTenDangNhap();
        String matKhau = loginDTO.getMatKhau();

        Map<String, Object> result = taiKhoanService.login(tenDangNhap, matKhau);
        String message = (String) result.get("message");

        if ("Đăng nhập thành công".equals(message)) {
            // ✅ Lưu session
            session.setAttribute("username", result.get("tenDangNhap"));
            session.setAttribute("vaiTro", result.get("vaiTro"));
            session.setAttribute("userId", result.get("idtk")); // Lưu ID tài khoản

            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(401).body(result);
        }
    }

    @PostMapping("/dangxuat")
    public ResponseEntity<?> dangXuat(HttpSession session) {
        session.invalidate(); // Xoá toàn bộ session
        return ResponseEntity.ok(Map.of("message", "Đăng xuất thành công"));
    }

    @PostMapping("/dangky")
    public ResponseEntity<?> register(@RequestBody RegisterRequestDTO dto) {
        TaiKhoan taiKhoan = new TaiKhoan();
        taiKhoan.setTenDangNhap(dto.getTenDangNhap());
        taiKhoan.setMatKhau(dto.getMatKhau());
        taiKhoan.setHoVaTen(dto.getHoVaTen());
        taiKhoan.setSoDienThoai(dto.getSoDienThoai());
        taiKhoan.setEmail(dto.getEmail());

        Map<String, Object> response = taiKhoanService.register(taiKhoan);
        String message = (String) response.get("message");

        if ("Đăng ký thành công".equals(message)) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/kiem-tra-phien")
    public ResponseEntity<?> kiemTraPhien(HttpSession session) {
        Object username = session.getAttribute("username");
        Object vaiTro = session.getAttribute("vaiTro");
        Object userId = session.getAttribute("userId"); // ✅ đổi tên

        if (username != null) {
            return ResponseEntity.ok(Map.of(
                    "message", "Đã đăng nhập",
                    "username", username,
                    "vaiTro", vaiTro,
                    "userId", userId // ✅ đúng key
            ));
        } else {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }
        
    }
}
