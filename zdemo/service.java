package com.example.DATN.zdemo; // Package chứa các lớp logic xử lý nghiệp vụ (business logic)

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate; // Dùng để thao tác truy vấn cơ bản với CSDL
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate; // Cho phép sử dụng tham số có tên trong truy vấn
import org.springframework.stereotype.Service;

import java.sql.*; // Thao tác với JDBC trực tiếp
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.sql.DataSource; // Đối tượng đại diện cho nguồn dữ liệu (connection pool)

@Service // Đánh dấu đây là một Spring Service để có thể inject và quản lý
public class service {

    private final JdbcTemplate jdbcTemplate; // Dùng để gọi stored procedure đơn giản (với ?)

    // Biểu thức regex để kiểm tra định dạng tên stored procedure
    private static final Pattern PROCEDURE_NAME_PATTERN = Pattern
            .compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_([A-Za-z0-9_]+)$");

    // Constructor injection để đảm bảo jdbcTemplate được truyền vào khi tạo service
    public DynamicProcedureService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Gọi stored procedure có truyền tham số và trả về kết quả dạng List<Map>
    public List<Map<String, Object>> callProcedure(String procedureName, Map<String, Object> params) {

        // Kiểm tra tên thủ tục có hợp lệ không (dựa vào regex)
        Matcher matcher = PROCEDURE_NAME_PATTERN.matcher(procedureName);
        if (!matcher.matches()) {
            throw new IllegalArgumentException("Tên thủ tục không hợp lệ hoặc không an toàn: " + procedureName);
        }

        // Tạo câu lệnh SQL bắt đầu với EXEC {procedureName}
        StringBuilder sql = new StringBuilder("EXEC ").append(procedureName);
        Object[] paramValues = new Object[0]; // Mảng giá trị truyền vào

        // Nếu có tham số truyền vào thì tạo chuỗi tham số kiểu "@param1 = ?", "@param2 = ?"
        if (params != null && !params.isEmpty()) {
            String paramPlaceholders = params.keySet().stream()
                    .map(key -> "@" + key + "=?")
                    .collect(Collectors.joining(", "));
            sql.append(" ").append(paramPlaceholders); // Gắn thêm tham số vào câu lệnh EXEC
            paramValues = params.values().toArray(); // Chuyển sang mảng để truyền cho query
        }

        logProcedureCall(procedureName, params); // In log ra console để theo dõi gọi procedure

        try {
            // Gọi stored procedure và trả về danh sách kết quả
            List<Map<String, Object>> result = jdbcTemplate.queryForList(sql.toString(), paramValues);

            // Nếu có kết quả trả về thì return, ngược lại trả về thông báo lỗi
            if (result != null && !result.isEmpty()) {
                return result;
            } else {
                return List.of(Map.of("status", "ERROR"));
            }

        } catch (DataAccessException dae) {
            // Bắt lỗi nếu truy vấn database thất bại
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("status", "ERROR");
            errorResult.put("message", dae.getMessage());

            if (dae.getCause() != null) {
                errorResult.put("cause", dae.getCause().toString());
            }

            return List.of(errorResult); // Trả về lỗi dạng List<Map> để giữ định dạng nhất quán
        }
    }

    // Hàm in log cho biết procedure nào đang được gọi và với tham số nào
    private void logProcedureCall(String procedure, Map<String, Object> params) {
        System.out.println("[PROC CALL] " + procedure + " with params: " + params);
    }

    // Phương thức (không dùng) để lấy thông tin tham số đầu vào từ Oracle ALL_ARGUMENTS
    public List<Map<String, Object>> getProcedureInputParams(String procedureName) {
        String sql = "SELECT argument_name, data_type, in_out FROM all_arguments " +
                "WHERE object_name = ? AND owner = 'WBH' AND argument_name IS NOT NULL " +
                "ORDER BY position";
        return jdbcTemplate.queryForList(sql, procedureName.toUpperCase());
    }

    @Autowired
    private NamedParameterJdbcTemplate namedJdbcTemplate; // Cho phép chạy SQL với tham số có tên

    @Autowired
    private DataSource dataSource; // Để tạo connection JDBC raw (thô)

    // Lấy ra danh sách cột (output fields) mà procedure trả về, dùng FMTONLY (SQL Server only)
    public List<String> getProcedureOutputFields(String procedureName, Map<String, Object> dummyParams) {
        List<String> columns = new ArrayList<>();

        // Dùng FMTONLY để chỉ lấy metadata mà không thực thi thật
        StringBuilder execProc = new StringBuilder("SET FMTONLY ON; EXEC ").append(procedureName);
        if (dummyParams != null && !dummyParams.isEmpty()) {
            String paramStr = dummyParams.keySet().stream()
                    .map(key -> "@" + key + "=NULL") // Truyền NULL để tránh thực thi logic
                    .collect(Collectors.joining(", "));
            execProc.append(" ").append(paramStr);
        }
        execProc.append("; SET FMTONLY OFF;");

        // Thực thi câu lệnh để lấy metadata
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
            throw new RuntimeException("Lỗi khi tìm nạp các trường đầu ra của quy trình: " + e.getMessage(), e);
        }

        return columns; // Trả về danh sách tên cột và kiểu dữ liệu
    }

    // Dùng INFORMATION_SCHEMA để lấy input parameters (SQL Server)
    public List<Map<String, Object>> getProcedureInputParams2(String procedureName) {
        String sql = "SELECT PARAMETER_NAME, DATA_TYPE, PARAMETER_MODE " +
                "FROM INFORMATION_SCHEMA.PARAMETERS " +
                "WHERE SPECIFIC_NAME = :procName " +
                "ORDER BY ORDINAL_POSITION";

        Map<String, Object> params = Map.of("procName", procedureName);
        return namedJdbcTemplate.queryForList(sql, params); // Truy vấn bằng NamedParameter
    }

    // Phân tích tên thủ tục theo quy ước: WBH_{role}_{action}_{entity}
    public Map<String, String> parseProcedureName(String procedureName) {
        Pattern pattern = Pattern.compile("^WBH_(US|AD)_(SEL|CRT|UPD|DEL)_([A-Za-z0-9_]+)$");
        Matcher matcher = pattern.matcher(procedureName);
        if (!matcher.matches()) {
            throw new IllegalArgumentException("Tên thủ tục không tuân theo mẫu yêu cầu.");
        }

        Map<String, String> result = new HashMap<>();
        // Xác định vai trò (User/Admin)
        result.put("role", matcher.group(1).equals("US") ? "User" : "Admin");

        // Xác định hành động (Select/Create/Update/Delete)
        result.put("action", switch (matcher.group(2)) {
            case "SEL" -> "Select";
            case "CRT" -> "Create";
            case "UPD" -> "Update";
            case "DEL" -> "Delete";
            default -> "Unknown";
        });

        // Lấy phần tên entity (bảng hoặc thực thể liên quan)
        result.put("entity", matcher.group(3));
        return result;
    }
}
