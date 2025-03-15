package com.ziio.backend.controller;

import com.ziio.backend.domain.Locations;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import com.ziio.backend.common.BaseResponse;
import com.ziio.backend.common.ResultUtils;
import com.ziio.backend.service.LocationsService;

@RestController
@RequestMapping("/locations")
public class LocationController {

    @Autowired
    private LocationsService locationService;

    @GetMapping("/all")
    public BaseResponse<List<Locations>> getAllLocations() {
        List<Locations> locations = locationService.getAllLocations();
        return ResultUtils.success(locations);
    }
}