package DATN.controller.dtocontroller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import DATN.dto.dtodata.DTO_CREATE;
import DATN.dto.dtodata.DTO_DETAILS;
import DATN.service.dtoservice.dto_service;

@RestController
@RequestMapping("/api/san-pham")
public class dto_controller {
    @Autowired
    private dto_service dto_service;

    // Tạo sản phẩm mới
    @PostMapping("/tao")
    public ResponseEntity<String> WBH_AD_CRT_THEMSP(@RequestBody DTO_CREATE dto) {
        try {
            dto_service.WBH_AD_CRT_THEMSP(dto);
            return ResponseEntity.ok("Thêm sản phẩm thành công!");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Thêm sản phẩm thất bại: " + e.getMessage());
        }
    }

    // Lấy toàn bộ dữ liệu sản phẩm theo id
    @GetMapping("/{id_sp}")
    public ResponseEntity<List<DTO_DETAILS>> DATN_SEL_SP_DB00001_1(@PathVariable int id_sp) {
        return ResponseEntity.ok(dto_service.DATN_SEL_SP_DB00001_1(id_sp));
    }

    // Lấy toàn bộ dữ liệu tất cả sản phẩm
    @GetMapping
    public ResponseEntity<List<DTO_DETAILS>> DATN_SEL_SP_DB00001_2() {
        return ResponseEntity.ok(dto_service.DATN_SEL_SP_DB00001_2());
    }

    // Sắp xếp sản phẩm theo ngày tạo
    @GetMapping("/ngay-tao")
    public ResponseEntity<List<DTO_DETAILS>> DATN_SEL_SP_DB00001_3() {
        return ResponseEntity.ok(dto_service.DATN_SEL_SP_DB00001_3());
    }

    // Sắp xếp sản phẩm theo lượt yêu thich
    @GetMapping("/yeu-thich")
    public ResponseEntity<List<DTO_DETAILS>> DATN_SEL_SP_DB00001_4() {
        return ResponseEntity.ok(dto_service.DATN_SEL_SP_DB00001_4());
    }

    // Lấy toàn bộ sản phẩm còn hạn giảm giá
    @GetMapping("/giam-gia")
    public ResponseEntity<List<DTO_DETAILS>> DATN_SEL_SP_DB00001_5() {
        return ResponseEntity.ok(dto_service.DATN_SEL_SP_DB00001_5());
    }

    // Tạo góp ý
    @PostMapping("/tao-gop-y")
    public ResponseEntity<String> DATN_CRE_GY_DB00002_0(@RequestBody DTO_CREATE dto) {
        try {
            dto_service.DATN_CRE_GY_DB00002_0(dto);
            return ResponseEntity.ok("Thêm góp ý thành công!");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Thêm góp ý thất bại: " + e.getMessage());
        }
    }

    // Cập nhật sản phẩm
    @PutMapping("/cap-nhat")
    public ResponseEntity<String> DATN_UPD_SP_DB00001_6(@RequestBody DTO_CREATE dto) {
        try {
            dto_service.DATN_UPD_SP_DB00001_6(dto);
            return ResponseEntity.ok("Cập nhật sản phẩm thành công!");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Cập nhật sản phẩm thất bại: " + e.getMessage());
        }
    }

    // Lấy toàn bộ dữ liệu góp ý
    @GetMapping("/gop-y")
    public ResponseEntity<List<DTO_DETAILS>> DATN_SEL_GY_DB00002_1(@RequestParam int p_pageNo,
            @RequestParam int p_pageSize) {
        return ResponseEntity.ok(dto_service.DATN_SEL_GY_DB00002_1(p_pageNo, p_pageSize));
    }
}
/*
 * {
 * "tensanpham": "Laptop X",
 * "dongia": 20000000,
 * "loai": 1,
 * "thuonghieu": 2,
 * "anhgoc": "image.jpg",
 * "cpuBrand": "Intel",
 * "cpuModel": "i5-1135G7",
 * "cpuType": "U",
 * "cpuMinSpeed": "2.4GHz",
 * "cpuMaxSpeed": "4.2GHz",
 * "cpuCores": "4",
 * "cpuThreads": "8",
 * "cpuCache": "8MB",
 * "gpuBrand": "NVIDIA",
 * "gpuModel": "MX450",
 * "gpuFullName": "NVIDIA GeForce MX450",
 * "gpuMemory": "2GB",
 * "ram": "16GB",
 * "rom": "512GB SSD",
 * "screen": "15.6 inch FHD",
 * "mausac": "Đen",
 * "soluong": 10
 * }
 */