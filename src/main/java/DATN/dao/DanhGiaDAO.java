package DATN.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import DATN.entity.TaiKhoan.DanhGia;

public interface DanhGiaDAO extends JpaRepository<DanhGia, Integer>{
	List<DanhGia> findBySanpham(Integer sanpham);
}
