package com.practice.moviebooking.entity.schedule;


import com.practice.moviebooking.entity.core.BaseEntity;
import com.practice.moviebooking.entity.movie.Movie;
import com.practice.moviebooking.entity.theater.Theater;
import com.practice.moviebooking.entity.user.User;
import com.practice.moviebooking.utils.UUIDUtil;
import jakarta.persistence.*;
import lombok.*;

import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Entity
@Table(name = "Schedules")
@SuperBuilder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Schedule extends BaseEntity {
    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "movie_id", nullable = false)
    private Movie movie;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "theater_id", nullable = false)
    private Theater theater;

    @Column(name = "show_time", nullable = false)
    private LocalDateTime showTime;

    @Column(name = "available_seats", nullable = false)
    private Integer availableSeats;

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUIDUtil.generateId();
        }
    }
}
