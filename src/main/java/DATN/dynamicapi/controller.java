package DATN.dynamicapi;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/datn")
public class controller {
    private final service service;

    // Regex chuẩn xác cho tên procedure (nên đồng bộ với Service)
    private static final Pattern PROCEDURE_NAME_PATTERN = Pattern
            .compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_[A-Za-z0-9_]+$");

    public controller(service service) {
        this.service = service;
    }

    @PostMapping("/{procedureName}")
    public ResponseEntity<?> call(
            @PathVariable String procedureName,
            @RequestBody request request) {
        // Validate procedureName trước
        if (!isValidProcedureName(procedureName)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid procedure name: " + procedureName);
        }

        // 👉 Trích xuất module và action từ procedureName
        String[] parts = procedureName.split("_");
        String module = parts.length >= 2 ? parts[1] : "UNKNOWN";
        String action = parts.length >= 3 ? parts[2] : "UNKNOWN";

        // 👉 In log rõ ràng
        System.out.printf("[API CALL] Module: %s | Action: %s | Procedure: %s%n",
                module, action, procedureName);

        try {
            List<Map<String, Object>> rows = service.callProcedure(procedureName, request.getParams());

            List<entity> results = rows.stream()
                    .map(this::convertToUniversalDTO)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(results);

        } catch (Exception ex) {
            ex.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error while executing procedure: " + ex.getMessage());
        }
    }

    private boolean isValidProcedureName(String name) {
        return StringUtils.hasText(name) && PROCEDURE_NAME_PATTERN.matcher(name).matches();
    }

    private entity convertToUniversalDTO(Map<String, Object> row) {
        entity dto = new entity();
        dto.setFields(row);
        return dto;
    }

    @GetMapping("/swagger/{procedureName}")
    public Map<String, Object> inspectProcedure(@PathVariable String procedureName) {
        Map<String, Object> result = new HashMap<>();

        // Metadata từ tên procedure
        Map<String, String> meta = service.parseProcedureName(procedureName);

        // Danh sách input params (nếu có)
        List<Map<String, Object>> inputParams = service.getProcedureInputParams2(procedureName);

        // Tạo dummy params = NULL cho việc FMTONLY
        Map<String, Object> dummyInputs = new HashMap<>();
        for (Map<String, Object> param : inputParams) {
            Object name = param.get("PARAMETER_NAME");
            if (name != null) dummyInputs.put(name.toString().replace("@", ""), null);
        }

        // Lấy danh sách output fields
        List<String> outputFields = service.getProcedureOutputFields(procedureName, dummyInputs);

        result.put("inputParams", inputParams);
        result.put("outputFields", outputFields);
        result.put("meta", meta);

        return result;
    }
}
