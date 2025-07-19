package DATN.dto.dtodata;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class DTO_CREATE {
    // Tài khoản
    private Integer id_tk;   

    // Thông tin sản phẩm chính
    private Integer id_sp;
    private String tensanpham;
    private Integer dongia;
    private Integer loai;
    private String loaiTen;
    private Integer thuonghieu;
    private String thuonghieuTen;
    private String anhgoc;
    private Date hangiamgia;
    private Date ngaytao;
    private Integer loaigiam;
    private String loaigiamTen;

    // Thông số kỹ thuật
    private Integer id_ts;
    private String cpuBrand;
    private String cpuModel;
    private String cpuType;
    private String cpuMinSpeed;
    private String cpuMaxSpeed;
    private String cpuCores;
    private String cpuThreads;
    private String cpuCache;
    private String gpuBrand;
    private String gpuModel;
    private String gpuFullName;
    private String gpuMemory;
    private String ram;
    private String rom;
    private String screen;
    private String mausac;
    private Integer soluong;

    // Ảnh phụ
    private Integer id_a;
    private String diachianh;

    // Góp ý
    private Integer id_gy;
    private Integer taikhoan;
    private String gy_noidung;
    private Date gy_ngaytao;
    private Date gy_ngaycapnhat;

    // Đánh giá
    private Integer id_dg;
    private Integer dg_taikhoan;
    private Integer dg_sanpham;
    private String noidung;
    private Integer diemso;

    // Yêu thích
    private Integer id_yt;
    private Integer yt_sanpham;
    private Integer yt_taikhoan;
    private String trangthai;

}
