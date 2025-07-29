package com.example.DATN.mapper;

import java.util.Map;

import com.example.DATN.entity.DynamicProcedureEntity;

public class DynamicProcedureMapper {
    public static DynamicProcedureEntity toEntity(Map<String, Object> row) {
        DynamicProcedureEntity entity = new DynamicProcedureEntity();
        entity.setFields(row);
        return entity;
    }
}
