package DATN.dto;

import lombok.Data;

@Data
public class MoMoPaymentRequestDTO {
    private String partnerCode;
    private String partnerName;
    private String storeId;
    private String requestId;
    private Long amount;
    private String orderId;
    private String orderInfo;
    private String redirectUrl;
    private String ipnUrl;
    private String lang;
    private String requestType;
    private String autoCapture;
    private String extraData;
    private String signature;
}
