package DATN.Data;
import lombok.Data;

@Data
public class MoMoResponse {
	private String requestId;
    private String orderId;
    private String amount;
    private String payUrl;
    private String qrCodeUrl; // Đảm bảo trường này tồn tại
    private String resultCode;
    private String message;
}	
    
