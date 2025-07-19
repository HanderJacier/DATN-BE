package DATN.service;

import DATN.dto.MoMoPaymentRequestDTO;
import DATN.dto.MoMoPaymentResponseDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class MoMoPaymentService {

    private final RestTemplate restTemplate = new RestTemplate();

    // MoMo Test Configuration - Sử dụng thông tin test chính thức
    private static final String PARTNER_CODE = "MOMO";
    private static final String ACCESS_KEY = "F8BBA842ECF85";
    private static final String SECRET_KEY = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    private static final String ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";
    private static final String RETURN_URL = "http://localhost:5173/payment-result";
    private static final String NOTIFY_URL = "http://localhost:8080/api/momo/notify";

    public MoMoPaymentResponseDTO createPayment(String orderId, Long amount, String orderInfo) {
        try {
            // Validate input
            if (orderId == null || orderId.trim().isEmpty()) {
                throw new IllegalArgumentException("OrderId không được để trống");
            }
            if (amount == null || amount <= 0) {
                throw new IllegalArgumentException("Số tiền không hợp lệ");
            }
            if (orderInfo == null || orderInfo.trim().isEmpty()) {
                orderInfo = "Thanh toán đơn hàng " + orderId;
            }

            String requestId = orderId;
            String extraData = "";
            String requestType = "payWithATM";
            String lang = "vi";
            String autoCapture = "true";

            // Tạo raw signature theo đúng thứ tự của MoMo
            String rawSignature = "accessKey=" + ACCESS_KEY +
                    "&amount=" + amount +
                    "&extraData=" + extraData +
                    "&ipnUrl=" + NOTIFY_URL +
                    "&orderId=" + orderId +
                    "&orderInfo=" + orderInfo +
                    "&partnerCode=" + PARTNER_CODE +
                    "&redirectUrl=" + RETURN_URL +
                    "&requestId=" + requestId +
                    "&requestType=" + requestType;

            System.out.println("🔐 Raw signature: " + rawSignature);

            // Generate signature
            String signature = generateHMACSHA256(rawSignature, SECRET_KEY);
            System.out.println("🔐 Generated signature: " + signature);

            // Create request body theo format MoMo yêu cầu
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("partnerCode", PARTNER_CODE);
            requestBody.put("partnerName", "Test");
            requestBody.put("storeId", "MomoTestStore");
            requestBody.put("requestId", requestId);
            requestBody.put("amount", amount);
            requestBody.put("orderId", orderId);
            requestBody.put("orderInfo", orderInfo);
            requestBody.put("redirectUrl", RETURN_URL);
            requestBody.put("ipnUrl", NOTIFY_URL);
            requestBody.put("lang", lang);
            requestBody.put("requestType", requestType);
            requestBody.put("autoCapture", autoCapture);
            requestBody.put("extraData", extraData);
            requestBody.put("signature", signature);

            System.out.println("📤 MoMo Request: " + requestBody);

            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // Make request
            ResponseEntity<MoMoPaymentResponseDTO> response = restTemplate.postForEntity(
                    ENDPOINT, entity, MoMoPaymentResponseDTO.class);

            MoMoPaymentResponseDTO responseBody = response.getBody();
            System.out.println("📥 MoMo Response: " + responseBody);

            if (responseBody != null) {
                System.out.println("📊 MoMo ResultCode: " + responseBody.getResultCode());
                System.out.println("📊 MoMo Message: " + responseBody.getMessage());
            }

            return responseBody;

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi tạo thanh toán MoMo: " + e.getMessage());
            e.printStackTrace();
            
            // Return error response instead of throwing exception
            MoMoPaymentResponseDTO errorResponse = new MoMoPaymentResponseDTO();
            errorResponse.setResultCode(99);
            errorResponse.setMessage("Lỗi kết nối MoMo: " + e.getMessage());
            return errorResponse;
        }
    }

    public boolean verifySignature(String signature, String rawData) {
        try {
            String expectedSignature = generateHMACSHA256(rawData, SECRET_KEY);
            return signature.equals(expectedSignature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String generateHMACSHA256(String data, String key) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi tạo signature: " + e.getMessage(), e);
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
}
