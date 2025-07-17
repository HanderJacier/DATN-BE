package DATN.service;

import DATN.dao.TaiKhoanDao;
import DATN.entity.TaiKhoan.TaiKhoan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class TaiKhoanService {

    private final TaiKhoanDao taiKhoanDao;

    public Map<String, Object> login(String tenDangNhap, String matKhau) {
        Map<String, Object> response = new HashMap<>();

        Optional<TaiKhoan> taiKhoanOpt = timTaiKhoanTheoThongTinDangNhap(tenDangNhap);

        if (taiKhoanOpt.isEmpty()) {
            response.put("message", "Tài khoản không tồn tại");
            return response;
        }

        TaiKhoan taiKhoan = taiKhoanOpt.get();

        if (!taiKhoan.getMatKhau().equals(matKhau)) {
            response.put("message", "Mật khẩu không đúng");
            return response;
        }

        if (!taiKhoan.getTrangThai()) {
            response.put("message", "Tài khoản đã bị khóa");
            return response;
        }

        response.put("message", "Đăng nhập thành công");
        response.put("idtk", taiKhoan.getId_tk());
        response.put("vaiTro", taiKhoan.getVaiTro() ? 1 : 0);
        response.put("hoVaTen", taiKhoan.getHoVaTen());
        response.put("tenDangNhap", taiKhoan.getTenDangNhap()); // ✅ thêm dòng này
        return response;
    }


    // === REGISTER ===
    public Map<String, Object> register(TaiKhoan taiKhoan) {
        Map<String, Object> response = new HashMap<>();

        // Kiểm tra xem tên đăng nhập, email hoặc số điện thoại đã tồn tại chưa
        if (taiKhoanDao.findByTenDangNhap(taiKhoan.getTenDangNhap()).isPresent()) {
            response.put("message", "Tên đăng nhập đã tồn tại");
            return response;
        }
        if (taiKhoanDao.findByEmail(taiKhoan.getEmail()).isPresent()) {
            response.put("message", "Email đã tồn tại");
            return response;
        }
        if (taiKhoanDao.findBySoDienThoai(taiKhoan.getSoDienThoai()).isPresent()) {
            response.put("message", "Số điện thoại đã tồn tại");
            return response;
        }

        // Mã hóa mật khẩu trước khi lưu (nếu cần)
        // taiKhoan.setMatKhau(passwordEncoder.encode(taiKhoan.getMatKhau()));

        // Lưu tài khoản vào database
        taiKhoanDao.save(taiKhoan);
        response.put("message", "Đăng ký thành công");
        response.put("taiKhoan", taiKhoan); // Trả về thông tin tài khoản nếu cần

        return response;
    }

    // === PRIVATE UTIL ===
    private Optional<TaiKhoan> timTaiKhoanTheoThongTinDangNhap(String thongTin) {
        // Ưu tiên theo tên đăng nhập, nếu không có thì email, sau đó số điện thoại
        Optional<TaiKhoan> tk = taiKhoanDao.findByTenDangNhap(thongTin);
        if (tk.isPresent()) return tk;

        tk = taiKhoanDao.findByEmail(thongTin);
        if (tk.isPresent()) return tk;

        return taiKhoanDao.findBySoDienThoai(thongTin);
    }

}
