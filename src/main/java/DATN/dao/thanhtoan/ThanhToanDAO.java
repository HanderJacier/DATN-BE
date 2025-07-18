package DATN.dao.thanhtoan;

import DATN.entity.thanhtoan.ThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ThanhToanDAO extends JpaRepository<ThanhToan, Integer> {
    List<ThanhToan> findByHoaDon(Integer hoaDon);
    Optional<ThanhToan> findByMaGiaoDich(String maGiaoDich);
    List<ThanhToan> findByTaiKhoanOrderByNgayTaoDesc(Integer taiKhoan);
}