package com.practice.moviebooking.entity.ticket;

import java.io.Serializable;
import java.util.Objects;

public class TicketDiscountId implements Serializable {
    private String ticket;
    private String discount;

    public TicketDiscountId() {}

    public TicketDiscountId(String ticket, String discount) {
        this.ticket = ticket;
        this.discount = discount;
    }

    // Getters and Setters

    // equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TicketDiscountId that = (TicketDiscountId) o;

        if (!Objects.equals(ticket, that.ticket)) return false;
        return Objects.equals(discount, that.discount);
    }

    @Override
    public int hashCode() {
        int result = ticket != null ? ticket.hashCode() : 0;
        result = 31 * result + (discount != null ? discount.hashCode() : 0);
        return result;
    }
}
