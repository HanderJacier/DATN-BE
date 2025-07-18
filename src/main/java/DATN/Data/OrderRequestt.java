package DATN.Data;

import java.util.List;



import lombok.Data;

@Data
public class OrderRequestt {
    private List<CartItem> cart;
    private String receiverName;
    private String phone;
    private String address;
    private boolean useEInvoice;
    private String paymentMethod;
    private long totalPrice;
}