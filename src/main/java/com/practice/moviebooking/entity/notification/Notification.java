package com.practice.moviebooking.entity.notification;

import com.practice.moviebooking.entity.core.BaseEntity;
import com.practice.moviebooking.enums.NotificationType;
import com.practice.moviebooking.entity.user.User;
import com.practice.moviebooking.utils.UUIDUtil;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;
@Entity
@Table(name = "Notifications")
@SuperBuilder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Notification extends BaseEntity {
    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private NotificationType type;

    @Column(name = "is_read", nullable = false)
    private Boolean isRead;

    @PrePersist
    public void prePersist() {
        if (this.id == null) {
            this.id = UUIDUtil.generateId();
        }
    }
}
