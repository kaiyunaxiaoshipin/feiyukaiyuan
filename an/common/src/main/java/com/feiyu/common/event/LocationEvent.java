package com.feiyu.common.event;

/**
 * Created by cxf on 2018/7/18.
 */

public class LocationEvent {
    private double lng;
    private double lat;

    public LocationEvent(double lng, double lat) {
        this.lng = lng;
        this.lat = lat;
    }

    public double getLng() {
        return lng;
    }

    public double getLat() {
        return lat;
    }
}
