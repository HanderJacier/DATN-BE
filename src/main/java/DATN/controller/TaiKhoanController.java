package DATN.controller;

import DATN.dao.TaiKhoanDao;
import DATN.dto.DoiMatKhauDTO;
import DATN.dto.TaiKhoanResponseDTO;
import DATN.dto.TaiKhoanUpdateDTO;
import DATN.entity.TaiKhoan.TaiKhoan;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/taikhoan")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@RequiredArgsConstructor
public class TaiKhoanController {

    private final TaiKhoanDao taiKhoanDao;

    // ✅ Lấy người dùng theo ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable("id") Integer id_tk) {
        Optional<TaiKhoan> tkOpt = taiKhoanDao.findById(id_tk);

        if (tkOpt.isEmpty()) {
            return ResponseEntity.status(404).body(Map.of("message", "Không tìm thấy người dùng"));
        }

        TaiKhoan tk = tkOpt.get();
        TaiKhoanResponseDTO dto = new TaiKhoanResponseDTO();
        dto.setTenDangNhap(tk.getTenDangNhap());
        dto.setHoVaTen(tk.getHoVaTen());
        dto.setEmail(tk.getEmail());
        dto.setSoDienThoai(tk.getSoDienThoai());
        dto.setVaiTro(tk.getVaiTro());
        dto.setMatKhau(tk.getMatKhau());

        return ResponseEntity.ok(dto);
    }

    // ✅ Lấy tất cả người dùng
    @GetMapping("/all")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok(taiKhoanDao.findAll());
    }

    // ✅ Thêm mới người dùng
    @PostMapping("/create")
    public ResponseEntity<?> createUser(@RequestBody TaiKhoan tk) {
        if (taiKhoanDao.findByTenDangNhap(tk.getTenDangNhap()).isPresent()) {
            return ResponseEntity.badRequest().body("Tên đăng nhập đã tồn tại");
        }
        if (taiKhoanDao.findByEmail(tk.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().body("Email đã tồn tại");
        }
        if (taiKhoanDao.findBySoDienThoai(tk.getSoDienThoai()).isPresent()) {
            return ResponseEntity.badRequest().body("SĐT đã tồn tại");
        }

        taiKhoanDao.save(tk);
        return ResponseEntity.ok("Tạo người dùng thành công");
    }

    // ✅ Cập nhật người dùng theo ID
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateUser(@PathVariable("id") Integer id_tk, @RequestBody TaiKhoan update) {
        Optional<TaiKhoan> opt = taiKhoanDao.findById(id_tk);
        if (opt.isEmpty()) {
            return ResponseEntity.status(404).body("Không tìm thấy người dùng");
        }

        TaiKhoan tk = opt.get();
        tk.setHoVaTen(update.getHoVaTen());
        tk.setEmail(update.getEmail());
        tk.setSoDienThoai(update.getSoDienThoai());
        tk.setVaiTro(update.getVaiTro());
        tk.setTrangThai(update.getTrangThai());
        tk.setMatKhau(update.getMatKhau());

        taiKhoanDao.save(tk);
        return ResponseEntity.ok("Cập nhật thành công");
    }

    // ✅ Xóa người dùng
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable("id") Integer id_tk) {
        if (!taiKhoanDao.existsById(id_tk)) {
            return ResponseEntity.status(404).body("Không tìm thấy người dùng");
        }

        taiKhoanDao.deleteById(id_tk);
        return ResponseEntity.ok("Xóa thành công");
    }

    // ✅ Lấy thông tin tài khoản theo session
    @GetMapping("/thongtin")
    public ResponseEntity<?> layThongTinTaiKhoan(HttpSession session) {
        Object username = session.getAttribute("username");

        if (username == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        Optional<TaiKhoan> tkOpt = taiKhoanDao.findByTenDangNhap(username.toString());
        if (tkOpt.isEmpty()) {
            return ResponseEntity.status(404).body(Map.of("message", "Không tìm thấy tài khoản"));
        }

        TaiKhoan tk = tkOpt.get();

        TaiKhoanResponseDTO dto = new TaiKhoanResponseDTO();
        dto.setTenDangNhap(tk.getTenDangNhap());
        dto.setHoVaTen(tk.getHoVaTen());
        dto.setEmail(tk.getEmail());
        dto.setSoDienThoai(tk.getSoDienThoai());
        dto.setVaiTro(tk.getVaiTro());

        return ResponseEntity.ok(dto);
    }

    // ✅ Cập nhật thông tin của chính người dùng (qua session)
    @PutMapping("/capnhat")
    public ResponseEntity<?> capNhatThongTin(@RequestBody TaiKhoanUpdateDTO dto, HttpSession session) {
        Object usernameObj = session.getAttribute("username");
        if (usernameObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        String username = usernameObj.toString();
        Optional<TaiKhoan> taiKhoanOpt = taiKhoanDao.findByTenDangNhap(username);

        if (taiKhoanOpt.isEmpty()) {
            return ResponseEntity.status(404).body(Map.of("message", "Không tìm thấy tài khoản"));
        }

        TaiKhoan tk = taiKhoanOpt.get();

        // Kiểm tra email trùng
        if (!tk.getEmail().equals(dto.getEmail()) &&
                taiKhoanDao.findByEmail(dto.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Email đã tồn tại"));
        }

        // Kiểm tra SĐT trùng
        if (!tk.getSoDienThoai().equals(dto.getSoDienThoai()) &&
                taiKhoanDao.findBySoDienThoai(dto.getSoDienThoai()).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Số điện thoại đã tồn tại"));
        }

        tk.setHoVaTen(dto.getHoVaTen());
        tk.setEmail(dto.getEmail());
        tk.setSoDienThoai(dto.getSoDienThoai());

        taiKhoanDao.save(tk);

        return ResponseEntity.ok(Map.of("message", "Cập nhật thành công"));
    }

    // ✅ Đổi mật khẩu
    @PutMapping("/doi-mat-khau")
    public ResponseEntity<?> doiMatKhau(@RequestBody DoiMatKhauDTO dto, HttpSession session) {
        Object usernameObj = session.getAttribute("username");
        if (usernameObj == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Chưa đăng nhập"));
        }

        String username = usernameObj.toString();
        Optional<TaiKhoan> taiKhoanOpt = taiKhoanDao.findByTenDangNhap(username);

        if (taiKhoanOpt.isEmpty()) {
            return ResponseEntity.status(404).body(Map.of("message", "Không tìm thấy tài khoản"));
        }

        TaiKhoan taiKhoan = taiKhoanOpt.get();

        // Kiểm tra mật khẩu cũ
        if (!taiKhoan.getMatKhau().equals(dto.getMatKhauCu())) {
            return ResponseEntity.badRequest().body(Map.of("message", "Mật khẩu cũ không đúng"));
        }

        // Kiểm tra xác nhận mật khẩu
        if (!dto.getMatKhauMoi().equals(dto.getXacNhanMatKhauMoi())) {
            return ResponseEntity.badRequest().body(Map.of("message", "Xác nhận mật khẩu không khớp"));
        }

        taiKhoan.setMatKhau(dto.getMatKhauMoi());
        taiKhoanDao.save(taiKhoan);

        return ResponseEntity.ok(Map.of("message", "Đổi mật khẩu thành công"));
    }
}
