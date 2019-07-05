package com.databaseapp.controller;

import com.databaseapp.model.dto.UserPurchase;
import com.databaseapp.repository.UserPurchaseRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * REST API about {@link UserPurchase}.
 */
@RestController
public class DatabaseApi {

    @Autowired
    UserPurchaseRepository userPurchaseRepository;

    /**
     * Get a user.
     */
    @RequestMapping(value = "/api/userpurchase", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
    public String apiUser(@RequestParam(value = "uid", defaultValue = "999999") Integer uid) {
        final List<UserPurchase> userPurchaseList = userPurchaseRepository.findUserLogByUserId(uid);
        return objectToString(userPurchaseList);
    }

    /**
     * Json util.
     */
    private String objectToString(Object object) {
        final ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(object);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return "";
    }
}