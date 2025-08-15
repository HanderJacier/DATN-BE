package com.example.DATN.controller; // Package chứa controller, xử lý HTTP request

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import com.example.DATN.entity.DynamicProcedureEntity;
import com.example.DATN.mapper.DynamicProcedureMapper;
import com.example.DATN.repository.DynamicProcedureRequest;
import com.example.DATN.service.DynamicProcedureService;

import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@RestController // Đánh dấu đây là REST controller (tự động trả JSON)
@RequestMapping("/api/datn") // Gốc URL cho các API trong controller này
public class controller {

    private final DynamicProcedureService service; // Inject service xử lý logic gọi procedure

    // Regex để kiểm tra tên thủ tục hợp lệ (WBH_US_SEL_xxx hoặc WBH_AD_CRT_xxx ...)
    private static final Pattern PROCEDURE_NAME_PATTERN = Pattern
        .compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_[A-Za-z0-9_]+$");

    // Constructor injection (khuyến khích dùng thay vì @Autowired trực tiếp)
    public DynamicProcedureController(DynamicProcedureService service) {
        this.service = service;
    }

    // POST /api/datn/{procedureName}
    @PostMapping("/{procedureName}")
    public ResponseEntity<?> call(
            @PathVariable String procedureName, // Tên stored procedure
            @RequestBody DynamicProcedureRequest request) { // Dữ liệu đầu vào truyền vào (Map)

        // Kiểm tra tên stored procedure có hợp lệ không
        if (!isValidProcedureName(procedureName)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid procedure name: " + procedureName);
        }

        // Phân tích thủ tục để in log: lấy module và action từ tên
        String[] parts = procedureName.split("_");
        String module = parts.length >= 2 ? parts[1] : "UNKNOWN";
        String action = parts.length >= 3 ? parts[2] : "UNKNOWN";

        // In ra log để tiện debug
        System.out.printf("[API CALL] Module: %s | Action: %s | Procedure: %s%n",
                module, action, procedureName);

        try {
            // Gọi stored procedure và nhận kết quả
            List<Map<String, Object>> rows = service.callProcedure(procedureName, request.getParams());

            // Chuyển từng dòng kết quả (Map) sang đối tượng DynamicProcedureEntity
            List<DynamicProcedureEntity> results = rows.stream()
                    .map(DynamicProcedureMapper::toEntity)
                    .collect(Collectors.toList());

            // Trả về danh sách entity đã map
            return ResponseEntity.ok(results);

        } catch (Exception ex) {
            ex.printStackTrace(); // Ghi log lỗi

            // Trả lỗi 500 nếu procedure thực thi thất bại
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error while executing procedure: " + ex.getMessage());
        }
    }

    // Hàm kiểm tra tên procedure có hợp lệ không dựa trên regex
    private boolean isValidProcedureName(String name) {
        return StringUtils.hasText(name) && PROCEDURE_NAME_PATTERN.matcher(name).matches();
    }

    // GET /api/datn/swagger/{procedureName}
    // Dùng để "inspect" 1 procedure: xem metadata đầu vào/đầu ra
    @GetMapping("/swagger/{procedureName}")
    public Map<String, Object> inspectProcedure(@PathVariable String procedureName) {
        Map<String, Object> result = new HashMap<>();

        // Phân tích meta từ tên procedure (role, action, entity)
        Map<String, String> meta = service.parseProcedureName(procedureName);

        // Lấy thông tin các tham số đầu vào từ INFORMATION_SCHEMA
        List<Map<String, Object>> inputParams = service.getProcedureInputParams2(procedureName);

        // Tạo dummy param để truyền vào khi gọi FMTONLY (chỉ lấy metadata)
        Map<String, Object> dummyInputs = new HashMap<>();
        for (Map<String, Object> param : inputParams) {
            Object name = param.get("PARAMETER_NAME");
            if (name != null) dummyInputs.put(name.toString().replace("@", ""), null);
        }

        // Gọi procedure ở chế độ "xem trước" để lấy danh sách cột đầu ra
        List<String> outputFields = service.getProcedureOutputFields(procedureName, dummyInputs);

        // Đóng gói tất cả metadata vào kết quả trả về
        result.put("inputParams", inputParams);
        result.put("outputFields", outputFields);
        result.put("meta", meta);

        return result; // Trả về JSON: { inputParams: [...], outputFields: [...], meta: {...} }
    }
}
