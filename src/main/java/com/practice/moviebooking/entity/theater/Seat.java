package com.practice.moviebooking.entity.theater;

import com.practice.moviebooking.entity.core.BaseEntity;
import com.practice.moviebooking.enums.Rating;
import com.practice.moviebooking.entity.movie.Movie;
import com.practice.moviebooking.entity.user.User;
import com.practice.moviebooking.utils.UUIDUtil;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "Reviews")
@SuperBuilder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Seat extends BaseEntity {
    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "movie_id", nullable = false)
    private Movie movie;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Rating rating;

    @Column(columnDefinition = "TEXT")
    private String comment;

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUIDUtil.generateId();
        }
    }
}
