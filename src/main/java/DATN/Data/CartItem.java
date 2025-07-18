package DATN.Data;


import lombok.Data;

@Data
public class CartItem {
    private String name;
    private String image;
    private String variant;
    private long price;
    private long originalPrice;
    private int quantity;
    private boolean selected;
}
