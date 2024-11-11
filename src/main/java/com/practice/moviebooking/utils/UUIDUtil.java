package com.practice.moviebooking.utils;

import lombok.experimental.UtilityClass;

import java.util.UUID;

@UtilityClass
public class UUIDUtil {
    public String generateId() {
        return UUID.randomUUID().toString();
    }
}
