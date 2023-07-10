package com.musclemate.server.repository;

import com.musclemate.server.entity.Followers;

import com.musclemate.server.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface FollowedRepository extends JpaRepository<Followers, Long> {

    Followers findByFollowerAndFollowed(User follower, User followed);

    @Query("SELECT f.follower FROM Followers f WHERE f.followed = :user")
    List<User> findFollowerUsersByFollowed(@Param("user") User user);


    void delete(Followers followers);
}




