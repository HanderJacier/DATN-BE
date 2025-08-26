package com.example.DATN.entity;

import java.math.BigDecimal;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class OrderRequest {
    private Integer idHd;
    private CustomerInfo customerInfo;
    private BigDecimal finalAmount;
    private List<Item> items;

    @Data
    public static class CustomerInfo {
        private String name;
        private String phone;
        private String email;
        private String address;
        private Integer id_tk;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Item {
        private Integer id;
        private String name;
        private Integer quantity;
        private BigDecimal price;
    }
}
