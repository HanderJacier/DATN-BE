package com.example.DATN.util;

import java.io.IOException;
import java.util.Map;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class nulldata extends JsonSerializer<Map<String, Object>> {
    @Override
    public void serialize(Map<String, Object> value, JsonGenerator gen, SerializerProvider serializers)
            throws IOException {
        gen.writeStartObject();
        for (Map.Entry<String, Object> entry : value.entrySet()) {
            if (entry.getValue() != null) {
                gen.writeObjectField(entry.getKey(), entry.getValue());
            }
        }
        gen.writeEndObject();
    }
}
