package DATN.controller;

import DATN.dao.sanpham.SanPhamDao;
import DATN.entity.sanpham.SanPham;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/gio-hang")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequiredArgsConstructor
public class GioHangController {

    private final SanPhamDao sanPhamDao;

    @PostMapping("/them")
    public ResponseEntity<?> themVaoGioHang(@RequestBody Map<String, Object> request, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        Integer sanPhamId = (Integer) request.get("sanPhamId");
        Integer soLuong = (Integer) request.get("soLuong");

        // Lấy giỏ hàng từ session
        Map<Integer, Integer> gioHang = (Map<Integer, Integer>) session.getAttribute("gioHang");
        if (gioHang == null) {
            gioHang = new HashMap<>();
        }

        // Thêm sản phẩm vào giỏ hàng
        gioHang.put(sanPhamId, gioHang.getOrDefault(sanPhamId, 0) + soLuong);
        session.setAttribute("gioHang", gioHang);

        return ResponseEntity.ok(Map.of(
            "message", "Thêm vào giỏ hàng thành công",
            "soLuongTrongGio", gioHang.size()
        ));
    }

    @GetMapping("/xem")
    public ResponseEntity<?> xemGioHang(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        Map<Integer, Integer> gioHang = (Map<Integer, Integer>) session.getAttribute("gioHang");
        if (gioHang == null || gioHang.isEmpty()) {
            return ResponseEntity.ok(Map.of(
                "danhSachSanPham", new ArrayList<>(),
                "tongTien", 0
            ));
        }

        List<Map<String, Object>> danhSachSanPham = new ArrayList<>();
        BigDecimal tongTien = BigDecimal.ZERO;

        for (Map.Entry<Integer, Integer> entry : gioHang.entrySet()) {
            Integer sanPhamId = entry.getKey();
            Integer soLuong = entry.getValue();

            SanPham sanPham = sanPhamDao.findById(sanPhamId).orElse(null);
            if (sanPham != null) {
                Map<String, Object> item = new HashMap<>();
                item.put("sanPhamId", sanPhamId);
                item.put("tenSanPham", sanPham.getTenSanPham());
                item.put("donGia", sanPham.getDonGia());
                item.put("soLuong", soLuong);
                item.put("anhGoc", sanPham.getAnhGoc());
                item.put("thanhTien", BigDecimal.valueOf(sanPham.getDonGia()).multiply(BigDecimal.valueOf(soLuong)));

                danhSachSanPham.add(item);
                tongTien = tongTien.add(BigDecimal.valueOf(sanPham.getDonGia()).multiply(BigDecimal.valueOf(soLuong)));
            }
        }

        return ResponseEntity.ok(Map.of(
            "danhSachSanPham", danhSachSanPham,
            "tongTien", tongTien
        ));
    }

    @DeleteMapping("/xoa/{sanPhamId}")
    public ResponseEntity<?> xoaKhoiGioHang(@PathVariable Integer sanPhamId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        Map<Integer, Integer> gioHang = (Map<Integer, Integer>) session.getAttribute("gioHang");
        if (gioHang != null) {
            gioHang.remove(sanPhamId);
            session.setAttribute("gioHang", gioHang);
        }

        return ResponseEntity.ok(Map.of("message", "Xóa sản phẩm khỏi giỏ hàng thành công"));
    }

    @PutMapping("/cap-nhat")
    public ResponseEntity<?> capNhatSoLuong(@RequestBody Map<String, Object> request, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        Integer sanPhamId = (Integer) request.get("sanPhamId");
        Integer soLuongMoi = (Integer) request.get("soLuong");

        Map<Integer, Integer> gioHang = (Map<Integer, Integer>) session.getAttribute("gioHang");
        if (gioHang != null && gioHang.containsKey(sanPhamId)) {
            if (soLuongMoi > 0) {
                gioHang.put(sanPhamId, soLuongMoi);
            } else {
                gioHang.remove(sanPhamId);
            }
            session.setAttribute("gioHang", gioHang);
        }

        return ResponseEntity.ok(Map.of("message", "Cập nhật số lượng thành công"));
    }

    @DeleteMapping("/xoa-tat-ca")
    public ResponseEntity<?> xoaTatCa(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        session.removeAttribute("gioHang");
        return ResponseEntity.ok(Map.of("message", "Xóa tất cả sản phẩm khỏi giỏ hàng thành công"));
    }
}