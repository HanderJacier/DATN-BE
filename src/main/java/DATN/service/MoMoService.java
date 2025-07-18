package DATN.service;

import com.fasterxml.jackson.databind.ObjectMapper;

import DATN.Data.MoMoRequest;
import DATN.Data.MoMoResponse;
import lombok.RequiredArgsConstructor;
import org.apache.commons.codec.digest.HmacUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
public class MoMoService {

    @Value("${momo.partner-code}")
    private String partnerCode;

    @Value("${momo.access-key}")
    private String accessKey;

    @Value("${momo.secret-key}")
    private String secretKey;

    @Value("${momo.endpoint}")
    private String endpoint;

    @Value("${momo.return-url}")
    private String returnUrl;

    @Value("${momo.notify-url}")
    private String notifyUrl;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public MoMoResponse createPayment(String orderId, String amount, String orderInfo) throws Exception {
        MoMoRequest request = new MoMoRequest();
        request.setPartnerCode(partnerCode);
        request.setRequestId(orderId + "-" + System.currentTimeMillis());
        request.setAmount(amount);
        request.setOrderId(orderId);
        request.setOrderInfo(orderInfo);
        request.setRedirectUrl(returnUrl);
        request.setIpnUrl(notifyUrl);
        request.setRequestType("captureWallet");
        request.setExtraData("");

        // Tạo chữ ký (signature)
        String rawSignature = "accessKey=" + accessKey +
                "&amount=" + amount +
                "&extraData=" + request.getExtraData() +
                "&ipnUrl=" + notifyUrl +
                "&orderId=" + orderId +
                "&orderInfo=" + orderInfo +
                "&partnerCode=" + partnerCode +
                "&redirectUrl=" + returnUrl +
                "&requestId=" + request.getRequestId() +
                "&requestType=" + request.getRequestType();
        String signature = HmacUtils.hmacSha256Hex(secretKey, rawSignature);
        request.setSignature(signature);

        // Gọi API MoMo
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<MoMoRequest> entity = new HttpEntity<>(request, headers);
        String response = restTemplate.postForObject(endpoint, entity, String.class);

        // Parse response
        return objectMapper.readValue(response, MoMoResponse.class);
    }
}
