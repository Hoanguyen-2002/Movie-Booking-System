package com.practice.moviebooking.entity.movie;

import com.practice.moviebooking.entity.core.BaseEntity;
import com.practice.moviebooking.enums.Genre;
import com.practice.moviebooking.enums.Rating;
import com.practice.moviebooking.utils.UUIDUtil;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
@Entity
@Table(name = "Movies")
@SuperBuilder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Movie extends BaseEntity {
    @Id
    @Column(length = 36)
    private String id;

    @Column(nullable = false, length = 255)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private Genre genre;

    @Column
    private Integer duration; // Thời lượng tính bằng phút

    @Column(name = "release_date")
    private LocalDate releaseDate;

    @Column
    private Rating rating;

    @Column(name = "cover_image_url", length = 255)
    private String coverImageUrl;

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUIDUtil.generateId();
        }
    }
}
