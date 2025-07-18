package DATN.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import DATN.Data.MoMoResponse;
import DATN.Data.OrderRequest;
import DATN.service.MoMoService;

@RestController
@RequestMapping("/api/momo")
@RequiredArgsConstructor
public class MoMoController {

    private final MoMoService moMoService;

    @PostMapping("/create-payment")
    public MoMoResponse createPayment(@RequestBody OrderRequest orderRequest) throws Exception {
        return moMoService.createPayment(orderRequest.getOrderId(), orderRequest.getAmount(), orderRequest.getOrderInfo());
    }

    @GetMapping("/return")
    public String handleReturn(@RequestParam String orderId, @RequestParam String resultCode, @RequestParam String message) {
        // Xử lý kết quả trả về từ MoMo
        if ("0".equals(resultCode)) {
            return "Thanh toán thành công cho đơn hàng: " + orderId;
        } else {
            return "Thanh toán thất bại: " + message;
        }
    }

    @PostMapping("/notify")
    public void handleNotify(@RequestBody MoMoResponse response) {
        // Xử lý thông báo từ MoMo (IPN)
        if ("0".equals(response.getResultCode())) {
            // Lưu trạng thái thanh toán thành công vào database
            System.out.println("Thanh toán thành công: " + response.getOrderId());
        } else {
            // Xử lý lỗi
            System.out.println("Thanh toán thất bại: " + response.getMessage());
        }
    }
}
