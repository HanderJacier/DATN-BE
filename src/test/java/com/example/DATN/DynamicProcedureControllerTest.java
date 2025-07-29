package com.example.DATN;

import com.example.DATN.controller.DynamicProcedureController;
import com.example.DATN.entity.DynamicProcedureEntity;
import com.example.DATN.repository.DynamicProcedureRequest;
import com.example.DATN.service.DynamicProcedureService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.util.*;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.transaction.Transactional;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(locations = "classpath:application.properties")
@Transactional
@Rollback
public class DynamicProcedureControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private ObjectMapper objectMapper;

    @BeforeEach
    void setup() {
        objectMapper = new ObjectMapper();
    }

    @Test
    void WBH_AD_CRT_THEMSP() throws Exception {
        String procedureName = "WBH_AD_CRT_THEMSP";

        // Dữ liệu gửi lên
        Map<String, Object> params = new HashMap<>();
        params.put("p_tensanpham", "iPhone 14 Pro 1");
        params.put("p_dongia", 25990100.00);
        params.put("p_loai", 10);
        params.put("p_thuonghieu", 10);
        params.put("p_anhgoc", "https://res.cloudinary.com/...png");
        params.put("p_cpuBrand", "Apple");
        params.put("p_cpuModel", "A16 Bionic");
        params.put("p_cpuType", "High-end");
        params.put("p_cpuMinSpeed", "3.46 GHz");
        params.put("p_cpuMaxSpeed", "3.46 GHz");
        params.put("p_cpuCores", "6");
        params.put("p_cpuThreads", "6");
        params.put("p_cpuCache", "16MB");
        params.put("p_gpuBrand", "Apple");
        params.put("p_gpuModel", "Apple GPU");
        params.put("p_gpuFullName", "Apple GPU 5-core");
        params.put("p_gpuMemory", "6GB");
        params.put("p_ram", "6GB");
        params.put("p_rom", "128GB");
        params.put("p_screen", "6.1");
        params.put("p_mausac", "Tím");
        params.put("p_soluong", 10);
        params.put("p_anhphu", "https://res.cloudinary.com/...png");
        params.put("p_id_gg", 1);
        params.put("p_hangiamgia", "2025-08-30");

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(params);

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.status").exists()); // or .value(giá trị kỳ vọng)
    }

    @Test
    void WBH_US_SEL_DETAIL_SP() throws Exception {
        String procedureName = "WBH_US_SEL_DETAIL_SP";

        Map<String, Object> params = new HashMap<>();
        params.put("p_id_sp", 1);

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(params);

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.id_sp").exists()); // kiểm tra có field id_sp
    }

    @Test
    void WBH_US_SEL_XEMSP() throws Exception {
        String procedureName = "WBH_US_SEL_XEMSP";

        // Nếu procedure không cần param
        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(new HashMap<>()); // hoặc null

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.id_sp").exists()); // kiểm tra có field id_sp
    }

    @Test
    void WBH_US_SEL_NGAYTAOSP() throws Exception {
        String procedureName = "WBH_US_SEL_NGAYTAOSP";

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(new HashMap<>()); // hoặc null

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.id_sp").exists()); // kiểm tra có field id_sp
    }

    @Test
    void WBH_US_SEL_RANKYTSP() throws Exception {
        String procedureName = "WBH_US_SEL_RANKYTSP";

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(new HashMap<>()); // hoặc null

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.id_sp").exists()); // kiểm tra có field id_sp
    }

    @Test
    void WBH_US_SEL_SALESP() throws Exception {
        String procedureName = "WBH_US_SEL_SALESP";

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(new HashMap<>()); // hoặc null

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.id_sp").exists()); // kiểm tra có field id_sp
    }

    @Test
    void WBH_AD_UPD_SUASP() throws Exception {
        String procedureName = "WBH_AD_UPD_SUASP";

        // Dữ liệu gửi lên
        Map<String, Object> params = new HashMap<>();
        params.put("p_id_sp", 1);
        params.put("p_tensanpham", "iPhone 14 Pro 1_1");
        params.put("p_dongia", 25990100.00);
        params.put("p_loai", 10);
        params.put("p_thuonghieu", 10);
        params.put("p_anhgoc", "https://res.cloudinary.com/...png");
        params.put("p_cpuBrand", "Apple");
        params.put("p_cpuModel", "A16 Bionic");
        params.put("p_cpuType", "High-end");
        params.put("p_cpuMinSpeed", "3.46 GHz");
        params.put("p_cpuMaxSpeed", "3.46 GHz");
        params.put("p_cpuCores", "6");
        params.put("p_cpuThreads", "6");
        params.put("p_cpuCache", "16MB");
        params.put("p_gpuBrand", "Apple");
        params.put("p_gpuModel", "Apple GPU");
        params.put("p_gpuFullName", "Apple GPU 5-core");
        params.put("p_gpuMemory", "6GB");
        params.put("p_ram", "6GB");
        params.put("p_rom", "128GB");
        params.put("p_screen", "6.1");
        params.put("p_mausac", "Tím");
        params.put("p_soluong", 10);
        params.put("p_anhphu", "https://res.cloudinary.com/...png");
        params.put("p_id_gg", 1);
        params.put("p_hangiamgia", "2025-08-30");

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(params);

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.status").exists());
    }

    @Test
    void WBH_US_CRT_GY() throws Exception {
        String procedureName = "WBH_US_CRT_GY";

        // Dữ liệu gửi lên
        Map<String, Object> params = new HashMap<>();
        params.put("id_tk", 1);
        params.put("noidung", "iPhone 14 Pro 1_1");

        DynamicProcedureRequest request = new DynamicProcedureRequest();
        request.setParams(params);

        mockMvc.perform(post("/api/datn/" + procedureName)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].fields.status").exists());
    }
}
