package com.musclemate.server.service.impl;

import com.musclemate.server.entity.Followers;
import com.musclemate.server.entity.User;

import com.musclemate.server.repository.FollowedRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class FollowerServiceImpl {

    @Autowired
    private FollowedRepository repository;

    public void seguirUsuario(User follower, User followed) {
        Followers followers = new Followers();
        followers.setFollower(follower);
        followers.setFollowed(followed);
        repository.save(followers);
    }

    public void deixarDeSeguirUsuario(User follower, User followed) {
        Followers followers = repository.findByFollowerAndFollowed(follower, followed);
        repository.delete(followers);
    }

    public List<User> getSeguidores(User user) {
        List<User> followers = repository.findFollowerUsersByFollowed(user);
        List<User> followersWithIdAndName = new ArrayList<>();

        for (User follower : followers) {
            User followerWithIdAndName = new User();
            followerWithIdAndName.setId(follower.getId());
            followerWithIdAndName.setNome(follower.getNome());
            followersWithIdAndName.add(followerWithIdAndName);
        }

        return followersWithIdAndName;
    }

    public List<User> getSeguindo(User user) {
        List<User> followed = repository.findFollowedUsers(user);
        List<User> followedsWithIdAndName = new ArrayList<>();

        for (User followedUser : followed) {
            User followedWithIdAndName = new User();
            followedWithIdAndName.setId(followedUser.getId());
            followedWithIdAndName.setNome(followedUser.getNome());
            followedsWithIdAndName.add(followedWithIdAndName);
        }

        return followedsWithIdAndName;
    }

}
