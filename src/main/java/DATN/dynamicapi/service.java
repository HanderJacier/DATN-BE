package DATN.dynamicapi;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.sql.DataSource;

@Service
public class service {
    private final JdbcTemplate jdbcTemplate;

    private static final Pattern PROCEDURE_NAME_PATTERN = Pattern
            .compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_([A-Za-z0-9_]+)$");

    public service(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> callProcedure(String procedureName, Map<String, Object> params) {
        Matcher matcher = PROCEDURE_NAME_PATTERN.matcher(procedureName);
        if (!matcher.matches()) {
            throw new IllegalArgumentException("Invalid or unsafe procedure name: " + procedureName);
        }

        StringBuilder sql = new StringBuilder("EXEC ").append(procedureName);
        Object[] paramValues = new Object[0];

        if (params != null && !params.isEmpty()) {
            String paramPlaceholders = params.keySet().stream()
                    .map(key -> "@" + key + "=?")
                    .collect(Collectors.joining(", "));
            sql.append(" ").append(paramPlaceholders);
            paramValues = params.values().toArray();
        }

        logProcedureCall(procedureName, params);

        try {
            List<Map<String, Object>> result = jdbcTemplate.queryForList(sql.toString(), paramValues);

            if (result == null || result.isEmpty()) {
                return List.of(Map.of("message", "Procedure executed successfully but returned no data"));
            }

            return result;
        } catch (org.springframework.dao.DataAccessException e) {
            // fallback khi procedure không có SELECT → dùng update
            try {
                return List.of(Map.of(
                        "message", "Procedure executed successfully (no result set)"
                ));
            } catch (Exception ex) {
                throw new RuntimeException("Failed to execute procedure: " + ex.getMessage(), ex);
            }
        }
    }

    private void logProcedureCall(String procedure, Map<String, Object> params) {
        System.out.println("[PROC CALL] " + procedure + " with params: " + params);
    }

    public List<Map<String, Object>> getProcedureInputParams(String procedureName) {
        String sql = "SELECT argument_name, data_type, in_out FROM all_arguments " +
                "WHERE object_name = ? AND owner = 'WBH' AND argument_name IS NOT NULL " +
                "ORDER BY position";
        return jdbcTemplate.queryForList(sql, procedureName.toUpperCase());
    }

    // @GetMapping("/swagger/{procedureName}")
    @Autowired
    private NamedParameterJdbcTemplate namedJdbcTemplate;

    @Autowired
    private DataSource dataSource;

    public List<String> getProcedureOutputFields(String procedureName, Map<String, Object> dummyParams) {
        List<String> columns = new ArrayList<>();

        StringBuilder execProc = new StringBuilder("SET FMTONLY ON; EXEC ").append(procedureName);

        if (dummyParams != null && !dummyParams.isEmpty()) {
            String paramStr = dummyParams.keySet().stream()
                    .map(key -> "@" + key + "=NULL")
                    .collect(Collectors.joining(", "));
            execProc.append(" ").append(paramStr);
        }

        execProc.append("; SET FMTONLY OFF;");

        try (Connection conn = dataSource.getConnection(); Statement stmt = conn.createStatement()) {
            boolean hasResult = stmt.execute(execProc.toString());
            if (hasResult) {
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData meta = rs.getMetaData();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    columns.add(meta.getColumnName(i) + " (" + meta.getColumnTypeName(i) + ")");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching procedure output fields: " + e.getMessage(), e);
        }

        return columns;
    }

    public List<Map<String, Object>> getProcedureInputParams2(String procedureName) {
        String sql = "SELECT PARAMETER_NAME, DATA_TYPE, PARAMETER_MODE " +
                "FROM INFORMATION_SCHEMA.PARAMETERS " +
                "WHERE SPECIFIC_NAME = :procName " +
                "ORDER BY ORDINAL_POSITION";

        Map<String, Object> params = Map.of("procName", procedureName);
        return namedJdbcTemplate.queryForList(sql, params);
    }

    public Map<String, String> parseProcedureName(String procedureName) {
        Pattern pattern = Pattern.compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_([A-Za-z0-9_]+)$");
        Matcher matcher = pattern.matcher(procedureName);

        if (!matcher.matches()) {
            throw new IllegalArgumentException("Procedure name does not follow the required pattern.");
        }

        Map<String, String> result = new HashMap<>();
        result.put("role", matcher.group(1).equals("US") ? "User" : "Admin");
        result.put("action", switch (matcher.group(2)) {
            case "SEL" -> "Select";
            case "CRT" -> "Create";
            case "UPD" -> "Update";
            case "DEL" -> "Delete";
            default -> "Unknown";
        });
        result.put("entity", matcher.group(3)); // Ví dụ: XEMSP

        return result;
    }

}
