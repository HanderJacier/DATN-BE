package com.example.DATN.repository;

import java.util.Map;

public class DynamicProcedureRequest {
    private Map<String, Object> params;

    public Map<String, Object> getParams() {
        return params;
    }

    public void setParams(Map<String, Object> params) {
        this.params = params;
    }
}
