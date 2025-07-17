package DATN.controller;

import DATN.dto.DanhGiaCreateDTO;
import DATN.dto.DanhGiaDTO;
import DATN.service.DanhGiaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/danhgia")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class DanhGiaController {

    private final DanhGiaService danhGiaService;

    // ✅ Lấy danh sách đánh giá theo sản phẩm
    @GetMapping("/{sanphamId}")
    public ResponseEntity<List<DanhGiaDTO>> getBySanPham(@PathVariable Integer sanphamId) {
        return ResponseEntity.ok(danhGiaService.layTheoSanPham(sanphamId));
    }

    // ✅ Tạo đánh giá mới
    @PostMapping("/create")
    public ResponseEntity<?> createDanhGia(@RequestBody DanhGiaCreateDTO dto) {
        if (dto.getNoidung() == null || dto.getNoidung().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Nội dung không được để trống");
        }

        danhGiaService.taoDanhGia(dto);
        return ResponseEntity.ok().body("Gửi đánh giá thành công");
    }

    // ✅ Xóa đánh giá theo ID
    @DeleteMapping("/{idDg}")
    public ResponseEntity<?> deleteDanhGia(@PathVariable Integer idDg) {
        try {
            danhGiaService.xoaDanhGia(idDg);
            return ResponseEntity.ok("Xóa đánh giá thành công");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
