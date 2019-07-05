package com.databaseapp.repository;

import com.databaseapp.model.dto.UserPurchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * {@link UserPurchase} repository.
 */
public interface UserPurchaseRepository extends JpaRepository<UserPurchase, Integer> {

    @Query("select u from UserPurchase u where u.userId = :user_id")
    public List<UserPurchase> findUserLogByUserId(@Param("user_id") Integer userId);
}