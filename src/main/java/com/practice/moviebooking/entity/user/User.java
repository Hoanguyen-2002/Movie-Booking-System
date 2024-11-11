package com.practice.moviebooking.entity.user;

import com.practice.moviebooking.entity.core.BaseEntity;
import com.practice.moviebooking.enums.Role;
import com.practice.moviebooking.utils.UUIDUtil;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "Users")
@SuperBuilder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User extends BaseEntity {
    @Id
    @Column(length = 36)
    private String id;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(nullable = false, length = 255)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Role role;

    @Column(name = "is_verified", nullable = false)
    private Boolean isVerified;

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUIDUtil.generateId();
        }
    }
}
