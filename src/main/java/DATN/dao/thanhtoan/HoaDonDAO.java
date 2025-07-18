package DATN.dao.thanhtoan;

import DATN.entity.thanhtoan.HoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HoaDonDAO extends JpaRepository<HoaDon, Integer> {
    List<HoaDon> findByTaiKhoanOrderByNgayTaoDesc(Integer taiKhoan);
    List<HoaDon> findByTrangThai(String trangThai);
}