package com.yandex.practicum.devops.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Objects;


@Document
@JsonIgnoreProperties(ignoreUnknown = true)
public class Report {
    @Id
    public String productId;
    public String PEPE;
    public String length;
    public Boolean wasDelecious;
    public String name;
    public String quantity;

    public Report() {
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getPEPE() {
        return PEPE;
    }

    public void setPEPE(String PEPE) {
        this.PEPE = PEPE;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    public Boolean getWasDelecious() {
        return wasDelecious;
    }

    public void setWasDelecious(Boolean wasDelecious) {
        this.wasDelecious = wasDelecious;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Report report = (Report) o;
        return Objects.equals(productId, report.productId) && Objects.equals(PEPE, report.PEPE) && Objects.equals(length, report.length) && Objects.equals(wasDelecious, report.wasDelecious) && Objects.equals(name, report.name) && Objects.equals(quantity, report.quantity);
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, PEPE, length, wasDelecious, name, quantity);
    }
}