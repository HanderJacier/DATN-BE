package DATN.service;

import DATN.dao.DanhGiaDAO;
import DATN.dao.TaiKhoanDao;
import DATN.dto.DanhGiaDTO;
import DATN.dto.DanhGiaCreateDTO;
import DATN.entity.TaiKhoan.DanhGia;
import DATN.entity.TaiKhoan.TaiKhoan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DanhGiaService {

    private final DanhGiaDAO danhGiaRepo;
    private final TaiKhoanDao taiKhoanDao;

    // ✅ Tạo đánh giá từ DanhGiaCreateDTO
    @Transactional
    public void taoDanhGia(DanhGiaCreateDTO dto) {
        DanhGia dg = new DanhGia();
        dg.setTaikhoan(dto.getTaikhoan());
        dg.setSanpham(dto.getSanpham());
        dg.setNoidung(dto.getNoidung());
        dg.setDiemso(dto.getDiemso() != null ? dto.getDiemso() : 0);

        danhGiaRepo.save(dg);
    }

    // ✅ Lấy tất cả đánh giá của một sản phẩm
    public List<DanhGiaDTO> layTheoSanPham(Integer idSanPham) {
        return danhGiaRepo.findBySanpham(idSanPham)
                .stream()
                .map(this::mapToDTO)
                .toList();
    }

    // ✅ Xóa đánh giá
    @Transactional
    public void xoaDanhGia(Integer idDg) {
        if (!danhGiaRepo.existsById(idDg)) {
            throw new RuntimeException("Đánh giá không tồn tại");
        }
        danhGiaRepo.deleteById(idDg);
    }

    // ✅ Chuyển Entity -> DTO
    private DanhGiaDTO mapToDTO(DanhGia dg) {
        DanhGiaDTO dto = new DanhGiaDTO();
        dto.setId_dg(dg.getId_dg());
        dto.setNoidung(dg.getNoidung());
        dto.setDiemso(dg.getDiemso());
        

        Optional<TaiKhoan> tk = taiKhoanDao.findById(dg.getTaikhoan());
        dto.setTenNguoiDung(tk.map(TaiKhoan::getHoVaTen).orElse("Ẩn danh"));

        return dto;
    }
}
