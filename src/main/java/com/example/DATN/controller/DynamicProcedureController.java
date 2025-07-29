package com.example.DATN.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import com.example.DATN.entity.DynamicProcedureEntity;
import com.example.DATN.mapper.DynamicProcedureMapper;
import com.example.DATN.repository.DynamicProcedureRequest;
import com.example.DATN.service.DynamicProcedureService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/datn")
public class DynamicProcedureController {
    private final DynamicProcedureService service;

    private static final Pattern PROCEDURE_NAME_PATTERN = Pattern
        .compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_[A-Za-z0-9_]+$");

    public DynamicProcedureController(DynamicProcedureService service) {
        this.service = service;
    }

    @PostMapping("/{procedureName}")
    public ResponseEntity<?> call(
            @PathVariable String procedureName,
            @RequestBody DynamicProcedureRequest request) {
        if (!isValidProcedureName(procedureName)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid procedure name: " + procedureName);
        }
        String[] parts = procedureName.split("_");
        String module = parts.length >= 2 ? parts[1] : "UNKNOWN";
        String action = parts.length >= 3 ? parts[2] : "UNKNOWN";
        System.out.printf("[API CALL] Module: %s | Action: %s | Procedure: %s%n",
                module, action, procedureName);
        try {
            List<Map<String, Object>> rows = service.callProcedure(procedureName, request.getParams());
            List<DynamicProcedureEntity> results = rows.stream()
                    .map(DynamicProcedureMapper::toEntity)
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


    @GetMapping("/swagger/{procedureName}")
    public Map<String, Object> inspectProcedure(@PathVariable String procedureName) {
        Map<String, Object> result = new HashMap<>();
        Map<String, String> meta = service.parseProcedureName(procedureName);
        List<Map<String, Object>> inputParams = service.getProcedureInputParams2(procedureName);
        Map<String, Object> dummyInputs = new HashMap<>();
        for (Map<String, Object> param : inputParams) {
            Object name = param.get("PARAMETER_NAME");
            if (name != null) dummyInputs.put(name.toString().replace("@", ""), null);
        }
        List<String> outputFields = service.getProcedureOutputFields(procedureName, dummyInputs);
        result.put("inputParams", inputParams);
        result.put("outputFields", outputFields);
        result.put("meta", meta);
        return result;
    }
}
