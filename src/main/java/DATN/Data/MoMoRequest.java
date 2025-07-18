package DATN.Data;

import lombok.Data;

@Data
public class MoMoRequest {
    private String partnerCode;
    private String requestId;
    private String amount;
    private String orderId;
    private String orderInfo;
    private String redirectUrl;
    private String ipnUrl;
    private String requestType;
    private String extraData;
    private String signature;
}
