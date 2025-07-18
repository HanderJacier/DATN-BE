package DATN.Data;

import lombok.Data;

@Data
public class OrderRequest {
    private String orderId;
    private String amount;
    private String orderInfo;
}