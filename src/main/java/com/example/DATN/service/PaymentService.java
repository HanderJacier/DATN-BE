package com.example.DATN.service;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.HexFormat;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.DATN.entity.OrderRequest;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PaymentService {

    @Value("${momo.endpoint}")
    private String momoEndpoint;

    @Value("${momo.partnerCode}")
    private String partnerCode;

    @Value("${momo.accessKey}")
    private String accessKey;

    @Value("${momo.secretKey}")
    private String secretKey;

    @Value("${momo.redirectUrl}")
    private String redirectUrl;

    @Value("${momo.ipnUrl}")
    private String ipnUrl;

    private final JdbcTemplate jdbcTemplate; // để gọi procedure SQL Server

    public PaymentService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> createPayment(OrderRequest order) throws Exception {
        String transactionId = "MM" + System.currentTimeMillis();

        // 1. Gọi procedure lưu hóa đơn
        SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("WBH_US_CRT_HOA_DON_DIEN_TU");

        Map<String, Object> params = new HashMap<>();
        params.put("p_id_hd", order.getIdHd());
        params.put("p_id_hoa_don", transactionId);
        params.put("p_khach_hang", order.getCustomerInfo().getName());
        params.put("p_so_dien_thoai", order.getCustomerInfo().getPhone());
        params.put("p_email", order.getCustomerInfo().getEmail());
        params.put("p_dia_chi", order.getCustomerInfo().getAddress());
        params.put("p_phuong_thuc_thanh_toan", "MOMO");
        params.put("p_tong_tien", order.getFinalAmount());
        params.put("p_ma_giao_dich", transactionId);
        params.put("p_chi_tiet_san_pham", new ObjectMapper().writeValueAsString(order.getItems()));

        Map<String, Object> invoiceResult = jdbcCall.execute(params);
        if (invoiceResult == null || invoiceResult.isEmpty()) {
            throw new RuntimeException("Không tạo được hóa đơn điện tử");
        }

        // 2. Gọi MoMo API
        String requestId = transactionId;
        String rawSignature = String.format(
                "accessKey=%s&amount=%s&extraData=&ipnUrl=%s&orderId=%s&orderInfo=%s&partnerCode=%s&redirectUrl=%s&requestId=%s&requestType=%s",
                accessKey, order.getFinalAmount(), ipnUrl, transactionId,
                "Thanh toan hoa don " + order.getIdHd(),
                partnerCode, redirectUrl, requestId, "captureWallet"
        );

        String signature = hmacSHA256(rawSignature, secretKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("partnerCode", partnerCode);
        requestBody.put("accessKey", accessKey);
        requestBody.put("requestId", requestId);
        requestBody.put("amount", order.getFinalAmount().toString());
        requestBody.put("orderId", transactionId);
        requestBody.put("orderInfo", "Thanh toan hoa don " + order.getIdHd());
        requestBody.put("redirectUrl", redirectUrl);
        requestBody.put("ipnUrl", ipnUrl);
        requestBody.put("extraData", "");
        requestBody.put("requestType", "captureWallet");
        requestBody.put("signature", signature);
        requestBody.put("lang", "vi");

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Map> momoResponse = restTemplate.postForEntity(
                momoEndpoint, requestBody, Map.class);

        Map<String, Object> result = momoResponse.getBody();
        if (result == null || !result.containsKey("payUrl")) {
            throw new RuntimeException("Không nhận được payUrl từ MoMo");
        }

        // 3. Trả về Vue
        Map<String, Object> response = new HashMap<>();
        response.put("hoadonId", order.getIdHd());
        response.put("transactionId", transactionId);
        response.put("payUrl", result.get("payUrl"));
        return response;
    }

    private String hmacSHA256(String data, String key) throws Exception {
        Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
        SecretKeySpec secret_key = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        sha256_HMAC.init(secret_key);
        return HexFormat.of().formatHex(sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8)));
    }
    public boolean handleMomoIpn(Map<String, Object> callbackData) {
        String orderId = (String) callbackData.get("orderId");        // transactionId đã gửi
        String transId = String.valueOf(callbackData.get("transId")); // id giao dịch MoMo
        Integer resultCode = (Integer) callbackData.get("resultCode"); // 0 = thành công

        if (orderId == null || transId == null) {
            return false;
        }

        // Xác định trạng thái
        String status = (resultCode != null && resultCode == 0) ? "SUCCESS" : "FAILED";

        // Gọi procedure update trạng thái thanh toán
        jdbcTemplate.update(
            "UPDATE THANH_TOAN SET magiaodich = ?, trangthai = ? WHERE hoadon = ?",
            transId, status, orderId
        );

        return true;
    }

}
